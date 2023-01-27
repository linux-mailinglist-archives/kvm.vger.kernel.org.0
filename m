Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5067EA0E
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 16:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjA0Pzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 10:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjA0Pzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 10:55:41 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528CB79F39
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:55:36 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id e18so1144568uax.2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r80X1ET8KcIlhWgcdQu72LX7k8pxX9L7dDPgmXQ6q7Q=;
        b=n+hejz2kLGUHsdk7peWBW9rt9y1Wz7dmzEGv85IpcBju56LiHWSNww76NtOsmR76WO
         HDvT4JDuBRMYGbsZT9nZHVrUGx5ZAV6ko1LJ5mDTKt7R9CN8R9k5LRPNqf+vu+fsKMAL
         rFnvTftvnNZgXTXfqsuMV1MpbjP92Lpuy4uJvjvb+/QayHfV4XrUUX8q6w1q8w9NmVgl
         xuaJ4H6ajNVcwQtIU+6OUC+mMJKq6/fpAi0PStTV+Vu2NjXtUXBFjYD11LR4FKRztFts
         hUlhQBES+O/uPQU6tiWTWE1nTrgQwnxxVk72E1oRrC+GTEts4xgM/AbpOMF43e4Rt3Zs
         bjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r80X1ET8KcIlhWgcdQu72LX7k8pxX9L7dDPgmXQ6q7Q=;
        b=1XUnf0ECcOocNXELE+tVsV3VF1iE4iV6bJrs79pqPFQltlREooIQjzyf9YA3qy5lJo
         pUAnatrxV87gdf3BBHh0pzaTkMzGZIb/1AE6qops/WuEl0JgpXdNN6yTYmoBaR8tG4SK
         KJ6XkwyvTSpohglzdJ6rrPyABQsSRa2Xgm93qys7GMOLw3SCkClWqwnhAtZbCjMsX8z0
         3XzL5w8yfx2DoVd9O5MvSga5cKZxRbN/vPvTCtOoI53XvCJP88AqL4rcPXDbpU32uM7P
         pTGFvOXHsfVt4VTqCC+jH8Mh3mw8NjE+DyAV3EQB7zQGYwzHvC/J61RDWEcWLMmcLlwt
         HD/w==
X-Gm-Message-State: AFqh2krHPrPVf2u+CHTVhUOaCSGOD3SZPtRDlDmj5vWEUGiXZa8d8VQZ
        zndg4VuzTYxL3IKQkx9+IOKtBjNYcbUoBvFEiwDy1A==
X-Google-Smtp-Source: AMrXdXtN9tTpb4MriUs4cMqcHuVL3StlYC2et7/sFhzIhPQD+Ufj/0zurGQZsAIK+T8VdzIa6Is0IpVhSQFwu7Hh+Jk=
X-Received: by 2002:ab0:2504:0:b0:63f:80d6:86d9 with SMTP id
 j4-20020ab02504000000b0063f80d686d9mr2937711uan.38.1674834935207; Fri, 27 Jan
 2023 07:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
 <20230112140304.1830648-6-apatel@ventanamicro.com> <20230126171938.la5jswt6gr4qanl5@orel>
