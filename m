Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74AF1634BC7
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 01:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiKWApb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 19:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiKWAp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 19:45:29 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33486D53AD
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:45:28 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1431386d5bbso3201084fac.10
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QDfPHulS/Vn3UOA4vR1uM87IErqQEjtpmYPvJXgv2cc=;
        b=n/WEWNZYmpf+Qj0M9QMABmyYmEMn3MwSKKOTD2GtDlkOtEUnE2e4UyLXvprOTVzCkC
         gpN2lAVl/dTG59HMGFr0viYw0A4O4x9vXDW3mNE1pSmD4T5HYpcMiD1iUUYVBTUwt3Nn
         SOTnDWKW8GY8GgPVFFIBtl+0+zEPulzwJwSyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDfPHulS/Vn3UOA4vR1uM87IErqQEjtpmYPvJXgv2cc=;
        b=az5oMyOpBJcXgBrD5qvFHlMraFGl1sknB2YujkYFtFgqsM3L9f/qHSpYdmQhZcKVU/
         8qJbZiJy+KVLGnm3kiU4EcR2dUcd8dIQe9QOaZo4oJPFvmj0vLAUkX/mKVU5hYH15o7b
         DwKG3sE2cO0NrLidTnEcmS8PsqOpmrJGZsA8+DoS5XcfaHCcT1HAu8Qf5iUyTzyy09Ei
         9h9b8/KlAzbrlkqncR+7Wld1icmXJcmW3cuu1y89KYVZd7k+vO0u+4oBWyX+wyyWkbfF
         mir8jpA89igxbdSO5YBqxyMfG5f/2qiQiR6ha/5BLXRvQURLTdH5b76U/nXfUJy+IAyr
         Padg==
X-Gm-Message-State: ANoB5pn/pEh93kV1KZSGdUg93k//hKdGg5X+s1yIa3LC2e0U4nYUdMsg
        escXMESyHaHSJ5bTS5mETi94GbZxQ2EuGbDVHzq/
X-Google-Smtp-Source: AA0mqf482MHjboGZeIsQnz4qTwhroK1wCGfeA0+PTYJ60ny8yeg4bGGnfuyAH58RMP7NM3Cx6PTBzDQ+N69SjfkMErQ=
X-Received: by 2002:a05:6870:60a4:b0:132:79b1:f85 with SMTP id
 t36-20020a05687060a400b0013279b10f85mr5833548oae.274.1669164327405; Tue, 22
 Nov 2022 16:45:27 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-9-atishp@rivosinc.com>
 <20221101153112.hpst2bohsdvqours@kamzik>
