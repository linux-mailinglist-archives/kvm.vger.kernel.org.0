Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C82EC1D6
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 18:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbhAFRMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 12:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbhAFRMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 12:12:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2E6C06134C
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 09:11:59 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j13so1922348pjz.3
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 09:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YC42Sep418k/6/yhd2iwtUsqtdYGxSoNNfQdhxN7DsU=;
        b=sAWOvCAm0vRAMKx0jb0ZbDavXsQoFVGkl/YJ0s1P2DN7JAzpDY477tQM+PneBUUDQr
         W2l0yl2/2OrrLHCT+qj62sNl/ZbbESE8l+x7l3xbQJ0+Tb/CCiiLIrsu0mAYtScyepxz
         RTCMWoVfYHBpfaRuZ/DPPoK1QsdMPGs+v2UPhzVFi6AO8NqQVWaZY9Fo/Z09n12hp1i7
         On3HpQ1Gfz8fLGfdrkctvgJ+5i0jmprJloOk+t75xkrQK10UxLxHv25UBUWcwiGphXcv
         YeFl9yJOjforR4vlVuxlgggVeeA5SE6xy6WqAd9tYaRxJScR0MXBagFWh8uqL2ym+qre
         pEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YC42Sep418k/6/yhd2iwtUsqtdYGxSoNNfQdhxN7DsU=;
        b=MmDOJ+gUXrJ+TwLHrqbOUiIxeGrGxDhTqyvBSYGuTW24FLvKHcH8wNDnMfx0UOKHf7
         Z97qC3uoAKcc+ltt2H93g9k85onzew0AwWH1VjmUVbTxyILiS6wNIiG3Ab++UPG7gyt+
         ATTFFptsCbWnKdrkAcbyoxugX+RbAd8avonk46rzA5yeD0RjG3pVhasSnAViPFZJ9l0d
         uDRiTjFDZ1nAxzG5RZMnuZeIE1iqLYlLHOsJk/5hLuufvUCemx6DbbJ64aLwDC8PS9Ge
         LsPSkUyp1ASxnkTVyP1u2rqp62HHSbIf2aGvf73I7sjdqGKjo5M4dIZmlVp8uz0hbBHa
         cpiA==
X-Gm-Message-State: AOAM5325/l8rGPr/REoL/6rCg9kLSFTSgAIOQcjButUtCqurz5xBRsvW
        sXEfjTPH+QjLvhRfy5vlkBM+Fg==
X-Google-Smtp-Source: ABdhPJxg4jLTo9gGw2vPKDL+V6crBpow6xJhEkCL8P4g9q4cOd95faDzeTMdbmQoAh0J9nc18B1iJA==
X-Received: by 2002:a17:90a:193:: with SMTP id 19mr5152267pjc.45.1609953119065;
        Wed, 06 Jan 2021 09:11:59 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 84sm3224542pfy.9.2021.01.06.09.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 09:11:58 -0800 (PST)
Date:   Wed, 6 Jan 2021 09:11:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        w90p710@gmail.com, pbonzini@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest
 context"
Message-ID: <X/XvWG18aBWocvvf@google.com>
References: <20210105192844.296277-1-nitesh@redhat.com>
 <874kjuidgp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kjuidgp.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021, Vitaly Kuznetsov wrote:
> Nitesh Narayan Lal <nitesh@redhat.com> writes:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3f7c1fc7a3ce..3e17c9ffcad8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9023,18 +9023,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  
> >  	kvm_x86_ops.handle_exit_irqoff(vcpu);
> >  
> > -	/*
> > -	 * Consume any pending interrupts, including the possible source of
> > -	 * VM-Exit on SVM 
> 
> I kind of liked this part of the comment, the new (old) one in
> svm_handle_exit_irqoff() doesn't actually explain what's going on.
> 
> > and any ticks that occur between VM-Exit and now.
> 
> Looking back, I don't quite understand why we wanted to account ticks
> between vmexit and exiting guest context as 'guest' in the first place;
> to my understanging 'guest time' is time spent within VMX non-root
> operation, the rest is KVM overhead (system).

With tick-based accounting, if the tick IRQ is received after PF_VCPU is cleared
then that tick will be accounted to the host/system.  The motivation for opening
an IRQ window after VM-Exit is to handle the case where the guest is constantly
exiting for a different reason _just_ before the tick arrives, e.g. if the guest
has its tick configured such that the guest and host ticks get synchronized
in a bad way.

This is a non-issue when using CONFIG_VIRT_CPU_ACCOUNTING_GEN=y, at least with a
stable TSC, as the accounting happens during guest_exit_irqoff() itself.
Accounting might be less-than-stellar if TSC is unstable, but I don't think it
would be as binary of a failure as tick-based accounting.

> It seems to match how the accounting is done nowadays after Tglx's
> 87fa7f3e98a1 ("x86/kvm: Move context tracking where it belongs").
> 
> > -	 * An instruction is required after local_irq_enable() to fully unblock
> > -	 * interrupts on processors that implement an interrupt shadow, the
> > -	 * stat.exits increment will do nicely.
> > -	 */
> > -	kvm_before_interrupt(vcpu);
> > -	local_irq_enable();
> >  	++vcpu->stat.exits;
> > -	local_irq_disable();
> > -	kvm_after_interrupt(vcpu);
> >  
> >  	if (lapic_in_kernel(vcpu)) {
> >  		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
> 
> FWIW,
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
