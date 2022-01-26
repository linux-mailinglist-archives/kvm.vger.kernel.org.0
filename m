Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7784049C7DE
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 11:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiAZKrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 05:47:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240166AbiAZKrB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 05:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643194020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36m2kcjL54DLfTH9bRXrige/OiNdmZ5nBs2jhR2L36k=;
        b=S62rvBCKBShAeqBIVTnDL06aKmxxAjUniIdPjKazBL0I+Kut0QKNa+OnIFU0s7NAcEECAv
        sPyeTSbZRE9PuShnd7oLK5GBY0yVVqEtL8Tki32ehdxm3OPMnBnfqv2sPGWw5G15RizaZn
        TUSa9bo6eJ+8lXpooFoX8hYLEF5cJec=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-ngoPEgJPPWKKGnxfkulL4g-1; Wed, 26 Jan 2022 05:46:59 -0500
X-MC-Unique: ngoPEgJPPWKKGnxfkulL4g-1
Received: by mail-wm1-f70.google.com with SMTP id c16-20020a1c9a10000000b0034dd409329eso3077556wme.3
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 02:46:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=36m2kcjL54DLfTH9bRXrige/OiNdmZ5nBs2jhR2L36k=;
        b=S5oAoaveJbgktDEoLlP680Ii9HxXTR7FuSyXe7dJx3p3G/Y0ZOh5/PHBUStngE5hKd
         HuVUerUEBPRo/bo7cA8Ik6gA4cb1ZbnRMLZ8TlYxulxUvY1q03J5aBsdBO3duRsyU/Jl
         kEuJyO1XKPrC2saR2Z0r1lqh/XdAkNTijVxIlx9ss/ub8648gTlZ6u8st+F3XH0RYKrJ
         mIxRB7k+0JOKsKN6K/IvuA/V0kl4DhxupNTO89xrtqSRu5fW31wTtkAevW8yjcr+9ZeT
         5WCh+LA1a3K5k6kLMHJipbISvC14p8lTOTjnYrQvWRVb4g1Rz40+92xO8OFC9WNd2eFp
         EWnw==
X-Gm-Message-State: AOAM531z1fWUlmQvMkV3Xk7BIDZBGeK19dVQC9PsnDrB0/YMHnFsnWWF
        0UmhMDAwJhR6V8+51Lk7YzkGZHmjU2Li7dPzcfhwIqjyL4ID+eJAbEZI/1RxezWvGYGCgLbzv9M
        XUHt03cREJH2b
X-Received: by 2002:a7b:c4cd:: with SMTP id g13mr6974620wmk.95.1643194018346;
        Wed, 26 Jan 2022 02:46:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaHQcmSFSVpbpZ521wSTzYwwTEACCYq2kS6aCXWll4DP8KYaHcDHbF3bZBduSQO4Lu0S/ZmA==
X-Received: by 2002:a7b:c4cd:: with SMTP id g13mr6974598wmk.95.1643194018083;
        Wed, 26 Jan 2022 02:46:58 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:2700:cdd8:dcb0:2a69:8783? (p200300cbc7092700cdd8dcb02a698783.dip0.t-ipconnect.de. [2003:cb:c709:2700:cdd8:dcb0:2a69:8783])
        by smtp.gmail.com with ESMTPSA id f13sm1085039wry.77.2022.01.26.02.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 02:46:57 -0800 (PST)
