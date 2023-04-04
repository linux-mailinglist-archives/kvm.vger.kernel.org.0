Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C076D62D5
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbjDDNbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbjDDNbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:31:39 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B956030EB
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:31:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w9so130668498edc.3
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 06:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680615095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/ds9NpyuRhCvifXQyS7v5NuGB8FfZD9VQITzq9CDXA=;
        b=ZF0oGdchf0gdsW2WRMROT8vWqiJbzLIIwCudRGKfDUn1HYZPKFm3oJ5mweJf5tXxw0
         IYYOeGj6be5HbtlnU7+ePQBDsuJpMmOQ96ZN9asWGy0wiiqiBS9P3aEyB6zsDaLBtdY0
         tuOshgdlgdejqxccnevs09IEBUP4yHIFQQQhqSi3gXShsyv467UA1Z7qCGHV2+dWw8H8
         fM8T4j46dmYeRfGRHO9tRKxoPZ+J2QMHywkdNVAvYNECBmejygofrRvmmVuIIpH42KuW
         kpUzpBBd8iLSEgYVUvB+pcdO9EFoFnPs1VXTZTt9spwiQDc2uS2/9s1kbtUBYECwGsZB
         1DLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680615095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/ds9NpyuRhCvifXQyS7v5NuGB8FfZD9VQITzq9CDXA=;
        b=G2CRhZeBaSf5zChTm+WSYPhT2lI07GtSIUF2X72F4oqYFtlaRZdEmF1kVz9ndyQMa1
         m97GQ9XB0/YsPypSERG7uKpJTYKdMPrm2feJPa1wFJaIlGg/0eEwe0zmpje1cPb3Iw2l
         UqS6KcZ9Gbu+sctSNJIjn2Y2WmOhywo+byJW2u3yU6fyDrw+K+wMFtzqJ4PtNcuG26rt
         lXuiZTbpz3WENcKTN7RHOD5i/JCYUYz15IRtLDn1z0hNUwv9JEtChh5+IqVS0v8pbjmA
         5rlDYSYgkTU5cAQJhirFb58VXhGVz9SDOPBoBjQZDFb2WqZcrxQHuSJ0x8IGkaj0c7Yv
         gMBQ==
X-Gm-Message-State: AAQBX9eF/G7mH1jLvHtyZJSvhBoKH2VUSSwUVfXz6/4J0yWrPGvFAf92
        gZYS0sLm7As6C8FymQ7Zw81UuiYdioM4LYBv9H7cCQ==
X-Google-Smtp-Source: AKy350boR41Zdxva5Gc1YqIkkPWL7c82yl25E9+LolW6nb/UzMUAEDIJ2sUIQmIOy/29BQYbjrHsF+Kwo5rTr6OEz+4=
X-Received: by 2002:a17:906:fe0c:b0:949:2293:1d1a with SMTP id
 wy12-20020a170906fe0c00b0094922931d1amr955112ejb.13.1680615095053; Tue, 04
 Apr 2023 06:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-8-apatel@ventanamicro.com> <boauaf7zkv6bai4jqw7gjp5yexmwgecinen2ss7s2r2qxfn7xv@4jbglkwtrafk>
In-Reply-To: <boauaf7zkv6bai4jqw7gjp5yexmwgecinen2ss7s2r2qxfn7xv@4jbglkwtrafk>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 4 Apr 2023 19:01:22 +0530
Message-ID: <CAAhSdy0j4913zREuMhu_UckL03kc3rOz5w4_kjeEfHJ6zTidrQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] RISC-V: KVM: Virtualize per-HART AIA CSRs
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
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

On Mon, Apr 3, 2023 at 10:07=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Mon, Apr 03, 2023 at 03:03:09PM +0530, Anup Patel wrote:
> > The AIA specification introduce per-HART AIA CSRs which primarily
> > support:
> > * 64 local interrupts on both RV64 and RV32
> > * priority for each of the 64 local interrupts
> > * interrupt filtering for local interrupts
> >
> > This patch virtualize above mentioned AIA CSRs and also extend
> > ONE_REG interface to allow user-space save/restore Guest/VM
> > view of these CSRs.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_aia.h  |  88 +++++----
> >  arch/riscv/include/asm/kvm_host.h |   7 +-
> >  arch/riscv/include/uapi/asm/kvm.h |   7 +
> >  arch/riscv/kvm/aia.c              | 317 ++++++++++++++++++++++++++++++
> >  arch/riscv/kvm/vcpu.c             |  53 +++--
> >  5 files changed, 415 insertions(+), 57 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/=
kvm_aia.h
> > index 258a835d4c32..1de0717112e5 100644
> > --- a/arch/riscv/include/asm/kvm_aia.h
> > +++ b/arch/riscv/include/asm/kvm_aia.h
>
> nit: Generating the diff with --patience makes this a bit easier to read,
> and/or several of the stub functions could have been directly put in
> arch/riscv/kvm/aia.c in the skeleton patch to avoid so many changes in
> this one.

