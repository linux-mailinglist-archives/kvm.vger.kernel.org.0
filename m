Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD93ADFCFE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 07:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfJVFJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 01:09:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41298 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731014AbfJVFJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 01:09:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id p4so16374693wrm.8
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 22:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u/quP6H3t0vd+EUHeiV1XtwPAgHpe/L6SdgFukt3v7I=;
        b=UJDKA2KXuJEpZjuCE7M0A4TYaHJwXeoBaS3iWDPtUSt7GpqUGQrS3O4k6DvdgSb0bN
         redzX4NV6SW/+egZUr2DuF4GQmoqZw7FDbnKJCBzFeU7rWxVQouA5kFncvAehzf3jKqK
         gdTnn7FZd+1uzTx9c+42X/rn+kUbhA3rerOGp02RJnWesekdrGx8kquK5lfH4pNSvvKR
         8hVX21GmgbEXHn5F9CCMPTbdlfTnvqE7OfjMz7MWDEo2qd4NIV6VUFFGdpo6bdcurrUX
         vG60tTnjBqx+BZ1xWISIV0eIeEvBvPOMyy/oxA+ZGo7xMeMx3TYp231RgISwQayeJOpK
         MH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u/quP6H3t0vd+EUHeiV1XtwPAgHpe/L6SdgFukt3v7I=;
        b=Gzd2/P3OpyCkB5FwyykP2TPO3/GWFSpDUVREvt/3gX0zoAmMu2/29xBUG2zhnUo23n
         bZ0FAXYJU4tzKfPl9Byq2g/HUaJSQyE94ko6r7DkVAEroSjSu60QLKEd3YJmrzNrhCkc
         pzUCt6SGTmAt2zYaSlXvPdKkNFaEOalJZxw3kF9enwfZUt4kDeW8oiaMAFUDF1GJPrhq
         oQ3zrvZFeNcJ0xLO8bEgP7Wh4e6PFVc9fWSHO0fuGDP+wNJn3zovfGr5GybsOioftT99
         3Sj3JqE+0QFrDvsVO22GzmHupbQA4z/4r1lyMUC1dsRQDSHeAadaGYJN+0xw3jIs5cNC
         E9eg==
X-Gm-Message-State: APjAAAVJ4j+VkxhVzw5MnUTf4zub0PTDfJ72hBhN4t+5BiLE7E0r6Xnj
        MQtxMn2SERvZkan3aJ++0hAvt2jyXvhPhgSt/0d72g==
X-Google-Smtp-Source: APXvYqwZD1j8xJWElPYHYhi9Zjt/MS9g2ikbsI1900bS88lRyEawqVJJ6EO8O2gyxOTlf+Gdd0g0pZutNuTIzTbuOe4=
X-Received: by 2002:adf:e850:: with SMTP id d16mr1439791wrn.251.1571720981754;
 Mon, 21 Oct 2019 22:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191016160649.24622-1-anup.patel@wdc.com> <20191016160649.24622-20-anup.patel@wdc.com>
 <7381057d-a3f3-e79a-bb2c-b078fc918b1f@redhat.com>
In-Reply-To: <7381057d-a3f3-e79a-bb2c-b078fc918b1f@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 22 Oct 2019 10:39:30 +0530
Message-ID: <CAAhSdy0E02VC0+Qb8Tczcs1YFMdFRRhM2VsGqNu1ZFLmohUAdw@mail.gmail.com>
Subject: Re: [PATCH v9 19/22] RISC-V: KVM: Remove per-CPU vsip_shadow variable
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 10:58 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 16/10/19 18:12, Anup Patel wrote:
> > Currently, we track last value wrote to VSIP CSR using per-CPU
> > vsip_shadow variable but this easily goes out-of-sync because
> > Guest can update VSIP.SSIP bit directly.
> >
> > To simplify things, we remove per-CPU vsip_shadow variable and
> > unconditionally write vcpu->arch.guest_csr.vsip to VSIP CSR in
> > run-loop.
> >
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
>
> Please squash this and patch 20 into the corresponding patches earlier
> in the series.

Sure, I will squash patch20 and patch19 onto patch5.

Regards,
Anup


>
> Paolo
>
> > ---
> >  arch/riscv/include/asm/kvm_host.h |  3 ---
> >  arch/riscv/kvm/main.c             |  6 ------
> >  arch/riscv/kvm/vcpu.c             | 24 +-----------------------
> >  3 files changed, 1 insertion(+), 32 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index ec1ca4bc98f2..cd86acaed055 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -202,9 +202,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> >  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> >
> > -int kvm_riscv_setup_vsip(void);
> > -void kvm_riscv_cleanup_vsip(void);
> > -
> >  #define KVM_ARCH_WANT_MMU_NOTIFIER
> >  int kvm_unmap_hva_range(struct kvm *kvm,
> >                       unsigned long start, unsigned long end);
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index 55df85184241..002301a27d29 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -61,17 +61,11 @@ void kvm_arch_hardware_disable(void)
> >
> >  int kvm_arch_init(void *opaque)
> >  {
> > -     int ret;
> > -
> >       if (!riscv_isa_extension_available(NULL, h)) {
> >               kvm_info("hypervisor extension not available\n");
> >               return -ENODEV;
> >       }
> >
> > -     ret = kvm_riscv_setup_vsip();
> > -     if (ret)
> > -             return ret;
> > -
> >       kvm_riscv_stage2_vmid_detect();
> >
> >       kvm_info("hypervisor extension available\n");
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index fd77cd39dd8c..f1a218d3a8cf 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -111,8 +111,6 @@ static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx) {}
> >                                riscv_isa_extension_mask(s) | \
> >                                riscv_isa_extension_mask(u))
> >
> > -static unsigned long __percpu *vsip_shadow;
> > -
> >  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > @@ -765,7 +763,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> >       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > -     unsigned long *vsip = raw_cpu_ptr(vsip_shadow);
> >
> >       csr_write(CSR_VSSTATUS, csr->vsstatus);
> >       csr_write(CSR_VSIE, csr->vsie);
> > @@ -775,7 +772,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >       csr_write(CSR_VSCAUSE, csr->vscause);
> >       csr_write(CSR_VSTVAL, csr->vstval);
> >       csr_write(CSR_VSIP, csr->vsip);
> > -     *vsip = csr->vsip;
> >       csr_write(CSR_VSATP, csr->vsatp);
> >
> >       kvm_riscv_stage2_update_hgatp(vcpu);
> > @@ -843,26 +839,8 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  static void kvm_riscv_update_vsip(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > -     unsigned long *vsip = raw_cpu_ptr(vsip_shadow);
> > -
> > -     if (*vsip != csr->vsip) {
> > -             csr_write(CSR_VSIP, csr->vsip);
> > -             *vsip = csr->vsip;
> > -     }
> > -}
> > -
> > -int kvm_riscv_setup_vsip(void)
> > -{
> > -     vsip_shadow = alloc_percpu(unsigned long);
> > -     if (!vsip_shadow)
> > -             return -ENOMEM;
> >
> > -     return 0;
> > -}
> > -
> > -void kvm_riscv_cleanup_vsip(void)
> > -{
> > -     free_percpu(vsip_shadow);
> > +     csr_write(CSR_VSIP, csr->vsip);
> >  }
> >
> >  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >
>
