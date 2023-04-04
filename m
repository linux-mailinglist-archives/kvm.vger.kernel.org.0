Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41E46D55AB
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 02:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjDDAyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 20:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjDDAyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 20:54:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4F52D49
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 17:54:37 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x15so28923686pjk.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 17:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1680569677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oeRhezTe6V3KRxJiPAUxev5yCp4NThE2FwzyZbUEj/w=;
        b=q6c9SbJLUNnXc0WkOkpocfapkQ4dqq6ipwmLvk7nGVQbE7154VWSLpmcLm4fUf/3Ft
         gERFB/lYnNBcG5fxh+omt7M4raMfD166SOH8dmbH1aLYgwHsHLyRPMFuPdZvqGg0p42j
         pEKnGCKhKqjN8GY63FdyGaGNiNh9cgN9AuCT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680569677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeRhezTe6V3KRxJiPAUxev5yCp4NThE2FwzyZbUEj/w=;
        b=Q557uAOFbrOsXsvOCbi/hKxdyOim1vYzcbsBQ/vEANMlF1ML74kxNmROeHN4YsLm9o
         fqtIWYK7rmpLyaRKEu6NPieEysLBBJpa6NSsMx+b5FIVd4Q6/Bpf5o9cXQ5rK+LtCExn
         pYFasFPr/j9r/rprH58p/k3wfGYpqnST6Pys3gaKU56Xx3t2ZQGC8q8MjyvKjb2t36Bb
         zmOg6oGIC8aAy/a3q/ymX91fbZrAQoT0CZpCnEhKXIV3v+rcKasX8QtYgLSCsRf4Smbc
         195vIrjmXV3L8nBFIq9VUhJWbbcRzrLYWTmg16T4sHJIYe0gOaJ9SO6SyAqLS8JBWQKp
         zN0A==
X-Gm-Message-State: AAQBX9dP5DaXMu/w3iC7h0E0UDRHmiNOvE8K02e7uoLbu3c5i0bnz5Pq
        Ae8XhoPVEDVhlfZovOQz6B1TKC7DQ/lCXFQkkOS5
X-Google-Smtp-Source: AKy350Ykn4T4uF1/NFxFPzzGrAe+qaPiHSoG2wg1K72mnjSzCZn2FZ5BVlkmrfQHF1IBbU+m52ehu4ZI7H9VV7JkwHY=
X-Received: by 2002:a17:90b:3511:b0:240:9b27:ded4 with SMTP id
 ls17-20020a17090b351100b002409b27ded4mr7681367pjb.4.1680569677399; Mon, 03
 Apr 2023 17:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230403093310.2271142-1-apatel@ventanamicro.com> <20230403093310.2271142-6-apatel@ventanamicro.com>
In-Reply-To: <20230403093310.2271142-6-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 4 Apr 2023 06:24:25 +0530
Message-ID: <CAOnJCULaGqO1kd2tM-MG7sCHaWTo_zpnhgm5kgsJ8206Ab6zDQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] RISC-V: KVM: Implement subtype for CSR ONE_REG interface
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
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

On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Anup Patel <apatel@ventanamicro.com>=
 wrote:
>
> To make the CSR ONE_REG interface extensible, we implement subtype
> for the CSR ONE_REG IDs. The existing CSR ONE_REG IDs are treated
> as subtype =3D 0 (aka General CSRs).
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  3 +-
>  arch/riscv/kvm/vcpu.c             | 88 +++++++++++++++++++++++--------
>  2 files changed, 69 insertions(+), 22 deletions(-)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 47a7c3958229..182023dc9a51 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -65,7 +65,7 @@ struct kvm_riscv_core {
>  #define KVM_RISCV_MODE_S       1
>  #define KVM_RISCV_MODE_U       0
>
> -/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
>  struct kvm_riscv_csr {
>         unsigned long sstatus;
>         unsigned long sie;
> @@ -152,6 +152,7 @@ enum KVM_RISCV_SBI_EXT_ID {
>
>  /* Control and status registers are mapped as type 3 */
>  #define KVM_REG_RISCV_CSR              (0x03 << KVM_REG_RISCV_TYPE_SHIFT=
)
> +#define KVM_REG_RISCV_CSR_GENERAL      (0x0 << KVM_REG_RISCV_SUBTYPE_SHI=
FT)
>  #define KVM_REG_RISCV_CSR_REG(name)    \
>                 (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned l=
ong))
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 1fd54ec15622..aca6b4fb7519 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -460,27 +460,72 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_v=
cpu *vcpu,
>         return 0;
>  }
>
> +static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
> +                                         unsigned long reg_num,
> +                                         unsigned long *out_val)
> +{
> +       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> +
> +       if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned l=
ong))
> +               return -EINVAL;
> +
> +       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> +               kvm_riscv_vcpu_flush_interrupts(vcpu);
> +               *out_val =3D (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VAL=
ID_MASK;
> +       } else
> +               *out_val =3D ((unsigned long *)csr)[reg_num];
> +
> +       return 0;
> +}
> +
> +static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
> +                                                unsigned long reg_num,
> +                                                unsigned long reg_val)
> +{
> +       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> +
> +       if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned l=
ong))
> +               return -EINVAL;
> +
> +       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> +               reg_val &=3D VSIP_VALID_MASK;
> +               reg_val <<=3D VSIP_TO_HVIP_SHIFT;
> +       }
> +
> +       ((unsigned long *)csr)[reg_num] =3D reg_val;
> +
> +       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
> +               WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +
> +       return 0;
> +}
> +
>  static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
>                                       const struct kvm_one_reg *reg)
>  {
> -       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> +       int rc;
>         unsigned long __user *uaddr =3D
>                         (unsigned long __user *)(unsigned long)reg->addr;
>         unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
>                                             KVM_REG_SIZE_MASK |
>                                             KVM_REG_RISCV_CSR);
> -       unsigned long reg_val;
> +       unsigned long reg_val, reg_subtype;
>
>         if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
>                 return -EINVAL;
> -       if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned l=
ong))
> -               return -EINVAL;
>
> -       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> -               kvm_riscv_vcpu_flush_interrupts(vcpu);
> -               reg_val =3D (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALI=
D_MASK;
> -       } else
> -               reg_val =3D ((unsigned long *)csr)[reg_num];
> +       reg_subtype =3D reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> +       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> +       switch (reg_subtype) {
> +       case KVM_REG_RISCV_CSR_GENERAL:
> +               rc =3D kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg=
_val);
> +               break;
> +       default:
> +               rc =3D -EINVAL;
> +               break;
> +       }
> +       if (rc)
> +               return rc;
>
>         if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
>                 return -EFAULT;
> @@ -491,31 +536,32 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vc=
pu *vcpu,
>  static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
>                                       const struct kvm_one_reg *reg)
>  {
> -       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> +       int rc;
>         unsigned long __user *uaddr =3D
>                         (unsigned long __user *)(unsigned long)reg->addr;
>         unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
>                                             KVM_REG_SIZE_MASK |
>                                             KVM_REG_RISCV_CSR);
> -       unsigned long reg_val;
> +       unsigned long reg_val, reg_subtype;
>
>         if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
>                 return -EINVAL;
> -       if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned l=
ong))
> -               return -EINVAL;
>
>         if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
>                 return -EFAULT;
>
> -       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> -               reg_val &=3D VSIP_VALID_MASK;
> -               reg_val <<=3D VSIP_TO_HVIP_SHIFT;
> +       reg_subtype =3D reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> +       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> +       switch (reg_subtype) {
> +       case KVM_REG_RISCV_CSR_GENERAL:
> +               rc =3D kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_=
val);
> +               break;
> +       default:
> +               rc =3D -EINVAL;
> +               break;
>         }
> -
> -       ((unsigned long *)csr)[reg_num] =3D reg_val;
> -
> -       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
> -               WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +       if (rc)
> +               return rc;
>
>         return 0;
>  }
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish
