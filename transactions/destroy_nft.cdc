///MAINTNET
//import NonFungibleToken from 0x1d7e57aa55817448
//import TapMyNFT from 0x0de9e8845aa8b678

///TESTNET
import NonFungibleToken from 0x631e88ae7f1d7c20
import TapMyNFT from 0xa46238203d51b316

/// This transaction withdraws an NFT from the signers collection and destroys it

transaction(id: UInt64) {

    /// Reference that will be used for the owner's collection
    let collectionRef: &TapMyNFT.Collection

    prepare(signer: AuthAccount) {

        // borrow a reference to the owner's collection
        self.collectionRef = signer.borrow<&TapMyNFT.Collection>(from: TapMyNFT.CollectionStoragePath)
            ?? panic("Account does not store an object at the specified path")

    }

    execute {

        // withdraw the NFT from the owner's collection
        let nft <- self.collectionRef.withdraw(withdrawID: id)

        destroy nft
    }

    post {
        !self.collectionRef.getIDs().contains(id): "The NFT with the specified ID should have been deleted"
    }
}
