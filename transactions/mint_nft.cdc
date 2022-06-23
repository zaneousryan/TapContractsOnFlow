///MAINTNET
//import FungibleToken from 0xf233dcee88fe0abe
//import NonFungibleToken from 0x1d7e57aa55817448
//import MetadataViews from 0x0de9e8845aa8b678
//import TapMyNFT from 0x0de9e8845aa8b678

///TESTNET
import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0xa46238203d51b316
import TapMyNFT from 0xa46238203d51b316

/// This script uses the NFTMinter resource to mint a new NFT
/// It must be run with the account that has the minter resource
/// stored in /storage/NFTMinter

transaction(
    recipient: Address,
    name: String,
    description: String,
    creatorId: String,
    creatorName: String,
    createdDateTime: String,
    location: String,
    thumbnail: String,
    cuts: [UFix64],
    royaltyDescriptions: [String],
    royaltyBeneficiaries: [Address] 
) {

    /// local variable for storing the minter reference
    let minter: &TapMyNFT.NFTMinter

    /// Reference to the receiver's collection
    let recipientCollectionRef: &{NonFungibleToken.CollectionPublic}

    /// Previous NFT ID before the transaction executes
    let mintingIDBefore: UInt64

    prepare(signer: AuthAccount) {
        self.mintingIDBefore = TapMyNFT.totalSupply
        // borrow a reference to the NFTMinter resource in storage
        self.minter = signer.borrow<&TapMyNFT.NFTMinter>(from: TapMyNFT.MinterStoragePath)
            ?? panic("Account does not store an object at the specified path")

        // Borrow the recipient's public NFT collection reference
        self.recipientCollectionRef = getAccount(recipient)
            .getCapability(TapMyNFT.CollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")
    }

    pre {
        cuts.length == royaltyDescriptions.length && cuts.length == royaltyBeneficiaries.length: "Array length should be equal for royalty related details"
    }

    execute {

        // Create the royalty details
        var count = 0
         var royalties: [MetadataViews.Royalty] = []
        // while royaltyBeneficiaries.length > count {
        //     let beneficiary = royaltyBeneficiaries[count]
        //     let beneficiaryCapability = getAccount(beneficiary)
        //     .getCapability<&{FungibleToken.Receiver}>(MetadataViews.getRoyaltyReceiverPublicPath())

        //     // Make sure the royalty capability is valid before minting the NFT
        //     if !beneficiaryCapability.check() { panic("Beneficiary capability is not valid!") }

        //     royalties.append(
        //         MetadataViews.Royalty(
        //             receiver: beneficiaryCapability,
        //             cut: cuts[count],
        //             description: royaltyDescriptions[count]
        //         )
        //     )
        //     count = count + 1
        // }



        // Mint the NFT and deposit it to the recipient's collection
        self.minter.mintNFT(
            recipient: self.recipientCollectionRef,
            name: name,
            description: description,
            creatorId: creatorId,
            creatorName: creatorName,
            createdDateTime: createdDateTime,
            location: location,
            thumbnail: thumbnail,
            royalties: royalties
        )
    }

    post {
        self.recipientCollectionRef.getIDs().contains(self.mintingIDBefore): "The next NFT ID should have been minted and delivered"
        TapMyNFT.totalSupply == self.mintingIDBefore + 1: "The total supply should have been increased by 1"
    }
}
 