If we have stubs as inline functions in the header then these are
optimized out by the compiler until actual function definition is available=
.

>
> > @@ -12,6 +12,7 @@
> >
> >  #include <linux/jump_label.h>
> >  #include <linux/kvm_types.h>
> > +#include <asm/csr.h>
> >
> >  struct kvm_aia {
> >       /* In-kernel irqchip created */
> > @@ -21,7 +22,22 @@ struct kvm_aia {
> >       bool            initialized;
> >  };
> >
> > +struct kvm_vcpu_aia_csr {
> > +     unsigned long vsiselect;
> > +     unsigned long hviprio1;
> > +     unsigned long hviprio2;
> > +     unsigned long vsieh;
> > +     unsigned long hviph;
> > +     unsigned long hviprio1h;
> > +     unsigned long hviprio2h;
> > +};
> > +
> >  struct kvm_vcpu_aia {
> > +     /* CPU AIA CSR context of Guest VCPU */
> > +     struct kvm_vcpu_aia_csr guest_csr;
> > +
> > +     /* CPU AIA CSR context upon Guest VCPU reset */
> > +     struct kvm_vcpu_aia_csr guest_reset_csr;
> >  };
> >
> >  #define kvm_riscv_aia_initialized(k) ((k)->arch.aia.initialized)
> > @@ -32,48 +48,50 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
> >  #define kvm_riscv_aia_available() \
> >       static_branch_unlikely(&kvm_riscv_aia_available)
> >
> > -static inline void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu=
 *vcpu)
> > -{
> > -}
> > -
> > -static inline void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu =
*vcpu)
> > -{
> > -}
> > -
> > -static inline bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *=
vcpu,
> > -                                                  u64 mask)
> > -{
> > -     return false;
> > -}
> > -
> > -static inline void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcp=
u)
> > -{
> > -}
> > -
> > -static inline void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int =
cpu)
> > -{
> > -}
> > -
> > -static inline void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> > +#define KVM_RISCV_AIA_IMSIC_TOPEI    (ISELECT_MASK + 1)
> > +static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
> > +                                            unsigned long isel,
> > +                                            unsigned long *val,
> > +                                            unsigned long new_val,
> > +                                            unsigned long wr_mask)
> >  {
> > +     return 0;
> >  }
> >
> > -static inline int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> > -                                          unsigned long reg_num,
> > -                                          unsigned long *out_val)
> > +#ifdef CONFIG_32BIT
> > +void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu);
> > +void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu);
> > +#else
> > +static inline void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu=
 *vcpu)
