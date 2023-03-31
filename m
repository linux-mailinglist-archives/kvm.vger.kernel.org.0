Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97266D267B
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 19:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjCaRQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 13:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCaRQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 13:16:01 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A391C1C0
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 10:16:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id er13so51381279edb.9
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 10:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680282958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAzw7TT/sjg4SXbGiPwMSsKqPPQHTtEY3GFboR2KSbo=;
        b=gzeyNPl7aMroQwkhnuH9dGPyoW8udYaZzd0U7ML/vdC4+J7sclUNzM/jNdJZ1BGD55
         M+UGvhyeguz14vqlRp4kqTNtrUdi+4pa7yVODVlapu245218Z9YiUeIgBi63e2M5/19v
         1QKhUrIn/8qyjzomEKcIlz2/OLQ+X8c6xnsQIEY1hKzwmpRpaXx3clmtLzcB+fkZTjZ1
         r56eqPJy4z4DrKCDQ/31TxX5pt9mhsbqCRZ53GUEbCS/plrOviyiXvmaL93zddm3vdAC
         N/jlIrYlDcCo3Ow/pExikuLl0zFRHD1+TktrgLgWY11XNPk1jBYZVn68wvFteMTU7F8w
         FJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680282958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAzw7TT/sjg4SXbGiPwMSsKqPPQHTtEY3GFboR2KSbo=;
        b=bSoBNvbA7UT9s5M9qTWao4gyjjH+kBSvopQ+helPCyYY79rwkVdiLNIVEID44sfwSb
         go3rrQa3e8A8IBH+t8SOpGSFtGscZTwoYA8w/HA5PrRpzIfE2+dFU2hI2j6dNFF0NMU+
         crouDKc+BWJu6QVQn7/DVR2R4qbptvMoLVWtcFQgp1LRRum2EQUniTpK06crMF7bijZO
         7dPa/dzRLxDW1nxbOWEaJRDOoB2MgYpbCp8my6iU+jxWmwgzf5RTx2bn5SzMntdRXT0o
         uMS9hD0uzgqecvZv3UyWCtLGw0NM8MhjcQHEOplY+nGTvfapT3/cta/5vO2QXQ2C6TMX
         qRsA==
X-Gm-Message-State: AAQBX9c3hz5UaErPeGpauUwFU/HuBsPiNphGJNei6rG3T6cRU4Fm3vay
        nmbSC6LPL/Ws2yPg/fw4BeUwXLyZNaQ6GTF2+TSMvw==
X-Google-Smtp-Source: AKy350aQxTi5kpx3wJRqUiy1Y9IwZo1FZ8Rz6frMwB5t4mEVDlsnr8AT/GAD4F+9EZzjaxUyruZAe7/0f+IOCV0GFlQ=
X-Received: by 2002:a17:907:7212:b0:946:f3f9:67b5 with SMTP id
 dr18-20020a170907721200b00946f3f967b5mr6589974ejc.6.1680282958562; Fri, 31
 Mar 2023 10:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230128072737.2995881-1-apatel@ventanamicro.com>
 <20230128072737.2995881-6-apatel@ventanamicro.com> <CAOnJCUKh6s6v0TK=4KRZk9GXN23ebvPuy2OHtWBtTOpnN4g9dg@mail.gmail.com>
