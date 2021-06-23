Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012F63B1ABB
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhFWNJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:09:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230121AbhFWNJp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 09:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624453646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pvXmK6gZaWHVnyy8+y3rlbryBzsszFyIqFKtOvq27dg=;
        b=GL1ExbluuI+FUF1/WD21JpeTbhoW6NGLPbY9SMgXpC44rmvtJ19v9YLu7p6wINGo165lKS
        dgKqrQcRemlefB/acNdebdu9DA1tcePJ8DsAc8NNDSYHVsEg/YtRWDKbUV2pdLF0Tmf9aD
        nUxWaodEoTQcbDajfx5lxP0JYNvpnLk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-drW6qGcBO6CNKhGMgkQmQA-1; Wed, 23 Jun 2021 09:07:25 -0400
X-MC-Unique: drW6qGcBO6CNKhGMgkQmQA-1
Received: by mail-wm1-f71.google.com with SMTP id p3-20020a05600c4303b02901da4751d86bso169757wme.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 06:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pvXmK6gZaWHVnyy8+y3rlbryBzsszFyIqFKtOvq27dg=;
        b=j1xUs9SCmIiS6kSsSL6j885gBg65qcCTM9ooX/g5Yq81r5zm0Uom5mLC8MqkMEsq3k
         Okf8pyN4b8B6OmoUDzNkvOb47haP2ZXZ1RmRMkrmG2OUPNKLnyJSu/PELS4g/sr6il55
         vC+Wlg5cqCSX9iGbyU45y2UrNvDMOSwvUP/OBU2ZVPn49oMPv1tKoX0iPsOQ+PIHH5l5
         dbxe4+VwxlHGikmp+Xh5sIZ0UAZHecUFSxtoOBphPEVcMK1L5NfMhPwH2n5RWtTkcmub
         KSnG05aw7v7ptgOyhUIWk1JJqLBn+9fcPfYTazAwqxhKQu8Ir7ULAcEWoFcMjGRtXzZu
         3Z7w==
X-Gm-Message-State: AOAM5323QGGgBqzuONW366rP6PRb1iBIdQ9voDARbyH9OehSdPtSnfG9
        eFNzaOv493YVL1IUT8hXAYC8Yj5H8O47iwBWA4qo91tADphabnvDJHEHybXcB/QkTkA/gkItpIC
        zctzwI1A25I41
X-Received: by 2002:a1c:2605:: with SMTP id m5mr10886881wmm.123.1624453643956;
        Wed, 23 Jun 2021 06:07:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxLb99ul1vFnR49Qlsotnc9tdEXKCN3S0jHBZHVkivu4D5gyHanH9XPf5rpMDfAiROB8n3UQ==
X-Received: by 2002:a1c:2605:: with SMTP id m5mr10886835wmm.123.1624453643623;
        Wed, 23 Jun 2021 06:07:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d4sm5868848wmd.42.2021.06.23.06.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:07:22 -0700 (PDT)
