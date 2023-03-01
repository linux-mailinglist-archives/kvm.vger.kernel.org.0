Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC006A742B
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 20:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCATVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 14:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCATVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 14:21:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22EA4AFCE
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 11:21:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6515E612FA
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 19:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD39C433D2;
        Wed,  1 Mar 2023 19:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677698494;
        bh=WBTBIUMKXFK23HBhf466NKgfhwM/1RJoj4OvR5ssJr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mVXMIER63OwIeXDglCri2kFRaWldxO1CDZNitGfSCpd1Ld5E0H4ZAAQdtijTzbrk1
         h/N5lVrtdAhSU1vyV3VhGbSy5F/91Kh15Am5bUvsTm5HJ/pCDnrsQF3GTKc4R2Go3l
         X0gCizMu0V3627yDCAmCdOaAZn5WN1T7bNNlgbym2m3NVZ/k5EguxZHnYtboPnTlCh
         P1Q2dYVXaziQYxhgz2rA/z9+oKdSdtDaf0/7MFxLWjCxZF6CLRtBX8p6ebwgYjaSVU
         3NPSgbb/eFF9KV5F9iQyhMd2pjrVm5Hf6oHOL3dLdxgqQb1bqHdbsV2NMEsc7w1EW6
         rqX18YJU3PpCQ==
Date:   Wed, 1 Mar 2023 19:21:27 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        Nick Knight <nick.knight@sifive.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Zong Li <zong.li@sifive.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH -next v14 14/19] riscv: signal: Report signal frame size
 to userspace via auxv
Message-ID: <b004ddc6-ec0f-4c7f-8201-df870bf0a86c@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-15-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D394b5UyBxRiFD12"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-15-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--D394b5UyBxRiFD12
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:13PM +0000, Andy Chiu wrote:
> From: Vincent Chen <vincent.chen@sifive.com>
>=20
> The vector register belongs to the signal context. They need to be stored
> and restored as entering and leaving the signal handler. According to the
> V-extension specification, the maximum length of the vector registers can
> be 2^(XLEN-1). Hence, if userspace refers to the MINSIGSTKSZ to create a
> sigframe, it may not be enough. To resolve this problem, this patch refers
> to the commit 94b07c1f8c39c
> ("arm64: signal: Report signal frame size to userspace via auxv") to enab=
le
> userspace to know the minimum required sigframe size through the auxiliary
> vector and use it to allocate enough memory for signal context.
>=20
> Note that auxv always reports size of the sigframe as if V exists for
> all starting processes, whenever the kernel has CONFIG_RISCV_ISA_V. The
> reason is that users usually reference this value to allocate an
> alternative signal stack, and the user may use V anytime. So the user
> must reserve a space for V-context in sigframe in case that the signal
> handler invokes after the kernel allocating V.
>=20
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--D394b5UyBxRiFD12
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+ltwAKCRB4tDGHoIJi
0vQ7AP0YSx4MnkgGVqWDk0+wp+vxnLj9imW9m5d8IMjgkIKecgEA6dhhbUlzkc4P
uRLPGfCn53oHACLzx9Goj7dgpnLcTgM=
=2iPH
-----END PGP SIGNATURE-----

--D394b5UyBxRiFD12--
