Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3516459F2A8
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 06:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiHXE2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 00:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiHXE2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 00:28:04 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E8A8034A
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 21:28:03 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id w188so8375935vsb.10
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 21:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=HZX9UPnD1SZbyIzV15u7lwCGjXwbp41n4vG+6lpWfQw=;
        b=ACGouVxoWAGKxuZOzlfcKKnrmIs/B+qEEX9Z5344E7B1sBsbUCrVo3S/p9v+jD1lYA
         dPi2QIpmQkU9JovJOLvy+Z+T54rn2u0WkmDnunJp0F+y7QvFMPflUjtbZYm+4c6E9QqY
         ou2OxfUJuFOUnrSDC94Sk1qxyrzT07CywUpCQy4pR7gxA1OaGKqaL6ZUqLAEUF+OWKF6
         Y2K/xTIxbXuIUI3gulai6+7UGikPgB9fh2hXIV9ihTLdYzJzAxvyvxJLh9oYjeJwUe1n
         b/suTm1KR4dOY4Cg2Oqz1yns3idNbpQQVYVHXN2hR9mvvV0CSyiRxOs3TAdYPqoK2FyZ
         ZlMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=HZX9UPnD1SZbyIzV15u7lwCGjXwbp41n4vG+6lpWfQw=;
        b=2rTWkBo8MVuiVD2XBBtzSjaxy1qxb+EE6GV32Duhqck/LEyBJcIyMSYix7RsF57O0W
         JBhLoHgqQifyTIizHz7jvWXXbguCxrpMyNGt+3NOKlWFaDFtIdwAgVuokVMvjcYR9u+4
         6ajFdYDDgfeoBzFuR+LJKDE07IUj4OCS06qlU2hlTbvboihoIWuRVdHacsjRxtCxMJyq
         LUrIzicHmng0yxKWd9YdK3HcMLnLVw4UH9+74zI/ZA/CyAGkaUbpckzBXriJKmpB4CQe
         jYK1EhVZ+EUGN7EO1kLK6HNiRgat7etozK4umeXvPU4P6NMmMdZm+me1FpzWJCQ4+5Ai
         xE2Q==
X-Gm-Message-State: ACgBeo0BT3HWZDX88+k1BtdbAAhxtmS7eKg7jqpWQSPEFny42EKKbiMc
        9ydnkvaK7+YpmWCpF64hRDY1t8GG5Kg0mWy06l5zdg==
X-Google-Smtp-Source: AA6agR7dswkVE0hsJgawQ/TXDE8UB7d8ATuNXQAThUBOmI+Q8XyJg6lgl7iQtnqQx5D0ROgRMMn5NtGvm/cLtYrpCwQ=
X-Received: by 2002:a67:de11:0:b0:390:4ef6:6a5f with SMTP id
 q17-20020a67de11000000b003904ef66a5fmr5783141vsk.58.1661315282499; Tue, 23
 Aug 2022 21:28:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-5-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-5-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 23 Aug 2022 21:27:46 -0700
Message-ID: <CAAeT=FwhK=Jb-fB22d76CAtDy2F9JBxme+tZyWyv+_fTG9eP+A@mail.gmail.com>
Subject: Re: [PATCH 4/9] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to reduce the boilerplate code, add two helpers returning
> the counter register index (resp. the event register) in the vcpu
> register file from the counter index.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0ab6f59f433c..9be485d23416 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -75,6 +75,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>         return container_of(vcpu_arch, struct kvm_vcpu, arch);
>  }
>
> +static u32 counter_index_to_reg(u64 idx)
> +{
> +       return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
> +}
> +
> +static u32 counter_index_to_evtreg(u64 idx)
> +{
> +       return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
> +}
> +
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -89,8 +99,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return 0;
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -               ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +       reg = counter_index_to_reg(select_idx);
>         counter = __vcpu_sys_reg(vcpu, reg);
>
>         /*
> @@ -120,8 +129,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return;
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> +       reg = counter_index_to_reg(select_idx);
>         __vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>
>         /* Recreate the perf event to reflect the updated sample_period */
> @@ -156,10 +164,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>
>         counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>
> -       if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -               reg = PMCCNTR_EL0;
> -       else
> -               reg = PMEVCNTR0_EL0 + pmc->idx;
> +       reg = counter_index_to_reg(pmc->idx);
>
>         if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
>                 counter = lower_32_bits(counter);
> @@ -540,8 +545,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         struct perf_event_attr attr;
>         u64 eventsel, counter, reg, data;
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
> +       reg = counter_index_to_evtreg(select_idx);
>         data = __vcpu_sys_reg(vcpu, reg);
>
>         kvm_pmu_stop_counter(vcpu, pmc);
> @@ -627,8 +631,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>         mask &= ~ARMV8_PMU_EVTYPE_EVENT;
>         mask |= kvm_pmu_event_mask(vcpu->kvm);
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> +       reg = counter_index_to_evtreg(select_idx);
>
>         __vcpu_sys_reg(vcpu, reg) = data & mask;
>
> --

counter_index_to_evtreg() could also be used in access_pmu_evtyper()
in sys_regs.c (counter_index_to_evtreg() is currently defined as
static in pmu-emul.c though).

---
static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
                               const struct sys_reg_desc *r)
{
        <...>
        } else if (r->CRn == 14 && (r->CRm & 12) == 12) {
                idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
                if (idx == ARMV8_PMU_CYCLE_IDX)
                        reg = PMCCFILTR_EL0;
                else
                        /* PMEVTYPERn_EL0 */
                        reg = PMEVTYPER0_EL0 + idx;
        <...>
---

Thank you,
Reiji
