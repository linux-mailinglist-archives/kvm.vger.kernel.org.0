Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392E24D9195
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 01:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343937AbiCOAbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 20:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343939AbiCOAbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 20:31:47 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0FB5FBC
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 17:30:28 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id u61so34176400ybi.11
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 17:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qEJ9pZXiPBJllStK15DjjPT29d6c31OxSK4K+jffViA=;
        b=aR6hKndBh2Bii9c6eKeCQH6yD4FDnaBw1Wv8yoGCwOt4/sBCyO0EFHvTSh9gpLQRmA
         iydCL4D4qao/TbgPFSlHkRWZFfI8G6zeMfDFRc3SOLvVhaUZNn4OZW6FeDF0rNIzya8/
         IzqWMgvqfujq/vfPZgJjoKlHuLTWexI9+jTB570EqGwadBx2rBe8Ie6tjPTknBPjsIrU
         P9CkJgXmT6WNpJEzQKkmvMjatCZgv/1ay1P6ZR+RCc+4CLDKvMPWGXYCa5kaoE57Rtm5
         Z+hlTk2ftAstaDNKqzeqjPIySRnFbhz0o/hG76+Wghg8I1cGE1hkz+DoQuq1GjzRFQyr
         eCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEJ9pZXiPBJllStK15DjjPT29d6c31OxSK4K+jffViA=;
        b=yQjUcI8ljWp0XYLdZQmk5Ah9TVySgqRiTvkcTRKumcSJkXIrO8T90EAt8B78Xi4T5t
         CvWC9/KU5Mt7NVDQyll1mIsktOezgZwK8FjFV5b7Yegpnb9/3vZBgFFY/TyEs5WIqKwc
         SrHCsPX65HN1fpeOEOeT68oMOcNuCe0KaXjzLcaWATKDoCsqayrJXC5LpeactJekAAsf
         eGYz4J61jkVJV/Sa/nBLu8oC1wLSTOELgOQogTi4FcEzS4NEHoOuanA1CE8j9C2moheR
         pBtIpnMXmE3o3qZfZ/jIiWhvCI4jX8FXmtPy+lRW8ietxVM5Qm9A9yCWUe7iuu0GQpib
         W4zg==
X-Gm-Message-State: AOAM530nEU2GHyEtfzmMRD1VdIgbGAHRhZXhwvRFn2ONADL/4ZAr+njX
        7ztFoJpwi6KCmPvM+q9KuB9ZrOcak+Yri5yO6vyaGQ==
X-Google-Smtp-Source: ABdhPJzgjbRQlBYSeMnmEPg1/7WUCgyQg/pJ0Cm6lUpmcMD4ib+NIE3Zsjq+dCvRIZFA/WttLrHBuqx4tPOa2SS/dLs=
X-Received: by 2002:a5b:d46:0:b0:628:aafa:1e54 with SMTP id
 f6-20020a5b0d46000000b00628aafa1e54mr19760362ybr.509.1647304227085; Mon, 14
 Mar 2022 17:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com> <20220224172559.4170192-8-rananta@google.com>
 <Yi+eoHWYgt6A5z+1@google.com>
