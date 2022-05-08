Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3791651EC15
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 09:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiEHHyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 May 2022 03:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiEHHxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 May 2022 03:53:48 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C312ABE28
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 00:49:48 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id g28so19787032ybj.10
        for <kvm@vger.kernel.org>; Sun, 08 May 2022 00:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dFexpI1CcAvP4bPrXFGudL7mJMKDkHsmR67F6Gffao8=;
        b=dIFqpJll2mKM1G1VvfjcBJezQWJT0RtTazwLhhjeShGNWEsXzIk5BKA8/JaRtUmz5Y
         kIscbuCsfwKfLDKsPHpc+2NY1/Q1hc6RpYZP8qf17f1Ec7LYruI/Ha6a1lNVqYzhI5Jv
         47SKUNCi2wMrY38YAlKqYvfVUYiZIHvvhNyD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dFexpI1CcAvP4bPrXFGudL7mJMKDkHsmR67F6Gffao8=;
        b=koqCNBqbTHQ51qMM6j6fpeYAIDOUxPsKpWwWwJDEEtKG5apQY/dHfHzi8akfhQXR7H
         BWT6EkGJl8m5Kde12p9yPZnOwF2fDezNVw3mtTkpxsWtu0T6DujM0YTlGPV5Ba7sVyoi
         EUGMH5NkSegNYeYv+Dmv6rQzVrnDNk5Co20sMT5l+tYRClgw9AiP8ct4rRD9yZQKiHmw
         8DpAhWozohFmTMnNGx7+Onkg0hX7qjXuFyVzohqxAqsdsG3CY5ub1BxPSic6RGCRT0SB
         T2sohrrqr1P9PX0H16uheOYUpQc9HfNrQ9e12ra8WeV0DkojgCFiFZcbRRKor/Dg5i0s
         fgTw==
X-Gm-Message-State: AOAM530/Q3cUp8vonH9i+D9ASwW7yJN9L1TZe4szAsO5riZHCHexgina
        VR76U5NqVRMyVU138QsLcRnft7YbjdDq3877ubud
X-Google-Smtp-Source: ABdhPJwPQ84lYi8rBRjQhhobqwrmIAHSMcPKzgiF39Kg5lVWpuCOypczW7YBFUmZ7DuiNrXcrZKIeGyH6wxVLH/3jCc=
X-Received: by 2002:a25:32d3:0:b0:648:5929:845f with SMTP id
 y202-20020a2532d3000000b006485929845fmr8272185yby.53.1651996187869; Sun, 08
 May 2022 00:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220426185245.281182-1-atishp@rivosinc.com> <20220426185245.281182-5-atishp@rivosinc.com>
 <19F90AE1-68AD-4478-B5C3-8ABADD781198@jrtc27.com>
In-Reply-To: <19F90AE1-68AD-4478-B5C3-8ABADD781198@jrtc27.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Sun, 8 May 2022 00:49:37 -0700
Message-ID: <CAOnJCUJQqe=T0x0ErVHX=Eod0Kd1m55VD=Q-GdPnbxav2VbN+g@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] RISC-V: KVM: Support sstc extension
To:     Jessica Clarke <jrtc27@jrtc27.com>
Cc:     Atish Patra <atishp@rivosinc.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree <devicetree@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 2:10 PM Jessica Clarke <jrtc27@jrtc27.com> wrote:
>
> On 26 Apr 2022, at 19:52, Atish Patra <atishp@rivosinc.com> wrote:
> >
> > Sstc extension allows the guest to program the vstimecmp CSR directly
> > instead of making an SBI call to the hypervisor to program the next
> > event. The timer interrupt is also directly injected to the guest by
> > the hardware in this case. To maintain backward compatibility, the
> > hypervisors also update the vstimecmp in an SBI set_time call if
> > the hardware supports it. Thus, the older kernels in guest also
> > take advantage of the sstc extension.
>
> This still violates the following part of the ratified SBI spec:
>
> > =E2=80=A2 All registers except a0 & a1 must be preserved across an SBI =
call by the callee.
>
> The Set Timer legacy extension and non-legacy function state they clear
> the pending timer bit but otherwise make no provision for other S-mode
> state being clobbered. The stimecmp register is S-mode read/write
> state. I don=E2=80=99t debate that this is a useful thing to allow, but a=
s
> things stand this is in direct violation of the letter of the ratified
> SBI spec and so if you want to allow this you have to fix your spec
> first and deal with the ratified spec compatibility issues that brings.
>

