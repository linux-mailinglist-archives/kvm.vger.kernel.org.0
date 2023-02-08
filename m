Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77C268E4B6
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 01:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBHAEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 19:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBHAEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 19:04:49 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A45023111
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 16:04:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so545168pjp.0
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 16:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dfEPQhR9+nvRYFuut3HlmHRlPkp8cAR6z45/icvtvuw=;
        b=bY80V9xOPF3ktFiiVHSWnzAiW7EJ+dEDiCHGs3IiSfFYGRXEEuUKNi+EsMjFtPWZ6v
         6ER4zszQSi4bzyZ31Q8wKhOv8RmhRopyjRvd5Q6KwjPUGj13I96N7ZNYSqnIJgcn2n9Y
         WsJA4YpowQfpU6KDhEdlxhItrUUBVdcMfE3Ak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dfEPQhR9+nvRYFuut3HlmHRlPkp8cAR6z45/icvtvuw=;
        b=W4UIJ8rgzOu+/gUJ7cclsn3X/hf64RPvXh6cyMrhkA1Awe+7fv1IH5cf2lA7kr1CzE
         pTS8ZJTQJQn+XfyKsTXcdkHk9EPxQ7M6THcnyboMF63NBE8/1YwDORbhwW+ch4c/xjrS
         MMrOauH5yX/gCBtTjJIe+ErfrQiwnCaU3MOS3f/Ar85yP7h/vvBVpAcsfzqte2UZU2G5
         0QS34KS+S6PMgsfgSinJFZ2ZOmOoIn1yfvT5Pgy6oC4w6Y/YGe5epfptei6yVVosgcyT
         35at7sGtLnoph9JonBwIE+tt/JC7n7V271gy4+vbv5QsSqIY/UP7GD+Rzg1kfkatZ6rD
         qLnQ==
X-Gm-Message-State: AO0yUKVCV12eV90BF4Lr5IDMhFHdoejzf32hEDAaAVyiLKczRvMe94Y+
        MBp14s2ZUHjBujzgJacFMwzAAKHcbqgSraW2yaAe
X-Google-Smtp-Source: AK7set+x2RMP9jPOWJjqB5AuZaFMEzKB81CZ5V6vAu5s3Oc0iy8TPASMirZbhn0c2Wzd3Tp69FACa6p/DaneNwBZ4Mk=
X-Received: by 2002:a17:902:8348:b0:193:794:ba9 with SMTP id
 z8-20020a170902834800b0019307940ba9mr1322433pln.22.1675814687080; Tue, 07 Feb
 2023 16:04:47 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-1-apatel@ventanamicro.com> <20230128072737.2995881-6-apatel@ventanamicro.com>
