Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AAB6D641D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbjDDNzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbjDDNwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:52:55 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E54ECD
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:52:47 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so130951347edd.5
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 06:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680616366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plOOgEIG8396rx4iCJr8AmtbDlt6pY+32irrDdi4MZU=;
        b=mIzyzcaml54l5H7z2MLPPShVAiHPRay2/Yc4Lg/WSdneG8SOv3h3pxrwfBfdmIOzyt
         8B1ke1cGZTXmRa1tOyVLkU8/LH0/RiMQvHYQtYx+ha5htRtrhipK8MJhFnOfwujIGLDF
         HINPBaF8F4/cUWLGGpZRYAw62bns3Eu7TgyP7upmdsaSEOBX/ZA4qjEBBLEe8NE6nSWP
         kfUwsEPEX8KdcliGjdTGuZUKvnezW+QJ9hvoOtBVxI1RCWR+lc9xMiUf/bckmpiu2dSq
         AbpyxTd8ELS9bafRysD0nQTmPHji4b1UE6FuDqyWvyV7U7l8EUNv7S6srYHTb242+oJi
         AXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680616366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=plOOgEIG8396rx4iCJr8AmtbDlt6pY+32irrDdi4MZU=;
        b=r5+XwVXmYQa3yBUK+xgZskue8qEbwYDpf3Aktdpa0nFBqPvJnqcnuf3rs4q9+ayKFS
         42PySccR2bgYLXCBGnQRPZmjxce07Z8lBzVC+bcPkomqBX0szIKywtJapCU4iPINvqzu
         5paiu2p7KvOOo4cy47g/CxzwmqI2Hw+tYuoKdEiwrbjrV05ORfkTI+AuNR/EDhMvGQbW
         q9FA85AxFjPHENga/dF/5PpzfNw8lkjXzSnzx9Zdp2G3uloHm2UsdFYI9hjNW+y04+3T
         yMBY4+S0u8jDjXfR1zVLIUgDFrpKhFo5gwzHGKAt9hnC07A4PX7ANFgxl05o1TQSIeyH
         fmlg==
X-Gm-Message-State: AAQBX9cwf2B1BQ7PKQt7DIUpQbFwR60Gmkxr1a47RS21Re9Mq+wQ/FtK
        fGfFTTtRI14eG3xUO2rfy+5KnDTDhvbsZxT2Dr/mesUbhWfPTqT3+rA=
X-Google-Smtp-Source: AKy350YOTIshLEk3PsuoxDxib9mcYfjnTeWGi4oF7Zyk/2q/aXtNdFT0Ya31C9SyiDa6zUXvngqONBo5cg9hoLpm+H8=
X-Received: by 2002:a17:906:c34e:b0:93e:aac:bb8d with SMTP id
 ci14-20020a170906c34e00b0093e0aacbb8dmr1316405ejb.13.1680616365887; Tue, 04
 Apr 2023 06:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-9-apatel@ventanamicro.com> <znn7ibu4r6ivsfb3sqoandhpvqkfwr6w4q4z6vwcwqiviya5bk@dsa3f5dk7m6l>
In-Reply-To: <znn7ibu4r6ivsfb3sqoandhpvqkfwr6w4q4z6vwcwqiviya5bk@dsa3f5dk7m6l>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 4 Apr 2023 19:22:33 +0530
Message-ID: <CAAhSdy2txionLCED-cszdcKias5orHTnNRzHJcrFdMSUEsPnig@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] RISC-V: KVM: Implement guest external interrupt
 line management
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

