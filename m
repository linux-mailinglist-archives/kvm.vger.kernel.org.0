Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD97601FE6
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 02:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiJRAwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 20:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiJRAwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 20:52:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234437B1C8
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 17:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666054321;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lch+0lg3n7TS+igKmtmFC8qqNbSDuMXa3xxdCzWFQyQ=;
        b=QzxjCllypU4Un0H4kFSg6Z14K9huJUTKqgesKY8hANp89S07B01Yi5brqMgYBuc4sJL0nW
        LoMWDbuZ0HqBEi2ckNm+rKoPMO5sXmSJVcg2DB1pZD2/3d8ZTLBbnEiZyNxrcm1pjDziXW
        CJFKL7pZ5LtQX6Ofh9xKie8yxfhnr8Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-b0g3CsSxPWelPq238NY-PQ-1; Mon, 17 Oct 2022 20:51:58 -0400
X-MC-Unique: b0g3CsSxPWelPq238NY-PQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9945E38012C3;
        Tue, 18 Oct 2022 00:51:57 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19C0B401D59;
        Tue, 18 Oct 2022 00:51:52 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable
 guest page size
From:   Gavin Shan <gshan@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
        pbonzini@redhat.com, shuah@kernel.org,
        kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-5-gshan@redhat.com>
 <3eecebca-a526-d10a-02d3-496ce919d577@maciej.szmigiero.name>
 <bd5df92c-6870-8053-0b35-a2ad993970bd@redhat.com>
Message-ID: <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
Date:   Tue, 18 Oct 2022 08:51:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <bd5df92c-6870-8053-0b35-a2ad993970bd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/22 8:46 AM, Gavin Shan wrote:
> On 10/18/22 5:31 AM, Maciej S. Szmigiero wrote:
>> On 14.10.2022 09:19, Gavin Shan wrote:
>>> The test case is obviously broken on aarch64 because non-4KB guest
>>> page size is supported. The guest page size on aarch64 could be 4KB,
>>> 16KB or 64KB.
>>>
>>> This supports variable guest page size, mostly for aarch64.
>>>
>>>    - The host determines the guest page size when virtual machine is
>>>      created. The value is also passed to guest through the synchronization
>>>      area.
>>>
>>>    - The number of guest pages are unknown until the virtual machine
>>>      is to be created. So all the related macros are dropped. Instead,
>>>      their values are dynamically calculated based on the guest page
>>>      size.
>>>
>>>    - The static checks on memory sizes and pages becomes dependent
>>>      on guest page size, which is unknown until the virtual machine
>>>      is about to be created. So all the static checks are converted
>>>      to dynamic checks, done in check_memory_sizes().
>>>
>>>    - As the address passed to madvise() should be aligned to host page,
>>>      the size of page chunk is automatically selected, other than one
>>>      page.
>>>
>>>    - All other changes included in this patch are almost mechanical
>>>      replacing '4096' with 'guest_page_size'.
>>>
>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>> ---
>>>   .../testing/selftests/kvm/memslot_perf_test.c | 191 +++++++++++-------
>>>   1 file changed, 115 insertions(+), 76 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>>> index d5aa9148f96f..d587bd952ff9 100644
>>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
>>> @@ -26,14 +26,11 @@
>>>   #include <processor.h>
>>>   #define MEM_SIZE        ((512U << 20) + 4096)
>>> -#define MEM_SIZE_PAGES        (MEM_SIZE / 4096)
>>>   #define MEM_GPA        0x10000000UL
>>>   #define MEM_AUX_GPA        MEM_GPA
>>>   #define MEM_SYNC_GPA        MEM_AUX_GPA
>>>   #define MEM_TEST_GPA        (MEM_AUX_GPA + 4096)
>>>   #define MEM_TEST_SIZE        (MEM_SIZE - 4096)
>>> -static_assert(MEM_SIZE % 4096 == 0, "invalid mem size");
>>> -static_assert(MEM_TEST_SIZE % 4096 == 0, "invalid mem test size");
>>>   /*
>>>    * 32 MiB is max size that gets well over 100 iterations on 509 slots.
>>> @@ -42,29 +39,16 @@ static_assert(MEM_TEST_SIZE % 4096 == 0, "invalid mem test size");
>>>    * limited resolution).
>>>    */
>>>   #define MEM_SIZE_MAP        ((32U << 20) + 4096)
>>> -#define MEM_SIZE_MAP_PAGES    (MEM_SIZE_MAP / 4096)
>>>   #define MEM_TEST_MAP_SIZE    (MEM_SIZE_MAP - 4096)
>>> -#define MEM_TEST_MAP_SIZE_PAGES (MEM_TEST_MAP_SIZE / 4096)
>>> -static_assert(MEM_SIZE_MAP % 4096 == 0, "invalid map test region size");
>>> -static_assert(MEM_TEST_MAP_SIZE % 4096 == 0, "invalid map test region size");
>>> -static_assert(MEM_TEST_MAP_SIZE_PAGES % 2 == 0, "invalid map test region size");
>>> -static_assert(MEM_TEST_MAP_SIZE_PAGES > 2, "invalid map test region size");
>>>   /*
>>>    * 128 MiB is min size that fills 32k slots with at least one page in each
>>>    * while at the same time gets 100+ iterations in such test
>>> + *
>>> + * 2 MiB chunk size like a typical huge page
>>>    */
>>>   #define MEM_TEST_UNMAP_SIZE        (128U << 20)
>>> -#define MEM_TEST_UNMAP_SIZE_PAGES    (MEM_TEST_UNMAP_SIZE / 4096)
>>> -/* 2 MiB chunk size like a typical huge page */
>>> -#define MEM_TEST_UNMAP_CHUNK_PAGES    (2U << (20 - 12))
>>> -static_assert(MEM_TEST_UNMAP_SIZE <= MEM_TEST_SIZE,
>>> -          "invalid unmap test region size");
>>> -static_assert(MEM_TEST_UNMAP_SIZE % 4096 == 0,
>>> -          "invalid unmap test region size");
>>> -static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
>>> -          (2 * MEM_TEST_UNMAP_CHUNK_PAGES) == 0,
>>> -          "invalid unmap test region size");
>>> +#define MEM_TEST_UNMAP_CHUNK_SIZE    (2U << 20)
>>>   /*
>>>    * For the move active test the middle of the test area is placed on
>>> @@ -77,8 +61,7 @@ static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
>>>    * for the total size of 25 pages.
>>>    * Hence, the maximum size here is 50 pages.
>>>    */
>>> -#define MEM_TEST_MOVE_SIZE_PAGES    (50)
>>> -#define MEM_TEST_MOVE_SIZE        (MEM_TEST_MOVE_SIZE_PAGES * 4096)
>>> +#define MEM_TEST_MOVE_SIZE        0x32000
>>
>> The above number seems less readable than an explicit value of 50 pages.
>>
>> In addition to that, it's 50 pages only with 4k page size, so at least
>> the comment above needs to be updated to reflect this fact.
>>
> 
> Yeah, I will change the comments like below in next revision.
> 
>   /*
>    * When running this test with 32k memslots, actually 32763 excluding
>    * the reserved memory slot 0, the memory for each slot is 0x4000 bytes.
>    * The last slot contains 0x19000 bytes memory. Hence, the maximum size
>    * here is 0x32000 bytes.
>    */
> 

I will replace those numbers with readable ones like below :)

/*
  * When running this test with 32k memslots, actually 32763 excluding
  * the reserved memory slot 0, the memory for each slot is 16KB. The
  * last slot contains 100KB memory with the remaining 84KB. Hence,
  * the maximum size is double of that (200KB)
  */

