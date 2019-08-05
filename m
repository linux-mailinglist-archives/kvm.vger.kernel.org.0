Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E04811C4
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 07:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfHEFsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 01:48:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34830 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfHEFst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 01:48:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so71664659wmg.0
        for <kvm@vger.kernel.org>; Sun, 04 Aug 2019 22:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1TgAgMN1acZNwv5Q61grmXOTBBeUYwY88MxdxlFsIgo=;
        b=sVnmdtBTLTowplyB43mPn9+XoIJom4npEqgCUIIA9I6z56mRtxYVMUUcDlq+XvFMl0
         SN6cLhPICpsyH32V+Pk3fcQsMLNfI8XWZHZwK35OZEmkchXkHZuB2R7U9Eo2vMf+8eZc
         4Wk2w/b2Q0K+QYb5s/FZZ++0Zu4jh5eYgUzfhRNP9nUtl1LG1eQPQyDFiTN+gW2fkht3
         ukkGxL+AVLE41Lp2MCbJZ4PFjOU7foC7WwD4VgSBd9EkBfKFfqO9aH43GMaCxkzPcyb/
         i8QUc3Pb1e8jaxMzV8q1CdLlAQE0pQlf87lWDs3irHeCIAkKkcaq6jEhhjCJ03SVqrDK
         gISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1TgAgMN1acZNwv5Q61grmXOTBBeUYwY88MxdxlFsIgo=;
        b=FsebE7ZajUtO0c0vm//g2WW6Qi3Dd6EogZeXMEhqB9Tu9Kr6tghT122zyNDMiQuSfM
         EqX8224UeAvo1fKO2OvZSFEGIlUKfokpH9WJCff/MkzUZkHKYRowVJb28od0lYz4Pg9+
         ElqqWnFVQzsB/lhYiUgKGJXAtpgHRLVQRqFV+iBH1siyB3UWlqGuwcb1YE17uTKaPnkO
         XgXKx3AMEDlMsAGTJPHIgVn98zaDNYeXhq21T15ekOWgVPYWYfVclM+S4eISbbaRqWGs
         moYYLMhMUwVE/qqDZLv0Qeqi9F39sgUgbpIIGNY+MpC0BaridezHsIFKn492Qw59P5U5
         VQYQ==
X-Gm-Message-State: APjAAAVko3/d+EyQqLK72Xa29jLQa9s9b2mmXVl5BpN39vm3RRG9AgXQ
        YuySgkwkPGpcP9ViM+uQGoYCD/uh5MM44x2euw4Pqg==
X-Google-Smtp-Source: APXvYqzW3IowkTSrn4nUEPSacemcxGVfBVssQwFtqtRFmO8Phkuhnd8lGP7wGdYpat5rhVK2w/B0MXCPFoNEYeOkEz4=
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr15160196wmg.24.1564984126543;
 Sun, 04 Aug 2019 22:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-5-anup.patel@wdc.com>
 <9f30d2b6-fa2c-22ff-e597-b9fbd1c700ff@redhat.com>
In-Reply-To: <9f30d2b6-fa2c-22ff-e597-b9fbd1c700ff@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 11:18:34 +0530
Message-ID: <CAAhSdy16w+98VB7+DtVJOngABu2uUDmYmqURMsRBqzvKCQfGUQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/19] RISC-V: Add initial skeletal KVM support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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

On Fri, Aug 2, 2019 at 2:31 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/19 09:47, Anup Patel wrote:
> > +static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
> > +{
> > +     if (kvm_request_pending(vcpu)) {
> > +             /* TODO: */
> > +
> > +             /*
> > +              * Clear IRQ_PENDING requests that were made to guarantee
> > +              * that a VCPU sees new virtual interrupts.
> > +              */
> > +             kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
> > +     }
> > +}
>
> This kvm_check_request can go away (as it does in patch 6).

Argh, I should have removed it in v2 itself.

Thanks for catching. I will update.

