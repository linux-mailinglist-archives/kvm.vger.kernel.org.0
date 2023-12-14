Return-Path: <kvm+bounces-4488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F53813062
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4307FB20A66
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48154CDF2;
	Thu, 14 Dec 2023 12:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="KgUHQ5Fi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C217F11B
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:42:09 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-28ad7a26f4aso2511857a91.0
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702557729; x=1703162529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yws50ylq1EjUkokTIkYOP2sTsutSEl10pAQ1LytLppw=;
        b=KgUHQ5FigzSTSXeBa5FBulKagCWsuMvWQ+tLOd/DRC1hUjqA5K8v8+1YUlcFjtaPYG
         yiMi0THxvA1xiaiuWy4u5DbOM+E377lnLtUNin7AzEfEycfQfrgXf26ao9orrMGQNbKT
         EbEX8iB2aZn64tZqfGJwGywlaUqG0V4ND0t4cJRa8Zz9qbiLw7BiqrR/hajaOBvrvFNN
         U8FAAbneY/s0HuqETgmAOh3ltBlDATN4wLsH9ieAO/h46ptU0MyhgvPpXTMUU8i1eT3a
         wnkmSdw1UWRM4UHCVeq7bI+vANP7tNBhrNK26X4aeig0c6uFUorYjDWwsJmfVZ3gfb+E
         FMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702557729; x=1703162529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yws50ylq1EjUkokTIkYOP2sTsutSEl10pAQ1LytLppw=;
        b=cmBD7/Rvajw9Mt/P6XyyqS8AgWbUPu5nAMB7z77Rfa+PYQpYovHA9xangBgxN1wyZD
         hqF4ClVXapdAs2euTZzAvYQWrBTkaAd/ntknB2E23hX2vBDSVJA5NkiRj9FpmPdb7tW/
         BHLoBrWTqWVJWhPpOJ8PdDTPYMuUlqN1Jcco98n08/15lQ2jonkDn4Fo09cYcMf8oy1p
         D2tXZAMj+DQPi72TPkjP1DtNw/dvPmqCRZf00fZRKnCFlPxqr3eDhFTYVU8IM+10mRFh
         l8nQlc7xc/jn/eH7wAYyLXgzcenjuwTomyVWVgLfeugdkMVt5EGQsJR2an5DmaN5c5Ce
         nl+A==
X-Gm-Message-State: AOJu0Yz+R4FCSIY/eNWNCC2bcsUzRcUYN8w+4gZYdZ4wp1Y9dX1uFefl
	ZOjZAyOGGL/a+koESmrwoVle+CNoFDc473+SKYUuMg==
X-Google-Smtp-Source: AGHT+IHGAsyuOZIB4sppc3GwRu4zHElev+uLaRnUeyYMhAuZzoyenRB6gyAOaSXUB4X/u3gleJnJa3pxzwY2EnvbCio=
X-Received: by 2002:a17:90a:c697:b0:28a:dfa6:f1d3 with SMTP id
 n23-20020a17090ac69700b0028adfa6f1d3mr2094943pjt.0.1702557729115; Thu, 14 Dec
 2023 04:42:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-10-atishp@rivosinc.com>
