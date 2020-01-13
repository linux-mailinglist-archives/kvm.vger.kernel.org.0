Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F6B139DA5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 00:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgAMXvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 18:51:47 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43435 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgAMXvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 18:51:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id p27so4448890pli.10
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 15:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tD53J8jGyNeupcC9TVVi1ObsGoZb81A2e8/tq4bo2Uo=;
        b=Go2wTMviwmfXcz9obTBOV/q36hwxY/kAH6c61E6u3pQ0X6X9JEOAtiaYdp2zAFlSiV
         FL5I7PGgod1AepUcmFPKByHveaKdKdpFq1/QTfGY4sjoc1/4zHxomeCbnotJv3n4CSq5
         qKJ3Um+rN7iszfh/fbmNnLP5XZPW1s2Yf2SWOjTGdJD3ZKHyqmAsMcaoKCHkjFLa9m3m
         jBo3q0ow3WSaRoXR9uhS1Yg1lak3g0+pB4XZUFB+2ksnVARmO0v9btEYuLpgPJ/+wUPp
         sYsSqe8SGmiwTn3a2RJSDjZRGI1n6ppbfWDFTMvLs9beWoVTe8BLVq6yEulEgMfUCz4h
         DOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tD53J8jGyNeupcC9TVVi1ObsGoZb81A2e8/tq4bo2Uo=;
        b=LM1gtXgCqdhzFAsblu+6bXpVlS7heQWRD6WwPTcSBf20hVnv4kQCtBAINtN+/A3jXH
         Bxx1L78jGhF4mKknKJiP/VCY33ubmzo54eOt4Fqn80VwESzxnQjD80PWm7o3q+FQytSd
         vqXETQusiYXwDmCzTBbf+qWnyWAUf79pLXJiusvyJvvhOjOU2W3NLMabuQUiXIcfvT+x
         IA0m5jntpcwDa9sAKRaZx6TA53hL1I/Md9FDToXwyPWGEJFfU9kc6GmoGJL+NPu9rZQV
         vENSGTNA/vpJt4B1jzyGI7rbGlaaoyZ6lSeWPDiBlo/4cMJps4Aeco592k8NFo+r486I
         HfCQ==
X-Gm-Message-State: APjAAAXRfh6cfNlUJJ39na9SgX4WbEPTDlgVz58q/b95R11jZWMjpW2A
        YNXcK5AhbXaCsH5WUwgt1EF/oA==
X-Google-Smtp-Source: APXvYqyd4YpCWvr6dfmYnQ7tXeYVZY/6OA+n+Ia57x9S2M4SrGOmi4iKahxxgXbPDIDGPzhNFKvzDw==
X-Received: by 2002:a17:90a:b008:: with SMTP id x8mr25776821pjq.106.1578959505267;
        Mon, 13 Jan 2020 15:51:45 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id q199sm15934680pfq.163.2020.01.13.15.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 15:51:44 -0800 (PST)
Date:   Mon, 13 Jan 2020 15:51:40 -0800
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Add vendor-specific #DB payload delivery
Message-ID: <20200113235140.GA45761@google.com>
References: <20200113221053.22053-1-oupton@google.com>
 <20200113221053.22053-2-oupton@google.com>
 <20200113225210.GB14928@linux.intel.com>
 <20200113231654.GB43583@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113231654.GB43583@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 03:16:54PM -0800, Oliver Upton wrote:
