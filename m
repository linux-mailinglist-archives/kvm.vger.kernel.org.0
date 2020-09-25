Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF9527923C
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgIYUdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:33:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726576AbgIYUYg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:24:36 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601065475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01ndKfa+GCpznGQ+xNkSEDCqzBhgr3SNm6LzFG9u5Yg=;
        b=fCmESQcpQqkVNnYu1hcP+d34UKtQRa0P0r7hMwnuNoIvw8H6vK0/nj7lPp3g3otVbvItZO
        vXW3qXZZ9heNXS270uSKL/g7Z39lwOAuBiGpBsqklpIUkZIpjnn7dSS75Vsour0UFVTPRN
        q2baw16ppQ2cUyiTLHWmIxWJBsNXFKc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-va5XUeX_OcqsIqFdxdewxA-1; Fri, 25 Sep 2020 16:24:32 -0400
X-MC-Unique: va5XUeX_OcqsIqFdxdewxA-1
Received: by mail-wm1-f70.google.com with SMTP id a25so88234wmb.2
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=01ndKfa+GCpznGQ+xNkSEDCqzBhgr3SNm6LzFG9u5Yg=;
        b=piTX0so3hIjRHXpcA1fS7XUB83hjoTt37wxyKOexR1TkioPVIPgFYNRSWgTr9798l0
         9lpRZxDqw+X6UAm2x+VodiBB/YxfdNm5KA0svNBwWbzXl+ScVkXuclzy8MaRM26dokBw
         F3NTpP27pap68gPQMca6eD2PH2kraB++iPT5MGXOLFaerBaCReNGtzNLAoVq3w4ZTb6A
         7SzmOm5yqrTYWHtepHhKS5X8lcipOygs1mFbXNMA+VYP8gxFkPzeO9lcAENAQoAROldZ
         s9NFSGE+5rOfgdJgHeMmLkSWb3d0in//O9OLQZ/AUSCnF3xJ7ufOZmtvfLHVbVaVDWZp
         8WxQ==
X-Gm-Message-State: AOAM530ILaespPC3F1wvnp+lISMWABn05S4gc1wyz9wafTGOARX4RbSu
        15GbbxZ4cy7U1odXaM+81fQXN0iCInFD0Ot8Ftnhc6ZbdEPKiy51QrpyNY6QSJ1Dl917ABrwhcs
        w7tlclNyHpVoV
X-Received: by 2002:a5d:6547:: with SMTP id z7mr6208962wrv.322.1601065471444;
        Fri, 25 Sep 2020 13:24:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaQPODIezVDHXXWdfc2VVPnz/e845Ud7GS+vwdoI3SF/yRDmnPzuPoZlSWH536vc4TF+RGSQ==
X-Received: by 2002:a5d:6547:: with SMTP id z7mr6208948wrv.322.1601065471178;
        Fri, 25 Sep 2020 13:24:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id l5sm188279wmf.10.2020.09.25.13.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:24:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Stash 'kvm' in a local variable in
 kvm_mmu_free_roots()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200923191204.8410-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b9c04020-3bd9-05f4-9306-4e24e7587740@redhat.com>
Date:   Fri, 25 Sep 2020 22:24:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923191204.8410-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 21:12, Sean Christopherson wrote:
> To make kvm_mmu_free_roots() a bit more readable, capture 'kvm' in a
> local variable instead of doing vcpu->kvm over and over (and over).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 76c5826e29a2..cdc498093450 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3603,6 +3603,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			ulong roots_to_free)
>  {
> +	struct kvm *kvm = vcpu->kvm;
>  	int i;
>  	LIST_HEAD(invalid_list);
>  	bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
> @@ -3620,22 +3621,21 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			return;
>  	}
>  
> -	spin_lock(&vcpu->kvm->mmu_lock);
> +	spin_lock(&kvm->mmu_lock);
>  
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>  		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
> -			mmu_free_root_page(vcpu->kvm, &mmu->prev_roots[i].hpa,
> +			mmu_free_root_page(kvm, &mmu->prev_roots[i].hpa,
>  					   &invalid_list);
>  
>  	if (free_active_root) {
>  		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
>  		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> -			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
> -					   &invalid_list);
> +			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
>  		} else {
>  			for (i = 0; i < 4; ++i)
>  				if (mmu->pae_root[i] != 0)
> -					mmu_free_root_page(vcpu->kvm,
> +					mmu_free_root_page(kvm,
>  							   &mmu->pae_root[i],
>  							   &invalid_list);
>  			mmu->root_hpa = INVALID_PAGE;
> @@ -3643,8 +3643,8 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  		mmu->root_pgd = 0;
>  	}
>  
> -	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
> -	spin_unlock(&vcpu->kvm->mmu_lock);
> +	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> +	spin_unlock(&kvm->mmu_lock);
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
>  
> 

Queued this one, for now.

Paolo

