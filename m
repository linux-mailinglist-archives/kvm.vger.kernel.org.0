Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D745445A16
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 19:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhKDTBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 15:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKDTBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 15:01:08 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38315C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 11:58:30 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so16828652ybe.3
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 11:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUmCcM2R27aOSL47pzbGyQqJ7fyPEFQW3dQWmWZEKC0=;
        b=oQjhMPhYfnVcGc5KK9SCmA092z/fwG+34NzH0Wc9ooFbdCywDFlYcfLZsnjMMsT6wA
         UP7MYfCuyqdjsgF1ngXeQtwctBnTPnm3DAoPKWSubBQUVit3MSIN1oqZJGdcivz0ZMA2
         bf9zIa941ohwL40/4HeiHvsJYLpVvUdObfiBS9tDj4l8mzXhDOryCBTaDhkCS6ZMBL05
         wnkLbO2+6f3CNLWKslMFDqkVtyOw3f65Qmuz8TEmJEKSxtCjYvUlT3z2U7fo7bf8d4JR
         Lj+PdinXblZI0ySHphrkl8/9Avk12Y+rkrvka9L3n1cO3iUGqIeNU6rxVsxa5+rC/I1p
         14jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUmCcM2R27aOSL47pzbGyQqJ7fyPEFQW3dQWmWZEKC0=;
        b=z8LOuRdplDFdiVweMPG35hIPiM8eK4mPU49s0iOZPVGECLsrJbr7E6w9Z8u86yV3G4
         8B9ubPqvYtrrb9sA6KF8E3BrE41npvuljmVpYZahNHsrolK9Q4IblACGhzNsIJs2U8Di
         d10KVR8hx3X0mMrHqeUW4K3Ui5mwrDIwrhVRaK36+0OwuaIti6QkqG4Q2ZNwi40NW/fH
         QBrGLydbR4rUq8ANw8JBNV9iT6bkQs1vxKd7BK0X0SRHC8qqNX5ZkZsAfWOzEwfuTJq6
         SS6QQpRnWX6rtEgNHpGNDz1YabzdhA0GpJ1tjqqwP9l3Tv04PnyQd5xL6Z2lFH458f45
         1VAA==
X-Gm-Message-State: AOAM533z0gKPv7KJYbO0qWN2hjt4kcLw9HBYsQIBI8teMqeVe6vwivoS
        e1WmWOQc2Eo1vMvrcrvV2O529UhZxNf1dWgK5K4P1g==
X-Google-Smtp-Source: ABdhPJw9+in7+jK3BzPJrRdvOhUL2WxBB20G1qO5j2AUIeI2ZbWx1/3MaBBORni/qhRE4xF3hhcxbWt21DUg28bKgAM=
X-Received: by 2002:a05:6902:10c4:: with SMTP id w4mr39840645ybu.439.1636052307853;
 Thu, 04 Nov 2021 11:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211102002203.1046069-1-rananta@google.com> <20211102002203.1046069-7-rananta@google.com>
 <YYMoEYzBvEqN5MD7@google.com>
In-Reply-To: <YYMoEYzBvEqN5MD7@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 4 Nov 2021 11:58:16 -0700
Message-ID: <CAJHc60yGpDR3denxfTUs_TxKcNWaPLChkVEgEXpNkGvkRS=KEg@mail.gmail.com>
Subject: Re: [RFC PATCH 6/8] tools: Import the firmware registers
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 3, 2021 at 5:23 PM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 12:22:01AM +0000, Raghavendra Rao Ananta wrote:
> > Import the firmware definitions for the firmware registers,
> > KVM_REG_ARM_STD, KVM_REG_ARM_STD_HYP, and KVM_REG_ARM_VENDOR_HYP.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >
> > ---
> >  tools/arch/arm64/include/uapi/asm/kvm.h | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
>
> Won't we have the latest UAPI headers available in usr/include/ at build
> time?
>
I think we do. Wasn't aware of this. I'll delete the patch.

Regards,
Raghavendra
> --
> Oliver
>
> > diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
> > index b3edde68bc3e..a1d0e8e69eed 100644
> > --- a/tools/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/tools/arch/arm64/include/uapi/asm/kvm.h
> > @@ -281,6 +281,24 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED     3
> >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED          (1U << 4)
> >
> > +#define KVM_REG_ARM_STD                      KVM_REG_ARM_FW_REG(3)
> > +enum kvm_reg_arm_std_bmap {
> > +     KVM_REG_ARM_STD_TRNG_V1_0,
> > +     KVM_REG_ARM_STD_BMAP_MAX,
> > +};
> > +
> > +#define KVM_REG_ARM_STD_HYP          KVM_REG_ARM_FW_REG(4)
> > +enum kvm_reg_arm_std_hyp_bmap {
> > +     KVM_REG_ARM_STD_HYP_PV_TIME_ST,
> > +     KVM_REG_ARM_STD_HYP_BMAP_MAX,
> > +};
> > +
> > +#define KVM_REG_ARM_VENDOR_HYP               KVM_REG_ARM_FW_REG(5)
> > +enum kvm_reg_arm_vendor_hyp_bmap {
> > +     KVM_REG_ARM_VENDOR_HYP_PTP,
> > +     KVM_REG_ARM_VENDOR_HYP_BMAP_MAX,
> > +};
> > +
> >  /* SVE registers */
> >  #define KVM_REG_ARM64_SVE            (0x15 << KVM_REG_ARM_COPROC_SHIFT)
> >
> > --
> > 2.33.1.1089.g2158813163f-goog
> >
