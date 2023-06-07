Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385AE7272C9
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjFGXRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjFGXRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:17:30 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F551FEA
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:17:28 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f63a2e1c5fso49764e87.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686179846; x=1688771846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exL7UJKnh0aQf8BCVJ4sMUbK2ucGAmWKQpAfHQ/ksFc=;
        b=rPTu/oMp4btAKF7Dou+L0dPFXKdTT1dzgVXrsc5HEogN1kL1tdRYTXQKWHnyShlt5/
         Uoi6/KEtj42CPCX3C4RrajPPo+Jq5t81wVLGxy5/10Iu5XG0L0UiyubyrPt+arDH1WkK
         9kl86L9/tmETy6raoNF3Kxs2/0xMhk3VTBC0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686179846; x=1688771846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exL7UJKnh0aQf8BCVJ4sMUbK2ucGAmWKQpAfHQ/ksFc=;
        b=SQ9wgQQsYYhwWLwKXmHWwh+YS+EvhhiGs150K5JTw5bPUwJEYNTXYpUKbz+xu3s8wb
         1EHUZTvNxNJlcpjAPiIDM+CbAdHn6FxjwPZIcj/L8YDH2rCOO4tadCdRxN09iP4ebtPn
         /2NtmxSWRCAyw2fHOUKD4loHihWj23gk1RF45kILf3ZqP1GlAq5cIMgbpZJ+ZJQLM434
         suQ0bwyCGK1OB3LgvNPR4tdJEjW7FwetjgERhsQ520GIkW52DtyNM/TMd15pUydCkAJG
         PUPIuRCQs8hIa/AQ8cufkrFcpdXwnJvlUpaKVbfOpY0Y5TlQWNNKSFCSGHm+eRshwP8Y
         eRvg==
X-Gm-Message-State: AC+VfDygaXozchYaFoU+2oBbCTSp35urmO5TFT6WHNv0/B+S1HGIxaPq
        KPB8sRmjwN6hbLe7cujxrE/509FsPdKDKC14l23k
X-Google-Smtp-Source: ACHHUZ4Miea6I9CfHReC01mCIjSxiDmVCARGqe++x3CRDRtMARpwNylxC9OvdVIBD7st8pr0w1rzj77Z++37UBAAQ7s=
X-Received: by 2002:a2e:924d:0:b0:2a8:a6a5:e26e with SMTP id
 v13-20020a2e924d000000b002a8a6a5e26emr3447628ljg.20.1686179846360; Wed, 07
 Jun 2023 16:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230517105135.1871868-1-apatel@ventanamicro.com> <20230517105135.1871868-11-apatel@ventanamicro.com>
