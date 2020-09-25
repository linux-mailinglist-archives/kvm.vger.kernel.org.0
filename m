Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8DA2793E9
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgIYWEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 18:04:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726576AbgIYWEx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 18:04:53 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601071491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsCTglPcEJCWqonBlngTDn2QZU1zRO8YnrPeV0NU/2o=;
        b=HGaYu/nGuuUhBk4MgaWEMgb8DSVlqp2WGaxs+TQMv36phPUBUgJWTsXl14EsefYoG5WQFX
        tVi5q+AS4dejrODGB/1ApgZ6yH03UfhJF9yK6gCxPKHBOV8+e7Ttks8CtumPJgtMnn0x+w
        gqAyj0pk1CpLvgIhoZ7AWGZ+7iGHP4U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-cN5q5_exPMGBtIkE7hldZw-1; Fri, 25 Sep 2020 18:04:40 -0400
X-MC-Unique: cN5q5_exPMGBtIkE7hldZw-1
Received: by mail-wm1-f72.google.com with SMTP id b20so139658wmj.1
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 15:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rsCTglPcEJCWqonBlngTDn2QZU1zRO8YnrPeV0NU/2o=;
        b=mnrgp8h1EBrVCz2h0oyMHw89XEWw6vqNNPIH6HW6GuvL7eCH77f9PYHx8rOAmezYO7
         RI8Xabfxb3r3Qe7TJ2clIDPKBP+dUW0V44GPNt5eMg1/RazuljxMiAFG7a/Mz8bcDeAR
         yClRCuwy/wkcvmn4PLqjkIhIQ9lYeFKcJzzynwCnvKwouWW8aTA2340+Hi0pHfNH3SL7
         hp4AAhoTgGMQ7wEokJpfn7a5Jw7stJx+RmbNLRzT2dvLvjaIcw1BwAH3zKNn47yXSEPn
         HGwZ+SlMUDoFfYZT21wcay2HGTijFaH4YLerxPr7fw962bkdXKadzN3bJ/VUFANqH0tR
         6wbQ==
X-Gm-Message-State: AOAM5327eA8Ha31lKqftFxE1FWesMTVBHplceEezw+dSOYvrjosia3Kl
        YZ6vLdtJ4lEVv4GnEfokOKxGALJPYyWbS0yYS6hDFjP813pux9J8oaRghdtQ7XygR3sFhTM4G+E
        dp8EQawfIteKR
X-Received: by 2002:adf:c44d:: with SMTP id a13mr6531950wrg.11.1601071479324;
        Fri, 25 Sep 2020 15:04:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4HGHGAjSu5siPnILL5rSlIRdGUutfl1v/dkb70yc637MqbrqkRY+9ZtBTRqTKfNhnY4UPDQ==
X-Received: by 2002:adf:c44d:: with SMTP id a13mr6531925wrg.11.1601071479046;
        Fri, 25 Sep 2020 15:04:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id t5sm1536915wrb.21.2020.09.25.15.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 15:04:37 -0700 (PDT)
Subject: Re: [PATCH v2 03/15] KVM: VMX: Rename "vmx_find_msr_index" to
 "vmx_find_loadstore_msr_slot"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
 <20200923180409.32255-4-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <86b26125-1f02-f3d7-2834-c8a1ed8aebf4@redhat.com>
Date:   Sat, 26 Sep 2020 00:04:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923180409.32255-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 20:03, Sean Christopherson wrote:
> Add "loadstore" to vmx_find_msr_index() to differentiate it from the so
> called shared MSRs helpers (which will soon be renamed), and replace
> "index" with "slot" to better convey that the helper returns slot in the
> array, not the MSR index (the value that gets stuffed into ECX).
> 
> No functional change intended.

"slot" is definitely better, I'll adjust SVM to use it too.

Paolo

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 16 ++++++++--------
>  arch/x86/kvm/vmx/vmx.c    | 10 +++++-----
>  arch/x86/kvm/vmx/vmx.h    |  2 +-
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f818a406302a..87e5d606582e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -938,11 +938,11 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
>  	 * VM-exit in L0, use the more accurate value.
>  	 */
>  	if (msr_index == MSR_IA32_TSC) {
> -		int index = vmx_find_msr_index(&vmx->msr_autostore.guest,
> -					       MSR_IA32_TSC);
> +		int i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore.guest,
> +						    MSR_IA32_TSC);
>  
> -		if (index >= 0) {
> -			u64 val = vmx->msr_autostore.guest.val[index].value;
> +		if (i >= 0) {
> +			u64 val = vmx->msr_autostore.guest.val[i].value;
>  
>  			*data = kvm_read_l1_tsc(vcpu, val);
>  			return true;
> @@ -1031,12 +1031,12 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
>  	bool in_vmcs12_store_list;
> -	int msr_autostore_index;
> +	int msr_autostore_slot;
>  	bool in_autostore_list;
>  	int last;
>  
> -	msr_autostore_index = vmx_find_msr_index(autostore, msr_index);
> -	in_autostore_list = msr_autostore_index >= 0;
> +	msr_autostore_slot = vmx_find_loadstore_msr_slot(autostore, msr_index);
> +	in_autostore_list = msr_autostore_slot >= 0;
>  	in_vmcs12_store_list = nested_msr_store_list_has_msr(vcpu, msr_index);
>  
>  	if (in_vmcs12_store_list && !in_autostore_list) {
> @@ -1057,7 +1057,7 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
>  		autostore->val[last].index = msr_index;
>  	} else if (!in_vmcs12_store_list && in_autostore_list) {
>  		last = --autostore->nr;
> -		autostore->val[msr_autostore_index] = autostore->val[last];
> +		autostore->val[msr_autostore_slot] = autostore->val[last];
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e99f3bbfa6e9..35291fd90ca0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -824,7 +824,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  	vm_exit_controls_clearbit(vmx, exit);
>  }
>  
> -int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
> +int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr)
>  {
>  	unsigned int i;
>  
> @@ -858,7 +858,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
>  		}
>  		break;
>  	}
> -	i = vmx_find_msr_index(&m->guest, msr);
> +	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
>  	if (i < 0)
>  		goto skip_guest;
>  	--m->guest.nr;
> @@ -866,7 +866,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
>  
>  skip_guest:
> -	i = vmx_find_msr_index(&m->host, msr);
> +	i = vmx_find_loadstore_msr_slot(&m->host, msr);
>  	if (i < 0)
>  		return;
>  
> @@ -925,9 +925,9 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
>  	}
>  
> -	i = vmx_find_msr_index(&m->guest, msr);
> +	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
>  	if (!entry_only)
> -		j = vmx_find_msr_index(&m->host, msr);
> +		j = vmx_find_loadstore_msr_slot(&m->host, msr);
>  
>  	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
>  	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9a418c274880..26887082118d 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -353,7 +353,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
>  void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
>  void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
> -int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
> +int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
>  void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
>  
>  #define POSTED_INTR_ON  0
> 

