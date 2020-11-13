Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA6C2B20CB
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 17:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgKMQs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 11:48:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbgKMQs3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 11:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605286107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIdgwwJZvi144qFVHjnQrVkabtrDwv5wW93JQz/JXxM=;
        b=gHNiogzyZtg25KNhUhAUSsjs957RoFAZnjqnN8pTjyhkPEUzJTO4e9LtABc6OUi4iC1tQF
        UDQWzciK24dMb5Uk8hCUymoSg3EvvEc6yqE1N0i9LaTOyRKMc2Ni8kX1Z2pS0yaSMdwDVA
        UVqCXpAk8DdW0yG3eUa3zw2D+ej0Vj0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-YE1iIxDxPe-LTmU06xMzOg-1; Fri, 13 Nov 2020 11:48:25 -0500
X-MC-Unique: YE1iIxDxPe-LTmU06xMzOg-1
Received: by mail-wr1-f70.google.com with SMTP id k1so4127914wrg.12
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 08:48:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AIdgwwJZvi144qFVHjnQrVkabtrDwv5wW93JQz/JXxM=;
        b=AD9dzKm2H2iuVV+JaldXr8sz9iJQkSXO0Xe9rYJKucjf0PdjsqdSNQtSryQKzaKTfD
         Am5834KnPjq6BU2e8CuPGHLAq+fIbipK4TWpSWt+AeZ6MOduZ9Wf8Z0H5BSAFcfJin03
         jN50aaUUE2arComhuSNE1NVF2e6SxXcekAMD6eRnzGohQfUxroksAgiUWB7xWSArUfb6
         yV2iZ8DGz1wO5VE2NnrM4g6WYRqWbMfU1Rb6JmMX7ng/Wur77wyCAAh3qtTfKxx7VRhW
         xjy8YKQJWfc5v0mSXnraWIKfntP8SRfU3KIo+dAxLp3mD8ZmZa5buCtPK7DMbqof/VlA
         sDhg==
X-Gm-Message-State: AOAM533t39R37a9oMvmYtyInX7FNPgig7TDlpaP6NgrNLd4ATS1VY4EQ
        ReDIdiJunlfJxBb21zOBFYE9aZfs2ThxKq7q/5BJLL6YJoeJd7FpneNMR412TlFCUyFrFN+pB1+
        Cn1qJc/wjEixI
X-Received: by 2002:adf:f40a:: with SMTP id g10mr4881451wro.58.1605286099822;
        Fri, 13 Nov 2020 08:48:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2Y11pw/jLsquw0BpC8wkKtjHyMMdwHp13PV+4/vEpNehyDIaEQXs9cpl3kM6DrGzXHgBitw==
X-Received: by 2002:adf:f40a:: with SMTP id g10mr4881027wro.58.1605286094699;
        Fri, 13 Nov 2020 08:48:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p10sm12015013wre.2.2020.11.13.08.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 08:48:13 -0800 (PST)
Subject: Re: [PATCH v2 00/11] KVM: selftests: Cleanups, take 2
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, bgardon@google.com,
        peterx@redhat.com
References: <20201111122636.73346-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f983ae1a-950d-1572-19af-88fafe61fe6d@redhat.com>
Date:   Fri, 13 Nov 2020 17:48:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201111122636.73346-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Applied 4/5/9/10/11 (plus, 1 and 2 have replacements in kvm/queue). 
I'll push shortly, please rebase and resend.

Paolo

