Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8BE2EB705
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 01:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbhAFArv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 19:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAFArv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 19:47:51 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCEAC061574
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 16:47:10 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id c22so1002591pgg.13
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 16:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kfZHZyAWKT0gu1CtPbXfDi7dkaM3yoFhEPhGiiQ+Kio=;
        b=mznuT4pmE2K/KBt/x1qYYASeoW2mxiPhdL9Sbt/9EFV6uHc00DGWuRrJ6CDOKiDNPu
         3Upf+SBQDOXEjaikajh/x9WEmOrPNw9tnGdMIeZayGxdsD4qS54GvoAM+jAYRk79g2+h
         TlpBA0N4VR6/UCBCV4gb4UT8UQWnMETvvHYxP+bDAfocQz4oyR8OQ8BuHtHiIAHFBp8I
         obTORNwqYBEYb6xse0xjjf2uod7csj+3joSolWkamlPLuduLvYCIgngG/Ro3XvYzXjkm
         46qOfVcMb1IOK1aBxqOG52EgucJC+mECAmeTyFsfITUk8Ehk+ZCDzDOhdKBLyMYw7KgL
         fwxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kfZHZyAWKT0gu1CtPbXfDi7dkaM3yoFhEPhGiiQ+Kio=;
        b=X8SPeJ+MHzrCBCxyFzZoXrk80rT+o3iRIUECbvDWRuDsC+6XswjA/ALq6E8GjGTr2i
         Ukl9w5QygeEnqrSRY4EWv6oyuo0/Hyrgt3XPz/hFAJCWBcD9DjxZhrZYb7TOKRM3fN2t
         hhniNV4bbjXSg72+5TWUg8AM738YBj4U/S5yYRsb+O2a5Kg1c3fX+jxYM/gQWR2Idw17
         /SVcxSWyPmhO0boM7RtyI0UMwnCekqvJ9SFnhwmQmRSzIJA3jAo4QwukWlZMic7OFcQW
         phTZBkmXw+47DNpXAdq6Tr3J7wCvFQYAx186KAwpkPGc8S+cTkLikBChPJsJXvTFlIpa
         0W9w==
X-Gm-Message-State: AOAM530REit+nVCHd2R6fFsvVXZ48CwOamcUIUVUlLEGfGw4Yxt5Jtiy
        CW5sTPCZcqfJa0iLYj1yGNLoJRhi411uCg==
X-Google-Smtp-Source: ABdhPJyu5Tyi0wca8RhA5ga+vXWR4SVQ9h7Ae2a/N1qGEmPIiGmMlZWuKMfrxz4HvVSvOpgbdkdYmg==
X-Received: by 2002:a63:591f:: with SMTP id n31mr1748019pgb.244.1609894030333;
        Tue, 05 Jan 2021 16:47:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a12sm368788pgq.5.2021.01.05.16.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 16:47:09 -0800 (PST)
Date:   Tue, 5 Jan 2021 16:47:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        w90p710@gmail.com, pbonzini@redhat.com, vkuznets@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest
 context"
Message-ID: <X/UIh1PqmSLNg8vM@google.com>
References: <20210105192844.296277-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105192844.296277-1-nitesh@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+tglx

On Tue, Jan 05, 2021, Nitesh Narayan Lal wrote:
> This reverts commit d7a08882a0a4b4e176691331ee3f492996579534.
> 
> After the introduction of the patch:
> 
> 	87fa7f3e9: x86/kvm: Move context tracking where it belongs
> 
> since we have moved guest_exit_irqoff closer to the VM-Exit, explicit
> enabling of irqs to process pending interrupts should not be required
> within vcpu_enter_guest anymore.

Ugh, except that commit completely broke tick-based accounting, on both Intel
and AMD.  With guest_exit_irqoff() being called immediately after VM-Exit, any
tick that happens after IRQs are disabled will be accounted to the host.  E.g.
on Intel, even an IRQ VM-Exit that has already been acked by the CPU isn't
processed until kvm_x86_ops.handle_exit_irqoff(), well after PF_VCPU has been
cleared.

CONFIG_VIRT_CPU_ACCOUNTING_GEN=y should still work (I didn't bother to verify).

Thomas, any clever ideas?  Handling IRQs in {vmx,svm}_vcpu_enter_exit() isn't an
option as KVM hasn't restored enough state to handle an IRQ, e.g. PKRU and XCR0
are still guest values.  Is it too heinous to fudge PF_VCPU across KVM's
"pending" IRQ handling?  E.g. this god-awful hack fixes the accounting:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 836912b42030..5a777fd35b4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9028,6 +9028,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
        vcpu->mode = OUTSIDE_GUEST_MODE;
        smp_wmb();
 
+       current->flags |= PF_VCPU;
        kvm_x86_ops.handle_exit_irqoff(vcpu);
 
        /*
@@ -9042,6 +9043,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
        ++vcpu->stat.exits;
        local_irq_disable();
        kvm_after_interrupt(vcpu);
+       current->flags &= ~PF_VCPU;
 
        if (lapic_in_kernel(vcpu)) {
                s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;

> Conflicts:
> 	arch/x86/kvm/svm.c
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  9 +++++++++
>  arch/x86/kvm/x86.c     | 11 -----------
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cce0143a6f80..c9b2fbb32484 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4187,6 +4187,15 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  
>  static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
> +	kvm_before_interrupt(vcpu);
> +	local_irq_enable();
> +	/*
> +	 * We must have an instruction with interrupts enabled, so
> +	 * the timer interrupt isn't delayed by the interrupt shadow.
> +	 */
> +	asm("nop");
> +	local_irq_disable();
> +	kvm_after_interrupt(vcpu);
>  }
>  
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3f7c1fc7a3ce..3e17c9ffcad8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9023,18 +9023,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	kvm_x86_ops.handle_exit_irqoff(vcpu);
>  
> -	/*
> -	 * Consume any pending interrupts, including the possible source of
> -	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
> -	 * An instruction is required after local_irq_enable() to fully unblock
> -	 * interrupts on processors that implement an interrupt shadow, the
> -	 * stat.exits increment will do nicely.
> -	 */
> -	kvm_before_interrupt(vcpu);
> -	local_irq_enable();
>  	++vcpu->stat.exits;
> -	local_irq_disable();
> -	kvm_after_interrupt(vcpu);
>  
>  	if (lapic_in_kernel(vcpu)) {
>  		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
> -- 
> 2.27.0
> 
