///MAINTNET
//import NonFungibleToken from 0x1d7e57aa55817448
//import TapMyNFT from 0x0de9e8845aa8b678

///TESTNET
import NonFungibleToken from 0x631e88ae7f1d7c20
import TapMyNFT from 0xa46238203d51b316

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account
        .getCapability(TapMyNFT.CollectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")
    
    return collectionRef.getIDs().length
}

// "testnet-account": {
// 			"address": "0xa46238203d51b316",
// 			"key": "5f504c536364c433ea472df416e184789717d0affa6764c355c55b40c237c48b"
// 		},


		// "testnet-account": {
		// 	"address": "0x771e3bd4ddfcb230",
		// 	"key": "aceefbdf8590f6932b14efb5b033bc5917af7aaff2bf6fb25419b528d1ca703e"
		// },
		