Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5D86D002D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 11:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjC3JvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 05:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjC3Juh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 05:50:37 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316A67DBA
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 02:49:12 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id h27so15750545vsa.1
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 02:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680169750; x=1682761750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/d0geixbXcxl/ky3X2dr7tRHzYHvkvmBO5hOy6/QBI=;
        b=hG85F0hrEps63V7C+NEpfJ+DFm17PAiRjY2C/S4zMcjTeQdvivR95Yr1fLd3tEvUGg
         bj929I91xs/vvo+CZdjzYX+ITJg6+ok1Z7829Wv2pxSwbPe/E6IA9UKtGa4t1lxWjTkC
         KGK9J7K14aXvWYbOMSj17D+NHmpAvLQbU2Vbn41eSSWSN7anOOW1axkekMRTKGkD+EIs
         M/fTektsNtmMbAh456KhaEWleQl/IXNIUi9OXdTxCUeaThxFpQPx4Mp+SSZaszShuGMp
         3QVSWYf+MJ1OaqzmfAOCHIa+nbpgK8Zpt7/hL3X8Dj4790J3yZ0StVHKUr2/n7IZVzX9
         Obrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680169750; x=1682761750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/d0geixbXcxl/ky3X2dr7tRHzYHvkvmBO5hOy6/QBI=;
        b=viHzdeGtQ5h0BXRCWAdgyPIbCp42f8l/5P+NEYjXb/NDU71JNzJL2zgKoxUEAjcCZD
         58yTPHfp4GYymQPRaX+0qAdF9+2MI8aEaq/UwCyT47uKWOPT19PeHtL/yiifses+hFlz
         ayxbUOyJ2T3/t3GVixASrKNpFfzIe5yDBcF2UCG/O83L2EKefmOL0ySaD8mzDsqeilWk
         Q156Luqrzb0mdSJGyziVNoF/hsAI2SS3YRI5sanaMPmC9CqH9VQ9tfXzFLGbQZa2Tg3Q
         1HQznD1nppaHj5vSuVuomdE3xIbhQBFLVjx+8UEQo7fd1HK+EMFpKBEbOM/0SFtsJWH7
         Q3dw==
X-Gm-Message-State: AAQBX9f9NDR0ig7roctDrrG57wO2HpDM0ZUqFbKeYn2CCeJAaazL6slH
        jzA6RzB/VDdNmQFQClOM+bCjmdI6+1iKwqZGh04QL0RttMzPVIZe
X-Google-Smtp-Source: AKy350Z5wHebdOlgabyj3e81hiRLsA2c4sKqpL8YlxmyfvG5ZeD7BAwn8FbzecbJNHkGDeEiUo5rhahmBcX5CtQJ8Uw=
X-Received: by 2002:a67:d508:0:b0:426:da10:240b with SMTP id
 l8-20020a67d508000000b00426da10240bmr766134vsj.7.1680169750057; Thu, 30 Mar
 2023 02:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230330053135.1686577-1-apatel@ventanamicro.com>
 <20230330053135.1686577-2-apatel@ventanamicro.com> <7gtvgdxjwa662kfafnd5xrgugjt3w6iwv4w7rbrfeooviq2cnb@dqplsikshpzw>
