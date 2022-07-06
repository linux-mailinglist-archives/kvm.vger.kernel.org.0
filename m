Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89288567DDC
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 07:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiGFFe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 01:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGFFe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 01:34:57 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8DE20F55
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 22:34:55 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v16so8908908wrd.13
        for <kvm@vger.kernel.org>; Tue, 05 Jul 2022 22:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mzFfzfxTcWfRcShNhy6xy755LFsV+j5QNgB0bsRHMsA=;
        b=X42NG2+Sf0aWnqfS4qfOpCqXAfEE+6CCMdfftkTlEBQCdYnFhYljaLQSmS+t+7AzCA
         gFzpyvgQUYsfXWK13XxOuCWYdTEQbzHNpTFMMkj9DQvbSux5DxDNLluyFQ5cd0K7DUvw
         wR/mxVgt6/v39eZd6NDcRh3njWgDAGoJLR+P8PkQN/T7dsERTtxxyhdgLSsR1ar2zzsI
         1TWk7Fdu/ej/nxidStT986zS7/AxOUCi59ZIiIrW5rkvkqfWRPZmfw0nJMg7VrAg3ssd
         +EkPI9EwNIuB+nkyibVjL/T8eNfhfRK5eNZNXDeoECLuPzvKRyGg2Jg6FX9WOyan2Qar
         GVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mzFfzfxTcWfRcShNhy6xy755LFsV+j5QNgB0bsRHMsA=;
        b=0/2nt1Ph1+KxP4bIXRRddiq6kUF+S/14NubxkHdPJO+wJOz69T3g+dy8O+e0bxJxMw
         9jGpHtaNIyC6HlYZ+wDVJp1TM+LMpqT7gCz7QowzmGB01xigr4sFqkByLxD0ETC4etsO
         sGthlOruDOPya94wve3AjUtixpmIDUCisfjf2reaTur6ylz0pKgfzhVclDG0WOIjGIJr
         RvAeGFPY+beGvkL02oISy3GTJHUHfCNsxGbsiCc6Dismaqd5yWTdM4guyyTDyyP1q134
         Zby+6q1NN03W0wNMiaJx90UkFszCYPqdrhj2pDuymsn2NOlRglRMj8SOf5tgAQpOU7pj
         MMbw==
X-Gm-Message-State: AJIora/l1DcY7nULv7S4IgBvYexk51mwnKg4e5QmivszGbkISyKx59nN
        9cPvQWOML+4VyMhCzQEOB2Hb5vfV3N2ti87HSsRsrA==
X-Google-Smtp-Source: AGRyM1vyL5ovhu/btsIvVSG5+9OXLps7/KAEAuZRnTn1XLvqNJBXZNftteTtbHZgDDq3aVm+vcB58YxTc38C+GSX5IQ=
X-Received: by 2002:adf:e9cf:0:b0:21d:7b89:da5 with SMTP id
 l15-20020adfe9cf000000b0021d7b890da5mr1872606wrn.346.1657085693935; Tue, 05
 Jul 2022 22:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220620234254.2610040-1-atishp@rivosinc.com> <CAAhSdy2ziUJV2vozZw+vDiA+-Xa5pNiC=Dy_gapCApoR4bnxWg@mail.gmail.com>
 <CAHBxVyFQUdNYdtt_d3MtOGnSGz8TKr7e-LuUi7fJT90TMykGTw@mail.gmail.com>
