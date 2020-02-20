Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C325D16635D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 17:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgBTQqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 11:46:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24651 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727709AbgBTQqW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 11:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582217180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wz3S2jgJvj4vVS0J/1tQsEZXIzN4XqcL3Uaj1OP2AMo=;
        b=P/v4GzmUgykqy5o6mLGcNU60tNi4I+8SiilbooMgUmCMUfNzLBb2SwtI4qbAvUKCpTyJcT
        bqprBceBsLmIV2R1YxYOlp89t3Yt3yha9UtqeujFbjwkaL81QwQpK0q28/cZBEvPN6pHFh
        hmytVQFc6d9CThN/uaJLGBG2VSYODCo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-ykvzcZgaMKW5w4MRz1MC7w-1; Thu, 20 Feb 2020 11:46:18 -0500
X-MC-Unique: ykvzcZgaMKW5w4MRz1MC7w-1
Received: by mail-wm1-f72.google.com with SMTP id o24so1073662wmh.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 08:46:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wz3S2jgJvj4vVS0J/1tQsEZXIzN4XqcL3Uaj1OP2AMo=;
        b=T1HRcSPiW8/EAtwjlVW8/fTxu44mjnlC2N/gnApdyKMSfgj4xTMY/4q2wiCdkZQbTj
         Tl7dxESTH4g469x7KCSWtSWNW+0nzuQISyZSHMLjMMbIl+groKwbryPwbLebGY0SLqAV
         Lxt/jv6a56lM+n+8Ai1yk3RWuG7BCfRn+0mksEnkIM4n1tg5eFU9rsPP9XXNBD7GVg05
         sDVqwRUTQxjF8G8V3Q4Lf8qNlAEhKmeCJf5HNHnAON/YpQbmdAzVMcIK9EItIfHtJwJt
         lVLa3syJgZWTKxib65iqcq+PmEU8A+q5sVQA4Po7pCbEiM6xWWDGifJBACQ+zZyrA866
         Jtig==
X-Gm-Message-State: APjAAAVbyusbg7v594oCUlOnIBMF1ak7fgGFLkXFhD1v5j0eix0JkqqL
        F8lUDAgslUBe3siayNgFuTDXq9gjYvsJ9llCLIyTWQzFuIkHSOUMBuWWXF/sVt0xUCWDSPtJq7N
        /eP6/m30Kjnym
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr5288925wme.36.1582217177172;
        Thu, 20 Feb 2020 08:46:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqwO7dvVJlOJWouvqSED22F87RWEtb02mYj0YicBJK9fZ6uZ7264VCg02h9CSQo+cOxFlgREig==
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr5288903wme.36.1582217176807;
        Thu, 20 Feb 2020 08:46:16 -0800 (PST)
Received: from [10.201.49.12] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id h128sm5806740wmh.33.2020.02.20.08.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 08:46:16 -0800 (PST)
Subject: Re: [PATCH 13/13] KVM: selftests: Introduce num-pages conversion
 utilities
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     bgardon@google.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, peterx@redhat.com
References: <20200214145920.30792-1-drjones@redhat.com>
 <20200214145920.30792-14-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <175a1e53-1e7b-423c-14bc-de4ce6c99868@redhat.com>
Date:   Thu, 20 Feb 2020 17:46:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200214145920.30792-14-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 15:59, Andrew Jones wrote:
> Guests and hosts don't have to have the same page size. This means
> calculations are necessary when selecting the number of guest pages
> to allocate in order to ensure the number is compatible with the
> host. Provide utilities to help with those calculations and apply
> them where appropriate.
> 
> We also revert commit bffed38d4fb5 ("kvm: selftests: aarch64:
> dirty_log_test: fix unaligned memslot size") and then use
> vm_adjust_num_guest_pages() there instead.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  .../selftests/kvm/demand_paging_test.c        |  8 ++---
>  tools/testing/selftests/kvm/dirty_log_test.c  | 13 ++++----
>  .../testing/selftests/kvm/include/kvm_util.h  |  8 +++++
>  .../testing/selftests/kvm/include/test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 32 +++++++++++++++++++
>  5 files changed, 50 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index a5e57bd63e78..a9289a9386c0 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -164,12 +164,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
>  	pages += (2 * pages) / PTES_PER_4K_PT;
>  	pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
>  		 PTES_PER_4K_PT;
> -
> -	/*
> -	 * If the host is uing 64K pages, then we need the number of 4K
> -	 * guest pages to be a multiple of 16.
> -	 */
> -	pages += 16 - pages % 16;
> +	pages = vm_adjust_num_guest_pages(mode, pages);
>  
>  	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
> @@ -382,6 +377,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>  		    "Guest memory size is not guest page size aligned.");
>  
>  	guest_num_pages = (vcpus * vcpu_memory_bytes) / guest_page_size;
> +	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
>  
>  #ifdef __s390x__
>  	/* Round up to multiple of 1M (segment size) */

