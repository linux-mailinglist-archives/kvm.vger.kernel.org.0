Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7852F60FCA7
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiJ0QJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbiJ0QJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:09:39 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D382F5F75
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:09:36 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 128so1939141pga.1
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b5rwX8OLkcub7N0+UK3cCK9WK2wAdTnWTeCnUPc2DXE=;
        b=AlAdovnXgLBDsanfOFyH0OiPOg7CGXqfP+gRb5Pl1FIMOXuEHZ0QT+0GO+TK3KmGGR
         x4DN7yp4QebP1cIvUwDsha4syhk2VfLEH/aQDBeMRacqouMPplQtHixlUXjbGdKt7mo5
         KTmTp5etOnnaxiLHxsrB1mEjmz7/qZjHpmVgTqwqcKh1icHd06WsDRSoUKaUpSqdnKPo
         UdYQ4c0iLM2Oa1JZnFoAm2YVK3GvJq/iQ7gOfDggtT4go7bpRNmQ9etdAqA6eNFZnchP
         75hVajv1jboIYlXfgiVVSQOE7wNxC2OrjXDn4kp3AvC3RLbR59vLTLUAeWux1jy1Mxif
         fH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b5rwX8OLkcub7N0+UK3cCK9WK2wAdTnWTeCnUPc2DXE=;
        b=Wef83zIwzyjj9qWGMn6MCzjsh7wXz/J5sP8TxUPJDN+sOPXBZiyjIDB5jKX45rP/xs
         /taUl8oFE/n/YkuF3SrDIgLYL73IZtMxf+gNUaN+Bhf/FnQHPCKlfQSm87Zjm/Fhvu3x
         OMXQ/4eDSaVKPJ/kq0MyMMJEObkr7V4ARGESAeY//uaM2HHUvnDnDtlffM6OUFS/hVPo
         GxRRUfGSCaIFcOPlfYnL3L17Hq6aLaQxUdn2TaaWBPh775ZH1kG6DVs+dZYwuCliCdu7
         1hBOxy9WRuvgdnqjAee43cj2c3H5Ma+uu74w0LNryUuYiCeDymQSRCgA50tmqlBmtqKd
         bSwQ==
X-Gm-Message-State: ACrzQf02/QScsoIUozttglocN+AV48N0D9u7HlFpn2+ULuBWUMRbrcl1
        zx/yoQF0nJ06F26M/U93HPhpwrK3WQGI+SHl7KFtig==
X-Google-Smtp-Source: AMsMyM7BPqhZVGGqV02vF8Yf3Cxcn7J2E/AfX0gtaXtp7sz1THntxvYt/8nbMcNZ5AV0sfVg0aOWchZX61YXVo/MrLE=
X-Received: by 2002:a05:6a00:148e:b0:56c:71c4:dff6 with SMTP id
 v14-20020a056a00148e00b0056c71c4dff6mr7650959pfu.84.1666886976115; Thu, 27
 Oct 2022 09:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-7-maz@kernel.org>
 <CAAeT=FzXyr7D24QCcwGckgnPFuo8QtN3GrPg9h+s+3uGETE9Dw@mail.gmail.com>
 <CAAeT=FxheB7HKFxyZwE8LJSjRzxRXQYb7_uQYF9o1hMV6Dow-g@mail.gmail.com> <86k04mejd0.wl-maz@kernel.org>
In-Reply-To: <86k04mejd0.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 27 Oct 2022 09:09:19 -0700
Message-ID: <CAAeT=FwFS+oTG3Q0sDMyobfQst2TWUqyU4XQFmmELPS1rwp96w@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
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

> Sorry it took so long to get back to this.

No problem!

