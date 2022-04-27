Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D9951201B
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244547AbiD0SBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 14:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244483AbiD0SBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 14:01:03 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B63432F2D5
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 10:57:51 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2ec42eae76bso27593117b3.10
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 10:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hA6N5h7NH/bduf+AHlY7bpb0csNzyhAnMJDChQJ7/OY=;
        b=DEpT18aU6lFt3aVeFqxNp0MVt7oFsb9GgMQGSnFGuSdtCCTOKCP3x9l+gwFp/CsvBp
         uL+LMV88I6cvKZKupchr28o78x37Sp5gS977kphSB7LYjzFMovm1+OkotgGUsRhZkCt5
         PnncW5mNbZX6GCxTfAwbRxcW2z05juxSGj36ddm8kAT7LSvJesoF/XzSBYRIfHSYsVH9
         4E+cgwOqdwiDCUj2WYV2ZEFvoFDienepWKxDMdUC74dMoN/iGmqjz1GdRmjIeISArJz6
         BgMdJRgG1qsCgPCjBo/anXONg9zrrIlMUmy8SOVMjrnVYE1+ur5plxbMo1X0c9qMYj8x
         4LhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hA6N5h7NH/bduf+AHlY7bpb0csNzyhAnMJDChQJ7/OY=;
        b=3nJNsua1F/i2L4g88fGMLouNmfBJRsrMCZefzggLRYokqobpXJgbLxBCA7uw/8weo0
         B55IUFmJ5M4eUcTxkNeJs9h1O6EcYsueVJk2YW4MGeHlhAY2fwXNs0vyNo3j0osOFpYc
         QF3MtO2J543YzezUtwncsV4zzPedeN+OYNxns3vWgbLL9OEUglovZGm3bfea20wxdLyS
         bvdw84NW4Vja5pzQfw0/ZIlyKQ9MLR6yh1bAge2UaKg78XGKTuZ+kmIr8wLWQtmFYOcq
         jPSLJ5yEWbZ5pX0xyDskMLRJOQJShVy9sbnYtj22ixbNiPLf0gDFoxbYAXSQgchesJte
         jqDw==
X-Gm-Message-State: AOAM5328x0WPb9BSEC0E5lwI1phKGv97c6q/ypv/Oe0fVIzb4FB6LVpO
        dVd4T1qdsSjipO5mC/zZY1VqXSGDP3s+DdyIrz/Apw==
X-Google-Smtp-Source: ABdhPJzYJbXSdZY8L7KaaOeF5QEdC2CsDDiDcoFSR6S4TbfHpfjQJvBiHzFb0+efrwRtKKkGw7brYIgLDPz+PxS99L4=
X-Received: by 2002:a81:d12:0:b0:2f4:e6c6:9caf with SMTP id
 18-20020a810d12000000b002f4e6c69cafmr26893959ywn.91.1651082269906; Wed, 27
 Apr 2022 10:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-3-rananta@google.com>
 <CAAeT=Fyv2Hc1oPb=UiDUvCSpzS9iYbEPBCvXuskBniTcOKfA5g@mail.gmail.com>
 <CAJHc60z3kiQMkdj4wQ2ixmd-MaA5bQT0SwDQYcUbACMaAOWrSg@mail.gmail.com> <CAAeT=FwcbpVW1PzAqbv+eDSXnA1_80a+-r78YpOrd3fZ9MYk5A@mail.gmail.com>
In-Reply-To: <CAAeT=FwcbpVW1PzAqbv+eDSXnA1_80a+-r78YpOrd3fZ9MYk5A@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 27 Apr 2022 10:57:39 -0700
Message-ID: <CAJHc60webDt4x6PW3WWh4FxGE7x8hSTrUkPganFMwwqYTLZUtA@mail.gmail.com>
Subject: Re: [PATCH v6 2/9] KVM: arm64: Setup a framework for hypercall bitmap
 firmware registers
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

