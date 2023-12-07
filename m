Return-Path: <kvm+bounces-3855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A55D6808767
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 13:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E4052839BC
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC1639AF8;
	Thu,  7 Dec 2023 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="lWwdoA/9"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DB7CA;
	Thu,  7 Dec 2023 04:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701951158; x=1733487158;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HUdSIX8FoylL7nOf/wJzJkkU/Ybmn3rRb/4PMgZXUHU=;
  b=lWwdoA/9smlUWJM/gWPYauCfbklKRNhV81yDL6bMqrdrSO47xaqH7+z6
   /ib7YVjylOL17zEa30/cacwhKtR6uDg1Zg1yNzBYNTlnQPrhUqnYoRNP2
   hZYnTBBysrkmHxx7jo87tuq0tc6awMbgKzEHZ7YskPZN64KhggRM51VYu
   ouys+fTeRx7Yg+2j+DptJSUNuTN+2Us9PZqhwWLfdfwwd8+wo59LqLnUB
   Y07Kjh9KPnuHAorSy7Xn5lIpHzIw6V+rjHscopm3xu+4OorhGAEM/a92X
   bU+2cSWLKVCLf7fSA75DcYp2fsHkMQAbr20KgJL+hahsdC3W4DNEX2604
   Q==;
X-CSE-ConnectionGUID: qtDtQC/MR0SMM/C1i87NvA==
X-CSE-MsgGUID: s22SpVhHSQ68I8AV5gRHvg==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="asc'?scan'208";a="13245727"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Dec 2023 05:12:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 05:12:21 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Thu, 7 Dec 2023 05:12:18 -0700
Date: Thu, 7 Dec 2023 12:11:48 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Atish Patra <atishp@rivosinc.com>
CC: <linux-kernel@vger.kernel.org>, Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, Icenowy
 Zheng <uwu@icenowy.me>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>, Mark Rutland
	<mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
	<paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [RFC 3/9] RISC-V: Add FIRMWARE_READ_HI definition
Message-ID: <20231207-jailbreak-kinsman-7353788a9a40@wendy>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
 <20231205024310.1593100-4-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bcU5bmCaFN29LsCy"
Content-Disposition: inline
In-Reply-To: <20231205024310.1593100-4-atishp@rivosinc.com>

--bcU5bmCaFN29LsCy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 04, 2023 at 06:43:04PM -0800, Atish Patra wrote:
> SBI v2.0 added another function to SBI PMU extension to read
> the upper bits of a counter with width larger than XLEN.

This definition here is quite a lot less specific than that in 11/1 of
the spec. I don't think that really matters much in reality since we
only support exactly one XLEN where that is the case.

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

> Add the definition for that function.
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 0892f4421bc4..f3eeca79a02d 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -121,6 +121,7 @@ enum sbi_ext_pmu_fid {
>  	SBI_EXT_PMU_COUNTER_START,
>  	SBI_EXT_PMU_COUNTER_STOP,
>  	SBI_EXT_PMU_COUNTER_FW_READ,
> +	SBI_EXT_PMU_COUNTER_FW_READ_HI,
>  };
> =20
>  union sbi_pmu_ctr_info {
> --=20
> 2.34.1
>=20

--bcU5bmCaFN29LsCy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZXG2hAAKCRB4tDGHoIJi
0u82AQDwi9UWn/9J92nmBoN8G2OQGiug9IR7IXTBPPHlWTNSfAD/QYb6iHZA/FQG
jX9pKcuUfaQ3vFjOevTwuCQy563jmAo=
=tIJW
-----END PGP SIGNATURE-----

--bcU5bmCaFN29LsCy--

