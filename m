Return-Path: <kvm+bounces-3852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D3F808752
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 13:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D07AE1F223CB
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B7A39AEB;
	Thu,  7 Dec 2023 12:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="gXVqDHxA"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4C3AA;
	Thu,  7 Dec 2023 04:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701950734; x=1733486734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+vqAtDYB58+ilZDY2IzWBId3CBwPu+5+VxutobiukMs=;
  b=gXVqDHxAC3F0kgJ1e9l17h/8swN7yRsFnYFDsm1A0Od/+9d4GezhwSvU
   fCDvrTlmLHmmuNy92oIC983hN/8/MFfQo+IXbGGmRPbiPlpOL6qkttgb6
   ZzRaF1YjlmgWi0BQ9isbijNPTy8V2/MNHO2UmDF0TsYYTH6DMZJuQmaeI
   8CQCjGBEB6/HJLIyvi1TxXWK9fN9BRj5/BrT6mXm7Zcn1YJEYLCFisCiK
   AHdFIw6adCCOpACh9bTOG6fuSIqsUX4kI9LgMHTlaC4/AevChVzcKPOnH
   FFE0ircjxt4vHoXgwiBv/W7dsiLWIqrw7HJFFkF3B2CjK0i1NKOZvLaWE
   g==;
X-CSE-ConnectionGUID: mTzueT1QSG2gazajd18OtQ==
X-CSE-MsgGUID: N6fBXV3OSlSjijCehmi7zQ==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="asc'?scan'208";a="12928857"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Dec 2023 05:05:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 05:05:03 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Thu, 7 Dec 2023 05:05:00 -0700
Date: Thu, 7 Dec 2023 12:04:30 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Atish Patra <atishp@rivosinc.com>
CC: <linux-kernel@vger.kernel.org>, Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, Icenowy
 Zheng <uwu@icenowy.me>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>, Mark Rutland
	<mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
	<paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [RFC 1/9] RISC-V: Fix the typo in Scountovf CSR name
Message-ID: <20231207-attractor-undone-a3efe2e0bb4e@wendy>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
 <20231205024310.1593100-2-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="G7tPSZJn8UmPNl7v"
Content-Disposition: inline
In-Reply-To: <20231205024310.1593100-2-atishp@rivosinc.com>

--G7tPSZJn8UmPNl7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 04, 2023 at 06:43:02PM -0800, Atish Patra wrote:
> The counter overflow CSR name is "scountovf" not "sscountovf".
>=20
> Fix the csr name.
>=20
> Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
>=20
^^ No blank line here.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h         | 2 +-
>  arch/riscv/include/asm/errata_list.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 306a19a5509c..88cdc8a3e654 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -281,7 +281,7 @@
>  #define CSR_HPMCOUNTER30H	0xc9e
>  #define CSR_HPMCOUNTER31H	0xc9f
> =20
> -#define CSR_SSCOUNTOVF		0xda0
> +#define CSR_SCOUNTOVF		0xda0
> =20
>  #define CSR_SSTATUS		0x100
>  #define CSR_SIE			0x104
> diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/as=
m/errata_list.h
> index 83ed25e43553..7026fba12eeb 100644
> --- a/arch/riscv/include/asm/errata_list.h
> +++ b/arch/riscv/include/asm/errata_list.h
> @@ -152,7 +152,7 @@ asm volatile(ALTERNATIVE_2(						\
> =20
>  #define ALT_SBI_PMU_OVERFLOW(__ovl)					\
>  asm volatile(ALTERNATIVE(						\
> -	"csrr %0, " __stringify(CSR_SSCOUNTOVF),			\
> +	"csrr %0, " __stringify(CSR_SCOUNTOVF),				\
>  	"csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),		\
>  		THEAD_VENDOR_ID, ERRATA_THEAD_PMU,			\
>  		CONFIG_ERRATA_THEAD_PMU)				\
> --=20
> 2.34.1
>=20

--G7tPSZJn8UmPNl7v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZXG0zgAKCRB4tDGHoIJi
0nN2AQCvWU22TUz271qbF0f5QPpTAMxJ3xWOjAley3m+IaVk2AEAgKbSJBE5ydgt
c0kRj6UIA26wDaBYi2ihZnFJRMAJVw0=
=pO03
-----END PGP SIGNATURE-----

--G7tPSZJn8UmPNl7v--

