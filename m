Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CFA307808
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhA1O1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:27:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231807AbhA1O1A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:27:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611843933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gCEF771+N+0tqQ1UU9+sM7hJ1Ni/JpDJH0gQdEd2dYk=;
        b=XKT4nmfgbgfJY9s7D5dcTXuvS8t4zsKsZg4QPukdApTgrZCd43229ffKrzH+e0a6pXONDp
        T0/PAm2VO17ZDf4zgjD6V9Yl9v25gR9o5XWSWCWPrpBLHlwXDlB8iQR6oOdl1iPhMjN9F+
        2GO2zxZuT+LZg/aZMqjWiwAYpZ5oEqU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-cdx5GjfmNUeCEig6uTGf5w-1; Thu, 28 Jan 2021 09:25:29 -0500
X-MC-Unique: cdx5GjfmNUeCEig6uTGf5w-1
Received: by mail-ed1-f70.google.com with SMTP id j12so3231778edq.10
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 06:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gCEF771+N+0tqQ1UU9+sM7hJ1Ni/JpDJH0gQdEd2dYk=;
        b=WPZHQoBfYEuPlRaY9i6LDSUpLeJGcf41sUkyrUTjXk0tryPAMTH0miuIXLJPMDGlPu
         0lPoNMqhXnu7+kDPjcqxpNzilQDszZ/zEXZpydH9+l8R4AYbw5uzVnA+onkrmPcTOgXV
         K5g2JuJ+Qgv9z2MxI8Xbit3tHRNfPWrZkQmgllPrxPpLWUw6SxARuMOPaabIapMQEEqB
         Trq2HK4zIKvhNK6n/UuijHCdow1tFinFt8cENXMkYIA/HVLbd3j5YnHlSX2jDIUqLQK+
         z0zZuQcn21cFpC5qKyEdAUPvj/+CFWENfbIrXfCaeciV0nrJHY5ytnTecnTfIInR2LjA
         j6fQ==
X-Gm-Message-State: AOAM531ZC/N5ZoGI8eMQ71zcFDOlfK9kYZFCQ8ukAfpxiMpxjjwA72Fa
        xEYsT+H8Urr/brZs6sSd8qkjM4wreWau5eGbDgfV7V/19yX2S/+cSRNW92Ah03D4erhBPF01N0t
        Hp0hp4ablBYFc
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr15004818edv.54.1611843928273;
        Thu, 28 Jan 2021 06:25:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxU+Ebdj2Ew74gGp6yLKN8vOrdi+Py2KnFRn4EY1m7ttv2yLSS/rf+33tN1pFpUlKJ290CWMw==
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr15004805edv.54.1611843928121;
        Thu, 28 Jan 2021 06:25:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id pw28sm2364602ejb.115.2021.01.28.06.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:25:27 -0800 (PST)
Subject: Re: [PATCH v2 00/15] KVM: x86: Conditional Hyper-V emulation
 enablement
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b88c62a9-2c64-4de9-b27e-dce969bf8c07@redhat.com>
Date:   Thu, 28 Jan 2021 15:25:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 14:48, Vitaly Kuznetsov wrote:
> Changes since v1 [Sean]:
> - Add a few cleanup patches ("Rename vcpu_to_hv_vcpu() to to_hv_vcpu()",
>    "Rename vcpu_to_synic()/synic_to_vcpu()", ...)
> - Drop unused kvm_hv_vapic_assist_page_enabled()
> - Stop shadowing global 'current_vcpu' variable in kvm_hv_flush_tlb()/
>    kvm_hv_send_ipi()
> 
> Original description:
> 
> Hyper-V emulation is enabled in KVM unconditionally even for Linux guests.
> This is bad at least from security standpoint as it is an extra attack
> surface. Ideally, there should be a per-VM capability explicitly enabled by
> VMM but currently it is not the case and we can't mandate one without
> breaking backwards compatibility. We can, however, check guest visible CPUIDs
> and only enable Hyper-V emulation when "Hv#1" interface was exposed in
> HYPERV_CPUID_INTERFACE.
> 
> Also (and while on it) per-vcpu Hyper-V context ('struct kvm_vcpu_hv') is
> currently part of 'struct kvm_vcpu_arch' and thus allocated unconditionally
> for each vCPU. The context, however, quite big and accounts for more than
> 1/4 of 'struct kvm_vcpu_arch' (e.g. 2912/9512 bytes). Switch to allocating
> it dynamically. This may come handy if we ever decide to raise KVM_MAX_VCPUS
> (and rumor has it some downstream distributions already have more than '288')
> 
> Vitaly Kuznetsov (15):
>    selftests: kvm: Move kvm_get_supported_hv_cpuid() to common code
>    selftests: kvm: Properly set Hyper-V CPUIDs in evmcs_test
>    KVM: x86: hyper-v: Drop unused kvm_hv_vapic_assist_page_enabled()
>    KVM: x86: hyper-v: Rename vcpu_to_hv_vcpu() to to_hv_vcpu()
>    KVM: x86: hyper-v: Rename vcpu_to_synic()/synic_to_vcpu()
>    KVM: x86: hyper-v: Rename vcpu_to_stimer()/stimer_to_vcpu()
>    KVM: x86: hyper-v: Rename vcpu_to_hv_syndbg() to to_hv_syndbg()
>    KVM: x86: hyper-v: Introduce to_kvm_hv() helper
>    KVM: x86: hyper-v: Stop shadowing global 'current_vcpu' variable
>    KVM: x86: hyper-v: Always use to_hv_vcpu() accessor to get to 'struct
>      kvm_vcpu_hv'
>    KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context
>    KVM: x86: hyper-v: Allocate 'struct kvm_vcpu_hv' dynamically
>    KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional
>    KVM: x86: hyper-v: Allocate Hyper-V context lazily
>    KVM: x86: hyper-v: Drop hv_vcpu_to_vcpu() helper
> 
>   arch/x86/include/asm/kvm_host.h               |   4 +-
>   arch/x86/kvm/cpuid.c                          |   2 +
>   arch/x86/kvm/hyperv.c                         | 301 +++++++++++-------
>   arch/x86/kvm/hyperv.h                         |  54 ++--
>   arch/x86/kvm/lapic.c                          |   5 +-
>   arch/x86/kvm/lapic.h                          |   7 +-
>   arch/x86/kvm/vmx/vmx.c                        |   9 +-
>   arch/x86/kvm/x86.c                            |  19 +-
>   .../selftests/kvm/include/x86_64/processor.h  |   3 +
>   .../selftests/kvm/lib/x86_64/processor.c      |  33 ++
>   .../testing/selftests/kvm/x86_64/evmcs_test.c |  39 ++-
>   .../selftests/kvm/x86_64/hyperv_cpuid.c       |  31 +-
>   12 files changed, 314 insertions(+), 193 deletions(-)
> 

Queued, thanks.

Paolo

