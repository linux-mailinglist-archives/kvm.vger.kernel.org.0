Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473FB601CB2
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 00:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiJQW5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 18:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJQW5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 18:57:12 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874C180518;
        Mon, 17 Oct 2022 15:57:08 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1okZ2Z-00024i-Nz; Tue, 18 Oct 2022 00:56:59 +0200
Message-ID: <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
Date:   Tue, 18 Oct 2022 00:56:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
Content-Language: en-US, pl-PL
To:     Gavin Shan <gshan@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ajones@ventanamicro.com, pbonzini@redhat.com, maz@kernel.org,
        shuah@kernel.org, oliver.upton@linux.dev, peterx@redhat.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.10.2022 00:51, Gavin Shan wrote:
> On 10/18/22 6:08 AM, Sean Christopherson wrote:
>> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
>>>> +#define MEM_EXTRA_SIZE        0x10000
>>>
>>> Also, an expression like "(64 << 10)" is more readable than a "1"
>>> with a tail of zeroes (it's easy to add one zero too many or be one
>>> zero short).
>>
>> +1 to not open coding raw numbers.
>>
>> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
>> 16KB, 64K, 2MB, 1GB, etc...
>>
>> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
>> math off of those.
>>
> 
> Ok. I will have one separate patch to define those sizes in kvm_util_base.h,
> right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let me know
> if it looks good to you?
> 
>      #define KB         (1UL << 10)
>      #define MB         (1UL << 20)
>      #define GB         (1UL << 30)
>      #define TB         (1UL << 40)
> 
>      /* Base page and huge page size */
>      #define SIZE_4KB   (  4 * KB)
>      #define SIZE_16KB  ( 16 * KB)
>      #define SIZE_64KB  ( 64 * KB)
>      #define SIZE_2MB   (  2 * MB)
>      #define SIZE_32MB  ( 32 * MB)
>      #define SIZE_512MB (512 * MB)
>      #define SIZE_1GB   (  1 * GB)
>      #define SIZE_16GB  ( 16 * GB)

FYI, QEMU uses KiB, MiB, GiB, etc., see [1].

> Thanks,
> Gavin
> 

Thanks,
Maciej

[1]: https://git.qemu.org/?p=qemu.git;a=blob;f=include/qemu/units.h;hb=HEAD

