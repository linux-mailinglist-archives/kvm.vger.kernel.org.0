Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4365D226C71
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGTQw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 12:52:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38213 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728495AbgGTQwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 12:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595263942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1+GTW6bUcVq9hOEzQOGLugjDBW3sKVqwUxpZJhBAW9g=;
        b=dgQSfwudhC2rC0OrqXE3e6HHZw4rhKu9aXehw1d/ku80sD8hkSURbdXp6HvEmUMt8JCA6k
        aAPeJu0wG4YCRfASN9CF9eBIxhJMyFIfOqQgh/4ZnMA9Rqf1/MDaIJyFhAzRj6I9oAsTHU
        /sek5jnVtQt0hkrVVpMlOrrhMXnKbK4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-oeVuiqjwNZSboxc1kzZvzA-1; Mon, 20 Jul 2020 12:52:19 -0400
X-MC-Unique: oeVuiqjwNZSboxc1kzZvzA-1
Received: by mail-wm1-f70.google.com with SMTP id g6so56267wmk.4
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 09:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1+GTW6bUcVq9hOEzQOGLugjDBW3sKVqwUxpZJhBAW9g=;
        b=PM2+tCI2Ul+h/czMSah+JGceva8L1jRA8eYL/pkDoTiqhpx6y0wfpDvmjDEZcgvkZQ
         vTJG45v4RjkrUgzlXwQp7/2qZESHT9u1xuGMQyuUJSyjncj6zKqYeHvFM93aK1LwbiMJ
         BVH8lR6s/FH1H1P7zuFNnLztD1fCqPzp8vzMsq4mCcXLT8Nj0s+Dq+QhKkxBAX9RN3e+
         TVvoyM3pHLtJ7dQ3W27J5q1u7UhqgEPpYdgAYjFSySLriX6xSMKRW9bspo17btkR1dnx
         SZE2YBIgllYJnRDPmdwKNBtkVnuLK45C7MzOHnQ0lIN8dMwlcbRS3Z9HfwkjFy3bfjZ5
         RCug==
X-Gm-Message-State: AOAM531yKDsSLsBq/EfogHrXW/8AcVvKFzDT/J/isUA0caeXu0O15TEM
        e1FUZVdupzg/qMBusFXOM+yNJJPVApmJn6F4smleB+LQTxbhskd82OWf4G1FrLAT0zhDAXEMTap
        6mOZewRcqe6IN
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr253062wmc.154.1595263937943;
        Mon, 20 Jul 2020 09:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxABkQsaNC6uhHjD2qXLGgxcmAgBJje062qg/eXZVT4/eyQq3RRhVHJaDFgP8d/p0TurMOOuA==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr253040wmc.154.1595263937551;
        Mon, 20 Jul 2020 09:52:17 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h11sm10910239wrb.68.2020.07.20.09.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 09:52:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/7] KVM: x86: Use common definition for kvm_nested_vmexit tracepoint
