Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288D336308D
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 16:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhDQOQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 10:16:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDQOQB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 10:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618668934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SOIr0O8qNdC79R0JFUW4qMw8jEh2rv7ToA0peixdmns=;
        b=NJjfrFUDgKgNjuZHsNz2GTfi5GFQiQdgKMmCnCed6ItlEKKLApvXLikzhGzaArcC5Yhcfs
        ARJwhNTK4P9utgAdixG9hrVZQG0wirQLKoU1CKwU+5nF07UJ1ua4PBoVfwdXcWLD368RGd
        m2Hk5Wn8kNmGUd2iKM5367H1tlZr3Y0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-12kr-6rAOFemj8kC87UrUQ-1; Sat, 17 Apr 2021 10:15:32 -0400
X-MC-Unique: 12kr-6rAOFemj8kC87UrUQ-1
Received: by mail-ed1-f72.google.com with SMTP id o4-20020a0564024384b0290378d45ecf57so8758575edc.12
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 07:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SOIr0O8qNdC79R0JFUW4qMw8jEh2rv7ToA0peixdmns=;
        b=ksoBvriRCYi/R4V9rqXa8FYO09Sn04MQQZj3Grx3vJnrg2vcF+O1eopptcNpys4VGE
         705+zHPf5i195Vxn5orF5ecFNfzC/BnW895ZWvzN8u6AYQG9eUXYAnOGETHxQ2Skre8r
         vCHQZnQf2u7HzqolAM77d8NMkRxhqYe5MZeWhAJfBhnLZattMPt5zugNJrhqIg+EI4fG
         kOOPYvzHKw/5NmVX5+ISLynN4zvEZHXA/bdXQsrRk98T2XKbxj3hiMH6zeu4tbA2OQcj
         DLUN5iSw2Ohkc2wz+IXb/ng6LmogL7xlYkFxLI/8OfZgA9EZgC82qazGTJaFExul3VFM
         SfIA==
X-Gm-Message-State: AOAM532osvm9Ii9ey0B1XFRqFIlH8csireVnu9Af6kd1Q7FaPSLw/hZd
        yFqQjVbN1VZfwW3nFBfzsEhH+N/DzsWSZxE/PB5N6iwTcQZhcYGC/3V6UeeyU2q+jLlNbNnVVjt
        wFeecAc/h723Q
X-Received: by 2002:a17:907:7283:: with SMTP id dt3mr13272859ejc.47.1618668931422;
        Sat, 17 Apr 2021 07:15:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7HEHzueEsTbrb651H8CrQ5let5IV0G8SS/liBr9u0c8MibRnPOiYT3SauemaXJfwp1Ab3Xw==
X-Received: by 2002:a17:907:7283:: with SMTP id dt3mr13272843ejc.47.1618668931230;
        Sat, 17 Apr 2021 07:15:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g12sm3961641edr.83.2021.04.17.07.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 07:15:30 -0700 (PDT)
Subject: Re: [PATCH v5 00/11] KVM SGX virtualization support (KVM part)
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d78d00de-0e4e-a310-53e4-152f23f4b5ea@redhat.com>
Date:   Sat, 17 Apr 2021 16:15:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 06:21, Kai Huang wrote:
> Hi Paolo, Sean,
> 
> Boris has merged x86 part patches to the tip/x86/sgx. This series is KVM part
> patches. Due to some code change in x86 part patches, two KVM patches need
> update so this is the new version. Please help to review. Thanks!
> 
> Specifically, x86 patch (x86/sgx: Add helpers to expose ECREATE and EINIT to
> KVM) was changed to return -EINVAL directly w/o setting trapnr when
> access_ok()s fail on any user pointers, so KVM patches:
> 
> KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
> KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
> 
> were updated to handle this case.
> 
> This seris was firstly based on tip/x86/sgx, and then rebased to latest
> kvm/queue, so it can be applied to kvm/queue directly now.
> 
> Changelog:
> 
> (Please see individual patch for changelog for specific patch)
> 
> v4->v5:
>   - Addressed Sean's comments (patch 06, 07, 09 were slightly updated).
>   - Rebased to latest kvm/queue (patch 08, 11 were updated to resolve conflict).
> 
> Sean Christopherson (11):
>    KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
>    KVM: x86: Define new #PF SGX error code bit
>    KVM: x86: Add support for reverse CPUID lookup of scattered features
>    KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
>    KVM: VMX: Add basic handling of VM-Exit from SGX enclave
>    KVM: VMX: Frame in ENCLS handler for SGX virtualization
>    KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
>    KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
>    KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
>    KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
>    KVM: x86: Add capability to grant VM access to privileged SGX
>      attribute
> 
>   Documentation/virt/kvm/api.rst  |  23 ++
>   arch/x86/include/asm/kvm_host.h |   5 +
>   arch/x86/include/asm/vmx.h      |   1 +
>   arch/x86/include/uapi/asm/vmx.h |   1 +
>   arch/x86/kvm/Makefile           |   2 +
>   arch/x86/kvm/cpuid.c            |  89 +++++-
>   arch/x86/kvm/cpuid.h            |  50 +++-
>   arch/x86/kvm/vmx/nested.c       |  28 +-
>   arch/x86/kvm/vmx/nested.h       |   5 +
>   arch/x86/kvm/vmx/sgx.c          | 502 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/sgx.h          |  34 +++
>   arch/x86/kvm/vmx/vmcs12.c       |   1 +
>   arch/x86/kvm/vmx/vmcs12.h       |   4 +-
>   arch/x86/kvm/vmx/vmx.c          | 109 ++++++-
>   arch/x86/kvm/vmx/vmx.h          |   3 +
>   arch/x86/kvm/x86.c              |  23 ++
>   include/uapi/linux/kvm.h        |   1 +
>   17 files changed, 858 insertions(+), 23 deletions(-)
>   create mode 100644 arch/x86/kvm/vmx/sgx.c
>   create mode 100644 arch/x86/kvm/vmx/sgx.h
> 

Queued, thanks.

Paolo

