Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6BF39A1CC
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFCNHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 09:07:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhFCNHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 09:07:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153D5oFI157982;
        Thu, 3 Jun 2021 13:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=G8xPxbKxZCNiDrkaN4F7yieu1lvx7sl5dhCWSaNWPqk=;
 b=i8Ph+58yNv3HaGBi9R+dFgeKyYgUBqrqNhjpZGR+zFApk0vrXHQqH0O4uWRTQ5i9BEHh
 4owhCuPY8bGiVlP6gN0XotwXM5JdcrVWfx3ZByoFuN2DCKcZ+tVHArwadMw3JnepX1jJ
 4sZO/2SGkzZjG7XTA/N+/GdV2x1mPHB46M4htoY1QhjCrFagN+nvyGWSonqXj8MaM1r1
 lxHalzLne4BloJwJp7trMynW+oyNiKXyif+oNC5m9jSmIFvA+1FAZxbJFC7G7nN7NxHn
 0zOvRB18aEpBQLU6Wy9MMumdye18LhK8eaXZ7LI+jGe/1ws2y1WkAFGodyQyF2l78UIP ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38udjmu9xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 13:05:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153D0585122614;
        Thu, 3 Jun 2021 13:05:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 38uaqy96cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 13:05:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 153D5mOH021933;
        Thu, 3 Jun 2021 13:05:48 GMT
