Return-Path: <kvm+bounces-4501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02B34813206
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 14:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 265BA1C21A97
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CFD57882;
	Thu, 14 Dec 2023 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="UFXu7+M+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE5133
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 05:46:26 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-28659348677so502811a91.0
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 05:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702561586; x=1703166386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqsCj1Pji2dMXUzssOKL24PMHOKuScY5OxCjdcWMM24=;
        b=UFXu7+M+Eq1D+oaf+zUY8mV+/C+TESUsNJaIW6gKzPAa6caplb1pDkuhBSrsCc4OCM
         2ToeS9i94/xASfJE54MWHDvWVwWqFqNQA3rm+cKJ4bxCCB/AQx9Z70RCZJwukj44erBL
         Aoz82WtyiZKgWV2yVewI60m76Ny32/n7EQdzD46Gqp3wPp32QZQER00BYcWitSAEDUG2
         nqbxkxtvBVoqRpEvEel1dWFRQ8D5AjekLg3QKnWuCQUZNfYmcBbQFe88/68qQaWdjvn5
         SBoq1piqAPmI3ayLbwiAMYb33NEuhms2DVhtdAKFHf7mol1nsQMaglPl576nYD3eyZ1y
         Mrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702561586; x=1703166386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eqsCj1Pji2dMXUzssOKL24PMHOKuScY5OxCjdcWMM24=;
        b=opBxXZmF/IKMB5I0Qnxl0dUPXrCKSgcXUNtG3Z56DywRRDpQstNEmtS6zPou4WsJ1z
         v4oy1MCkoNWtss4DfzB0Nf0SksKXEsgwheucIy1d6Gs6wvqsy9tRB3AhsJ76qy8/8V/2
         r3JvC7iOiTbR7FLvtc8Al4x050BoxIeyQnx3RK940m82ReHt2aKDXAuM7cxU0HVOZ8Zr
         DrlXf7FH1AD/B+HmyMNI2MSG2TY1WYyxR+REpfYeIuoiSe90H3wi2o1VZNlYRs5vDWLg
         cs02ssVhd8JK4ULL2SLFH1jNJxCPy6Ye+bQOg7KwryrTgEngVdEwvoKR11sGgtfxips0
         nITg==
X-Gm-Message-State: AOJu0YzjlHsRZQfFflcxIF84lC3KY6Okk7UDPsyXoue68WFnXlSh/vo/
	0Iacea91h+mwXd8KqTtpOszXXtIRUm1CNiDtxDNSnQ==
X-Google-Smtp-Source: AGHT+IGeny43qUFIe4BpX45oxi28cgFjsCAPznUNG/JAF7tIIG9tJABsAEjZn2TVlKcm9A/tD8jvLIRTHsDpI1pXtS4=
X-Received: by 2002:a17:90a:ad7:b0:28b:1451:f789 with SMTP id
 r23-20020a17090a0ad700b0028b1451f789mr594645pje.14.1702561585831; Thu, 14 Dec
 2023 05:46:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-8-atishp@rivosinc.com>
In-Reply-To: <20231205024310.1593100-8-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 19:16:13 +0530
Message-ID: <CAAhSdy3cqeHg0HSE2qAZ3n4854xkhgZVjZa9hW0PD2NU9is4uA@mail.gmail.com>
Subject: Re: [RFC 7/9] RISC-V: KVM: Implement SBI PMU Snapshot feature
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
> PMU Snapshot function allows to minimize the number of traps when the
> guest access configures/access the hpmcounters. If the snapshot feature
> is enabled, the hypervisor updates the shared memory with counter
> data and state of overflown counters. The guest can just read the
> shared memory instead of trap & emulate done by the hypervisor.
>
> This patch doesn't implement the counter overflow yet.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  10 ++
>  arch/riscv/kvm/vcpu_pmu.c             | 129 ++++++++++++++++++++++++--
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
>  3 files changed, 134 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/a=
sm/kvm_vcpu_pmu.h
> index 395518a1664e..64c75acad6ba 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -36,6 +36,7 @@ struct kvm_pmc {
>         bool started;
>         /* Monitoring event ID */
>         unsigned long event_idx;
> +       struct kvm_vcpu *vcpu;

Where is this used ?

>  };
>
>  /* PMU data structure per vcpu */
> @@ -50,6 +51,12 @@ struct kvm_pmu {
>         bool init_done;
>         /* Bit map of all the virtual counter used */
>         DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> +       /* Bit map of all the virtual counter overflown */
> +       DECLARE_BITMAP(pmc_overflown, RISCV_KVM_MAX_COUNTERS);
> +       /* The address of the counter snapshot area (guest physical addre=
ss) */
> +       unsigned long snapshot_addr;
> +       /* The actual data of the snapshot */
> +       struct riscv_pmu_snapshot_data *sdata;
>  };
>
>  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
> @@ -85,6 +92,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *v=
cpu, unsigned long ctr_ba
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cid=
x,
>                                 struct kvm_vcpu_sbi_return *retdata);
>  void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned lo=
ng saddr_low,
> +                                      unsigned long saddr_high, unsigned=
 long flags,
