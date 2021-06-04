Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA7539BD9B
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 18:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhFDQvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 12:51:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhFDQvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 12:51:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Gi6rT105323;
        Fri, 4 Jun 2021 16:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NqplpJX7bQoiRI0Mw7vbdx3oy3DueL3Lt5kMEdsimUA=;
 b=FC3xPaGp3x+/R9QSEEOU7I6xOXn83D/pJ4PGB5K8RB38uAHa7xXHH+2htJwHhPzfls3M
 pUMMG8ym6Uumj59zP7biwAAbbvCIEaLSUzg2jmXHCyG7DoY2qShkvneNiky11yka/P2e
 CFRTkJZrRiaxj2Az4Iy8SCJ0MFrJJ7p1JiIAeU5wGd6a4Nq3W/pO1sgIT5DIv/1ITZzc
 7z16QAHGPxE/5a4m+avCGjSs/fqUJdDuQrp+bJZbmSyaDcFQGnJvyceFOBPFoDqrYAly
 br6yE2C4yZb/zq3+OfdQyaemgZ9uq+vlbvUpKPw5UMwWSeL6iTHPsCvdnaZIDj2Bp0nM Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38ud1spdvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 16:49:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154GkeWq173168;
        Fri, 4 Jun 2021 16:49:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 38ubnfu3jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 16:49:19 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 154GnIsO021497;
        Fri, 4 Jun 2021 16:49:18 GMT
