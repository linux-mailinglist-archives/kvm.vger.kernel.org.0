Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CDC46CB96
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 04:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243918AbhLHDjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 22:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbhLHDjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 22:39:49 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA93C061574;
        Tue,  7 Dec 2021 19:36:18 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 8so1297106pfo.4;
        Tue, 07 Dec 2021 19:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nlNeWYNiG4wB8fm8bDrml6qpR1XZ26MTyLEwdFMRF/4=;
        b=NJVkmMSKJXGl1BnVEPIA+D/PYLXZ+ECpHsfoy/wWRZ0HP8kAKK6Ey7njNcKm5PRTgh
         Wf19nWS31leJ7e29BCqzT87wSk5rFOzWQcxP/ycztfegZS1VQaJ7nwM0LcvD5l1KDCXE
         qytWxlvZfs+c6z09AvnR5i6vMXeGL1Vg9Jg6FaW99Y/NZbZUBOR5tJQgotFnzjeCvAho
         y9uwJcESkSzvTgjA77nDwndrRGL+dO86ZlR9oZf0oEgsaINT46jMdKDyOg7xYOafOEBv
         5KfwSJL+2q8wp+3XmqyxnLHvi1ajsvxJI/2PMbIBh8bH8xwa8odj8nOa4thWHRFfz3SJ
         9VDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nlNeWYNiG4wB8fm8bDrml6qpR1XZ26MTyLEwdFMRF/4=;
        b=HvsIlJHcIDEH89nJqPBjR7wyoqrDckm1rYCB6SVIsK8vxCsRsgDp7fZF3fuyjWvrxm
         EQl1GVWI2L76SvwbDLmhWF9jEvJi3ImHTTxIcnVZ6dU/NabjJKB5cq8nAKUnVMR/0swH
         7MTiyt9ANiXabDpFIrpZoaAGWD2sXUbSa7JzpCW+cXn1CPpK+2neUxEzz0dMVhdNMtvD
         hNDwCmINiEFTjF9Qu+NaEsEVb88G8D3pnqYAMUZe3CrpHPDC0n4IKje6ksYNRvPXVjIt
         3A+qAL2gGyEYLwWAYQPfDxy3agbo3439BpMswi/nAAsl7XGdgIBDfBrie4rF3E7P5LEL
         MrqA==
X-Gm-Message-State: AOAM533UoNRXHPK9ClzWSi7KAKWtr1D4Yz/z4cpc3BYFyKJEWVBxjcpq
        u3PGmNdqoKMYVDY5AoJsYl4=
X-Google-Smtp-Source: ABdhPJw858T+Ft5YFgbYzDbNKhxlNhCChFcnA3iCs7bqKNM1wEeGUU2m0khMKafIp/1uHH92tl9hNw==
X-Received: by 2002:a65:6452:: with SMTP id s18mr18820567pgv.393.1638934577753;
        Tue, 07 Dec 2021 19:36:17 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id y190sm1263859pfg.153.2021.12.07.19.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:36:17 -0800 (PST)
Date:   Wed, 8 Dec 2021 11:36:09 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211208113609.483d5f1a@gmail.com>
In-Reply-To: <Ya/s17QDlGZi9COR@google.com>
References: <20211124125409.6eec3938@gmail.com>
        <Ya/s17QDlGZi9COR@google.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Dec 2021 23:23:03 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Nov 24, 2021, Aili Yao wrote:
> > When cpu-pm is successfully enabled, and hlt_in_guest is true and
> > mwait_in_guest is false, the guest cant't use Monitor/Mwait instruction
> > for idle operation, instead, the guest may use halt for that purpose, as
> > we have enable the cpu-pm feature and hlt_in_guest is true, we will also
> > minimize the guest exit; For such a scenario, Monitor/Mwait instruction
> > support is totally disabled, the guest has no way to use Mwait to exit from
> > non-root mode;
> > 
> > For cpu-pm feature, hlt_in_guest and others except mwait_in_guest will
> > be a good hint for it. So replace it with hlt_in_guest.  
> 
> This should be a separate patch from the housekeeping_cpu() check, if we add
> the housekeeping check.
> 
> > Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> > ---
> >  arch/x86/kvm/lapic.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 759952dd1222..42aef1accd6b 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -34,6 +34,7 @@
> >  #include <asm/delay.h>
> >  #include <linux/atomic.h>
> >  #include <linux/jump_label.h>
> > +#include <linux/sched/isolation.h>
> >  #include "kvm_cache_regs.h"
> >  #include "irq.h"
> >  #include "ioapic.h"
> > @@ -113,13 +114,14 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> >  
> >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> >  {
> > -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > +		!housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);  
> 
> Why not check kvm_{hlt,mwait}_in_guest()?  IIUC, non-housekeeping CPUs don't _have_
> to be associated 1:1 with a vCPU, in which case posting the timer is unlikely
> to be a performance win even though the target isn't a housekeeping CPU.

Yes, non-housekeeping CPUs can be assigned to multi vCPUs, I don't think it's a common configuration;
But this can happen.

> And wouldn't exposing HLT/MWAIT to a vCPU that's on a housekeeping CPU be a bogus
> configuration?

Agree, it's a bogus configuration and not suppose to like this, but this can happen;

It seems we can't cover all the abnormal cases in a single line. So I think just checking for
most right configurations is needed.

> >  }
> >  
> >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> >  {
> >  	return kvm_x86_ops.set_hv_timer
> > -	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > +	       && !(kvm_hlt_in_guest(vcpu->kvm) ||  
> 
> This is incorrect, the HLT vs. MWAIT isn't purely a posting interrupts thing.  The
> VMX preemption timer counts down in C0, C1, and C2, but not deeper sleep states.
> HLT is always C1, thus it's safe to use the VMX preemption timer even if the guest
> can execute HLT without exiting.
> The timer isn't compatible with MWAIT because it stops counting in C3 (or lower),
> i.e. the guest can cause the timer to stop counting.

Thanks for your pointer, now i know this.

> 
> >  		    kvm_can_post_timer_interrupt(vcpu));
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> > --   
> 
> Splicing in Wanpeng's version to try and merge the two threads:
> 
> On Tue, Nov 23, 2021 at 10:00 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> > ---
> >  arch/x86/kvm/lapic.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 759952dd1222..8257566d44c7 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> >
> >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> >  {
> > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > +       return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) && kvm_vcpu_apicv_active(vcpu);  
> 
> As Aili's changelog pointed out, MWAIT may not be advertised to the guest. 
> 
> So I think we want this?  With a non-functional, opinionated refactoring of
> kvm_can_use_hv_timer() because I'm terrible at reading !(a || b).
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 40270d7bc597..c77cb386d03d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -113,14 +113,25 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> 
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
> -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +              (kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
>  }

I think only kvm_hlt_in_guest() check is enough here, as for current code, if kvm_mwait_in_guest() is true,
kvm_hlt_in_guest must be ture, if kvm_mwait_in_guest() is false, kvm_hlt_in_guest() could also
be true.

>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
>  {
> -       return kvm_x86_ops.set_hv_timer
> -              && !(kvm_mwait_in_guest(vcpu->kvm) ||
> -                   kvm_can_post_timer_interrupt(vcpu));
> +       /*
> +        * Don't use the hypervisor timer, a.k.a. VMX Preemption Timer, if the
> +        * guest can execute MWAIT without exiting as the timer will stop
> +        * counting if the core enters C3 or lower.  HLT in the guest is ok as
> +        * HLT is effectively C1 and the timer counts in C0, C1, and C2.
> +        *
> +        * Don't use the hypervisor timer if KVM can post a timer interrupt to
> +        * the guest since posted the timer avoids taking an extra a VM-Exit
> +        * when the timer expires.
> +        */
> +       return kvm_x86_ops.set_hv_timer &&
> +              !kvm_mwait_in_guest(vcpu->kvm) &&
> +              !kvm_can_post_timer_interrupt(vcpu));
>  }
>  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> 

I think this modification covers most used configurations and it's right.
Thanks!

--Aili Yao
 
