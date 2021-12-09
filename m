Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE97D46F3F6
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 20:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhLITeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 14:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhLITeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 14:34:15 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20191C061746;
        Thu,  9 Dec 2021 11:30:41 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g14so22196573edb.8;
        Thu, 09 Dec 2021 11:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0xRtXJW83Yd8z831Xed6i/iEDs06aIGGNcWdPaz0N3Q=;
        b=RyfBbQL/vfgxEpy/6Bm0MoQjNUaEqzC9YhtLTbdkQZclUhmdoPWLnj4j2ntG53lwE0
         omy6N3M4bmOzLNI7Ne1T6qj8w9P0DMe1e2DZr8eadbb9Z2O9mIl1lv9IX3cRsJ7hfHIP
         QhbYjR3ae1Gk0uojBwN5Mys8RmGuKk1Nttth48tQXiLuDe/lh2psg37ecORjPNW/ZU/m
         1bDlGV4QzanITlc2q0iT+9KFiWcxeo9fjBOve6X1Csfa8/ZRluRdnntAHT+96yvZo4DW
         pktOLScd/l3yxeNwxkU9pcdH8HFW+VOU77dSX1K1w8H86+8vFck1nq7VSU9znbXlnn37
         qQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0xRtXJW83Yd8z831Xed6i/iEDs06aIGGNcWdPaz0N3Q=;
        b=yPbr7WgIYEPrjaTLqqZYrUT+7+qtzA2+FKav3zWcEDjIYRIHoyG5gPGL+CExMP0gf7
         Cgn5iDo4hZ5I7+GgSj7zthL9XGy0rKwbIcQnYRi0SqdK2ia1CNk6OyGYH1SaDgoYl7zx
         WsMzbuEb1d9DmDpcaucrl6QX/0Wp8bnjSjANoLbRQ5sR1puJcUMOGu2kHVcY+EsMwUk5
         BZkemf5sPaB8d4fwWBrg157WSoxLumhsutqnZJuyivb1AAIAu/16Ij2z2k76wSaa23jf
         WEi1Q9f8YTPq2VRBWOUbuqT6rRrTWGOG6hEeuOMque2+5iNzu8qtgOefBFqsmBpQBfGq
         E4BA==
X-Gm-Message-State: AOAM530kv3WaGZmMT779lISiV3TR86hdA3r2jDTqTxiaTLbWHZDvI5h2
        v/t0HK9ijjhKX7SWlZQGAf64AI5Gn44=
X-Google-Smtp-Source: ABdhPJzgx/xQHPAUMDm+QCSw2KPPR3pnbY6xJBcSAwv6NcsMZz7bbc1uRMovkuY6avOW0uV6jad8eg==
X-Received: by 2002:a05:6402:1395:: with SMTP id b21mr32197670edv.299.1639078239733;
        Thu, 09 Dec 2021 11:30:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id sd28sm404766ejc.37.2021.12.09.11.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 11:30:39 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3118559d-8d4e-e080-2849-b526917969eb@redhat.com>
Date:   Thu, 9 Dec 2021 20:30:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/6] KVM: x86/pmu: Count two basic events for emulated
 instructions
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211130074221.93635-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 08:42, Like Xu wrote:
> Hi,
> 
> [ Jim is on holiday, so I'm here to continue this work. ]
> 
> Some cloud customers need accurate virtualization of two
> basic PMU events on x86 hardware: "instructions retired" and
> "branch instructions retired". The existing PMU virtualization code
> fails to account for instructions (e.g, CPUID) that are emulated by KVM.
> 
> Accurately virtualizing all PMU events for all microarchitectures is a
> herculean task, let's just stick to the two events covered by this set.
> 
> Eric Hankland wrote this code originally, but his plate is full, so Jim
> and I volunteered to shepherd the changes through upstream acceptance.
> 
> Thanks,
> 
> v1 -> v2 Changelog:
> - Include the patch set [1] and drop the intel_find_fixed_event(); [Paolo]
>    (we will fix the misleading Intel CPUID events in another patch set)
> - Drop checks for pmc->perf_event or event state or event type;
> - Increase a counter once its umask bits and the first 8 select bits are matched;
> - Rewrite kvm_pmu_incr_counter() with a less invasive approach to the host perf;
> - Rename kvm_pmu_record_event to kvm_pmu_trigger_event;
> - Add counter enable check for kvm_pmu_trigger_event();
> - Add vcpu CPL check for kvm_pmu_trigger_event(); [Jim]
> 
> Previous:
> https://lore.kernel.org/kvm/20211112235235.1125060-2-jmattson@google.com/
> 
> [1] https://lore.kernel.org/kvm/20211119064856.77948-1-likexu@tencent.com/
> 
> Jim Mattson (1):
>    KVM: x86: Update vPMCs when retiring branch instructions
> 
> Like Xu (5):
>    KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
>    KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
>    KVM: x86/pmu: Reuse pmc_perf_hw_id() and drop find_fixed_event()
>    KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
>    KVM: x86: Update vPMCs when retiring instructions
> 
>   arch/x86/include/asm/kvm_host.h |   1 +
>   arch/x86/kvm/emulate.c          |  55 ++++++++------
>   arch/x86/kvm/kvm_emulate.h      |   1 +
>   arch/x86/kvm/pmu.c              | 128 ++++++++++++++++++++++----------
>   arch/x86/kvm/pmu.h              |   5 +-
>   arch/x86/kvm/svm/pmu.c          |  19 ++---
>   arch/x86/kvm/vmx/nested.c       |   7 +-
>   arch/x86/kvm/vmx/pmu_intel.c    |  44 ++++++-----
>   arch/x86/kvm/x86.c              |   5 ++
>   9 files changed, 167 insertions(+), 98 deletions(-)
> 

Queued patches 1-4, thanks.

Paolo