In-Reply-To: <20230126171938.la5jswt6gr4qanl5@orel>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 27 Jan 2023 21:25:23 +0530
Message-ID: <CAK9=C2VQF8kKfVztBR2hrANb63Q8s0+Md6ZDXFjLWjWED1A2zA@mail.gmail.com>
Subject: Re: [PATCH 5/7] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 10:49 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Jan 12, 2023 at 07:33:02PM +0530, Anup Patel wrote:
> > We extend the CSR ONE_REG interface to access both general CSRs and
> > AIA CSRs. To achieve this, we introduce "subtype" field in the ONE_REG
> > id which can be used for grouping registers within a particular "type"
> > of ONE_REG registers.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/uapi/asm/kvm.h | 15 ++++-
> >  arch/riscv/kvm/vcpu.c             | 96 ++++++++++++++++++++++++-------
> >  2 files changed, 89 insertions(+), 22 deletions(-)
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > index 71992ff1f9dd..d0704eff0121 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -64,7 +64,7 @@ struct kvm_riscv_core {
> >  #define KVM_RISCV_MODE_S     1
> >  #define KVM_RISCV_MODE_U     0
> >
> > -/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > +/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >  struct kvm_riscv_csr {
> >       unsigned long sstatus;
> >       unsigned long sie;
> > @@ -78,6 +78,10 @@ struct kvm_riscv_csr {
> >       unsigned long scounteren;
> >  };
> >
> > +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > +struct kvm_riscv_aia_csr {
> > +};
> > +
> >  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >  struct kvm_riscv_timer {
> >       __u64 frequency;
> > @@ -105,6 +109,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >       KVM_RISCV_ISA_EXT_SVINVAL,
> >       KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
> >       KVM_RISCV_ISA_EXT_ZICBOM,
> > +     KVM_RISCV_ISA_EXT_SSAIA,
> >       KVM_RISCV_ISA_EXT_MAX,
> >  };
> >
> > @@ -134,6 +139,8 @@ enum KVM_RISCV_SBI_EXT_ID {
> >  /* If you need to interpret the index values, here is the key: */
> >  #define KVM_REG_RISCV_TYPE_MASK              0x00000000FF000000
> >  #define KVM_REG_RISCV_TYPE_SHIFT     24
> > +#define KVM_REG_RISCV_SUBTYPE_MASK   0x0000000000FF0000
> > +#define KVM_REG_RISCV_SUBTYPE_SHIFT  16
>
> We could just define a new AIA_CSR type, rather than introduce CSR
> subtypes. While grouping all CSRs together under the CSR type also
> makes sense, having to teach all userspaces about subtypes may not
> be worth the organizational benefits.

My main concern is that we have chosen a 8-bit wide "type" field
in ONE_REG id which can't be changed now and it will be consumed
very fast if we start adding separate "type" for each ISA extension.
This "type" field is shared with SBI extensions and we will be also
having separate nested CSR state for various ISA extensions.

Since KVM RISC-V is young, I think it is better to introduce a
"subtype" field now so that we have ample space for the future.

Also, both ONE_REG "type" and "subtype" are arch specific fields
of ONE_REG id so all KVM user space changes will be contained
in RISC-V specific code.

>
> >
> >  /* Config registers are mapped as type 1 */
> >  #define KVM_REG_RISCV_CONFIG         (0x01 << KVM_REG_RISCV_TYPE_SHIFT)
> > @@ -147,8 +154,12 @@ enum KVM_RISCV_SBI_EXT_ID {
> >
> >  /* Control and status registers are mapped as type 3 */
> >  #define KVM_REG_RISCV_CSR            (0x03 << KVM_REG_RISCV_TYPE_SHIFT)
> > +#define KVM_REG_RISCV_CSR_GENERAL    0x0
> > +#define KVM_REG_RISCV_CSR_AIA                0x1
> >  #define KVM_REG_RISCV_CSR_REG(name)  \
> > -             (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
> > +     (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
> > +#define KVM_REG_RISCV_CSR_AIA_REG(name)      \
> > +     (offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
> >
> >  /* Timer registers are mapped as type 4 */
> >  #define KVM_REG_RISCV_TIMER          (0x04 << KVM_REG_RISCV_TYPE_SHIFT)
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 3cf50eadc8ce..37933ea20274 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -58,6 +58,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
> >       [KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
> >       [KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
> >
> > +     KVM_ISA_EXT_ARR(SSAIA),
> >       KVM_ISA_EXT_ARR(SSTC),
> >       KVM_ISA_EXT_ARR(SVINVAL),
> >       KVM_ISA_EXT_ARR(SVPBMT),
> > @@ -96,6 +97,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
> >       case KVM_RISCV_ISA_EXT_C:
> >       case KVM_RISCV_ISA_EXT_I:
> >       case KVM_RISCV_ISA_EXT_M:
> > +     case KVM_RISCV_ISA_EXT_SSAIA:
> >       case KVM_RISCV_ISA_EXT_SSTC:
> >       case KVM_RISCV_ISA_EXT_SVINVAL:
> >       case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
> > @@ -451,30 +453,79 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
> > +                                       unsigned long reg_num,
> > +                                       unsigned long *out_val)
> > +{
> > +     struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > +
> > +     if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
> > +             return -EINVAL;
> > +
> > +     if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
> > +             kvm_riscv_vcpu_flush_interrupts(vcpu);
> > +             *out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
> > +     } else
> > +             *out_val = ((unsigned long *)csr)[reg_num];
> > +
> > +     return 0;
> > +}
> > +
> >  static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
> >                                     const struct kvm_one_reg *reg)
> >  {
> > -     struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > +     int rc;
> >       unsigned long __user *uaddr =
> >                       (unsigned long __user *)(unsigned long)reg->addr;
> >       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> >                                           KVM_REG_SIZE_MASK |
> >                                           KVM_REG_RISCV_CSR);
> > -     unsigned long reg_val;
> > +     unsigned long reg_val, reg_subtype;
> >
> >       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> >               return -EINVAL;
> > +
> > +     reg_subtype = (reg_num & KVM_REG_RISCV_SUBTYPE_MASK)
> > +                     >> KVM_REG_RISCV_SUBTYPE_SHIFT;
> > +     reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
> > +     switch (reg_subtype) {
> > +     case KVM_REG_RISCV_CSR_GENERAL:
> > +             rc = kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg_val);
> > +             break;
> > +     case KVM_REG_RISCV_CSR_AIA:
> > +             rc = kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val);
> > +             break;
> > +     default:
> > +             rc = -EINVAL;
> > +             break;
> > +     }
> > +     if (rc)
> > +             return rc;
> > +
> > +     if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
> > +                                              unsigned long reg_num,
> > +                                              unsigned long reg_val)
> > +{
> > +     struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > +
> >       if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
> >               return -EINVAL;
> >
> >       if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
> > -             kvm_riscv_vcpu_flush_interrupts(vcpu);
> > -             reg_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
> > -     } else
> > -             reg_val = ((unsigned long *)csr)[reg_num];
> > +             reg_val &= VSIP_VALID_MASK;
> > +             reg_val <<= VSIP_TO_HVIP_SHIFT;
> > +     }
> >
> > -     if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > -             return -EFAULT;
> > +     ((unsigned long *)csr)[reg_num] = reg_val;
> > +
> > +     if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> > +             WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> >
> >       return 0;
> >  }
> > @@ -482,31 +533,36 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
> >  static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
> >                                     const struct kvm_one_reg *reg)
> >  {
> > -     struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > +     int rc;
> >       unsigned long __user *uaddr =
> >                       (unsigned long __user *)(unsigned long)reg->addr;
> >       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> >                                           KVM_REG_SIZE_MASK |
> >                                           KVM_REG_RISCV_CSR);
> > -     unsigned long reg_val;
> > +     unsigned long reg_val, reg_subtype;
> >
> >       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> >               return -EINVAL;
> > -     if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
> > -             return -EINVAL;
> >
> >       if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> >               return -EFAULT;
> >
> > -     if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
> > -             reg_val &= VSIP_VALID_MASK;
> > -             reg_val <<= VSIP_TO_HVIP_SHIFT;
> > +     reg_subtype = (reg_num & KVM_REG_RISCV_SUBTYPE_MASK)
> > +                     >> KVM_REG_RISCV_SUBTYPE_SHIFT;
> > +     reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
> > +     switch (reg_subtype) {
> > +     case KVM_REG_RISCV_CSR_GENERAL:
> > +             rc = kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_val);
> > +             break;
> > +     case KVM_REG_RISCV_CSR_AIA:
> > +             rc = kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val);
> > +             break;
> > +     default:
> > +             rc = -EINVAL;
> > +             break;
> >       }
> > -
> > -     ((unsigned long *)csr)[reg_num] = reg_val;
> > -
> > -     if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> > -             WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> > +     if (rc)
> > +             return rc;
> >
> >       return 0;
> >  }
> > --
> > 2.34.1
> >
>
> Thanks,
> drew