Received: from [10.175.187.218] (/10.175.187.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jun 2021 06:05:48 -0700
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
 memslot_perf_test
To:     "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210528191134.3740950-1-pbonzini@redhat.com>
 <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
 <fc41bfc4-949f-03c5-3b20-2c1563ad7f62@redhat.com>
 <73511f2e-7b5d-0d29-b8dc-9cb16675afb3@oracle.com>
 <68bda0ef-b58f-c335-a0c7-96186cbad535@oracle.com>
 <DM8PR11MB5670B1AA392BF7502501D43B923C9@DM8PR11MB5670.namprd11.prod.outlook.com>
Message-ID: <de413189-b0c8-df1a-a0f5-e3fea1a329f8@oracle.com>
Date:   Thu, 3 Jun 2021 15:05:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <DM8PR11MB5670B1AA392BF7502501D43B923C9@DM8PR11MB5670.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030089
X-Proofpoint-GUID: JE3KpXmeBbgsMa66XmWzpsT1H_UJLWYM
X-Proofpoint-ORIG-GUID: JE3KpXmeBbgsMa66XmWzpsT1H_UJLWYM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.06.2021 07:26, Duan, Zhenzhong wrote:
>> -----Original Message-----
>> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> Sent: Thursday, June 3, 2021 7:07 AM
>> To: Paolo Bonzini <pbonzini@redhat.com>; Duan, Zhenzhong
>> <zhenzhong.duan@intel.com>
>> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Andrew Jones
>> <drjones@redhat.com>
>> Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
>> memslot_perf_test
>>
>> On 30.05.2021 01:13, Maciej S. Szmigiero wrote:
>>> On 29.05.2021 12:20, Paolo Bonzini wrote:
>>>> On 28/05/21 21:51, Maciej S. Szmigiero wrote:
>>>>> On 28.05.2021 21:11, Paolo Bonzini wrote:
>>>>>> The memory that is allocated in vm_create is already mapped close
>>>>>> to GPA 0, because test_execute passes the requested memory to
>>>>>> prepare_vm.  This causes overlapping memory regions and the test
>>>>>> crashes.  For simplicity just move MEM_GPA higher.
>>>>>>
>>>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>>
>>>>> I am not sure that I understand the issue correctly, is
>>>>> vm_create_default() already reserving low GPAs (around 0x10000000)
>>>>> on some arches or run environments?
>>>>
>>>> It maps the number of pages you pass in the second argument, see
>>>> vm_create.
>>>>
>>>>     if (phy_pages != 0)
>>>>       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
>>>>                                   0, 0, phy_pages, 0);
>>>>
>>>> In this case:
>>>>
>>>>     data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
>>>>
>>>> called here:
>>>>
>>>>     if (!prepare_vm(data, nslots, maxslots, tdata->guest_code,
>>>>                     mem_size, slot_runtime)) {
>>>>
>>>> where mempages is mem_size, which is declared as:
>>>>
>>>>           uint64_t mem_size = tdata->mem_size ? : MEM_SIZE_PAGES;
>>>>
>>>> but actually a better fix is just to pass a small fixed value (e.g.
>>>> 1024) to vm_create_default, since all other regions are added by hand
>>>
>>> Yes, but the argument that is passed to vm_create_default() (mem_size
>>> in the case of the test) is not passed as phy_pages to vm_create().
>>> Rather, vm_create_with_vcpus() calculates some upper bound of extra
>>> memory that is needed to cover that much guest memory (including for
>>> its page tables).
>>>
>>> The biggest possible mem_size from memslot_perf_test is 512 MiB + 1
>>> page, according to my calculations this results in phy_pages of 1029
>>> (~4 MiB) in the x86-64 case and around 1540 (~6 MiB) in the s390x case
>>> (here I am not sure about the exact number, since s390x has some
>>> additional alignment requirements).
>>>
>>> Both values are well below 256 MiB (0x10000000UL), so I was wondering
>>> what kind of circumstances can make these allocations collide (maybe I
>>> am missing something in my analysis).
>>
>> I see now that there has been a patch merged last week called
>> "selftests: kvm: make allocation of extra memory take effect" by Zhenzhong
>> that now allocates also the whole memory size passed to
>> vm_create_default() (instead of just page tables for that much memory).
>>
>> The commit message of this patch says that "perf_test_util and
>> kvm_page_table_test use it to alloc extra memory currently", however both
>> kvm_page_table_test and lib/perf_test_util framework explicitly add the
>> required memory allocation by doing a vm_userspace_mem_region_add()
>> call for the same memory size that they pass to vm_create_default().
>>
>> So now they allocate this memory twice.
>>
>> @Zhenzhong: did you notice improper operation of either
>> kvm_page_table_test or perf_test_util-based tests (demand_paging_test,
>> dirty_log_perf_test,
>> memslot_modification_stress_test) before your patch?
> No
> 
>>
>> They seem to work fine for me without the patch (and I guess other people
>> would have noticed earlier, too, if they were broken).
>>
>> After this patch not only these tests allocate their memory twice but it is
>> harder to make vm_create_default() allocate the right amount of memory for
>> the page tables in cases where the test needs to explicitly use
>> vm_userspace_mem_region_add() for its allocations (because it wants the
>> allocation placed at a specific GPA or in a specific memslot).
>>
>> One has to basically open-code the page table size calculations from
>> vm_create_with_vcpus() in the particular test then, taking also into account
>> that vm_create_with_vcpus() will not only allocate the passed memory size
>> (calculated page tables size) but also behave like it was allocating space for
>> page tables for these page tables (even though the passed memory size itself
>> is supposed to cover them).
> Looks we have different understanding to the parameter extra_mem_pages of vm_create_default().
> 
> In your usage, extra_mem_pages is only used for page table calculations, real extra memory allocation
> happens in the extra call of vm_userspace_mem_region_add().
> 
> In my understanding, extra_mem_pages is used for a VM who wants a custom memory size in slot0,
> rather than the default DEFAULT_GUEST_PHY_PAGES size.
> 
> I understood your comments and do agree that my patch bring some trouble to your code, sorry for that.
> I'm fine to revert that patch and I think it's better to let the maintainers to decide what extra_mem_pages
> Is used for.

No problem, I just noticed the inconsistent behavior.
I've coded memslot_perf_test to the old one (like other tests are) and
was surprised there were guest memory allocation collisions.

> Thanks
> Zhenzhong

Thanks,
Maciej
