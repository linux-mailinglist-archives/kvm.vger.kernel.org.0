Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCC8417903
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343652AbhIXQpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233969AbhIXQpT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ayfGdTCBtiqgPiJaceqi1OGn0mBN7usLeKdCjt4NNw=;
        b=Et+NPhxDCb8MUTmqcsquftp1YII6Fa+6JCf0GTd5UaSoz3z5EPl1NakfokzDae4veSg+Zn
        LYQIAuu56YTpo1yfOt9G1Ba8UIsMWrD4+pw/OuHQfc8q2yrQoUL/Icl6iLCEIwKeHC0iXM
        wYMMHvenrhWwxVdM2tDStpE/wLyRIu4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-hxXd30D_MM-di50BrDBdRg-1; Fri, 24 Sep 2021 12:43:45 -0400
X-MC-Unique: hxXd30D_MM-di50BrDBdRg-1
Received: by mail-ed1-f69.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso10931137edp.0
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:43:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2ayfGdTCBtiqgPiJaceqi1OGn0mBN7usLeKdCjt4NNw=;
        b=s+7Dx8GRGy5X3QPuQzbbpk5Y6DszGeFn4ML87yTLORCG5H8Od5imreQB8DJ3O+nc5B
         R9dxWAFnjtMJfcIet5TK3opbG/GDDFgI5lERvTWJeXA1JAPetz/So/BdLSDWRSL2QtPl
         iCXdJ9ingeQxUr2Fsh85JkwDo7iIko4KIfX75J7KbSWN4/CABVjFmT0peCvvt24Rnno1
         q+6J6eeM9xlNW7t4TSv4iqzoXXV781BABBndrCR2KgVKY6I2mFzsEEY41UnQ2uq+O75Z
         ZgnMrDnvYGDYoeRFxWIScAce7oGuM4veAE067irqQbqyklFI/N9+zm/DUuK82CNnOIS1
         4a8A==
X-Gm-Message-State: AOAM531jPVWcYDXs49M4+5EJ6nUhCBxmtFYF60Ug3p3rbuyubhBOWHX9
        tHT6qYHh5ZH5isI2LMITq4dHsXHikgKt8Iv7JM5TTsO2/Y3RjDM2zA8ptwzcnBYQ/NHLf+X+S8W
        +tjJxB0gjSIXW
X-Received: by 2002:a17:906:1484:: with SMTP id x4mr12169309ejc.72.1632501823822;
        Fri, 24 Sep 2021 09:43:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+Yv3J2nN2uB7FgYH5ZxA5zjL/80SexpKmfVSqrcDD0N8I1bfA249hQ9sfmzeDIxBqSeb+tQ==
X-Received: by 2002:a17:906:1484:: with SMTP id x4mr12169286ejc.72.1632501823639;
        Fri, 24 Sep 2021 09:43:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z3sm5228855eju.34.2021.09.24.09.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:43:43 -0700 (PDT)
Message-ID: <9982d53a-8160-d7f7-09eb-ea640f99136b@redhat.com>
Date:   Fri, 24 Sep 2021 18:43:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 0/9] selftests: KVM: Test offset-based counter controls
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181555.973085-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 20:15, Oliver Upton wrote:
> This series implements new tests for the x86 and arm64 counter migration
> changes that I've mailed out. These are sent separately as a dependent
> change since there are cross-arch dependencies here.
> 
> Patch 1 yanks the pvclock headers into the tools/ directory so we can
> make use of them within a KVM selftest guest.
> 
> Patch 2 tests the new capabilities of the KVM_*_CLOCK ioctls, ensuring
> that the kernel accounts for elapsed time when restoring the KVM clock.
> 
> Patches 3-4 add some device attribute helpers and clean up some mistakes
> in the assertions thereof.
> 
> Patch 5 implements a test for the KVM_VCPU_TSC_OFFSET attribute,
> asserting that manipulation of the offset results in correct TSC values
> within the guest.
> 
> Patch 6 adds basic arm64 support to the counter offset test, checking
> that the virtual counter-timer offset works correctly. Patch 7 does the
> same for the physical counter-timer offset.
> 
> Patch 8 adds a benchmark for physical counter offsetting, since most
> implementations available right now will rely on emulation.
> 
> Lastly, patch 9 extends the get-reg-list test to check for
> KVM_REG_ARM_TIMER_OFFSET if userspace opts-in to the kernel capability.
> 
> This series applies cleanly to 5.15-rc1
> 
> Tests were ran against the respective architecture changes on the
> following systems:
> 
>   - Haswell (x86)
>   - Ampere Mt. Jade (non-ECV, nVHE and VHE)

Queued patches 1-5, thanks.

Paolo

> v7: https://lore.kernel.org/r/20210816001246.3067312-1-oupton@google.com
> 
> v7 -> v8:
>   - Rebased to 5.15-rc1
>   - Dropped helper for checking if reg exists in reg list (no longer
>     necessary)
>   - Test and enable KVM_CAP_ARM_VTIMER_OFFSET
>   - Add get-reg-list changes
> 
> Oliver Upton (9):
>    tools: arch: x86: pull in pvclock headers
>    selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
>    selftests: KVM: Fix kvm device helper ioctl assertions
>    selftests: KVM: Add helpers for vCPU device attributes
>    selftests: KVM: Introduce system counter offset test
>    selftests: KVM: Add support for aarch64 to system_counter_offset_test
>    selftests: KVM: Test physical counter offsetting
>    selftests: KVM: Add counter emulation benchmark
>    selftests: KVM: Test vtimer offset reg in get-reg-list
> 
>   tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++++
>   tools/arch/x86/include/asm/pvclock.h          | 103 ++++++++
>   tools/testing/selftests/kvm/.gitignore        |   3 +
>   tools/testing/selftests/kvm/Makefile          |   4 +
>   .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++
>   .../selftests/kvm/aarch64/get-reg-list.c      |  42 ++++
>   .../selftests/kvm/include/aarch64/processor.h |  24 ++
>   .../testing/selftests/kvm/include/kvm_util.h  |  11 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +++-
>   .../kvm/system_counter_offset_test.c          | 220 ++++++++++++++++++
>   .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++
>   11 files changed, 907 insertions(+), 3 deletions(-)
>   create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
>   create mode 100644 tools/arch/x86/include/asm/pvclock.h
>   create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
>   create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> 