Moved this part to "fixup! KVM: selftests: Support multiple vCPUs in
demand paging test".

Paolo

> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 12acf90826c1..a723333b138a 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -178,12 +178,11 @@ static void *vcpu_worker(void *data)
>  	return NULL;
>  }
>  
> -static void vm_dirty_log_verify(unsigned long *bmap)
> +static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  {
> +	uint64_t step = vm_num_host_pages(mode, 1);
>  	uint64_t page;
>  	uint64_t *value_ptr;
> -	uint64_t step = host_page_size >= guest_page_size ? 1 :
> -				guest_page_size / host_page_size;
>  
>  	for (page = 0; page < host_num_pages; page += step) {
>  		value_ptr = host_test_mem + page * host_page_size;
> @@ -291,14 +290,14 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	 * case where the size is not aligned to 64 pages.
>  	 */
>  	guest_num_pages = (1ul << (DIRTY_MEM_BITS -
> -				   vm_get_page_shift(vm))) + 16;
> +				   vm_get_page_shift(vm))) + 3;
> +	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
>  #ifdef __s390x__
>  	/* Round up to multiple of 1M (segment size) */
>  	guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
>  #endif
>  	host_page_size = getpagesize();
> -	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
> -			 !!((guest_num_pages * guest_page_size) % host_page_size);
> +	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>  
>  	if (!phys_offset) {
>  		guest_test_phys_mem = (vm_get_max_gfn(vm) -
> @@ -369,7 +368,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
>  				       host_num_pages);
>  #endif
> -		vm_dirty_log_verify(bmap);
> +		vm_dirty_log_verify(mode, bmap);
>  		iteration++;
>  		sync_global_to_guest(vm, iteration);
>  	}
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 45c6c7ea24c5..bc7c67913fe0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -158,6 +158,14 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
>  unsigned int vm_get_page_shift(struct kvm_vm *vm);
>  unsigned int vm_get_max_gfn(struct kvm_vm *vm);
>  
> +unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
> +unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages);
> +static inline unsigned int
> +vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
> +{
> +	return vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
> +}
> +
>  struct kvm_userspace_memory_region *
>  kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  				 uint64_t end);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index c921ea719ae0..a60cf4ffcc3b 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -19,6 +19,8 @@
>  #include <fcntl.h>
>  #include "kselftest.h"
>  
> +#define getpageshift() (__builtin_ffs(getpagesize()) - 1)
> +
>  static inline int _no_printf(const char *format, ...) { return 0; }
>  
>  #ifdef DEBUG
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5e26e24bd609..44f1ef064085 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -583,6 +583,10 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  	size_t huge_page_size = KVM_UTIL_PGS_PER_HUGEPG * vm->page_size;
>  	size_t alignment;
>  
> +	TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages,
> +		"Number of guest pages is not compatible with the host. "
> +		"Try npages=%d", vm_adjust_num_guest_pages(vm->mode, npages));
> +
>  	TEST_ASSERT((guest_paddr % vm->page_size) == 0, "Guest physical "
>  		"address not on a page boundary.\n"
>  		"  guest_paddr: 0x%lx vm->page_size: 0x%x",
> @@ -1718,3 +1722,31 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
>  {
>  	return vm->max_gfn;
>  }
> +
> +static unsigned int vm_calc_num_pages(unsigned int num_pages,
> +				      unsigned int page_shift,
> +				      unsigned int new_page_shift,
> +				      bool ceil)
> +{
> +	unsigned int n = 1 << (new_page_shift - page_shift);
> +
> +	if (page_shift >= new_page_shift)
> +		return num_pages * (1 << (page_shift - new_page_shift));
> +
> +	return num_pages / n + !!(ceil && num_pages % n);
> +}
> +
> +unsigned int
> +vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
> +{
> +	return vm_calc_num_pages(num_guest_pages,
> +				 vm_guest_mode_params[mode].page_shift,
> +				 getpageshift(), true);
> +}
> +
> +unsigned int
> +vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages)
> +{
> +	return vm_calc_num_pages(num_host_pages, getpageshift(),
> +				 vm_guest_mode_params[mode].page_shift, false);
> +}
> 