In-Reply-To: <20230128072737.2995881-6-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 7 Feb 2023 16:04:35 -0800
Message-ID: <CAOnJCUKh6s6v0TK=4KRZk9GXN23ebvPuy2OHtWBtTOpnN4g9dg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:28 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We extend the CSR ONE_REG interface to access both general CSRs and
> AIA CSRs. To achieve this, we introduce "subtype" field in the ONE_REG
> id which can be used for grouping registers within a particular "type"
> of ONE_REG registers.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 15 ++++-
>  arch/riscv/kvm/vcpu.c             | 96 ++++++++++++++++++++++++-------
>  2 files changed, 89 insertions(+), 22 deletions(-)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 71992ff1f9dd..d0704eff0121 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -64,7 +64,7 @@ struct kvm_riscv_core {
>  #define KVM_RISCV_MODE_S       1
>  #define KVM_RISCV_MODE_U       0
>
> -/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
>  struct kvm_riscv_csr {
>         unsigned long sstatus;
>         unsigned long sie;
> @@ -78,6 +78,10 @@ struct kvm_riscv_csr {
>         unsigned long scounteren;
>  };
>
> +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_aia_csr {
> +};
> +
>  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
>  struct kvm_riscv_timer {
>         __u64 frequency;
> @@ -105,6 +109,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_SVINVAL,
>         KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
>         KVM_RISCV_ISA_EXT_ZICBOM,
> +       KVM_RISCV_ISA_EXT_SSAIA,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> @@ -134,6 +139,8 @@ enum KVM_RISCV_SBI_EXT_ID {
>  /* If you need to interpret the index values, here is the key: */
>  #define KVM_REG_RISCV_TYPE_MASK                0x00000000FF000000
>  #define KVM_REG_RISCV_TYPE_SHIFT       24
> +#define KVM_REG_RISCV_SUBTYPE_MASK     0x0000000000FF0000
> +#define KVM_REG_RISCV_SUBTYPE_SHIFT    16
>
>  /* Config registers are mapped as type 1 */
>  #define KVM_REG_RISCV_CONFIG           (0x01 << KVM_REG_RISCV_TYPE_SHIFT)
> @@ -147,8 +154,12 @@ enum KVM_RISCV_SBI_EXT_ID {
>
>  /* Control and status registers are mapped as type 3 */
>  #define KVM_REG_RISCV_CSR              (0x03 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_CSR_GENERAL      0x0
> +#define KVM_REG_RISCV_CSR_AIA          0x1
>  #define KVM_REG_RISCV_CSR_REG(name)    \
> -               (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
> +       (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
> +#define KVM_REG_RISCV_CSR_AIA_REG(name)        \
> +       (offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
>
>  /* Timer registers are mapped as type 4 */
>  #define KVM_REG_RISCV_TIMER            (0x04 << KVM_REG_RISCV_TYPE_SHIFT)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3cf50eadc8ce..37933ea20274 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -58,6 +58,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>         [KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
>         [KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
>
> +       KVM_ISA_EXT_ARR(SSAIA),
>         KVM_ISA_EXT_ARR(SSTC),
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVPBMT),
> @@ -96,6 +97,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>         case KVM_RISCV_ISA_EXT_C:
>         case KVM_RISCV_ISA_EXT_I:
>         case KVM_RISCV_ISA_EXT_M:
> +       case KVM_RISCV_ISA_EXT_SSAIA:
>         case KVM_RISCV_ISA_EXT_SSTC:
>         case KVM_RISCV_ISA_EXT_SVINVAL:
>         case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
> @@ -451,30 +453,79 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
> +                                         unsigned long reg_num,
> +                                         unsigned long *out_val)
> +{
> +       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +
> +       if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
> +               kvm_riscv_vcpu_flush_interrupts(vcpu);
> +               *out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
> +       } else
> +               *out_val = ((unsigned long *)csr)[reg_num];
> +
> +       return 0;
> +}
> +
>  static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
>                                       const struct kvm_one_reg *reg)
>  {
> -       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +       int rc;
>         unsigned long __user *uaddr =
>                         (unsigned long __user *)(unsigned long)reg->addr;
>         unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
>                                             KVM_REG_SIZE_MASK |
>                                             KVM_REG_RISCV_CSR);
> -       unsigned long reg_val;
> +       unsigned long reg_val, reg_subtype;
>
>         if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
>                 return -EINVAL;
> +
> +       reg_subtype = (reg_num & KVM_REG_RISCV_SUBTYPE_MASK)
> +                       >> KVM_REG_RISCV_SUBTYPE_SHIFT;
> +       reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
> +       switch (reg_subtype) {
> +       case KVM_REG_RISCV_CSR_GENERAL:
> +               rc = kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg_val);
> +               break;
> +       case KVM_REG_RISCV_CSR_AIA:
> +               rc = kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val);
> +               break;
> +       default:
> +               rc = -EINVAL;
> +               break;
> +       }
> +       if (rc)
> +               return rc;
> +
> +       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
> +                                                unsigned long reg_num,
> +                                                unsigned long reg_val)
> +{
> +       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +
>         if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
>                 return -EINVAL;
>
>         if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
> -               kvm_riscv_vcpu_flush_interrupts(vcpu);
> -               reg_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
> -       } else
> -               reg_val = ((unsigned long *)csr)[reg_num];
> +               reg_val &= VSIP_VALID_MASK;
> +               reg_val <<= VSIP_TO_HVIP_SHIFT;
> +       }
>
> -       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> -               return -EFAULT;
> +       ((unsigned long *)csr)[reg_num] = reg_val;
> +
> +       if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> +               WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>
>         return 0;
>  }
> @@ -482,31 +533,36 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
>  static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
>                                       const struct kvm_one_reg *reg)
>  {
> -       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +       int rc;
>         unsigned long __user *uaddr =
>                         (unsigned long __user *)(unsigned long)reg->addr;
>         unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
>                                             KVM_REG_SIZE_MASK |
>                                             KVM_REG_RISCV_CSR);
> -       unsigned long reg_val;
> +       unsigned long reg_val, reg_subtype;
>
>         if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
>                 return -EINVAL;
> -       if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
> -               return -EINVAL;
>
>         if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
>                 return -EFAULT;
>
> -       if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
> -               reg_val &= VSIP_VALID_MASK;
> -               reg_val <<= VSIP_TO_HVIP_SHIFT;
> +       reg_subtype = (reg_num & KVM_REG_RISCV_SUBTYPE_MASK)
> +                       >> KVM_REG_RISCV_SUBTYPE_SHIFT;
> +       reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
> +       switch (reg_subtype) {
> +       case KVM_REG_RISCV_CSR_GENERAL:
> +               rc = kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_val);
> +               break;
> +       case KVM_REG_RISCV_CSR_AIA:
> +               rc = kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val);
> +               break;
> +       default:
> +               rc = -EINVAL;
> +               break;
>         }
> -
> -       ((unsigned long *)csr)[reg_num] = reg_val;
> -
> -       if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> -               WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +       if (rc)
> +               return rc;
>
>         return 0;
>  }
> --
> 2.34.1
>

This can be split into two patches. The first patch can just modify
the existing implementation
to parse subtypes for general CSRs. AIA support can be added in the next one.


-- 
Regards,
Atish
