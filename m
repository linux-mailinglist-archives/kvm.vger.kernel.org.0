Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF3536303B
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhDQNXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:23:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhDQNXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618665777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uy+wTYY2LmEUbjzC1DEbNzxYstTZTEjdM/GOp0GYn/g=;
        b=VMh6cs+RQP4Sq9dwvx7LX3UpSQ2rkiWLBzvtnyiKacPjMKW6DROvMlS95PQOkD+NM+5Hj5
        skP5wH+AKQK8pfdGYQtEq5BbqNIvc9sYqlHWlljNP/rOJkIOdU+Ie/iuhnLbyqxgsycLdA
        ofZZAhEGCr49ZHHwiBfs3GxJPXOq750=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-G0yH67iYPnW-2HjBKKohIQ-1; Sat, 17 Apr 2021 09:22:54 -0400
X-MC-Unique: G0yH67iYPnW-2HjBKKohIQ-1
Received: by mail-ed1-f69.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so8624906edd.5
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uy+wTYY2LmEUbjzC1DEbNzxYstTZTEjdM/GOp0GYn/g=;
        b=YZMmcJcvJ+Hvk4OZCYWR5GzEbIDYXNq00trOpDZwPubLNToT/fM6bCZRLnT9P1rcz3
         no1q2+i7qNOYX15k6QAIjqGbelnEVYH4ZDwvv4hdx25EqtBcuVS4/LFSeF83jPW8PXvs
         tp1u6R/SICNhaDiIG0cFSNi5vexfo4UMLeYwm59liaHKuvxcTkyePrapUre0nVrbCLHl
         9avUClcbIkxw1oJHTwPHCRRyIo2TkzuHkkb8AFq/4ki2uuVf/FqMaMYUn6QAWdZYo4Ya
         HoOoXEhbvdnkkWsQA9bEvljag2AoNukgxIp29wbC5EKN/lwmmaZFj2XedbQPpo14B2Bh
         rAIA==
X-Gm-Message-State: AOAM530BCiWTgZm4QYfc7wxhHR0dlMkXYWwYGuGt2mOcO8azMta+S0PZ
        dg90NslgOMkKDu1MSliH5ltVfg9ZWBoxk3oSLKPFKPhPvXT14ZROgZ8iipek1vk+7teX8BOgtxB
        MfqjRBSdslmCp
X-Received: by 2002:a17:906:2cd1:: with SMTP id r17mr12893554ejr.429.1618665773658;
        Sat, 17 Apr 2021 06:22:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUxOOoJdwlxjaRg450X5IrGlRvq/r1GTTuiaohluQhdXbq4NxbCG69VG1QslBdIWSsUz+4jA==
X-Received: by 2002:a17:906:2cd1:: with SMTP id r17mr12893533ejr.429.1618665773412;
        Sat, 17 Apr 2021 06:22:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f20sm3188595ejw.36.2021.04.17.06.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:22:52 -0700 (PDT)
Subject: Re: [PATCH v6 00/10] KVM: selftests: some improvement and a new test
 for kvm page table
To:     "wangyanan (Y)" <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20210330080856.14940-1-wangyanan55@huawei.com>
 <31ab81be-bf14-62f3-d579-9685ccec578a@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <62d02fe3-da49-5c75-d8be-177c7b2b129f@redhat.com>