In-Reply-To: <20230517105135.1871868-11-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 7 Jun 2023 16:17:14 -0700
Message-ID: <CAOnJCUKm9hK5tVvRV8-mS7w4nZc9T6U47e1Lsh6JRaBPDpVfug@mail.gmail.com>
Subject: Re: [PATCH 10/10] RISC-V: KVM: Expose IMSIC registers as attributes
 of AIA irqchip
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 3:52=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> We expose IMSIC registers as KVM device attributes of the in-kernel
> AIA irqchip device. This will allow KVM user-space to save/restore
> IMISC state of each VCPU using KVM device ioctls().
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  |   3 +
>  arch/riscv/include/uapi/asm/kvm.h |  12 +++
>  arch/riscv/kvm/aia_device.c       |  29 ++++-
>  arch/riscv/kvm/aia_imsic.c        | 170 ++++++++++++++++++++++++++++++
>  4 files changed, 212 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index a4f6ebf90e31..1f37b600ca47 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -97,6 +97,9 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vc=
pu);
>  int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu, unsigned long is=
el,
>                                  unsigned long *val, unsigned long new_va=
l,
>                                  unsigned long wr_mask);
> +int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, unsigned long type,
> +                               bool write, unsigned long *val);
> +int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type);
>  void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
>                                     u32 guest_index, u32 offset, u32 iid)=
;
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index e80210c2220b..624784bb21dd 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -242,6 +242,18 @@ enum KVM_RISCV_SBI_EXT_ID {
>
>  #define KVM_DEV_RISCV_AIA_GRP_APLIC            3
>
> +#define KVM_DEV_RISCV_AIA_GRP_IMSIC            4
> +#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS      12
> +#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK      \
> +               ((1U << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) - 1)
> +#define KVM_DEV_RISCV_AIA_IMSIC_MKATTR(__vcpu, __isel) \
> +               (((__vcpu) << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) | \
> +                ((__isel) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK))
> +#define KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(__attr)       \
> +               ((__attr) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK)
> +#define KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(__attr)       \
> +               ((__attr) >> KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS)
> +
>  /* One single KVM irqchip, ie. the AIA */
>  #define KVM_NR_IRQCHIPS                        1
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 17dba92a90e1..ac7bd98301a3 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -326,7 +326,7 @@ static int aia_set_attr(struct kvm_device *dev, struc=
t kvm_device_attr *attr)
>         u32 nr;
>         u64 addr;
>         int nr_vcpus, r =3D -ENXIO;
> -       unsigned long type =3D (unsigned long)attr->attr;
> +       unsigned long v, type =3D (unsigned long)attr->attr;
>         void __user *uaddr =3D (void __user *)(long)attr->addr;
>
>         switch (attr->group) {
> @@ -373,6 +373,15 @@ static int aia_set_attr(struct kvm_device *dev, stru=
ct kvm_device_attr *attr)
>                 r =3D kvm_riscv_aia_aplic_set_attr(dev->kvm, type, nr);
>                 mutex_unlock(&dev->kvm->lock);
>
> +               break;
> +       case KVM_DEV_RISCV_AIA_GRP_IMSIC:
> +               if (copy_from_user(&v, uaddr, sizeof(v)))
> +                       return -EFAULT;
> +
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D kvm_riscv_aia_imsic_rw_attr(dev->kvm, type, true, &=
v);
> +               mutex_unlock(&dev->kvm->lock);
> +
>                 break;
>         }
>
> @@ -385,7 +394,7 @@ static int aia_get_attr(struct kvm_device *dev, struc=
t kvm_device_attr *attr)
>         u64 addr;
>         int nr_vcpus, r =3D -ENXIO;
>         void __user *uaddr =3D (void __user *)(long)attr->addr;
> -       unsigned long type =3D (unsigned long)attr->attr;
> +       unsigned long v, type =3D (unsigned long)attr->attr;
>
>         switch (attr->group) {
>         case KVM_DEV_RISCV_AIA_GRP_CONFIG:
> @@ -434,6 +443,20 @@ static int aia_get_attr(struct kvm_device *dev, stru=
ct kvm_device_attr *attr)
>                 if (copy_to_user(uaddr, &nr, sizeof(nr)))
>                         return -EFAULT;
>
> +               break;
> +       case KVM_DEV_RISCV_AIA_GRP_IMSIC:
> +               if (copy_from_user(&v, uaddr, sizeof(v)))
> +                       return -EFAULT;
> +
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D kvm_riscv_aia_imsic_rw_attr(dev->kvm, type, false, =
&v);
> +               mutex_unlock(&dev->kvm->lock);
> +               if (r)
> +                       return r;
> +
> +               if (copy_to_user(uaddr, &v, sizeof(v)))
> +                       return -EFAULT;
> +
>                 break;
>         }
>
> @@ -472,6 +495,8 @@ static int aia_has_attr(struct kvm_device *dev, struc=
t kvm_device_attr *attr)
>                 break;
>         case KVM_DEV_RISCV_AIA_GRP_APLIC:
>                 return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr)=
;
> +       case KVM_DEV_RISCV_AIA_GRP_IMSIC:
> +               return kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr)=
;
>         }
>
>         return -ENXIO;
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index 2dc09dcb8ab5..8f108cfa80e5 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -277,6 +277,33 @@ static u32 imsic_mrif_topei(struct imsic_mrif *mrif,=
 u32 nr_eix, u32 nr_msis)
