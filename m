Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A177B6A6220
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjB1WHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjB1WHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:07:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65BC2F7B0
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 14:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E9BFB80ECC
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 22:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC476C433D2;
        Tue, 28 Feb 2023 22:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677622064;
        bh=FApbKilY3GXJ4q89pXMD20d4s4g8bNIn5KjKszQhVjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQBWRFx7k93CR0cw9Cb6i3MAbh5DNDM7hP3Vyt8lDR084A4h0Tc8gH54eeddC7UVg
         sC3Ja57LIBCLkJidvWeJQbAIzGEgJ2cY8Z9n9RaH6OUTbaRz5gdwWPGvatLL+RgOoV
         yNk3tw+X7Z4M4DiQzDBKH13k9SAVJ34fdvoOpY6JQPEG5a8OGlr87seFs7ZjKBm7SN
         ZuzvzzRf8zcuI/1mYctq7zfv60nBRB6JiZB3F7ersDLGL6GIQnaUdxNUs6+UH+n8bH
         DS6JVaW7mZHp9UNlPncNZ83DwWcjjZBQ1tEgE3I2zxXExsyuB0tA0xlN5woTPH+DC5
         duv2VoUpDXiyQ==
Date:   Tue, 28 Feb 2023 22:07:38 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Dao Lu <daolu@rivosinc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>
Subject: Re: [PATCH -next v14 02/19] riscv: Extending cpufeature.c to detect
 V-extension
Message-ID: <Y/57KguRXH4H5zDd@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-3-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TTOC1DDLd5I06q+Z"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-3-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--TTOC1DDLd5I06q+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:01PM +0000, Andy Chiu wrote:
> From: Guo Ren <ren_guo@c-sky.com>
>=20
> Add V-extension into riscv_isa_ext_keys array and detect it with isa
> string parsing.
>=20
> Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Looks grand, and thanks for switching to IS_ENABLED().
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--TTOC1DDLd5I06q+Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/57KgAKCRB4tDGHoIJi
0qhbAQDvniHcdbGl6PEkgQ/Y+JTRcHbc8r6Qu04xT5YNTTRlOgD9EjJIwx8OCOwo
ghoz1TDN+aklvl21oLAoJhe8b1JR9gc=
=1fxM
-----END PGP SIGNATURE-----

--TTOC1DDLd5I06q+Z--
