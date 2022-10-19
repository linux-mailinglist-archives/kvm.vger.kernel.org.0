Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E001603718
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 02:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJSA0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 20:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJSA0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 20:26:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65559B978B
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 17:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666139191;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2iRn13iSXiKN1tasBVGZtH8JeAlfEonkeX/dLbbng1k=;
        b=iUhRaShlmmIdSVo9an2mkZi+zFcstqJzBUhpMZ8J7g0fDvQkWhRIoDOszcTtZ/4rI7HKQF
        iU8s5EgqjwJuw1wcF8CzrEWzUBuGIRalbolOneMsyOWyfEN94XDNBN88dUbvMtnE0/N8gb
        edbgnQ/u/Ndw2Teaubt8RP1gP+Nfgac=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-y8oaFLu7N5emg5q9o1-lYw-1; Tue, 18 Oct 2022 20:26:28 -0400
X-MC-Unique: y8oaFLu7N5emg5q9o1-lYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8A1F3C01E0A;
        Wed, 19 Oct 2022 00:26:27 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 506502028DC1;
        Wed, 19 Oct 2022 00:26:22 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable
 guest page size
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
        pbonzini@redhat.com, shuah@kernel.org,
        kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-5-gshan@redhat.com>
 <3eecebca-a526-d10a-02d3-496ce919d577@maciej.szmigiero.name>
 <bd5df92c-6870-8053-0b35-a2ad993970bd@redhat.com>
 <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
 <a1a8664c-4d06-89e7-8cfa-b730969bb841@maciej.szmigiero.name>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <5bfbe050-a654-8400-e1f1-dcfa4dba13e6@redhat.com>
Date:   Wed, 19 Oct 2022 08:26:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <a1a8664c-4d06-89e7-8cfa-b730969bb841@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/22 11:56 PM, Maciej S. Szmigiero wrote:
> On 18.10.2022 02:51, Gavin Shan wrote:
>> On 10/18/22 8:46 AM, Gavin Shan wrote:
>>> On 10/18/22 5:31 AM, Maciej S. Szmigiero wrote:
>>>> On 14.10.2022 09:19, Gavin Shan wrote:
>>>>> The test case is obviously broken on aarch64 because non-4KB guest
>>>>> page size is supported. The guest page size on aarch64 could be 4KB,
>>>>> 16KB or 64KB.
>>>>>
>>>>> This supports variable guest page size, mostly for aarch64.
>>>>>
>>>>>    - The host determines the guest page size when virtual machine is
>>>>>      created. The value is also passed to guest through the synchronization
>>>>>      area.
>>>>>
>>>>>    - The number of guest pages are unknown until the virtual machine
>>>>>      is to be created. So all the related macros are dropped. Instead,
>>>>>      their values are dynamically calculated based on the guest page
>>>>>      size.
>>>>>
>>>>>    - The static checks on memory sizes and pages becomes dependent
>>>>>      on guest page size, which is unknown until the virtual machine
>>>>>      is about to be created. So all the static checks are converted
>>>>>      to dynamic checks, done in check_memory_sizes().
>>>>>
>>>>>    - As the address passed to madvise() should be aligned to host page,
>>>>>      the size of page chunk is automatically selected, other than one
>>>>>      page.
>>>>>
>>>>>    - All other changes included in this patch are almost mechanical
>>>>>      replacing '4096' with 'guest_page_size'.
>>>>>
>>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>>> ---
>>>>>   .../testing/selftests/kvm/memslot_perf_test.c | 191 +++++++++++-------
>>>>>   1 file changed, 115 insertions(+), 76 deletions(-)
>>>>>
>>>>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>>>>> index d5aa9148f96f..d587bd952ff9 100644
>>>>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>>>>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> (...)
>>>>> @@ -77,8 +61,7 @@ static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
>>>>>    * for the total size of 25 pages.
>>>>>    * Hence, the maximum size here is 50 pages.
>>>>>    */
>>>>> -#define MEM_TEST_MOVE_SIZE_PAGES    (50)
>>>>> -#define MEM_TEST_MOVE_SIZE        (MEM_TEST_MOVE_SIZE_PAGES * 4096)
>>>>> +#define MEM_TEST_MOVE_SIZE        0x32000
>>>>
>>>> The above number seems less readable than an explicit value of 50 pages.
>>>>
>>>> In addition to that, it's 50 pages only with 4k page size, so at least
>>>> the comment above needs to be updated to reflect this fact.
>>>>
>>>
>>> Yeah, I will change the comments like below in next revision.
>>>
>>>   /*
>>>    * When running this test with 32k memslots, actually 32763 excluding
>>>    * the reserved memory slot 0, the memory for each slot is 0x4000 bytes.
>>>    * The last slot contains 0x19000 bytes memory. Hence, the maximum size
>>>    * here is 0x32000 bytes.
>>>    */
>>>
>>
>> I will replace those numbers with readable ones like below :)
>>
>> /*
>>   * When running this test with 32k memslots, actually 32763 excluding
>>   * the reserved memory slot 0, the memory for each slot is 16KB. The
>>   * last slot contains 100KB memory with the remaining 84KB. Hence,
>>   * the maximum size is double of that (200KB)
>>   */
> 
> Still, these numbers are for x86, which has KVM_INTERNAL_MEM_SLOTS
> defined as 3.
> 
> As far as I can see aarch64 has KVM_INTERNAL_MEM_SLOTS equal to 0, so
> this arch has 32766 slot available for the test memory.
> 
> Quick calculations show that this will result in 112 KiB of memory in
> the last slot for 4 KiB page size (while for 64 KiB page size the
> maximum slot count for this test is 8192 anyway - not counting slot 0).
> 

It seems your calculation had (512MB+64KB), instead of (512MB+4KB).
In this particular patch, we still have (512MB+4KB). How about to change
like below in this patch. In next patch, it's adjusted accordingly after
we have (512MB+64KB).

(1) In this patch, the comment is changed to as below

     /*
      * We have different number of memory slots, excluding the reserved
      * memory slot 0, on various architectures and configurations. The
      * memory size in this test is calculated by doubling the maximal
      * memory size in last memory slot, with alignment to the largest
      * supported page size (64KB).
      *
      * architecture   slots    memory-per-slot    memory-on-last-slot
      * --------------------------------------------------------------
      * x86-4KB        32763    16KB               100KB
      * arm64-4KB      32766    16KB               52KB
      * arm64-64KB     8192     64KB               64KB
      */
     #define MEM_TEST_MOVE_SIZE	0x40000           /* 256KB */

(2) In the next patch, where we have (512MB+64KB) after the various
     memory sizes are consolidated, It is adjusted accordingly as below.

     /*
      * We have different number of memory slots, excluding the reserved
      * memory slot 0, on various architectures and configurations. The
      * memory size in this test is calculated by doubling the maximal
      * memory size in last memory slot, with alignment to the largest
      * supported page size (64KB).
      *
      * architecture   slots    memory-per-slot    memory-on-last-slot
      * --------------------------------------------------------------
      * x86-4KB        32763    16KB               160KB
      * arm64-4KB      32766    16KB               112KB
      * arm64-64KB     8192     64KB               128KB
      */
     #define MEM_TEST_MOVE_SIZE	0x50000           /* 320KB */

Thanks,
Gavin