> On Mon, Jan 13, 2020 at 02:52:10PM -0800, Sean Christopherson wrote:
> > On Mon, Jan 13, 2020 at 02:10:51PM -0800, Oliver Upton wrote:
> > > VMX and SVM differ slightly in the handling of #DB debug-trap exceptions
> > > upon VM-entry. VMX defines the 'pending debug exceptions' field in the
> > > VMCS for hardware to inject the event and update debug register state
> > > upon VM-entry.
> > > 
> > > SVM provides no such mechanism for maintaining the state of a pending
> > > debug exception, as the debug register state is updated before delivery
> > > of #VMEXIT.
> > > 
> > > Lastly, while KVM defines the exception payload for debug-trap
> > > exceptions as compatible with the 'pending debug exceptions' VMCS field,
> > > it is not compatible with the DR6 register across both vendors.
> > > 
> > > Split the #DB payload delivery between SVM and VMX to capture the
> > > nuanced differences in instruction emulation. Utilize the 'pending debug
> > > exceptions' field on VMX to deliver the payload. On SVM, directly update
> > > register state with the appropriate requested bits from the exception
> > > payload.
> > > 
> > > Fixes: f10c729ff965 ("kvm: vmx: Defer setting of DR6 until #DB delivery")
> > 
> > Without even looking at the code, I recommend splitting this into two
> > patches: first fix SVM without introducing any functional changes to VMX,
> > and then change VMX to use the PENDING_DBG field.  That way the SVM code
> > isn't affected if for some reason the VMX patch needs to be reverted.
> 
> Alright, I'll split this between vendors in the SVM patch, but keep the
> existing DR6 magic in both. I'll also mask BIT(12) in the SVM patch.
> 
> > Not that I doubt the correctness of the VMX change, I just expect problems
> > by default whenever anything so much as breathes on dr6 :-)
> 
> Hah. I'll muck with VMX afterwards :)
> 
> As always, thanks for the great, prompt review Sean.
> 
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > Reviewed-by: Peter Shier <pshier@google.com>
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  1 +
> > >  arch/x86/kvm/svm.c              | 20 ++++++++++++++++++++
> > >  arch/x86/kvm/vmx/vmx.c          | 20 +++++++++++++++++++-
> > >  arch/x86/kvm/x86.c              | 21 +--------------------
> > >  4 files changed, 41 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index b79cd6aa4075..4739ca11885d 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1100,6 +1100,7 @@ struct kvm_x86_ops {
> > >  	void (*set_nmi)(struct kvm_vcpu *vcpu);
> > >  	void (*queue_exception)(struct kvm_vcpu *vcpu);
> > >  	void (*cancel_injection)(struct kvm_vcpu *vcpu);
> > > +	void (*deliver_db_payload)(struct kvm_vcpu *vcpu,
> > > +				   unsigned long payload);
> > >  	int (*interrupt_allowed)(struct kvm_vcpu *vcpu);
> > >  	int (*nmi_allowed)(struct kvm_vcpu *vcpu);
> > >  	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index 122d4ce3b1ab..16ded16af997 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -5615,6 +5615,25 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
> > >  	svm_complete_interrupts(svm);
> > >  }
> > >  
> > > +static void svm_deliver_db_payload(struct kvm_vcpu *vcpu, unsigned long payload)
> > > +{
> > > +	/*
> > > +	 * The exception payload is defined as compatible with the 'pending
> > > +	 * debug exceptions' field in VMX, not the DR6 register. Clear bit 12
> > > +	 * (enabled breakpoint) in the payload, which is reserved MBZ in DR6.
> > > +	 */
> > > +	payload &= ~BIT(12);
> > > +
> > > +	/*
> > > +	 * The processor updates bits 3:0 according to the matched breakpoint
> > > +	 * conditions on every debug breakpoint or general-detect condition.
> > > +	 * Hardware will not clear any other bits in DR6. Clear bits 3:0 and set
> > > +	 * the bits requested in the exception payload.
> > > +	 */
> > > +	vcpu->arch.dr6 &= ~DR_TRAP_BITS;
> > > +	vcpu->arch.dr6 |= payload;
> > > +}
> > > +
> > >  static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> > >  {
> > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > > @@ -7308,6 +7327,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > >  	.set_nmi = svm_inject_nmi,
> > >  	.queue_exception = svm_queue_exception,
> > >  	.cancel_injection = svm_cancel_injection,
> > > +	.deliver_db_payload = svm_deliver_db_payload,
> > >  	.interrupt_allowed = svm_interrupt_allowed,
> > >  	.nmi_allowed = svm_nmi_allowed,
> > >  	.get_nmi_mask = svm_get_nmi_mask,
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index e3394c839dea..148696199c88 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1613,6 +1613,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
> > >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > >  	unsigned nr = vcpu->arch.exception.nr;
> > >  	bool has_error_code = vcpu->arch.exception.has_error_code;
> > > +	bool has_payload = vcpu->arch.exception.has_payload;
> > >  	u32 error_code = vcpu->arch.exception.error_code;
> > >  	u32 intr_info = nr | INTR_INFO_VALID_MASK;
> > >  
> > > @@ -1640,7 +1641,13 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
> > >  	} else
> > >  		intr_info |= INTR_TYPE_HARD_EXCEPTION;
> > >  
> > > -	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
> > > +	/*
> > > +	 * Debug-trap exceptions are injected into the guest via the 'pending
> > > +	 * debug exceptions' vmcs field and thus should not be injected into the
> > > +	 * guest using the general event injection mechanism.
> > > +	 */
> > > +	if (nr != DB_VECTOR || !has_payload)
> > > +		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
> > >  
> > >  	vmx_clear_hlt(vcpu);
> > >  }
> > > @@ -6398,6 +6405,16 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
> > >  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
> > >  }
> > >  
> > > +static void vmx_deliver_db_payload(struct kvm_vcpu *vcpu, unsigned long payload)
> > > +{
> > > +	/*
> > > +	 * Synthesized debug exceptions that have an associated payload must be
> > > +	 * traps, and thus the 'pending debug exceptions' field can be used to
> > > +	 * allow hardware to inject the event upon VM-entry.
> > > +	 */
> > 
> > I'm confused by this, probably because I don't understand what you mean by
> > "Synthesized debug exceptions".  E.g. code #DBs are fault-like and update
> > dr6.

Yeah, this comment could benefit from being cleaned up. By 'synthesized'
I meant to imply exceptions that we are going to inject resulting from
instruction emulation.

AFAIK, KVM only emulates single step #DBs during instruction emulation,
and as such we should never reach this with a software #DB (I tested
this in the kvm-unit-tests patch). I think that software #DBs should get
reinjected by handle_exception_nmi(), which manipulates DR6 and calls
kvm_queue_exception() (i.e. no payload).