On 11/11/20 13:26, Andrew Jones wrote:
> This series attempts to clean up demand_paging_test, dirty_log_perf_test,
> and dirty_log_test by factoring out common code, creating some new API
> along the way. It also splits include/perf_test_util.h into a more
> conventional header and source pair.
> 
> I've tested on x86 and AArch64 (one config each), but not s390x.
> 
> v2:
>    - Use extra_mem instead of per-vcpu mem for the test mem in
>      demand_paging_test and dirty_log_perf_test [Ben]
> 
>    - Couple more cleanups, like adding perf_test_destroy_vm()
>      to balance create/destroy of a perf test vm [drew]
> 
>    - Added new patches [drew]:
> 
>      - Since dirty_log_perf_test works fine on AArch64,
>        "KVM: selftests: Also build dirty_log_perf_test on AArch64"
> 
>      - More cleanup of redundant code,
>        "KVM: selftests: x86: Set supported CPUIDs on default VM"
> 
>      - Keep test skipping consistent,
>        "KVM: selftests: Make test skipping consistent"
> 
> I definitely want to get x86 people's review on "KVM: selftests: x86:
> Set supported CPUIDs on default VM" to be sure it's OK to do that.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (11):
>    KVM: selftests: Update .gitignore
>    KVM: selftests: Remove deadcode
>    KVM: selftests: Factor out guest mode code
>    KVM: selftests: Make vm_create_default common
>    KVM: selftests: Introduce vm_create_[default_]_with_vcpus
>    KVM: selftests: dirty_log_test: Remove create_vm
>    KVM: selftests: Use vm_create_with_vcpus in create_vm
>    KVM: selftests: Implement perf_test_util more conventionally
>    KVM: selftests: Also build dirty_log_perf_test on AArch64
>    KVM: selftests: x86: Set supported CPUIDs on default VM
>    KVM: selftests: Make test skipping consistent
> 
>   tools/testing/selftests/kvm/.gitignore        |   2 +-
>   tools/testing/selftests/kvm/Makefile          |   3 +-
>   .../selftests/kvm/demand_paging_test.c        | 118 +++--------
>   .../selftests/kvm/dirty_log_perf_test.c       | 183 ++++--------------
>   tools/testing/selftests/kvm/dirty_log_test.c  | 182 +++++------------
>   .../selftests/kvm/include/guest_modes.h       |  21 ++
>   .../testing/selftests/kvm/include/kvm_util.h  |  42 +++-
>   .../selftests/kvm/include/perf_test_util.h    | 171 ++--------------
>   .../selftests/kvm/lib/aarch64/processor.c     |  17 --
>   tools/testing/selftests/kvm/lib/guest_modes.c |  70 +++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  67 ++++++-
>   .../selftests/kvm/lib/perf_test_util.c        | 134 +++++++++++++
>   .../selftests/kvm/lib/s390x/processor.c       |  22 ---
>   .../selftests/kvm/lib/x86_64/processor.c      |  32 ---
>   .../selftests/kvm/set_memory_region_test.c    |   2 -
>   .../kvm/x86_64/cr4_cpuid_sync_test.c          |   1 -
>   .../testing/selftests/kvm/x86_64/debug_regs.c |   1 -
>   .../testing/selftests/kvm/x86_64/evmcs_test.c |   2 -
>   .../selftests/kvm/x86_64/kvm_pv_test.c        |   4 +-
>   tools/testing/selftests/kvm/x86_64/smm_test.c |   2 -
>   .../testing/selftests/kvm/x86_64/state_test.c |   1 -
>   .../selftests/kvm/x86_64/svm_vmcall_test.c    |   1 -
>   .../selftests/kvm/x86_64/tsc_msrs_test.c      |   1 -
>   .../selftests/kvm/x86_64/user_msr_test.c      |   7 +-
>   .../kvm/x86_64/vmx_apic_access_test.c         |   1 -
>   .../kvm/x86_64/vmx_close_while_nested_test.c  |   1 -
>   .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   1 -
>   .../kvm/x86_64/vmx_preemption_timer_test.c    |  15 +-
>   .../kvm/x86_64/vmx_set_nested_state_test.c    |  21 ++
>   .../kvm/x86_64/vmx_tsc_adjust_test.c          |   1 -
>   30 files changed, 499 insertions(+), 627 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
>   create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
>   create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c
> 