Received: from [10.175.182.238] (/10.175.182.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Jun 2021 09:49:18 -0700
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: selftests: kvm: allocating extra mem in slot 0 (Was: Re: [PATCH]
 selftests: kvm: fix overlapping addresses in memslot_perf_test)
To:     "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>
References: <20210528191134.3740950-1-pbonzini@redhat.com>
 <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
 <fc41bfc4-949f-03c5-3b20-2c1563ad7f62@redhat.com>
 <73511f2e-7b5d-0d29-b8dc-9cb16675afb3@oracle.com>
 <68bda0ef-b58f-c335-a0c7-96186cbad535@oracle.com>
 <DM8PR11MB5670B1AA392BF7502501D43B923C9@DM8PR11MB5670.namprd11.prod.outlook.com>
 <20210603123759.ovlgws3ycnem4t3d@gator.home>
 <8800fc7a-4501-12f7-ed15-26ea5db41df8@oracle.com>
 <DM8PR11MB5670CF4237FE0DF804C3AA8D923B9@DM8PR11MB5670.namprd11.prod.outlook.com>
Message-ID: <a598cd40-31af-158f-d879-b302de7a44d3@oracle.com>
Date:   Fri, 4 Jun 2021 18:49:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <DM8PR11MB5670CF4237FE0DF804C3AA8D923B9@DM8PR11MB5670.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040120
X-Proofpoint-ORIG-GUID: 17_ooyqT7YjOBbIjZZsF19aXgYxw5E2d
X-Proofpoint-GUID: 17_ooyqT7YjOBbIjZZsF19aXgYxw5E2d
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.06.2021 05:35, Duan, Zhenzhong wrote:
>> -----Original Message-----
>> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> Sent: Thursday, June 3, 2021 9:06 PM
>> To: Andrew Jones <drjones@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; Duan, Zhenzhong <zhenzhong.duan@intel.com>
>> Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
>> memslot_perf_test
>>
>> On 03.06.2021 14:37, Andrew Jones wrote:
>>> On Thu, Jun 03, 2021 at 05:26:33AM +0000, Duan, Zhenzhong wrote:
>>>>> -----Original Message-----
>>>>> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>>>> Sent: Thursday, June 3, 2021 7:07 AM
>>>>> To: Paolo Bonzini <pbonzini@redhat.com>; Duan, Zhenzhong
>>>>> <zhenzhong.duan@intel.com>
>>>>> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Andrew Jones
>>>>> <drjones@redhat.com>
>>>>> Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
>>>>> memslot_perf_test
>>>>>
>>>>> On 30.05.2021 01:13, Maciej S. Szmigiero wrote:
>>>>>> On 29.05.2021 12:20, Paolo Bonzini wrote:
>>>>>>> On 28/05/21 21:51, Maciej S. Szmigiero wrote:
>>>>>>>> On 28.05.2021 21:11, Paolo Bonzini wrote:
>>>>>>>>> The memory that is allocated in vm_create is already mapped
>>>>>>>>> close to GPA 0, because test_execute passes the requested memory
>>>>>>>>> to prepare_vm.  This causes overlapping memory regions and the
>>>>>>>>> test crashes.  For simplicity just move MEM_GPA higher.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>>>>>
>>>>>>>> I am not sure that I understand the issue correctly, is
>>>>>>>> vm_create_default() already reserving low GPAs (around
>>>>>>>> 0x10000000) on some arches or run environments?
>>>>>>>
>>>>>>> It maps the number of pages you pass in the second argument, see
>>>>>>> vm_create.
>>>>>>>
>>>>>>>      if (phy_pages != 0)
>>>>>>>        vm_userspace_mem_region_add(vm,
>> VM_MEM_SRC_ANONYMOUS,
>>>>>>>                                    0, 0, phy_pages, 0);
>>>>>>>
>>>>>>> In this case:
>>>>>>>
>>>>>>>      data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
>>>>>>>
>>>>>>> called here:
>>>>>>>
>>>>>>>      if (!prepare_vm(data, nslots, maxslots, tdata->guest_code,
>>>>>>>                      mem_size, slot_runtime)) {
>>>>>>>
>>>>>>> where mempages is mem_size, which is declared as:
>>>>>>>
>>>>>>>            uint64_t mem_size = tdata->mem_size ? : MEM_SIZE_PAGES;
>>>>>>>
>>>>>>> but actually a better fix is just to pass a small fixed value (e.g.
>>>>>>> 1024) to vm_create_default, since all other regions are added by
>>>>>>> hand
>>>>>>
>>>>>> Yes, but the argument that is passed to vm_create_default()
>>>>>> (mem_size in the case of the test) is not passed as phy_pages to
>> vm_create().
>>>>>> Rather, vm_create_with_vcpus() calculates some upper bound of extra
>>>>>> memory that is needed to cover that much guest memory (including
>>>>>> for its page tables).
>>>>>>
>>>>>> The biggest possible mem_size from memslot_perf_test is 512 MiB + 1
>>>>>> page, according to my calculations this results in phy_pages of
>>>>>> 1029
>>>>>> (~4 MiB) in the x86-64 case and around 1540 (~6 MiB) in the s390x
>>>>>> case (here I am not sure about the exact number, since s390x has
>>>>>> some additional alignment requirements).
>>>>>>
>>>>>> Both values are well below 256 MiB (0x10000000UL), so I was
>>>>>> wondering what kind of circumstances can make these allocations
>>>>>> collide (maybe I am missing something in my analysis).
>>>>>
>>>>> I see now that there has been a patch merged last week called
>>>>> "selftests: kvm: make allocation of extra memory take effect" by
>>>>> Zhenzhong that now allocates also the whole memory size passed to
>>>>> vm_create_default() (instead of just page tables for that much memory).
>>>>>
>>>>> The commit message of this patch says that "perf_test_util and
>>>>> kvm_page_table_test use it to alloc extra memory currently", however
>>>>> both kvm_page_table_test and lib/perf_test_util framework explicitly
>>>>> add the required memory allocation by doing a
>>>>> vm_userspace_mem_region_add() call for the same memory size that
>> they pass to vm_create_default().
>>>>>
>>>>> So now they allocate this memory twice.
>>>>>
>>>>> @Zhenzhong: did you notice improper operation of either
>>>>> kvm_page_table_test or perf_test_util-based tests
>>>>> (demand_paging_test, dirty_log_perf_test,
>>>>> memslot_modification_stress_test) before your patch?
>>>> No
>>>>
>>>>>
>>>>> They seem to work fine for me without the patch (and I guess other
>>>>> people would have noticed earlier, too, if they were broken).
>>>>>
>>>>> After this patch not only these tests allocate their memory twice
>>>>> but it is harder to make vm_create_default() allocate the right
>>>>> amount of memory for the page tables in cases where the test needs
>>>>> to explicitly use
>>>>> vm_userspace_mem_region_add() for its allocations (because it wants
>>>>> the allocation placed at a specific GPA or in a specific memslot).
>>>>>
>>>>> One has to basically open-code the page table size calculations from
>>>>> vm_create_with_vcpus() in the particular test then, taking also into
>>>>> account that vm_create_with_vcpus() will not only allocate the
>>>>> passed memory size (calculated page tables size) but also behave
>>>>> like it was allocating space for page tables for these page tables
>>>>> (even though the passed memory size itself is supposed to cover them).
>>>> Looks we have different understanding to the parameter
>> extra_mem_pages of vm_create_default().
>>>>
>>>> In your usage, extra_mem_pages is only used for page table
>>>> calculations, real extra memory allocation happens in the extra call of
>> vm_userspace_mem_region_add().
>>>
>>> Yes, this is the meaning that kvm selftests has always had for
>>> extra_mem_pages of vm_create_default(). If we'd rather have a
>>> different meaning, that's fine, but we need to change all the callers
>>> of the function as well.
>>
>> If we change the meaning of extra_mem_pages (keep the patch) it would be
>> good to still have an additional parameter to vm_create_with_vcpus() for
>> tests that have to allocate their memory on their own via
>> vm_userspace_mem_region_add() for vm_create_with_vcpus() to just
>> allocate the page tables for these manual allocations.
>> Or a helper to calculate the required extra_mem_pages for them.
>>
>>> If we decide to leave vm_create_default() the way it was by reverting
>>> this patch, then maybe we should consider renaming the parameter
>>> and/or documenting the function.
>>
>> Adding a descriptive comment (and possibly renaming the parameter) seems
>> like a much simpler solution to me that adapting these tests (and possibly
>> adding the parameter or helper described above for them).
> 
> Agree, I prefer the simpler way.
> 
> I also think of an idea for custom slot0 memory, keep extra_mem_pages the original way, adding a global slot0_pages for custom slot0 memory. Maybe not a good choice as it's not thread safe, just for discussion. That is:
> 1. revert "selftests: kvm: make allocation of extra memory take effect"
> 2. add below patch
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -280,6 +280,9 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>   struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
>                                   void *guest_code);
> 
> +struct kvm_vm *vm_create_slot0(uint32_t vcpuid, uint64_t slot0_mem_pages,
> +                              uint64_t extra_mem_pages, void *guest_code);
> +
>   /* Same as vm_create_default, but can be used for more than one vcpu */
>   struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
>                                              uint32_t num_percpu_pages, void *guest_code,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 63418df921f0..56b1225865d5 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -196,6 +196,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>   _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>                 "Missing new mode params?");
> 
> +uint64_t slot0_pages = DEFAULT_GUEST_PHY_PAGES;
>   /*
>    * VM Create
>    *
> @@ -319,8 +320,8 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>           * than N/x*2.
>           */
>          uint64_t vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
> -       uint64_t extra_pg_pages = (extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> -       uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
> +       uint64_t extra_pg_pages = (slot0_pages + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> +       uint64_t pages = slot0_pages + vcpu_pages + extra_pg_pages;
>          struct kvm_vm *vm;
>          int i;
> 
> @@ -358,9 +359,18 @@ struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_me
>                                      num_percpu_pages, guest_code, vcpuids);
>   }
> 
> +struct kvm_vm *vm_create_slot0(uint32_t vcpuid, uint64_t slot0_mem_pages,
> +                                      uint64_t extra_mem_pages, void *guest_code)
> +{
> +       slot0_pages = slot0_mem_pages;
> +       return vm_create_default_with_vcpus(1, extra_mem_pages, 0, guest_code,
> +                                           (uint32_t []){ vcpuid });
> +}
> +
>   struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
>                                   void *guest_code)
>   {
> +       slot0_pages = DEFAULT_GUEST_PHY_PAGES;
>          return vm_create_default_with_vcpus(1, extra_mem_pages, 0, guest_code,
>                                              (uint32_t []){ vcpuid });
>   }
> @@ -626,6 +636,9 @@ void kvm_vm_free(struct kvm_vm *vmp)
> 
>          /* Free the structure describing the VM. */
>          free(vmp);
> +
> +       /* Restore slot0 memory to default size for next VM creation */
> +       slot0_pages = DEFAULT_GUEST_PHY_PAGES;
>   }
> 
>   /*

In terms of thread safety a quick glance at current tests seems to
suggest that none of them create VMs from anything but their main
threads (although s90x diag318 handler for sync_regs_test does some
suspicious stuff).

But I think a better solution than adding a global variable as an implicit
parameter to vm_create_with_vcpus() is to simply add an extra explicit
parameter to this function - it has just 3 callers that need to be
(trivially) adapted then.

> Thanks
> Zhenzhong
> 

Thanks,
Maciej