>>>   #define MEM_TEST_MOVE_GPA_DEST        (MEM_GPA + MEM_SIZE)
>>>   static_assert(MEM_TEST_MOVE_SIZE <= MEM_TEST_SIZE,
>>>             "invalid move test region size");
>> (...)
>>> @@ -242,33 +229,34 @@ static struct vm_data *alloc_vm(void)
>>>   }
>>>   static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
>>> -               void *guest_code, uint64_t mempages,
>>> +               void *guest_code, uint64_t mem_size,
>>>                  struct timespec *slot_runtime)
>>>   {
>>> -    uint64_t rempages;
>>> +    uint64_t mempages, rempages;
>>>       uint64_t guest_addr;
>>> -    uint32_t slot;
>>> +    uint32_t slot, guest_page_size;
>>>       struct timespec tstart;
>>>       struct sync_area *sync;
>>> -    TEST_ASSERT(mempages > 1,
>>> -            "Can't test without any memory");
>>> +    guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
>>> +    mempages = mem_size / guest_page_size;
>>> +
>>> +    data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
>>> +    ucall_init(data->vm, NULL);
>>>
>>
>> TEST_ASSERT(data->vm->page_size == guest_page_size, "Invalid VM page size")
>> here would catch the case if someone accidentally modifies
>> __vm_create_with_one_vcpu() to use other page size than specified for
>> VM_MODE_DEFAULT.
>>
> 
> Sure, it's not harmful at least.
> 
>>>       data->npages = mempages;
>>> +    TEST_ASSERT(data->npages > 1, "Can't test without any memory");
>>>       data->nslots = nslots;
>>> -    data->pages_per_slot = mempages / data->nslots;
>>> +    data->pages_per_slot = data->npages / data->nslots;
>>>       if (!data->pages_per_slot) {
>>> -        *maxslots = mempages + 1;
>>> +        *maxslots = data->npages + 1;
>>>           return false;
>>>       }
>>> -    rempages = mempages % data->nslots;
>>> +    rempages = data->npages % data->nslots;
>>>       data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
>>>       TEST_ASSERT(data->hva_slots, "malloc() fail");
>>> -    data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
>>> -    ucall_init(data->vm, NULL);
>>> -
>>>       pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
>>>           data->nslots, data->pages_per_slot, rempages);
>> (...)
>>> @@ -856,6 +863,35 @@ static void help(char *name, struct test_args *targs)
>>>           pr_info("%d: %s\n", ctr, tests[ctr].name);
>>>   }
>>> +static bool check_memory_sizes(void)
>>> +{
>>> +    uint32_t guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
>>> +
>>> +    if (MEM_SIZE % guest_page_size ||
>>> +        MEM_TEST_SIZE % guest_page_size) {
>>> +        pr_info("invalid MEM_SIZE or MEM_TEST_SIZE\n");
>>> +        return false;
>>> +    }
>>> +
>>> +    if (MEM_SIZE_MAP % guest_page_size        ||
>>> +        MEM_TEST_MAP_SIZE % guest_page_size        ||
>>> +        (MEM_TEST_MAP_SIZE / guest_page_size) <= 2    ||
>>> +        (MEM_TEST_MAP_SIZE / guest_page_size) % 2) {
>>> +        pr_info("invalid MEM_SIZE_MAP or MEM_TEST_MAP_SIZE\n");
>>> +        return false;
>>> +    }
>>> +
>>> +    if (MEM_TEST_UNMAP_SIZE > MEM_TEST_SIZE        ||
>>> +        MEM_TEST_UNMAP_SIZE % guest_page_size    ||
>>> +        (MEM_TEST_UNMAP_SIZE / guest_page_size) %
>>> +        (MEM_TEST_UNMAP_CHUNK_SIZE / guest_page_size)) {
>>
>> This should be (MEM_TEST_UNMAP_SIZE / guest_page_size) % (2 * MEM_TEST_UNMAP_CHUNK_SIZE / guest_page_size))
>> to match the old static_assert().
>>
> 
> Nice catch! I will fix it up in next revision :)
> 

Thanks,
Gavin

