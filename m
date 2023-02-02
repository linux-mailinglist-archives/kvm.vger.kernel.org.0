Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D56876C5
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 08:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjBBHxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 02:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjBBHxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 02:53:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1995CA0A;
        Wed,  1 Feb 2023 23:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675324386; x=1706860386;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p/zYRQXtmX1Ll4pA6xfxwM9O0U6tjnwz5o+IJ7OH76E=;
  b=GJQbP9ezCSlN9ED/wk5MYQhX2q5eObbUizf62i3QxmFtqIZF/idrUDPi
   eYkbDLTn1GHussXRNpRpYsTJtMgAfOOyW/JqwkiFua1d5eY61f4HLxcXZ
   u9nWzaDZ4qsfLbgixxQASOTwBFqIp3safaH7WySDXGJT70H/Et3cO4pcL
   4kRKUfBq0m/AHCygbKS0zyiljumRxBlQtZYFu5XGhWEWd9LtYDCpZ2vyx
   WKE8OFHf2G1xN0JRBYKjq8f0iMvHyCQkLOnIST34541KCiGJnx9k43HxY
   aCGF/1BJaHJYk4sFn8IjaFZ7edaGtwu/DRfJ0gywAr820orAB6GtuobO1
   A==;
X-IronPort-AV: E=Sophos;i="5.97,266,1669100400"; 
   d="asc'?scan'208";a="198575674"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 00:53:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 00:53:04 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 2 Feb 2023 00:53:02 -0700
Date:   Thu, 2 Feb 2023 07:52:37 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Atish Patra <atishp@rivosinc.com>
CC:     <linux-kernel@vger.kernel.org>, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 08/14] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <Y9trxX9hj6/pi1b1@wendy>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-9-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O/gnr0SEjao1pV0b"
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-9-atishp@rivosinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--O/gnr0SEjao1pV0b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Atish,

On Wed, Feb 01, 2023 at 03:12:44PM -0800, Atish Patra wrote:
> SBI PMU extension allows KVM guests to configure/start/stop/query about
> the PMU counters in virtualized enviornment as well.
>=20
> In order to allow that, KVM implements the entire SBI PMU extension.
>=20
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Could complaints from CI for you:

+      1 ../arch/riscv/kvm/vcpu_sbi_pmu.c:73:15: warning: no previous proto=
type for 'kvm_sbi_ext_pmu_probe' [-Wmissing-prototypes]
+      1 ../arch/riscv/kvm/vcpu_sbi_pmu.c:73:15: warning: symbol 'kvm_sbi_e=
xt_pmu_probe' was not declared. Should it be static?
+      1 ../arch/riscv/kvm/vcpu_sbi_pmu.c:80:37: warning: symbol 'vcpu_sbi_=
ext_pmu' was not declared. Should it be static?

Thanks,
Conor.

> ---
>  arch/riscv/kvm/Makefile       |  2 +-
>  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c | 85 +++++++++++++++++++++++++++++++++++
>  3 files changed, 97 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
>=20
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 5de1053..278e97c 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,4 +25,4 @@ kvm-y +=3D vcpu_sbi_base.o
>  kvm-y +=3D vcpu_sbi_replace.o
>  kvm-y +=3D vcpu_sbi_hsm.o
>  kvm-y +=3D vcpu_timer.o
> -kvm-$(CONFIG_RISCV_PMU_SBI) +=3D vcpu_pmu.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) +=3D vcpu_pmu.o vcpu_sbi_pmu.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index fe2897e..15fde15 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -20,6 +20,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ex=
t_v01 =3D {
>  };
>  #endif
> =20
> +#ifdef CONFIG_RISCV_PMU_SBI
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> +#else
> +static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu =3D {
> +	.extid_start =3D -1UL,
> +	.extid_end =3D -1UL,
> +	.handler =3D NULL,
> +};
> +#endif
> +
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] =3D {
>  	&vcpu_sbi_ext_v01,
>  	&vcpu_sbi_ext_base,
> @@ -28,6 +38,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] =
=3D {
>  	&vcpu_sbi_ext_rfence,
>  	&vcpu_sbi_ext_srst,
>  	&vcpu_sbi_ext_hsm,
> +	&vcpu_sbi_ext_pmu,
>  	&vcpu_sbi_ext_experimental,
>  	&vcpu_sbi_ext_vendor,
>  };
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> new file mode 100644
> index 0000000..e028b0a
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +#include <asm/sbi.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +
> +static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run=
 *run,
> +				   struct kvm_vcpu_sbi_return *retdata)
> +{
> +	int ret =3D 0;
> +	struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> +	struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +	unsigned long funcid =3D cp->a6;
> +	uint64_t temp;
> +
> +	/* Return not supported if PMU is not initialized */
> +	if (!kvpmu->init_done)
> +		return -EINVAL;
> +
> +	switch (funcid) {
> +	case SBI_EXT_PMU_NUM_COUNTERS:
> +		ret =3D kvm_riscv_vcpu_pmu_num_ctrs(vcpu, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_GET_INFO:
> +		ret =3D kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> +#if defined(CONFIG_32BIT)
> +		temp =3D ((uint64_t)cp->a5 << 32) | cp->a4;
> +#else
> +		temp =3D cp->a4;
> +#endif
> +		/*
> +		 * This can fail if perf core framework fails to create an event.
> +		 * Forward the error to the user space because its an error happened
> +		 * within host kernel. The other option would be convert this to
> +		 * an SBI error and forward to the guest.
> +		 */
> +		ret =3D kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> +						       cp->a2, cp->a3, temp, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_START:
> +#if defined(CONFIG_32BIT)
> +		temp =3D ((uint64_t)cp->a4 << 32) | cp->a3;
> +#else
> +		temp =3D cp->a3;
> +#endif
> +		ret =3D kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> +						   temp, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_STOP:
> +		ret =3D kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, retd=
ata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_FW_READ:
> +		ret =3D kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
> +		break;
> +	default:
> +		retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
> +	}
> +
> +	return ret;
> +}
> +
> +unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +
> +	return kvpmu->init_done;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu =3D {
> +	.extid_start =3D SBI_EXT_PMU,
> +	.extid_end =3D SBI_EXT_PMU,
> +	.handler =3D kvm_sbi_ext_pmu_handler,
> +	.probe =3D kvm_sbi_ext_pmu_probe,
> +};
> --=20
> 2.25.1
>=20
>=20

--O/gnr0SEjao1pV0b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9trtwAKCRB4tDGHoIJi
0r9wAQCU2XfX8lMA7q7V3L+bs2Eqe7Zxk1taHg1wI55aDI6a+gD7BHNfxb8G8yn3
DDFv78dpbG9wXOitf7rHFPZJD8mq0wo=
=cGWs
-----END PGP SIGNATURE-----

--O/gnr0SEjao1pV0b--