On Tue, Apr 4, 2023 at 6:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Mon, Apr 03, 2023 at 03:03:10PM +0530, Anup Patel wrote:
> > The RISC-V host will have one guest external interrupt line for each
> > VS-level IMSICs associated with a HART. The guest external interrupt
> > lines are per-HART resources and hypervisor can use HGEIE, HGEIP, and
> > HIE CSRs to manage these guest external interrupt lines.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_aia.h |  10 ++
> >  arch/riscv/kvm/aia.c             | 241 +++++++++++++++++++++++++++++++
> >  arch/riscv/kvm/main.c            |   3 +-
> >  arch/riscv/kvm/vcpu.c            |   2 +
> >  4 files changed, 255 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/=
kvm_aia.h
> > index 1de0717112e5..0938e0cadf80 100644
> > --- a/arch/riscv/include/asm/kvm_aia.h
> > +++ b/arch/riscv/include/asm/kvm_aia.h
> > @@ -44,10 +44,15 @@ struct kvm_vcpu_aia {
> >
> >  #define irqchip_in_kernel(k)         ((k)->arch.aia.in_kernel)
> >
> > +extern unsigned int kvm_riscv_aia_nr_hgei;
> >  DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
> >  #define kvm_riscv_aia_available() \
> >       static_branch_unlikely(&kvm_riscv_aia_available)
> >
> > +static inline void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *v=
cpu)
> > +{
> > +}
> > +
> >  #define KVM_RISCV_AIA_IMSIC_TOPEI    (ISELECT_MASK + 1)
> >  static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
> >                                              unsigned long isel,
> > @@ -119,6 +124,11 @@ static inline void kvm_riscv_aia_destroy_vm(struct=
 kvm *kvm)
