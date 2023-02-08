Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4068F6C5
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjBHSTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 13:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBHSTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 13:19:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18011113C7
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 10:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0FA6178B
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7343FC433D2;
        Wed,  8 Feb 2023 18:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675880360;
        bh=6KoBeMpeRHFeimH5d0ziYXzYBp1yUeV/0hV0eN2Wxyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qjh1vN3mKT0iPCq+xThdF1HLZpgWOw5GP4vdzmO6bRJ7aSatMSwkhFvvb4bZg5doD
         vpLq1v+rzaJRdQ2An0Vm1k4xWvT8QSW0EQgQf8BKyH8WfrP7136Xk8N40bJcl8QrrX
         mx3gYHqtfFMcNAKz0+HjICOgbgvnfabMgYXKTWWlJyk7xlohRzarr8qubU8tsc7DNp
         vCxCNYYtOJCXB1ya/s8vJtNwiF9fnCiQ4sVFLeYiqa5gCjsX2YZAiiJDP0NRFONGcq
         vyjZ7F37ftrL2DqY8GD/US9fF5g/FjtKnOFZnvEq/82wWaS5+KHiWXWH7xcsTJgIFW
         eq12Ci6e/DOFw==
Date:   Wed, 8 Feb 2023 18:19:14 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
Message-ID: <Y+PnorGskAAIsODw@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-20-andy.chiu@sifive.com>
 <Y9GZbVrZxEZAraVu@spud>
 <CABgGipW430Cs0OgYO94RqfwrBFJOPV3HeS24Rv3nHgr4yOVaPQ@mail.gmail.com>
 <Y9d8IBqXyep+PJTq@wendy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gyvV7XIdJDtwPXYD"
Content-Disposition: inline
In-Reply-To: <Y9d8IBqXyep+PJTq@wendy>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--gyvV7XIdJDtwPXYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

On Mon, Jan 30, 2023 at 08:13:20AM +0000, Conor Dooley wrote:
> On Mon, Jan 30, 2023 at 03:46:32PM +0800, Andy Chiu wrote:
> > On Thu, Jan 26, 2023 at 5:04 AM Conor Dooley <conor@kernel.org> wrote:
> > > Firstly, no-implicit-float is a CFLAG, so why add it to march?
> > I placed it in march because I thought we need the flag in vdso. And,
> > KBUILD_CFLAGS is not enough for vdso. However, I think we don't need
> > this flag in vdso since it is run in user space anyway.
> > > There is an existing patch on the list for enabling this flag, but I
> > > recall Palmer saying that it was not actually needed?
> > The flag is needed for clang builds to prevent auto-vectorization from
> > using V in the kernel code [1].
> >=20
> > > Palmer, do you remember why that was?
> > The discussion[2] suggested that we need this flag, IIUC. But somehow
> > the patch did make it into the tree.
>=20
> I know, in [1] I left an R-b as the patch seemed reasonable to me.
> Palmer mentioned some reason for not thinking it was actually needed but
> not on-list, so I was hoping he'd comment!

Palmer replied there today with his rationale & an expectation that we
do the same thing for vector as we did for float:
https://lore.kernel.org/linux-riscv/mhng-4c71ada6-003c-414f-9a74-efa3ccd285=
6b@palmer-ri-x1c9/T/#m366779709bbcf7672b5277b3bb27a7d6ce6c6115

>=20
> And I suppose, it never got any further attention as it isn't needed by
> any in-tree code?
>=20
> > [1]https://lore.kernel.org/all/CAOnJCULtT-y9vo6YhW7bW9XyKRdod-hvFfr02jH=
VamR_LcsKdA@mail.gmail.com/
> > [2]https://lore.kernel.org/all/20221216185012.2342675-1-abdulras@google=
=2Ecom/

Cheers,
Conor.


--gyvV7XIdJDtwPXYD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+PnogAKCRB4tDGHoIJi
0uJ7AQDYZ/e40tjcGorJ/ALeoRnKAUyci3t2IcqRT1xoAD16dgEA7cSgEiEZ6h6l
r1xFWeLAvcre2pZxf/YPY7NXXWrhzAQ=
=9EzO
-----END PGP SIGNATURE-----

--gyvV7XIdJDtwPXYD--
