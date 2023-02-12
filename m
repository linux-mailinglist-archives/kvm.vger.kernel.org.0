Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2066938FA
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 18:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjBLRGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 12:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBLRGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 12:06:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4F0EFA3;
        Sun, 12 Feb 2023 09:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5CD2B80D26;
        Sun, 12 Feb 2023 17:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD2DC433D2;
        Sun, 12 Feb 2023 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676221574;
        bh=xp+pefU+YHy43K0Cj/XKFLXgNVyRDAe45y8OPXjYd98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V0QrHsaoukwZplXnOXNUul981zsJ5R9VZid8ANCLlsXoEt2GZ4UA7+X4gFPFhOzkD
         hxURisohnPmmTxRednradbcOxxqYYfhSdejp06G+6U3UHASgRDAMVbjdkCqIhDvaef
         dptZCfppcYzMVv6nXLRj3soqyH3CAB+WFqbr1pDvyQLrKlsxxngkfHyXYnqyVNA8Y7
         ILGEfLPaBvPLQNyK/nXlVaiLmhbCeIZ1bkD6dBfv683pu3K/igqXwkA/FAd6Qf4JHT
         tD2F4bkQh8MwXcRbQyheXMYguE9yU/sFUyCgCTi8igc9yfKcvJ9jFeiAr3HudyEycd
         IITgQL3rFCPvw==
Date:   Sun, 12 Feb 2023 17:06:09 +0000
From:   Conor Dooley <conor@kernel.org>
To:     conor@kernel.org
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
Message-ID: <Y+kcgcncQO/2DNLo@spud>
References: <20230128172856.3814-1-jszhang@kernel.org>
 <20230212154333.GA3760469@roeck-us.net>
 <Y+kM//nuDv29Z9qJ@spud>
 <Y+kU9nDBTttZRLLq@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h6c3DYobJqr9hTJK"
Content-Disposition: inline
In-Reply-To: <Y+kU9nDBTttZRLLq@spud>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--h6c3DYobJqr9hTJK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2023 at 04:33:58PM +0000, Conor Dooley wrote:
> On Sun, Feb 12, 2023 at 03:59:59PM +0000, Conor Dooley wrote:

So as not to lead anyone up the garden path, let me correct myself:

> Hmm, so this appears to be us attempting to patch in alternatives where
> none actually exists - seemingly F & D.

And of course that's not true, riscv_has_extension_likely() now uses
alternatives as of:
bdda5d554e43 ("riscv: introduce riscv_has_extension_[un]likely()")

=46rom a quick look, it just happens that the only users are F & D.


--h6c3DYobJqr9hTJK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+kcgAAKCRB4tDGHoIJi
0haHAP47irJdLd+BYtO2693Gm0LwdwLkixyoiVtbaWgoOWK1kAEAr5pMmLqKw2+T
l5ybCzYN+j3mUvmfex8RQuDNBnBj3gY=
=SyUl
-----END PGP SIGNATURE-----

--h6c3DYobJqr9hTJK--
