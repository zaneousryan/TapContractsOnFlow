///MAINTNET
//import NonFungibleToken from 0x1d7e57aa55817448
//import TapMyNFT from 0x0de9e8845aa8b678
//import MetadataViews from 0x0de9e8845aa8b678

///TESTNET
import NonFungibleToken from 0x631e88ae7f1d7c20
import TapMyNFT from 0xa46238203d51b316
import MetadataViews from 0xa46238203d51b316

/// This transaction is what an account would run
/// to set itself up to receive NFTs. This function
/// uses views to know where to set up the collection
/// in storage and to create the empty collection.

transaction(address: Address, publicPath: PublicPath, id: UInt64) {

    prepare(signer: AuthAccount) {
        let collection = getAccount(address)
            .getCapability(publicPath)
            .borrow<&{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>()
            ?? panic("Could not borrow a reference to the collection")

        let resolver = collection.borrowViewResolver(id: id)!
        let nftCollectionView = resolver.resolveView(Type<MetadataViews.NFTCollectionData>())! as! MetadataViews.NFTCollectionData

        // Create a new empty collections
        let emptyCollection <- nftCollectionView.createEmptyCollection()

        // save it to the account
        signer.save(<-emptyCollection, to: nftCollectionView.storagePath)

        // create a public capability for the collection
        signer.link<&{NonFungibleToken.CollectionPublic, TapMyNFT.TapMyNFTCollectionPublic, MetadataViews.ResolverCollection}>(
            nftCollectionView.publicPath,
            target: nftCollectionView.storagePath
        )
    }
}