On Tue, Apr 26, 2022 at 6:46 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Raghu,
>
> On Mon, Apr 25, 2022 at 9:46 AM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Sun, Apr 24, 2022 at 9:52 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Raghu,
> > >
> > > On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > KVM regularly introduces new hypercall services to the guests without
> > > > any consent from the userspace. This means, the guests can observe
> > > > hypercall services in and out as they migrate across various host
> > > > kernel versions. This could be a major problem if the guest
> > > > discovered a hypercall, started using it, and after getting migrated
> > > > to an older kernel realizes that it's no longer available. Depending
> > > > on how the guest handles the change, there's a potential chance that
> > > > the guest would just panic.
> > > >
> > > > As a result, there's a need for the userspace to elect the services
> > > > that it wishes the guest to discover. It can elect these services
> > > > based on the kernels spread across its (migration) fleet. To remedy
> > > > this, extend the existing firmware pseudo-registers, such as
> > > > KVM_REG_ARM_PSCI_VERSION, but by creating a new COPROC register space
> > > > for all the hypercall services available.
> > > >
> > > > These firmware registers are categorized based on the service call
> > > > owners, but unlike the existing firmware pseudo-registers, they hold
> > > > the features supported in the form of a bitmap.
> > > >
> > > > During the VM initialization, the registers are set to upper-limit of
> > > > the features supported by the corresponding registers. It's expected
> > > > that the VMMs discover the features provided by each register via
> > > > GET_ONE_REG, and write back the desired values using SET_ONE_REG.
> > > > KVM allows this modification only until the VM has started.
> > > >
> > > > Some of the standard features are not mapped to any bits of the
> > > > registers. But since they can recreate the original problem of
> > > > making it available without userspace's consent, they need to
> > > > be explicitly added to the case-list in
> > > > kvm_hvc_call_default_allowed(). Any function-id that's not enabled
> > > > via the bitmap, or not listed in kvm_hvc_call_default_allowed, will
> > > > be returned as SMCCC_RET_NOT_SUPPORTED to the guest.
> > > >
> > > > Older userspace code can simply ignore the feature and the
> > > > hypercall services will be exposed unconditionally to the guests,
> > > > thus ensuring backward compatibility.
> > > >
> > > > In this patch, the framework adds the register only for ARM's standard
> > > > secure services (owner value 4). Currently, this includes support only
> > > > for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> > > > register representing mandatory features of v1.0. Other services are
> > > > momentarily added in the upcoming patches.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h | 12 ++++
> > > >  arch/arm64/include/uapi/asm/kvm.h |  9 +++
> > > >  arch/arm64/kvm/arm.c              |  1 +
> > > >  arch/arm64/kvm/guest.c            |  8 ++-
> > > >  arch/arm64/kvm/hypercalls.c       | 94 +++++++++++++++++++++++++++++++
> > > >  arch/arm64/kvm/psci.c             | 13 +++++
> > > >  include/kvm/arm_hypercalls.h      |  6 ++
> > > >  include/kvm/arm_psci.h            |  2 +-
> > > >  8 files changed, 142 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index 94a27a7520f4..df07f4c10197 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
> > > >  struct kvm_arch_memory_slot {
> > > >  };
> > > >
> > > > +/**
> > > > + * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
> > > > + *
> > > > + * @std_bmap: Bitmap of standard secure service calls
> > > > + */
> > > > +struct kvm_smccc_features {
> > > > +       unsigned long std_bmap;
> > > > +};
> > > > +
> > > >  struct kvm_arch {
> > > >         struct kvm_s2_mmu mmu;
> > > >
> > > > @@ -150,6 +159,9 @@ struct kvm_arch {
> > > >
> > > >         u8 pfr0_csv2;
> > > >         u8 pfr0_csv3;
> > > > +
> > > > +       /* Hypercall features firmware registers' descriptor */
> > > > +       struct kvm_smccc_features smccc_feat;
> > > >  };
> > > >
> > > >  struct kvm_vcpu_fault_info {
> > > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > > index c1b6ddc02d2f..0b79d2dc6ffd 100644
> > > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > > @@ -332,6 +332,15 @@ struct kvm_arm_copy_mte_tags {
> > > >  #define KVM_ARM64_SVE_VLS_WORDS        \
> > > >         ((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> > > >
> > > > +/* Bitmap feature firmware registers */
> > > > +#define KVM_REG_ARM_FW_FEAT_BMAP               (0x0016 << KVM_REG_ARM_COPROC_SHIFT)
> > > > +#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)                (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> > > > +                                               KVM_REG_ARM_FW_FEAT_BMAP |      \
> > > > +                                               ((r) & 0xffff))
> > > > +
> > > > +#define KVM_REG_ARM_STD_BMAP                   KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
> > > > +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0          0
> > > > +
> > > >  /* Device Control API: ARM VGIC */
> > > >  #define KVM_DEV_ARM_VGIC_GRP_ADDR      0
> > > >  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index 523bc934fe2f..a37fadbd617e 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > > >         kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> > > >
> > > >         set_default_spectre(kvm);
> > > > +       kvm_arm_init_hypercalls(kvm);
> > > >
> > > >         return ret;
> > > >  out_free_stage2_pgd:
> > > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > > index 0d5cca56cbda..8c607199cad1 100644
> > > > --- a/arch/arm64/kvm/guest.c
> > > > +++ b/arch/arm64/kvm/guest.c
> > > > @@ -756,7 +756,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >
> > > >         switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> > > >         case KVM_REG_ARM_CORE:  return get_core_reg(vcpu, reg);
> > > > -       case KVM_REG_ARM_FW:    return kvm_arm_get_fw_reg(vcpu, reg);
> > > > +       case KVM_REG_ARM_FW:
> > > > +       case KVM_REG_ARM_FW_FEAT_BMAP:
> > > > +               return kvm_arm_get_fw_reg(vcpu, reg);
> > > >         case KVM_REG_ARM64_SVE: return get_sve_reg(vcpu, reg);
> > > >         }
> > > >
> > > > @@ -774,7 +776,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >
> > > >         switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> > > >         case KVM_REG_ARM_CORE:  return set_core_reg(vcpu, reg);
> > > > -       case KVM_REG_ARM_FW:    return kvm_arm_set_fw_reg(vcpu, reg);
> > > > +       case KVM_REG_ARM_FW:
> > > > +       case KVM_REG_ARM_FW_FEAT_BMAP:
> > > > +               return kvm_arm_set_fw_reg(vcpu, reg);
> > > >         case KVM_REG_ARM64_SVE: return set_sve_reg(vcpu, reg);
> > > >         }
> > > >
> > > > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > > > index fa6d9378d8e7..df55a04d2fe8 100644
> > > > --- a/arch/arm64/kvm/hypercalls.c
> > > > +++ b/arch/arm64/kvm/hypercalls.c
> > > > @@ -58,6 +58,48 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> > > >         val[3] = lower_32_bits(cycles);
> > > >  }
> > > >
> > > > +static bool kvm_arm_fw_reg_feat_enabled(unsigned long *reg_bmap, unsigned long feat_bit)
> > > > +{
> > > > +       return test_bit(feat_bit, reg_bmap);
> > > > +}
> > > > +
> > > > +static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> > > > +{
> > > > +       switch (func_id) {
> > > > +       /*
> > > > +        * List of function-ids that are not gated with the bitmapped feature
> > > > +        * firmware registers, and are to be allowed for servicing the call by default.
> > > > +        */
> > > > +       case ARM_SMCCC_VERSION_FUNC_ID:
> > > > +       case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > > > +       case ARM_SMCCC_HV_PV_TIME_FEATURES:
> > > > +       case ARM_SMCCC_HV_PV_TIME_ST:
> > > > +       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> > > > +       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > > > +       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > > > +               return true;
> > > > +       default:
> > > > +               return kvm_psci_func_id_is_valid(vcpu, func_id);
> > > > +       }
> > > > +}
> > > > +
> > > > +static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> > > > +{
> > > > +       struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> > > > +
> > > > +       switch (func_id) {
> > > > +       case ARM_SMCCC_TRNG_VERSION:
> > > > +       case ARM_SMCCC_TRNG_FEATURES:
> > > > +       case ARM_SMCCC_TRNG_GET_UUID:
> > > > +       case ARM_SMCCC_TRNG_RND32:
> > > > +       case ARM_SMCCC_TRNG_RND64:
> > > > +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
> > > > +                                               KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> > > > +       default:
> > > > +               return kvm_hvc_call_default_allowed(vcpu, func_id);
> > > > +       }
> > > > +}
> > > > +
> > > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > > >  {
> > > >         u32 func_id = smccc_get_function(vcpu);
> > > > @@ -65,6 +107,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > > >         u32 feature;
> > > >         gpa_t gpa;
> > > >
> > > > +       if (!kvm_hvc_call_allowed(vcpu, func_id))
> > > > +               goto out;
> > > > +
> > > >         switch (func_id) {
> > > >         case ARM_SMCCC_VERSION_FUNC_ID:
> > > >                 val[0] = ARM_SMCCC_VERSION_1_1;
> > > > @@ -155,6 +200,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > > >                 return kvm_psci_call(vcpu);
> > > >         }
> > > >
> > > > +out:
> > > >         smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> > > >         return 1;
> > > >  }
> > > > @@ -164,8 +210,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> > > >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> > > >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > > >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> > > > +       KVM_REG_ARM_STD_BMAP,
> > > >  };
> > > >
> > > > +void kvm_arm_init_hypercalls(struct kvm *kvm)
> > > > +{
> > > > +       struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> > > > +
> > > > +       smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> > > > +}
> > > > +
> > > >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > > >  {
> > > >         return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> > > > @@ -237,6 +291,7 @@ static int get_kernel_wa_level(u64 regid)
> > > >
> > > >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >  {
> > > > +       struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> > > >         void __user *uaddr = (void __user *)(long)reg->addr;
> > > >         u64 val;
> > > >
> > > > @@ -249,6 +304,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >         case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> > > >                 val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> > > >                 break;
> > > > +       case KVM_REG_ARM_STD_BMAP:
> > > > +               val = READ_ONCE(smccc_feat->std_bmap);
> > > > +               break;
> > > >         default:
> > > >                 return -ENOENT;
> > > >         }
> > > > @@ -259,6 +317,40 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> > > > +{
> > > > +       int ret = 0;
> > > > +       struct kvm *kvm = vcpu->kvm;
> > > > +       struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> > > > +       unsigned long *fw_reg_bmap, fw_reg_features;
> > > > +
> > > > +       switch (reg_id) {
> > > > +       case KVM_REG_ARM_STD_BMAP:
> > > > +               fw_reg_bmap = &smccc_feat->std_bmap;
> > > > +               fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
> > > > +               break;
> > > > +       default:
> > > > +               return -ENOENT;
> > > > +       }
> > > > +
> > > > +       /* Check for unsupported bit */
> > > > +       if (val & ~fw_reg_features)
> > > > +               return -EINVAL;
> > > > +
> > > > +       mutex_lock(&kvm->lock);
> > >
> > > Why don't you check if the register value will be modified before
> > > getting the lock ? (then there is nothing to do)
> > > It would help reduce unnecessary serialization for live migration
> > > (even without the vm-scoped register capability).
> > >
> > That was the case until v5. Since v6, we return -EBUSY unconditionally
> > regardless of the incoming value. See Marc's comments in [1].
>
> > That was the case until v5. Since v6, we return -EBUSY unconditionally
> > regardless of the incoming value. See Marc's comments in [1].
>
> Even with that, the function could do below to avoid
> the unnecessary serialization.
> (I would expect mostly the function returns before getting the lock)
>
>         if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags))
>               return -EBUSY;
>
>         if (val == *fw_reg_bmap)
>               return 0;
>
>         mutex_lock(&kvm->lock);
>
>         <...>
>
Great idea! I can try this out. Thanks for the suggestion.