Regardless, I need to expand this comment to ensure it is abundantly
clear what is happening.

Sean, given my above comments, do you still see any issues with this
change (beyond comment fix)?

Sorry I missed this in the first mail, thank you for bringing attention
to this.

> > 
> > > +	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, payload);
> > > +}
> > > +
> > >  static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> > >  {
> > >  	int i, nr_msrs;
> > > @@ -7821,6 +7838,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> > >  	.set_nmi = vmx_inject_nmi,
> > >  	.queue_exception = vmx_queue_exception,
> > >  	.cancel_injection = vmx_cancel_injection,
> > > +	.deliver_db_payload = vmx_deliver_db_payload,
> > >  	.interrupt_allowed = vmx_interrupt_allowed,
> > >  	.nmi_allowed = vmx_nmi_allowed,
> > >  	.get_nmi_mask = vmx_get_nmi_mask,
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index cf917139de6b..c14174c033e4 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -415,26 +415,7 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
> > >  
> > >  	switch (nr) {
> > >  	case DB_VECTOR:
> > > -		/*
> > > -		 * "Certain debug exceptions may clear bit 0-3.  The
> > > -		 * remaining contents of the DR6 register are never
> > > -		 * cleared by the processor".
> > > -		 */
> > > -		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
> > > -		/*
> > > -		 * DR6.RTM is set by all #DB exceptions that don't clear it.
> > > -		 */
> > > -		vcpu->arch.dr6 |= DR6_RTM;
> > > -		vcpu->arch.dr6 |= payload;
> > > -		/*
> > > -		 * Bit 16 should be set in the payload whenever the #DB
> > > -		 * exception should clear DR6.RTM. This makes the payload
> > > -		 * compatible with the pending debug exceptions under VMX.
> > > -		 * Though not currently documented in the SDM, this also
> > > -		 * makes the payload compatible with the exit qualification
> > > -		 * for #DB exceptions under VMX.
> > > -		 */
> > > -		vcpu->arch.dr6 ^= payload & DR6_RTM;
> > > +		kvm_x86_ops->deliver_db_payload(vcpu, payload);
> > >  		break;
> > >  	case PF_VECTOR:
> > >  		vcpu->arch.cr2 = payload;
> > > -- 
> > > 2.25.0.rc1.283.g88dfdc4193-goog
> > > 