> >  {
> > -     *out_val =3D 0;
> > -     return 0;
> >  }
> > -
> > -static inline int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
> > -                                          unsigned long reg_num,
> > -                                          unsigned long val)
> > +static inline void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu =
*vcpu)
> >  {
> > -     return 0;
> >  }
> > -
> > -#define KVM_RISCV_VCPU_AIA_CSR_FUNCS
> > +#endif
> > +bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask=
);
> > +
> > +void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu);
> > +void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu);
> > +void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu);
> > +int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> > +                            unsigned long reg_num,
> > +                            unsigned long *out_val);
> > +int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
> > +                            unsigned long reg_num,
> > +                            unsigned long val);
> > +
> > +int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
> > +                              unsigned int csr_num,
> > +                              unsigned long *val,
> > +                              unsigned long new_val,
> > +                              unsigned long wr_mask);
> > +int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int cs=
r_num,
> > +                             unsigned long *val, unsigned long new_val=
,
> > +                             unsigned long wr_mask);
> > +#define KVM_RISCV_VCPU_AIA_CSR_FUNCS \
> > +{ .base =3D CSR_SIREG,      .count =3D 1, .func =3D kvm_riscv_vcpu_aia=
_rmw_ireg }, \
> > +{ .base =3D CSR_STOPEI,     .count =3D 1, .func =3D kvm_riscv_vcpu_aia=
_rmw_topei },
> >
> >  static inline int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
> >  {
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > index 3157cf748df1..ee0acccb1d3b 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -204,8 +204,9 @@ struct kvm_vcpu_arch {
> >        * in irqs_pending. Our approach is modeled around multiple produ=
cer
> >        * and single consumer problem where the consumer is the VCPU its=
elf.
> >        */
> > -     unsigned long irqs_pending;
> > -     unsigned long irqs_pending_mask;
> > +#define KVM_RISCV_VCPU_NR_IRQS       64
> > +     DECLARE_BITMAP(irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
> > +     DECLARE_BITMAP(irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS);
>
> I'd prefer this ulong to bitmap change, and all its repercussions, be don=
e
> in a separate patch.

Okay, I will create a separate patch.

>
> >
> >       /* VCPU Timer */
> >       struct kvm_vcpu_timer timer;
> > @@ -334,7 +335,7 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *v=
cpu, unsigned int irq);
> >  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int=
 irq);
> >  void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
> > -bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned lon=
g mask);
> > +bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask);
> >  void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index cbc3e74fa670..c517e70ddcd6 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -81,6 +81,13 @@ struct kvm_riscv_csr {
> >
> >  /* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >  struct kvm_riscv_aia_csr {
> > +     unsigned long siselect;
> > +     unsigned long siprio1;
> > +     unsigned long siprio2;
> > +     unsigned long sieh;
> > +     unsigned long siph;
> > +     unsigned long siprio1h;
> > +     unsigned long siprio2h;
> >  };
> >
> >  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> > index 7a633331cd3e..d530912f28bc 100644
> > --- a/arch/riscv/kvm/aia.c
> > +++ b/arch/riscv/kvm/aia.c
> > @@ -26,6 +26,323 @@ static void aia_set_hvictl(bool ext_irq_pending)
> >       csr_write(CSR_HVICTL, hvictl);
> >  }
> >
> > +#ifdef CONFIG_32BIT
> > +void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> > +     unsigned long mask, val;
> > +
> > +     if (!kvm_riscv_aia_available())
> > +             return;
> > +
> > +     if (READ_ONCE(vcpu->arch.irqs_pending_mask[1])) {
> > +             mask =3D xchg_acquire(&vcpu->arch.irqs_pending_mask[1], 0=
);
> > +             val =3D READ_ONCE(vcpu->arch.irqs_pending[1]) & mask;
> > +
> > +             csr->hviph &=3D ~mask;
> > +             csr->hviph |=3D val;
> > +     }
> > +}
> > +
> > +void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> > +
> > +     if (kvm_riscv_aia_available())
> > +             csr->vsieh =3D csr_read(CSR_VSIEH);
> > +}
> > +#endif
> > +
> > +bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask=
)
> > +{
> > +     unsigned long seip;
> > +
> > +     if (!kvm_riscv_aia_available())
> > +             return false;
> > +
> > +#ifdef CONFIG_32BIT
> > +     if (READ_ONCE(vcpu->arch.irqs_pending[1]) &
> > +         (vcpu->arch.aia_context.guest_csr.vsieh & (unsigned long)(mas=
k >> 32)))
>
> upper_32_bits()

Okay, I will update.

>
> > +             return true;
> > +#endif
> > +
> > +     seip =3D vcpu->arch.guest_csr.vsie;
> > +     seip &=3D (unsigned long)mask;
> > +     seip &=3D BIT(IRQ_S_EXT);
>
> Please add a blank line above the if-statement.
>
> > +     if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
>
> Shouldn't we check kvm_riscv_aia_initialized() at the top of this
> function?

It is possible that Guest/VM uses AIA CSRs but does not
use the Guest external interrupts so kvm_riscv_aia_initialized()
should be checked afterwards.

>
> > +             return false;
> > +
> > +     return false;
>
> return true
>
> But if we move kvm_riscv_aia_initialized() up, then we instead can do
>
>  return !!seip;

Yes, this can be optimized but kvm_riscv_aia_initialized() should be
checked in middle.

>
> > +}
> > +
> > +void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> > +
> > +     if (!kvm_riscv_aia_available())
> > +             return;
> > +
> > +#ifdef CONFIG_32BIT
> > +     csr_write(CSR_HVIPH, vcpu->arch.aia_context.guest_csr.hviph);
> > +#endif
> > +     aia_set_hvictl((csr->hvip & BIT(IRQ_VS_EXT)) ? true : false);
>
> The compiler will manage the conversion of csr->hvip & BIT(IRQ_VS_EXT)
> to a 1 or 0 since it's getting passed in as a boolean parameter.

Okay, I will update.

>
> > +}
> > +
> > +void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
> > +{
> > +     struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> > +
> > +     if (!kvm_riscv_aia_available())
> > +             return;
> > +
> > +     csr_write(CSR_VSISELECT, csr->vsiselect);
> > +     csr_write(CSR_HVIPRIO1, csr->hviprio1);
> > +     csr_write(CSR_HVIPRIO2, csr->hviprio2);
> > +#ifdef CONFIG_32BIT
> > +     csr_write(CSR_VSIEH, csr->vsieh);
> > +     csr_write(CSR_HVIPH, csr->hviph);
> > +     csr_write(CSR_HVIPRIO1H, csr->hviprio1h);
> > +     csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
> > +#endif
> > +}
> > +
> > +void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> > +
> > +     if (!kvm_riscv_aia_available())
> > +             return;
> > +
> > +     csr->vsiselect =3D csr_read(CSR_VSISELECT);
> > +     csr->hviprio1 =3D csr_read(CSR_HVIPRIO1);
> > +     csr->hviprio2 =3D csr_read(CSR_HVIPRIO2);
> > +#ifdef CONFIG_32BIT
> > +     csr->vsieh =3D csr_read(CSR_VSIEH);
> > +     csr->hviph =3D csr_read(CSR_HVIPH);
> > +     csr->hviprio1h =3D csr_read(CSR_HVIPRIO1H);
> > +     csr->hviprio2h =3D csr_read(CSR_HVIPRIO2H);
> > +#endif
> > +}
> > +
> > +int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> > +                            unsigned long reg_num,
> > +                            unsigned long *out_val)
> > +{
> > +     struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> > +
> > +     if (reg_num >=3D sizeof(struct kvm_riscv_aia_csr) / sizeof(unsign=
ed long))
> > +             return -EINVAL;
> > +
> > +     *out_val =3D 0;
> > +     if (kvm_riscv_aia_available())
> > +             *out_val =3D ((unsigned long *)csr)[reg_num];
> > +
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
> > +                            unsigned long reg_num,
> > +                            unsigned long val)
> > +{
> > +     struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> > +
> > +     if (reg_num >=3D sizeof(struct kvm_riscv_aia_csr) / sizeof(unsign=
ed long))
> > +             return -EINVAL;
> > +
> > +     if (kvm_riscv_aia_available()) {
> > +             ((unsigned long *)csr)[reg_num] =3D val;
> > +
> > +#ifdef CONFIG_32BIT
> > +             if (reg_num =3D=3D KVM_REG_RISCV_CSR_AIA_REG(siph))
> > +                     WRITE_ONCE(vcpu->arch.irqs_pending_mask[1], 0);
> > +#endif
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
> > +                              unsigned int csr_num,
> > +                              unsigned long *val,
> > +                              unsigned long new_val,
> > +                              unsigned long wr_mask)
> > +{
> > +     /* If AIA not available then redirect trap */
> > +     if (!kvm_riscv_aia_available())
> > +             return KVM_INSN_ILLEGAL_TRAP;
> > +
> > +     /* If AIA not initialized then forward to user space */
> > +     if (!kvm_riscv_aia_initialized(vcpu->kvm))
> > +             return KVM_INSN_EXIT_TO_USER_SPACE;
> > +
> > +     return kvm_riscv_vcpu_aia_imsic_rmw(vcpu, KVM_RISCV_AIA_IMSIC_TOP=
EI,
> > +                                         val, new_val, wr_mask);
> > +}
> > +
> > +/*
> > + * External IRQ priority always read-only zero. This means default
> > + * priority order  is always preferred for external IRQs unless
> > + * HVICTL.IID =3D=3D 9 and HVICTL.IPRIO !=3D 0
> > + */
> > +static int aia_irq2bitpos[] =3D {
> > +0,     8,   -1,   -1,   16,   24,   -1,   -1, /* 0 - 7 */
> > +32,   -1,   -1,   -1,   -1,   40,   48,   56, /* 8 - 15 */
> > +64,   72,   80,   88,   96,  104,  112,  120, /* 16 - 23 */
> > +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 24 - 31 */
> > +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 32 - 39 */
> > +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 40 - 47 */
> > +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 48 - 55 */
> > +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 56 - 63 */
> > +};
> > +
> > +static u8 aia_get_iprio8(struct kvm_vcpu *vcpu, unsigned int irq)
> > +{
> > +     unsigned long hviprio;
> > +     int bitpos =3D aia_irq2bitpos[irq];
> > +
> > +     if (bitpos < 0)
> > +             return 0;
> > +
> > +     switch (bitpos / BITS_PER_LONG) {
> > +     case 0:
> > +             hviprio =3D csr_read(CSR_HVIPRIO1);
> > +             break;
> > +     case 1:
> > +#ifndef CONFIG_32BIT
> > +             hviprio =3D csr_read(CSR_HVIPRIO2);
> > +             break;
> > +#else
> > +             hviprio =3D csr_read(CSR_HVIPRIO1H);
> > +             break;
> > +     case 2:
> > +             hviprio =3D csr_read(CSR_HVIPRIO2);
> > +             break;
> > +     case 3:
> > +             hviprio =3D csr_read(CSR_HVIPRIO2H);
> > +             break;
> > +#endif
> > +     default:
> > +             return 0;
> > +     };
>          ^ unnecessary ;

Okay, I will update.

> > +
> > +     return (hviprio >> (bitpos % BITS_PER_LONG)) & TOPI_IPRIO_MASK;
> > +}
> > +
> > +static void aia_set_iprio8(struct kvm_vcpu *vcpu, unsigned int irq, u8=
 prio)