In-Reply-To: <20221101153112.hpst2bohsdvqours@kamzik>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 22 Nov 2022 16:45:16 -0800
Message-ID: <CAOnJCU++M5jd6toy1J8T+FPGJWSUaw8s9X7sxZY25naPoZeJJw@mail.gmail.com>
Subject: Re: [RFC 8/9] RISC-V: KVM: Implement perf support
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 1, 2022 at 8:31 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Mon, Jul 18, 2022 at 10:02:04AM -0700, Atish Patra wrote:
> > RISC-V SBI PMU & Sscofpmf ISA extension allows supporting perf in
> > the virtualization enviornment as well. KVM implementation
> > relies on SBI PMU extension for most of the part while traps
>
> ...relies on the SBI PMU extension for the most part while trapping
> and emulating...
>
> > & emulates the CSRs read for counter access.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/kvm/vcpu_pmu.c | 318 ++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 301 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > index 5434051f495d..278c261efad3 100644
> > --- a/arch/riscv/kvm/vcpu_pmu.c
> > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > @@ -11,9 +11,163 @@
> >  #include <linux/kvm_host.h>
> >  #include <linux/perf/riscv_pmu.h>
> >  #include <asm/csr.h>
> > +#include <asm/bitops.h>
> >  #include <asm/kvm_vcpu_pmu.h>
> >  #include <linux/kvm_host.h>
> >
> > +#define get_event_type(x) ((x & SBI_PMU_EVENT_IDX_TYPE_MASK) >> 16)
> > +#define get_event_code(x) (x & SBI_PMU_EVENT_IDX_CODE_MASK)
> > +
> > +static inline u64 pmu_get_sample_period(struct kvm_pmc *pmc)
> > +{
> > +     u64 counter_val_mask = GENMASK(pmc->cinfo.width, 0);
> > +     u64 sample_period;
> > +
> > +     if (!pmc->counter_val)
> > +             sample_period = counter_val_mask;
> > +     else
> > +             sample_period = pmc->counter_val & counter_val_mask;
> > +
> > +     return sample_period;
> > +}
> > +
> > +static u32 pmu_get_perf_event_type(unsigned long eidx)
> > +{
> > +     enum sbi_pmu_event_type etype = get_event_type(eidx);
> > +     u32 type;
> > +
> > +     if (etype == SBI_PMU_EVENT_TYPE_HW)
> > +             type = PERF_TYPE_HARDWARE;
> > +     else if (etype == SBI_PMU_EVENT_TYPE_CACHE)
> > +             type = PERF_TYPE_HW_CACHE;
> > +     else if (etype == SBI_PMU_EVENT_TYPE_RAW || etype == SBI_PMU_EVENT_TYPE_FW)
> > +             type = PERF_TYPE_RAW;
> > +     else
> > +             type = PERF_TYPE_MAX;
> > +
> > +     return type;
> > +}
> > +
> > +static inline bool pmu_is_fw_event(unsigned long eidx)
> > +{
> > +     enum sbi_pmu_event_type etype = get_event_type(eidx);
> > +
> > +     return (etype == SBI_PMU_EVENT_TYPE_FW) ? true : false;
>
>  return get_event_type(eidx) == SBI_PMU_EVENT_TYPE_FW;
>

Done.

> > +}
> > +
> > +static void pmu_release_perf_event(struct kvm_pmc *pmc)
> > +{
> > +     if (pmc->perf_event) {
> > +             perf_event_disable(pmc->perf_event);
> > +             perf_event_release_kernel(pmc->perf_event);
> > +             pmc->perf_event = NULL;
> > +     }
> > +}
> > +
> > +static u64 pmu_get_perf_event_hw_config(u32 sbi_event_code)
> > +{
> > +     /* SBI PMU HW event code is offset by 1 from perf hw event codes */
> > +     return (u64)sbi_event_code - 1;
> > +}
> > +
> > +static u64 pmu_get_perf_event_cache_config(u32 sbi_event_code)
> > +{
> > +     u64 config = U64_MAX;
> > +     unsigned int cache_type, cache_op, cache_result;
> > +
> > +     /* All the cache event masks lie within 0xFF. No separate masking is necesssary */
> > +     cache_type = (sbi_event_code & SBI_PMU_EVENT_CACHE_ID_CODE_MASK) >> 3;
> > +     cache_op = (sbi_event_code & SBI_PMU_EVENT_CACHE_OP_ID_CODE_MASK) >> 1;
> > +     cache_result = sbi_event_code & SBI_PMU_EVENT_CACHE_RESULT_ID_CODE_MASK;
> > +
> > +     if (cache_type >= PERF_COUNT_HW_CACHE_MAX ||
> > +         cache_op >= PERF_COUNT_HW_CACHE_OP_MAX ||
> > +         cache_result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
> > +             goto out;
>
> No goto necessary
>

Done.

>         if (...)
>                 return U64_MAX;
>         return cache_type | (cache_op << 8) | (cache_result << 16);
>
> > +     config = cache_type | (cache_op << 8) | (cache_result << 16);
> > +out:
> > +     return config;
> > +}
> > +
> > +static u64 pmu_get_perf_event_config(unsigned long eidx, uint64_t edata)
> > +{
> > +     enum sbi_pmu_event_type etype = get_event_type(eidx);
> > +     u32 ecode = get_event_code(eidx);
> > +     u64 config = U64_MAX;
> > +
> > +     if (etype == SBI_PMU_EVENT_TYPE_HW)
> > +             config = pmu_get_perf_event_hw_config(ecode);
> > +     else if (etype == SBI_PMU_EVENT_TYPE_CACHE)
> > +             config = pmu_get_perf_event_cache_config(ecode);
> > +     else if (etype == SBI_PMU_EVENT_TYPE_RAW)
> > +             config = edata & RISCV_PMU_RAW_EVENT_MASK;
> > +     else if ((etype == SBI_PMU_EVENT_TYPE_FW) && (ecode < SBI_PMU_FW_MAX))
> > +             config = (1ULL << 63) | ecode;
> > +
> > +     return config;
> > +}
> > +
> > +static int pmu_get_fixed_pmc_index(unsigned long eidx)
> > +{
> > +     u32 etype = pmu_get_perf_event_type(eidx);
> > +     u32 ecode = get_event_code(eidx);
> > +     int ctr_idx;
> > +
> > +     if (etype != SBI_PMU_EVENT_TYPE_HW)
> > +             return -EINVAL;
> > +
> > +     if (ecode == SBI_PMU_HW_CPU_CYCLES)
> > +             ctr_idx = 0;
> > +     else if (ecode == SBI_PMU_HW_INSTRUCTIONS)
> > +             ctr_idx = 2;
> > +     else
> > +             return -EINVAL;
> > +
> > +     return ctr_idx;
> > +}
> > +
> > +static int pmu_get_programmable_pmc_index(struct kvm_pmu *kvpmu, unsigned long eidx,
> > +                                       unsigned long cbase, unsigned long cmask)
> > +{
> > +     int ctr_idx = -1;
> > +     int i, pmc_idx;
> > +     int min, max;
> > +
> > +     if (pmu_is_fw_event(eidx)) {
> > +             /* Firmware counters are mapped 1:1 starting from num_hw_ctrs for simplicity */
> > +             min = kvpmu->num_hw_ctrs;
> > +             max = min + kvpmu->num_fw_ctrs;
> > +     } else {
> > +             /* First 3 counters are reserved for fixed counters */
> > +             min = 3;
> > +             max = kvpmu->num_hw_ctrs;
> > +     }
> > +
> > +     for_each_set_bit(i, &cmask, BITS_PER_LONG) {
> > +             pmc_idx = i + cbase;
> > +             if ((pmc_idx >= min && pmc_idx < max) &&
> > +                 !test_bit(pmc_idx, kvpmu->used_pmc)) {
> > +                     ctr_idx = pmc_idx;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     return ctr_idx;
> > +}
> > +
> > +static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
> > +                          unsigned long cbase, unsigned long cmask)
> > +{
> > +     int ret;
> > +
> > +     /* Fixed counters need to be have fixed mapping as they have different width */
> > +     ret = pmu_get_fixed_pmc_index(eidx);
> > +     if (ret >= 0)
> > +             return ret;
> > +
> > +     return pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
> > +}
> > +
> >  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> >                               unsigned long *out_val)
> >  {
> > @@ -43,7 +197,6 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> >
> >       if (!kvpmu)
> >               return KVM_INSN_EXIT_TO_USER_SPACE;
> > -     //TODO: Should we check if vcpu pmu is initialized or not!
> >       if (wr_mask)
> >               return KVM_INSN_ILLEGAL_TRAP;
> >       cidx = csr_num - CSR_CYCLE;
> > @@ -81,14 +234,62 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> >  int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> >                                unsigned long ctr_mask, unsigned long flag, uint64_t ival)
> >  {
> > -     /* TODO */
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     int i, num_ctrs, pmc_index;
> > +     struct kvm_pmc *pmc;
> > +
> > +     num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
> > +     if (ctr_base + __fls(ctr_mask) >= num_ctrs)
> > +             return -EINVAL;
> > +
> > +     /* Start the counters that have been configured and requested by the guest */
> > +     for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
> > +             pmc_index = i + ctr_base;
> > +             if (!test_bit(pmc_index, kvpmu->used_pmc))
> > +                     continue;
> > +             pmc = &kvpmu->pmc[pmc_index];
> > +             if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
> > +                     pmc->counter_val = ival;
> > +             if (pmc->perf_event) {
> > +                     perf_event_period(pmc->perf_event, pmu_get_sample_period(pmc));
> > +                     perf_event_enable(pmc->perf_event);
> > +             }
>
> What about checking the "SBI_ERR_ALREADY_STARTED" condition?
>

pmu start and stop functions in core framework return void. Thus, perf
core can not check any error code
returning from pmu start/stop. We can not check SBI_ERR_ALREADY_STARTED/STOPPED.
It does maintain a state PERF_EVENT_STATE_ACTIVE(once
enabled)/PERF_EVENT_STATE_OFF(disabled).
We can check those states but those states can be invalid for other
reasons. A debug message can be printed
if enabling/disabling fails though.

However, KVM pmu implementation should return SBI_ERR_ALREADY_STARTED/STOPPED if
the event state is not accurate before enabling/disabling the event. I
have added that.

This brings up another generic error returning problem in KVM SBI
land. Usually, SBI error code numbers do not
align with Linux error codes to accommodate other operating systems.
However, most of the SBI error codes
have 1-1 relationship with the Linux error code.
Thus, kvm internal code returns a Linux specific error code and
vcpu_sbi will map those to SBI error code using
kvm_linux_err_map_sbi.

However, this will not work for SBI_ERR_ALREADY_STARTED/STOPPED as
there are no corresponding
Linux specific error codes. We can directly return the SBI error codes
from vcpu_pmu.c and modify the
kvm_linux_err_map_sbi to pass through those. In that case, we can't
map any linux error code that
collides with SBI error code. Any other ideas to handle this case ?


> > +     }
> > +
> >       return 0;
> >  }
> >
> >  int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> >                                unsigned long ctr_mask, unsigned long flag)
> >  {
> > -     /* TODO */
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     int i, num_ctrs, pmc_index;
> > +     u64 enabled, running;
> > +     struct kvm_pmc *pmc;
> > +
> > +     num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
> > +     if ((ctr_base + __fls(ctr_mask)) >= num_ctrs)
> > +             return -EINVAL;
> > +
> > +     /* Stop the counters that have been configured and requested by the guest */
> > +     for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
> > +             pmc_index = i + ctr_base;
> > +             if (!test_bit(pmc_index, kvpmu->used_pmc))
> > +                     continue;
> > +             pmc = &kvpmu->pmc[pmc_index];
> > +             if (pmc->perf_event) {
> > +                     /* Stop counting the counter */
> > +                     perf_event_disable(pmc->perf_event);
> > +                     if (flag & SBI_PMU_STOP_FLAG_RESET) {
> > +                             /* Relase the counter if this is a reset request */
> > +                             pmc->counter_val += perf_event_read_value(pmc->perf_event,
> > +                                                                       &enabled, &running);
> > +                             pmu_release_perf_event(pmc);
> > +                             clear_bit(pmc_index, kvpmu->used_pmc);
> > +                     }
>
> What about checking the "SBI_ERR_ALREADY_STOPPED" condition?
>

> > +             }
> > +     }
> > +
> >       return 0;
> >  }
> >
> > @@ -96,14 +297,85 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
> >                                    unsigned long ctr_mask, unsigned long flag,
> >                                    unsigned long eidx, uint64_t edata)
> >  {
> > -     /* TODO */
> > -     return 0;
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     struct perf_event *event;
> > +     struct perf_event_attr attr;
> > +     int num_ctrs, ctr_idx;
> > +     u32 etype = pmu_get_perf_event_type(eidx);
> > +     u64 config;
> > +     struct kvm_pmc *pmc;
> > +
> > +     num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
> > +     if ((etype == PERF_TYPE_MAX) || ((ctr_base + __fls(ctr_mask)) >= num_ctrs))
>
> nit: Unnecessary ()
>

Fixed.

> > +             return -EINVAL;
> > +
> > +     if (pmu_is_fw_event(eidx))
> > +             return -EOPNOTSUPP;
>
> nit: need blank line here
>

Fixed.

> > +     /*
> > +      * SKIP_MATCH flag indicates the caller is aware of the assigned counter
> > +      * for this event. Just do a sanity check if it already marked used.
> > +      */
> > +     if (flag & SBI_PMU_CFG_FLAG_SKIP_MATCH) {
> > +             if (!test_bit(ctr_base, kvpmu->used_pmc))
> > +                     return -EINVAL;
> > +             ctr_idx = ctr_base;
> > +             goto match_done;
> > +     }
> > +
> > +     ctr_idx = pmu_get_pmc_index(kvpmu, eidx, ctr_base, ctr_mask);
> > +     if (ctr_idx < 0)
> > +             return -EOPNOTSUPP;
> > +
> > +match_done:
> > +     pmc = &kvpmu->pmc[ctr_idx];
> > +     pmu_release_perf_event(pmc);
> > +     pmc->idx = ctr_idx;
> > +
> > +     config = pmu_get_perf_event_config(eidx, edata);
> > +     memset(&attr, 0, sizeof(struct perf_event_attr));
> > +     attr.type = etype;
> > +     attr.size = sizeof(attr);
> > +     attr.pinned = true;
> > +
> > +     /*
> > +      * It should never reach here if the platform doesn't support sscofpmf extensio
> > +      * as mode filtering won't work without it.
> > +      */
> > +     attr.exclude_host = true;
> > +     attr.exclude_hv = true;
> > +     attr.exclude_user = flag & SBI_PMU_CFG_FLAG_SET_UINH ? 1 : 0;
> > +     attr.exclude_kernel = flag & SBI_PMU_CFG_FLAG_SET_SINH ? 1 : 0;
>
> nit: can use !!(flag & SBI_PMU_CFG_FLAG_SET_UINH)

Fixed.

>
> > +     attr.config = config;
> > +     attr.config1 = RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS;
> > +     if (flag & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
> > +             //TODO: Do we really want to clear the value in hardware counter
> > +             pmc->counter_val = 0;
> > +     }
>
> nit: add blank line

Fixed.

>
> > +     /*
> > +      * Set the default sample_period for now. The guest specified value
> > +      * will be updated in the start call.
> > +      */
> > +     attr.sample_period = pmu_get_sample_period(pmc);
> > +
> > +     event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> > +     if (IS_ERR(event)) {
> > +             pr_err("kvm pmu event creation failed event %pe for eidx %lx\n", event, eidx);
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     set_bit(ctr_idx, kvpmu->used_pmc);
> > +     pmc->perf_event = event;
> > +     if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
> > +             perf_event_enable(pmc->perf_event);
> > +
> > +     return ctr_idx;
> >  }
> >
> >  int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> >  {
> >       int i = 0, num_hw_ctrs, num_fw_ctrs, hpm_width;
> >       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     struct kvm_pmc *pmc;
> >
> >       if (!kvpmu)
> >               return -EINVAL;
> > @@ -120,6 +392,7 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> >               return -EINVAL;
> >       }
> >
> > +     bitmap_zero(kvpmu->used_pmc, RISCV_MAX_COUNTERS);
> >       kvpmu->num_hw_ctrs = num_hw_ctrs;
> >       kvpmu->num_fw_ctrs = num_fw_ctrs;
> >       /*
> > @@ -132,38 +405,49 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> >               /* TIME CSR shouldn't be read from perf interface */
> >               if (i == 1)
> >                       continue;
> > -             kvpmu->pmc[i].idx = i;
> > -             kvpmu->pmc[i].vcpu = vcpu;
> > +             pmc = &kvpmu->pmc[i];
>
> Better to introduce this with the patch that introduced this loop.
>

Sure. Done.

> > +             pmc->idx = i;
> > +             pmc->counter_val = 0;
> > +             pmc->vcpu = vcpu;
> >               if (i < kvpmu->num_hw_ctrs) {
> >                       kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
> >                       if (i < 3)
> >                               /* CY, IR counters */
> > -                             kvpmu->pmc[i].cinfo.width = 63;
> > +                             pmc->cinfo.width = 63;
> >                       else
> > -                             kvpmu->pmc[i].cinfo.width = hpm_width;
> > +                             pmc->cinfo.width = hpm_width;
> >                       /*
> >                        * The CSR number doesn't have any relation with the logical
> >                        * hardware counters. The CSR numbers are encoded sequentially
> >                        * to avoid maintaining a map between the virtual counter
> >                        * and CSR number.
> >                        */
> > -                     kvpmu->pmc[i].cinfo.csr = CSR_CYCLE + i;
> > +                     pmc->cinfo.csr = CSR_CYCLE + i;
> >               } else {
> > -                     kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_FW;
> > -                     kvpmu->pmc[i].cinfo.width = BITS_PER_LONG - 1;
> > +                     pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
> > +                     pmc->cinfo.width = BITS_PER_LONG - 1;
> >               }
> >       }
> >
> >       return 0;
> >  }
> >
> > -void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> > +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> >  {
> > -     /* TODO */
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     struct kvm_pmc *pmc;
> > +     int i;
> > +
> > +     if (!kvpmu)
> > +             return;
> > +
> > +     for_each_set_bit(i, kvpmu->used_pmc, RISCV_MAX_COUNTERS) {
> > +             pmc = &kvpmu->pmc[i];
> > +             pmu_release_perf_event(pmc);
> > +     }
> >  }
> >
> > -void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> > +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> >  {
> > -     /* TODO */
> > +     kvm_riscv_vcpu_pmu_deinit(vcpu);
> >  }
> > -
> > --
> > 2.25.1
> >
>
> Thanks,
> drew



-- 
Regards,
Atish