I tried the approach you suggested by keeping separate context for
SBI path & vstimecmp but this results in in unreliable behavior for
guest (which may use SBI call or stimecmp) because hardware will always
trigger virtual timer interrupt whenever henvcfg.STCE=3D=3D1 and
"vstimecmp < (time+ htimedelta)".

Further, the hypervisor has no idea if the guest wants Sstc extension
or not unless the hypervisor management tool (QEMU/KVMTOOL)
explicitly disables the Sstc extension for a specific Guest/VM. In
general, the hypervisor management tools can't assume anything
about the features supported by Guest OS so explicitly disabling
Sstc extension for Guest/VM is not a practical approach.

Most hypervisors will always have Sstc extension enabled by default
for Guest/VM by setting the henvcfg.STCE bit whenever hardware
supports Sstc. Once this bit is set, hardware will actively compare
vstimecmp value at every CPU clock cycle. vstimecmp value need to be
saved/restored at vcpu_load/put path always. If the vstimecmp is not
updated in the SBI path, it may contain stale value which will trigger
spurious timer interrupts.

Regards,
Anup

> Jess
>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> > arch/riscv/include/asm/kvm_host.h       |   1 +
> > arch/riscv/include/asm/kvm_vcpu_timer.h |   8 +-
> > arch/riscv/include/uapi/asm/kvm.h       |   1 +
> > arch/riscv/kvm/main.c                   |  12 ++-
> > arch/riscv/kvm/vcpu.c                   |   5 +-
> > arch/riscv/kvm/vcpu_timer.c             | 138 +++++++++++++++++++++++-
> > 6 files changed, 159 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > index 78da839657e5..50a97c821f83 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -135,6 +135,7 @@ struct kvm_vcpu_csr {
> >       unsigned long hvip;
> >       unsigned long vsatp;
> >       unsigned long scounteren;
> > +     u64 vstimecmp;
> > };
> >
> > struct kvm_vcpu_arch {
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/inclu=
de/asm/kvm_vcpu_timer.h
> > index 375281eb49e0..a24a265f3ccb 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_timer.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
> > @@ -28,6 +28,11 @@ struct kvm_vcpu_timer {
> >       u64 next_cycles;
> >       /* Underlying hrtimer instance */
> >       struct hrtimer hrt;
> > +
> > +     /* Flag to check if sstc is enabled or not */
> > +     bool sstc_enabled;
> > +     /* A function pointer to switch between stimecmp or hrtimer at ru=
ntime */
> > +     int (*timer_next_event)(struct kvm_vcpu *vcpu, u64 ncycles);
> > };
> >
> > int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)=
;
> > @@ -39,6 +44,7 @@ int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
> > int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
> > int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
> > void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
> > +void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu);
> > int kvm_riscv_guest_timer_init(struct kvm *kvm);
> > -
> > +bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu);
> > #endif
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 92bd469e2ba6..d2f02ba1947a 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -96,6 +96,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >       KVM_RISCV_ISA_EXT_H,
> >       KVM_RISCV_ISA_EXT_I,
> >       KVM_RISCV_ISA_EXT_M,
> > +     KVM_RISCV_ISA_EXT_SSTC,
> >       KVM_RISCV_ISA_EXT_MAX,
> > };
> >
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index 2e5ca43c8c49..83c4db7fc35f 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -32,7 +32,7 @@ int kvm_arch_hardware_setup(void *opaque)
> >
> > int kvm_arch_hardware_enable(void)
> > {
> > -     unsigned long hideleg, hedeleg;
> > +     unsigned long hideleg, hedeleg, henvcfg;
> >
> >       hedeleg =3D 0;
> >       hedeleg |=3D (1UL << EXC_INST_MISALIGNED);
> > @@ -51,6 +51,16 @@ int kvm_arch_hardware_enable(void)
> >
> >       csr_write(CSR_HCOUNTEREN, -1UL);
> >
> > +     if (riscv_isa_extension_available(NULL, SSTC)) {
> > +#ifdef CONFIG_64BIT
> > +             henvcfg =3D csr_read(CSR_HENVCFG);
> > +             csr_write(CSR_HENVCFG, henvcfg | 1UL<<HENVCFG_STCE);
> > +#else
> > +             henvcfg =3D csr_read(CSR_HENVCFGH);
> > +             csr_write(CSR_HENVCFGH, henvcfg | 1UL<<HENVCFGH_STCE);
> > +#endif
> > +     }
> > +
> >       csr_write(CSR_HVIP, 0);
> >
> >       return 0;
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 93492eb292fd..da1559725b03 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -143,7 +143,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >
> > int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> > {
> > -     return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
> > +     return kvm_riscv_vcpu_timer_pending(vcpu);
> > }
> >
> > void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> > @@ -374,6 +374,7 @@ static unsigned long kvm_isa_ext_arr[] =3D {
> >       RISCV_ISA_EXT_h,
> >       RISCV_ISA_EXT_i,
> >       RISCV_ISA_EXT_m,
> > +     RISCV_ISA_EXT_SSTC,
> > };
> >
> > static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
> > @@ -754,6 +755,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >                                    vcpu->arch.isa);
> >       kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
> >
> > +     kvm_riscv_vcpu_timer_save(vcpu);
> > +
> >       csr->vsstatus =3D csr_read(CSR_VSSTATUS);
> >       csr->vsie =3D csr_read(CSR_VSIE);
> >       csr->vstvec =3D csr_read(CSR_VSTVEC);
> > diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> > index 5c4c37ff2d48..d226a931de92 100644
> > --- a/arch/riscv/kvm/vcpu_timer.c
> > +++ b/arch/riscv/kvm/vcpu_timer.c
> > @@ -69,7 +69,18 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vc=
pu_timer *t)
> >       return 0;
> > }
> >
> > -int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles=
)
> > +static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 =
ncycles)
> > +{
> > +#if __riscv_xlen =3D=3D 32
> > +             csr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> > +             csr_write(CSR_VSTIMECMPH, ncycles >> 32);
> > +#else
> > +             csr_write(CSR_VSTIMECMP, ncycles);
> > +#endif
> > +             return 0;
> > +}
> > +
> > +static int kvm_riscv_vcpu_update_hrtimer(struct kvm_vcpu *vcpu, u64 nc=
ycles)
> > {
> >       struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
> >       struct kvm_guest_timer *gt =3D &vcpu->kvm->arch.timer;
> > @@ -88,6 +99,68 @@ int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu =
*vcpu, u64 ncycles)
> >       return 0;
> > }
> >
> > +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles=
)
> > +{
> > +     struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
> > +
> > +     return t->timer_next_event(vcpu, ncycles);
> > +}
> > +
> > +static enum hrtimer_restart kvm_riscv_vcpu_vstimer_expired(struct hrti=
mer *h)
> > +{
> > +     u64 delta_ns;
> > +     struct kvm_vcpu_timer *t =3D container_of(h, struct kvm_vcpu_time=
r, hrt);
> > +     struct kvm_vcpu *vcpu =3D container_of(t, struct kvm_vcpu, arch.t=
imer);
> > +     struct kvm_guest_timer *gt =3D &vcpu->kvm->arch.timer;
> > +
> > +     if (kvm_riscv_current_cycles(gt) < t->next_cycles) {
> > +             delta_ns =3D kvm_riscv_delta_cycles2ns(t->next_cycles, gt=
, t);
> > +             hrtimer_forward_now(&t->hrt, ktime_set(0, delta_ns));
> > +             return HRTIMER_RESTART;
> > +     }
> > +
> > +     t->next_set =3D false;
> > +     kvm_vcpu_kick(vcpu);
> > +
> > +     return HRTIMER_NORESTART;
> > +}
> > +
> > +bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
> > +     struct kvm_guest_timer *gt =3D &vcpu->kvm->arch.timer;
> > +     u64 vstimecmp_val =3D vcpu->arch.guest_csr.vstimecmp;
> > +
> > +     if (!kvm_riscv_delta_cycles2ns(vstimecmp_val, gt, t) ||
> > +         kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER))
> > +             return true;
> > +     else
> > +             return false;
> > +}
> > +
> > +static void kvm_riscv_vcpu_timer_blocking(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
> > +     struct kvm_guest_timer *gt =3D &vcpu->kvm->arch.timer;
> > +     u64 delta_ns;
> > +     u64 vstimecmp_val =3D vcpu->arch.guest_csr.vstimecmp;
> > +
> > +     if (!t->init_done)
> > +             return;
> > +
> > +     delta_ns =3D kvm_riscv_delta_cycles2ns(vstimecmp_val, gt, t);
> > +     if (delta_ns) {
> > +             t->next_cycles =3D vstimecmp_val;
> > +             hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MO=
DE_REL);
> > +             t->next_set =3D true;
> > +     }
> > +}
> > +
> > +static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
> > +{
> > +     kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
> > +}
> > +
> > int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
> >                                const struct kvm_one_reg *reg)
> > {
> > @@ -180,10 +253,20 @@ int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vc=
pu)
> >               return -EINVAL;
> >
> >       hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > -     t->hrt.function =3D kvm_riscv_vcpu_hrtimer_expired;
> >       t->init_done =3D true;
> >       t->next_set =3D false;
> >
> > +     /* Enable sstc for every vcpu if available in hardware */
> > +     if (riscv_isa_extension_available(NULL, SSTC)) {
> > +             t->sstc_enabled =3D true;
> > +             t->hrt.function =3D kvm_riscv_vcpu_vstimer_expired;
> > +             t->timer_next_event =3D kvm_riscv_vcpu_update_vstimecmp;
> > +     } else {
> > +             t->sstc_enabled =3D false;
> > +             t->hrt.function =3D kvm_riscv_vcpu_hrtimer_expired;
> > +             t->timer_next_event =3D kvm_riscv_vcpu_update_hrtimer;
> > +     }
> > +
> >       return 0;
> > }
> >
> > @@ -202,7 +285,7 @@ int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcp=
u)
> >       return kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
> > }
> >
> > -void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
> > +static void kvm_riscv_vcpu_update_timedelta(struct kvm_vcpu *vcpu)
> > {
> >       struct kvm_guest_timer *gt =3D &vcpu->kvm->arch.timer;
> >
> > @@ -214,6 +297,55 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu =
*vcpu)
> > #endif
> > }
> >
> > +void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_csr *csr;
> > +     struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
> > +
> > +     kvm_riscv_vcpu_update_timedelta(vcpu);
> > +
> > +     if (!t->sstc_enabled)
> > +             return;
> > +
> > +     csr =3D &vcpu->arch.guest_csr;
> > +#ifdef CONFIG_64BIT
> > +     csr_write(CSR_VSTIMECMP, csr->vstimecmp);
> > +#else
> > +     csr_write(CSR_VSTIMECMP, (u32)csr->vstimecmp);
> > +     csr_write(CSR_VSTIMECMPH, (u32)(csr->vstimecmp >> 32));
> > +#endif
> > +
> > +     /* timer should be enabled for the remaining operations */
> > +     if (unlikely(!t->init_done))
> > +             return;
> > +
> > +     kvm_riscv_vcpu_timer_unblocking(vcpu);
> > +}
> > +
> > +void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_csr *csr;
> > +     struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
> > +
> > +     if (!t->sstc_enabled)
> > +             return;
> > +
> > +     csr =3D &vcpu->arch.guest_csr;
> > +     t =3D &vcpu->arch.timer;
> > +#ifdef CONFIG_64BIT
> > +     csr->vstimecmp =3D csr_read(CSR_VSTIMECMP);
> > +#else
> > +     csr->vstimecmp =3D csr_read(CSR_VSTIMECMP);
> > +     csr->vstimecmp |=3D (u64)csr_read(CSR_VSTIMECMPH) << 32;
> > +#endif
> > +     /* timer should be enabled for the remaining operations */
> > +     if (unlikely(!t->init_done))
> > +             return;
> > +
> > +     if (kvm_vcpu_is_blocking(vcpu))
> > +             kvm_riscv_vcpu_timer_blocking(vcpu);
> > +}
> > +
> > int kvm_riscv_guest_timer_init(struct kvm *kvm)
> > {
> >       struct kvm_guest_timer *gt =3D &kvm->arch.timer;
> > --
> > 2.25.1
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
>


--=20
Regards,
Atish
