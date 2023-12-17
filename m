Return-Path: <kvm+bounces-4649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3D7815E5A
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 10:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2C291F2211F
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 09:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ACD1569F;
	Sun, 17 Dec 2023 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="NdKasacU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722A35662
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ca0715f0faso25991321fa.0
        for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 01:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702805798; x=1703410598; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cr7WP6pWKVfZhbIR4trNXbp8xAMrqU0GBoHGegXbFT4=;
        b=NdKasacU+3SnQQ2G23XJl7Fhkk74W4XUzZzMZbja3fyZoP05lrRWqkh8OsU1r4eCD3
         Tu1m3u+2VSM1AwC7c3vTeSuQK1ol7W+cFCEyd01YPx6TkGsj15+jX1YRytdkYw+CJ8AU
         3D6egg9p43qQ6PZMj8P/Qz/RrBVPL8SpVxUXmSX2cqqOETBF+JJIuJ2jvvXW54LDBnol
         4qASJiYK+1cAnh+pJe00QKfthVDvI2wSjwW+IKyezfBrJMo5H6ee8jVGL3s3nNoVcs8Q
         IElk/z9GsOQc0eVKfqN/pjX43PNxBQIcnYGd9KA/oNUKutjYDw7JQDoSA7KzsNIRCInw
         fBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702805798; x=1703410598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cr7WP6pWKVfZhbIR4trNXbp8xAMrqU0GBoHGegXbFT4=;
        b=t8II6rv/FwLA+mfE07l+0o8O5Qw9LV3c/LLaKFeoccq8nCRRNVKltFkyfxqbAvHf3Q
         CZ5imxQ8PKojtBk+rqOqMKyx93kP8aHSZfT2aHBn6eCRSUvKqauDPzlvnToJgJkJJzQh
         aRNQIrM/nlPmgFcLGOoLRo0msnV0S/se8G7qcf1Dqhal+Q8H5FgFaObti9o7DeTS4Rb/
         3ImSiKV+SG6/8R4BkjRPoigWvEIL8hzkf/TaGVdJZ3USyC3tB9ASHptiwpJYid4214Yr
         J04zH1L56u7ssI1soYtX+xaYGEGQa6dCzNmq/wLyGykWc2Y1tjQpS4VYeTltTvvDAOtl
         zHKA==
X-Gm-Message-State: AOJu0YyfRgn4BIBIMtMVdqPl2BP9M9OJsCsAmJNTaBMl5vw0IukszTz0
	kbBiMPXdTVnCpmiRvsDpGc0oO5BXMnmA7NWZOCC/uA==
X-Google-Smtp-Source: AGHT+IFjAjrk5bxheA9uHJxq5u8+I6RsnQiY4fWo4nOY04wkXFwjHXPy2RHyUNCMqmvgmQZfBLJYNuR5UGKK5XRD8sc=
X-Received: by 2002:a05:6512:2019:b0:50b:d764:8046 with SMTP id
 a25-20020a056512201900b0050bd7648046mr5955858lfb.121.1702805797769; Sun, 17
 Dec 2023 01:36:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-8-atishp@rivosinc.com>
 <CAAhSdy3cqeHg0HSE2qAZ3n4854xkhgZVjZa9hW0PD2NU9is4uA@mail.gmail.com>
In-Reply-To: <CAAhSdy3cqeHg0HSE2qAZ3n4854xkhgZVjZa9hW0PD2NU9is4uA@mail.gmail.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Sun, 17 Dec 2023 01:36:26 -0800
Message-ID: <CAHBxVyFf4f7LA4mAyCgfFp425BbnbYneCZqWkudDYC_upC0cSQ@mail.gmail.com>
Subject: Re: [RFC 7/9] RISC-V: KVM: Implement SBI PMU Snapshot feature
To: Anup Patel <anup@brainfault.org>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 5:46=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Tue, Dec 5, 2023 at 8:13=E2=80=AFAM Atish Patra <atishp@rivosinc.com> =
wrote:
> >
> > PMU Snapshot function allows to minimize the number of traps when the
> > guest access configures/access the hpmcounters. If the snapshot feature
> > is enabled, the hypervisor updates the shared memory with counter
> > data and state of overflown counters. The guest can just read the
> > shared memory instead of trap & emulate done by the hypervisor.
> >
> > This patch doesn't implement the counter overflow yet.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  10 ++
> >  arch/riscv/kvm/vcpu_pmu.c             | 129 ++++++++++++++++++++++++--
> >  arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
> >  3 files changed, 134 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include=
/asm/kvm_vcpu_pmu.h
> > index 395518a1664e..64c75acad6ba 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > @@ -36,6 +36,7 @@ struct kvm_pmc {
> >         bool started;
> >         /* Monitoring event ID */
> >         unsigned long event_idx;
> > +       struct kvm_vcpu *vcpu;
>
> Where is this used ?
>

Moved it to the next patch as suggested there.

> >  };
> >
> >  /* PMU data structure per vcpu */
> > @@ -50,6 +51,12 @@ struct kvm_pmu {
> >         bool init_done;
> >         /* Bit map of all the virtual counter used */
> >         DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> > +       /* Bit map of all the virtual counter overflown */
> > +       DECLARE_BITMAP(pmc_overflown, RISCV_KVM_MAX_COUNTERS);
> > +       /* The address of the counter snapshot area (guest physical add=
ress) */
> > +       unsigned long snapshot_addr;
> > +       /* The actual data of the snapshot */
> > +       struct riscv_pmu_snapshot_data *sdata;
> >  };
> >
> >  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
> > @@ -85,6 +92,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu =
*vcpu, unsigned long ctr_ba
> >  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long c=
idx,
> >                                 struct kvm_vcpu_sbi_return *retdata);
> >  void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> > +int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned =
long saddr_low,
> > +                                      unsigned long saddr_high, unsign=
ed long flags,
> > +                                      struct kvm_vcpu_sbi_return *retd=
ata);
> >  void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> >
> > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > index 86391a5061dd..622c4ee89e7b 100644
> > --- a/arch/riscv/kvm/vcpu_pmu.c
> > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > @@ -310,6 +310,79 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *v=
cpu, unsigned int csr_num,
> >         return ret;
> >  }
> >
> > +static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
> > +{
> > +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> > +       int snapshot_area_size =3D sizeof(struct riscv_pmu_snapshot_dat=
a);
> > +
> > +       if (kvpmu->sdata) {
> > +               memset(kvpmu->sdata, 0, snapshot_area_size);
> > +               if (kvpmu->snapshot_addr !=3D INVALID_GPA)
> > +                       kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr=
,
> > +                                            kvpmu->sdata, snapshot_are=
a_size);
>
> We should free the "kvpmu->sdata" and set it to NULL. This way subsequent
> re-enabling of snapshot won't leak the kernel memory.
>

Done.

> > +       }
> > +       kvpmu->snapshot_addr =3D INVALID_GPA;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned =
long saddr_low,
> > +                                     unsigned long saddr_high, unsigne=
d long flags,
> > +                                     struct kvm_vcpu_sbi_return *retda=
ta)
> > +{
> > +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> > +       int snapshot_area_size =3D sizeof(struct riscv_pmu_snapshot_dat=
a);
> > +       int sbiret =3D 0;
> > +       gpa_t saddr;
> > +       unsigned long hva;
> > +       bool writable;
> > +
> > +       if (!kvpmu) {
> > +               sbiret =3D SBI_ERR_INVALID_PARAM;
> > +               goto out;
> > +       }
> > +
> > +       if (saddr_low =3D=3D -1 && saddr_high =3D=3D -1) {
> > +               kvm_pmu_clear_snapshot_area(vcpu);
> > +               return 0;
> > +       }
> > +
> > +       saddr =3D saddr_low;
> > +
> > +       if (saddr_high !=3D 0) {
> > +#ifdef CONFIG_32BIT
> > +               saddr |=3D ((gpa_t)saddr << 32);
> > +#else
> > +               sbiret =3D SBI_ERR_INVALID_ADDRESS;
> > +               goto out;
> > +#endif
> > +       }
> > +
> > +       if (kvm_is_error_gpa(vcpu->kvm, saddr)) {
> > +               sbiret =3D SBI_ERR_INVALID_PARAM;
> > +               goto out;
> > +       }
> > +
> > +       hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, saddr >> PAGE_SHIFT, &wr=
itable);
> > +       if (kvm_is_error_hva(hva) || !writable) {
> > +               sbiret =3D SBI_ERR_INVALID_ADDRESS;
> > +               goto out;
> > +       }
> > +
> > +       kvpmu->snapshot_addr =3D saddr;
> > +       kvpmu->sdata =3D kzalloc(snapshot_area_size, GFP_ATOMIC);
> > +       if (!kvpmu->sdata)
> > +               return -ENOMEM;
> > +
> > +       if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_ar=
ea_size)) {
> > +               kfree(kvpmu->sdata);
> > +               kvpmu->snapshot_addr =3D INVALID_GPA;
> > +               sbiret =3D SBI_ERR_FAILURE;
> > +       }
>
> Newline here.
>

Done.

> > +out:
> > +       retdata->err_val =3D sbiret;
> > +
> > +       return 0;
> > +}
> > +
> >  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
> >                                 struct kvm_vcpu_sbi_return *retdata)
> >  {
> > @@ -343,8 +416,10 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *=
vcpu, unsigned long ctr_base,
> >         int i, pmc_index, sbiret =3D 0;
> >         struct kvm_pmc *pmc;
> >         int fevent_code;
> > +       bool bSnapshot =3D flags & SBI_PMU_START_FLAG_INIT_FROM_SNAPSHO=
T;
> >
> > -       if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < =
0) {
> > +       if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) <=
 0) ||
> > +           (bSnapshot && kvpmu->snapshot_addr =3D=3D INVALID_GPA)) {
>
> We have a different error code when shared memory is not available.
>

Fixed.

> >                 sbiret =3D SBI_ERR_INVALID_PARAM;
> >                 goto out;
> >         }
> > @@ -355,8 +430,14 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *=
vcpu, unsigned long ctr_base,
> >                 if (!test_bit(pmc_index, kvpmu->pmc_in_use))
> >                         continue;
> >                 pmc =3D &kvpmu->pmc[pmc_index];
> > -               if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE)
> > +               if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE) {
> >                         pmc->counter_val =3D ival;
> > +               } else if (bSnapshot) {
> > +                       kvm_vcpu_read_guest(vcpu, kvpmu->snapshot_addr,=
 kvpmu->sdata,
> > +                                           sizeof(struct riscv_pmu_sna=
pshot_data));
> > +                       pmc->counter_val =3D kvpmu->sdata->ctr_values[p=
mc_index];
> > +               }
> > +
> >                 if (pmc->cinfo.type =3D=3D SBI_PMU_CTR_TYPE_FW) {
> >                         fevent_code =3D get_event_code(pmc->event_idx);
> >                         if (fevent_code >=3D SBI_PMU_FW_MAX) {
> > @@ -400,8 +481,10 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *v=
cpu, unsigned long ctr_base,
> >         u64 enabled, running;
> >         struct kvm_pmc *pmc;
> >         int fevent_code;
> > +       bool bSnapshot =3D flags & SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
> >
> > -       if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < =
0) {
> > +       if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) <=
 0) ||
> > +           (bSnapshot && (kvpmu->snapshot_addr =3D=3D INVALID_GPA))) {
>
> Same as above.
>
> >                 sbiret =3D SBI_ERR_INVALID_PARAM;
> >                 goto out;
> >         }
> > @@ -423,27 +506,52 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *=
vcpu, unsigned long ctr_base,
> >                                 sbiret =3D SBI_ERR_ALREADY_STOPPED;
> >
> >                         kvpmu->fw_event[fevent_code].started =3D false;
> > +                       /* No need to increment the value as it is abso=
lute for firmware events */
> > +                       pmc->counter_val =3D kvpmu->fw_event[fevent_cod=
e].value;
>
> This change does not relate to the current patch.
>

Actually it does. We need to assign pmc->counter_val here because
shared memory needs to be updated
with the actual counter val. However, we should do it if the snapshot
is enabled only.
Otherwise, it will be updated in pmu_ctr_read anyways. I have fixed
that and moved this to the if condition with bSnapshot
below.

