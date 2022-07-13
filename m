Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01177572ABE
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 03:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiGMBYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 21:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiGMBYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 21:24:02 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6016D2CCBE
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:24:01 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id n74so16919326yba.3
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YxOh0nLFFVmYSRH0bGoSLFMwaYMfiAsAxktFavty9+E=;
        b=A/l4VpczNL+qIPVoPAmdw5rmr3hZET1GfjqWyIQyU6QVbLdHkupXiiGeAivJMI5Y2q
         UUED2SFUDX7v6cJBHpLH6mTaw26pLid3XLm4YpAleqf6ybOVqlITCQo0zJoErF59t++V
         Vhf/vlRY1AvKBd7Pkv54IVx2HwmVDaQvyyVLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YxOh0nLFFVmYSRH0bGoSLFMwaYMfiAsAxktFavty9+E=;
        b=h5aFEOZFsUrEAFfFoRYMtPBpWUGEaJr4Jf0Zzjb+OgMKMIAkmrqmQSQ8P+HSZJ3B0B
         qQ3mGrtXzBd3IDYRwejS6JOOtN16mRzMR2FyLiH5pzfIpE35LqazgO+Ehp/U3u5cmv9j
         mUxj+Ye82Z0mnrpNsm7+xyc+NdEtV4pR5+AvgVWSLGGnkudV5Jtb5yrhooETeT+UeKpt
         L1iXGetKZzDyBvcl87ZsXjPr56e+tGUXp001+790oDAMS1gF0L7sMaqCUZq0eWHIiU4Y
         ZHNrG/xH7IGFQioEvHta+D8X67B53egmNxuYe++XwCuoD+UBJOUvB/I8oizPOfRGHGnu
         kdCA==
X-Gm-Message-State: AJIora8eRrRtxs+usw4RAEnLYZ9uZUKRIbNAp/MwrWqAW/3fmWblS5Tq
        WIJA5ZEaVR+7TsR7/8g96fG6re4uJln6pi+Tgy/M
X-Google-Smtp-Source: AGRyM1vEKkssVrNxZ28zlQCEI65AGSBjQ9cE5H7vmQHY8qoVVQohpUQteCrlS9kr714Wr1mcNE3jYQ/qcwwecPy33H0=
X-Received: by 2002:a05:6902:154e:b0:66e:6718:f6f2 with SMTP id
 r14-20020a056902154e00b0066e6718f6f2mr1293389ybu.228.1657675440625; Tue, 12
 Jul 2022 18:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220707145248.458771-1-apatel@ventanamicro.com> <20220707145248.458771-6-apatel@ventanamicro.com>
In-Reply-To: <20220707145248.458771-6-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 12 Jul 2022 18:23:50 -0700
Message-ID: <CAOnJCU+H_inpUj1EuvqEYx41iEguCdcC4B3Lr9TWdo+aFhFNAA@mail.gmail.com>
Subject: Re: [PATCH 5/5] RISC-V: KVM: Add support for Svpbmt inside Guest/VM
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 7, 2022 at 7:53 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The Guest/VM can use Svpbmt in VS-stage page tables when allowed by the
> Hypervisor using the henvcfg.PBMTE bit.
>
> We add Svpbmt support for the KVM Guest/VM which can be enabled/disabled
> by the KVM user-space (QEMU/KVMTOOL) using the ISA extension ONE_REG
> interface.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/csr.h      | 16 ++++++++++++++++
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/vcpu.c             | 16 ++++++++++++++++
>  3 files changed, 33 insertions(+)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 6d85655e7edf..17516afc389a 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -156,6 +156,18 @@
>                                  (_AC(1, UL) << IRQ_S_TIMER) | \
>                                  (_AC(1, UL) << IRQ_S_EXT))
>
> +/* xENVCFG flags */
> +#define ENVCFG_STCE                    (_AC(1, ULL) << 63)
> +#define ENVCFG_PBMTE                   (_AC(1, ULL) << 62)
> +#define ENVCFG_CBZE                    (_AC(1, UL) << 7)
> +#define ENVCFG_CBCFE                   (_AC(1, UL) << 6)
> +#define ENVCFG_CBIE_SHIFT              4
> +#define ENVCFG_CBIE                    (_AC(0x3, UL) << ENVCFG_CBIE_SHIFT)
> +#define ENVCFG_CBIE_ILL                        _AC(0x0, UL)
> +#define ENVCFG_CBIE_FLUSH              _AC(0x1, UL)
> +#define ENVCFG_CBIE_INV                        _AC(0x3, UL)
> +#define ENVCFG_FIOM                    _AC(0x1, UL)
> +
>  /* symbolic CSR names: */
>  #define CSR_CYCLE              0xc00
>  #define CSR_TIME               0xc01
> @@ -252,7 +264,9 @@
>  #define CSR_HTIMEDELTA         0x605
>  #define CSR_HCOUNTEREN         0x606
>  #define CSR_HGEIE              0x607
> +#define CSR_HENVCFG            0x60a
>  #define CSR_HTIMEDELTAH                0x615
> +#define CSR_HENVCFGH           0x61a
>  #define CSR_HTVAL              0x643
>  #define CSR_HIP                        0x644
>  #define CSR_HVIP               0x645
> @@ -264,6 +278,8 @@
>  #define CSR_MISA               0x301
>  #define CSR_MIE                        0x304
>  #define CSR_MTVEC              0x305
> +#define CSR_MENVCFG            0x30a
> +#define CSR_MENVCFGH           0x31a
>  #define CSR_MSCRATCH           0x340
>  #define CSR_MEPC               0x341
>  #define CSR_MCAUSE             0x342
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 6119368ba6d5..24b2a6e27698 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -96,6 +96,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_H,
>         KVM_RISCV_ISA_EXT_I,
>         KVM_RISCV_ISA_EXT_M,
> +       KVM_RISCV_ISA_EXT_SVPBMT,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 6dd9cf729614..b7a433c54d0f 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -51,6 +51,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>         RISCV_ISA_EXT_h,
>         RISCV_ISA_EXT_i,
>         RISCV_ISA_EXT_m,
> +       RISCV_ISA_EXT_SVPBMT,
>  };
>
>  static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
> @@ -777,6 +778,19 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>         return -EINVAL;
>  }
>
> +static void kvm_riscv_vcpu_update_config(const unsigned long *isa)
> +{
> +       u64 henvcfg = 0;
> +
> +       if (__riscv_isa_extension_available(isa, RISCV_ISA_EXT_SVPBMT))
> +               henvcfg |= ENVCFG_PBMTE;
> +
> +       csr_write(CSR_HENVCFG, henvcfg);
> +#ifdef CONFIG_32BIT
> +       csr_write(CSR_HENVCFGH, henvcfg >> 32);
> +#endif
> +}
> +
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>         struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> @@ -791,6 +805,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>         csr_write(CSR_HVIP, csr->hvip);
>         csr_write(CSR_VSATP, csr->vsatp);
>
> +       kvm_riscv_vcpu_update_config(vcpu->arch.isa);
> +
>         kvm_riscv_gstage_update_hgatp(vcpu);
>
>         kvm_riscv_vcpu_timer_restore(vcpu);
> --
> 2.34.1
>

LGTM.


Reviewed-by: Atish Patra <atishp@rivosinc.com>


-- 
Regards,
Atish
