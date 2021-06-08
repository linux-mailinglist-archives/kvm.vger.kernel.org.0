Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DE839F0AF
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFHIV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:21:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhFHIV2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 04:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623140375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VYofGLMdJz0x7TQAB9W/n0hJPFjc2qioUswn197Rpmg=;
        b=fcwJ51ogu2v/4V8rCdemcc7+gBOsjIlxPEcmK+dphrRJk0D2fUiZ4fd7FZYCJQBbm3+O+0
        MSMps7k5hEKUaoupAfp2Yhr+n+oNsetfPMQUpjVF5QDfWcJg+V1yfX2GSCyhoei/WEIO37
        pLwWuceElg74MeK1NdDt/NITO1qaoQ4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-7UHcrVVVPC2F60fPEycNgA-1; Tue, 08 Jun 2021 04:19:34 -0400
X-MC-Unique: 7UHcrVVVPC2F60fPEycNgA-1
Received: by mail-wm1-f71.google.com with SMTP id n8-20020a05600c3b88b02901b6e5bcd841so37568wms.9
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 01:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VYofGLMdJz0x7TQAB9W/n0hJPFjc2qioUswn197Rpmg=;
        b=go1q9Lcq8WO/tXNDMhl3MToEJt4shFqqz+vLxsM8cEceZDcF3dpwafEowBYMqVTNyk
         2x/p8wKMlM+V1RWz1bS9TeT29kgR7QXVKD3tiRU+GsckDzMtjAQp9sXGUWCfcBMNnT7F
         ZNNmvGJl/TmG1Myotbubv22zlmCffiKWCswILpZ5cLN8Dhm8ahNAyvijLP6au1pjlMyS
         3OG7WwhzYcNncDgvlOuFrmvguRO7o6XTRRg9aebqFH4pTuh4NP1DJo4iEl3fQf/GCPCe
         4uqk77SPzpHnHEVbcsFCcKJ0V1xO4VEdA2H46O73Ho6EpjpJ8tDoDb5iX/8dDWDlbpD+
         CukQ==
X-Gm-Message-State: AOAM533QaEFMzXMXMmVskccuCt+8yBGG+KaUjWRi++AbLfLKqi/TXAQL
        jCxtpWXr4JwqDs72J3KcFwMTU9ZeqvdV7zCcE3T3h9OepC6K3olc/RrIFQW119QgR2OLp9yjpso
        S2oV6fUYR6sK/
X-Received: by 2002:a1c:dcd7:: with SMTP id t206mr20193297wmg.121.1623140372913;
        Tue, 08 Jun 2021 01:19:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi8gxqmjvw40rudPWWCg7DHIKvxwJzLSnbmTUYj9lv4cEdff36HtynMr0vaDuuGYT4gT3EzA==
X-Received: by 2002:a1c:dcd7:: with SMTP id t206mr20193275wmg.121.1623140372579;
        Tue, 08 Jun 2021 01:19:32 -0700 (PDT)
Received: from gator (93-137-73-41.adsl.net.t-com.hr. [93.137.73.41])
        by smtp.gmail.com with ESMTPSA id h9sm2099406wmm.33.2021.06.08.01.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 01:19:32 -0700 (PDT)
Date:   Tue, 8 Jun 2021 10:19:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, maciej.szmigiero@oracle.com,
        pbonzini@redhat.com, shuah@kernel.org
Subject: Re: [PATCH 3/3] selftests: kvm: Add support for customized slot0
 memory size
Message-ID: <20210608081929.6jyzcv4y4e7aqxa3@gator>
References: <20210608233816.423958-1-zhenzhong.duan@intel.com>
 <20210608233816.423958-4-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608233816.423958-4-zhenzhong.duan@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 07:38:16AM +0800, Zhenzhong Duan wrote:
