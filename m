Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3431844B8
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 11:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgCMKUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 06:20:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39098 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726414AbgCMKUu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 06:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584094848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p8p0yU+2dtK6r1zkXXvBWL0DAYf00F48i3c6W+/DfDA=;
        b=f93lXXCxqMcVWXcM8uFA/fOGcluwnRfcoNQcq0LwGZwB6pThb2Kr4wU04Bjk0v6dXNH2q8
        Z4IjSptHn9P9vajpKHFXjc2wuVnQVbJDGmg5p7BVh02aIXEafNjFNHgJSgkCBy794caPjz
        K45khI23G5ZsfT44HLR+3HMiXpnL37k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-Jek3W0FXNv-BboceZ2BhtQ-1; Fri, 13 Mar 2020 06:20:47 -0400
X-MC-Unique: Jek3W0FXNv-BboceZ2BhtQ-1
Received: by mail-wr1-f69.google.com with SMTP id 31so4087404wrq.0
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 03:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=p8p0yU+2dtK6r1zkXXvBWL0DAYf00F48i3c6W+/DfDA=;
        b=evJLxogrq1yObnrU4mEEXq8e6lyZcSJsYzzrGsRiaw3ttP9d9vL8me5tNBm7U8yYAy
         JvPILtfcJlrLh+z4MvwIobxmQyXU8pJyyEJmRarMmGS8rcNX672EKU7UBQMcwRFTwoyZ
         ZIFBBnQYbkCZFWvbSmvztV06UIjOi/CyyIQVWnRRt2iiVqxCc/oW6rsShIBsYm3sgVEW
         082Tc9xZ9A4gm0OTYbPmJkIHzwKxXJsJFK05r/o+y3iIgnJWoepXLUu42kw/Vccdxq5f
         G/Mqd7Avx+P3hN7eWAn6eaJ8hcM3mnvGiH5pa3awV725//+4/c8LnHoUDtlru2awlSei
         1TDw==
X-Gm-Message-State: ANhLgQ3078ptIxhd9s22SXSKcQ14IF1NC8dvaDc9MLknv/Lk1IKp8PFU
        KVS5/Uf1JU3904L9YUHATzkaZ9oq3Ye/eMQ/vsQmKJgxc/SjX8rQVcZQJ2OyGcpzEXYyVXyLwZ9
        OEW6AUGLDO1ek
X-Received: by 2002:a7b:c458:: with SMTP id l24mr9972981wmi.120.1584094845565;
        Fri, 13 Mar 2020 03:20:45 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu4okEOyFmr9Ae+lSmbX/xV4gnPgkDtiLRpMgrFE8NAiB8lzXzPaNtVJsV1W672x5xOLNPu8w==
X-Received: by 2002:a7b:c458:: with SMTP id l24mr9972964wmi.120.1584094845318;
        Fri, 13 Mar 2020 03:20:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b187sm233348wmc.14.2020.03.13.03.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 03:20:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Print symbolic names of VMX VM-Exit flags in traces
In-Reply-To: <20200312181535.23797-1-sean.j.christopherson@intel.com>
References: <20200312181535.23797-1-sean.j.christopherson@intel.com>
Date:   Fri, 13 Mar 2020 11:20:43 +0100
Message-ID: <87sgicpnd0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use __print_flags() to display the names of VMX flags in VM-Exit traces
> and strip the flags when printing the basic exit reason, e.g. so that a
> failed VM-Entry due to invalid guest state gets recorded as
> "INVALID_STATE FAILED_VMENTRY" instead of "0x80000021".
>
> Opportunstically fix misaligned variables in the kvm_exit and
> kvm_nested_vmexit_inject tracepoints.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/uapi/asm/vmx.h |  3 +++
>  arch/x86/kvm/trace.h            | 32 +++++++++++++++++---------------
>  2 files changed, 20 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index e95b72ec19bc..b8ff9e8ac0d5 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -150,6 +150,9 @@
>  	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
>  	{ EXIT_REASON_TPAUSE,                "TPAUSE" }
>  
> +#define VMX_EXIT_REASON_FLAGS \
> +	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
> +
>  #define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
>  #define VMX_ABORT_LOAD_HOST_PDPTE_FAIL       2
>  #define VMX_ABORT_LOAD_HOST_MSR_FAIL         4
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index f5b8814d9f83..3cfc8d97b158 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -219,6 +219,14 @@ TRACE_EVENT(kvm_apic,
>  #define KVM_ISA_VMX   1
>  #define KVM_ISA_SVM   2
>  
> +#define kvm_print_exit_reason(exit_reason, isa)				\
> +	(isa == KVM_ISA_VMX) ?						\
> +	__print_symbolic(exit_reason & 0xffff, VMX_EXIT_REASONS) :	\
> +	__print_symbolic(exit_reason, SVM_EXIT_REASONS),		\
> +	(isa == KVM_ISA_VMX && exit_reason & ~0xffff) ? " " : "",	\
> +	(isa == KVM_ISA_VMX) ?						\
> +	__print_flags(exit_reason & ~0xffff, " ", VMX_EXIT_REASON_FLAGS) : ""
> +
>  /*
>   * Tracepoint for kvm guest exit:
>   */
> @@ -244,12 +252,10 @@ TRACE_EVENT(kvm_exit,
>  					   &__entry->info2);
>  	),
>  
> -	TP_printk("vcpu %u reason %s rip 0x%lx info %llx %llx",
> +	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info %llx %llx",
>  		  __entry->vcpu_id,
> -		 (__entry->isa == KVM_ISA_VMX) ?
> -		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
> -		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),
> -		 __entry->guest_rip, __entry->info1, __entry->info2)
> +		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa),
> +		  __entry->guest_rip, __entry->info1, __entry->info2)
>  );
>  
>  /*
> @@ -582,12 +588,10 @@ TRACE_EVENT(kvm_nested_vmexit,
>  		__entry->exit_int_info_err	= exit_int_info_err;
>  		__entry->isa			= isa;

Unrelated to your patch, just a random thought: I *think* it would be
possible to avoid passing 'isa' to these tracepoints and figure out
which module is embedding them instead (THIS_MODULE/KBUILD_MODNAME/...
magic or something like that) but it may not worth the effort.

>  	),
> -	TP_printk("rip: 0x%016llx reason: %s ext_inf1: 0x%016llx "
> +	TP_printk("rip: 0x%016llx reason: %s%s%s ext_inf1: 0x%016llx "
>  		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
>  		  __entry->rip,
> -		 (__entry->isa == KVM_ISA_VMX) ?
> -		 __print_symbolic(__entry->exit_code, VMX_EXIT_REASONS) :
> -		 __print_symbolic(__entry->exit_code, SVM_EXIT_REASONS),
> +		  kvm_print_exit_reason(__entry->exit_code, __entry->isa),
>  		  __entry->exit_info1, __entry->exit_info2,
>  		  __entry->exit_int_info, __entry->exit_int_info_err)
>  );
> @@ -620,13 +624,11 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
>  		__entry->isa			= isa;
>  	),
>  
> -	TP_printk("reason: %s ext_inf1: 0x%016llx "
> +	TP_printk("reason: %s%s%s ext_inf1: 0x%016llx "
>  		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
> -		 (__entry->isa == KVM_ISA_VMX) ?
> -		 __print_symbolic(__entry->exit_code, VMX_EXIT_REASONS) :
> -		 __print_symbolic(__entry->exit_code, SVM_EXIT_REASONS),
> -		__entry->exit_info1, __entry->exit_info2,
> -		__entry->exit_int_info, __entry->exit_int_info_err)
> +		  kvm_print_exit_reason(__entry->exit_code, __entry->isa),
> +		  __entry->exit_info1, __entry->exit_info2,
> +		  __entry->exit_int_info, __entry->exit_int_info_err)
>  );
>  
>  /*

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

