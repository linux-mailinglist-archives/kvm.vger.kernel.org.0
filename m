Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A686FC67E
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 14:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbjEIMfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 08:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbjEIMfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 08:35:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4065F40F1
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 05:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683635701; x=1715171701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IGW4MUyXwLnRAJqCcL3gpIXRjeYwxHcdIWMyXJUWta4=;
  b=zmRMNKu4KbX/q7qOWM/8B3JlFM/yHlIcdaB+sPVOCfmPYjgTORhOCW73
   1vctK7zLPlzUz6xdFw5oSeu0RqhMu0lEdSdaijF3JTRS7tuQ+d4pff5p6
   IbeiNfgnlEClDuH7l8TyVaPfOonlgfdWMlduth17QcaZVP8a6bmqYnC5e
   QHs8s3CDyijcFMv8wUWISJPaRCZQFIVWQXf2Sup+49HLa/s02jhXLOVyc
   qTSfm2xltqc/9XAb/rP7bNX7RXrcZZ0w68+OWkXRkCiAvQfdF9k5D4+HC
   rFbhECDew68kVtqdSy7+5XD/8h72MFfzND7W/w+8vclbtlScXGZAlESi8
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,262,1677567600"; 
   d="asc'?scan'208";a="213086078"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 05:34:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 05:34:53 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 9 May 2023 05:34:51 -0700
Date:   Tue, 9 May 2023 13:34:31 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
Message-ID: <20230509-resilient-lagoon-265e851e5bf8@wendy>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
 <20230509103033.11285-24-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hmFU81Al1OkqyRgj"
Content-Disposition: inline
In-Reply-To: <20230509103033.11285-24-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--hmFU81Al1OkqyRgj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

On Tue, May 09, 2023 at 10:30:32AM +0000, Andy Chiu wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
>=20
> This patch adds a config which enables vector feature from the kernel
> space.

This commit message probably needs to change, it's not exactly doing
that anymore!

> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>

> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Suggested-by: Atish Patra <atishp@atishpatra.org>

And I suspect that these two are also likely inaccurate at this point,
but IDC.

> Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
> Changelog V19:
>  - Add RISCV_V_DISABLE to set compile-time default.
>=20
>  arch/riscv/Kconfig  | 31 +++++++++++++++++++++++++++++++
>  arch/riscv/Makefile |  6 +++++-
>  2 files changed, 36 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 1019b519d590..fa256f2e23c1 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -466,6 +466,37 @@ config RISCV_ISA_SVPBMT
> =20
>  	   If you don't know what to do here, say Y.
> =20
> +config TOOLCHAIN_HAS_V
> +	bool
> +	default y
> +	depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64iv)
> +	depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32iv)
> +	depends on LLD_VERSION >=3D 140000 || LD_VERSION >=3D 23800
> +	depends on AS_HAS_OPTION_ARCH
> +
> +config RISCV_ISA_V
> +	bool "VECTOR extension support"
> +	depends on TOOLCHAIN_HAS_V
> +	depends on FPU
> +	select DYNAMIC_SIGFRAME
> +	default y
> +	help
> +	  Say N here if you want to disable all vector related procedure
> +	  in the kernel.
> +
> +	  If you don't know what to do here, say Y.
> +
> +config RISCV_V_DISABLE
> +	bool "Disable userspace Vector by default"
> +	depends on RISCV_ISA_V
> +	default n
> +	help
> +	  Say Y here if you want to disable default enablement state of Vector
> +	  in u-mode. This way userspace has to make explicit prctl() call to
> +	  enable Vector, or enable it via sysctl interface.

If we are worried about breaking userspace, why is the default for this
option not y? Or further,

config RISCV_ISA_V_DEFAULT_ENABLE
	bool "Enable userspace Vector by default"
	depends on RISCV_ISA_V
	help
	  Say Y here to allow use of Vector in userspace by default.
	  Otherwise, userspace has to make an explicit prctl() call to
	  enable Vector, or enable it via the sysctl interface.

	  If you don't know what to do here, say N.

Thanks,
Conor.

--hmFU81Al1OkqyRgj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFo91wAKCRB4tDGHoIJi
0irBAQDZLK/emZnHozYTMzlCfcn1KDeyYeKp6hc160uDpKl3wAEAp5PAZqH7QZv8
PIFHgeMttfCqIXDkQLNsnWfqqPjqdgw=
=mTan
-----END PGP SIGNATURE-----

--hmFU81Al1OkqyRgj--
