Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83276FCBD3
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 18:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbjEIQyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 12:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjEIQyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 12:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D5355AC
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 09:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEAE46124D
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 16:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D1EC433D2;
        Tue,  9 May 2023 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683651202;
        bh=vRIAzOifVTJF+NL+zPnob6GzLta4VkDeRxHaLY4fN94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c2WGJ/pCR/n86hfghAdWTdIjbCDFYlHyQ/7+SQ92/BVX/AZljbZub3QbsLJgoBV5O
         JLcPZnBBQzuQL8Rx7whJ15wNUe0XDNKfBsoUoCrJadKcM2OXUUiw+9CFqqsEKtuFhS
         Y27/tcsBeK5NY8D2Pswef2kKV9DxEP4ccMUyjHM8y+x7k+26OZkKMu1v+/M/4AOSNY
         sqemOSiebo+LmEoGNr8NLnUAAH1xmm5aVJveWktkb1XTm2VcA3HrhM6JR63ltk3sEr
         3M5oKwOOm/Sjo8qkXmofEdNfjPTVwO/NMNWgZfryqGNP3PNDSZlpvs5AXoX7lbECAk
         N3MNDM/KxvaDg==
Date:   Tue, 9 May 2023 17:53:17 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
Message-ID: <20230509-chitchat-elitism-bc4882a8ef8d@spud>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
 <20230509103033.11285-24-andy.chiu@sifive.com>
 <20230509-resilient-lagoon-265e851e5bf8@wendy>
 <CABgGipXvVw8GWeVLTuTJT9Hus-pEPUcgRhO3oovKYOAZK3fAEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="poLtL7+Byn1gs2Xr"
Content-Disposition: inline
In-Reply-To: <CABgGipXvVw8GWeVLTuTJT9Hus-pEPUcgRhO3oovKYOAZK3fAEg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--poLtL7+Byn1gs2Xr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 10, 2023 at 12:04:12AM +0800, Andy Chiu wrote:
> > > +config RISCV_V_DISABLE
> > > +     bool "Disable userspace Vector by default"
> > > +     depends on RISCV_ISA_V
> > > +     default n
> > > +     help
> > > +       Say Y here if you want to disable default enablement state of=
 Vector
> > > +       in u-mode. This way userspace has to make explicit prctl() ca=
ll to
> > > +       enable Vector, or enable it via sysctl interface.
> >
> > If we are worried about breaking userspace, why is the default for this
> > option not y? Or further,
> >
> > config RISCV_ISA_V_DEFAULT_ENABLE
> >         bool "Enable userspace Vector by default"
> >         depends on RISCV_ISA_V
> >         help
> >           Say Y here to allow use of Vector in userspace by default.
> >           Otherwise, userspace has to make an explicit prctl() call to
> >           enable Vector, or enable it via the sysctl interface.
> >
> >           If you don't know what to do here, say N.
> >
>=20
> Yes, expressing the option, where Y means "on", is more direct. But I
> have a little concern if we make the default as "off". Yes, we create
> this option in the worries of breaking userspace. But given that the
> break case might be rare, is it worth making userspace Vector harder
> to use by doing this? I assume in an ideal world that nothing would
> break and programs could just use V without bothering with prctl(), or
> sysctl. But on the other hand, to make a program robust enough, we
> must check the status with the prctl() anyway. So I have no answer
> here.

FWIW my logic was that those who know what they are doing can turn it on
& keep the pieces. I would expect distros and all that lark to be able to
make an educated decision here. But those that do not know what they are
doing should be given the "safe" option by default.
CONFIG_RISCV_ISA_V is default y, so will be enabled for those upgrading
their kernel. With your patch they would also get vector enabled by
default. The chance of a breakage might be small, but it seems easy to
avoid. I dunno...


--poLtL7+Byn1gs2Xr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFp6WAAKCRB4tDGHoIJi
0tbRAP92OqQTPhLZLqtifLjtmpk/XP/qCNCv1/2OEe0mjpWnsAD+JswXLM/3OV2q
7UgK5h39kaC/tJc2kq/HBsfBTh6YvwA=
=0eCT
-----END PGP SIGNATURE-----

--poLtL7+Byn1gs2Xr--
