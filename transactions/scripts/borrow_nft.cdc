///MAINTNET
//import NonFungibleToken from 0x1d7e57aa55817448
//import TapMyNFT from 0x0de9e8845aa8b678

///TESTNET
import NonFungibleToken from 0x631e88ae7f1d7c20
import TapMyNFT from 0xa46238203d51b316

// This script borrows an NFT from a collection
pub fun main(address: Address, id: UInt64) {
    let account = getAccount(address)

    let collectionRef = account
        .getCapability(TapMyNFT.CollectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    // Borrow a reference to a specific NFT in the collection
    let _ = collectionRef.borrowNFT(id: id)
}