> Current implementatiion only create VM with slot0 memory size
> of fixed 512 pages plus page tables and per-cpu memory.
> 
> Add a new parameter slot0_mem_pages to vm_create_with_vcpus() and
> some comments to clarify the meaning of slot0_mem_pages and
> extra_mem_pages.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  7 +--
>  .../selftests/kvm/kvm_page_table_test.c       |  2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 47 +++++++++++++++----
>  .../selftests/kvm/lib/perf_test_util.c        |  2 +-
>  4 files changed, 44 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index fcd8e3855111..8bcadfa8cea5 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -285,10 +285,11 @@ struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_me
>  					    uint32_t num_percpu_pages, void *guest_code,
>  					    uint32_t vcpuids[]);
>  
> -/* Like vm_create_default_with_vcpus, but accepts mode as a parameter */
> +/* Like vm_create_default_with_vcpus, but accepts mode and slot0 memory as a parameter */
>  struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
> -				    uint64_t extra_mem_pages, uint32_t num_percpu_pages,
> -				    void *guest_code, uint32_t vcpuids[]);
> +				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
> +				    uint32_t num_percpu_pages, void *guest_code,
> +				    uint32_t vcpuids[]);
>  
>  /*
>   * Adds a vCPU with reasonable defaults (e.g. a stack)
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> index 1c4753fff19e..82171f17c1d7 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -268,7 +268,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
>  
>  	/* Create a VM with enough guest pages */
>  	guest_num_pages = test_mem_size / guest_page_size;
> -	vm = vm_create_with_vcpus(mode, nr_vcpus,
> +	vm = vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
>  				  guest_num_pages, 0, guest_code, NULL);
>  
>  	/* Align down GPA of the testing memslot */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 63418df921f0..d86422a119fd 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -308,21 +308,50 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  	return vm;
>  }
>  
> +/*
> + * VM Create with customized parameters
> + *
> + * Input Args:
> + *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
> + *   nr_vcpus - VCPU count
> + *   slot0_mem_pages - Slot0 physical memory size
> + *   extra_mem_pages - Non-slot0 physical memory total size
> + *   num_percpu_pages - Per-cpu physical memory pages
> + *   guest_code - Guest entry point
> + *   vcpuids - VCPU IDs
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Pointer to opaque structure that describes the created VM.
> + *
> + * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K),
> + * with customized slot0 memory size, at least 512 pages currently.
> + * extra_mem_pages is only used to calculate the maximum page table size,
> + * no real memory allocation for non-slot0 memory in this function.
> + */
>  struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
> -				    uint64_t extra_mem_pages, uint32_t num_percpu_pages,
> -				    void *guest_code, uint32_t vcpuids[])
> +				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
> +				    uint32_t num_percpu_pages, void *guest_code,
> +				    uint32_t vcpuids[])
>  {
> +	uint64_t vcpu_pages, extra_pg_pages, pages;
> +	struct kvm_vm *vm;
> +	int i;
> +
> +	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
> +	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
> +		slot0_mem_pages = DEFAULT_GUEST_PHY_PAGES;
> +
>  	/* The maximum page table size for a memory region will be when the
>  	 * smallest pages are used. Considering each page contains x page
>  	 * table descriptors, the total extra size for page tables (for extra
>  	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
>  	 * than N/x*2.
>  	 */
> -	uint64_t vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
> -	uint64_t extra_pg_pages = (extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> -	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
> -	struct kvm_vm *vm;
> -	int i;
> +	vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
> +	extra_pg_pages = (slot0_mem_pages + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;

We weren't including the slot0 memory (which was DEFAULT_GUEST_PHY_PAGES)
in the extra_pg_pages calculation before, since they weren't considered
"extra". It's probably a good idea to do this calculation for the caller,
but it's making a change not called out in the commit message.

> +	pages = slot0_mem_pages + vcpu_pages + extra_pg_pages;
>  
>  	TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
>  		    "nr_vcpus = %d too large for host, max-vcpus = %d",
> @@ -354,8 +383,8 @@ struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_me
>  					    uint32_t num_percpu_pages, void *guest_code,
>  					    uint32_t vcpuids[])
>  {
> -	return vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, extra_mem_pages,
> -				    num_percpu_pages, guest_code, vcpuids);
> +	return vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
> +				    extra_mem_pages, num_percpu_pages, guest_code, vcpuids);
>  }
>  
>  struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index abf381800a59..7397ca299835 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -69,7 +69,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
>  		    "Guest memory size is not guest page size aligned.");
>  
> -	vm = vm_create_with_vcpus(mode, vcpus,
> +	vm = vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
>  				  (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
>  				  0, guest_code, NULL);
>  
> -- 
> 2.25.1
>

Besides the extra_pg_pages comment

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew 

