Return-Path: <kvm+bounces-5339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 248E28203FF
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 09:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C47AB2119F
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 08:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5131C2584;
	Sat, 30 Dec 2023 08:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="SWbnYKeE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2B423A5
	for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 08:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-35fd902c6b5so59907415ab.3
        for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 00:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1703923830; x=1704528630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yiNrSH9oUjINY/vtkmdArFK8GmKKmu32NZyqnMgcK1w=;
        b=SWbnYKeEQgImfiXRdKfjLr17q3Ih3+w1K9rEy2kvHK6ESKTDS6sz/SBGDyQ1o3ek2X
         22Visn/sb/E9nK4NtWHJ7pufyiMXfCEHyHAuIr0zuSlHNh8U1v7CRko/zRCtl9tW2Smq
         dtaP5i/xU1pjP2x75A/UO2n5oXTVKdcpIUxL/xsVotPNgA5CGWW4DfL+0AwTLgs6ogPd
         KSLqbbG5Q0uhwp9UqQk4x+32vQ+AI7AGO0CfmCZGE777OKyqAh/Wu1vtBnF+kT5R9Odd
         RVqSgbq/PZJagDFCv2g79ETWvLRM6PRlwOWzX9T112HrchgizNANi2tRf0dv4QE2lSj+
         UceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703923830; x=1704528630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yiNrSH9oUjINY/vtkmdArFK8GmKKmu32NZyqnMgcK1w=;
        b=k3QKSWH0l5dvjJIwOD52SaJQ3OaOkFDjZCAP3cX1FWUOmtZxsfskM0rU1pIc5jHhyv
         fO/k5jIhZw/3UJCieZIBKwTpXvgvReJ0eOsKDMZ91VDolmd+Ne9ZB8DMjl/KY6dq6pHI
         GVggxq+Qh0ig514v4g2V/+AgR/mvWtzyXSmBtMc3cFpYpnHZuh9L24g1L+u7LwVWFhmW
         RlI58dSULIvnwDmXq0Zuk/TzRjFb2ZgdWQrLvqHo+X5ATgdp00IiuGYBC11Tjh+mlsXZ
         dkemhdrtDRSRlCnIi+ZNaNydvri9v5VMJDehIi2xycNWMVFke/c9Jp+fmC9+RWM0gNaH
         nx8Q==
X-Gm-Message-State: AOJu0Yy7dhAl92iAoz2yam8gNlW+LIKaHSzGjWkJhA6KgFkqV+nHw2SW
	yYTutMPUkYe+P2TTEAJMckQFTZnkJbIWLfSVCo5fmCvAlfDEGA==
X-Google-Smtp-Source: AGHT+IEhY4D0sK9xFLORpCAS+I82gFLXEGeS2aN1Vp0qGYmEIOgWrqL0REUG0dfNSg0lCV7PZGEUmGb8+bNLhldBe68=
X-Received: by 2002:a05:6e02:2408:b0:35d:5995:7992 with SMTP id
 bs8-20020a056e02240800b0035d59957992mr23726864ilb.44.1703923830374; Sat, 30
 Dec 2023 00:10:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229214950.4061381-1-atishp@rivosinc.com> <20231229214950.4061381-11-atishp@rivosinc.com>
In-Reply-To: <20231229214950.4061381-11-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Sat, 30 Dec 2023 13:40:20 +0530
Message-ID: <CAAhSdy03BLQRdTZAqteK9PsbjxQt7cncXu_fG1CG99uQK5v6CA@mail.gmail.com>
Subject: Re: [v2 10/10] RISC-V: KVM: Support 64 bit firmware counters on RV32
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 3:20=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> The SBI v2.0 introduced a fw_read_hi function to read 64 bit firmware
> counters for RV32 based systems.
>
> Add infrastructure to support that.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  4 ++-
>  arch/riscv/kvm/vcpu_pmu.c             | 37 ++++++++++++++++++++++++++-
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |  6 +++++
>  3 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/a=
sm/kvm_vcpu_pmu.h
> index af6d0ff5ce41..463c349a9ea5 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -20,7 +20,7 @@ static_assert(RISCV_KVM_MAX_COUNTERS <=3D 64);
>
>  struct kvm_fw_event {
>         /* Current value of the event */
> -       unsigned long value;
> +       u64 value;
>
>         /* Event monitoring status */
>         bool started;
> @@ -91,6 +91,8 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *v=
cpu, unsigned long ctr_ba
>                                      struct kvm_vcpu_sbi_return *retdata)=
;
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cid=
x,
>                                 struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned lo=
ng cidx,
> +                                     struct kvm_vcpu_sbi_return *retdata=
);
>  void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned lo=
ng saddr_low,
>                                       unsigned long saddr_high, unsigned =
long flags,
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index f2bf5b5bdd61..e6ce37819ca2 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -196,6 +196,29 @@ static int pmu_get_pmc_index(struct kvm_pmu *pmu, un=
signed long eidx,
>         return kvm_pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask=
);
>  }
>
> +static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                             unsigned long *out_val)
> +{
> +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +       struct kvm_pmc *pmc;
> +       int fevent_code;
> +
> +       if (!IS_ENABLED(CONFIG_32BIT))
> +               return -EINVAL;
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
> +
>  static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>                         unsigned long *out_val)
>  {
> @@ -701,6 +724,18 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu=
 *vcpu, unsigned long ctr_ba
>         return 0;
>  }
>
> +int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned lo=
ng cidx,
> +                                     struct kvm_vcpu_sbi_return *retdata=
)
> +{
> +       int ret;
> +
> +       ret =3D pmu_fw_ctr_read_hi(vcpu, cidx, &retdata->out_val);
> +       if (ret =3D=3D -EINVAL)
> +               retdata->err_val =3D SBI_ERR_INVALID_PARAM;
> +
> +       return 0;
> +}
> +
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cid=
x,
>                                 struct kvm_vcpu_sbi_return *retdata)
>  {
> @@ -774,7 +809,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
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
> index 9f61136e4bb1..58a0e5587e2a 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -64,6 +64,12 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>         case SBI_EXT_PMU_COUNTER_FW_READ:
>                 ret =3D kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata=
);
>                 break;
> +       case SBI_EXT_PMU_COUNTER_FW_READ_HI:
> +               if (IS_ENABLED(CONFIG_32BIT))
> +                       ret =3D kvm_riscv_vcpu_pmu_fw_ctr_read_hi(vcpu, c=
p->a0, retdata);
> +               else
> +                       retdata->out_val =3D 0;
> +               break;
>         case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
>                 ret =3D kvm_riscv_vcpu_pmu_setup_snapshot(vcpu, cp->a0, c=
p->a1, cp->a2, retdata);
>                 break;
> --
> 2.34.1
>