Date:   Sat, 17 Apr 2021 15:22:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <31ab81be-bf14-62f3-d579-9685ccec578a@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/21 05:05, wangyanan (Y) wrote:
> Kindly ping...
> 
> Hi Paolo,
> Will this series be picked up soon, or is there any other work for me to 
> do?
> 
> Regards,
> Yanan
> 
> 
> On 2021/3/30 16:08, Yanan Wang wrote:
>> Hi,
>> This v6 series can mainly include two parts.
>> Rebased on kvm queue branch: 
>> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=queue
>>
>> In the first part, all the known hugetlb backing src types specified
>> with different hugepage sizes are listed, so that we can specify use
>> of hugetlb source of the exact granularity that we want, instead of
>> the system default ones. And as all the known hugetlb page sizes are
>> listed, it's appropriate for all architectures. Besides, a helper that
>> can get granularity of different backing src types(anonumous/thp/hugetlb)
>> is added, so that we can use the accurate backing src granularity for
>> kinds of alignment or guest memory accessing of vcpus.
>>
>> In the second part, a new test is added:
>> This test is added to serve as a performance tester and a bug reproducer
>> for kvm page table code (GPA->HPA mappings), it gives guidance for the
>> people trying to make some improvement for kvm. And the following 
>> explains
>> what we can exactly do through this test.
>>
>> The function guest_code() can cover the conditions where a single vcpu or
>> multiple vcpus access guest pages within the same memory region, in three
>> VM stages(before dirty logging, during dirty logging, after dirty 
>> logging).
>> Besides, the backing src memory type(ANONYMOUS/THP/HUGETLB) of the tested
>> memory region can be specified by users, which means normal page mappings
>> or block mappings can be chosen by users to be created in the test.
>>
>> If ANONYMOUS memory is specified, kvm will create normal page mappings
>> for the tested memory region before dirty logging, and update attributes
>> of the page mappings from RO to RW during dirty logging. If THP/HUGETLB
>> memory is specified, kvm will create block mappings for the tested memory
>> region before dirty logging, and split the blcok mappings into normal 
>> page
>> mappings during dirty logging, and coalesce the page mappings back into
>> block mappings after dirty logging is stopped.
>>
>> So in summary, as a performance tester, this test can present the
>> performance of kvm creating/updating normal page mappings, or the
>> performance of kvm creating/splitting/recovering block mappings,
>> through execution time.
>>
>> When we need to coalesce the page mappings back to block mappings after
>> dirty logging is stopped, we have to firstly invalidate *all* the TLB
>> entries for the page mappings right before installation of the block 
>> entry,
>> because a TLB conflict abort error could occur if we can't invalidate the
>> TLB entries fully. We have hit this TLB conflict twice on aarch64 
>> software
>> implementation and fixed it. As this test can imulate process from dirty
>> logging enabled to dirty logging stopped of a VM with block mappings,
>> so it can also reproduce this TLB conflict abort due to inadequate TLB
>> invalidation when coalescing tables.
>>
>> Links about the TLB conflict abort:
>> https://lore.kernel.org/lkml/20201201201034.116760-3-wangyanan55@huawei.com/ 
>>
>>
>> ---
>>
>> Change logs:
>>
>> v5->v6:
>> - Address Andrew Jones's comments for v5 series
>> - Add Andrew Jones's R-b tags in some patches
>> - Rebased on newest kvm/queue tree
>> - v5: 
>> https://lore.kernel.org/lkml/20210323135231.24948-1-wangyanan55@huawei.com/ 
>>
>>
>> v4->v5:
>> - Use synchronization(sem_wait) for time measurement
>> - Add a new patch about TEST_ASSERT(patch 4)
>> - Address Andrew Jones's comments for v4 series
>> - Add Andrew Jones's R-b tags in some patches
>> - v4: 
>> https://lore.kernel.org/lkml/20210302125751.19080-1-wangyanan55@huawei.com/ 
>>
>>
>> v3->v4:
>> - Add a helper to get system default hugetlb page size
>> - Add tags of Reviewed-by of Ben in the patches
>> - v3: 
>> https://lore.kernel.org/lkml/20210301065916.11484-1-wangyanan55@huawei.com/ 
>>
>>
>> v2->v3:
>> - Add tags of Suggested-by, Reviewed-by in the patches
>> - Add a generic micro to get hugetlb page sizes
>> - Some changes for suggestions about v2 series
>> - v2: 
>> https://lore.kernel.org/lkml/20210225055940.18748-1-wangyanan55@huawei.com/ 
>>
>>
>> v1->v2:
>> - Add a patch to sync header files
>> - Add helpers to get granularity of different backing src types
>> - Some changes for suggestions about v1 series
>> - v1: 
>> https://lore.kernel.org/lkml/20210208090841.333724-1-wangyanan55@huawei.com/ 
>>
>>
>> ---
>>
>> Yanan Wang (10):
>>    tools headers: sync headers of asm-generic/hugetlb_encode.h
>>    mm/hugetlb: Add a macro to get HUGETLB page sizes for mmap
>>    KVM: selftests: Use flag CLOCK_MONOTONIC_RAW for timing
>>    KVM: selftests: Print the errno besides error-string in TEST_ASSERT
>>    KVM: selftests: Make a generic helper to get vm guest mode strings
>>    KVM: selftests: Add a helper to get system configured THP page size
>>    KVM: selftests: Add a helper to get system default hugetlb page size
>>    KVM: selftests: List all hugetlb src types specified with page sizes
>>    KVM: selftests: Adapt vm_userspace_mem_region_add to new helpers
>>    KVM: selftests: Add a test for kvm page table code
>>
>>   include/uapi/linux/mman.h                     |   2 +
>>   tools/include/asm-generic/hugetlb_encode.h    |   3 +
>>   tools/include/uapi/linux/mman.h               |   2 +
>>   tools/testing/selftests/kvm/.gitignore        |   1 +
>>   tools/testing/selftests/kvm/Makefile          |   3 +
>>   .../selftests/kvm/demand_paging_test.c        |   8 +-
>>   .../selftests/kvm/dirty_log_perf_test.c       |  14 +-
>>   .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
>>   .../testing/selftests/kvm/include/test_util.h |  21 +-
>>   .../selftests/kvm/kvm_page_table_test.c       | 506 ++++++++++++++++++
>>   tools/testing/selftests/kvm/lib/assert.c      |   4 +-
>>   tools/testing/selftests/kvm/lib/kvm_util.c    |  59 +-
>>   tools/testing/selftests/kvm/lib/test_util.c   | 163 +++++-
>>   tools/testing/selftests/kvm/steal_time.c      |   4 +-
>>   14 files changed, 733 insertions(+), 61 deletions(-)
>>   create mode 100644 tools/testing/selftests/kvm/kvm_page_table_test.c
>>
> 

Queued, thanks.

I moved MAP_HUGE_PAGE_SIZE from the uapi header to test_util.c, because 
I'm not confident in adding a new userspace API without an ack.

Paolo

