Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703026FD07E
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 23:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjEIVGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 17:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjEIVGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 17:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BA718C
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 14:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F3760FD2
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 21:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC50C433D2;
        Tue,  9 May 2023 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683666379;
        bh=7sYfkgLry7WC/8Y8/DOxEpFS/0wr5s2HgaHfNmzpg14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b2NEeO4ZctXLGfGPwVLHFvMw0sCKX4CRVkYWea3neCy9F7UZGMVLS8AWcdSgQl60y
         N2FuFtpQmDTHlpaXsYqVKexAHl8GP6Py2VSqDldNaEnDvUMhMsDzkHOYTlfa2hsMW8
         +egWxGk0jU0NFGn4R16vXjjuBdN447cg2kl7PgdBt4LYtOky7rLf0ZbySQgbnMzEls
         gw3mSehQE9c7K3oAibhjHmcIy8Ja5xC03/Vc2aYuwj/07qK8wfCVJ5ZN40IicUPL3z
         Qf88zXhyl7Q1J3znWUXlLltp4IvETxfKtF0qEedZJXbXIJ9C1+r5oPgbfkmiHqUO8M
         2zXjGa4pWhaPQ==
Date:   Tue, 9 May 2023 22:06:14 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     andy.chiu@sifive.com, Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu
Subject: Re: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
Message-ID: <20230509-mayday-remold-a4421af1f9e1@spud>
References: <20230509-chitchat-elitism-bc4882a8ef8d@spud>
 <mhng-8554b236-c9d4-4590-8941-ed7ca5316d18@palmer-ri-x1c9a>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6CxUoqN6izL3gIto"
Content-Disposition: inline
In-Reply-To: <mhng-8554b236-c9d4-4590-8941-ed7ca5316d18@palmer-ri-x1c9a>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6CxUoqN6izL3gIto
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2023 at 01:59:33PM -0700, Palmer Dabbelt wrote:
> On Tue, 09 May 2023 09:53:17 PDT (-0700), Conor Dooley wrote:
> > On Wed, May 10, 2023 at 12:04:12AM +0800, Andy Chiu wrote:
> > > > > +config RISCV_V_DISABLE
> > > > > +     bool "Disable userspace Vector by default"
> > > > > +     depends on RISCV_ISA_V
> > > > > +     default n
> > > > > +     help
> > > > > +       Say Y here if you want to disable default enablement stat=
e of Vector
> > > > > +       in u-mode. This way userspace has to make explicit prctl(=
) call to
> > > > > +       enable Vector, or enable it via sysctl interface.
> > > >
> > > > If we are worried about breaking userspace, why is the default for =
this
> > > > option not y? Or further,
> > > >
> > > > config RISCV_ISA_V_DEFAULT_ENABLE
> > > >         bool "Enable userspace Vector by default"
> > > >         depends on RISCV_ISA_V
> > > >         help
> > > >           Say Y here to allow use of Vector in userspace by default.
> > > >           Otherwise, userspace has to make an explicit prctl() call=
 to
> > > >           enable Vector, or enable it via the sysctl interface.
> > > >
> > > >           If you don't know what to do here, say N.
> > > >
> > >=20
> > > Yes, expressing the option, where Y means "on", is more direct. But I
> > > have a little concern if we make the default as "off". Yes, we create
> > > this option in the worries of breaking userspace. But given that the
> > > break case might be rare, is it worth making userspace Vector harder
> > > to use by doing this? I assume in an ideal world that nothing would
> > > break and programs could just use V without bothering with prctl(), or
> > > sysctl. But on the other hand, to make a program robust enough, we
> > > must check the status with the prctl() anyway. So I have no answer
> > > here.
> >=20
> > FWIW my logic was that those who know what they are doing can turn it on
> > & keep the pieces. I would expect distros and all that lark to be able =
to
> > make an educated decision here. But those that do not know what they are
> > doing should be given the "safe" option by default.
> > CONFIG_RISCV_ISA_V is default y, so will be enabled for those upgrading
> > their kernel. With your patch they would also get vector enabled by
> > default. The chance of a breakage might be small, but it seems easy to
> > avoid. I dunno...
>=20
> It's really more of a distro/user question than anything else, I'm not
> really sure there's a right answer.  I'd lean towards turning V on by
> default, though: the defconfigs are meant for kernel hackers, so defaulti=
ng
> to the option that's more likely to break something seems like the way to=
 go
> -- that way we see any possible breakages early and can go figure them ou=
t.

To get my "ackchyually" out of the way, I meant the person doing `make
olddefconfig` based on their distro's .config etc or using menuconfig
rather than someone using the in-kernel defconfig.
We can always set it to the potentially breaking mode explicitly in our
defconfigs while leaving the defaults for the aforementioned situations
as the "safe" option, no?

> Depending on the risk tolerance of their users, distributions might want =
to
> turn this off by default.  I posted on sw-dev, which is generally the best
> way to find the distro folks.

--6CxUoqN6izL3gIto
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFq1xgAKCRB4tDGHoIJi
0onDAP4iMNMAEyDHEcVWCAxQH1cpSuxmaOfKw42e48Bn+vxW0QD/SBshmaA7DYck
7Cmq5TAKkVMA+lRlsp6nZgJfdQoNqwM=
=bIbJ
-----END PGP SIGNATURE-----

--6CxUoqN6izL3gIto--
