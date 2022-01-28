Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D1D49F7D7
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 12:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348013AbiA1LIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 06:08:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348000AbiA1LIG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 06:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643368086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r/Z89cDjHpntAHUD/RSb3guWlLGmU+c1d1Z61HpvZ50=;
        b=UkPnP3h2J7+RCf/rNNCulBU9MttB3/Kqgxljmva3Un02NVjhWxixJ/LuD8lhCgfjlKozXm
        teoRiyP8k5nD5WvYcDxnlUV6cb82Ezq/aGEw3dnYh2aHgImZVgCvbx4smRHWclmQK/pJGp
        dfYFnGSQuSGxWn2tOM0zxxZPSmoloCM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-FkQTCBm2Omyv0WEfc8osgQ-1; Fri, 28 Jan 2022 06:08:04 -0500
X-MC-Unique: FkQTCBm2Omyv0WEfc8osgQ-1
Received: by mail-wr1-f72.google.com with SMTP id x4-20020adfbb44000000b001d83e815683so2120912wrg.8
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 03:08:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=r/Z89cDjHpntAHUD/RSb3guWlLGmU+c1d1Z61HpvZ50=;
        b=OqBd8KXByRj/RMqB/b+YvaQtx2KlSk//Qjac1TI5B2vj2QZQMMd1wXKQMJUsH+vhHh
         wdG0MJzDMd1JvHNokBHyG10rHQaCSzi4r9KSTc5i9lDZCKhi+ZAwsA1cH5RS3n0zaZLg
         9OlJ61QZvxaUIK0rhDAfb4A6NZuiCu+qbu6URMOA3WOKQGbS1NXIA3NJ8nFW1Sff0az8
         ZU+Uprov4wBR8tdfGJxpa/KRxhywfoW0KoGpjUS+MvGt8BCRZylNuSEVyK3gJzVQq8EK
         M+xGeG5oka6naIccMqZmU/13o5kCdkYeKduVA1lvqbHOO/BBDz2s8DaHSLmuTpp3mJN6
         OCmw==
X-Gm-Message-State: AOAM530J8dk0bpEatFurzv+NLxQsuLAa6lXqiZa1E+YBcl6X1b5QwwKT
        2dxSLCysH2VoZMQ9WMZWSIqFu3PbE++4B3lC5EZ+OPnKMWLLA3sDzjWriCNO2I0K8Ahw2tAWdYP
        n/jruCvVjJk7R
X-Received: by 2002:a1c:cc07:: with SMTP id h7mr15956170wmb.50.1643368083524;
        Fri, 28 Jan 2022 03:08:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGSxkD+x/HGNqu62fVuWQR5UvYZe4M0tfmZqqbG2QMxvuo6OHoohmnOIdvXtTCKrBrWjPbew==
X-Received: by 2002:a1c:cc07:: with SMTP id h7mr15956149wmb.50.1643368083223;
        Fri, 28 Jan 2022 03:08:03 -0800 (PST)
Received: from ?IPV6:2003:cb:c70e:5c00:522f:9bcd:24a0:cd70? (p200300cbc70e5c00522f9bcd24a0cd70.dip0.t-ipconnect.de. [2003:cb:c70e:5c00:522f:9bcd:24a0:cd70])
        by smtp.gmail.com with ESMTPSA id n10sm1621775wmr.25.2022.01.28.03.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 03:08:02 -0800 (PST)
Message-ID: <99e39466-513b-6db9-6b3a-f40e68997cec@redhat.com>
Date:   Fri, 28 Jan 2022 12:08:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
Content-Language: en-US
To:     "Nikunj A. Dadhania" <nikunj@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bharata B Rao <bharata@amd.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-4-nikunj@amd.com>
 <99248ffb-2c7c-ba25-5d56-2c577e58da4c@redhat.com>
 <c7918558-4eb3-0592-f3e1-9a1c4f36f7c0@amd.com>
 <ef8dcee4-8ce7-cb91-6938-feb39f0bdaba@redhat.com>
 <bd8e94d6-e2fd-16a9-273e-c2563af235df@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <bd8e94d6-e2fd-16a9-273e-c2563af235df@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.01.22 12:04, Nikunj A. Dadhania wrote:
> On 1/28/2022 1:57 PM, David Hildenbrand wrote:
>> On 28.01.22 07:57, Nikunj A. Dadhania wrote:
>>> On 1/26/2022 4:16 PM, David Hildenbrand wrote:
>>>> On 18.01.22 12:06, Nikunj A Dadhania wrote:
>>>>> Use the memslot metadata to store the pinned data along with the pfns.
>>>>> This improves the SEV guest startup time from O(n) to a constant by
>>>>> deferring guest page pinning until the pages are used to satisfy nested
>>>>> page faults. The page reference will be dropped in the memslot free
>>>>> path.
>>>>>
>>>>> Remove the enc_region structure definition and the code which did
>>>>> upfront pinning, as they are no longer needed in view of the demand
>>>>> pinning support.
>>>>>
>>>>> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
>>>>> since qemu is dependent on this API.
>>>>>
>>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>>> ---
>>>>>  arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
>>>>>  arch/x86/kvm/svm/svm.c |   1 +
>>>>>  arch/x86/kvm/svm/svm.h |   3 +-
>>>>>  3 files changed, 81 insertions(+), 131 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>> index d972ab4956d4..a962bed97a0b 100644
>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>> @@ -66,14 +66,6 @@ static unsigned int nr_asids;
>>>>>  static unsigned long *sev_asid_bitmap;
>>>>>  static unsigned long *sev_reclaim_asid_bitmap;
>>>>>  
>>>>> -struct enc_region {
>>>>> -	struct list_head list;
>>>>> -	unsigned long npages;
>>>>> -	struct page **pages;
>>>>> -	unsigned long uaddr;
>>>>> -	unsigned long size;
>>>>> -};
>>>>> -
>>>>>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>>>>>  static int sev_flush_asids(int min_asid, int max_asid)
>>>>>  {
>>>>> @@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>>  	if (ret)
>>>>>  		goto e_free;
>>>>>  
>>>>> -	INIT_LIST_HEAD(&sev->regions_list);
>>>>> -
>>>>>  	return 0;
>>>>>  
>>>>>  e_free:
>>>>> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>>>>  	src->handle = 0;
>>>>>  	src->pages_locked = 0;
>>>>>  	src->enc_context_owner = NULL;
>>>>> -
>>>>> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>>>>>  }
>>>>>  
>>>>>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>>>>> @@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>>>  int svm_register_enc_region(struct kvm *kvm,
>>>>>  			    struct kvm_enc_region *range)
>>>>>  {
>>>>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>> -	struct enc_region *region;
>>>>> -	int ret = 0;
>>>>> -
>>>>> -	if (!sev_guest(kvm))
>>>>> -		return -ENOTTY;
>>>>> -
>>>>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>>>>> -	if (is_mirroring_enc_context(kvm))
>>>>> -		return -EINVAL;
>>>>> -
>>>>> -	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>>>>> -		return -EINVAL;
>>>>> -
>>>>> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>>>>> -	if (!region)
>>>>> -		return -ENOMEM;
>>>>> -
>>>>> -	mutex_lock(&kvm->lock);
>>>>> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>>>>> -	if (IS_ERR(region->pages)) {
>>>>> -		ret = PTR_ERR(region->pages);
>>>>> -		mutex_unlock(&kvm->lock);
>>>>> -		goto e_free;
>>>>> -	}
>>>>> -
>>>>> -	region->uaddr = range->addr;
>>>>> -	region->size = range->size;
>>>>> -
>>>>> -	list_add_tail(&region->list, &sev->regions_list);
>>>>> -	mutex_unlock(&kvm->lock);
>>>>> -
>>>>> -	/*
>>>>> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
>>>>> -	 * or vice versa for this memory range. Lets make sure caches are
>>>>> -	 * flushed to ensure that guest data gets written into memory with
>>>>> -	 * correct C-bit.
>>>>> -	 */
>>>>> -	sev_clflush_pages(region->pages, region->npages);
>>>>> -
>>>>> -	return ret;
>>>>> -
>>>>> -e_free:
>>>>> -	kfree(region);
>>>>> -	return ret;
>>>>> -}
>>>>> -
>>>>> -static struct enc_region *
>>>>> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>>>>> -{
>>>>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>> -	struct list_head *head = &sev->regions_list;
>>>>> -	struct enc_region *i;
>>>>> -
>>>>> -	list_for_each_entry(i, head, list) {
>>>>> -		if (i->uaddr == range->addr &&
>>>>> -		    i->size == range->size)
>>>>> -			return i;
>>>>> -	}
>>>>> -
>>>>> -	return NULL;
>>>>> -}
>>>>> -
>>>>> -static void __unregister_enc_region_locked(struct kvm *kvm,
>>>>> -					   struct enc_region *region)
>>>>> -{
>>>>> -	sev_unpin_memory(kvm, region->pages, region->npages);
>>>>> -	list_del(&region->list);
>>>>> -	kfree(region);
>>>>> +	return 0;
>>>>>  }
>>>>>  
>>>>>  int svm_unregister_enc_region(struct kvm *kvm,
>>>>>  			      struct kvm_enc_region *range)
>>>>>  {
>>>>> -	struct enc_region *region;
>>>>> -	int ret;
>>>>> -
>>>>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>>>>> -	if (is_mirroring_enc_context(kvm))
>>>>> -		return -EINVAL;
>>>>> -
>>>>> -	mutex_lock(&kvm->lock);
>>>>> -
>>>>> -	if (!sev_guest(kvm)) {
>>>>> -		ret = -ENOTTY;
>>>>> -		goto failed;
>>>>> -	}
>>>>> -
>>>>> -	region = find_enc_region(kvm, range);
>>>>> -	if (!region) {
>>>>> -		ret = -EINVAL;
>>>>> -		goto failed;
>>>>> -	}
>>>>> -
>>>>> -	/*
>>>>> -	 * Ensure that all guest tagged cache entries are flushed before
>>>>> -	 * releasing the pages back to the system for use. CLFLUSH will
>>>>> -	 * not do this, so issue a WBINVD.
>>>>> -	 */
>>>>> -	wbinvd_on_all_cpus();
>>>>> -
>>>>> -	__unregister_enc_region_locked(kvm, region);
>>>>> -
>>>>> -	mutex_unlock(&kvm->lock);
>>>>>  	return 0;
>>>>> -
>>>>> -failed:
>>>>> -	mutex_unlock(&kvm->lock);
>>>>> -	return ret;
>>>>>  }
>>>>>  
>>>>>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>> @@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>>  	mirror_sev->fd = source_sev->fd;
>>>>>  	mirror_sev->es_active = source_sev->es_active;
>>>>>  	mirror_sev->handle = source_sev->handle;
>>>>> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
>>>>>  	ret = 0;
>>>>>  
>>>>>  	/*
>>>>> @@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>>  void sev_vm_destroy(struct kvm *kvm)
>>>>>  {
>>>>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>> -	struct list_head *head = &sev->regions_list;
>>>>> -	struct list_head *pos, *q;
>>>>>  
>>>>>  	WARN_ON(sev->num_mirrored_vms);
>>>>>  
>>>>> @@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
>>>>>  	 */
>>>>>  	wbinvd_on_all_cpus();
>>>>>  
>>>>> -	/*
>>>>> -	 * if userspace was terminated before unregistering the memory regions
>>>>> -	 * then lets unpin all the registered memory.
>>>>> -	 */
>>>>> -	if (!list_empty(head)) {
>>>>> -		list_for_each_safe(pos, q, head) {
>>>>> -			__unregister_enc_region_locked(kvm,
>>>>> -				list_entry(pos, struct enc_region, list));
>>>>> -			cond_resched();
>>>>> -		}
>>>>> -	}
>>>>> -
>>>>>  	sev_unbind_asid(kvm, sev->handle);
>>>>>  	sev_asid_free(sev);
>>>>>  }
>>>>> @@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>>>>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>>>>>  }
>>>>>  
>>>>> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>>>>> +		  kvm_pfn_t pfn)
>>>>> +{
>>>>> +	struct kvm_arch_memory_slot *aslot;
>>>>> +	struct kvm_memory_slot *slot;
>>>>> +	gfn_t rel_gfn, pin_pfn;
>>>>> +	unsigned long npages;
>>>>> +	kvm_pfn_t old_pfn;
>>>>> +	int i;
>>>>> +
>>>>> +	if (!sev_guest(kvm))
>>>>> +		return;
>>>>> +
>>>>> +	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
>>>>> +		return;
>>>>> +
>>>>> +	/* Tested till 1GB pages */
>>>>> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
>>>>> +		return;
>>>>> +
>>>>> +	slot = gfn_to_memslot(kvm, gfn);
>>>>> +	if (!slot || !slot->arch.pfns)
>>>>> +		return;
>>>>> +
>>>>> +	/*
>>>>> +	 * Use relative gfn index within the memslot for the bitmap as well as
>>>>> +	 * the pfns array
>>>>> +	 */
>>>>> +	rel_gfn = gfn - slot->base_gfn;
>>>>> +	aslot = &slot->arch;
>>>>> +	pin_pfn = pfn;
>>>>> +	npages = KVM_PAGES_PER_HPAGE(level);
>>>>> +
>>>>> +	/* Pin the page, KVM doesn't yet support page migration. */
>>>>> +	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
>>>>> +		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
>>>>> +			old_pfn = aslot->pfns[rel_gfn];
>>>>> +			if (old_pfn == pin_pfn)
>>>>> +				continue;
>>>>> +
>>>>> +			put_page(pfn_to_page(old_pfn));
>>>>> +		}
>>>>> +
>>>>> +		set_bit(rel_gfn, aslot->pinned_bitmap);
>>>>> +		aslot->pfns[rel_gfn] = pin_pfn;
>>>>> +		get_page(pfn_to_page(pin_pfn));
>>>>
>>>>
>>>> I assume this is to replace KVM_MEMORY_ENCRYPT_REG_REGION, which ends up
>>>> calling svm_register_enc_region()->sev_pin_memory(), correct?
>>>
>>> Yes, that is correct.
>>>>
>>>> sev_pin_memory() correctly checks the RLIMIT_MEMLOCK and uses
>>>> pin_user_pages_fast().
>>>>
>>>> I have to strongly assume that sev_pin_memory() is *wrong* as is because
>>>> it's supposed to supply FOLL_LONGTERM -- after all we're pinning these
>>>> pages possibly forever.
>>>>
>>>>
>>>> I might be wrong but
>>>>
>>>> 1. You are missing the RLIMIT_MEMLOCK check
>>>
>>> Yes, I will add this check during the enc_region registration.
>>>
>>>> 2. get_page() is the wong way of long-term pinning a page. You would
>>>> have to mimic what pin_user_pages_fast(FOLL_LONGTERM) does to eventually
>>>> get it right (e.g., migrate the page off of MIGRATE_CMA or ZONE_MOVABLE).
>>>
>>> Let me go through this and I will come back. Thanks for pointing this out.
>>
>> I asusme the "issue" is that KVM uses mmu notifier and does a simple
>> get_user_pages() to obtain the references, to drop the reference when
>> the entry is invalidated via a mmu notifier call. So once you intent to
>> long-term pin, it's already to late.
>>
>> If you could teach KVM to do a long-term pin when stumbling over these
>> special encrypted memory regions (requires a proper matching
>> unpin_user_pages() call from KVM), then you could "take over" that pin
>> by get_page(), and let KVM do the ordinary put_page(), while you would
>> do the unpin_user_pages().
>>
> 
> The fault path looks like this in KVM x86 mmu code:
> 
> direct_page_fault()
> -> kvm_faultin_pfn()
>    -> __gfn_to_pfn_memslot()
>       -> hva_to_pfn()
>          -> hva_to_pfn_{slow,fast}()
>             -> get_user_pages_*()      <<<<==== This is where the
>                                                 reference is taken
> 
> Next step is to create the mappings which is done in below functions:
> 
> -> kvm_tdp_mmu_map() / __direct_map()
> 
>    -> Within this function (patch 1/6), I call sev_pin_spte to take an extra 
>       reference to pin it using get_page. 
> 
>       Is it possible to use pin_user_pages(FOLL_LONGTERM) here? Wouldn't that 
>       be equivalent to "take over" solution that you are suggesting?
> 

The issue is that pin_user_pages(FOLL_LONGTERM) might have to migrate
the page, which will fail if there is already an additional reference
from get_user_pages_*().

-- 
Thanks,

David / dhildenb