>
> On Fri, 26 Aug 2022 07:02:21 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Thu, Aug 25, 2022 at 9:34 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Marc,
> > >
> > > On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > As further patches will enable the selection of a PMU revision
> > > > from userspace, sample the supported PMU revision at VM creation
> > > > time, rather than building each time the ID_AA64DFR0_EL1 register
> > > > is accessed.
> > > >
> > > > This shouldn't result in any change in behaviour.
> > > >
> > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  1 +
> > > >  arch/arm64/kvm/arm.c              |  6 ++++++
> > > >  arch/arm64/kvm/pmu-emul.c         | 11 +++++++++++
> > > >  arch/arm64/kvm/sys_regs.c         | 26 +++++++++++++++++++++-----
> > > >  include/kvm/arm_pmu.h             |  6 ++++++
> > > >  5 files changed, 45 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index f38ef299f13b..411114510634 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -163,6 +163,7 @@ struct kvm_arch {
> > > >
> > > >         u8 pfr0_csv2;
> > > >         u8 pfr0_csv3;
> > > > +       u8 dfr0_pmuver;
> > > >
> > > >         /* Hypercall features firmware registers' descriptor */
> > > >         struct kvm_smccc_features smccc_feat;
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index 8fe73ee5fa84..e4f80f0c1e97 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -164,6 +164,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > > >         set_default_spectre(kvm);
> > > >         kvm_arm_init_hypercalls(kvm);
> > > >
> > > > +       /*
> > > > +        * Initialise the default PMUver before there is a chance to
> > > > +        * create an actual PMU.
> > > > +        */
> > > > +       kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_host_pmuver();
> > > > +
> > > >         return ret;
> > > >  out_free_stage2_pgd:
> > > >         kvm_free_stage2_pgd(&kvm->arch.mmu);
> > > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > > index ddd79b64b38a..33a88ca7b7fd 100644
> > > > --- a/arch/arm64/kvm/pmu-emul.c
> > > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > > @@ -1021,3 +1021,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > > >
> > > >         return -ENXIO;
> > > >  }
> > > > +
> > > > +u8 kvm_arm_pmu_get_host_pmuver(void)
> > >
> > > Nit: Since this function doesn't simply return the host's pmuver, but the
> > > pmuver limit for guests, perhaps "kvm_arm_pmu_get_guest_pmuver_limit"
> > > might be more clear (closer to what it does) ?
>
> Maybe a bit verbose, but I'll work something out.
>
> > >
> > > > +{
> > > > +       u64 tmp;
> > > > +
> > > > +       tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > > > +       tmp = cpuid_feature_cap_perfmon_field(tmp,
> > > > +                                             ID_AA64DFR0_PMUVER_SHIFT,
> > > > +                                             ID_AA64DFR0_PMUVER_8_4);
> > > > +       return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
> > > > +}
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index 333efddb1e27..55451f49017c 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -1062,6 +1062,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> > > >         return true;
> > > >  }
> > > >
> > > > +static u8 pmuver_to_perfmon(const struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       if (!kvm_vcpu_has_pmu(vcpu))
> > > > +               return 0;
> > > > +
> > > > +       switch (vcpu->kvm->arch.dfr0_pmuver) {
> > > > +       case ID_AA64DFR0_PMUVER_8_0:
> > > > +               return ID_DFR0_PERFMON_8_0;
> > > > +       case ID_AA64DFR0_PMUVER_IMP_DEF:
> > > > +               return 0;
> > > > +       default:
> > > > +               /* Anything ARMv8.4+ has the same value. For now. */
> > > > +               return vcpu->kvm->arch.dfr0_pmuver;
> > > > +       }
> > > > +}
> > > > +
> > > >  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > > >                 struct sys_reg_desc const *r, bool raz)
> > > > @@ -1112,10 +1128,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > > >                 /* Limit debug to ARMv8.0 */
> > > >                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
> > > >                 val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
> > > > -               /* Limit guests to PMUv3 for ARMv8.4 */
> > > > -               val = cpuid_feature_cap_perfmon_field(val,
> > > > -                                                     ID_AA64DFR0_PMUVER_SHIFT,
> > > > -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
> > > > +               /* Set PMUver to the required version */
> > > > +               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
> > > > +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
> > > > +                                 kvm_vcpu_has_pmu(vcpu) ? vcpu->kvm->arch.dfr0_pmuver : 0);
> >
> > I've just noticed one issue in this patch while I'm reviewing patch-7.
> >
> > I would think that this patch makes PMUVER and PERFMON inconsistent
> > when PMU is not enabled for the vCPU, and the host's sanitised PMUVER
> > is IMP_DEF.
> >
> > Previously, when PMU is not enabled for the vCPU and the host's
> > sanitized value of PMUVER is IMP_DEF(0xf), the vCPU's PMUVER and PERFMON
> > are set to IMP_DEF due to a bug of cpuid_feature_cap_perfmon_field().
> > (https://lore.kernel.org/all/20220214065746.1230608-11-reijiw@google.com/)
> >
> > With this patch, the vCPU's PMUVER will be 0 for the same case,
> > while the vCPU's PERFMON will stay the same (IMP_DEF).
> > I guess you unintentionally corrected only the PMUVER value of the VCPU.
>
> I think that with this patch both PMUVer and Perfmon values get set to
> 0 (pmuver_to_perfmon() returns 0 for both ID_AA64DFR0_PMUVER_IMP_DEF
> and no PMU at all). Am I missing anything here?

> > With this patch, the vCPU's PMUVER will be 0 for the same case,
> > while the vCPU's PERFMON will stay the same (IMP_DEF).
> > I guess you unintentionally corrected only the PMUVER value of the VCPU.
>
> I think that with this patch both PMUVer and Perfmon values get set to
> 0 (pmuver_to_perfmon() returns 0 for both ID_AA64DFR0_PMUVER_IMP_DEF
> and no PMU at all). Am I missing anything here?

When pmuver_to_perfmon() returns 0 for ID_AA64DFR0_PMUVER_IMP_DEF,
cpuid_feature_cap_perfmon_field() is called with 'cap' == 0.  Then,
the code in cpuid_feature_cap_perfmon_field() updates the 'val' with 0
if the given 'features' (sanitized) value is ID_AA64DFR0_PMUVER_IMP_DEF.
So, now the val(== 0) is not larger than the cap (== 0), and
cpuid_feature_cap_perfmon_field() ends up returning the given 'features'
value as it is without updating the PERFMON field.

Or am I missing anything here?

Thank you,
Reiji


>
> However, you definitely have a point that we should handle a guest
> being restored with an IMPDEF PMU. Which means I need to revisit this
> patch and the userspace accessors. Oh well...
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
