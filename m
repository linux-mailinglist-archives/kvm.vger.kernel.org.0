Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340613909F1
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 21:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhEYTxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 15:53:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231442AbhEYTxl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 15:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621972331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nGP41R39mkAjt7XqFET82Q1jeEhxHpTBwlHlsk5MGVs=;
        b=hOY+nSjWmCOMVxir2E4+tv2ehjPoMNJECLV2CR/npCo1bhppnEuD6+2JBQn4fYlJdwX4Ek
        eJuZI9zpc/C8tIJdswnvbws2IM7jOZdQ+hbkFbi8XaA1ruPXqbp0drfBI4WTiR6c2yUuop
        TgD+w0H0hPPDLBZZ3KbtepBR8x5RWwI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-7BhlcIcfN_yTkSe5KcLYcg-1; Tue, 25 May 2021 15:52:09 -0400
X-MC-Unique: 7BhlcIcfN_yTkSe5KcLYcg-1
Received: by mail-qv1-f71.google.com with SMTP id h10-20020a0cab0a0000b029020282c64ecfso12504710qvb.19
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 12:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nGP41R39mkAjt7XqFET82Q1jeEhxHpTBwlHlsk5MGVs=;
        b=FbxVtzAVx21AhZSe9ZnNSsCdzA3ueVP0JxHqeQdqm6ecHdNxJLsgORzD/IoFrFOFfp
         6hRUf/kdOiPp6PCYuIJB/uO0U0jwlF2xVdMSrHuTT4vv1RauGr0OFo+4fwTK5z3kK0qN
         2jHepME2ui7SYcoBzU1mzdr/QntX67fNc7D8qXd/MAIBpGOtEvCNScHyRH+LDniZjolA
         afDDpvzr8xAdTwARsuCKHvuHUbhhhohGoZK8Es/8LqBtN2BMcXUJBnhGkJmAGErNAzim
         2k4KSYHORlqczhu0cRPtvqh6x9/rSTQkjPE7TcnGGlfKFDrkBPXxboCsk/wzAp996rP2
         Dv3Q==
X-Gm-Message-State: AOAM533zB5RWw+FsbruqRcgnr25E2sFBkvXACBCHbtZsPcXsua5C2rfL
        E3CXJr2znESYf1sa2n4fPKkdWTBuzZr2kkTeppnYLSwgC7AMymGRN2SazYHRSUmOPJ6TQdnQye2
        4TzuUaqXb4XyC
X-Received: by 2002:a05:622a:164a:: with SMTP id y10mr34915341qtj.97.1621972328677;
        Tue, 25 May 2021 12:52:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8XLj7Z6Zv27SjCuQfLfYMXglJ4ztkA2tG6Xx36q8w3cqUAM+DFKZvIkdv0fCDrolBo8k/Ag==
X-Received: by 2002:a05:622a:164a:: with SMTP id y10mr34915327qtj.97.1621972328382;
        Tue, 25 May 2021 12:52:08 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id s10sm115640qkj.77.2021.05.25.12.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 12:52:07 -0700 (PDT)
Date:   Tue, 25 May 2021 15:52:06 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 2/3] KVM: rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK
Message-ID: <YK1VZogK5n7Anqy8@t490s>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.303768132@redhat.com>
 <YK1MmcHqJGCR631n@t490s>
 <20210525192637.GC365242@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210525192637.GC365242@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 04:26:37PM -0300, Marcelo Tosatti wrote:
> On Tue, May 25, 2021 at 03:14:33PM -0400, Peter Xu wrote:
> > On Tue, May 25, 2021 at 10:41:17AM -0300, Marcelo Tosatti wrote:
> > > KVM_REQ_UNBLOCK will be used to exit a vcpu from
> > > its inner vcpu halt emulation loop.
> > > 
> > > Rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK, switch
> > > PowerPC to arch specific request bit.
> > > 
> > > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > > 
> > > Index: kvm/include/linux/kvm_host.h
> > > ===================================================================
> > > --- kvm.orig/include/linux/kvm_host.h
> > > +++ kvm/include/linux/kvm_host.h
> > > @@ -146,7 +146,7 @@ static inline bool is_error_page(struct
> > >   */
> > >  #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > >  #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > > -#define KVM_REQ_PENDING_TIMER     2
> > > +#define KVM_REQ_UNBLOCK           2
> > >  #define KVM_REQ_UNHALT            3
> > >  #define KVM_REQUEST_ARCH_BASE     8
> > >  
> > > Index: kvm/virt/kvm/kvm_main.c
> > > ===================================================================
> > > --- kvm.orig/virt/kvm/kvm_main.c
> > > +++ kvm/virt/kvm/kvm_main.c
> > > @@ -2794,6 +2794,8 @@ static int kvm_vcpu_check_block(struct k
> > >  		goto out;
> > >  	if (signal_pending(current))
> > >  		goto out;
> > > +	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
> > > +		goto out;
> > >  
> > >  	ret = 0;
> > >  out:
> > > Index: kvm/Documentation/virt/kvm/vcpu-requests.rst
> > > ===================================================================
> > > --- kvm.orig/Documentation/virt/kvm/vcpu-requests.rst
> > > +++ kvm/Documentation/virt/kvm/vcpu-requests.rst
> > > @@ -118,10 +118,11 @@ KVM_REQ_MMU_RELOAD
> > >    necessary to inform each VCPU to completely refresh the tables.  This
> > >    request is used for that.
> > >  
> > > -KVM_REQ_PENDING_TIMER
> > > +KVM_REQ_UNBLOCK
> > >  
> > >    This request may be made from a timer handler run on the host on behalf
> > > -  of a VCPU.  It informs the VCPU thread to inject a timer interrupt.
> > > +  of a VCPU, or when device assignment is performed. It informs the VCPU to
> > > +  exit the vcpu halt inner loop.
> > >  
> > >  KVM_REQ_UNHALT
> > >  
> > > Index: kvm/arch/powerpc/include/asm/kvm_host.h
> > > ===================================================================
> > > --- kvm.orig/arch/powerpc/include/asm/kvm_host.h
> > > +++ kvm/arch/powerpc/include/asm/kvm_host.h
> > > @@ -51,6 +51,7 @@
> > >  /* PPC-specific vcpu->requests bit members */
> > >  #define KVM_REQ_WATCHDOG	KVM_ARCH_REQ(0)
> > >  #define KVM_REQ_EPR_EXIT	KVM_ARCH_REQ(1)
> > > +#define KVM_REQ_PENDING_TIMER	KVM_ARCH_REQ(2)
> > >  
> > >  #include <linux/mmu_notifier.h>
> > >  
> > > Index: kvm/arch/x86/kvm/lapic.c
> > > ===================================================================
> > > --- kvm.orig/arch/x86/kvm/lapic.c
> > > +++ kvm/arch/x86/kvm/lapic.c
> > > @@ -1657,7 +1657,7 @@ static void apic_timer_expired(struct kv
> > >  	}
> > >  
> > >  	atomic_inc(&apic->lapic_timer.pending);
> > > -	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> > > +	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> > >  	if (from_timer_fn)
> > >  		kvm_vcpu_kick(vcpu);
> > >  }
> > 
> > Pure question on the existing code: why do we need kvm_make_request() for
> > timer?  As I see kvm_vcpu_check_block() already checks explicitly for timers:
> > 
> > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > {
> >         ...
> > 	if (kvm_cpu_has_pending_timer(vcpu))
> > 		goto out;
> >         ...
> > }
> > 
> > for x86:
> > 
> > int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> > {
> > 	if (lapic_in_kernel(vcpu))
> > 		return apic_has_pending_timer(vcpu);
> > 
> > 	return 0;
> > }
> > 
> > So wondering why we can drop the two references to KVM_REQ_PENDING_TIMER in x86
> > directly..
> 
> See commit 06e05645661211b9eaadaf6344c335d2e80f0ba2

I see, thanks Marcelo.

Then we might have checked twice on timer pending in kvm_vcpu_check_block() for
x86, as we also checks KVM_REQ_UNBLOCK now. Didn't think further on how to make
it better, e.g. simply dropping kvm_cpu_has_pending_timer() won't work since
it seems to still be useful for non-x86..

Then this patch looks good to me:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