In-Reply-To: <7gtvgdxjwa662kfafnd5xrgugjt3w6iwv4w7rbrfeooviq2cnb@dqplsikshpzw>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Thu, 30 Mar 2023 15:18:57 +0530
Message-ID: <CAK9=C2Xe2wRtv02cOCfdeKK4K=UVjWf-bLjAz_WJ80zYLE1LNQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] RISC-V: KVM: Add ONE_REG interface to
 enable/disable SBI extensions
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 12:34=E2=80=AFPM Andrew Jones <ajones@ventanamicro.=
com> wrote:
>
> On Thu, Mar 30, 2023 at 11:01:35AM +0530, Anup Patel wrote:
> > We add ONE_REG interface to enable/disable SBI extensions (just
> > like the ONE_REG interface for ISA extensions). This allows KVM
> > user-space to decide the set of SBI extension enabled for a Guest
> > and by default all SBI extensions are enabled.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
> >  arch/riscv/include/uapi/asm/kvm.h     |  20 ++++
> >  arch/riscv/kvm/vcpu.c                 |   2 +
> >  arch/riscv/kvm/vcpu_sbi.c             | 150 +++++++++++++++++++++++---
> >  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
> >  5 files changed, 163 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include=
/asm/kvm_vcpu_sbi.h
> > index 8425556af7d1..4278125a38a5 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > @@ -16,6 +16,7 @@
> >
> >  struct kvm_vcpu_sbi_context {
> >       int return_handled;
> > +     bool extension_disabled[KVM_RISCV_SBI_EXT_MAX];
> >  };
> >
> >  struct kvm_vcpu_sbi_return {
> > @@ -45,7 +46,12 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu=
 *vcpu,
> >                                    struct kvm_run *run,
> >                                    u32 type, u64 flags);
> >  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *r=
un);
> > -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned lo=
ng extid);
> > +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > +                                const struct kvm_one_reg *reg);
> > +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > +                                const struct kvm_one_reg *reg);
> > +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> > +                             struct kvm_vcpu *vcpu, unsigned long exti=
d);
> >  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *ru=
n);
> >
> >  #ifdef CONFIG_RISCV_SBI_V01
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 92af6f3f057c..33c3457b94e7 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -108,6 +108,23 @@ enum KVM_RISCV_ISA_EXT_ID {
> >       KVM_RISCV_ISA_EXT_MAX,
> >  };
> >
> > +/*
> > + * SBI extension IDs specific to KVM. This is not the same as the SBI
> > + * extension IDs defined by the RISC-V SBI specification.
> > + */
> > +enum KVM_RISCV_SBI_EXT_ID {
> > +     KVM_RISCV_SBI_EXT_V01 =3D 0,
> > +     KVM_RISCV_SBI_EXT_TIME,
> > +     KVM_RISCV_SBI_EXT_IPI,
> > +     KVM_RISCV_SBI_EXT_RFENCE,
> > +     KVM_RISCV_SBI_EXT_SRST,
> > +     KVM_RISCV_SBI_EXT_HSM,
> > +     KVM_RISCV_SBI_EXT_PMU,
> > +     KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> > +     KVM_RISCV_SBI_EXT_VENDOR,
> > +     KVM_RISCV_SBI_EXT_MAX,
> > +};
> > +
> >  /* Possible states for kvm_riscv_timer */
> >  #define KVM_RISCV_TIMER_STATE_OFF    0
> >  #define KVM_RISCV_TIMER_STATE_ON     1
> > @@ -152,6 +169,9 @@ enum KVM_RISCV_ISA_EXT_ID {
> >  /* ISA Extension registers are mapped as type 7 */
> >  #define KVM_REG_RISCV_ISA_EXT                (0x07 << KVM_REG_RISCV_TY=
PE_SHIFT)
> >
> > +/* SBI extension registers are mapped as type 8 */
> > +#define KVM_REG_RISCV_SBI_EXT                (0x08 << KVM_REG_RISCV_TY=
PE_SHIFT)
> > +
> >  #endif
> >
> >  #endif /* __LINUX_KVM_RISCV_H */
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 7d010b0be54e..311fd347c5a8 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -601,6 +601,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *=
vcpu,
> >                                                KVM_REG_RISCV_FP_D);
> >       case KVM_REG_RISCV_ISA_EXT:
> >               return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
> > +     case KVM_REG_RISCV_SBI_EXT:
> > +             return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
> >       default:
> >               break;
> >       }
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index 15fde15f9fb8..bedd7d78a5f0 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -30,17 +30,52 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi=
_ext_pmu =3D {
> >  };
> >  #endif
> >
> > -static const struct kvm_vcpu_sbi_extension *sbi_ext[] =3D {
> > -     &vcpu_sbi_ext_v01,
> > -     &vcpu_sbi_ext_base,
> > -     &vcpu_sbi_ext_time,
> > -     &vcpu_sbi_ext_ipi,
> > -     &vcpu_sbi_ext_rfence,
> > -     &vcpu_sbi_ext_srst,
> > -     &vcpu_sbi_ext_hsm,
> > -     &vcpu_sbi_ext_pmu,
> > -     &vcpu_sbi_ext_experimental,
> > -     &vcpu_sbi_ext_vendor,
> > +struct kvm_riscv_sbi_extension_entry {
> > +     enum KVM_RISCV_SBI_EXT_ID dis_idx;
> > +     const struct kvm_vcpu_sbi_extension *ext_ptr;
> > +};
> > +
> > +static const struct kvm_riscv_sbi_extension_entry sbi_ext[] =3D {
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_V01,
> > +             .ext_ptr =3D &vcpu_sbi_ext_v01,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled =
*/
> > +             .ext_ptr =3D &vcpu_sbi_ext_base,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_TIME,
> > +             .ext_ptr =3D &vcpu_sbi_ext_time,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_IPI,
> > +             .ext_ptr =3D &vcpu_sbi_ext_ipi,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_RFENCE,
> > +             .ext_ptr =3D &vcpu_sbi_ext_rfence,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_SRST,
> > +             .ext_ptr =3D &vcpu_sbi_ext_srst,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_HSM,
> > +             .ext_ptr =3D &vcpu_sbi_ext_hsm,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_PMU,
> > +             .ext_ptr =3D &vcpu_sbi_ext_pmu,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> > +             .ext_ptr =3D &vcpu_sbi_ext_experimental,
> > +     },
> > +     {
> > +             .dis_idx =3D KVM_RISCV_SBI_EXT_VENDOR,
> > +             .ext_ptr =3D &vcpu_sbi_ext_vendor,
> > +     },
> >  };
> >
> >  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run =
*run)
> > @@ -99,14 +134,95 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcp=
u, struct kvm_run *run)
> >       return 0;
> >  }
> >
> > -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned lo=
ng extid)
> > +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > +                                const struct kvm_one_reg *reg)
> > +{
> > +     unsigned long __user *uaddr =3D
> > +                     (unsigned long __user *)(unsigned long)reg->addr;
> > +     unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> > +                                         KVM_REG_SIZE_MASK |
> > +                                         KVM_REG_RISCV_SBI_EXT);
> > +     unsigned long i, reg_val;
> > +     const struct kvm_riscv_sbi_extension_entry *sext =3D NULL;
> > +     struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> > +
> > +     if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> > +             return -EINVAL;
> > +
> > +     if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> > +             return -EFAULT;
> > +
> > +     if (reg_num >=3D KVM_RISCV_SBI_EXT_MAX ||
> > +         (reg_val !=3D 1 && reg_val !=3D 0))
> > +             return -EINVAL;
> > +
> > +     if (vcpu->arch.ran_atleast_once)
> > +             return -EBUSY;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > +             if (sbi_ext[i].dis_idx =3D=3D reg_num) {
> > +                     sext =3D &sbi_ext[i];
> > +                     break;
> > +             }
> > +     }
> > +     if (!sext)
> > +             return -ENOENT;
> > +
> > +     scontext->extension_disabled[sext->dis_idx] =3D !reg_val;
> > +
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > +                                const struct kvm_one_reg *reg)
> > +{
> > +     unsigned long __user *uaddr =3D
> > +                     (unsigned long __user *)(unsigned long)reg->addr;
> > +     unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> > +                                         KVM_REG_SIZE_MASK |
> > +                                         KVM_REG_RISCV_SBI_EXT);
> > +     unsigned long i, reg_val;
> > +     const struct kvm_riscv_sbi_extension_entry *sext =3D NULL;
> > +     struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> > +
> > +     if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> > +             return -EINVAL;
> > +
> > +     if (reg_num >=3D KVM_RISCV_SBI_EXT_MAX)
> > +             return -EINVAL;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > +             if (sbi_ext[i].dis_idx =3D=3D reg_num) {
> > +                     sext =3D &sbi_ext[i];
> > +                     break;
> > +             }
> > +     }
> > +     if (!sext)
> > +             return -ENOENT;
> > +
> > +     reg_val =3D !scontext->extension_disabled[sext->dis_idx];
> > +     if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> > +                             struct kvm_vcpu *vcpu, unsigned long exti=
d)
> >  {
> > -     int i =3D 0;
> > +     int i;
> > +     const struct kvm_riscv_sbi_extension_entry *sext;
> > +     struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> >
> >       for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > -             if (sbi_ext[i]->extid_start <=3D extid &&
> > -                 sbi_ext[i]->extid_end >=3D extid)
> > -                     return sbi_ext[i];
> > +             sext =3D &sbi_ext[i];
> > +             if (sext->ext_ptr->extid_start <=3D extid &&
> > +                 sext->ext_ptr->extid_end >=3D extid) {
> > +                     if (sext->dis_idx < KVM_RISCV_SBI_EXT_MAX &&
> > +                         scontext->extension_disabled[sext->dis_idx])
> > +                             return NULL;
> > +                     return sbi_ext[i].ext_ptr;
> > +             }
> >       }
> >
> >       return NULL;
> > @@ -126,7 +242,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu,=
 struct kvm_run *run)
