Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2A6514F3
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 22:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiLSVcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 16:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiLSVc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 16:32:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE6EFAE6;
        Mon, 19 Dec 2022 13:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 58FA7CE10AF;
        Mon, 19 Dec 2022 21:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17666C433EF;
        Mon, 19 Dec 2022 21:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671485541;
        bh=oLY/hWa0BsSKVuey9p+rADWc2gkKEa942bf2hq1ehSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S1567cbCr+8VKeF8rr15yhcd757qttbUoi9vPPSH3xwVULQyVsY3lCKOkzZA0X3ri
         b7xUeWvzosshiz92VyUqtNF+T1kNXsmQ132Bh8oRVxf9QEIJVHNJVJfowP1p+Idrwj
         suuPnHFhbfRktNEi5OqzI8P8J1Iy9BjWYEI1JV5EnRd+KwK9HCNHt9LC75yVsfA9st
         xNgoFn1XokgNFeeeBFYDb9Vw00Dr3IWhvDUz6biFFkG8Fk5o44n4pWUBcpeMFi5NYA
         OJX2Gp26kMahJY5wvbA4n5RomPQwzHe6da4HVfTYaHFaofUhfsgLQPoLHn5yXNLZNq
         1QVcqmC8lzRdQ==
Date:   Mon, 19 Dec 2022 21:32:16 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Message-ID: <Y6DYYL1CGuiKMsY2@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <10190559.nUPlyArG6x@diego>
 <Y45LRu0Gvrurm5Rh@spud>
 <12207576.O9o76ZdvQC@diego>
 <Y49Zi2CNv8pZSAe5@xhacker>
 <Y49p82Iac/+iYQ+1@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CH6M3iiZKM+1TO/I"
Content-Disposition: inline
In-Reply-To: <Y49p82Iac/+iYQ+1@spud>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--CH6M3iiZKM+1TO/I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2022 at 04:12:35PM +0000, Conor Dooley wrote:
> On Tue, Dec 06, 2022 at 11:02:35PM +0800, Jisheng Zhang wrote:
>=20
> > > > Higher Powers here, but some sort of logical ordering would probabl=
y be
> > > > a good idea so as not to hold each other up?
> > > > The non-string bit of your series has been fairly well reviewed & w=
ould,
> > > > in theory, be mergeable once the tree re-opens? Timing aside, Jishe=
ng's
> > > > idea seems like a good one, no?
> >=20
> > IMHO, it will be better if Palmer can merge Heiko's alternative improve=
ments
> > into riscv-next once well reviewed and the window is reopen. Then Drew,
> > Prabhakar and I can rebase on that tree.
>=20
> Unless I missed something, we're saying the same thing in different ways
> :)

Hey Jisheng,
FYI I'm gonna mark this version of the patchset as "Changes Requested"
in patchwork. Palmer's said he'll apply Heiko's patchset that this
depends on once rc1 is out so I am expecting that you'll rebase on top
of that with the various comments fixed.
Thanks,
Conor.


--CH6M3iiZKM+1TO/I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY6DYYAAKCRB4tDGHoIJi
0hGXAPoCfrNQ91+zdzsVkiszxD3RNg9lL443e0NP61dSS19AFQEA0/W07PpVDPhb
RC3f0K1Rn59gl+cuhonv9fuRRPtRhQc=
=R5/T
-----END PGP SIGNATURE-----

--CH6M3iiZKM+1TO/I--
