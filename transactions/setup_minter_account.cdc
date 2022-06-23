///MAINTNET
//import NonFungibleToken from 0x1d7e57aa55817448
//import MetadataViews from 0x0de9e8845aa8b678
//import TapMyNFT from 0x0de9e8845aa8b678

///TESTNET
import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0xa46238203d51b316
import TapMyNFT from 0xa46238203d51b316

/// This transaction is what an account would run
/// to set itself up to receive NFTs

transaction {

    prepare(signer: AuthAccount) {
        // Return early if the account already has a collection
        if signer.borrow<&TapMyNFT.Collection>(from: TapMyNFT.MinterStoragePath) != nil {
            return
        }

        // Create a new empty collection
        let collection <- TapMyNFT.createEmptyMinterCollection()

        // save it to the account
        signer.save(<-collection, to: TapMyNFT.MinterStoragePath)

        // // create a public capability for the collection
        // signer.link<&{NonFungibleToken.CollectionPublic, TapMyNFT.TapMyNFTCollectionPublic, MetadataViews.ResolverCollection}>(
        //     TapMyNFT.CollectionPublicPath,
        //     target: TapMyNFT.CollectionStoragePath
        // )
    }
}