In-Reply-To: <20231205024310.1593100-10-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 18:11:57 +0530
Message-ID: <CAAhSdy24k0r7vS1MkuRkAZwu9vOM7nLz4z+_gUjQE7ppkSq15g@mail.gmail.com>
Subject: Re: [RFC 9/9] RISC-V: KVM: Support 64 bit firmware counters on RV32
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 8:13=E2=80=AFAM Atish Patra <atishp@rivosinc.com> wr=
ote:
>
> The SBI v2.0 introduced a fw_read_hi function to read 64 bit firmware
> counters for RV32 based systems.
>
> Add infrastructure to support that.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  6 ++++-
>  arch/riscv/kvm/vcpu_pmu.c             | 38 ++++++++++++++++++++++++++-
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |  7 +++++
>  3 files changed, 49 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/a=
sm/kvm_vcpu_pmu.h
> index 64c75acad6ba..dd655315e706 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -20,7 +20,7 @@ static_assert(RISCV_KVM_MAX_COUNTERS <=3D 64);
>
>  struct kvm_fw_event {
>         /* Current value of the event */
> -       unsigned long value;
> +       uint64_t value;
>
>         /* Event monitoring status */
>         bool started;
> @@ -91,6 +91,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *=
vcpu, unsigned long ctr_ba
>                                      struct kvm_vcpu_sbi_return *retdata)=
;
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cid=
x,
>                                 struct kvm_vcpu_sbi_return *retdata);
> +#if defined(CONFIG_32BIT)
> +int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned lo=
ng cidx,
> +                               struct kvm_vcpu_sbi_return *retdata);
> +#endif
>  void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned lo=
ng saddr_low,
>                                        unsigned long saddr_high, unsigned=
 long flags,
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 86c8e92f92d3..5b4a93647256 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -195,6 +195,28 @@ static int pmu_get_pmc_index(struct kvm_pmu *pmu, un=
signed long eidx,
>
>         return kvm_pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask=
);
>  }

Newline here.

> +#if defined(CONFIG_32BIT)

Just like other patches, let's use IS_ENABLED() here.

> +static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                             unsigned long *out_val)
> +{
> +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +       struct kvm_pmc *pmc;
> +       u64 enabled, running;
> +       int fevent_code;
> +
> +       pmc =3D &kvpmu->pmc[cidx];
> +
> +       if (pmc->cinfo.type !=3D SBI_PMU_CTR_TYPE_FW)
> +               return -EINVAL;
> +
> +       fevent_code =3D get_event_code(pmc->event_idx);
> +       pmc->counter_val =3D kvpmu->fw_event[fevent_code].value;
> +
> +       *out_val =3D pmc->counter_val >> 32;
> +
> +       return 0;
> +}
> +#endif
>
>  static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>                         unsigned long *out_val)
> @@ -696,6 +718,20 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu=
 *vcpu, unsigned long ctr_ba
>         return 0;
>  }
>
> +#if defined(CONFIG_32BIT)
> +int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned lo=
ng cidx,
> +                                  struct kvm_vcpu_sbi_return *retdata)
> +{
> +       int ret;
> +
> +       ret =3D pmu_fw_ctr_read_hi(vcpu, cidx, &retdata->out_val);
> +       if (ret =3D=3D -EINVAL)
> +               retdata->err_val =3D SBI_ERR_INVALID_PARAM;
> +
> +       return 0;
> +}
> +#endif
> +
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cid=
x,
>                                 struct kvm_vcpu_sbi_return *retdata)
>  {
> @@ -769,7 +805,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>                         pmc->cinfo.csr =3D CSR_CYCLE + i;
>                 } else {
>                         pmc->cinfo.type =3D SBI_PMU_CTR_TYPE_FW;
> -                       pmc->cinfo.width =3D BITS_PER_LONG - 1;
> +                       pmc->cinfo.width =3D 63;
>                 }
>         }
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.=
c
> index 77c20a61fd7d..0cd051d5a448 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -64,6 +64,13 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>         case SBI_EXT_PMU_COUNTER_FW_READ:
>                 ret =3D kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata=
);
>                 break;
> +       case SBI_EXT_PMU_COUNTER_FW_READ_HI:
> +#if defined(CONFIG_32BIT)

Same as above, use IS_ENABLED() here.

> +               ret =3D kvm_riscv_vcpu_pmu_fw_ctr_read_hi(vcpu, cp->a0, r=
etdata);
> +#else
> +               retdata->out_val =3D 0;
> +#endif
> +               break;
>         case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
>                 ret =3D kvm_riscv_vcpu_pmu_setup_snapshot(vcpu, cp->a0, c=
p->a1, cp->a2, retdata);
>                 break;
> --
> 2.34.1
>

Apart from minor nits above, this looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

