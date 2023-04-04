Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8126D55AD
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 02:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjDDAzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 20:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDDAzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 20:55:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DC326A2
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 17:55:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so32336755pjz.1
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 17:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1680569736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEwFn2uGtRQsO9awpxhbGL1a6vuoUJbo7CO/eXVUsqU=;
        b=GlpqQK7gy6EApv3Sc/UyYohp7NSneizSCpJAnaXbNX6wCClkpgyJnLXyoMNDrW0RGH
         JJEQKA9KWSJNgUIUptDwwSILqYkCwPvnun5nD3pXLNO8COXds4JF0GpTCPTp9auKuGpU
         LBLyWsgS0ktm5oNiK4gpXJsqfGNODIRAU0vjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680569736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEwFn2uGtRQsO9awpxhbGL1a6vuoUJbo7CO/eXVUsqU=;
        b=En4TBwzii0jmf6el1FLry4zHTtgftQcb45FFgM6WG3xMbhzis3HLM2/VQxfb9XYX7I
         vifzIFBKmIsvGLHkFlW7DstCxDGC+AL4Ys2QWD5ZaJYILZMQk1DtLvV4r1NRon4aV4Q+
         qSrSFWCu10LLUeCRelP4ZYmise/ySyHdSVZiH8ll1aAsDcj+2l//Vx37TO6ubBkkVjyB
         YupZYWVMEtkNEsLd80pfetnomwg8Na0iZWADvOhu4M2SacR8hDbb3swFeg2qDT6U8PY3
         bDcr9lx63nHOG4SQYHz9CUFn0i1slyk+MxmVfG+z/vmHYTkMI+FH1/NYdp5WAwsosc5Z
         wtoA==
X-Gm-Message-State: AAQBX9dC7+mxZ3zaNwD1NpS9S1N+jAW0FoXIr9Ykp18SjMW7denqi//e
        fowut/DH1fIrr/LWonB3V6ce2HZAhiFXF68Fj+As
X-Google-Smtp-Source: AKy350ZP5YKZ16+SpnppyXfLhSLP7eL7PHbUb9z1R22CcfULzFD0TQxOxSFi+54XPufaTj35Mh5p0Ksk4QPQw3rgrxI=
X-Received: by 2002:a17:902:b60e:b0:1a1:f6d9:2c27 with SMTP id
 b14-20020a170902b60e00b001a1f6d92c27mr337392pls.5.1680569736077; Mon, 03 Apr
 2023 17:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230403093310.2271142-1-apatel@ventanamicro.com> <20230403093310.2271142-7-apatel@ventanamicro.com>
In-Reply-To: <20230403093310.2271142-7-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 4 Apr 2023 06:25:24 +0530
Message-ID: <CAOnJCU+4Qd=KBc98p-dN5+y8LCGY0x12rZP-RC0d7UsiN+7tiA@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
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
> We implement ONE_REG interface for AIA CSRs as a separate subtype
> under the CSR ONE_REG interface.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 8 ++++++++
>  arch/riscv/kvm/vcpu.c             | 8 ++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 182023dc9a51..cbc3e74fa670 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -79,6 +79,10 @@ struct kvm_riscv_csr {
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
> @@ -107,6 +111,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
>         KVM_RISCV_ISA_EXT_ZICBOM,
>         KVM_RISCV_ISA_EXT_ZBB,
> +       KVM_RISCV_ISA_EXT_SSAIA,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> @@ -153,8 +158,11 @@ enum KVM_RISCV_SBI_EXT_ID {
>  /* Control and status registers are mapped as type 3 */
>  #define KVM_REG_RISCV_CSR              (0x03 << KVM_REG_RISCV_TYPE_SHIFT=
)
>  #define KVM_REG_RISCV_CSR_GENERAL      (0x0 << KVM_REG_RISCV_SUBTYPE_SHI=
FT)
> +#define KVM_REG_RISCV_CSR_AIA          (0x1 << KVM_REG_RISCV_SUBTYPE_SHI=
FT)
>  #define KVM_REG_RISCV_CSR_REG(name)    \
>                 (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned l=
ong))
> +#define KVM_REG_RISCV_CSR_AIA_REG(name)        \
> +       (offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long)=
)
>
>  /* Timer registers are mapped as type 4 */
>  #define KVM_REG_RISCV_TIMER            (0x04 << KVM_REG_RISCV_TYPE_SHIFT=
)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index aca6b4fb7519..15507cd3a595 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -58,6 +58,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         [KVM_RISCV_ISA_EXT_I] =3D RISCV_ISA_EXT_i,
>         [KVM_RISCV_ISA_EXT_M] =3D RISCV_ISA_EXT_m,
>
> +       KVM_ISA_EXT_ARR(SSAIA),
>         KVM_ISA_EXT_ARR(SSTC),
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVPBMT),
> @@ -97,6 +98,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned=
 long ext)
>         case KVM_RISCV_ISA_EXT_C:
>         case KVM_RISCV_ISA_EXT_I:
>         case KVM_RISCV_ISA_EXT_M:
> +       case KVM_RISCV_ISA_EXT_SSAIA:
>         case KVM_RISCV_ISA_EXT_SSTC:
>         case KVM_RISCV_ISA_EXT_SVINVAL:
>         case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
> @@ -520,6 +522,9 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu=
 *vcpu,
>         case KVM_REG_RISCV_CSR_GENERAL:
>                 rc =3D kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg=
_val);
>                 break;
> +       case KVM_REG_RISCV_CSR_AIA:
> +               rc =3D kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val=
);
> +               break;
>         default:
>                 rc =3D -EINVAL;
>                 break;
> @@ -556,6 +561,9 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu=
 *vcpu,
>         case KVM_REG_RISCV_CSR_GENERAL:
>                 rc =3D kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_=
val);
>                 break;
> +       case KVM_REG_RISCV_CSR_AIA:
> +               rc =3D kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val)=
;
> +               break;
>         default:
>                 rc =3D -EINVAL;
>                 break;
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish
