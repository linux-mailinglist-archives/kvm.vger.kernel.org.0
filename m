Return-Path: <kvm+bounces-15687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7848AF462
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DEB81C22566
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4671713D505;
	Tue, 23 Apr 2024 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uuR7RjmX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635641E898;
	Tue, 23 Apr 2024 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713890372; cv=none; b=JXqAyaywVxuhtg53vHFdl3ljE3px0h3gW8Cbwtq9iaN1Ig7gHzR7BTpM78R8UUCMaRMLdbXHJ8ZnflcSAug2mV+788MWIiTqB5klsHApbchNvuX6hqR/dxXcR6ml+oP7wpWLrJbqbpO0v/04pmmfDB6IZ1dt9AmmDEB0mQlx33o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713890372; c=relaxed/simple;
	bh=fD5RMgFE9IYTbhqS2tikK8r+BZHDSJNOiDPqXgfFmyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doaL8gaZVVQ74xmBOWejC4cz3u6jC4ylmqgFYEziT8Yj2j86pFVX8KF6Qe3LW5dCcKo8UD7e3DLs+w5KQ4Vz3JONCZ8WCxBEA82z4AUSnnKZ5nOyTCoSRyyqeTVP13BiZhUouwTShjEoztSadN14Q4EKSbsqh2uy4kDt961ihB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uuR7RjmX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254EEC2BD10;
	Tue, 23 Apr 2024 16:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713890371;
	bh=fD5RMgFE9IYTbhqS2tikK8r+BZHDSJNOiDPqXgfFmyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uuR7RjmXnnV7dwQMq1qJFthRAzaRTXxYy3JEg3KQvr4zzMi/JHojE2vmpSGNK7Uyl
	 DT4rXran619QVJV3xSMNgCgBDQvFDV7gSaRBFmhY1+tIwO8biddrF4IOEx3CuJz2CW
	 z6wzH1DMwSFVYHHUup+vkY2OLUkVJ9CKrdVEzPbvpFK/juJopAkhCbasv3v/B3Luey
	 noiZuTKVCTYtK1XEdRAqrW+ABr5CgxfI8a6QRs+9vMszwTB0mYRTcVNV2+OqRGHLkZ
	 RZM3t+XFJh2IKOOK62CfTY6iQB8EvGLJIQr2AqnKyfLUdaq4E2wiY5kCmeLTtwlViI
	 7nLiKrd2Pj6cw==
Date: Tue, 23 Apr 2024 17:39:27 +0100
From: Conor Dooley <conor@kernel.org>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [RFC PATCH 5/7] riscv: add double trap driver
Message-ID: <20240423-headsman-arrival-16a2d13342b2@spud>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="eBwmz41Uh9YWXnLI"
Content-Disposition: inline
In-Reply-To: <20240418142701.1493091-6-cleger@rivosinc.com>


