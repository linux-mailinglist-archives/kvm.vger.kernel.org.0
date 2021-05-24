Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5008C38E69E
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhEXMcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:32:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232456AbhEXMcH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fq0Z2MgWlbAQmzdaXY7w+OdhQ82ycArwFgcIADS+NT8=;
        b=VCoM0WSxFp77Y9uZWB+2fdgdckHX38/t6YocaHfHCwUPxXhoIOt1A1pcBKwHK/mO2QFf6m
        MxMFxTJrzJO8ZoXCkX96NuiT7tOZVJZijIht2p0b5TxCkfmdPzTDf1S6anUAfjlGYqeVpn
        as9sIIYGEikJxpKfVoMr8VULAf0CBCs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-DAjJob8PPvKrmehV2_jC2Q-1; Mon, 24 May 2021 08:30:37 -0400
X-MC-Unique: DAjJob8PPvKrmehV2_jC2Q-1
Received: by mail-ed1-f70.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so15472259edd.2
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fq0Z2MgWlbAQmzdaXY7w+OdhQ82ycArwFgcIADS+NT8=;
        b=quh3YYw1O7y+WjnjoFxh9gFEsJG5GiHCGQdXYQH/ntzbEsw1X6T+gnKgqLv6aHx5YH
         xeFkR45fNmF+nUXGKAS6ycQsCsjpyNLYeY3szTHxNOSrJzCB/Clpv9X3F1Xd1fEXsxaX
         sThR8DcAmfGXNFv6K1QLyizdvwIYgCXv1nts+He8IAQUuvMlcu1JTXwWNomGmmcGsnN0
         d/kScY5kcF16WoNFX/TzxEfV99HsTukUyN/Mflfnx6KP9FS9D2zz9hBbUIz0y0qkPKsX
         Oyt6RuRKMSS4zGDntP1q8jS7qpbQGT3AjGyj74AY+IC5znGnUBAZgJRJ3WDvBEcY7knG
         D6Ug==
X-Gm-Message-State: AOAM532n69ofC5gL8tBcfN/enRW2ZXdT3zD9nmFMRUn5YxST727sNhMY
        EQH/KaaWRxAsKfuVlFGD3MTQLfdYI5uOcR+bLJT3yE/9qz9fitFrwG/Fpu0E9Y3Eov+ZuTMH8U5
        wVeMcJU6epEge
X-Received: by 2002:a17:906:694b:: with SMTP id c11mr22459493ejs.420.1621859436722;
        Mon, 24 May 2021 05:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc4CU9e1Fnv5pJO6SKKgaaXiuNh+yH3wexv7MlQqmzaE287PDvr6wuqnwHMLbc1UxpakwozQ==
X-Received: by 2002:a17:906:694b:: with SMTP id c11mr22459475ejs.420.1621859436554;
        Mon, 24 May 2021 05:30:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o4sm9197317edq.25.2021.05.24.05.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:30:36 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: selftests: Fix 32-bit truncation of
 vm_get_max_gfn()
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     Andrew Jones <drjones@redhat.com>, Ben Gardon <bgardon@google.com>,
        Peter Xu <peterx@redhat.com>
References: <20210521173828.1180619-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <59e09f4c-e844-4e84-24a2-30b485e05e78@redhat.com>
Date:   Mon, 24 May 2021 14:30:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521173828.1180619-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 19:38, David Matlack wrote:
> vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
> which causes the upper 32-bits of the max_gfn to get truncated.
> 
> Nobody noticed until now likely because vm_get_max_gfn() is only used
> as a mechanism to create a memslot in an unused region of the guest
> physical address space (the top), and the top of the 32-bit physical
> address space was always good enough.
> 
> This fix reveals a bug in memslot_modification_stress_test which was
> trying to create a dummy memslot past the end of guest physical memory.
> Fix that by moving the dummy memslot lower.
> 
> Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> 
> v1 -> v2:
>   - Added Venkatesh's R-b line.
>   - Used PRIx64 to print uint64_t instead of %lx.
> 
>   tools/testing/selftests/kvm/include/kvm_util.h |  2 +-
>   tools/testing/selftests/kvm/lib/kvm_util.c     |  2 +-
>   .../testing/selftests/kvm/lib/perf_test_util.c |  4 +++-
>   .../kvm/memslot_modification_stress_test.c     | 18 +++++++++++-------
>   4 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 84982eb02b29..5d9b35d09251 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -303,7 +303,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
>   
>   unsigned int vm_get_page_size(struct kvm_vm *vm);
>   unsigned int vm_get_page_shift(struct kvm_vm *vm);
> -unsigned int vm_get_max_gfn(struct kvm_vm *vm);
> +uint64_t vm_get_max_gfn(struct kvm_vm *vm);
>   int vm_get_fd(struct kvm_vm *vm);
>   
>   unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1af1009254c4..aeffbb1e7c7d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2058,7 +2058,7 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
>   	return vm->page_shift;
>   }
>   
> -unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> +uint64_t vm_get_max_gfn(struct kvm_vm *vm)
>   {
>   	return vm->max_gfn;
>   }
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 81490b9b4e32..abf381800a59 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -2,6 +2,7 @@
>   /*
>    * Copyright (C) 2020, Google LLC.
>    */
> +#include <inttypes.h>
>   
>   #include "kvm_util.h"
>   #include "perf_test_util.h"
> @@ -80,7 +81,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>   	 */
>   	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
>   		    "Requested more guest memory than address space allows.\n"
> -		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
> +		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
> +		    " vcpus: %d wss: %" PRIx64 "]\n",
>   		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
>   		    vcpu_memory_bytes);
>   
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 6096bf0a5b34..98351ba0933c 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -71,14 +71,22 @@ struct memslot_antagonist_args {
>   };
>   
>   static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
> -			      uint64_t nr_modifications, uint64_t gpa)
> +			       uint64_t nr_modifications)
>   {
> +	const uint64_t pages = 1;
> +	uint64_t gpa;
>   	int i;
>   
> +	/*
> +	 * Add the dummy memslot just below the perf_test_util memslot, which is
> +	 * at the top of the guest physical address space.
> +	 */
> +	gpa = guest_test_phys_mem - pages * vm_get_page_size(vm);
> +
>   	for (i = 0; i < nr_modifications; i++) {
>   		usleep(delay);
>   		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
> -					    DUMMY_MEMSLOT_INDEX, 1, 0);
> +					    DUMMY_MEMSLOT_INDEX, pages, 0);
>   
>   		vm_mem_region_delete(vm, DUMMY_MEMSLOT_INDEX);
>   	}
> @@ -120,11 +128,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	pr_info("Started all vCPUs\n");
>   
>   	add_remove_memslot(vm, p->memslot_modification_delay,
> -			   p->nr_memslot_modifications,
> -			   guest_test_phys_mem +
> -			   (guest_percpu_mem_size * nr_vcpus) +
> -			   perf_test_args.host_page_size +
> -			   perf_test_args.guest_page_size);
> +			   p->nr_memslot_modifications);
>   
>   	run_vcpus = false;
>   
> 

Queued, thanks.

Paolo