In-Reply-To: <20200718063854.16017-7-sean.j.christopherson@intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com> <20200718063854.16017-7-sean.j.christopherson@intel.com>
Date:   Mon, 20 Jul 2020 18:52:15 +0200
Message-ID: <87365mqgcg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use the newly introduced TRACE_EVENT_KVM_EXIT to define the guts of
> kvm_nested_vmexit so that it captures and prints the same information as
> with kvm_exit.  This has the bonus side effect of fixing the interrupt
> info and error code printing for the case where they're invalid, e.g. if
> the exit was a failed VM-Entry.  This also sets the stage for retrieving
> EXIT_QUALIFICATION and VM_EXIT_INTR_INFO in nested_vmx_reflect_vmexit()
> if and only if the VM-Exit is being routed to L1.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm/svm.c    |  7 +------
>  arch/x86/kvm/trace.h      | 34 +---------------------------------
>  arch/x86/kvm/vmx/nested.c |  5 +----
>  3 files changed, 3 insertions(+), 43 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8ab3413094500..133581c5b0dc0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2950,12 +2950,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	if (is_guest_mode(vcpu)) {
>  		int vmexit;
>  
> -		trace_kvm_nested_vmexit(vcpu, exit_code,
> -					svm->vmcb->control.exit_info_1,
> -					svm->vmcb->control.exit_info_2,
> -					svm->vmcb->control.exit_int_info,
> -					svm->vmcb->control.exit_int_info_err,
> -					KVM_ISA_SVM);
> +		trace_kvm_nested_vmexit(exit_code, vcpu, KVM_ISA_SVM);
>  
>  		vmexit = nested_svm_exit_special(svm);
>  
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 6cb75ba494fcd..e29576985e03a 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -579,39 +579,7 @@ TRACE_EVENT(kvm_nested_intercepts,
>  /*
>   * Tracepoint for #VMEXIT while nested
>   */
> -TRACE_EVENT(kvm_nested_vmexit,
> -	    TP_PROTO(struct kvm_vcpu *vcpu, __u32 exit_code,
> -		     __u64 exit_info1, __u64 exit_info2,
> -		     __u32 exit_int_info, __u32 exit_int_info_err, __u32 isa),
> -	    TP_ARGS(vcpu, exit_code, exit_info1, exit_info2,
> -		    exit_int_info, exit_int_info_err, isa),
> -
> -	TP_STRUCT__entry(
> -		__field(	__u64,		rip			)
> -		__field(	__u32,		exit_code		)
> -		__field(	__u64,		exit_info1		)
> -		__field(	__u64,		exit_info2		)
> -		__field(	__u32,		exit_int_info		)
> -		__field(	__u32,		exit_int_info_err	)
> -		__field(	__u32,		isa			)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->rip			= kvm_rip_read(vcpu);
> -		__entry->exit_code		= exit_code;
> -		__entry->exit_info1		= exit_info1;
> -		__entry->exit_info2		= exit_info2;
> -		__entry->exit_int_info		= exit_int_info;
> -		__entry->exit_int_info_err	= exit_int_info_err;
> -		__entry->isa			= isa;
> -	),
> -	TP_printk("rip: 0x%016llx reason: %s%s%s ext_inf1: 0x%016llx "
> -		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
> -		  __entry->rip,
> -		  kvm_print_exit_reason(__entry->exit_code, __entry->isa),
> -		  __entry->exit_info1, __entry->exit_info2,
> -		  __entry->exit_int_info, __entry->exit_int_info_err)
> -);
> +TRACE_EVENT_KVM_EXIT(kvm_nested_vmexit);
>  
>  /*
>   * Tracepoint for #VMEXIT reinjected to the guest
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fc70644b916ca..f437d99f4db09 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5912,10 +5912,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
>  	exit_intr_info = vmx_get_intr_info(vcpu);
>  	exit_qual = vmx_get_exit_qual(vcpu);
>  
> -	trace_kvm_nested_vmexit(vcpu, exit_reason, exit_qual,
> -				vmx->idt_vectoring_info, exit_intr_info,
> -				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
> -				KVM_ISA_VMX);
> +	trace_kvm_nested_vmexit(exit_reason, vcpu, KVM_ISA_VMX);
>  
>  	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
>  	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))

With so many lines removed I'm almost in love with the patch! However,
when testing on SVM (unrelated?) my trace log looks a bit ugly:

           <...>-315119 [010]  3733.092646: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000200000006 info2 0x0000000000641000 intr_info 0x00000000 error_code 0x00000000
           <...>-315119 [010]  3733.092655: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000100000014 info2 0x0000000000400000 intr_info 0x00000000 error_code 0x00000000

...

but after staring at this for some time I still don't see where this
comes from :-( ... but reverting this commit helps:

 qemu-system-x86-9928  [022]   379.260656: kvm_nested_vmexit:    rip 400433 reason EXIT_NPF info1 200000006 info2 641000 int_info 0 int_info_err 0
 qemu-system-x86-9928  [022]   379.260666: kvm_nested_vmexit:    rip 400433 reason EXIT_NPF info1 100000014 info2 400000 int_info 0 int_info_err 0

-- 
Vitaly