> +                                      struct kvm_vcpu_sbi_return *retdat=
a);
>  void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 86391a5061dd..622c4ee89e7b 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -310,6 +310,79 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcp=
u, unsigned int csr_num,
>         return ret;
>  }
>
> +static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +       int snapshot_area_size =3D sizeof(struct riscv_pmu_snapshot_data)=
;
> +
> +       if (kvpmu->sdata) {
> +               memset(kvpmu->sdata, 0, snapshot_area_size);
> +               if (kvpmu->snapshot_addr !=3D INVALID_GPA)
> +                       kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr,
> +                                            kvpmu->sdata, snapshot_area_=
size);

We should free the "kvpmu->sdata" and set it to NULL. This way subsequent
re-enabling of snapshot won't leak the kernel memory.

> +       }
> +       kvpmu->snapshot_addr =3D INVALID_GPA;
> +}
> +
> +int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned lo=
ng saddr_low,
> +                                     unsigned long saddr_high, unsigned =
long flags,
> +                                     struct kvm_vcpu_sbi_return *retdata=
)
> +{
> +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +       int snapshot_area_size =3D sizeof(struct riscv_pmu_snapshot_data)=
;
> +       int sbiret =3D 0;
> +       gpa_t saddr;
> +       unsigned long hva;
> +       bool writable;
> +
> +       if (!kvpmu) {
> +               sbiret =3D SBI_ERR_INVALID_PARAM;
> +               goto out;
> +       }
> +
> +       if (saddr_low =3D=3D -1 && saddr_high =3D=3D -1) {
> +               kvm_pmu_clear_snapshot_area(vcpu);
> +               return 0;
> +       }
> +
> +       saddr =3D saddr_low;
> +
> +       if (saddr_high !=3D 0) {
> +#ifdef CONFIG_32BIT
> +               saddr |=3D ((gpa_t)saddr << 32);
> +#else
> +               sbiret =3D SBI_ERR_INVALID_ADDRESS;
> +               goto out;
> +#endif
> +       }
> +
> +       if (kvm_is_error_gpa(vcpu->kvm, saddr)) {
> +               sbiret =3D SBI_ERR_INVALID_PARAM;
> +               goto out;
> +       }
> +
> +       hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, saddr >> PAGE_SHIFT, &writ=
able);
> +       if (kvm_is_error_hva(hva) || !writable) {
> +               sbiret =3D SBI_ERR_INVALID_ADDRESS;
> +               goto out;
> +       }
> +
> +       kvpmu->snapshot_addr =3D saddr;
> +       kvpmu->sdata =3D kzalloc(snapshot_area_size, GFP_ATOMIC);
> +       if (!kvpmu->sdata)
> +               return -ENOMEM;
> +
> +       if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area=
_size)) {
> +               kfree(kvpmu->sdata);
> +               kvpmu->snapshot_addr =3D INVALID_GPA;
> +               sbiret =3D SBI_ERR_FAILURE;
> +       }

Newline here.

> +out:
> +       retdata->err_val =3D sbiret;
> +
> +       return 0;
> +}
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
>                                 struct kvm_vcpu_sbi_return *retdata)
>  {
> @@ -343,8 +416,10 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vc=
pu, unsigned long ctr_base,
>         int i, pmc_index, sbiret =3D 0;
>         struct kvm_pmc *pmc;
>         int fevent_code;
> +       bool bSnapshot =3D flags & SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT;
>
> -       if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0)=
 {
> +       if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0=
) ||
> +           (bSnapshot && kvpmu->snapshot_addr =3D=3D INVALID_GPA)) {

We have a different error code when shared memory is not available.

>                 sbiret =3D SBI_ERR_INVALID_PARAM;
>                 goto out;
>         }
> @@ -355,8 +430,14 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vc=
pu, unsigned long ctr_base,
>                 if (!test_bit(pmc_index, kvpmu->pmc_in_use))
>                         continue;
>                 pmc =3D &kvpmu->pmc[pmc_index];
> -               if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE)
> +               if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE) {
>                         pmc->counter_val =3D ival;
> +               } else if (bSnapshot) {
> +                       kvm_vcpu_read_guest(vcpu, kvpmu->snapshot_addr, k=
vpmu->sdata,
> +                                           sizeof(struct riscv_pmu_snaps=
hot_data));
> +                       pmc->counter_val =3D kvpmu->sdata->ctr_values[pmc=
_index];
> +               }
> +
>                 if (pmc->cinfo.type =3D=3D SBI_PMU_CTR_TYPE_FW) {
>                         fevent_code =3D get_event_code(pmc->event_idx);
>                         if (fevent_code >=3D SBI_PMU_FW_MAX) {
> @@ -400,8 +481,10 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcp=
u, unsigned long ctr_base,
>         u64 enabled, running;
>         struct kvm_pmc *pmc;
>         int fevent_code;
> +       bool bSnapshot =3D flags & SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
>
> -       if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0)=
 {
> +       if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0=
) ||
> +           (bSnapshot && (kvpmu->snapshot_addr =3D=3D INVALID_GPA))) {

Same as above.

>                 sbiret =3D SBI_ERR_INVALID_PARAM;
>                 goto out;
>         }
> @@ -423,27 +506,52 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vc=
pu, unsigned long ctr_base,
>                                 sbiret =3D SBI_ERR_ALREADY_STOPPED;
>
>                         kvpmu->fw_event[fevent_code].started =3D false;
> +                       /* No need to increment the value as it is absolu=
te for firmware events */
> +                       pmc->counter_val =3D kvpmu->fw_event[fevent_code]=
.value;