Subject: Re: [PATCH 00/19] KVM: selftests: Add x86 mmu_role test and cleanups
To:     Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>
References: <20210622200529.3650424-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <74ef13b2-ed97-1386-f6ea-5b041e68fe92@redhat.com>
Date:   Wed, 23 Jun 2021 15:07:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 22:05, Sean Christopherson wrote:
> The primary intent of this series is to allow x86-64 tests to create
> arbitrary hugepages and use the new functionality to abuse x86's CPUID
> APIs to test KVM MMU behavior.
> 
> The majority of the prep work refactors the selftests APIs related to
> memory allocation.  The core memory allocation APIs within the selftests
> don't provide defaults for memslot or min virtual address, which has led
> to a ridiculous amount of magic and duplicate code.  Literally zero tests
> use non-standard values in a meaningful way, and if a test comes along
> that has a legitimate use case, it should use lower-level helpers.
> 
> Patches 01 and 02 are fixes for bugs found during the refactoring.
> 
> As for the mmu_role test itself, the idea is to change the vCPU model
> while the guest is running (via KVM_SET_CPUID2) to verify that KVM
> reconfigures its MMUs when the vCPU model is changed.  E.g. toggling
> guest support for 1gb hugepages and changing guest MAXPHYADDR.
> 
> Sadly, the test doesn't pass when KVM is using TDP paging (even with all
> my mmu_role fixes) because KVM doesn't fully support manipulating GBPAGES
> and MAXPHYADDR (and other CPUID-based properties that affect the MMU)
> while the guest is running.  And practically speaking, KVM will never
> fully support such behavior becuase (a) there is likely no sane use case,
> (b) fixing the issues is very costly (memory consumption), (c) GBPAGES
> and potentially other features _can't_ be handled correctly due to lack
> of hardware support, and (d) userspace can workaround all issues simply
> by deleting a memslot.
> 
> All that said, I purposely made the test off-by-default instead of
> requiring TDP.  Partly because detecting whether TDP is enabled is a pain
> becuase it's per-vendor, but also because running the test with TDP
> enabled is still interesting to some extent, e.g. the test will fail, but
> it shouldn't crash KVM, trigger WARNs, etc...
> 
> Sean Christopherson (19):
>    KVM: selftests: Remove errant asm/barrier.h include to fix arm64 build
>    KVM: selftests: Zero out the correct page in the Hyper-V features test
>    KVM: selftests: Unconditionally use memslot 0 when loading elf binary
>    KVM: selftests: Unconditionally use memslot 0 for x86's GDT/TSS setup
>    KVM: selftests: Use "standard" min virtual address for Hyper-V pages
>    KVM: selftests: Add helpers to allocate N pages of virtual memory
>    KVM: selftests: Lower the min virtual address for misc page
>      allocations
>    KVM: selftests: Use alloc_page helper for x86-64's GDT/ITD/TSS
>      allocations
>    KVM: selftests: Use alloc page helper for xAPIC IPI test
>    KVM: selftests: Use "standard" min virtual address for CPUID test
>      alloc
>    KVM: selftest: Unconditionally use memslot 0 for vaddr allocations
>    KVM: selftests: Unconditionally use memslot '0' for page table
>      allocations
>    KVM: selftests: Unconditionally allocate EPT tables in memslot 0
>    KVM: selftests: Add wrapper to allocate page table page
>    KVM: selftests: Rename x86's page table "address" to "pfn"
>    KVM: selfests: Add PTE helper for x86-64 in preparation for hugepages
>    KVM: selftests: Genericize upper level page table entry struct
>    KVM: selftests: Add hugepage support for x86-64
>    KVM: sefltests: Add x86-64 test to verify MMU reacts to CPUID updates
> 
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   tools/testing/selftests/kvm/dirty_log_test.c  |   5 +-
>   .../selftests/kvm/hardware_disable_test.c     |   2 +-
>   .../testing/selftests/kvm/include/kvm_util.h  |  18 +-
>   .../selftests/kvm/include/x86_64/processor.h  |  11 +
>   .../selftests/kvm/include/x86_64/vmx.h        |  10 +-
>   .../selftests/kvm/kvm_page_table_test.c       |   2 +-
>   .../selftests/kvm/lib/aarch64/processor.c     |  34 +--
>   .../testing/selftests/kvm/lib/aarch64/ucall.c |   2 +-
>   tools/testing/selftests/kvm/lib/elf.c         |   6 +-
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  62 ++++-
>   .../selftests/kvm/lib/perf_test_util.c        |   2 +-
>   .../selftests/kvm/lib/s390x/processor.c       |  17 +-
>   .../selftests/kvm/lib/x86_64/processor.c      | 254 ++++++++----------
>   tools/testing/selftests/kvm/lib/x86_64/svm.c  |   9 +-
>   tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  52 ++--
>   .../testing/selftests/kvm/memslot_perf_test.c |   2 +-
>   .../selftests/kvm/set_memory_region_test.c    |   2 +-
>   tools/testing/selftests/kvm/steal_time.c      |   2 +-
>   .../selftests/kvm/x86_64/get_cpuid_test.c     |   3 +-
>   .../selftests/kvm/x86_64/hyperv_clock.c       |   2 +-
>   .../selftests/kvm/x86_64/hyperv_features.c    |   8 +-
>   .../selftests/kvm/x86_64/mmu_role_test.c      | 147 ++++++++++
>   .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   2 +-
>   .../kvm/x86_64/vmx_apic_access_test.c         |   2 +-
>   .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   8 +-
>   .../selftests/kvm/x86_64/xapic_ipi_test.c     |   4 +-
>   .../selftests/kvm/x86_64/xen_shinfo_test.c    |   2 +-
>   .../selftests/kvm/x86_64/xen_vmcall_test.c    |   2 +-
>   30 files changed, 414 insertions(+), 260 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> 

Queued, thanks.

Paolo

