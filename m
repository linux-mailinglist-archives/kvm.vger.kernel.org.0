Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249256434C6
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbiLETw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiLETwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:52:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6662C66D;
        Mon,  5 Dec 2022 11:49:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3886161307;
        Mon,  5 Dec 2022 19:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3429FC433D6;
        Mon,  5 Dec 2022 19:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670269771;
        bh=gpqDWSWbXSjKg40I3kv9dGH01C0Fe67Bhy3F34jRTBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c4HnnmhP1SKtWfDiRy4ddvgwR2Fv32UwFEwm+R7CK+6FV5Y9LSMFvXXoy/Nj8NpuG
         YhJL9kfEgliu6fQs/UkH1fcFE7TmBDHtjTifD37ok/u4P3aVJlaLVslXDMUI8B8hbM
         +t/3sBllwFNE3yEkzZ3zRJY2/DeytO8EDf3Y3fvhp0PHuuciEpldmCnmuODU8BLQwz
         p9Nzmk79TKOU0bFtADERPr0KYEeqY5LCBWENqG4N9WYNuNKGO5xZKn9f3VlMqX0YGb
         xaxh9jrOJv6Sa+H2jmssKdOcGDLTRmR/PqTRiDv1SqXJIiXK58miEph0Jy2jZqbyv+
         VGtyk1PfQJ4vw==
Date:   Mon, 5 Dec 2022 19:49:26 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Message-ID: <Y45LRu0Gvrurm5Rh@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <Y44Q/B6THtP38eyL@xhacker>
 <Y446PdlUPGw5iB71@spud>
 <10190559.nUPlyArG6x@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0eq6YNiH5eo8OX+V"
Content-Disposition: inline
In-Reply-To: <10190559.nUPlyArG6x@diego>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0eq6YNiH5eo8OX+V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 07:49:01PM +0100, Heiko St=FCbner wrote:
> Am Montag, 5. Dezember 2022, 19:36:45 CET schrieb Conor Dooley:
> > Heiko, Jisheng,
> > On Mon, Dec 05, 2022 at 11:40:44PM +0800, Jisheng Zhang wrote:
> > > Yesterday, I also wanted to unify the two instruction fix into
> > > one. But that would need to roll back the
> > > riscv_alternative_fix_auipc_jalr() to your v1 version. And IMHO,
> > > it's better if you can split the Zbb string optimizations series
> > > into two: one for alternative improvements, another for Zbb. Then
> > > we may get the alternative improvements and this inst extension
> > > series merged in v6.2-rc1.
> >=20
> > Heiko, perhaps you can correct me here:
> >=20
> > Last Wednesday you & Palmer agreed that it was too late in the cycle to
> > apply any of the stuff touching alternatives?
> > If I do recall correctly, gives plenty of time to sort out any
> > interdependent changes here.
> >=20
> > Could easily be misremembering, wouldn't be the first time!
>=20
> You slightly misremembered, but are still correct with the above ;-) .
>=20
> I.e. what we talked about was stuff for fixes for 6.1-rc, were Palmers
> wisely wanted to limit additions to really easy fixes for the remaining
> last rc, to not upset any existing boards.

Ahh right. I was 50-50 on whether something like that was said so at
least I am not going crazy.

> But you are still correct that we also shouldn't target the 6.2 merge win=
dow
> anymore :-) .
>=20
> We're after -rc8 now (which is in itself uncommon) and in his -rc7
> announcement [0], Linus stated
>=20
> "[...] the usual rule is that things that I get sent for the
> merge window should have been all ready _before_ the merge window
> opened. But with the merge window happening largely during the holiday
> season, I'll just be enforcing that pretty strictly."

Yah, of all the windows to land patchsets that are being re-spun a few
days before it opens this probably isn't the best one to pick!

> That means new stuff should be reviewed and in linux-next _way before_ the
> merge window opens next weekend. Taking into account that people need
> to review stuff (and maybe the series needing another round), I really do=
n't
> see this happening this week and everything else will get us shouted at
> from atop a christmas tree ;-) .
>=20
> That's the reason most maintainer-trees stop accepting stuff after -rc7

Aye, in RISC-V land maybe we will get there one day :)

For the original question though, breaking them up into 3 or 4 smaller
bits that could get applied on their own is probably a good idea?

Between yourselves, Drew and Prabhakar there's a couple series touching
the same bits. Certainly don't want to seem like I am speaking for the
Higher Powers here, but some sort of logical ordering would probably be
a good idea so as not to hold each other up?
The non-string bit of your series has been fairly well reviewed & would,
in theory, be mergeable once the tree re-opens? Timing aside, Jisheng's
idea seems like a good one, no?


--0eq6YNiH5eo8OX+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY45LRgAKCRB4tDGHoIJi
0h/yAPoClGkccfHN0If2EOKH3NZmBJCUaoEgyf+E45t3FZ0FRgD+MTXdEYEJhPHI
1popxrLDGDwBWadBaE4lr/cv8t7ZVwE=
=JYwo
-----END PGP SIGNATURE-----

--0eq6YNiH5eo8OX+V--
