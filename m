Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55931361B
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhBHPGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:06:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232676AbhBHPE3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 10:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612796562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DR49OgLueRyHpA+lnoLuAYbqkdnnsGY7HEhzsoXTolQ=;
        b=LwY8RV2GMQZu62tDEd6rzQy7ENLEI3fOltgzUoQONUb1Vc5qEudIMXnt0pz/99gHQqhOqF
        f2XZUuPJI2cs0sPYsqWtc7MAdtWeKYvSiqIx/vOfDb0RCGBIqZMF2T+GHgcWfgq4V4nAvY
        U44RaA8fouAWPBd4OiEspWvPEV5SpSA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-G4qd_u2sNsuMX1jAIHhUgg-1; Mon, 08 Feb 2021 10:02:40 -0500
X-MC-Unique: G4qd_u2sNsuMX1jAIHhUgg-1
Received: by mail-wm1-f71.google.com with SMTP id b62so8856017wmc.5
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 07:02:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DR49OgLueRyHpA+lnoLuAYbqkdnnsGY7HEhzsoXTolQ=;
        b=LfqTHiv5dvT7ICkowNHPRK2A6mj1lVm1Bdwg4suRzteubk9DiCPLzayrspQh4/H2VE
         iRRilLAr+WxFJo3E0KuxiEkplyvfVcf3e1esmZCv96Jt0GXMPEg4s+JQqadbRRp8PdVL
         CXPWhIwKuUQrJ3+R/hFbmU3ixfHNYuP8piAKd9yOWVWepCgxVjiTzLPo9OSyZM4oEUmx
         3XGssFzu3RQhVVgk1gatGhkCkU9dCdfY38+ivNgZbh7o2mY8Sqf0nhTIbgGtcPcjCaV2
         lWOw/fA5/luj12YIVNuPXNVIQ+T5q0xbOuvMNd7oCA3UVemPz0jUZtOTtKf3H3DKk5O1
         qR9w==
X-Gm-Message-State: AOAM533KqNb2fI5x1SJd5UnNEom8rts+4SiGLU1Q63zepmaJlIozdM/q
        avshxsSLPuMf4wpCL++ZoTm+JLzINABvGXeNIkupfh6y63zqcLin0Gb82iK/uNzfxs1jQsin3Fz
        +Jst9Q+ruSowV
X-Received: by 2002:a5d:5484:: with SMTP id h4mr20710813wrv.94.1612796558892;
        Mon, 08 Feb 2021 07:02:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGMBz1Uht2kZ9CFfQA+dRAmxRYnSif3T7CPLCOrCqiDxc7jRgBTwBmlZSlJSJuNPSao+6lKA==
X-Received: by 2002:a5d:5484:: with SMTP id h4mr20710788wrv.94.1612796558597;
        Mon, 08 Feb 2021 07:02:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z8sm28368201wrh.83.2021.02.08.07.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:02:37 -0800 (PST)
Subject: Re: [PATCH v2 00/15] KVM: x86: Conditional Hyper-V emulation
 enablement
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
 <b88c62a9-2c64-4de9-b27e-dce969bf8c07@redhat.com>
 <87czxaod7j.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b5be2cf-2edc-3abf-e962-c0a017f9ebec@redhat.com>
Date:   Mon, 8 Feb 2021 16:02:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87czxaod7j.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 15:18, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 26/01/21 14:48, Vitaly Kuznetsov wrote:
>>> Changes since v1 [Sean]:
>>> - Add a few cleanup patches ("Rename vcpu_to_hv_vcpu() to to_hv_vcpu()",
>>>     "Rename vcpu_to_synic()/synic_to_vcpu()", ...)
>>> - Drop unused kvm_hv_vapic_assist_page_enabled()
>>> - Stop shadowing global 'current_vcpu' variable in kvm_hv_flush_tlb()/
>>>     kvm_hv_send_ipi()
>>>
>>> Original description:
>>>
>>> Hyper-V emulation is enabled in KVM unconditionally even for Linux guests.
>>> This is bad at least from security standpoint as it is an extra attack
>>> surface. Ideally, there should be a per-VM capability explicitly enabled by
>>> VMM but currently it is not the case and we can't mandate one without
>>> breaking backwards compatibility. We can, however, check guest visible CPUIDs
>>> and only enable Hyper-V emulation when "Hv#1" interface was exposed in
>>> HYPERV_CPUID_INTERFACE.
>>>
>>> Also (and while on it) per-vcpu Hyper-V context ('struct kvm_vcpu_hv') is
>>> currently part of 'struct kvm_vcpu_arch' and thus allocated unconditionally
>>> for each vCPU. The context, however, quite big and accounts for more than
>>> 1/4 of 'struct kvm_vcpu_arch' (e.g. 2912/9512 bytes). Switch to allocating
>>> it dynamically. This may come handy if we ever decide to raise KVM_MAX_VCPUS
>>> (and rumor has it some downstream distributions already have more than '288')
>>>
>>> Vitaly Kuznetsov (15):
>>>     selftests: kvm: Move kvm_get_supported_hv_cpuid() to common code
>>>     selftests: kvm: Properly set Hyper-V CPUIDs in evmcs_test
>>>     KVM: x86: hyper-v: Drop unused kvm_hv_vapic_assist_page_enabled()
>>>     KVM: x86: hyper-v: Rename vcpu_to_hv_vcpu() to to_hv_vcpu()
>>>     KVM: x86: hyper-v: Rename vcpu_to_synic()/synic_to_vcpu()
>>>     KVM: x86: hyper-v: Rename vcpu_to_stimer()/stimer_to_vcpu()
>>>     KVM: x86: hyper-v: Rename vcpu_to_hv_syndbg() to to_hv_syndbg()
>>>     KVM: x86: hyper-v: Introduce to_kvm_hv() helper
>>>     KVM: x86: hyper-v: Stop shadowing global 'current_vcpu' variable
>>>     KVM: x86: hyper-v: Always use to_hv_vcpu() accessor to get to 'struct
>>>       kvm_vcpu_hv'
>>>     KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context
>>>     KVM: x86: hyper-v: Allocate 'struct kvm_vcpu_hv' dynamically
>>>     KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional
>>>     KVM: x86: hyper-v: Allocate Hyper-V context lazily
>>>     KVM: x86: hyper-v: Drop hv_vcpu_to_vcpu() helper
>>>
> ...
>>>
>>
>> Queued, thanks.
> 
> I was expecting it to appear in kvm/queue but it didn't happen so just
> wanted to double-check what happened to these patches. Thanks!

Added them back now (they conflicted with the Xen patches), thanks.

Paolo