--eBwmz41Uh9YWXnLI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 04:26:44PM +0200, Cl=E9ment L=E9ger wrote:
> Add a small driver to request double trap enabling as well as
> registering a SSE handler for double trap. This will also be used by KVM
> SBI FWFT extension support to detect if it is possible to enable double
> trap in VS-mode.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h    |  1 +
>  drivers/firmware/Kconfig        |  7 +++
>  drivers/firmware/Makefile       |  1 +
>  drivers/firmware/riscv_dbltrp.c | 95 +++++++++++++++++++++++++++++++++
>  include/linux/riscv_dbltrp.h    | 19 +++++++
>  5 files changed, 123 insertions(+)
>  create mode 100644 drivers/firmware/riscv_dbltrp.c
>  create mode 100644 include/linux/riscv_dbltrp.h
>=20
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 744aa1796c92..9cd4ca66487c 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -314,6 +314,7 @@ enum sbi_sse_attr_id {
>  #define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SPIE	(1 << 2)
> =20
>  #define SBI_SSE_EVENT_LOCAL_RAS		0x00000000
> +#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP	0x00000001
>  #define SBI_SSE_EVENT_GLOBAL_RAS	0x00008000
>  #define SBI_SSE_EVENT_LOCAL_PMU		0x00010000
>  #define SBI_SSE_EVENT_LOCAL_SOFTWARE	0xffff0000
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 59f611288807..a037f6e89942 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -197,6 +197,13 @@ config RISCV_SSE_TEST
>  	  Select if you want to enable SSE extension testing at boot time.
>  	  This will run a series of test which verifies SSE sanity.
> =20
> +config RISCV_DBLTRP
> +	bool "Enable Double trap handling"
> +	depends on RISCV_SSE && RISCV_SBI
> +	default n
> +	help
> +	  Select if you want to enable SSE double trap handler.
> +
>  config SYSFB
>  	bool
>  	select BOOT_VESA_SUPPORT
> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> index fb7b0c08c56d..ad67a1738c0f 100644
> --- a/drivers/firmware/Makefile
> +++ b/drivers/firmware/Makefile
> @@ -18,6 +18,7 @@ obj-$(CONFIG_RASPBERRYPI_FIRMWARE) +=3D raspberrypi.o
>  obj-$(CONFIG_FW_CFG_SYSFS)	+=3D qemu_fw_cfg.o
>  obj-$(CONFIG_RISCV_SSE)		+=3D riscv_sse.o
>  obj-$(CONFIG_RISCV_SSE_TEST)	+=3D riscv_sse_test.o
> +obj-$(CONFIG_RISCV_DBLTRP)	+=3D riscv_dbltrp.o

As previously mentioned, I'd like to see all of these riscv specific
things in a riscv directory.

>  obj-$(CONFIG_SYSFB)		+=3D sysfb.o
>  obj-$(CONFIG_SYSFB_SIMPLEFB)	+=3D sysfb_simplefb.o
>  obj-$(CONFIG_TI_SCI_PROTOCOL)	+=3D ti_sci.o
> diff --git a/drivers/firmware/riscv_dbltrp.c b/drivers/firmware/riscv_dbl=
trp.c
> new file mode 100644
> index 000000000000..72f9a067e87a
> --- /dev/null
> +++ b/drivers/firmware/riscv_dbltrp.c
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 Rivos Inc.
> + */
> +
> +#define pr_fmt(fmt) "riscv-dbltrp: " fmt
> +
> +#include <linux/cpu.h>
> +#include <linux/init.h>
> +#include <linux/riscv_dbltrp.h>
> +#include <linux/riscv_sse.h>
> +
> +#include <asm/sbi.h>
> +
> +static bool double_trap_enabled;
> +
> +static int riscv_sse_dbltrp_handle(uint32_t evt, void *arg,
> +				   struct pt_regs *regs)
> +{
> +	__show_regs(regs);
> +	panic("Double trap !\n");
> +
> +	return 0;
> +}
> +
> +struct cpu_dbltrp_data {
> +	int error;
> +};
> +
> +static void
> +sbi_cpu_enable_double_trap(void *data)

This should easily fit on one line.

> +{
> +	struct sbiret ret;
> +	struct cpu_dbltrp_data *cdd =3D data;
> +
> +	ret =3D sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
> +			SBI_FWFT_DOUBLE_TRAP_ENABLE, 1, 0, 0, 0, 0);
> +
> +	if (ret.error) {
> +		cdd->error =3D 1;

If this is a boolean, make it a boolean please. All the code in this
patch treats it as one.

> +		pr_err("Failed to enable double trap on cpu %d\n", smp_processor_id());
> +	}
> +}
> +
> +static int sbi_enable_double_trap(void)
> +{
> +	struct cpu_dbltrp_data cdd =3D {0};
> +
> +	on_each_cpu(sbi_cpu_enable_double_trap, &cdd, 1);
> +	if (cdd.error)
> +		return -1;

Can this be an errno please?

> +
> +	double_trap_enabled =3D true;
> +
> +	return 0;
> +}
> +
> +bool riscv_double_trap_enabled(void)
> +{
> +	return double_trap_enabled;
> +}
> +EXPORT_SYMBOL(riscv_double_trap_enabled);

Can we just use double_trap everywhere? dbltrp reads like sound that a
beatboxer would make and this looks a lot nicer than the other functions
in the file...

> +
> +static int __init riscv_dbltrp(void)

I think this function is missing an action work - init or probe?

> +{
> +	struct sse_event *evt;
> +
> +	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SSDBLTRP)) {
> +		pr_err("Ssdbltrp extension not available\n");
> +		return 1;
> +	}
> +
> +	if (!sbi_probe_extension(SBI_EXT_FWFT)) {
> +		pr_err("Can not enable double trap, SBI_EXT_FWFT is not available\n");
> +		return 1;
> +	}
> +
> +	if (sbi_enable_double_trap()) {
> +		pr_err("Failed to enable double trap on all cpus\n");
> +		return 1;

Why do we return 1s here, but an errno via PTR_ERR() below?
Shouldn't all of these be returning a negative errono?
This particular one should probably propagate the error it got from
sbi_enable_double_trap().

Cheers,
Conor.

> +	}
> +
> +	evt =3D sse_event_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, 0,
> +				 riscv_sse_dbltrp_handle, NULL);
> +	if (IS_ERR(evt)) {
> +		pr_err("SSE double trap register failed\n");
> +		return PTR_ERR(evt);
> +	}
> +
> +	sse_event_enable(evt);
> +	pr_info("Double trap handling registered\n");
> +
> +	return 0;
> +}
> +device_initcall(riscv_dbltrp);
> diff --git a/include/linux/riscv_dbltrp.h b/include/linux/riscv_dbltrp.h
> new file mode 100644
> index 000000000000..6de4f43fae6b
> --- /dev/null
> +++ b/include/linux/riscv_dbltrp.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 Rivos Inc.
> + */
> +
> +#ifndef __LINUX_RISCV_DBLTRP_H
> +#define __LINUX_RISCV_DBLTRP_H
> +
> +#if defined(CONFIG_RISCV_DBLTRP)
> +bool riscv_double_trap_enabled(void);
> +#else
> +
> +static inline bool riscv_double_trap_enabled(void)
> +{
> +	return false;
> +}
> +#endif
> +
> +#endif /* __LINUX_RISCV_DBLTRP_H */
> --=20
> 2.43.0
>=20

--eBwmz41Uh9YWXnLI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZifkPgAKCRB4tDGHoIJi
0veEAQCEMsQKaddsiHfFoNYh1yUhaTvMiAQRLZ5gWJnUVG44RgEAsdBPvXs6WM6q
F6tFelwPbvovDtQMFL4XBLmTu06pFgs=
=Rjup
-----END PGP SIGNATURE-----

--eBwmz41Uh9YWXnLI--

