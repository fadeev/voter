package voter

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/fadeev/voter/x/voter/types"
	"github.com/tendermint/tendermint/crypto"
)

func handleMsgCreatePoll(ctx sdk.Context, k Keeper, msg MsgCreatePoll) (*sdk.Result, error) {
	var poll = types.Poll{
		Creator: msg.Creator,
		ID:      msg.ID,
		Title:   msg.Title,
		Options: msg.Options,
	}
	moduleAcct := sdk.AccAddress(crypto.AddressHash([]byte(types.ModuleName)))
	payment, _ := sdk.ParseCoins("200token")
	if err := k.CoinKeeper.SendCoins(ctx, poll.Creator, moduleAcct, payment); err != nil {
		return nil, err
	}
	k.CreatePoll(ctx, poll)

	return &sdk.Result{Events: ctx.EventManager().Events()}, nil
}