> >  {
> >  }
> >
> > +int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
> > +                          void __iomem **hgei_va, phys_addr_t *hgei_pa=
);
> > +void kvm_riscv_aia_free_hgei(int cpu, int hgei);
> > +void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable);
> > +
> >  void kvm_riscv_aia_enable(void);
> >  void kvm_riscv_aia_disable(void);
> >  int kvm_riscv_aia_init(void);
> > diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> > index d530912f28bc..1264783e7c4d 100644
> > --- a/arch/riscv/kvm/aia.c
> > +++ b/arch/riscv/kvm/aia.c
> > @@ -7,11 +7,46 @@
> >   *   Anup Patel <apatel@ventanamicro.com>
> >   */
> >
> > +#include <linux/bitops.h>
> > +#include <linux/irq.h>
> > +#include <linux/irqdomain.h>
> >  #include <linux/kvm_host.h>
> > +#include <linux/percpu.h>
> > +#include <linux/spinlock.h>
> >  #include <asm/hwcap.h>
> >
> > +struct aia_hgei_control {
> > +     raw_spinlock_t lock;
> > +     unsigned long free_bitmap;
> > +     struct kvm_vcpu *owners[BITS_PER_LONG];
> > +};
> > +static DEFINE_PER_CPU(struct aia_hgei_control, aia_hgei);
> > +static int hgei_parent_irq;
> > +
> > +unsigned int kvm_riscv_aia_nr_hgei;
> >  DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
> >
> > +static int aia_find_hgei(struct kvm_vcpu *owner)
> > +{
> > +     int i, hgei;
> > +     unsigned long flags;
> > +     struct aia_hgei_control *hgctrl =3D this_cpu_ptr(&aia_hgei);
> > +
> > +     raw_spin_lock_irqsave(&hgctrl->lock, flags);
> > +
> > +     hgei =3D -1;
> > +     for (i =3D 1; i <=3D kvm_riscv_aia_nr_hgei; i++) {
> > +             if (hgctrl->owners[i] =3D=3D owner) {
> > +                     hgei =3D i;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> > +
> > +     return hgei;
> > +}
> > +
> >  static void aia_set_hvictl(bool ext_irq_pending)
> >  {
> >       unsigned long hvictl;
> > @@ -55,6 +90,7 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vc=
pu *vcpu)
> >
> >  bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask=
)
> >  {
> > +     int hgei;
> >       unsigned long seip;
> >
> >       if (!kvm_riscv_aia_available())
> > @@ -72,6 +108,10 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_v=
cpu *vcpu, u64 mask)
> >       if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
> >               return false;
> >
> > +     hgei =3D aia_find_hgei(vcpu);
> > +     if (hgei > 0)
> > +             return (csr_read(CSR_HGEIP) & BIT(hgei)) ? true : false;
>
> nit: return !!(csr_read(CSR_HGEIP) & BIT(hgei)) is a bit less verbose.

Okay, I will update.

>
> > +
> >       return false;
> >  }
> >
> > @@ -343,6 +383,144 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *=
vcpu, unsigned int csr_num,
> >       return KVM_INSN_EXIT_TO_USER_SPACE;
> >  }
> >
> > +int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
> > +                          void __iomem **hgei_va, phys_addr_t *hgei_pa=
)
> > +{
> > +     int ret =3D -ENOENT;
> > +     unsigned long flags;
> > +     struct aia_hgei_control *hgctrl =3D per_cpu_ptr(&aia_hgei, cpu);
> > +
> > +     if (!kvm_riscv_aia_available())
> > +             return -ENODEV;
> > +     if (!hgctrl)
> > +             return -ENODEV;
>
> nit:
>
> if (!kvm_riscv_aia_available() || !hgctrl)
>    return -ENODEV;

Okay, I will update.

>
> > +
> > +     raw_spin_lock_irqsave(&hgctrl->lock, flags);
> > +
> > +     if (hgctrl->free_bitmap) {
> > +             ret =3D __ffs(hgctrl->free_bitmap);
> > +             hgctrl->free_bitmap &=3D ~BIT(ret);
> > +             hgctrl->owners[ret] =3D owner;
> > +     }
> > +
> > +     raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> > +
> > +     /* TODO: To be updated later by AIA in-kernel irqchip support */
> > +     if (hgei_va)
> > +             *hgei_va =3D NULL;
> > +     if (hgei_pa)
> > +             *hgei_pa =3D 0;
> > +
> > +     return ret;
> > +}
> > +
> > +void kvm_riscv_aia_free_hgei(int cpu, int hgei)
> > +{
> > +     unsigned long flags;
> > +     struct aia_hgei_control *hgctrl =3D per_cpu_ptr(&aia_hgei, cpu);
> > +
> > +     if (!kvm_riscv_aia_available() || !hgctrl)
> > +             return;
> > +
> > +     raw_spin_lock_irqsave(&hgctrl->lock, flags);
> > +
> > +     if (hgei > 0 && hgei <=3D kvm_riscv_aia_nr_hgei) {
> > +             if (!(hgctrl->free_bitmap & BIT(hgei))) {
> > +                     hgctrl->free_bitmap |=3D BIT(hgei);
> > +                     hgctrl->owners[hgei] =3D NULL;
> > +             }
> > +     }
> > +
> > +     raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> > +}
> > +
> > +void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable)
> > +{
> > +     int hgei;
> > +
> > +     if (!kvm_riscv_aia_available())
> > +             return;
> > +
> > +     hgei =3D aia_find_hgei(owner);
> > +     if (hgei > 0) {
> > +             if (enable)
> > +                     csr_set(CSR_HGEIE, BIT(hgei));
> > +             else
> > +                     csr_clear(CSR_HGEIE, BIT(hgei));
> > +     }
> > +}
> > +
> > +static irqreturn_t hgei_interrupt(int irq, void *dev_id)
> > +{
> > +     int i;
> > +     unsigned long hgei_mask, flags;
> > +     struct aia_hgei_control *hgctrl =3D this_cpu_ptr(&aia_hgei);
> > +
> > +     hgei_mask =3D csr_read(CSR_HGEIP) & csr_read(CSR_HGEIE);
> > +     csr_clear(CSR_HGEIE, hgei_mask);
> > +
> > +     raw_spin_lock_irqsave(&hgctrl->lock, flags);
> > +
> > +     for_each_set_bit(i, &hgei_mask, BITS_PER_LONG) {
> > +             if (hgctrl->owners[i])
> > +                     kvm_vcpu_kick(hgctrl->owners[i]);
> > +     }
> > +
> > +     raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static int aia_hgei_init(void)
> > +{
> > +     int cpu, rc;
> > +     struct irq_domain *domain;
> > +     struct aia_hgei_control *hgctrl;
> > +
> > +     /* Initialize per-CPU guest external interrupt line management */
> > +     for_each_possible_cpu(cpu) {
> > +             hgctrl =3D per_cpu_ptr(&aia_hgei, cpu);
> > +             raw_spin_lock_init(&hgctrl->lock);
> > +             if (kvm_riscv_aia_nr_hgei) {
> > +                     hgctrl->free_bitmap =3D
> > +                             BIT(kvm_riscv_aia_nr_hgei + 1) - 1;
> > +                     hgctrl->free_bitmap &=3D ~BIT(0);
> > +             } else
> > +                     hgctrl->free_bitmap =3D 0;
> > +     }
> > +
> > +     /* Find INTC irq domain */
> > +     domain =3D irq_find_matching_fwnode(riscv_get_intc_hwnode(),
> > +                                       DOMAIN_BUS_ANY);
> > +     if (!domain) {
> > +             kvm_err("unable to find INTC domain\n");
> > +             return -ENOENT;
> > +     }
> > +
> > +     /* Map per-CPU SGEI interrupt from INTC domain */
> > +     hgei_parent_irq =3D irq_create_mapping(domain, IRQ_S_GEXT);
> > +     if (!hgei_parent_irq) {
> > +             kvm_err("unable to map SGEI IRQ\n");
> > +             return -ENOMEM;
> > +     }
> > +
> > +     /* Request per-CPU SGEI interrupt */
> > +     rc =3D request_percpu_irq(hgei_parent_irq, hgei_interrupt,
> > +                             "riscv-kvm", &aia_hgei);
> > +     if (rc) {
> > +             kvm_err("failed to request SGEI IRQ\n");
> > +             return rc;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void aia_hgei_exit(void)
> > +{
> > +     /* Free per-CPU SGEI interrupt */
> > +     free_percpu_irq(hgei_parent_irq, &aia_hgei);
> > +}
> > +
> >  void kvm_riscv_aia_enable(void)
> >  {
> >       if (!kvm_riscv_aia_available())
> > @@ -357,21 +535,79 @@ void kvm_riscv_aia_enable(void)
> >       csr_write(CSR_HVIPRIO1H, 0x0);
> >       csr_write(CSR_HVIPRIO2H, 0x0);
> >  #endif
> > +
> > +     /* Enable per-CPU SGEI interrupt */
> > +     enable_percpu_irq(hgei_parent_irq,
> > +                       irq_get_trigger_type(hgei_parent_irq));
> > +     csr_set(CSR_HIE, BIT(IRQ_S_GEXT));
> >  }
> >
> >  void kvm_riscv_aia_disable(void)
> >  {
> > +     int i;
> > +     unsigned long flags;
> > +     struct kvm_vcpu *vcpu;
> > +     struct aia_hgei_control *hgctrl =3D this_cpu_ptr(&aia_hgei);
> > +
> >       if (!kvm_riscv_aia_available())
> >               return;
> >
> > +     /* Disable per-CPU SGEI interrupt */
> > +     csr_clear(CSR_HIE, BIT(IRQ_S_GEXT));
> > +     disable_percpu_irq(hgei_parent_irq);
> > +
> >       aia_set_hvictl(false);
> > +
> > +     raw_spin_lock_irqsave(&hgctrl->lock, flags);
> > +
> > +     for (i =3D 0; i <=3D kvm_riscv_aia_nr_hgei; i++) {
>
> I guess this should start at i =3D 1, but in this case it doesn't
> matter since hgctrl->owners[0] should always be NULL.

Yes, it doesn't matter in this case.

>
> > +             vcpu =3D hgctrl->owners[i];
> > +             if (!vcpu)
> > +                     continue;
> > +
> > +             /*
> > +              * We release hgctrl->lock before notifying IMSIC
> > +              * so that we don't have lock ordering issues.
> > +              */
> > +             raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> > +
> > +             /* Notify IMSIC */
> > +             kvm_riscv_vcpu_aia_imsic_release(vcpu);
> > +
> > +             /*
> > +              * Wakeup VCPU if it was blocked so that it can
> > +              * run on other HARTs
> > +              */
> > +             if (csr_read(CSR_HGEIE) & BIT(i)) {
> > +                     csr_clear(CSR_HGEIE, BIT(i));
> > +                     kvm_vcpu_kick(vcpu);
>
> Doing all this outside the lock makes me wonder what happens when 'vcpu'
> is no longer the owner at the time of kvm_riscv_vcpu_aia_imsic_release()
> or kvm_vcpu_kick(). Even if the calls on the wrong vcpu are just noise,
> then don't we still need to confirm that we release/kick the real owner
> before we return from this function?
>
> It appears safe to call kvm_vcpu_kick() while holding the lock and
> hgei_interrupt() does that. So, since there's currently no
> implementation of kvm_riscv_vcpu_aia_imsic_release(), I'm not sure what
> lock ordering issues we need to avoid.

Next batch of AIA patches has kvm_riscv_vcpu_aia_imsic_release() where
kvm_riscv_vcpu_aia_imsic_release() function will release the HGEI interrupt
line.

This is not to protect the kvm_vcpu_kick() call.

Regards,
Anup

>
> > +             }
> > +
> > +             raw_spin_lock_irqsave(&hgctrl->lock, flags);
> > +     }
> > +
> > +     raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> >  }
> >
> >  int kvm_riscv_aia_init(void)
> >  {
> > +     int rc;
> > +
> >       if (!riscv_isa_extension_available(NULL, SxAIA))
> >               return -ENODEV;
> >
> > +     /* Figure-out number of bits in HGEIE */
> > +     csr_write(CSR_HGEIE, -1UL);
> > +     kvm_riscv_aia_nr_hgei =3D fls_long(csr_read(CSR_HGEIE));
> > +     csr_write(CSR_HGEIE, 0);
> > +     if (kvm_riscv_aia_nr_hgei)
> > +             kvm_riscv_aia_nr_hgei--;
> > +
> > +     /* Initialize guest external interrupt line management */
> > +     rc =3D aia_hgei_init();
> > +     if (rc)
> > +             return rc;
> > +
> >       /* Enable KVM AIA support */
> >       static_branch_enable(&kvm_riscv_aia_available);
> >
> > @@ -380,4 +616,9 @@ int kvm_riscv_aia_init(void)
> >
> >  void kvm_riscv_aia_exit(void)
> >  {
> > +     if (!kvm_riscv_aia_available())
> > +             return;
> > +
> > +     /* Cleanup the HGEI state */
> > +     aia_hgei_exit();
> >  }
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index 6396352b4e4d..b0b46f48f31e 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -116,7 +116,8 @@ static int __init riscv_kvm_init(void)
> >       kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits(=
));
> >
> >       if (kvm_riscv_aia_available())
> > -             kvm_info("AIA available\n");
> > +             kvm_info("AIA available with %d guest external interrupts=
\n",
> > +                      kvm_riscv_aia_nr_hgei);
> >
> >       rc =3D kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> >       if (rc) {
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 30acf3ebdc3d..eace51dd896f 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -249,10 +249,12 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vc=
pu)
> >
> >  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> >  {
> > +     kvm_riscv_aia_wakeon_hgei(vcpu, true);
> >  }
> >
> >  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >  {
> > +     kvm_riscv_aia_wakeon_hgei(vcpu, false);
> >  }
> >
> >  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
> > --
> > 2.34.1
> >
>
> Thanks,
> drew