Message-ID: <99248ffb-2c7c-ba25-5d56-2c577e58da4c@redhat.com>
Date:   Wed, 26 Jan 2022 11:46:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Nikunj A Dadhania <nikunj@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-4-nikunj@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
In-Reply-To: <20220118110621.62462-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.01.22 12:06, Nikunj A Dadhania wrote:
> Use the memslot metadata to store the pinned data along with the pfns.
> This improves the SEV guest startup time from O(n) to a constant by
> deferring guest page pinning until the pages are used to satisfy nested
> page faults. The page reference will be dropped in the memslot free
> path.
> 
> Remove the enc_region structure definition and the code which did
> upfront pinning, as they are no longer needed in view of the demand
> pinning support.
> 
> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
> since qemu is dependent on this API.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
>  arch/x86/kvm/svm/svm.c |   1 +
>  arch/x86/kvm/svm/svm.h |   3 +-
>  3 files changed, 81 insertions(+), 131 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d972ab4956d4..a962bed97a0b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -66,14 +66,6 @@ static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  
> -struct enc_region {
> -	struct list_head list;
> -	unsigned long npages;
> -	struct page **pages;
> -	unsigned long uaddr;
> -	unsigned long size;
> -};
> -
>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>  static int sev_flush_asids(int min_asid, int max_asid)
>  {
> @@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (ret)
>  		goto e_free;
>  
> -	INIT_LIST_HEAD(&sev->regions_list);
> -
>  	return 0;
>  
>  e_free:
> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>  	src->handle = 0;
>  	src->pages_locked = 0;
>  	src->enc_context_owner = NULL;
> -
> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>  }
>  
>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> @@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  int svm_register_enc_region(struct kvm *kvm,
>  			    struct kvm_enc_region *range)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct enc_region *region;
> -	int ret = 0;
> -
> -	if (!sev_guest(kvm))
> -		return -ENOTTY;
> -
> -	/* If kvm is mirroring encryption context it isn't responsible for it */
> -	if (is_mirroring_enc_context(kvm))
> -		return -EINVAL;
> -
> -	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
> -		return -EINVAL;
> -
> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
> -	if (!region)
> -		return -ENOMEM;
> -
> -	mutex_lock(&kvm->lock);
> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
> -	if (IS_ERR(region->pages)) {
> -		ret = PTR_ERR(region->pages);
> -		mutex_unlock(&kvm->lock);
> -		goto e_free;
> -	}
> -
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
> -	/*
> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
> -	 * or vice versa for this memory range. Lets make sure caches are
> -	 * flushed to ensure that guest data gets written into memory with
> -	 * correct C-bit.
> -	 */
> -	sev_clflush_pages(region->pages, region->npages);
> -
> -	return ret;
> -
> -e_free:
> -	kfree(region);
> -	return ret;
> -}
> -
> -static struct enc_region *
> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
> -{
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct list_head *head = &sev->regions_list;
> -	struct enc_region *i;
> -
> -	list_for_each_entry(i, head, list) {
> -		if (i->uaddr == range->addr &&
> -		    i->size == range->size)
> -			return i;
> -	}
> -
> -	return NULL;
> -}
> -
> -static void __unregister_enc_region_locked(struct kvm *kvm,
> -					   struct enc_region *region)
> -{
> -	sev_unpin_memory(kvm, region->pages, region->npages);
> -	list_del(&region->list);
> -	kfree(region);
> +	return 0;
>  }
>  
>  int svm_unregister_enc_region(struct kvm *kvm,
>  			      struct kvm_enc_region *range)
>  {
> -	struct enc_region *region;
> -	int ret;
> -
> -	/* If kvm is mirroring encryption context it isn't responsible for it */
> -	if (is_mirroring_enc_context(kvm))
> -		return -EINVAL;
> -
> -	mutex_lock(&kvm->lock);
> -
> -	if (!sev_guest(kvm)) {
> -		ret = -ENOTTY;
> -		goto failed;
> -	}
> -
> -	region = find_enc_region(kvm, range);
> -	if (!region) {
> -		ret = -EINVAL;
> -		goto failed;
> -	}
> -
> -	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> -	 */
> -	wbinvd_on_all_cpus();
> -
> -	__unregister_enc_region_locked(kvm, region);
> -
> -	mutex_unlock(&kvm->lock);
>  	return 0;
> -
> -failed:
> -	mutex_unlock(&kvm->lock);
> -	return ret;
>  }
>  
>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> @@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  	mirror_sev->fd = source_sev->fd;
>  	mirror_sev->es_active = source_sev->es_active;
>  	mirror_sev->handle = source_sev->handle;
> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
>  	ret = 0;
>  
>  	/*
> @@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct list_head *head = &sev->regions_list;
> -	struct list_head *pos, *q;
>  
>  	WARN_ON(sev->num_mirrored_vms);
>  
> @@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
>  	 */
>  	wbinvd_on_all_cpus();
>  
> -	/*
> -	 * if userspace was terminated before unregistering the memory regions
> -	 * then lets unpin all the registered memory.
> -	 */
> -	if (!list_empty(head)) {
> -		list_for_each_safe(pos, q, head) {
> -			__unregister_enc_region_locked(kvm,
> -				list_entry(pos, struct enc_region, list));
> -			cond_resched();
> -		}
> -	}
> -
>  	sev_unbind_asid(kvm, sev->handle);
>  	sev_asid_free(sev);
>  }
> @@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>  }
>  
> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +		  kvm_pfn_t pfn)
> +{
> +	struct kvm_arch_memory_slot *aslot;
> +	struct kvm_memory_slot *slot;
> +	gfn_t rel_gfn, pin_pfn;
> +	unsigned long npages;
> +	kvm_pfn_t old_pfn;
> +	int i;
> +
> +	if (!sev_guest(kvm))
> +		return;
> +
> +	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
> +		return;
> +
> +	/* Tested till 1GB pages */
> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
> +		return;
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot || !slot->arch.pfns)
> +		return;
> +
> +	/*
> +	 * Use relative gfn index within the memslot for the bitmap as well as
> +	 * the pfns array
> +	 */
> +	rel_gfn = gfn - slot->base_gfn;
> +	aslot = &slot->arch;
> +	pin_pfn = pfn;
> +	npages = KVM_PAGES_PER_HPAGE(level);
> +
> +	/* Pin the page, KVM doesn't yet support page migration. */
> +	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
> +		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
> +			old_pfn = aslot->pfns[rel_gfn];
> +			if (old_pfn == pin_pfn)
> +				continue;
> +
> +			put_page(pfn_to_page(old_pfn));
> +		}
> +
> +		set_bit(rel_gfn, aslot->pinned_bitmap);
> +		aslot->pfns[rel_gfn] = pin_pfn;
> +		get_page(pfn_to_page(pin_pfn));


I assume this is to replace KVM_MEMORY_ENCRYPT_REG_REGION, which ends up
calling svm_register_enc_region()->sev_pin_memory(), correct?

sev_pin_memory() correctly checks the RLIMIT_MEMLOCK and uses
pin_user_pages_fast().

I have to strongly assume that sev_pin_memory() is *wrong* as is because
it's supposed to supply FOLL_LONGTERM -- after all we're pinning these
pages possibly forever.


I might be wrong but

1. You are missing the RLIMIT_MEMLOCK check

2. get_page() is the wong way of long-term pinning a page. You would
have to mimic what pin_user_pages_fast(FOLL_LONGTERM) does to eventually
get it right (e.g., migrate the page off of MIGRATE_CMA or ZONE_MOVABLE).

-- 
Thanks,

David / dhildenb

