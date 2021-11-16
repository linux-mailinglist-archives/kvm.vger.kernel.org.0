Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681634538B7
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 18:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbhKPRpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 12:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbhKPRpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 12:45:50 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1697AC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:42:53 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x15so91417079edv.1
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0uyxbq3Zi8iuCDmmqLxBHkIEANvSCPO6zZ1ctHGsS64=;
        b=iSUnLpmQFD7KtlemeYJqeXhDf1eE+FexdJ9iYWURQgZ3cEZ9waAzNVfhsCX4So5Oym
         BA2WPCQcoCz1ab655sj/hb/h+zNZuSTmbSw3a9kfMvk4im6a2ilsAUrW848DPd21xZtG
         Th+d0y6/F28B6kDZr/JI13ltKs8TFN5PQnHJ/8GtpNcmYDQ88ZhK1xCwaJ7PnjvUz+Ta
         8PJs6GXboBdYZDu956MEIibN+kIJweZ7S2ug+Z0xUzIkFMq4BVw+xOaaG28YnkA9dQWl
         9YMf+BJOgBkxfYM1IpqThLpV3PUaTQ0AjPdS0c86RlPrDh3bSwC1mLI/akg4AzlVCf9s
         G0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0uyxbq3Zi8iuCDmmqLxBHkIEANvSCPO6zZ1ctHGsS64=;
        b=ei0YcDkAK9pfjiKZeLg7/fuypFJMhomDk0BWwOb8ti9IyPSJV1AZohB5RftvstGIC6
         eNZDv6EpWT6O+5VV27yKGP63tG2Vi0TV9LMuKBX28BV5Md2BA7EdK1khylhW29momZco
         eSLUsVQbY2AKAgxWFWqZPLiwTgN9S0S6da2hpMKpEQh6fsIg33+t6n0lv+0tYv4K+4ac
         q9VsLr/GxMmOFjiA/vzay1n5QO6kinYc1pHPBC+URc8vZN/g0frrQFf8xze7zwdWIIjk
         hzLrWyILlyu2UhUXgveU4JKuwNBt+69JA4IZ2NDMUrAcZcleECv8UVrPhwe1diNyfCuP
         TmKA==
X-Gm-Message-State: AOAM533MJQSEe/UMDUsbyy73bQoHZmj7GXjuDLmPbhy3CPS43mIVv625
        +FSxu8EJBXyNM+WwZeOB/ac=
X-Google-Smtp-Source: ABdhPJzLzHO84VGGoooNAny8D3YKoqGoxjKg4P7oRtkCQKuFptzXYjZ+f5IP3hkSawkvRbxbua80Og==
X-Received: by 2002:a17:906:1697:: with SMTP id s23mr12538310ejd.60.1637084571545;
        Tue, 16 Nov 2021 09:42:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id he14sm8957863ejc.55.2021.11.16.09.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 09:42:51 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <1b8af2ad-17f8-8c22-d0d5-35332e919104@gnu.org>
Date:   Tue, 16 Nov 2021 18:42:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
 <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
 <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
 <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
 <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
 <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
 <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
 <YZLmapmzs7sLpu/L@google.com>
 <57d599584ace8ab410b9b14569f434028e2cf642.camel@infradead.org>
 <94bb55e117287e07ba74de2034800da5ba4398d2.camel@infradead.org>
 <04bf7e8b-d0d7-0eb6-4d15-bfe4999f42f8@redhat.com>
 <19bf769ef623e0392016975b12133d9a3be210b3.camel@infradead.org>
 <ad0648ac-b72a-1692-c608-b37109b3d250@redhat.com>
 <126b7fcbfa78988b0fceb35f86588bd3d5aae837.camel@infradead.org>
 <02cdb0b0-c7b0-34c5-63c1-aec0e0b14cf7@redhat.com>
 <9733f477bada4cc311078be529b7118f1dec25bb.camel@infradead.org>
From:   Paolo Bonzini <bonzini@gnu.org>
In-Reply-To: <9733f477bada4cc311078be529b7118f1dec25bb.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 17:06, David Woodhouse wrote:
> On Tue, 2021-11-16 at 16:49 +0100, Paolo Bonzini wrote:
>> On 11/16/21 16:09, David Woodhouse wrote:
>>> On Tue, 2021-11-16 at 15:57 +0100, Paolo Bonzini wrote:
>>>> This should not be needed, should it?  As long as the gfn-to-pfn
>>>> cache's vcpu field is handled properly, the request will just cause
>>>> the vCPU not to enter.
>>>
>>> If the MMU mappings never change, the request never happens. But the
>>> memslots *can* change, so it does need to be revalidated each time
>>> through I think?
>>
>> That needs to be done on KVM_SET_USER_MEMORY_REGION, using the same
>> request (or even the same list walking code) as the MMU notifiers.
> 
> Hm....  kvm_arch_memslots_updated() is already kicking every vCPU after
> the update, and although that was asynchronous it was actually OK
> because unlike in the MMU notifier case, that page wasn't actually
> going away — and if that HVA *did* subsequently go away, our HVA-based
> notifier check would still catch that and kill it synchronously.

Right, so it only needs to change the kvm_vcpu_kick into a 
kvm_make_all_cpus_request without KVM_WAIT.

>>> Hm, in my head that was never going to *change* for a given gpc; it
>>> *belongs* to that vCPU for ever (and was even part of vmx->nested. for
>>> that vCPU, to replace e.g. vmx->nested.pi_desc_map).
>>
>> Ah okay, I thought it would be set in nested vmentry and cleared in
>> nested vmexit.
> 
> I don't think it needs to be proactively cleared; we just don't
> *refresh* it until we need it again.

True, but if it's cleared the vCPU won't be kicked, which is nice.

> If we *know* the GPA and size haven't changed, and if we know that
> gpc->valid becoming false would have been handled differently, then we
> could optimise that whole thing away quite effectively to a single
> check on ->generations?

I wonder if we need a per-gpc memslot generation...  Can it be global?

> This one actually compiles. Not sure we have any test cases that will
> actually exercise it though, do we?

I'll try to spend some time writing testcases.

> +		read_lock(&gpc->lock);
> +		if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE)) {
> +			read_unlock(&gpc->lock);
>   			goto mmio_needed;
> +		}
> +
> +		vapic_page = gpc->khva;

If we know this gpc is of the synchronous kind, I think we can skip the 
read_lock/read_unlock here?!?

>   		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
>   			vapic_page, &max_irr);
> @@ -3749,6 +3783,7 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
>   			status |= (u8)max_irr;
>   			vmcs_write16(GUEST_INTR_STATUS, status);
>   		}
> +		read_unlock(&gpc->lock);
>   	}
>   
>   	nested_mark_vmcs12_pages_dirty(vcpu);
> @@ -4569,7 +4604,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>   		kvm_release_page_clean(vmx->nested.apic_access_page);
>   		vmx->nested.apic_access_page = NULL;
>   	}
> -	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
> +	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vmx->nested.virtual_apic_cache);
>   	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
>   	vmx->nested.pi_desc = NULL;
>   
> @@ -6744,4 +6779,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
>   	.write_log_dirty = nested_vmx_write_pml_buffer,
>   	.enable_evmcs = nested_enable_evmcs,
>   	.get_evmcs_version = nested_get_evmcs_version,
> +	.check_guest_maps = nested_vmx_check_guest_maps,
>   };
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ba66c171d951..6c61faef86d3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3839,19 +3839,23 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>   static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	void *vapic_page;
> +	struct gfn_to_pfn_cache *gpc = &vmx->nested.virtual_apic_cache;
>   	u32 vppr;
>   	int rvi;
>   
>   	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
>   		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
> -		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn))
> +		WARN_ON_ONCE(gpc->gpa == GPA_INVALID))
>   		return false;
>   
>   	rvi = vmx_get_rvi();
>   
> -	vapic_page = vmx->nested.virtual_apic_map.hva;
> -	vppr = *((u32 *)(vapic_page + APIC_PROCPRI));
> +	read_lock(&gpc->lock);
> +	if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE))
> +		vppr = *((u32 *)(gpc->khva + APIC_PROCPRI));
> +	else
> +		vppr = 0xff;
> +	read_unlock(&gpc->lock);
>   
>   	return ((rvi & 0xf0) > (vppr & 0xf0));
>   }
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 4df2ac24ffc1..8364e7fc92a0 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -195,7 +195,7 @@ struct nested_vmx {
>   	 * pointers, so we must keep them pinned while L2 runs.
>   	 */
>   	struct page *apic_access_page;
> -	struct kvm_host_map virtual_apic_map;
> +	struct gfn_to_pfn_cache virtual_apic_cache;
>   	struct kvm_host_map pi_desc_map;
>   
>   	struct kvm_host_map msr_bitmap_map;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0a689bb62e9e..a879e4d08758 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9735,6 +9735,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   
>   		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
>   			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
> +		if (kvm_check_request(KVM_REQ_GPC_INVALIDATE, vcpu))
> +			; /* Nothing to do. It just wanted to wake us */
>   	}
>   
>   	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> @@ -9781,6 +9783,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	local_irq_disable();
>   	vcpu->mode = IN_GUEST_MODE;
>   
> +	/*
> +	 * If the guest requires direct access to mapped L1 pages, check
> +	 * the caches are valid. Will raise KVM_REQ_GET_NESTED_STATE_PAGES
> +	 * to go and revalidate them, if necessary.
> +	 */
> +	if (is_guest_mode(vcpu) && kvm_x86_ops.nested_ops->check_guest_maps)
> +		kvm_x86_ops.nested_ops->check_guest_maps(vcpu);
> +
>   	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>   
>   	/*
> 

