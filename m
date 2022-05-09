Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537EE51F3ED
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 07:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiEIFkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 01:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiEIFii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 01:38:38 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D2011E1D6
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 22:34:45 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id h206-20020a1c21d7000000b003946c466c17so178279wmh.4
        for <kvm@vger.kernel.org>; Sun, 08 May 2022 22:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZM78wIZ6JLMPND7Ht3IA1Mgf/xPFUerHdSHdeZPHpFw=;
        b=Rkns/KQugvEQmGsLLnfc60vj1l7V5wIkMGSPjxpCBigi+ckpY7MB9HM9yCG+ypQkhG
         pWxETVX5ZTxLiddk/JMOIIhnbLZH4vd805xOKIzmPBv5dkPeSEsmm5E//LXP8fQ2W1Es
         SiJKseZWMb4bbTNnDEm1aYChw5QX9PEO1kMgtH1SE09LD/28GI0WSAZG5cNQNKR1Q2JO
         GR+FtIOxEqsmcnM9AcbjvZ7a5VzK/sk0Lw43s5qVzf64RMfv13eCm35YG63rGQzJgXNa
         PZThzfS6C5Rdu8U1+I0gUfjyU4KtBflnnSicfKSMuSQzv8dhmPISS28YcMN9XJwEAbW0
         CA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZM78wIZ6JLMPND7Ht3IA1Mgf/xPFUerHdSHdeZPHpFw=;
        b=pazgkw85FwJwtYAciDF61eezzo2+S2yOpQU/w0DLoaDNyfTWV57pRL0IW6LGckfks4
         PlOB8sPL5+4RSbVr+mbWLIcdz03xFvcQ2I8eSLIwhoAoFzfSbFiSDUNIOFyLiuHxkPKw
         WuP3xOJoUYSU4D5dhGvtUsJjoN89G41Jup7Fw+nTFoxsS/twpCiSbOWbmsIn3EvtuZFK
         nryZbyfjnls4QZilmsvxJR8q+zNb5XxFTqV9jYCJU2MQ0TuD5+IiKJ6KEvs+NE7I7V6U
         CIowe94T7QYmjq/YV8rb8vOB6TJR+2ZyjpM/cKP4dembofOaJWO1eVMr9b1PjEwQXfxe
         0Rvg==
X-Gm-Message-State: AOAM533invqx86641JBmafGZ4IvLur0o4EzQ6HR4yeWbDNv+y3pkeGEv
        kHa1N+z00B9RKn/tV7mwjg2Q7GdP6NKaLV6NTQDnsA==
X-Google-Smtp-Source: ABdhPJx+XJja9QmJ3YmL5ZIcR7cEiHctbogPUidPX/ngHjqaF6Vs9HvPRSruYhOOLnu79JRJ91pGoIl9sM+wQ1uUUt4=
X-Received: by 2002:a05:600c:5113:b0:394:800c:4c36 with SMTP id
 o19-20020a05600c511300b00394800c4c36mr11044954wms.93.1652074484181; Sun, 08
 May 2022 22:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com>
 <20220420112450.155624-8-apatel@ventanamicro.com> <CAOnJCUKPTwjGr9Lg1XRMVTCMswg0E+4VvknBQ0p+Qo6EHL3M5A@mail.gmail.com>
In-Reply-To: <CAOnJCUKPTwjGr9Lg1XRMVTCMswg0E+4VvknBQ0p+Qo6EHL3M5A@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 9 May 2022 11:04:32 +0530
Message-ID: <CAAhSdy0QxZ7kfh34DO_mPuCbXUM6Use7XT-TSpayR1B3BEU3tg@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] RISC-V: KVM: Cleanup stale TLB entries when host
 CPU changes
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 6, 2022 at 1:23 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > On RISC-V platforms with hardware VMID support, we share same
> > VMID for all VCPUs of a particular Guest/VM. This means we might
> > have stale G-stage TLB entries on the current Host CPU due to
> > some other VCPU of the same Guest which ran previously on the
> > current Host CPU.
> >
> > To cleanup stale TLB entries, we simply flush all G-stage TLB
> > entries by VMID whenever underlying Host CPU changes for a VCPU.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h |  5 +++++
> >  arch/riscv/kvm/tlb.c              | 23 +++++++++++++++++++++++
> >  arch/riscv/kvm/vcpu.c             | 11 +++++++++++
> >  3 files changed, 39 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index a40e88a9481c..94349a5ffd34 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -166,6 +166,9 @@ struct kvm_vcpu_arch {
> >         /* VCPU ran at least once */
> >         bool ran_atleast_once;
> >
> > +       /* Last Host CPU on which Guest VCPU exited */
> > +       int last_exit_cpu;
> > +
> >         /* ISA feature bits (similar to MISA) */
> >         unsigned long isa;
> >
> > @@ -256,6 +259,8 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
> >                                      unsigned long order);
> >  void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
> >
> > +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
> > +
> >  void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
> > diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> > index c0f86d09c41d..1a76d0b1907d 100644
> > --- a/arch/riscv/kvm/tlb.c
> > +++ b/arch/riscv/kvm/tlb.c
> > @@ -215,6 +215,29 @@ void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
> >         csr_write(CSR_HGATP, hgatp);
> >  }
> >
> > +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
> > +{
> > +       unsigned long vmid;
> > +
> > +       if (!kvm_riscv_gstage_vmid_bits() ||
> > +           vcpu->arch.last_exit_cpu == vcpu->cpu)
> > +               return;
> > +
> > +       /*
> > +        * On RISC-V platforms with hardware VMID support, we share same
> > +        * VMID for all VCPUs of a particular Guest/VM. This means we might
> > +        * have stale G-stage TLB entries on the current Host CPU due to
> > +        * some other VCPU of the same Guest which ran previously on the
> > +        * current Host CPU.
> > +        *
> > +        * To cleanup stale TLB entries, we simply flush all G-stage TLB
> > +        * entries by VMID whenever underlying Host CPU changes for a VCPU.
> > +        */
> > +
> > +       vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> > +       kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> > +}
> > +
> >  void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
> >  {
> >         local_flush_icache_all();
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 9cd8f6e91c98..a86710fcd2e0 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -67,6 +67,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> >         if (loaded)
> >                 kvm_arch_vcpu_put(vcpu);
> >
> > +       vcpu->arch.last_exit_cpu = -1;
> > +
> >         memcpy(csr, reset_csr, sizeof(*csr));
> >
> >         memcpy(cntx, reset_cntx, sizeof(*cntx));
> > @@ -735,6 +737,7 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> >  {
> >         guest_state_enter_irqoff();
> >         __kvm_riscv_switch_to(&vcpu->arch);
> > +       vcpu->arch.last_exit_cpu = vcpu->cpu;
> >         guest_state_exit_irqoff();
> >  }
> >
> > @@ -829,6 +832,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                         continue;
> >                 }
> >
> > +               /*
> > +                * Cleanup stale TLB enteries
> > +                *
> > +                * Note: This should be done after G-stage VMID has been
> > +                * updated using kvm_riscv_gstage_vmid_ver_changed()
> > +                */
> > +               kvm_riscv_local_tlb_sanitize(vcpu);
> > +
> >                 guest_timing_enter_irqoff();
> >
> >                 kvm_riscv_vcpu_enter_exit(vcpu);
> > --
> > 2.25.1
> >
>
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Queued this patch for 5.19

Thanks,
Anup

> --
> Regards,
> Atish