> > +{
> > +     unsigned long hviprio;
> > +     int bitpos =3D aia_irq2bitpos[irq];
> > +
> > +     if (bitpos < 0)
> > +             return;
> > +
> > +     switch (bitpos / BITS_PER_LONG) {
> > +     case 0:
> > +             hviprio =3D csr_read(CSR_HVIPRIO1);
> > +             break;
> > +     case 1:
> > +#ifndef CONFIG_32BIT
> > +             hviprio =3D csr_read(CSR_HVIPRIO2);
> > +             break;
> > +#else
> > +             hviprio =3D csr_read(CSR_HVIPRIO1H);
> > +             break;
> > +     case 2:
> > +             hviprio =3D csr_read(CSR_HVIPRIO2);
> > +             break;
> > +     case 3:
> > +             hviprio =3D csr_read(CSR_HVIPRIO2H);
> > +             break;
> > +#endif
> > +     default:
> > +             return;
> > +     };
>          ^ unnecessary ;

Okay, I will update.

>
> The csr read switch could be put in a helper and shared between the get
> and set functions.

I think that's unnecessary.

>
> > +
> > +     hviprio &=3D ~((unsigned long)TOPI_IPRIO_MASK <<
>
> I don't think the (unsigned long) cast is necessary, as I believe
> TOPI_IPRIO_MASK is already an unsigned long.

Okay, I will update.

>
> > +                  (bitpos % BITS_PER_LONG));
> > +     hviprio |=3D (unsigned long)prio << (bitpos % BITS_PER_LONG);
> > +
> > +     switch (bitpos / BITS_PER_LONG) {
> > +     case 0:
> > +             csr_write(CSR_HVIPRIO1, hviprio);
> > +             break;
> > +     case 1:
> > +#ifndef CONFIG_32BIT
> > +             csr_write(CSR_HVIPRIO2, hviprio);
> > +             break;
> > +#else
> > +             csr_write(CSR_HVIPRIO1H, hviprio);
> > +             break;
> > +     case 2:
> > +             csr_write(CSR_HVIPRIO2, hviprio);
> > +             break;
> > +     case 3:
> > +             csr_write(CSR_HVIPRIO2H, hviprio);
> > +             break;
> > +#endif
> > +     default:
> > +             return;
> > +     };
>          ^ unnecessary ;

Okay, I will update.

>
> > +}
> > +
> > +static int aia_rmw_iprio(struct kvm_vcpu *vcpu, unsigned int isel,
> > +                      unsigned long *val, unsigned long new_val,
> > +                      unsigned long wr_mask)
> > +{
> > +     int i, firq, nirqs;
>
> nit: I guessed 'f' is for 'first', but 'first_irq' would make that more
> clear from the start.

Okay, I will rename firq to first_irq.

>
> > +     unsigned long old_val;
> > +
> > +#ifndef CONFIG_32BIT
> > +     if (isel & 0x1)
> > +             return KVM_INSN_ILLEGAL_TRAP;
> > +#endif
> > +
> > +     nirqs =3D 4 * (BITS_PER_LONG / 32);
> > +     firq =3D ((isel - ISELECT_IPRIO0) / (BITS_PER_LONG / 32)) * (nirq=
s);
>
> This is just firq =3D 4 * (isel - ISELECT_IPRIO0);

I agree. The current computation can be much simpler. Probably, I was
over thinking.

>
> > +
> > +     old_val =3D 0;
> > +     for (i =3D 0; i < nirqs; i++)
> > +             old_val |=3D (unsigned long)aia_get_iprio8(vcpu, firq + i=
) <<
> > +                        (TOPI_IPRIO_BITS * i);
>
> nit: normally would indent to under the (

This is not part of the parameter passed to aia_get_iprio8().

>
> > +
> > +     if (val)
> > +             *val =3D old_val;
> > +
> > +     if (wr_mask) {
> > +             new_val =3D (old_val & ~wr_mask) | (new_val & wr_mask);
> > +             for (i =3D 0; i < nirqs; i++)
> > +                     aia_set_iprio8(vcpu, firq + i,
> > +                     (new_val >> (TOPI_IPRIO_BITS * i)) & TOPI_IPRIO_M=
ASK);
>
> nit: normally would indent to under the (

Okay, I will update.

>
> > +     }
> > +
> > +     return KVM_INSN_CONTINUE_NEXT_SEPC;
> > +}
> > +
> > +#define IMSIC_FIRST  0x70
> > +#define IMSIC_LAST   0xff
> > +int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int cs=
r_num,
> > +                             unsigned long *val, unsigned long new_val=
,
> > +                             unsigned long wr_mask)
> > +{
> > +     unsigned int isel;
> > +
> > +     /* If AIA not available then redirect trap */
> > +     if (!kvm_riscv_aia_available())
> > +             return KVM_INSN_ILLEGAL_TRAP;
> > +
> > +     /* First try to emulate in kernel space */
> > +     isel =3D csr_read(CSR_VSISELECT) & ISELECT_MASK;
> > +     if (isel >=3D ISELECT_IPRIO0 && isel <=3D ISELECT_IPRIO15)
> > +             return aia_rmw_iprio(vcpu, isel, val, new_val, wr_mask);
> > +     else if (isel >=3D IMSIC_FIRST && isel <=3D IMSIC_LAST &&
> > +              kvm_riscv_aia_initialized(vcpu->kvm))
> > +             return kvm_riscv_vcpu_aia_imsic_rmw(vcpu, isel, val, new_=
val,
> > +                                                 wr_mask);
> > +
> > +     /* We can't handle it here so redirect to user space */
> > +     return KVM_INSN_EXIT_TO_USER_SPACE;
> > +}
> > +
> >  void kvm_riscv_aia_enable(void)
> >  {
> >       if (!kvm_riscv_aia_available())
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 15507cd3a595..30acf3ebdc3d 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -141,8 +141,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *v=
cpu)
> >
> >       kvm_riscv_vcpu_aia_reset(vcpu);
> >
> > -     WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> > -     WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> > +     bitmap_zero(vcpu->arch.irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
> > +     bitmap_zero(vcpu->arch.irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS)=
;
> >
> >       kvm_riscv_vcpu_pmu_reset(vcpu);
> >
> > @@ -474,6 +474,7 @@ static int kvm_riscv_vcpu_general_get_csr(struct kv=
m_vcpu *vcpu,
> >       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
> >               kvm_riscv_vcpu_flush_interrupts(vcpu);
> >               *out_val =3D (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VAL=
ID_MASK;
> > +             *out_val |=3D csr->hvip & ~IRQ_LOCAL_MASK;
> >       } else
> >               *out_val =3D ((unsigned long *)csr)[reg_num];
> >
> > @@ -497,7 +498,7 @@ static inline int kvm_riscv_vcpu_general_set_csr(st=
ruct kvm_vcpu *vcpu,
> >       ((unsigned long *)csr)[reg_num] =3D reg_val;
> >
> >       if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
> > -             WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> > +             WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
> >
> >       return 0;
> >  }
> > @@ -799,9 +800,9 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcp=
u *vcpu)
> >       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> >       unsigned long mask, val;
> >
> > -     if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
> > -             mask =3D xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
> > -             val =3D READ_ONCE(vcpu->arch.irqs_pending) & mask;
> > +     if (READ_ONCE(vcpu->arch.irqs_pending_mask[0])) {
> > +             mask =3D xchg_acquire(&vcpu->arch.irqs_pending_mask[0], 0=
);
> > +             val =3D READ_ONCE(vcpu->arch.irqs_pending[0]) & mask;
> >
> >               csr->hvip &=3D ~mask;
> >               csr->hvip |=3D val;
> > @@ -825,12 +826,12 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vc=
pu *vcpu)
> >       if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
> >               if (hvip & (1UL << IRQ_VS_SOFT)) {
> >                       if (!test_and_set_bit(IRQ_VS_SOFT,
> > -                                           &v->irqs_pending_mask))
> > -                             set_bit(IRQ_VS_SOFT, &v->irqs_pending);
> > +                                           v->irqs_pending_mask))
> > +                             set_bit(IRQ_VS_SOFT, v->irqs_pending);
> >               } else {
> >                       if (!test_and_set_bit(IRQ_VS_SOFT,
> > -                                           &v->irqs_pending_mask))
> > -                             clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
> > +                                           v->irqs_pending_mask))
> > +                             clear_bit(IRQ_VS_SOFT, v->irqs_pending);
> >               }
> >       }
> >
> > @@ -843,14 +844,20 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vc=
pu *vcpu)
> >
> >  int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int i=
rq)
> >  {
> > -     if (irq !=3D IRQ_VS_SOFT &&
> > +     /*
> > +      * We only allow VS-mode software, timer, and external
> > +      * interrupts when irq is one of the local interrupts
> > +      * defined by RISC-V privilege specification.
> > +      */
> > +     if (irq < IRQ_LOCAL_MAX &&
> > +         irq !=3D IRQ_VS_SOFT &&
> >           irq !=3D IRQ_VS_TIMER &&
> >           irq !=3D IRQ_VS_EXT)
> >               return -EINVAL;
> >
> > -     set_bit(irq, &vcpu->arch.irqs_pending);
> > +     set_bit(irq, vcpu->arch.irqs_pending);
> >       smp_mb__before_atomic();
> > -     set_bit(irq, &vcpu->arch.irqs_pending_mask);
> > +     set_bit(irq, vcpu->arch.irqs_pending_mask);
> >
> >       kvm_vcpu_kick(vcpu);
> >
> > @@ -859,25 +866,33 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu =
*vcpu, unsigned int irq)
> >
> >  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int=
 irq)
