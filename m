Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E407B46D622
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 15:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhLHOzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhLHOzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 09:55:06 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610D0C061746;
        Wed,  8 Dec 2021 06:51:34 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x6so9247401edr.5;
        Wed, 08 Dec 2021 06:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QWHLsi58iBRKLpnRUwKPYaAT671ZxtkhBU1FfVlVdXg=;
        b=K+4tRxGphRbws1f4Rrz0JYGa2Qx/72RzMwQUficOEbDv1SlOEhtiw3VGzPcnLY3Jo2
         1P1jH2DJ2Il+6mtk7fPD06NeoCXeeNnt2d95pXGlX5eWBMj/BalrT7AJOOOFH5y4B+Yh
         b8/2uLh2bql/u5eRW9MQFgc6RCd3QhgJOBn/VzNrFN+K03/4iWwEiusX0q52KMF94+9w
         J7Ciwb0oFbIlV1xP3Q5cI99NcmtmsYgSsVKyS9dXEuTU3n0Y6frI6wYMO9YbKq4gRIE+
         YIu3o09Kn/5UNq4wSkPPAnn1vwABqCMS/QkwAmQ2i9tW+t2V5+C6zjqZk2zV+Y3arYOb
         XWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QWHLsi58iBRKLpnRUwKPYaAT671ZxtkhBU1FfVlVdXg=;
        b=jqbmYugse+5yrZnypmzDkPNtON6vMfc0R8H5wqPxTwmHwKwwzlpmh2ZjZSjHIINnGL
         FX9H76nIWTtSpi4nTt0d7ytNdafdhreCMUlTNuiKIWHQqGbL+JCPQbnNggyUKfOf0iFs
         YrcxpKwkBD/JCdd8aHknyTdJ+i9sef1Yy3tO0u0okyaZ8MmAWZxsnliUElx9QLohMvqv
         DHKpqZGX28g91b0064GsDKePDrO9STa4xYYIdZs2g8fSLcGX2vO24+GwGzu03n5qM/R6
         u49pda0je5VaIpmDz5PsvBgVtlZ0R7TykMHETHEyh/E6Nbanw7feUnAkpJT+eFVIx1mr
         OvhQ==
X-Gm-Message-State: AOAM530KgfGo1d8eEmaPS4FoZ3iZPFbdqhLzAd6GMKouXrc6AKGqDOS4
        r/R9YXpq4z9XnOvPdv92fBI=
X-Google-Smtp-Source: ABdhPJxCx1VEvF7FzfkCtA0NwaIDc28iCguT9i8qNKGCpeXl8YVLWLN6FoGepTtKHBM7AnLSsJFzHw==
X-Received: by 2002:a05:6402:4302:: with SMTP id m2mr19576689edc.349.1638975092953;
        Wed, 08 Dec 2021 06:51:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h10sm2087524edr.95.2021.12.08.06.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:51:32 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <518c3e07-41c8-feeb-5298-702c101994c7@redhat.com>
Date:   Wed, 8 Dec 2021 15:51:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20211208015236.1616697-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 02:52, Sean Christopherson wrote:
> Overhaul and cleanup APIC virtualization (Posted Interrupts on Intel VMX,
> AVIC on AMD SVM) to streamline things as much as possible, remove a bunch
> of cruft, and document the lurking gotchas along the way.
> 
> Patch 01 is a fix from Paolo that's already been merged but hasn't made
> its way to kvm/queue.  It's included here to avoid a number of conflicts.
> 
> Based on kvm/queue, commit 1cf84614b04a ("KVM: x86: Exit to ...")

Queued, thanks; patches 24-26 for 5.16 and the rest for 5.17.

Just one nit: please tune the language to have a little fewer idiomatic 
phrases, as that can be a bit taxing on non-native speakers.  I for one 
enjoy learning a few new words, and it even adds some "personality" to 
the remote interactions, but it probably distracts people that aren't 
too preficient in English.

Paolo

> v3:
>   - Rebase to kvm/queue (and drop non-x86 patches as they've been queued).
>   - Redo AVIC patches, sadly the vcpu_(un)blocking() hooks need to stay.
>   - Add a patch to fix a missing (docuentation-only) barrier in nested
>     posted interrupt delivery. [Paolo]
>   - Collect reviews.
> 
> v2:
>   - https://lore.kernel.org/all/20211009021236.4122790-1-seanjc@google.com/
>   - Collect reviews. [Christian, David]
>   - Add patch to move arm64 WFI functionality out of hooks. [Marc]
>   - Add RISC-V to the fun.
>   - Add all the APICv fun.
> 
> v1: https://lkml.kernel.org/r/20210925005528.1145584-1-seanjc@google.com
> 
> Paolo Bonzini (1):
>    KVM: fix avic_set_running for preemptable kernels
> 
> Sean Christopherson (25):
>    KVM: nVMX: Ensure vCPU honors event request if posting nested IRQ
>      fails
>    KVM: VMX: Clean up PI pre/post-block WARNs
>    KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
>    KVM: Drop unused kvm_vcpu.pre_pcpu field
>    KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
>    KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
>    KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
>    KVM: x86: Remove defunct pre_block/post_block kvm_x86_ops hooks
>    KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
>    KVM: SVM: Don't bother checking for "running" AVIC when kicking for
>      IPIs
>    KVM: SVM: Remove unnecessary APICv/AVIC update in vCPU unblocking path
>    KVM: SVM: Use kvm_vcpu_is_blocking() in AVIC load to handle preemption
>    KVM: SVM: Skip AVIC and IRTE updates when loading blocking vCPU
>    iommu/amd: KVM: SVM: Use pCPU to infer IsRun state for IRTE
>    KVM: VMX: Don't do full kick when triggering posted interrupt "fails"
>    KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this
>      vCPU
>    KVM: VMX: Pass desired vector instead of bool for triggering posted
>      IRQ
>    KVM: VMX: Fold fallback path into triggering posted IRQ helper
>    KVM: VMX: Don't do full kick when handling posted interrupt wakeup
>    KVM: SVM: Drop AVIC's intermediate avic_set_running() helper
>    KVM: SVM: Move svm_hardware_setup() and its helpers below svm_x86_ops
>    KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC is disabled
>    KVM: x86: Skip APICv update if APICv is disable at the module level
>    KVM: x86: Drop NULL check on kvm_x86_ops.check_apicv_inhibit_reasons
>    KVM: x86: Unexport __kvm_request_apicv_update()
> 
>   arch/x86/include/asm/kvm-x86-ops.h |   2 -
>   arch/x86/include/asm/kvm_host.h    |  12 -
>   arch/x86/kvm/hyperv.c              |   3 +
>   arch/x86/kvm/lapic.c               |   2 -
>   arch/x86/kvm/svm/avic.c            | 116 ++++---
>   arch/x86/kvm/svm/svm.c             | 479 ++++++++++++++---------------
>   arch/x86/kvm/svm/svm.h             |  16 +-
>   arch/x86/kvm/vmx/posted_intr.c     | 234 +++++++-------
>   arch/x86/kvm/vmx/posted_intr.h     |   8 +-
>   arch/x86/kvm/vmx/vmx.c             |  66 ++--
>   arch/x86/kvm/vmx/vmx.h             |   3 +
>   arch/x86/kvm/x86.c                 |  41 ++-
>   drivers/iommu/amd/iommu.c          |   6 +-
>   include/linux/amd-iommu.h          |   6 +-
>   include/linux/kvm_host.h           |   3 -
>   virt/kvm/kvm_main.c                |   3 -
>   16 files changed, 510 insertions(+), 490 deletions(-)
> 