>         return 0;
>  }
>
> +static int imsic_mrif_isel_check(u32 nr_eix, unsigned long isel)
> +{
> +       u32 num =3D 0;
> +
> +       switch (isel) {
> +       case IMSIC_EIDELIVERY:
> +       case IMSIC_EITHRESHOLD:
> +               break;
> +       case IMSIC_EIP0 ... IMSIC_EIP63:
> +               num =3D isel - IMSIC_EIP0;
> +               break;
> +       case IMSIC_EIE0 ... IMSIC_EIE63:
> +               num =3D isel - IMSIC_EIE0;
> +               break;
> +       default:
> +               return -ENOENT;
> +       };
> +#ifndef CONFIG_32BIT
> +       if (num & 0x1)
> +               return -EINVAL;
> +#endif
> +       if ((num / 2) >=3D nr_eix)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  static int imsic_mrif_rmw(struct imsic_mrif *mrif, u32 nr_eix,
>                           unsigned long isel, unsigned long *val,
>                           unsigned long new_val, unsigned long wr_mask)
> @@ -407,6 +434,86 @@ static void imsic_vsfile_read(int vsfile_hgei, int v=
sfile_cpu, u32 nr_eix,
>                          imsic_vsfile_local_read, &idata, 1);
>  }
>
> +struct imsic_vsfile_rw_data {
> +       int hgei;
> +       int isel;
> +       bool write;
> +       unsigned long val;
> +};
> +
> +static void imsic_vsfile_local_rw(void *data)
> +{
> +       struct imsic_vsfile_rw_data *idata =3D data;
> +       unsigned long new_hstatus, old_hstatus, old_vsiselect;
> +
> +       old_vsiselect =3D csr_read(CSR_VSISELECT);
> +       old_hstatus =3D csr_read(CSR_HSTATUS);
> +       new_hstatus =3D old_hstatus & ~HSTATUS_VGEIN;
> +       new_hstatus |=3D ((unsigned long)idata->hgei) << HSTATUS_VGEIN_SH=
IFT;
> +       csr_write(CSR_HSTATUS, new_hstatus);
> +
> +       switch (idata->isel) {
> +       case IMSIC_EIDELIVERY:
> +               if (idata->write)
> +                       imsic_vs_csr_write(IMSIC_EIDELIVERY, idata->val);
> +               else
> +                       idata->val =3D imsic_vs_csr_read(IMSIC_EIDELIVERY=
);
> +               break;
> +       case IMSIC_EITHRESHOLD:
> +               if (idata->write)
> +                       imsic_vs_csr_write(IMSIC_EITHRESHOLD, idata->val)=
;
> +               else
> +                       idata->val =3D imsic_vs_csr_read(IMSIC_EITHRESHOL=
D);
> +               break;
> +       case IMSIC_EIP0 ... IMSIC_EIP63:
> +       case IMSIC_EIE0 ... IMSIC_EIE63:
> +#ifndef CONFIG_32BIT
> +               if (idata->isel & 0x1)
> +                       break;
> +#endif
> +               if (idata->write)
> +                       imsic_eix_write(idata->isel, idata->val);
> +               else
> +                       idata->val =3D imsic_eix_read(idata->isel);
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       csr_write(CSR_HSTATUS, old_hstatus);
> +       csr_write(CSR_VSISELECT, old_vsiselect);
> +}
> +
> +static int imsic_vsfile_rw(int vsfile_hgei, int vsfile_cpu, u32 nr_eix,
> +                          unsigned long isel, bool write,
> +                          unsigned long *val)
> +{
> +       int rc;
> +       struct imsic_vsfile_rw_data rdata;
> +
> +       /* We can only access register if we have a IMSIC VS-file */
> +       if (vsfile_cpu < 0 || vsfile_hgei <=3D 0)
> +               return -EINVAL;
> +
> +       /* Check IMSIC register iselect */
> +       rc =3D imsic_mrif_isel_check(nr_eix, isel);
> +       if (rc)
> +               return rc;
> +
> +       /* We can only access register on local CPU */
> +       rdata.hgei =3D vsfile_hgei;
> +       rdata.isel =3D isel;
> +       rdata.write =3D write;
> +       rdata.val =3D (write) ? *val : 0;
> +       on_each_cpu_mask(cpumask_of(vsfile_cpu),
> +                        imsic_vsfile_local_rw, &rdata, 1);
> +
> +       if (!write)
> +               *val =3D rdata.val;
> +
> +       return 0;
> +}
> +
>  static void imsic_vsfile_local_clear(int vsfile_hgei, u32 nr_eix)
>  {
>         u32 i;
> @@ -758,6 +865,69 @@ int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vc=
pu, unsigned long isel,
>         return rc;
>  }
>
> +int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, unsigned long type,
> +                               bool write, unsigned long *val)
> +{
> +       u32 isel, vcpu_id;
> +       unsigned long flags;
> +       struct imsic *imsic;
> +       struct kvm_vcpu *vcpu;
> +       int rc, vsfile_hgei, vsfile_cpu;
> +
> +       if (!kvm_riscv_aia_initialized(kvm))
> +               return -ENODEV;
> +
> +       vcpu_id =3D KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(type);
> +       vcpu =3D kvm_get_vcpu_by_id(kvm, vcpu_id);
> +       if (!vcpu)
> +               return -ENODEV;
> +
> +       isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
> +       imsic =3D vcpu->arch.aia_context.imsic_state;
> +
> +       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +
> +       rc =3D 0;
> +       vsfile_hgei =3D imsic->vsfile_hgei;
> +       vsfile_cpu =3D imsic->vsfile_cpu;
> +       if (vsfile_cpu < 0) {
> +               if (write) {
> +                       rc =3D imsic_mrif_rmw(imsic->swfile, imsic->nr_ei=
x,
> +                                           isel, NULL, *val, -1UL);
> +                       imsic_swfile_extirq_update(vcpu);
> +               } else
> +                       rc =3D imsic_mrif_rmw(imsic->swfile, imsic->nr_ei=
x,
> +                                           isel, val, 0, 0);
> +       }
> +
> +       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +       if (!rc && vsfile_cpu >=3D 0)
> +               rc =3D imsic_vsfile_rw(vsfile_hgei, vsfile_cpu, imsic->nr=
_eix,
> +                                    isel, write, val);
> +
> +       return rc;
> +}
> +
> +int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type)
> +{
> +       u32 isel, vcpu_id;
> +       struct imsic *imsic;
> +       struct kvm_vcpu *vcpu;
> +
> +       if (!kvm_riscv_aia_initialized(kvm))
> +               return -ENODEV;
> +
> +       vcpu_id =3D KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(type);
> +       vcpu =3D kvm_get_vcpu_by_id(kvm, vcpu_id);
> +       if (!vcpu)
> +               return -ENODEV;
> +
> +       isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
> +       imsic =3D vcpu->arch.aia_context.imsic_state;
> +       return imsic_mrif_isel_check(imsic->nr_eix, isel);
> +}
> +
>  void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu)
>  {
>         struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish
