Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FBB3987B0
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 13:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhFBLJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 07:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBLJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 07:09:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F22C061574
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 04:07:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id g17so1835967wrs.13
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 04:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QwU7eNpnhcnSNsCtdIpNIwPgvGDGJ4+rnF5GomWdPmY=;
        b=v1ylLqjAdoNf/H7w9k6hQe7WHAc3a2ZesvC3IRvLPZ1+tQRZac+5ne5v5FaCWj+y5C
         BxBVdNM5skbbGmZhDCRSWRz3Xt0A5h6zb4DZsNKbWib3299MD2oicnmoT1z9oz0cjrJ3
         8kR2BfFD3YvzWy5mEPYEPl1uy4R86YjGrT17a/Puup3fQvY8kdPiuiv5h2H48v/v6dA/
         3FCz/EIjFp6BEePGVBUNTN6mngT9AhytfCRfcCjE0KXsPUsm5AoALDbB/jCiNoTbie29
         OU2SyFWidQIIf65c44G8BW8zwbZe0H26U29sc2qkBI0unDdkQd9/SpRNhyyJzVXsPmI1
         qi0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QwU7eNpnhcnSNsCtdIpNIwPgvGDGJ4+rnF5GomWdPmY=;
        b=Ryi8Y86H3FQMoiQpI+grurE/R6xivoJY8ZEYW0KsFG+g2g71ndAiTpX7GhL2PxbTaF
         b+Ftf/IebpOKJb1QPNn9tnx3Aqsk+2B+20NoOStA3pw9o6hjCi0BpbZc72VcTr9r23nW
         eQ8rOAI0zykuGa9hqvW32JY7rboN2vanVPVw8d1RskrXy3Qjk5PZW6UQMUNquBw4UlQy
         /FwNKUNJh6UV7++l5P5eP+P7on4owgAh04I1xfwE8XWAeXrM4UicNN+R/9aMA6q881Dm
         nd4ok6lo1PFqDrw2Nv8KR2xWY6oxb1ZZPt8hG0rjwAY7LWmFEYxKKto41gON4sTSKOuP
         hW1Q==
X-Gm-Message-State: AOAM531fYl//3LgeRFGTj5c0aGjVIkZgwWOEvgpd8W/rdlJUcAIKHY3z
        Xn43rD2dQPWRNgwAGsteGzqGmw==
X-Google-Smtp-Source: ABdhPJyaYUKxfSrgwNdRYacXMtN7kPQKgVxIk8ZpqN9TTX1nHz6hbmS6x6ztsX9uQZdAVXxWRyaxEg==
X-Received: by 2002:a5d:6082:: with SMTP id w2mr7244022wrt.209.1622632076964;
        Wed, 02 Jun 2021 04:07:56 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id z11sm6213182wrs.7.2021.06.02.04.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 04:07:56 -0700 (PDT)
Date:   Wed, 2 Jun 2021 11:07:53 +0000
From:   Quentin Perret <qperret@google.com>
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, wanghaibin.wang@huawei.com,
        zhukeqian1@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH v5 6/6] KVM: arm64: Distinguish cases of memcache
 allocations completely
Message-ID: <YLdmiTfgz1EqBsJd@google.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-7-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415115032.35760-7-wangyanan55@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday 15 Apr 2021 at 19:50:32 (+0800), Yanan Wang wrote:
> With a guest translation fault, the memcache pages are not needed if KVM
> is only about to install a new leaf entry into the existing page table.
> And with a guest permission fault, the memcache pages are also not needed
> for a write_fault in dirty-logging time if KVM is only about to update
> the existing leaf entry instead of collapsing a block entry into a table.
> 
> By comparing fault_granule and vma_pagesize, cases that require allocations
> from memcache and cases that don't can be distinguished completely.
> 
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/mmu.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index aa536392b308..9e35aa5d29f2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -895,19 +895,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	gfn = fault_ipa >> PAGE_SHIFT;
>  	mmap_read_unlock(current->mm);
>  
> -	/*
> -	 * Permission faults just need to update the existing leaf entry,
> -	 * and so normally don't require allocations from the memcache. The
> -	 * only exception to this is when dirty logging is enabled at runtime
> -	 * and a write fault needs to collapse a block entry into a table.
> -	 */
> -	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
> -		ret = kvm_mmu_topup_memory_cache(memcache,
> -						 kvm_mmu_cache_min_pages(kvm));
> -		if (ret)
> -			return ret;
> -	}
> -
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	/*
>  	 * Ensure the read of mmu_notifier_seq happens before we call
> @@ -970,6 +957,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
>  		prot |= KVM_PGTABLE_PROT_X;
>  
> +	/*
> +	 * Allocations from the memcache are required only when granule of the
> +	 * lookup level where the guest fault happened exceeds vma_pagesize,
> +	 * which means new page tables will be created in the fault handlers.
> +	 */
> +	if (fault_granule > vma_pagesize) {
> +		ret = kvm_mmu_topup_memory_cache(memcache,
> +						 kvm_mmu_cache_min_pages(kvm));
> +		if (ret)
> +			return ret;
> +	}

You're now doing the top-up in the kvm->mmu_lock critical section. Isn't
this more or less what we try to avoid by using a memory cache?

Thanks,
Quentin
