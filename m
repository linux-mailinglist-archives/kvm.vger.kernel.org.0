Return-Path: <kvm+bounces-5907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B77C828C8C
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 19:24:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 305BA1F29769
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 18:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFD13C48D;
	Tue,  9 Jan 2024 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMOsYWHp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDBC3C463;
	Tue,  9 Jan 2024 18:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DE7C433F1;
	Tue,  9 Jan 2024 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704824666;
	bh=YH4M2iq+dsTemyb3X8718ozap7wGWcbUkBH3kDOUFvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UMOsYWHpozaWSSGPj5W71OllGoVAA8fbDri9UCvDsttZDEheTgpxxudaF7LoSaY4D
	 PzOOG9Pjxwj0RjvDqQfaGZB69mN2zpJ0O8UEICciPzk88MPINNdvsN8NgP6vSpb5cT
	 qjTWz/FoE+/52wl7eU9dx+8VNLdPkwNNFjfv4YoTPJLoZsaFL8F/XyyKHv2j+rOa9a
	 TtbiePv0NDaVr74xVlXDapYknDMkviHKnU+FYuZYBUzFmmOV3PdHQoh3+N4EHP5zoT
	 XKCxzWBFbW+BlwBMp9JPKUnVzOHxf4iTaTPCnpvdKBfw+3nv/PS00kwlFWylZAlpRb
	 8HdksWcecgyIw==
Date: Tue, 9 Jan 2024 18:24:20 +0000
From: Conor Dooley <conor@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [v2 03/10] drivers/perf: riscv: Read upper bits of a firmware
 counter
Message-ID: <20240109-saddlebag-daylight-306f7eab1c1f@spud>
References: <20231229214950.4061381-1-atishp@rivosinc.com>
 <20231229214950.4061381-4-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hp43pEGkrkpwpLxJ"
Content-Disposition: inline
In-Reply-To: <20231229214950.4061381-4-atishp@rivosinc.com>


--hp43pEGkrkpwpLxJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2023 at 01:49:43PM -0800, Atish Patra wrote:
> SBI v2.0 introduced a explicit function to read the upper 32 bits
> for any firmwar counter width that is longer than 32bits.
> This is only applicable for RV32 where firmware counter can be
> 64 bit.
>=20
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 16acd4dcdb96..646604f8c0a5 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -35,6 +35,8 @@
>  PMU_FORMAT_ATTR(event, "config:0-47");
>  PMU_FORMAT_ATTR(firmware, "config:63");
> =20
> +static bool sbi_v2_available;
> +
>  static struct attribute *riscv_arch_formats_attr[] =3D {
>  	&format_attr_event.attr,
>  	&format_attr_firmware.attr,
> @@ -488,16 +490,23 @@ static u64 pmu_sbi_ctr_read(struct perf_event *even=
t)
>  	struct hw_perf_event *hwc =3D &event->hw;
>  	int idx =3D hwc->idx;
>  	struct sbiret ret;
> -	union sbi_pmu_ctr_info info;
>  	u64 val =3D 0;
> +	union sbi_pmu_ctr_info info =3D pmu_ctr_list[idx];
> =20
>  	if (pmu_sbi_is_fw_event(event)) {
>  		ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
>  				hwc->idx, 0, 0, 0, 0, 0);
> -		if (!ret.error)
> -			val =3D ret.value;
> +		if (ret.error)
> +			return val;

A nit perhaps, but can you just make this return 0 please? I think it
makes the code more obvious in its intent.

Otherwise I think you've satisfied the issues that I had with the
previous iteration:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

> +
> +		val =3D ret.value;
> +		if (IS_ENABLED(CONFIG_32BIT) && sbi_v2_available && info.width >=3D 32=
) {
> +			ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI,
> +					hwc->idx, 0, 0, 0, 0, 0);
> +			if (!ret.error)
> +				val |=3D ((u64)ret.value << 32);
> +		}
>  	} else {
> -		info =3D pmu_ctr_list[idx];
>  		val =3D riscv_pmu_ctr_read_csr(info.csr);
>  		if (IS_ENABLED(CONFIG_32BIT))
>  			val =3D ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
> @@ -1108,6 +1117,9 @@ static int __init pmu_sbi_devinit(void)
>  		return 0;
>  	}
> =20
> +	if (sbi_spec_version >=3D sbi_mk_version(2, 0))
> +		sbi_v2_available =3D true;
> +
>  	ret =3D cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
>  				      "perf/riscv/pmu:starting",
>  				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);
> --=20
> 2.34.1
>=20

--hp43pEGkrkpwpLxJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZZ2PVAAKCRB4tDGHoIJi
0lgIAP4y9URWADEjBFdKYjZhtBZVo75g7Yg78LJJtKqUKfqYzwEA+GssPUjOp7ib
coGIu9cWotZmHHa2TkJCe40qLfau4As=
=uhMP
-----END PGP SIGNATURE-----

--hp43pEGkrkpwpLxJ--

