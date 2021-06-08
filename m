Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54FF39F119
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFHIlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:41:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFHIlW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 04:41:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1588ZnG8039520;
        Tue, 8 Jun 2021 04:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=geFK72XNIPfLAPJij4fFG/glYrSynGXZn6hoW4g9mQk=;
 b=Uon461dyhEVy8lUHELqHgk+7yy8OPAmO/83DM7X9lGur1Hvy+gvQN0l3ONvb19OUfTtB
 xtc3xaze98Hl9g4rqpCbgVj0PCLtNsA1gd9vvyUgKb7YLnenr/BX1a7Y03AH4+7RHoPj
 HeyF9oQ8XKp/zHpRRcKVlY0K9DLzMj7r2eM6jh+ZSPDvd5yj78G4h9d3fMfn2Q5gLE3x
 kBqbLRkVyu0neG8gR6RNyMLohQFSsZT9g4GarLOt1I6pJUoqKA79DBUimD+A2hiGsXGN
 2NrKZcQgUH5oYiPibVyqizuFIS1+BxH2BzTwlrujDIux2V0QdvBajRsIyk+8Scbf+xji 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39237wkbea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 04:39:28 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1588a1bF040312;
        Tue, 8 Jun 2021 04:39:28 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39237wkbdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 04:39:28 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1588WWZx011190;
        Tue, 8 Jun 2021 08:39:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3900w88s1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 08:39:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1588dN6329622748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 08:39:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54433A4053;
        Tue,  8 Jun 2021 08:39:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8CBAA4051;
        Tue,  8 Jun 2021 08:39:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.48.134])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Jun 2021 08:39:22 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: selftests: Fix 32-bit truncation of
 vm_get_max_gfn()
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>
References: <20210521173828.1180619-1-dmatlack@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <8cae6330-f88a-ec24-4e7d-bc999f49288d@de.ibm.com>
Date:   Tue, 8 Jun 2021 10:39:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521173828.1180619-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e1Allph93XTGqOEKk3a_EXr_CoS7w0yA
X-Proofpoint-GUID: GfrGbV_ibe1FWOyyNzFFS6yoprA0_s9t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_05:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21.05.21 19:38, David Matlack wrote:
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

As a heads up:
I have not yet looked into this, but this broke demand_paging_test and kvm_page_table_test
on s390:

not ok 4 selftests: kvm: demand_paging_test # exit=254
# selftests: kvm: dirty_log_test
# ==== Test Assertion Failure ====
#   lib/kvm_util.c:900: ret == 0
#   pid=245410 tid=245410 errno=22 - Invalid argument
#      1	0x0000000001005457: vm_userspace_mem_region_add at kvm_util.c:900
#      2	0x0000000001002cbf: run_test at dirty_log_test.c:757
#      3	 (inlined by) run_test at dirty_log_test.c:702
#      4	0x000000000100c055: for_each_guest_mode at guest_modes.c:37
#      5	0x00000000010022b5: main at dirty_log_test.c:929 (discriminator 3)
#      6	0x000003ff96fabdb3: ?? ??:0
#      7	0x000000000100241d: .annobin_lto.hot at crt1.o:?
#   KVM_SET_USER_MEMORY_REGION IOCTL failed,
#   rc: -1 errno: 22
#   slot: 1 flags: 0x1
#   guest_phys_addr: 0xfffffbfe00000 size: 0x40100000
# Test iterations: 32, interval: 10 (ms)
# Testing Log Mode 'dirty-log'
# Testing guest mode: PA-bits:52,  VA-bits:48,  4K pages
# guest physical test memory offset: 0xfffffbfe00000
not ok 5 selftests: kvm: dirty_log_test # exit=254
# selftests: kvm: kvm_create_max_vcpus
# KVM_CAP_MAX_VCPU_ID: 248
# KVM_CAP_MAX_VCPUS: 248
# Testing creating 248 vCPUs, with IDs 0...247.
ok 6 selftests: kvm: kvm_create_max_vcpus
# selftests: kvm: kvm_page_table_test
# ==== Test Assertion Failure ====
#   lib/kvm_util.c:900: ret == 0
#   pid=245454 tid=245454 errno=22 - Invalid argument
#      1	0x0000000001003e47: vm_userspace_mem_region_add at kvm_util.c:900
#      2	0x000000000100257d: pre_init_before_test at kvm_page_table_test.c:302
#      3	 (inlined by) run_test at kvm_page_table_test.c:374
#      4	0x000000000100aa45: for_each_guest_mode at guest_modes.c:37
#      5	0x0000000001001dd9: main at kvm_page_table_test.c:503
#      6	0x000003ff827abdb3: ?? ??:0
#      7	0x0000000001001e8d: .annobin_lto.hot at crt1.o:?
#   KVM_SET_USER_MEMORY_REGION IOCTL failed,
#   rc: -1 errno: 22
#   slot: 1 flags: 0x0
#   guest_phys_addr: 0xfffffbff00000 size: 0x40000000
not ok 7 selftests: kvm: kvm_page_table_test # exit=254


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
