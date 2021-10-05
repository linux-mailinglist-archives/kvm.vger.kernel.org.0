Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A855C42216A
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhJEJAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:00:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233460AbhJEJAP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 05:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633424304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iSIxKLHKuCQREC6ljaT0YwTeZjnFDwhGrC3/FjpOD9w=;
        b=OvmS01yWuZl0WFxRQDTvt/638sjF+AQ/gH1gXHJIIcg1wQ9Mm+cMlSV0hgsP0zJ5zhdYHY
        g6EfClmF+JCMpCef6JgI0JrSKMBBDUsrMIoT+B1lgx3X+LKoqP6GoxBEHBP8ghGG2pKeAh
        JlwLORxWfThZwlJv7D4sAIM+0AX+Gqc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-RgebkO-AO9Wx0NUxJg2-1w-1; Tue, 05 Oct 2021 04:58:23 -0400
X-MC-Unique: RgebkO-AO9Wx0NUxJg2-1w-1
Received: by mail-ed1-f69.google.com with SMTP id k2-20020a50ce42000000b003dadf140b15so8294077edj.19
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 01:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iSIxKLHKuCQREC6ljaT0YwTeZjnFDwhGrC3/FjpOD9w=;
        b=ZF8dRMdaWtSmPNXpu18iPxjEzdV8KmW4OBl3qne1Tr8DA431rwDRTs3YZacDGZMy2i
         MJPCo8H0zcbZGbVlSx3VCN5XJVCnVv2okWFTYXGPdi+Pf0j0LycbmQBwbuBn6L8QKMu1
         kTFWygBDXOQmIzFNJcu2qj5294AEfD15QQd+ffNrUvUAfmgDdJZSIrTiZNhf94YBfApg
         NVCmTD4yne5MMy9WSEYspktDnY0Zm5zEINmSzLpdvicyP+Gn61UfZQU+E+BPeHCQ9SvD
         D2p06gCBblHB7p4WdpRlvUQ2ISRI3h+mw5b5ic6R0WR5MckrFZ8H4G/4hgtLljCeXHzo
         d5Yw==
X-Gm-Message-State: AOAM533pirQvtkob6G8c59la+5Nykg9Ud7kMEgFyTsSj1iJaNo4L1SRB
        OX3Dvs89+EF8WKY2v68I2jVsdlbucT5mWdz1xPlMN8R0cO2Dx6D+PU4D5yG4MSy46mti+m+ugqz
        0iR3KCzcwvLOu
X-Received: by 2002:a50:cf87:: with SMTP id h7mr25229117edk.152.1633424302394;
        Tue, 05 Oct 2021 01:58:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy//hFPZIOmIMpXpLIvym9w9znFdvxh5ulIf8v0oW4NCFIbrXhPFgLiygcthyaAsP0cGZ4cuA==
X-Received: by 2002:a50:cf87:: with SMTP id h7mr25229087edk.152.1633424302157;
        Tue, 05 Oct 2021 01:58:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id z4sm8604398edb.16.2021.10.05.01.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 01:58:21 -0700 (PDT)
Message-ID: <4e5e47d8-d69f-d4ea-cfe1-90ad5c52bae1@redhat.com>
Date:   Tue, 5 Oct 2021 10:58:19 +0200
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
> 
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

Queued patches 1-5, thanks.

Paolo

