Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687BC630C4B
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 06:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiKSFxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 00:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiKSFxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 00:53:14 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6DE8FE4E
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 21:53:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u6-20020a17090a5e4600b0021881a8d264so4593642pji.4
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 21:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wz8dYcxR3+yX3z3xmnU9Zu+0PZxNi4yPWJhB9721SRM=;
        b=fUpTDtRxfjg6unyhlyNX9OdDnqKxaHSz88G5lgmqtHNpZpgAscvHJbdGqXZDnqpM9P
         aegcZohdOVti2VieOCToDG20TFNykHNuYhjenxkdyLHL/2PPEdFGHNMP9eEJ9oAH5UOF
         y2Na9pK/LY93pqbyMf57qVXQwmz9kFgYXmWVTwbmDd7YbTxFa0pNtmUbtL3bk+3yB42D
         wATYzmC1cI6yQnEwNioy14jOcYLzuE0qAxp2YRg39ebNgSzUbRALJWt7mpBOM0++z+RD
         royoIERiovEGL861hFzs//PxiAzc4W8TKiVEnINoQn/91VzXXHFS7vrLRQ9fWmJlMQT9
         0IKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wz8dYcxR3+yX3z3xmnU9Zu+0PZxNi4yPWJhB9721SRM=;
        b=b5vSTTtBdx9zdyS4JfF5ZDT4NOEYd12Nzj3e+7fpIXAP6iyf/ZWkd+Dau79FGme4OZ
         4tCTT/3vVCk8OZX3m0+ZoyeYr9XrgkT/PHsx7wZkL8RXkw8RbrQ1RO3ZR0HNYBCPebCa
         bUyVDtnI5RFWBSYPSWYqud3TK8LGDTeXHAbgcxkZZ38vD2S4BEYSXhuYnShiyMEgM9t/
         xxbfwIcKwhO1n6GQ3T750iI6WoO2Vrg51wM0AB6yhFReO9SJnL81W8aN+Y+GdxFghAmZ
         BDL8JIqp7xcxGJH2IdPM5l2nI0qSiExHxhJHUDq2Zmjjumwoa0T/h3O6SFePJo2vrDE1
         QJVA==
X-Gm-Message-State: ANoB5pkamC9i9ezEPMBWhBd7Yf+4CSHsiW4UUpAHS4PNBEcS6gYotOl/
        N4ExxaaKNwLJRCUpH7cI4Fbd/FG28ZOn1Q2lRR+pmA==
X-Google-Smtp-Source: AA0mqf4kXBS5cv71+AQu54rPe1r6va354rE1Kqu4awgYk/aGAewIyvsWXPmKv1Nwztx5XCKtF6ysqdChVX62y5oIrQk=
X-Received: by 2002:a17:902:cacb:b0:188:5e78:be0 with SMTP id
 y11-20020a170902cacb00b001885e780be0mr2780600pld.18.1668837192845; Fri, 18
 Nov 2022 21:53:12 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-13-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-13-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 18 Nov 2022 21:52:56 -0800
Message-ID: <CAAeT=Fwq8wcBvoWE+5RJt4og4uD5KgQ0kzhDZorGPjHmTguwzw@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be
 set from userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_DFR0_EL1, on the condition that only
> the PerfMon field can be altered and be something that is compatible
> with what was computed for the AArch64 view of the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 57 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3cbcda665d23..dc201a0557c0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1070,6 +1070,19 @@ static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>         return vcpu->kvm->arch.dfr0_pmuver.unimp;
>  }
>
> +static u8 perfmon_to_pmuver(u8 perfmon)
> +{
> +       switch (perfmon) {
> +       case ID_DFR0_PERFMON_8_0:
> +               return ID_AA64DFR0_EL1_PMUVer_IMP;
> +       case ID_DFR0_PERFMON_IMP_DEF:
> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;

Nit: Since IMP_DEF is 0xf for both PMUVER and PERFMON,
I think the 'default' can handle IMP_DEF (I have the same
comment for pmuver_to_perfmon in the patch-10).

> +       default:
> +               /* Anything ARMv8.1+ has the same value. For now. */

Nit: Shouldn't the comment also mention NI (and IMP_DEF) ?
(I have the same comment for pmuver_to_perfmon in the patch-10)

Otherwise:
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji

> +               return perfmon;
> +       }
> +}
> +
>  static u8 pmuver_to_perfmon(u8 pmuver)
>  {
>         switch (pmuver) {
> @@ -1281,6 +1294,46 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +                          const struct sys_reg_desc *rd,
> +                          u64 val)
> +{
> +       u8 perfmon, host_perfmon;
> +       bool valid_pmu;
> +
> +       host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
> +
> +       /*
> +        * Allow DFR0_EL1.PerfMon to be set from userspace as long as
> +        * it doesn't promise more than what the HW gives us on the
> +        * AArch64 side (as everything is emulated with that), and
> +        * that this is a PMUv3.
> +        */
> +       perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_PERFMON), val);
> +       if ((perfmon != ID_DFR0_PERFMON_IMP_DEF && perfmon > host_perfmon) ||
> +           (perfmon != 0 && perfmon < ID_DFR0_PERFMON_8_0))
> +               return -EINVAL;
> +
> +       valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_PERFMON_IMP_DEF);
> +
> +       /* Make sure view register and PMU support do match */
> +       if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
> +               return -EINVAL;
> +
> +       /* We can only differ with PerfMon, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd);
> +       val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
> +       if (val)
> +               return -EINVAL;
> +
> +       if (valid_pmu)
> +               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> +       else
> +               vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> +
> +       return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1502,7 +1555,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         /* CRm=1 */
>         AA32_ID_SANITISED(ID_PFR0_EL1),
>         AA32_ID_SANITISED(ID_PFR1_EL1),
> -       AA32_ID_SANITISED(ID_DFR0_EL1),
> +       { SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
> +         .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
> +         .visibility = aa32_id_visibility, },
>         ID_HIDDEN(ID_AFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR1_EL1),
> --
> 2.34.1
>
