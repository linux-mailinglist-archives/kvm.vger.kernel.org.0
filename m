Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BBC5A209E
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 08:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiHZGCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 02:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHZGCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 02:02:42 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72D2BD085
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 23:02:38 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id j4so245332vki.0
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 23:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Yu6V3HoqcT85l6PQ22nYw9REHjCJdFZCIGnABb74KYo=;
        b=GJjCCMpexDrT1ERmSj1vPwkGA1PEEBenI4/WAPt46L11Y1dY0AzCOp+o1SCGio+GXH
         TLuLYxJG5Ji6LxHVJ72J0qcdjXOd0/Y1sEZyr6aUxyWPL77pkmXNY2IHLvEQiTfTER5c
         hNx43A3AMiBCysEVphbH1uTFRKTNX+Pf1S6mlOkNmLW17DDXuRJy16x/G6ol4EdF1Ulh
         NRyCJCNfJw0I7GvWUEq6dBynhDMrpyOSFSuXcwXoB0AWDtx81lbJu9Zog95D6JjqhRgZ
         y3IKKgPHnaEfnGRQB435j6limvkx4BfM6RHRQzxz2LQAbUgWL/Idxchi1hY4RBhj5Qj+
         LFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Yu6V3HoqcT85l6PQ22nYw9REHjCJdFZCIGnABb74KYo=;
        b=swAilVM7Z9I1B16geFnzuHbDFBO55HOWkDtmZx1/FVX5BkGG9cPkD9I/6EYymT4zxh
         TU/5/Cy2gCwjuFOg9hUaO1SNhaVLq0Ve3P2CH+uqx7lYlGKcJa1PtJonl0BmQTDKSSrq
         1PiGqGnEBuEHYi7uW6XtPeg7Qx+4rYUYhd8Lo2Ph3J3J4pGGtt/Neawpn/CJI4RYbnQk
         gdEJ9rCibWiyUiGw5NYERlWSafrBhvvsfrqXstDPteSslEawmuhotrH+OKW5dIZhl1MB
         pB3n9GUaGG6CSEc0DWEn9CQCopS+3um5S5AVaU5dhRhh7RpJ8BmKCkd3/xvFl0zAONHP
         +Jlg==
X-Gm-Message-State: ACgBeo3xx7BJ6n4FjmmRPL5u7XVkOcycKHRneDC4QCHlI4EcNQyuPYgV
        cg/WQyBz0m4sCWvVyIEC9ruGjWFP3Mi8FFdv2OCh9HJVv083JA==
X-Google-Smtp-Source: AA6agR47I6NvoK6nrrGb/91E4qiOVdsRptI14ryo8aHlLw197SyUcKq4Z6SKG9ZcuqMMk9PaUXBdo+pQsbVJhnxo378=
X-Received: by 2002:a05:6122:1881:b0:38c:4d0b:f005 with SMTP id
 bi1-20020a056122188100b0038c4d0bf005mr2699530vkb.4.1661493757861; Thu, 25 Aug
 2022 23:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-7-maz@kernel.org>
 <CAAeT=FzXyr7D24QCcwGckgnPFuo8QtN3GrPg9h+s+3uGETE9Dw@mail.gmail.com>
In-Reply-To: <CAAeT=FzXyr7D24QCcwGckgnPFuo8QtN3GrPg9h+s+3uGETE9Dw@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 25 Aug 2022 23:02:21 -0700
Message-ID: <CAAeT=FxheB7HKFxyZwE8LJSjRzxRXQYb7_uQYF9o1hMV6Dow-g@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Aug 25, 2022 at 9:34 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Marc,
>
> On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > As further patches will enable the selection of a PMU revision
> > from userspace, sample the supported PMU revision at VM creation
> > time, rather than building each time the ID_AA64DFR0_EL1 register
> > is accessed.
> >
> > This shouldn't result in any change in behaviour.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/arm.c              |  6 ++++++
> >  arch/arm64/kvm/pmu-emul.c         | 11 +++++++++++
> >  arch/arm64/kvm/sys_regs.c         | 26 +++++++++++++++++++++-----
> >  include/kvm/arm_pmu.h             |  6 ++++++
> >  5 files changed, 45 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f38ef299f13b..411114510634 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -163,6 +163,7 @@ struct kvm_arch {
> >
> >         u8 pfr0_csv2;
> >         u8 pfr0_csv3;
> > +       u8 dfr0_pmuver;
> >
> >         /* Hypercall features firmware registers' descriptor */
> >         struct kvm_smccc_features smccc_feat;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 8fe73ee5fa84..e4f80f0c1e97 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -164,6 +164,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >         set_default_spectre(kvm);
> >         kvm_arm_init_hypercalls(kvm);
> >
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_host_pmuver();
> > +
> >         return ret;
> >  out_free_stage2_pgd:
> >         kvm_free_stage2_pgd(&kvm->arch.mmu);
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index ddd79b64b38a..33a88ca7b7fd 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -1021,3 +1021,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >
> >         return -ENXIO;
> >  }
> > +
> > +u8 kvm_arm_pmu_get_host_pmuver(void)
>
> Nit: Since this function doesn't simply return the host's pmuver, but the
> pmuver limit for guests, perhaps "kvm_arm_pmu_get_guest_pmuver_limit"
> might be more clear (closer to what it does) ?
>
> > +{
> > +       u64 tmp;
> > +
> > +       tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > +       tmp = cpuid_feature_cap_perfmon_field(tmp,
> > +                                             ID_AA64DFR0_PMUVER_SHIFT,
> > +                                             ID_AA64DFR0_PMUVER_8_4);
> > +       return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
> > +}
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 333efddb1e27..55451f49017c 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1062,6 +1062,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >         return true;
> >  }
> >
> > +static u8 pmuver_to_perfmon(const struct kvm_vcpu *vcpu)
> > +{
> > +       if (!kvm_vcpu_has_pmu(vcpu))
> > +               return 0;
> > +
> > +       switch (vcpu->kvm->arch.dfr0_pmuver) {
> > +       case ID_AA64DFR0_PMUVER_8_0:
> > +               return ID_DFR0_PERFMON_8_0;
> > +       case ID_AA64DFR0_PMUVER_IMP_DEF:
> > +               return 0;
> > +       default:
> > +               /* Anything ARMv8.4+ has the same value. For now. */
> > +               return vcpu->kvm->arch.dfr0_pmuver;
> > +       }
> > +}
> > +
> >  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >                 struct sys_reg_desc const *r, bool raz)
> > @@ -1112,10 +1128,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >                 /* Limit debug to ARMv8.0 */
> >                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
> >                 val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
> > -               /* Limit guests to PMUv3 for ARMv8.4 */
> > -               val = cpuid_feature_cap_perfmon_field(val,
> > -                                                     ID_AA64DFR0_PMUVER_SHIFT,
> > -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
> > +               /* Set PMUver to the required version */
> > +               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
> > +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
> > +                                 kvm_vcpu_has_pmu(vcpu) ? vcpu->kvm->arch.dfr0_pmuver : 0);

I've just noticed one issue in this patch while I'm reviewing patch-7.

I would think that this patch makes PMUVER and PERFMON inconsistent
when PMU is not enabled for the vCPU, and the host's sanitised PMUVER
is IMP_DEF.

Previously, when PMU is not enabled for the vCPU and the host's
sanitized value of PMUVER is IMP_DEF(0xf), the vCPU's PMUVER and PERFMON
are set to IMP_DEF due to a bug of cpuid_feature_cap_perfmon_field().
(https://lore.kernel.org/all/20220214065746.1230608-11-reijiw@google.com/)

With this patch, the vCPU's PMUVER will be 0 for the same case,
while the vCPU's PERFMON will stay the same (IMP_DEF).
I guess you unintentionally corrected only the PMUVER value of the VCPU.

Thank you,
Reiji

> >                 /* Hide SPE from guests */
> >                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
> >                 break;
> > @@ -1123,7 +1139,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >                 /* Limit guests to PMUv3 for ARMv8.4 */
>
> Nit: I think the comment above should be removed like you did for
> ID_AA64DFR0_EL1 (or move it to kvm_arm_pmu_get_host_pmuver()?).
>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
>
> Thank you,
> Reiji
>
>
>
> >                 val = cpuid_feature_cap_perfmon_field(val,
> >                                                       ID_DFR0_PERFMON_SHIFT,
> > -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> > +                                                     pmuver_to_perfmon(vcpu));
> >                 break;
> >         }
> >
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 96b192139a23..6bda9b071084 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -89,6 +89,8 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >                         vcpu->arch.pmu.events = *kvm_get_pmu_events();  \
> >         } while (0)
> >
> > +u8 kvm_arm_pmu_get_host_pmuver(void);
> > +
> >  #else
> >  struct kvm_pmu {
> >  };
> > @@ -154,6 +156,10 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
> >  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> > +static inline u8 kvm_arm_pmu_get_host_pmuver(void)
> > +{
> > +       return 0;
> > +}
> >
> >  #endif
> >
> > --
> > 2.34.1
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
