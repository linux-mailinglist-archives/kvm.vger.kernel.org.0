Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B241153046
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgBEMAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:00:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56766 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726277AbgBEMAU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580904018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z9OdtqIYUBqoL66r9+oESb2jG/fvhjGyIkGlsqD7Tqs=;
        b=X6pGbPFA6D4WvFECHidJJnQ/GLuPG3fwztAkRMGqvI9/MkLYCmcZbtOwgmyqQSTrTNSjOT
        OUEhF3euSXyjzXoFsapGuRey3Cj2r1DJGUSXLXr3pWsoZ3SZD61ek68lZ65M8jWh5XXRAw
        SS346G5UjU9M/5ZPccVkyK7zmQRgCu8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-9dZmVKLjNbSzv1F3pfEEQA-1; Wed, 05 Feb 2020 07:00:14 -0500
X-MC-Unique: 9dZmVKLjNbSzv1F3pfEEQA-1
Received: by mail-wr1-f72.google.com with SMTP id a12so1069166wrn.19
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 04:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Z9OdtqIYUBqoL66r9+oESb2jG/fvhjGyIkGlsqD7Tqs=;
        b=Ca4BXP/pZ6/bqAPXGZNqTXbmBSAMC9ngaD2vNkeJ1MWOcQP+O0FdmYwrJ4MH6B3eki
         P25so4kCJgHOUv2ogh+ZHUCHxPKFJMDV4FWN4KaiRIkMgaqxNRk/sxn8X3oLIibzInC1
         jfvYsGlAnm9+CcSlVUoztTGmVngaxry1aYPgx8JoyZppnYyesqaa5pPtQfUngU/wEkvD
         Ixu0Wv0IgEOloWupgXF8qT+AW6LPyfZzrXAu+oOBOVZVCghiSZyW6H4zU+r7wyLNiTor
         OGT+odJEM15P1Qkox56Hs8rgMJhtNyvOMqmhMYwXvE08LR9Hy8+Zl+7NFpVVPmsZka4l
         2tKw==
X-Gm-Message-State: APjAAAXn8pYt6chjsESqkYfIBzLi6rHIc8h2CzcH67Ah2YiEV7hYqDyo
        e5r706Pah9T1MDy5DI4+QzemMxlI/XbkhBU8v0gsGEVlDSPmfP1/nLQrMr9GlOMrbOYhR5/7WyY
        A8YE37GzAubLN
X-Received: by 2002:a5d:4c89:: with SMTP id z9mr22168448wrs.97.1580904013032;
        Wed, 05 Feb 2020 04:00:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwSvQyMeJTISB9Ag6NMPuNBbKfC47aIaLnVUfMV7jVwsDN2cT06Yn/Y71CxLRow8+0A6XsFrQ==
X-Received: by 2002:a5d:4c89:: with SMTP id z9mr22168431wrs.97.1580904012809;
        Wed, 05 Feb 2020 04:00:12 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q14sm34679205wrj.81.2020.02.05.04.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 04:00:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/3] kvm: mmu: Replace unsigned with unsigned int for PTE access
In-Reply-To: <20200203230911.39755-1-bgardon@google.com>
References: <20200203230911.39755-1-bgardon@google.com>
Date:   Wed, 05 Feb 2020 13:00:11 +0100
Message-ID: <87v9olkzw4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ben Gardon <bgardon@google.com> writes:

> There are several functions which pass an access permission mask for
> SPTEs as an unsigned. This works, but checkpatch complains about it.
> Switch the occurrences of unsigned to unsigned int to satisfy checkpatch.
>
> No functional change expected.
>
> Tested by running kvm-unit-tests on an Intel Haswell machine. This
> commit introduced no new failures.
>
> This commit can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2358
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 84eeb61d06aa3..a9c593dec49bf 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -452,7 +452,7 @@ static u64 get_mmio_spte_generation(u64 spte)
>  }
>  
>  static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
> -			   unsigned access)
> +			   unsigned int access)
>  {
>  	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
>  	u64 mask = generation_mmio_spte_mask(gen);
> @@ -484,7 +484,7 @@ static unsigned get_mmio_spte_access(u64 spte)
>  }
>  
>  static bool set_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
> -			  kvm_pfn_t pfn, unsigned access)
> +			  kvm_pfn_t pfn, unsigned int access)
>  {
>  	if (unlikely(is_noslot_pfn(pfn))) {
>  		mark_mmio_spte(vcpu, sptep, gfn, access);
> @@ -2475,7 +2475,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  					     gva_t gaddr,
>  					     unsigned level,
>  					     int direct,
> -					     unsigned access)
> +					     unsigned int access)
>  {
>  	union kvm_mmu_page_role role;
>  	unsigned quadrant;
> @@ -2990,7 +2990,7 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
>  #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
>  
>  static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> -		    unsigned pte_access, int level,
> +		    unsigned int pte_access, int level,
>  		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
>  		    bool can_unsync, bool host_writable)
>  {
> @@ -3081,9 +3081,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	return ret;
>  }
>  
> -static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
> -			int write_fault, int level, gfn_t gfn, kvm_pfn_t pfn,
> -		       	bool speculative, bool host_writable)
> +static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> +			unsigned int pte_access, int write_fault, int level,
> +			gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> +			bool host_writable)
>  {
>  	int was_rmapped = 0;
>  	int rmap_count;
> @@ -3165,7 +3166,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
>  {
>  	struct page *pages[PTE_PREFETCH_NUM];
>  	struct kvm_memory_slot *slot;
> -	unsigned access = sp->role.access;
> +	unsigned int access = sp->role.access;
>  	int i, ret;
>  	gfn_t gfn;
>  
> @@ -3400,7 +3401,8 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>  }
>  
>  static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
> -				kvm_pfn_t pfn, unsigned access, int *ret_val)
> +				kvm_pfn_t pfn, unsigned int access,
> +				int *ret_val)
>  {
>  	/* The pfn is invalid, report the error! */
>  	if (unlikely(is_error_pfn(pfn))) {
> @@ -4005,7 +4007,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  
>  	if (is_mmio_spte(spte)) {
>  		gfn_t gfn = get_mmio_spte_gfn(spte);
> -		unsigned access = get_mmio_spte_access(spte);
> +		unsigned int access = get_mmio_spte_access(spte);
>  
>  		if (!check_mmio_spte(vcpu, spte))
>  			return RET_PF_INVALID;
> @@ -4349,7 +4351,7 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
>  }
>  
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
> -			   unsigned access, int *nr_present)
> +			   unsigned int access, int *nr_present)
>  {
>  	if (unlikely(is_mmio_spte(*sptep))) {
>  		if (gfn != get_mmio_spte_gfn(*sptep)) {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