In-Reply-To: <Yi+eoHWYgt6A5z+1@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 14 Mar 2022 17:30:15 -0700
Message-ID: <CAJHc60z7wZmABs3Z0LVP9SJnu9T7tU-VK5=F0=tSjy9ScEdqOQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/13] KVM: arm64: Add vendor hypervisor firmware register
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 12:59 PM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Feb 24, 2022 at 05:25:53PM +0000, Raghavendra Rao Ananta wrote:
> > Introduce the firmware register to hold the vendor specific
> > hypervisor service calls (owner value 6) as a bitmap. The
> > bitmap represents the features that'll be enabled for the
> > guest, as configured by the user-space. Currently, this
> > includes support only for Precision Time Protocol (PTP),
> > represented by bit-0.
> >
> > The register is also added to the kvm_arm_vm_scope_fw_regs[]
> > list as it maintains its state per-VM.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
> >  arch/arm64/kvm/guest.c            |  1 +
> >  arch/arm64/kvm/hypercalls.c       | 22 +++++++++++++++++++++-
> >  include/kvm/arm_hypercalls.h      |  3 +++
> >  5 files changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 318148b69279..d999456c4604 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
> >   *
> >   * @hvc_std_bmap: Bitmap of standard secure service calls
> >   * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
> > + * @hvc_vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
> >   */
> >  struct kvm_hvc_desc {
> >       u64 hvc_std_bmap;
> >       u64 hvc_std_hyp_bmap;
> > +     u64 hvc_vendor_hyp_bmap;
> >  };
> >
> >  struct kvm_arch {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 9a2caead7359..ed470bde13d8 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -299,6 +299,10 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME              BIT(0)
> >  #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX     0       /* Last valid bit */
> >
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP          KVM_REG_ARM_FW_BMAP_REG(2)
> > +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP               BIT(0)
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX  0       /* Last valid bit */
> > +
> >  /* SVE registers */
> >  #define KVM_REG_ARM64_SVE            (0x15 << KVM_REG_ARM_COPROC_SHIFT)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index c42426d6137e..fc3656f91aed 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -67,6 +67,7 @@ static const u64 kvm_arm_vm_scope_fw_regs[] = {
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> >       KVM_REG_ARM_STD_BMAP,
> >       KVM_REG_ARM_STD_HYP_BMAP,
> > +     KVM_REG_ARM_VENDOR_HYP_BMAP,
> >  };
> >
> >  /**
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index ebc0cc26cf2e..5c5098c8f1f9 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -79,6 +79,9 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
> >       case ARM_SMCCC_HV_PV_TIME_ST:
> >               return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
> >                                       KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> > +     case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +             return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_vendor_hyp_bmap,
> > +                                     KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
> >       default:
> >               /* By default, allow the services that aren't listed here */
> >               return true;
> > @@ -162,7 +165,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >               break;
> >       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >               val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > -             val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> > +
> > +             /*
> > +              * The feature bits exposed to user-space doesn't include
> > +              * ARM_SMCCC_KVM_FUNC_FEATURES. However, we expose this to
> > +              * the guest as bit-0. Hence, left-shift the user-space
> > +              * exposed bitmap by 1 to accommodate this.
> > +              */
> > +             val[0] |= hvc_desc->hvc_vendor_hyp_bmap << 1;
>
> Having an off-by-one difference between the userspace and guest
> representations of this bitmap seems like it could be a source of bugs
> in the future. Its also impossible for the guest to completely hide the
> vendor range if it so chooses.
>
> Why not tie ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID and
> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID to BIT(0)? PTP would then
> become BIT(1).
>
I agree it's a little asymmetrical. But exposing a bit for the
func_ids that you mentioned means providing a capability to disable
them by the userspace. This would block the guests from even
discovering the space. If it's not too ugly, we can maintain certain
bits to always remain read-only to the user-space. On the other hand,
we can simply ignore what the userspace configure and simply treat it
as a userspace bug. What do you think?

Regards,
Raghavendra
> >               break;
> >       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >               kvm_ptp_get_time(vcpu, val);
> > @@ -188,6 +198,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> >       KVM_REG_ARM_STD_BMAP,
> >       KVM_REG_ARM_STD_HYP_BMAP,
> > +     KVM_REG_ARM_VENDOR_HYP_BMAP,
> >  };
> >
> >  void kvm_arm_init_hypercalls(struct kvm *kvm)
> > @@ -196,6 +207,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
> >
> >       hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
> >       hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
> > +     hvc_desc->hvc_vendor_hyp_bmap = ARM_SMCCC_VENDOR_HYP_FEATURES;
> >  }
> >
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > @@ -285,6 +297,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >       case KVM_REG_ARM_STD_HYP_BMAP:
> >               val = READ_ONCE(hvc_desc->hvc_std_hyp_bmap);
> >               break;
> > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +             val = READ_ONCE(hvc_desc->hvc_vendor_hyp_bmap);
> > +             break;
> >       default:
> >               return -ENOENT;
> >       }
> > @@ -311,6 +326,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> >               fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
> >               fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
> >               break;
> > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +             fw_reg_bmap = &hvc_desc->hvc_vendor_hyp_bmap;
> > +             fw_reg_features = ARM_SMCCC_VENDOR_HYP_FEATURES;
> > +             break;
> >       default:
> >               return -ENOENT;
> >       }
> > @@ -416,6 +435,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >               return 0;
> >       case KVM_REG_ARM_STD_BMAP:
> >       case KVM_REG_ARM_STD_HYP_BMAP:
> > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> >               return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
> >       default:
> >               return -ENOENT;
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index a1cb6e839c74..91be758ca58e 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -12,6 +12,9 @@
> >  #define ARM_SMCCC_STD_HYP_FEATURES \
> >       GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> >
> > +#define ARM_SMCCC_VENDOR_HYP_FEATURES \
> > +     GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> >
> >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