> >  {
> > -     if (irq !=3D IRQ_VS_SOFT &&
> > +     /*
> > +      * We only allow VS-mode software, timer, and external
> > +      * interrupts when irq is one of the local interrupts
> > +      * defined by RISC-V privilege specification.
> > +      */
> > +     if (irq < IRQ_LOCAL_MAX &&
> > +         irq !=3D IRQ_VS_SOFT &&
> >           irq !=3D IRQ_VS_TIMER &&
> >           irq !=3D IRQ_VS_EXT)
> >               return -EINVAL;
> >
> > -     clear_bit(irq, &vcpu->arch.irqs_pending);
> > +     clear_bit(irq, vcpu->arch.irqs_pending);
> >       smp_mb__before_atomic();
> > -     set_bit(irq, &vcpu->arch.irqs_pending_mask);
> > +     set_bit(irq, vcpu->arch.irqs_pending_mask);
> >
> >       return 0;
> >  }
> >
> > -bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned lon=
g mask)
> > +bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
> >  {
> >       unsigned long ie;
> >
> >       ie =3D ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
> > -             << VSIP_TO_HVIP_SHIFT) & mask;
> > -     if (READ_ONCE(vcpu->arch.irqs_pending) & ie)
> > +             << VSIP_TO_HVIP_SHIFT) & (unsigned long)mask;
> > +     ie |=3D vcpu->arch.guest_csr.vsie & ~IRQ_LOCAL_MASK &
> > +             (unsigned long)mask;
> > +     if (READ_ONCE(vcpu->arch.irqs_pending[0]) & ie)
> >               return true;
> >
> >       /* Check AIA high interrupts */
> > --
> > 2.34.1
> >
>
> Thanks,
> drew

Regards,
Anup
