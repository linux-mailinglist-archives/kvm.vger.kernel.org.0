Return-Path: <kvm+bounces-3857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E26C8087CC
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 13:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8480E1F224DD
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536753D0B5;
	Thu,  7 Dec 2023 12:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ABl8+A7M"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28FCD5E;
	Thu,  7 Dec 2023 04:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701952451; x=1733488451;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/29bWAHsyxsZQC0+CaHDpJbfrecN2Fa5js7gLIME0cg=;
  b=ABl8+A7MmkY2hBM2NJ3Nr6Ig74FO6+fdR3q7VdUwkueASYH5ewc/RuK0
   KEVlRgklx5OLb1gErZhh6zQXJacSdEP+0FGHJPsMENl7D7KKL757lqLK8
   0Auhg094TfheIaO43yDkgYJ6xcGrQeiS2Qlv5igqHAaM2RmloCQ9gDNbH
   rYM0l36gsbc511LXVfzTrDLEnOede/DAhgwcvDQNMXlbs/3i2/ZnxEFYj
   t0Qk5DA4KbfwZarmkCSgkXjDwTXJMms6dgsAqHND4xiHS379SlbK1BAGv
   DTCYXje5X+LXLaY/vD70vnQcd5oOgA9MsqIypMtTh6/x5yvjIVpczGjEA
   Q==;
X-CSE-ConnectionGUID: 5S5swfdoQfujZvrEN0fvmg==
X-CSE-MsgGUID: i1Q0FKZETvaelYNIfTFB6g==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="asc'?scan'208";a="12867992"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Dec 2023 05:34:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 05:33:54 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex02.mchp-main.com (10.10.85.144)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Thu, 7 Dec 2023 05:33:51 -0700
Date: Thu, 7 Dec 2023 12:33:21 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Atish Patra <atishp@rivosinc.com>
CC: <linux-kernel@vger.kernel.org>, Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, Icenowy
 Zheng <uwu@icenowy.me>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>, Mark Rutland
	<mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
	<paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [RFC 5/9] RISC-V: Add SBI PMU snapshot definitions
Message-ID: <20231207-unpleased-landlord-8383b4c50aca@wendy>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
 <20231205024310.1593100-6-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gTzysXj1uHqZjdds"
Content-Disposition: inline
In-Reply-To: <20231205024310.1593100-6-atishp@rivosinc.com>

--gTzysXj1uHqZjdds
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 04, 2023 at 06:43:06PM -0800, Atish Patra wrote:
> SBI PMU Snapshot function optimizes the number of traps to
> higher privilege mode by leveraging a shared memory between the S/VS-mode
> and the M/HS mode. Add the definitions for that extension
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index f3eeca79a02d..29821addb9b7 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -122,6 +122,7 @@ enum sbi_ext_pmu_fid {
>  	SBI_EXT_PMU_COUNTER_STOP,
>  	SBI_EXT_PMU_COUNTER_FW_READ,
>  	SBI_EXT_PMU_COUNTER_FW_READ_HI,
> +	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
>  };
> =20
>  union sbi_pmu_ctr_info {
> @@ -138,6 +139,13 @@ union sbi_pmu_ctr_info {
>  	};
>  };
> =20
> +/* Data structure to contain the pmu snapshot data */
> +struct riscv_pmu_snapshot_data {
> +	uint64_t ctr_overflow_mask;
> +	uint64_t ctr_values[64];
> +	uint64_t reserved[447];
> +};
> +
>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
>  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
> =20
> @@ -234,9 +242,11 @@ enum sbi_pmu_ctr_type {
> =20
>  /* Flags defined for counter start function */
>  #define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
> +#define SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT (1 << 1)
> =20
>  /* Flags defined for counter stop function */
>  #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
> +#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT (1 << 1)

If we can use GENMASK in this file, why can we not use BIT()?

> =20
>  enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE =3D 0,
> --=20
> 2.34.1
>=20

--gTzysXj1uHqZjdds
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZXG7kQAKCRB4tDGHoIJi
0u7BAP98g7gYr0WtICEW4nsKWIrQsLsY6Wc8mDmWrwFalMU4ogEAqbupqAr9KImF
qhjdmarFukSX4880Fs+uZ0l+0cWf5w0=
=abO+
-----END PGP SIGNATURE-----

--gTzysXj1uHqZjdds--