In-Reply-To: <CAOnJCUKh6s6v0TK=4KRZk9GXN23ebvPuy2OHtWBtTOpnN4g9dg@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 31 Mar 2023 22:45:45 +0530
Message-ID: <CAAhSdy1GxsdRVJDJP_70VtK_tM=sNnpvSJoCWwm1LSfHsVf=Lg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 8, 2023 at 5:34=E2=80=AFAM Atish Patra <atishp@atishpatra.org> =
wrote:
>
> On Fri, Jan 27, 2023 at 11:28 PM Anup Patel <apatel@ventanamicro.com> wro=
te:
> >
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
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 71992ff1f9dd..d0704eff0121 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -64,7 +64,7 @@ struct kvm_riscv_core {
> >  #define KVM_RISCV_MODE_S       1
> >  #define KVM_RISCV_MODE_U       0
> >
> > -/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > +/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >  struct kvm_riscv_csr {
> >         unsigned long sstatus;
> >         unsigned long sie;
> > @@ -78,6 +78,10 @@ struct kvm_riscv_csr {
> >         unsigned long scounteren;
> >  };
> >
> > +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > +struct kvm_riscv_aia_csr {
> > +};
> > +
> >  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >  struct kvm_riscv_timer {
> >         __u64 frequency;
> > @@ -105,6 +109,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >         KVM_RISCV_ISA_EXT_SVINVAL,
> >         KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
> >         KVM_RISCV_ISA_EXT_ZICBOM,
> > +       KVM_RISCV_ISA_EXT_SSAIA,
> >         KVM_RISCV_ISA_EXT_MAX,
> >  };
> >
> > @@ -134,6 +139,8 @@ enum KVM_RISCV_SBI_EXT_ID {
> >  /* If you need to interpret the index values, here is the key: */
> >  #define KVM_REG_RISCV_TYPE_MASK                0x00000000FF000000
> >  #define KVM_REG_RISCV_TYPE_SHIFT       24
> > +#define KVM_REG_RISCV_SUBTYPE_MASK     0x0000000000FF0000
> > +#define KVM_REG_RISCV_SUBTYPE_SHIFT    16
> >
> >  /* Config registers are mapped as type 1 */
> >  #define KVM_REG_RISCV_CONFIG           (0x01 << KVM_REG_RISCV_TYPE_SHI=
FT)
> > @@ -147,8 +154,12 @@ enum KVM_RISCV_SBI_EXT_ID {
> >
> >  /* Control and status registers are mapped as type 3 */
> >  #define KVM_REG_RISCV_CSR              (0x03 << KVM_REG_RISCV_TYPE_SHI=
FT)
> > +#define KVM_REG_RISCV_CSR_GENERAL      0x0
> > +#define KVM_REG_RISCV_CSR_AIA          0x1
> >  #define KVM_REG_RISCV_CSR_REG(name)    \
> > -               (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned=
 long))
> > +       (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
> > +#define KVM_REG_RISCV_CSR_AIA_REG(name)        \
> > +       (offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned lon=
g))
> >
> >  /* Timer registers are mapped as type 4 */
> >  #define KVM_REG_RISCV_TIMER            (0x04 << KVM_REG_RISCV_TYPE_SHI=
FT)
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 3cf50eadc8ce..37933ea20274 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -58,6 +58,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
> >         [KVM_RISCV_ISA_EXT_I] =3D RISCV_ISA_EXT_i,
> >         [KVM_RISCV_ISA_EXT_M] =3D RISCV_ISA_EXT_m,
> >
> > +       KVM_ISA_EXT_ARR(SSAIA),
> >         KVM_ISA_EXT_ARR(SSTC),
> >         KVM_ISA_EXT_ARR(SVINVAL),
> >         KVM_ISA_EXT_ARR(SVPBMT),
> > @@ -96,6 +97,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsign=
ed long ext)
> >         case KVM_RISCV_ISA_EXT_C:
> >         case KVM_RISCV_ISA_EXT_I:
> >         case KVM_RISCV_ISA_EXT_M:
> > +       case KVM_RISCV_ISA_EXT_SSAIA:
> >         case KVM_RISCV_ISA_EXT_SSTC:
> >         case KVM_RISCV_ISA_EXT_SVINVAL:
> >         case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
> > @@ -451,30 +453,79 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm=
_vcpu *vcpu,
> >         return 0;
> >  }
> >
> > +static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
> > +                                         unsigned long reg_num,
> > +                                         unsigned long *out_val)
> > +{
> > +       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> > +
> > +       if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned=
 long))