In-Reply-To: <CAHBxVyFQUdNYdtt_d3MtOGnSGz8TKr7e-LuUi7fJT90TMykGTw@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 6 Jul 2022 11:04:40 +0530
Message-ID: <CAAhSdy3gQ3Zwqd+xZzK4No9znUZruH8hbXs74HCAEJX8HmOYvw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Improve ISA extension by using a bitmap
To:     Atish Kumar Patra <atishp@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 5, 2022 at 12:53 PM Atish Kumar Patra <atishp@rivosinc.com> wrote:
>
> On Mon, Jul 4, 2022 at 1:47 AM Anup Patel <anup@brainfault.org> wrote:
> >
> > On Tue, Jun 21, 2022 at 5:13 AM Atish Patra <atishp@rivosinc.com> wrote:
> > >
> > > Currently, the every vcpu only stores the ISA extensions in a unsigned long
> > > which is not scalable as number of extensions will continue to grow.
> > > Using a bitmap allows the ISA extension to support any number of
> > > extensions. The CONFIG one reg interface implementation is modified to
> > > support the bitmap as well. But it is meant only for base extensions.
> > > Thus, the first element of the bitmap array is sufficient for that
> > > interface.
> > >
> > > In the future, all the new multi-letter extensions must use the
> > > ISA_EXT one reg interface that allows enabling/disabling any extension
> > > now.
> > >
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > ---
> > >  arch/riscv/include/asm/kvm_host.h    |  3 +-
> > >  arch/riscv/include/asm/kvm_vcpu_fp.h |  8 +--
> > >  arch/riscv/kvm/vcpu.c                | 81 ++++++++++++++--------------
> > >  arch/riscv/kvm/vcpu_fp.c             | 27 +++++-----
> > >  4 files changed, 59 insertions(+), 60 deletions(-)
> > >
> > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > > index 319c8aeb42af..c749cdacbd63 100644
> > > --- a/arch/riscv/include/asm/kvm_host.h
> > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > @@ -14,6 +14,7 @@
> > >  #include <linux/kvm_types.h>
> > >  #include <linux/spinlock.h>
> > >  #include <asm/csr.h>
> > > +#include <asm/hwcap.h>
> > >  #include <asm/kvm_vcpu_fp.h>
> > >  #include <asm/kvm_vcpu_timer.h>
> > >
> > > @@ -170,7 +171,7 @@ struct kvm_vcpu_arch {
> > >         int last_exit_cpu;
> > >
> > >         /* ISA feature bits (similar to MISA) */
> > > -       unsigned long isa;
> > > +       DECLARE_BITMAP(isa, RISCV_ISA_EXT_MAX);
> > >
> > >         /* SSCRATCH, STVEC, and SCOUNTEREN of Host */
> > >         unsigned long host_sscratch;
> > > diff --git a/arch/riscv/include/asm/kvm_vcpu_fp.h b/arch/riscv/include/asm/kvm_vcpu_fp.h
> > > index 4da9b8e0f050..e86bb67f2a8a 100644
> > > --- a/arch/riscv/include/asm/kvm_vcpu_fp.h
> > > +++ b/arch/riscv/include/asm/kvm_vcpu_fp.h
> > > @@ -22,9 +22,9 @@ void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
> > >
> > >  void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu);
> > >  void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> > > -                                 unsigned long isa);
> > > +                                 unsigned long *isa);
> >
> > Better to use "const unsigned long *"
> >
> > >  void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
> > > -                                    unsigned long isa);
> > > +                                    unsigned long *isa);
> >
> > Same as above.
> >
>
> Yes. Thanks.
>
> > >  void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx);
> > >  void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx);
> > >  #else
> > > @@ -32,12 +32,12 @@ static inline void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
> > >  {
> > >  }
> > >  static inline void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> > > -                                               unsigned long isa)
> > > +                                               unsigned long *isa)
> > >  {
> > >  }
> > >  static inline void kvm_riscv_vcpu_guest_fp_restore(
> > >                                         struct kvm_cpu_context *cntx,
> > > -                                       unsigned long isa)
> > > +                                       unsigned long *isa)
> > >  {
> > >  }
> > >  static inline void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
> > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > index 7f4ad5e4373a..cb2a65b5d563 100644
> > > --- a/arch/riscv/kvm/vcpu.c
> > > +++ b/arch/riscv/kvm/vcpu.c
> > > @@ -46,8 +46,19 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
> > >                                                 riscv_isa_extension_mask(i) | \
> > >                                                 riscv_isa_extension_mask(m))
> > >
> > > -#define KVM_RISCV_ISA_ALLOWED (KVM_RISCV_ISA_DISABLE_ALLOWED | \
> > > -                              KVM_RISCV_ISA_DISABLE_NOT_ALLOWED)
> > > +#define KVM_RISCV_ISA_MASK GENMASK(25, 0)
> > > +
> > > +/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
> > > +static unsigned long kvm_isa_ext_arr[] = {
> > > +       RISCV_ISA_EXT_a,
> > > +       RISCV_ISA_EXT_c,
> > > +       RISCV_ISA_EXT_d,
> > > +       RISCV_ISA_EXT_f,
> > > +       RISCV_ISA_EXT_h,
> > > +       RISCV_ISA_EXT_i,
> > > +       RISCV_ISA_EXT_m,
> > > +       RISCV_ISA_EXT_SSCOFPMF,
> >
> > The RISCV_ISA_EXT_SSCOFPMF should be added only after we have
> > SBI PMU support in KVM RISC-V. Please drop it.
> >
>
> Ahh. Sorry. I forgot to remove it while rebasing.
>
> > > +};
> > >
> > >  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> > >  {
> > > @@ -99,13 +110,20 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >  {
> > >         struct kvm_cpu_context *cntx;
> > >         struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
> > > +       unsigned long host_isa, i;
> > >
> > >         /* Mark this VCPU never ran */
> > >         vcpu->arch.ran_atleast_once = false;
> > >         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > > +       bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
> > >
> > >         /* Setup ISA features available to VCPU */
> > > -       vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
> > > +       for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
> > > +               host_isa = kvm_isa_ext_arr[i];
> > > +               if (__riscv_isa_extension_available(NULL, host_isa) &&
> > > +                  host_isa != RISCV_ISA_EXT_h)
> > > +                       set_bit(host_isa, vcpu->arch.isa);
> > > +       }
> > >
> > >         /* Setup VCPU hfence queue */
> > >         spin_lock_init(&vcpu->arch.hfence_lock);
> > > @@ -199,7 +217,7 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
> > >
> > >         switch (reg_num) {
> > >         case KVM_REG_RISCV_CONFIG_REG(isa):
> > > -               reg_val = vcpu->arch.isa;
> > > +               reg_val = vcpu->arch.isa[0] & KVM_RISCV_ISA_MASK;
> > >                 break;
> > >         default:
> > >                 return -EINVAL;
> > > @@ -220,6 +238,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
> > >                                             KVM_REG_SIZE_MASK |
> > >                                             KVM_REG_RISCV_CONFIG);
> > >         unsigned long reg_val;
> > > +       unsigned long isa_mask;
> > >
> > >         if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> > >                 return -EINVAL;
> > > @@ -227,13 +246,19 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
> > >         if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> > >                 return -EFAULT;
> > >
> > > +       /* This ONE REG interface is only defined for single letter extensions */
> > > +       if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
> > > +               return -EINVAL;
> > > +
> > >         switch (reg_num) {
> > >         case KVM_REG_RISCV_CONFIG_REG(isa):
> > >                 if (!vcpu->arch.ran_atleast_once) {
> > >                         /* Ignore the disable request for these extensions */
> > > -                       vcpu->arch.isa = reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
> > > -                       vcpu->arch.isa &= riscv_isa_extension_base(NULL);
> > > -                       vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> > > +                       isa_mask = (reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED);
> > > +                       isa_mask &= riscv_isa_extension_base(NULL);
> > > +                       /* Do not modify anything beyond single letter extensions */
> > > +                       isa_mask |= (~KVM_RISCV_ISA_MASK);
> > > +                       bitmap_and(vcpu->arch.isa, vcpu->arch.isa, &isa_mask, RISCV_ISA_EXT_MAX);
> >
> > A little more readable version of above sequence can be:
> >
> >             /* Ignore the disable request for these extensions */
> >             reg_val |= KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
> >             reg_val &= riscv_isa_extension_base(NULL);
> >             /* Do not modify anything beyond single letter extensions */
> >             reg_val = (vcpu->arch.isa[0] & ~KVM_RISCV_ISA_MASK) |
> >                   (reg_val & KVM_RISCV_ISA_MASK);
> >             vcpu->arch.isa[0] = reg_val;
> >             kvm_riscv_vcpu_fp_reset(vcpu);
> >
> >
> > >                         kvm_riscv_vcpu_fp_reset(vcpu);
> > >                 } else {
> > >                         return -EOPNOTSUPP;
> > > @@ -374,17 +399,6 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
> > >         return 0;
> > >  }
> > >
> > > -/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
> > > -static unsigned long kvm_isa_ext_arr[] = {
> > > -       RISCV_ISA_EXT_a,
> > > -       RISCV_ISA_EXT_c,
> > > -       RISCV_ISA_EXT_d,
> > > -       RISCV_ISA_EXT_f,
> > > -       RISCV_ISA_EXT_h,
> > > -       RISCV_ISA_EXT_i,
> > > -       RISCV_ISA_EXT_m,
> > > -};
> > > -
> > >  static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
> > >                                           const struct kvm_one_reg *reg)
> > >  {
> > > @@ -403,7 +417,7 @@ static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
> > >                 return -EINVAL;
> > >
> > >         host_isa_ext = kvm_isa_ext_arr[reg_num];
> > > -       if (__riscv_isa_extension_available(&vcpu->arch.isa, host_isa_ext))
> > > +       if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
> > >                 reg_val = 1; /* Mark the given extension as available */
> > >
> > >         if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > > @@ -437,30 +451,17 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
> > >         if (!__riscv_isa_extension_available(NULL, host_isa_ext))
> > >                 return  -EOPNOTSUPP;
> > >
> > > -       if (host_isa_ext >= RISCV_ISA_EXT_BASE &&
> > > -           host_isa_ext < RISCV_ISA_EXT_MAX) {
> > > -               /*
> > > -                * Multi-letter ISA extension. Currently there is no provision
> > > -                * to enable/disable the multi-letter ISA extensions for guests.
> > > -                * Return success if the request is to enable any ISA extension
> > > -                * that is available in the hardware.
> > > -                * Return -EOPNOTSUPP otherwise.
> > > -                */
> > > -               if (!reg_val)
> > > -                       return -EOPNOTSUPP;
> > > -               else
> > > -                       return 0;
> > > -       }
> > > -
> > > -       /* Single letter base ISA extension */
> > >         if (!vcpu->arch.ran_atleast_once) {
> > > +               /* All multi-letter extension and a few single letter extension can be disabled */
> > >                 host_isa_ext_mask = BIT_MASK(host_isa_ext);
> > > -               if (!reg_val && (host_isa_ext_mask & KVM_RISCV_ISA_DISABLE_ALLOWED))
> > > -                       vcpu->arch.isa &= ~host_isa_ext_mask;
> > > +               if (!reg_val &&
> > > +                  ((host_isa_ext_mask & KVM_RISCV_ISA_DISABLE_ALLOWED) ||
> > > +                  ((host_isa_ext >= RISCV_ISA_EXT_BASE) && (host_isa_ext < RISCV_ISA_EXT_MAX))))
> > > +                       clear_bit(host_isa_ext, vcpu->arch.isa);
> > > +               else if (reg_val == 1 && (host_isa_ext != RISCV_ISA_EXT_h))
> > > +                       set_bit(host_isa_ext, vcpu->arch.isa);
> > >                 else
> > > -                       vcpu->arch.isa |= host_isa_ext_mask;
> > > -               vcpu->arch.isa &= riscv_isa_extension_base(NULL);
> > > -               vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> > > +                       return -EINVAL;
> >
> > A slightly more readable version of above sequence can be:
> >
> >         /* All multi-letter extension and a few single letter
> > extension can be disabled */
> >         if (host_isa_ext >= RISCV_ISA_EXT_MAX)
> >             return -EINVAL;
> >         disable_allow_mask = KVM_RISCV_ISA_DISABLE_ALLOWED;
> >         if (reg_val == 1)
> >             set_bit(host_isa_ext, vcpu->arch.isa);
>
> Shouldn't we ensure that (host_isa_ext != RISCV_ISA_EXT_h) here ?

Ahh, yes. I have updated the KVM queue.

Thanks,
Anup

>
> >         else if (!reg_val && test_bit(host_isa_ext, &disable_allow_mask))
> >             clear_bit(host_isa_ext, vcpu->arch.isa);
> >         else
> >             return -EINVAL;
> >
> >
> > >                 kvm_riscv_vcpu_fp_reset(vcpu);
> > >         } else {
> > >                 return -EOPNOTSUPP;
> > > diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
> > > index d4308c512007..748a8f6a9b5d 100644
> > > --- a/arch/riscv/kvm/vcpu_fp.c
> > > +++ b/arch/riscv/kvm/vcpu_fp.c
> > > @@ -16,12 +16,11 @@
> > >  #ifdef CONFIG_FPU
> > >  void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
> > >  {
> > > -       unsigned long isa = vcpu->arch.isa;
> > >         struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> > >
> > >         cntx->sstatus &= ~SR_FS;
> > > -       if (riscv_isa_extension_available(&isa, f) ||
> > > -           riscv_isa_extension_available(&isa, d))
> > > +       if (riscv_isa_extension_available(vcpu->arch.isa, f) ||
> > > +           riscv_isa_extension_available(vcpu->arch.isa, d))
> > >                 cntx->sstatus |= SR_FS_INITIAL;
> > >         else
> > >                 cntx->sstatus |= SR_FS_OFF;
> > > @@ -34,24 +33,24 @@ static void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
> > >  }
> > >
> > >  void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> > > -                                 unsigned long isa)
> > > +                                 unsigned long *isa)
> > >  {
> > >         if ((cntx->sstatus & SR_FS) == SR_FS_DIRTY) {
> > > -               if (riscv_isa_extension_available(&isa, d))
> > > +               if (riscv_isa_extension_available(isa, d))
> > >                         __kvm_riscv_fp_d_save(cntx);
> > > -               else if (riscv_isa_extension_available(&isa, f))
> > > +               else if (riscv_isa_extension_available(isa, f))
> > >                         __kvm_riscv_fp_f_save(cntx);
> > >                 kvm_riscv_vcpu_fp_clean(cntx);
> > >         }
> > >  }
> > >
> > >  void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
> > > -                                    unsigned long isa)
> > > +                                    unsigned long *isa)
> > >  {
> > >         if ((cntx->sstatus & SR_FS) != SR_FS_OFF) {
> > > -               if (riscv_isa_extension_available(&isa, d))
> > > +               if (riscv_isa_extension_available(isa, d))
> > >                         __kvm_riscv_fp_d_restore(cntx);
> > > -               else if (riscv_isa_extension_available(&isa, f))
> > > +               else if (riscv_isa_extension_available(isa, f))
> > >                         __kvm_riscv_fp_f_restore(cntx);
> > >                 kvm_riscv_vcpu_fp_clean(cntx);
> > >         }
> > > @@ -80,7 +79,6 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
> > >                               unsigned long rtype)
> > >  {
> > >         struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> > > -       unsigned long isa = vcpu->arch.isa;
> > >         unsigned long __user *uaddr =
> > >                         (unsigned long __user *)(unsigned long)reg->addr;
> > >         unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> > > @@ -89,7 +87,7 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
> > >         void *reg_val;
> > >
> > >         if ((rtype == KVM_REG_RISCV_FP_F) &&
> > > -           riscv_isa_extension_available(&isa, f)) {
> > > +           riscv_isa_extension_available(vcpu->arch.isa, f)) {
> > >                 if (KVM_REG_SIZE(reg->id) != sizeof(u32))
> > >                         return -EINVAL;
> > >                 if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
> > > @@ -100,7 +98,7 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
> > >                 else
> > >                         return -EINVAL;
> > >         } else if ((rtype == KVM_REG_RISCV_FP_D) &&
> > > -                  riscv_isa_extension_available(&isa, d)) {
> > > +                  riscv_isa_extension_available(vcpu->arch.isa, d)) {
> > >                 if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
> > >                         if (KVM_REG_SIZE(reg->id) != sizeof(u32))
> > >                                 return -EINVAL;
> > > @@ -126,7 +124,6 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
> > >                               unsigned long rtype)
> > >  {
> > >         struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> > > -       unsigned long isa = vcpu->arch.isa;
> > >         unsigned long __user *uaddr =
> > >                         (unsigned long __user *)(unsigned long)reg->addr;
> > >         unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> > > @@ -135,7 +132,7 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
> > >         void *reg_val;
> > >
> > >         if ((rtype == KVM_REG_RISCV_FP_F) &&
> > > -           riscv_isa_extension_available(&isa, f)) {
> > > +           riscv_isa_extension_available(vcpu->arch.isa, f)) {
> > >                 if (KVM_REG_SIZE(reg->id) != sizeof(u32))
> > >                         return -EINVAL;
> > >                 if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
> > > @@ -146,7 +143,7 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
> > >                 else
> > >                         return -EINVAL;
> > >         } else if ((rtype == KVM_REG_RISCV_FP_D) &&
> > > -                  riscv_isa_extension_available(&isa, d)) {
> > > +                  riscv_isa_extension_available(vcpu->arch.isa, d)) {
> > >                 if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
> > >                         if (KVM_REG_SIZE(reg->id) != sizeof(u32))
> > >                                 return -EINVAL;
> > > --
> > > 2.25.1
> > >
> >
> > Apart from minor comments above, this looks good to me.
> >
> Thanks.
>
> > I have taken care of the above comments and queued it for 5.20. I
> > can certainly modify my queue if you want further changes in this patch.
> >
> > Thanks,
> > Anup