>
> > +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > +{
> > +     int ret;
> > +     unsigned long scause, stval;
>
> You need to wrap this with srcu_read_lock/srcu_read_unlock, otherwise
> stage2_page_fault can access freed memslot arrays.  (ARM doesn't have
> this issue because it does not have to decode instructions on MMIO faults).

Looking at KVM ARM/ARM64, I was not sure about use of kvm->srcu. Thanks
for clarifying. I will use kvm->srcu like you suggested.

>
> That is,
>
>         vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>
> > +     /* Process MMIO value returned from user-space */
> > +     if (run->exit_reason == KVM_EXIT_MMIO) {
> > +             ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     if (run->immediate_exit)
> > +             return -EINTR;
> > +
> > +     vcpu_load(vcpu);
> > +
> > +     kvm_sigset_activate(vcpu);
> > +
> > +     ret = 1;
> > +     run->exit_reason = KVM_EXIT_UNKNOWN;
> > +     while (ret > 0) {
> > +             /* Check conditions before entering the guest */
> > +             cond_resched();
> > +
> > +             kvm_riscv_check_vcpu_requests(vcpu);
> > +
> > +             preempt_disable();
> > +
> > +             local_irq_disable();
> > +
> > +             /*
> > +              * Exit if we have a signal pending so that we can deliver
> > +              * the signal to user space.
> > +              */
> > +             if (signal_pending(current)) {
> > +                     ret = -EINTR;
> > +                     run->exit_reason = KVM_EXIT_INTR;
> > +             }
>
> Add an srcu_read_unlock here (and then the smp_store_mb can become
> smp_mb__after_srcu_read_unlock + WRITE_ONCE).

Sure, I will update.

>
>
> > +             /*
> > +              * Ensure we set mode to IN_GUEST_MODE after we disable
> > +              * interrupts and before the final VCPU requests check.
> > +              * See the comment in kvm_vcpu_exiting_guest_mode() and
> > +              * Documentation/virtual/kvm/vcpu-requests.rst
> > +              */
> > +             smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> > +
> > +             if (ret <= 0 ||
> > +                 kvm_request_pending(vcpu)) {
> > +                     vcpu->mode = OUTSIDE_GUEST_MODE;
> > +                     local_irq_enable();
> > +                     preempt_enable();
> > +                     continue;
> > +             }
> > +
> > +             guest_enter_irqoff();
> > +
> > +             __kvm_riscv_switch_to(&vcpu->arch);
> > +
> > +             vcpu->mode = OUTSIDE_GUEST_MODE;
> > +             vcpu->stat.exits++;
> > +
> > +             /* Save SCAUSE and STVAL because we might get an interrupt
> > +              * between __kvm_riscv_switch_to() and local_irq_enable()
> > +              * which can potentially overwrite SCAUSE and STVAL.
> > +              */
> > +             scause = csr_read(CSR_SCAUSE);
> > +             stval = csr_read(CSR_STVAL);
> > +
> > +             /*
> > +              * We may have taken a host interrupt in VS/VU-mode (i.e.
> > +              * while executing the guest). This interrupt is still
> > +              * pending, as we haven't serviced it yet!
> > +              *
> > +              * We're now back in HS-mode with interrupts disabled
> > +              * so enabling the interrupts now will have the effect
> > +              * of taking the interrupt again, in HS-mode this time.
> > +              */
> > +             local_irq_enable();
> > +
> > +             /*
> > +              * We do local_irq_enable() before calling guest_exit() so
> > +              * that if a timer interrupt hits while running the guest
> > +              * we account that tick as being spent in the guest. We
> > +              * enable preemption after calling guest_exit() so that if
> > +              * we get preempted we make sure ticks after that is not
> > +              * counted as guest time.
> > +              */
> > +             guest_exit();
> > +
> > +             preempt_enable();
>
> And another srcu_read_lock here.  Using vcpu->srcu_idx instead of a
> local variable also allows system_opcode_insn to wrap kvm_vcpu_block
> with a srcu_read_unlock/srcu_read_lock pair.

Okay.

>
> > +             ret = kvm_riscv_vcpu_exit(vcpu, run, scause, stval);
> > +     }
> > +
> > +     kvm_sigset_deactivate(vcpu);
>
> And finally srcu_read_unlock here.

Okay.

Regards,
Anup