> > +               return -EINVAL;
> > +
> > +       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> > +               kvm_riscv_vcpu_flush_interrupts(vcpu);
> > +               *out_val =3D (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_V=
ALID_MASK;
> > +       } else
> > +               *out_val =3D ((unsigned long *)csr)[reg_num];
> > +
> > +       return 0;
> > +}
> > +
> >  static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
> >                                       const struct kvm_one_reg *reg)
> >  {
> > -       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> > +       int rc;
> >         unsigned long __user *uaddr =3D
> >                         (unsigned long __user *)(unsigned long)reg->add=
r;
> >         unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> >                                             KVM_REG_SIZE_MASK |
> >                                             KVM_REG_RISCV_CSR);
> > -       unsigned long reg_val;
> > +       unsigned long reg_val, reg_subtype;
> >
> >         if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> >                 return -EINVAL;
> > +
> > +       reg_subtype =3D (reg_num & KVM_REG_RISCV_SUBTYPE_MASK)
> > +                       >> KVM_REG_RISCV_SUBTYPE_SHIFT;
> > +       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> > +       switch (reg_subtype) {
> > +       case KVM_REG_RISCV_CSR_GENERAL:
> > +               rc =3D kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &r=
eg_val);
> > +               break;
> > +       case KVM_REG_RISCV_CSR_AIA:
> > +               rc =3D kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_v=
al);
> > +               break;
> > +       default:
> > +               rc =3D -EINVAL;
> > +               break;
> > +       }
> > +       if (rc)
> > +               return rc;
> > +
> > +       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > +               return -EFAULT;
> > +
> > +       return 0;
> > +}
> > +
> > +static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu=
,
> > +                                                unsigned long reg_num,
> > +                                                unsigned long reg_val)
> > +{
> > +       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> > +
> >         if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned=
 long))
> >                 return -EINVAL;
> >
> >         if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> > -               kvm_riscv_vcpu_flush_interrupts(vcpu);
> > -               reg_val =3D (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VA=
LID_MASK;
> > -       } else
> > -               reg_val =3D ((unsigned long *)csr)[reg_num];
> > +               reg_val &=3D VSIP_VALID_MASK;
> > +               reg_val <<=3D VSIP_TO_HVIP_SHIFT;
> > +       }
> >
> > -       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > -               return -EFAULT;
> > +       ((unsigned long *)csr)[reg_num] =3D reg_val;
> > +
> > +       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
> > +               WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> >
> >         return 0;
> >  }
> > @@ -482,31 +533,36 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_=
vcpu *vcpu,
> >  static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
> >                                       const struct kvm_one_reg *reg)
> >  {
> > -       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> > +       int rc;
> >         unsigned long __user *uaddr =3D
> >                         (unsigned long __user *)(unsigned long)reg->add=
r;
> >         unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> >                                             KVM_REG_SIZE_MASK |
> >                                             KVM_REG_RISCV_CSR);
> > -       unsigned long reg_val;
> > +       unsigned long reg_val, reg_subtype;
> >
> >         if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> >                 return -EINVAL;
> > -       if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned=
 long))
> > -               return -EINVAL;
> >
> >         if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> >                 return -EFAULT;
> >
> > -       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> > -               reg_val &=3D VSIP_VALID_MASK;
> > -               reg_val <<=3D VSIP_TO_HVIP_SHIFT;
> > +       reg_subtype =3D (reg_num & KVM_REG_RISCV_SUBTYPE_MASK)
> > +                       >> KVM_REG_RISCV_SUBTYPE_SHIFT;
> > +       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> > +       switch (reg_subtype) {
> > +       case KVM_REG_RISCV_CSR_GENERAL:
> > +               rc =3D kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, re=
g_val);
> > +               break;
> > +       case KVM_REG_RISCV_CSR_AIA:
> > +               rc =3D kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_va=
l);
> > +               break;
> > +       default:
> > +               rc =3D -EINVAL;
> > +               break;
> >         }
> > -
> > -       ((unsigned long *)csr)[reg_num] =3D reg_val;
> > -
> > -       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
> > -               WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> > +       if (rc)
> > +               return rc;
> >
> >         return 0;
> >  }
> > --
> > 2.34.1
> >
>
> This can be split into two patches. The first patch can just modify
> the existing implementation
> to parse subtypes for general CSRs. AIA support can be added in the next =
one.

Okay, I will split this into two patches.

Regards,
Anup