> >                 } else if (pmc->perf_event) {
> >                         if (pmc->started) {
> >                                 /* Stop counting the counter */
> >                                 perf_event_disable(pmc->perf_event);
> > -                               pmc->started =3D false;
>
> Same as above.
>
> >                         } else {
> >                                 sbiret =3D SBI_ERR_ALREADY_STOPPED;
> >                         }
> >
> > -                       if (flags & SBI_PMU_STOP_FLAG_RESET) {
> > -                               /* Relase the counter if this is a rese=
t request */
> > +                       /* Stop counting the counter */
> > +                       perf_event_disable(pmc->perf_event);
> > +

This is not needed as we would have already stopped when started =3D true.

> > +                       /* We only update if stopped is already called.=
 The caller may stop/reset
> > +                        * the event in two steps.
> > +                        */
>
> Use a double winged style multiline comment block.
>

Fixed.

> > +                       if (pmc->started) {
> >                                 pmc->counter_val +=3D perf_event_read_v=
alue(pmc->perf_event,
> >                                                                        =
   &enabled, &running);
> > +                               pmc->started =3D false;
> > +                       }
> > +
> > +                       if (flags & SBI_PMU_STOP_FLAG_RESET) {
>
> No need for braces here.
>
> > +                               /* Relase the counter if this is a rese=
t request */
>
> s/Relase/Release/
>

Fixed.

> >                                 kvm_pmu_release_perf_event(pmc);
> >                         }
> >                 } else {
> >                         sbiret =3D SBI_ERR_INVALID_PARAM;
> >                 }
> > +
> > +               if (bSnapshot && !sbiret) {
> > +                       //TODO: Add counter overflow support when sscof=
pmf support is added
>
> Use "/* */"
>
> > +                       kvpmu->sdata->ctr_values[i] =3D pmc->counter_va=
l;
> > +                       kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr=
, kvpmu->sdata,
> > +                                            sizeof(struct riscv_pmu_sn=
apshot_data));
> > +               }
> > +
> >                 if (flags & SBI_PMU_STOP_FLAG_RESET) {
> >                         pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
> >                         clear_bit(pmc_index, kvpmu->pmc_in_use);
> > +                       if (bSnapshot) {
> > +                               /* Clear the snapshot area for the upco=
ming deletion event */
> > +                               kvpmu->sdata->ctr_values[i] =3D 0;
> > +                               kvm_vcpu_write_guest(vcpu, kvpmu->snaps=
hot_addr, kvpmu->sdata,
> > +                                                    sizeof(struct risc=
v_pmu_snapshot_data));
> > +                       }
> >                 }
> >         }
> >
> > @@ -517,8 +625,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vc=
pu *vcpu, unsigned long ctr_ba
> >                         kvpmu->fw_event[event_code].started =3D true;
> >         } else {
> >                 ret =3D kvm_pmu_create_perf_event(pmc, &attr, flags, ei=
dx, evtdata);
> > -               if (ret)
> > -                       return ret;
> > +               if (ret) {
> > +                       sbiret =3D SBI_ERR_NOT_SUPPORTED;
> > +                       goto out;
> > +               }
>
> This also looks like a change not related to the current patch.
>

Moved to a separate patch.

> >         }
> >
> >         set_bit(ctr_idx, kvpmu->pmc_in_use);
> > @@ -566,6 +676,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> >         kvpmu->num_hw_ctrs =3D num_hw_ctrs + 1;
> >         kvpmu->num_fw_ctrs =3D SBI_PMU_FW_MAX;
> >         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_=
fw_event));
> > +       kvpmu->snapshot_addr =3D INVALID_GPA;
> >
> >         if (kvpmu->num_hw_ctrs > RISCV_KVM_MAX_HW_CTRS) {
> >                 pr_warn_once("Limiting the hardware counters to 32 as s=
pecified by the ISA");
> > @@ -585,6 +696,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> >                 pmc =3D &kvpmu->pmc[i];
> >                 pmc->idx =3D i;
> >                 pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
> > +               pmc->vcpu =3D vcpu;
> >                 if (i < kvpmu->num_hw_ctrs) {
> >                         pmc->cinfo.type =3D SBI_PMU_CTR_TYPE_HW;
> >                         if (i < 3)
> > @@ -625,6 +737,7 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcp=
u)
> >         }
> >         bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
> >         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_=
fw_event));
> > +       kvpmu->snapshot_addr =3D INVALID_GPA;
>
> You need to also free the sdata pointer.
>

Fixed. Thanks.

> >  }
> >
> >  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> > diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pm=
u.c
> > index 7eca72df2cbd..77c20a61fd7d 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> > @@ -64,6 +64,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *v=
cpu, struct kvm_run *run,
> >         case SBI_EXT_PMU_COUNTER_FW_READ:
> >                 ret =3D kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retda=
ta);
> >                 break;
> > +       case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
> > +               ret =3D kvm_riscv_vcpu_pmu_setup_snapshot(vcpu, cp->a0,=
 cp->a1, cp->a2, retdata);
> > +               break;
> >         default:
> >                 retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
> >         }
> > --
> > 2.34.1
> >
>
> Regards,
> Anup