> >       };
> >       bool ext_is_v01 =3D false;
> >
> > -     sbi_ext =3D kvm_vcpu_sbi_find_ext(cp->a7);
> > +     sbi_ext =3D kvm_vcpu_sbi_find_ext(vcpu, cp->a7);
> >       if (sbi_ext && sbi_ext->handler) {
> >  #ifdef CONFIG_RISCV_SBI_V01
> >               if (cp->a7 >=3D SBI_EXT_0_1_SET_TIMER &&
> > diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_b=
ase.c
> > index 9945aff34c14..5bc570b984f4 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_base.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> > @@ -44,7 +44,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *=
vcpu, struct kvm_run *run,
> >                       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> >                       retdata->uexit =3D true;
> >               } else {
> > -                     sbi_ext =3D kvm_vcpu_sbi_find_ext(cp->a0);
> > +                     sbi_ext =3D kvm_vcpu_sbi_find_ext(vcpu, cp->a0);
> >                       *out_val =3D sbi_ext && sbi_ext->probe ?
> >                                          sbi_ext->probe(vcpu) : !!sbi_e=
xt;
> >               }
> > --
> > 2.34.1
> >
>
> This looks good, but I wonder if we shouldn't instead get/set a bitmap of
> all SBI extension enables at once for scalability.

The SBI extensions (just like ISA extensions) are enabled by default
so user-space only needs to disable selected ones which it does not
want.

Also, the problem with bitmap is that we can't fix the size of bitmap
and we will have to define each XLEN bitmap word (along with
the bits) separately.

Instead (like you had suggested previously), we should rather add
a generic IOCTL which allows user-space to create a VCPU based
on some other VCPU as reference.

Regards,
Anup