> > >
> > >
> > > > +
> > > > +       /* Return -EBUSY if the VM (any vCPU) has already started running. */
> > > > +       if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> > > > +               ret = -EBUSY;
> > > > +               goto out;
> > > > +       }
> > >
> > > I just would like to make sure that you are sure that existing
> > > userspace you know will not run KVM_RUN for any vCPUs until
> > > KVM_SET_ONE_REG is complete for all vCPUs (even for migration),
> > > correct ?
> > >
> > Since v6, that is something that we are leaving with the userspace to
> > synchronize. See [1].
>
> Understood.
>
>
> > > > +o
> > > > +       WRITE_ONCE(*fw_reg_bmap, val);
> > > > +out:
> > > > +       mutex_unlock(&kvm->lock);
> > > > +       return ret;
> > > > +}
> > > > +
> > > >  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >  {
> > > >         void __user *uaddr = (void __user *)(long)reg->addr;
> > > > @@ -337,6 +429,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >                         return -EINVAL;
> > > >
> > > >                 return 0;
> > > > +       case KVM_REG_ARM_STD_BMAP:
> > > > +               return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
> > > >         default:
> > > >                 return -ENOENT;
> > > >         }
> > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > index 346535169faa..67d1273e8086 100644
> > > > --- a/arch/arm64/kvm/psci.c
> > > > +++ b/arch/arm64/kvm/psci.c
> > > > @@ -436,3 +436,16 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
> > > >                 return -EINVAL;
> > > >         }
> > > >  }
> > > > +
> > > > +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id)
> > > > +{
> > > > +       /* PSCI 0.1 doesn't comply with the standard SMCCC */
> > > > +       if (kvm_psci_version(vcpu) == KVM_ARM_PSCI_0_1)
> > > > +               return (func_id == KVM_PSCI_FN_CPU_OFF || func_id == KVM_PSCI_FN_CPU_ON);
> > > > +
> > > > +       if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
> > > > +               ARM_SMCCC_FUNC_NUM(func_id) >= 0 && ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
> > > > +               return true;
> > >
> > > For PSCI 0.1, the function checks if the funct_id is valid for
> > > the vCPU (according to the vCPU's PSCI version).
> > > For other version of PSCI, the function doesn't care the vCPU's
> > > PSCI version (although supported functions depend on the PSCI
> > > version and not all of them are defined yet, the code returns
> > > true as long as the function id is within the reserved PSCI
> > > function id range).
> > > So, the behavior appears to be inconsistent.
> > > Shouldn't it return the validity of the function id according
> > > to the vCPU's psci version for non-PSCI 0.1 case as well ?
> > > (Otherwise, shouldn't it return true if the function id is valid
> > > for any of the PSCI versions ?)
> > >
> > Well, PSCI 1.0 is somewhat of an odd implementation. It doesn't comply
> > with the SMCCC, hence needed some special handling. Only two func_ids> are currently supported by KVM, and we just check for each. The second
> > 'if' statement is for all the PSCI versions >= 0.2. Thankfully, the
> > specification defines a range of acceptable PSCI func_ids.
>
> I understand PSCI 0.1 is different from PSCI 0.2 or newer versions.
> But, my question is: What would you consider "valid" psci function id ?
> It seems that the function checks whether or not the func_id is valid
> on the vCPU for PSCI 0.1, and checks whether or not the func_id is a
> PSCI function id for vCPU with PSCI 0.2 or newer.
>
> I understand either one works for your purpose, but I would think
> the behavior should be consistent.
>
I guess checking for the version caused the confusion here, but that
was done since there isn't a standard way to check the 0.1's range of
func_ids. Alternatively, instead of version, since the base of the
0.1's range is different as well, I can just check for that to avoid
the confusion (no functional change though).

Thank you.
Raghavendra
> Thanks,
> Reiji
>
>
> >
> > If it's confusing, I can add a comment above the second 'if' that it's
> > for all PSCI versions >= 0.2.
> > > Thanks,
> > > Reiji
> > >
> > Thank you.
> > Raghavendra
> >
> > [1]: https://lore.kernel.org/lkml/87ilrlb6un.wl-maz@kernel.org/
> > >
> > >
> > > > +
> > > > +       return false;
> > > > +}
> > > > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > > > index 5d38628a8d04..499b45b607b6 100644
> > > > --- a/include/kvm/arm_hypercalls.h
> > > > +++ b/include/kvm/arm_hypercalls.h
> > > > @@ -6,6 +6,11 @@
> > > >
> > > >  #include <asm/kvm_emulate.h>
> > > >
> > > > +/* Last valid bits of the bitmapped firmware registers */
> > > > +#define KVM_REG_ARM_STD_BMAP_BIT_MAX           0
> > > > +
> > > > +#define KVM_ARM_SMCCC_STD_FEATURES             GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> > > > +
> > > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> > > >
> > > >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> > > > @@ -42,6 +47,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
> > > >
> > > >  struct kvm_one_reg;
> > > >
> > > > +void kvm_arm_init_hypercalls(struct kvm *kvm);
> > > >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> > > >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> > > >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > > > diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> > > > index 6e55b9283789..c47be3e26965 100644
> > > > --- a/include/kvm/arm_psci.h
> > > > +++ b/include/kvm/arm_psci.h
> > > > @@ -36,7 +36,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
> > > >         return KVM_ARM_PSCI_0_1;
> > > >  }
> > > >
> > > > -
> > > >  int kvm_psci_call(struct kvm_vcpu *vcpu);
> > > > +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id);
> > > >
> > > >  #endif /* __KVM_ARM_PSCI_H__ */
> > > > --
> > > > 2.36.0.rc2.479.g8af0fa9b8e-goog
> > > >