This change does not relate to the current patch.

>                 } else if (pmc->perf_event) {
>                         if (pmc->started) {
>                                 /* Stop counting the counter */
>                                 perf_event_disable(pmc->perf_event);
> -                               pmc->started =3D false;

Same as above.

>                         } else {
>                                 sbiret =3D SBI_ERR_ALREADY_STOPPED;
>                         }
>
> -                       if (flags & SBI_PMU_STOP_FLAG_RESET) {
> -                               /* Relase the counter if this is a reset =
request */
> +                       /* Stop counting the counter */
> +                       perf_event_disable(pmc->perf_event);
> +
> +                       /* We only update if stopped is already called. T=
he caller may stop/reset
> +                        * the event in two steps.
> +                        */

Use a double winged style multiline comment block.

> +                       if (pmc->started) {
>                                 pmc->counter_val +=3D perf_event_read_val=
ue(pmc->perf_event,
>                                                                          =
 &enabled, &running);
> +                               pmc->started =3D false;
> +                       }
> +
> +                       if (flags & SBI_PMU_STOP_FLAG_RESET) {

No need for braces here.

> +                               /* Relase the counter if this is a reset =
request */

s/Relase/Release/

>                                 kvm_pmu_release_perf_event(pmc);
>                         }
>                 } else {
>                         sbiret =3D SBI_ERR_INVALID_PARAM;
>                 }
> +
> +               if (bSnapshot && !sbiret) {
> +                       //TODO: Add counter overflow support when sscofpm=
f support is added

Use "/* */"

> +                       kvpmu->sdata->ctr_values[i] =3D pmc->counter_val;
> +                       kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, =
kvpmu->sdata,
> +                                            sizeof(struct riscv_pmu_snap=
shot_data));
> +               }
> +
>                 if (flags & SBI_PMU_STOP_FLAG_RESET) {
>                         pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
>                         clear_bit(pmc_index, kvpmu->pmc_in_use);
> +                       if (bSnapshot) {
> +                               /* Clear the snapshot area for the upcomi=
ng deletion event */
> +                               kvpmu->sdata->ctr_values[i] =3D 0;
> +                               kvm_vcpu_write_guest(vcpu, kvpmu->snapsho=
t_addr, kvpmu->sdata,
> +                                                    sizeof(struct riscv_=
pmu_snapshot_data));
> +                       }
>                 }
>         }
>
> @@ -517,8 +625,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu=
 *vcpu, unsigned long ctr_ba
>                         kvpmu->fw_event[event_code].started =3D true;
>         } else {
>                 ret =3D kvm_pmu_create_perf_event(pmc, &attr, flags, eidx=
, evtdata);
> -               if (ret)
> -                       return ret;
> +               if (ret) {
> +                       sbiret =3D SBI_ERR_NOT_SUPPORTED;
> +                       goto out;
> +               }

This also looks like a change not related to the current patch.

>         }
>
>         set_bit(ctr_idx, kvpmu->pmc_in_use);
> @@ -566,6 +676,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>         kvpmu->num_hw_ctrs =3D num_hw_ctrs + 1;
>         kvpmu->num_fw_ctrs =3D SBI_PMU_FW_MAX;
>         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw=
_event));
> +       kvpmu->snapshot_addr =3D INVALID_GPA;
>
>         if (kvpmu->num_hw_ctrs > RISCV_KVM_MAX_HW_CTRS) {
>                 pr_warn_once("Limiting the hardware counters to 32 as spe=
cified by the ISA");
> @@ -585,6 +696,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>                 pmc =3D &kvpmu->pmc[i];
>                 pmc->idx =3D i;
>                 pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
> +               pmc->vcpu =3D vcpu;
>                 if (i < kvpmu->num_hw_ctrs) {
>                         pmc->cinfo.type =3D SBI_PMU_CTR_TYPE_HW;
>                         if (i < 3)
> @@ -625,6 +737,7 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
>         }
>         bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
>         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw=
_event));
> +       kvpmu->snapshot_addr =3D INVALID_GPA;

You need to also free the sdata pointer.

>  }
>
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.=
c
> index 7eca72df2cbd..77c20a61fd7d 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -64,6 +64,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcp=
u, struct kvm_run *run,
>         case SBI_EXT_PMU_COUNTER_FW_READ:
>                 ret =3D kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata=
);
>                 break;
> +       case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
> +               ret =3D kvm_riscv_vcpu_pmu_setup_snapshot(vcpu, cp->a0, c=
p->a1, cp->a2, retdata);
> +               break;
>         default:
>                 retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
>         }
> --
> 2.34.1
>

Regards,
Anup

