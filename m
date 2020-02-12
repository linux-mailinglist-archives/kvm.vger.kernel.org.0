Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F47315A87B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgBLMA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:00:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35324 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728049AbgBLMA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581508857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t5fKOSPBE8npqjvC4E7Sos0okp9RyOPPOUkKe29Zb9Y=;
        b=POWT5UhbojxvI1QfzmT+JuF7Uuqn9s08crSwpPGmCmbrSXnRbFHx2pwhJzoH+MGvDjr0qJ
        CHKHTHS8I82RDgUbmg5/ZK9zBg4gEMII6esbadD3u+zAxNMx8WovuslmHpWeteBhQasKCj
        +rwRdeamlYqBt3oR2cTxTBoMmslz2y0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Rjs73vc8Os2kUSxUACHrNw-1; Wed, 12 Feb 2020 07:00:56 -0500
X-MC-Unique: Rjs73vc8Os2kUSxUACHrNw-1
Received: by mail-wr1-f71.google.com with SMTP id a12so712341wrn.19
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 04:00:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t5fKOSPBE8npqjvC4E7Sos0okp9RyOPPOUkKe29Zb9Y=;
        b=B3wXdAIhpyK0CC0DeyTFMOTxSmTiYBTKqHRmM9v9C+WqGoq4hthGcBulMjpgFn3Q0Y
         36EW/6ysQR5RZWAQ8WKXYWJoccdmiZd6gL2pTWCqzXYPb8KSj7XAVoHVzOUOToJuXEfI
         Yigt2EorAyyA/YjN1Le0Z51okAxbdJrEz7H0I56O30CqPn7qLaUL2KuTzh3ybI+Lk5by
         kcJrBZ93RpOEeLlgktm4rKt+zExXuB1/Esrf88UF4q7Eo4CDJGV03mRofc2OKuAF9bAu
         fhe4HwNVcK582N9aQn5+dPoaQt00SJU/c/K+B31jmdsQzUTaHLu1I+GCwCQNI0h6dbEn
         Ygyw==
X-Gm-Message-State: APjAAAWoWVBHjckJUhldwaro8wGXoEiZV0LWEMtcznCJeBKxo5FOqLfW
        IFazBcOzHecmJukhCHmY2XZIzeJxO/Jxn4UPzyVS/KXjsavYv+W9k/saVpWzeri+etrPBtBm746
        BMlHTrxYIs8Fj
X-Received: by 2002:adf:b352:: with SMTP id k18mr14637611wrd.242.1581508854959;
        Wed, 12 Feb 2020 04:00:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqKUKTK/LXZj659FKqEXgIuqLsOuUOLcQ0XyLeuBvUfrvCi4p4abJmqdOzVfUyB5pdBrR/lg==
X-Received: by 2002:adf:b352:: with SMTP id k18mr14637580wrd.242.1581508854612;
        Wed, 12 Feb 2020 04:00:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id u4sm370285wrt.37.2020.02.12.04.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 04:00:53 -0800 (PST)
Subject: Re: [PATCH v2 6/7] KVM: x86/mmu: Rename kvm_mmu->get_cr3() to
 ->get_guest_cr3_or_eptp()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
 <20200207173747.6243-7-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1424348b-7f09-513a-960b-6d15ac3a9ae4@redhat.com>
Date:   Wed, 12 Feb 2020 13:00:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207173747.6243-7-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 18:37, Sean Christopherson wrote:
> Rename kvm_mmu->get_cr3() to call out that it is retrieving a guest
> value, as opposed to kvm_mmu->set_cr3(), which sets a host value, and to
> note that it will return L1's EPTP when nested EPT is in use.  Hopefully
> the new name will also make it more obvious that L1's nested_cr3 is
> returned in SVM's nested NPT case.
> 
> No functional change intended.

Should we call it "get_pgd", since that is how Linux calls the top-level
directory?  I always get confused by PUD/PMD, but as long as we only
keep one /p.d/ moniker it should be fine.

Paolo

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 24 ++++++++++++------------
>  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>  arch/x86/kvm/svm.c              | 10 +++++-----
>  arch/x86/kvm/vmx/nested.c       |  8 ++++----
>  arch/x86/kvm/x86.c              |  2 +-
>  6 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4dffbc10d3f8..d3d69ad2e969 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -383,7 +383,7 @@ struct kvm_mmu_root_info {
>   */
>  struct kvm_mmu {
>  	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
> -	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
> +	unsigned long (*get_guest_cr3_or_eptp)(struct kvm_vcpu *vcpu);
>  	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
>  	int (*page_fault)(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 err,
>  			  bool prefault);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 70f67bcab7db..13df4b4a5649 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3731,7 +3731,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
>  	} else
>  		BUG();
> -	vcpu->arch.mmu->root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
> +	vcpu->arch.mmu->root_cr3 = vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu);
>  
>  	return 0;
>  }
> @@ -3743,7 +3743,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	gfn_t root_gfn, root_cr3;
>  	int i;
>  
> -	root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
> +	root_cr3 = vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu);
>  	root_gfn = root_cr3 >> PAGE_SHIFT;
>  
>  	if (mmu_check_root(vcpu, root_gfn))
> @@ -4080,7 +4080,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>  	arch.gfn = gfn;
>  	arch.direct_map = vcpu->arch.mmu->direct_map;
> -	arch.cr3 = vcpu->arch.mmu->get_cr3(vcpu);
> +	arch.cr3 = vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu);
>  
>  	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
>  				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
> @@ -4932,7 +4932,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
>  	context->direct_map = true;
>  	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
> -	context->get_cr3 = get_cr3;
> +	context->get_guest_cr3_or_eptp = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
>  
> @@ -5080,10 +5080,10 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
>  	struct kvm_mmu *context = vcpu->arch.mmu;
>  
>  	kvm_init_shadow_mmu(vcpu);
> -	context->set_cr3           = kvm_x86_ops->set_cr3;
> -	context->get_cr3           = get_cr3;
> -	context->get_pdptr         = kvm_pdptr_read;
> -	context->inject_page_fault = kvm_inject_page_fault;
> +	context->set_cr3	       = kvm_x86_ops->set_cr3;
> +	context->get_guest_cr3_or_eptp = get_cr3;
> +	context->get_pdptr	       = kvm_pdptr_read;
> +	context->inject_page_fault     = kvm_inject_page_fault;
>  }
>  
>  static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
> @@ -5095,10 +5095,10 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>  	if (new_role.as_u64 == g_context->mmu_role.as_u64)
>  		return;
>  
> -	g_context->mmu_role.as_u64 = new_role.as_u64;
> -	g_context->get_cr3           = get_cr3;
> -	g_context->get_pdptr         = kvm_pdptr_read;
> -	g_context->inject_page_fault = kvm_inject_page_fault;
> +	g_context->mmu_role.as_u64	 = new_role.as_u64;
> +	g_context->get_guest_cr3_or_eptp = get_cr3;
> +	g_context->get_pdptr		 = kvm_pdptr_read;
> +	g_context->inject_page_fault	 = kvm_inject_page_fault;
>  
>  	/*
>  	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 6b15b58f3ecc..24dfa0fcba56 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -333,7 +333,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	trace_kvm_mmu_pagetable_walk(addr, access);
>  retry_walk:
>  	walker->level = mmu->root_level;
> -	pte           = mmu->get_cr3(vcpu);
> +	pte           = mmu->get_guest_cr3_or_eptp(vcpu);
>  	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>  
>  #if PTTYPE == 64
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index a3e32d61d60c..1e2f05a79417 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3026,11 +3026,11 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
>  	kvm_init_shadow_mmu(vcpu);
> -	vcpu->arch.mmu->set_cr3           = nested_svm_set_tdp_cr3;
> -	vcpu->arch.mmu->get_cr3           = nested_svm_get_tdp_cr3;
> -	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
> -	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
> -	vcpu->arch.mmu->shadow_root_level = get_npt_level(vcpu);
> +	vcpu->arch.mmu->set_cr3		      = nested_svm_set_tdp_cr3;
> +	vcpu->arch.mmu->get_guest_cr3_or_eptp = nested_svm_get_tdp_cr3;
> +	vcpu->arch.mmu->get_pdptr	      = nested_svm_get_tdp_pdptr;
> +	vcpu->arch.mmu->inject_page_fault     = nested_svm_inject_npf_exit;
> +	vcpu->arch.mmu->shadow_root_level     = get_npt_level(vcpu);
>  	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
>  	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
>  }
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4fb05c0e29fe..2d7b87b532f5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -354,10 +354,10 @@ static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
>  			VMX_EPT_EXECUTE_ONLY_BIT,
>  			nested_ept_ad_enabled(vcpu),
>  			nested_ept_get_eptp(vcpu));
> -	vcpu->arch.mmu->set_cr3           = vmx_set_cr3;
> -	vcpu->arch.mmu->get_cr3           = nested_ept_get_eptp;
> -	vcpu->arch.mmu->inject_page_fault = nested_ept_inject_page_fault;
> -	vcpu->arch.mmu->get_pdptr         = kvm_pdptr_read;
> +	vcpu->arch.mmu->set_cr3		      = vmx_set_cr3;
> +	vcpu->arch.mmu->get_guest_cr3_or_eptp = nested_ept_get_eptp;
> +	vcpu->arch.mmu->inject_page_fault     = nested_ept_inject_page_fault;
> +	vcpu->arch.mmu->get_pdptr	      = kvm_pdptr_read;
>  
>  	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..1e6d8766fbdd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10179,7 +10179,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		return;
>  
>  	if (!vcpu->arch.mmu->direct_map &&
> -	      work->arch.cr3 != vcpu->arch.mmu->get_cr3(vcpu))
> +	      work->arch.cr3 != vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu))
>  		return;
>  
>  	vcpu->arch.mmu->page_fault(vcpu, work->cr2_or_gpa, 0, true);
> 

