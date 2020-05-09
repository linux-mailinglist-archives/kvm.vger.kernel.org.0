Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195341CC182
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 14:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEIMzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 08:55:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40451 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728045AbgEIMzp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 08:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589028943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jNwS/pZRyLqFQzu/O1yKyJjzCIHSPwgAChIA0OqMfxE=;
        b=B8eGPtvnuKXGh7xsAMKxcuP0Tkx6Ej3c2lVye1J/UtJgIf4ZA7EiLnDir0n3GOxLWSwYm8
        TopyAXyYd1kZWcqdXZTMf5qaVSTmLK9H0kk4ZXd+Kn8y+No88u+zzDM2ibJhez9oe1SeX4
        PgLMxA+crN842619pSZqh51zi24fW7s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-ju0ty2uqPeKsnBURJ26AWw-1; Sat, 09 May 2020 08:55:41 -0400
X-MC-Unique: ju0ty2uqPeKsnBURJ26AWw-1
Received: by mail-wr1-f70.google.com with SMTP id z5so2334217wrt.17
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 05:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jNwS/pZRyLqFQzu/O1yKyJjzCIHSPwgAChIA0OqMfxE=;
        b=nM5iY3osuMgG2PCRFLSD1ujCEULOQcNEF+MUmyYIq+k3hxDwvqcS7AthwwX/ki++vH
         b5K36vn/HLi16OSOwh4/IiI/OJFyLxpvhyOVJb3ju2kZd3tqxhOGTjkLIDt5fzFip7hT
         pLTmOozuftfD7nGh+RvKB7NEfpNoa5JH04YziaqZJejOa+x4Ol7kMpEVidSWo8J6KS1+
         xnQA4MHOSu5QwUBQ2bgeSK1/U7ORpVqP6GEjVk2YXKcPyM0TpjcCE6OjbAkJ8Zpo2rUP
         guWsQdYCbdGX2o61FbARnJeza2A+WQVt6dAqhHvHYr1ymB0JHG9SJb+IP/lEXSasZ0/K
         SBcg==
X-Gm-Message-State: AGi0Puavf1SbMpFYfAtFBetWyO1UWAMLPN/xV7C8SOhlOHyEG/8LmEBi
        hWL/Fkpb0AmlatDNFgMAiHJVQ3Sj5GqGdyEaWb1GA44iGJcvlpLULOcTfmE1iziYyHThomSOUOV
        kbQMhv+rimLyS
X-Received: by 2002:a5d:444c:: with SMTP id x12mr4839926wrr.406.1589028939946;
        Sat, 09 May 2020 05:55:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypIK6UspDWv/KZ+yzDXQxumiQ0dnmR9CUeHFxNvecAUMDtZcuoEfRrCNBmeDTuFkiLiWkl5/4w==
X-Received: by 2002:a5d:444c:: with SMTP id x12mr4839912wrr.406.1589028939715;
        Sat, 09 May 2020 05:55:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id s17sm17354919wmc.48.2020.05.09.05.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 05:55:39 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Print symbolic names of VMX VM-Exit flags
 in traces
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200508235348.19427-1-sean.j.christopherson@intel.com>
 <20200508235348.19427-3-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fdc4d7be-f458-d7c3-eb0e-8a36637c41d1@redhat.com>
Date:   Sat, 9 May 2020 14:55:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508235348.19427-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/20 01:53, Sean Christopherson wrote:
> Use __print_flags() to display the names of VMX flags in VM-Exit traces
> and strip the flags when printing the basic exit reason, e.g. so that a
> failed VM-Entry due to invalid guest state gets recorded as
> "INVALID_STATE FAILED_VMENTRY" instead of "0x80000021".
> 
> Opportunstically fix misaligned variables in the kvm_exit and
> kvm_nested_vmexit_inject tracepoints.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/uapi/asm/vmx.h |  3 +++
>  arch/x86/kvm/trace.h            | 32 +++++++++++++++++---------------
>  2 files changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index e95b72ec19bc0..b8ff9e8ac0d51 100644
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
> index 249062f24b940..54a10c98d7466 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -225,6 +225,14 @@ TRACE_EVENT(kvm_apic,
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
> @@ -250,12 +258,10 @@ TRACE_EVENT(kvm_exit,
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
> @@ -588,12 +594,10 @@ TRACE_EVENT(kvm_nested_vmexit,
>  		__entry->exit_int_info_err	= exit_int_info_err;
>  		__entry->isa			= isa;
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
> @@ -626,13 +630,11 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
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
> 

Queued, thanks.

Paolo

