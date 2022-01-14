Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236FD48F34F
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 00:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiANX6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 18:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiANX6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 18:58:37 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5710AC06173F
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 15:58:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i17so4141044pfk.11
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 15:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ADWcaIkA01YbE4TT3huW2j2OTlAZUheWg4CaojBHWhU=;
        b=XrAK9Q4h8NbWlWEXyH4IMPsy5lz0vYqfqSj1cEtYCY3aOMu06kW6w+kU2hOFgMlsqP
         qtupN7TLnVO2UJyTmYYMFKGiGfYXAVV5cr3ez8BRJkNXt/yX25FETyh+hXTYvCLD59Ju
         TMm4hPcyE/vMpF16q5+vd+cGD0/8niU/b5Yzs52CofZsMqbZ1Ygv4AkBrjb/E7dBAoh+
         P4+u9gXJkyM+wqryX1IBAxQa8mrUpZ0VPS7DT9Y8uA9K5Tf1Mreshx+/+y169GxiX3/n
         Zh8Lx3sSPVYVJoGePvZGLE1GewxPs+g66hysQRCpqqnsGsF0/OolzSug1R6IcOfdXSdd
         bSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ADWcaIkA01YbE4TT3huW2j2OTlAZUheWg4CaojBHWhU=;
        b=liILmpFxvIbB9I/jNAhtV1gdqquI/1918DG6P5uK5c18v64aHctawEdbwEn8/JKv/M
         ja4NYPJH/hp5ePesRwuQ5XHbL33VtnEbXnpnT/77gien4j2lLf6UAhH5N8xoQq+W8kp2
         2sd2J2KiCUEny9WbHJ6jkbl3mesZL1TWyS7uF208810QxeSxzrLOzeWk0fMxsaMpGtkm
         kmmsbqbWCh8Pq+Z2NY58f1J4iB5jRJtW6eVS50lqu+Mj0mFO2d6SMVMgitZ5rHh5x+0l
         r5oQ6t2K+BraYzPDTXVCL1PTVkPozmJ3lURD/x2/P1glQjHvD+KyRUXqhgnAqGYDvCxW
         7wrA==
X-Gm-Message-State: AOAM5326jAzdYjjdlEzIVzGdsJp0SB1pbiV4Uxu3pU/osxRKGe+3dsXr
        arQK3YH+jbUyiVAn5XWEKtRAEg==
X-Google-Smtp-Source: ABdhPJzLbkTwR89hs7Uw5aqjihEtjbXLO24l0jq3ZhUIQvFWcpDogUCUKNsMmuVDIfiL3T5JKq60GQ==
X-Received: by 2002:a63:82c3:: with SMTP id w186mr6675942pgd.157.1642204716292;
        Fri, 14 Jan 2022 15:58:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g5sm7241583pfc.107.2022.01.14.15.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:58:35 -0800 (PST)
Date:   Fri, 14 Jan 2022 23:58:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86/mmu: Improve TLB flush comment in
 kvm_mmu_slot_remove_write_access()
Message-ID: <YeIOKLxBF/MPmxbP@google.com>
References: <20220113233020.3986005-1-dmatlack@google.com>
 <20220113233020.3986005-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113233020.3986005-5-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, David Matlack wrote:
> Rewrite the comment in kvm_mmu_slot_remove_write_access() that explains
> why it is safe to flush TLBs outside of the MMU lock after
> write-protecting SPTEs for dirty logging. The current comment is a long
> run-on sentence that was difficult to understand. In addition it was
> specific to the shadow MMU (mentioning mmu_spte_update()) when the TDP
> MMU has to handle this as well.
> 
> The new comment explains:
>  - Why the TLB flush is necessary at all.
>  - Why it is desirable to do the TLB flush outside of the MMU lock.
>  - Why it is safe to do the TLB flush outside of the MMU lock.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

One nit below,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1d275e9d76b5..8ed2b42a7aa3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5756,6 +5756,7 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>  				continue;
>  
>  			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
> +
>  							PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
>  							start, end - 1, true, flush);
>  		}
> @@ -5825,15 +5826,27 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  	}
>  
>  	/*
> -	 * We can flush all the TLBs out of the mmu lock without TLB
> -	 * corruption since we just change the spte from writable to
> -	 * readonly so that we only need to care the case of changing
> -	 * spte from present to present (changing the spte from present
> -	 * to nonpresent will flush all the TLBs immediately), in other
> -	 * words, the only case we care is mmu_spte_update() where we
> -	 * have checked Host-writable | MMU-writable instead of
> -	 * PT_WRITABLE_MASK, that means it does not depend on PT_WRITABLE_MASK
> -	 * anymore.
> +	 * Flush TLBs if any SPTEs had to be write-protected to ensure that
> +	 * guest writes are reflected in the dirty bitmap before the memslot
> +	 * update completes, i.e. before enabling dirty logging is visible to
> +	 * userspace.
> +	 *
> +	 * Perform the TLB flush outside the mmu_lock to reduce the amount of
> +	 * time the lock is held. However, this does mean that another CPU can
> +	 * now grab the mmu_lock and encounter an SPTE that is write-protected
> +	 * while CPUs still have writable versions of that SPTE in their TLB.

Uber nit on "SPTE in their TLB".  Maybe this?

	 * now grab mmu_lock and encounter a write-protected SPTE while CPUs
	 * still have a writable mapping for the associated GFN in their TLB.

> +	 *
> +	 * This is safe but requires KVM to be careful when making decisions
> +	 * based on the write-protection status of an SPTE. Specifically, KVM
> +	 * also write-protects SPTEs to monitor changes to guest page tables
> +	 * during shadow paging, and must guarantee no CPUs can write to those
> +	 * page before the lock is dropped. As mentioned in the previous
> +	 * paragraph, a write-protected SPTE is no guarantee that CPU cannot
> +	 * perform writes. So to determine if a TLB flush is truly required, KVM
> +	 * will clear a separate software-only bit (MMU-writable) and skip the
> +	 * flush if-and-only-if this bit was already clear.
> +	 *
> +	 * See DEFAULT_SPTE_MMU_WRITEABLE for more details.
>  	 */
>  	if (flush)
>  		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> -- 
> 2.34.1.703.g22d0c6ccf7-goog
> 
