Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15923107D7
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 10:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhBEJ22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 04:28:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229977AbhBEJZ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 04:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612517071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3H9mnK0htSrk+0iAVGc6yh1bw0zDy0MOzHt8lRTm/x8=;
        b=DJrSwz73OT7tkW9OsYOiWi2CcaoMRKJeD+CUT8HBmHMcnOKPGw77Cmz457hWnIbQnKoBPy
        Nc05NJ5zxQ6yqMCHBxz8iTsNI/9zY7ngg7zKNyd6WuTQEF81OFxh9GkGeBYgAjK5sNPBJl
        8DHWqbY+o5zseS3JnKndwpRLQtZwpLY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-Qm8EDn6hPrWdKwoOxWf6rA-1; Fri, 05 Feb 2021 04:24:30 -0500
X-MC-Unique: Qm8EDn6hPrWdKwoOxWf6rA-1
Received: by mail-ed1-f72.google.com with SMTP id i13so6447225edq.19
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 01:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3H9mnK0htSrk+0iAVGc6yh1bw0zDy0MOzHt8lRTm/x8=;
        b=Cc6GlGaYueWLljJL8u0tGnCxZKw4JoojcjmAQeEtiFbLNSj4sipaL7RXfPTLQBTm9S
         9kfXaK8qc/FRlmbG15y3smvC8MfucTmmnkEm2BVkChuLfu3YvnynzSIVc7TdvEeq3J6n
         EDlByWAmXGStPAxh5ObudmCx/bMo8eVdjLxSKvSm4UKwujrVN5wMWpGPTfhXKzCn4H1O
         T1GWv8xv22uPYq7/N000S1ikXzC2O3h0pzLjILlrlwtAEPJrdGntehon0+LCi6AJvfwc
         yyuPsNBvi+4Fz6PRSrg9P+FBz+pV0M0kFrMxF2wQk0R4AV2R9pfvwXBhFvzvUp01dvT+
         c8xg==
X-Gm-Message-State: AOAM530nx+KoPukaFk8BILXsGsuRbf2FNEefakYucBNqYZwZP0gigiG1
        dtyKrp13V3zOf/gVdadFzczxA8/SFiW/N9K/P6gExqTlOaDZRvttO0joSJBHKAbD62BYeY6rhJy
        U+binstXcisHD
X-Received: by 2002:a17:906:5e5a:: with SMTP id b26mr3078684eju.327.1612517068414;
        Fri, 05 Feb 2021 01:24:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPtjWpIzA36eowWHr9mnl3mDIzunyyiX9F78zWN6lXErigabdX/+t41pV4Sj/j6GteMKCUBw==
X-Received: by 2002:a17:906:5e5a:: with SMTP id b26mr3078659eju.327.1612517068201;
        Fri, 05 Feb 2021 01:24:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ov9sm3671341ejb.53.2021.02.05.01.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 01:24:27 -0800 (PST)
Subject: Re: [PATCH v4 0/5] KVM: PKS Virtualization support
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <adf80c59-8309-75a6-4678-7fee03529d7d@redhat.com>
Date:   Fri, 5 Feb 2021 10:24:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205083706.14146-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 09:37, Chenyi Qiang wrote:
> Protection Keys for Supervisor Pages(PKS) is a feature that extends the
> Protection Keys architecture to support thread-specific permission
> restrictions on supervisor pages.
> 
> PKS works similar to an existing feature named PKU(protecting user pages).
> They both perform an additional check after all legacy access
> permissions checks are done. If violated, #PF occurs and PFEC.PK bit will
> be set. PKS introduces MSR IA32_PKRS to manage supervisor protection key
> rights. The MSR contains 16 pairs of ADi and WDi bits. Each pair
> advertises on a group of pages with the same key which is set in the
> leaf paging-structure entries(bits[62:59]). Currently, IA32_PKRS is not
> supported by XSAVES architecture.
> 
> This patchset aims to add the virtualization of PKS in KVM. It
> implemented PKS CPUID enumeration, vmentry/vmexit configuration, MSR
> exposure, nested supported etc. Currently, PKS is not yet supported for
> shadow paging.
> 
> PKS bare metal support:
> https://lore.kernel.org/lkml/20201106232908.364581-1-ira.weiny@intel.com/
> 
> Detailed information about PKS can be found in the latest Intel 64 and
> IA-32 Architectures Software Developer's Manual.
> 
> ---
> 
> Changelogs:
> 
> v3->v4
> - Make the MSR intercept and load-controls setting depend on CR4.PKS value
> - shadow the guest pkrs and make it usable in PKS emultion
> - add the cr4_pke and cr4_pks check in pkr_mask update
> - squash PATCH 2 and PATCH 5 to make the dependencies read more clear
> - v3: https://lore.kernel.org/lkml/20201105081805.5674-1-chenyi.qiang@intel.com/
> 
> v2->v3:
> - No function changes since last submit
> - rebase on the latest PKS kernel support:
>    https://lore.kernel.org/lkml/20201102205320.1458656-1-ira.weiny@intel.com/
> - add MSR_IA32_PKRS to the vmx_possible_passthrough_msrs[]
> - RFC v2: https://lore.kernel.org/lkml/20201014021157.18022-1-chenyi.qiang@intel.com/
> 
> v1->v2:
> - rebase on the latest PKS kernel support:
>    https://github.com/weiny2/linux-kernel/tree/pks-rfc-v3
> - add a kvm-unit-tests for PKS
> - add the check in kvm_init_msr_list for PKRS
> - place the X86_CR4_PKS in mmu_role_bits in kvm_set_cr4
> - add the support to expose VM_{ENTRY, EXIT}_LOAD_IA32_PKRS in nested
>    VMX MSR
> - RFC v1: https://lore.kernel.org/lkml/20200807084841.7112-1-chenyi.qiang@intel.com/
> 
> ---
> 
> Chenyi Qiang (5):
>    KVM: VMX: Introduce PKS VMCS fields
>    KVM: X86: Expose PKS to guest
>    KVM: MMU: Rename the pkru to pkr
>    KVM: MMU: Add support for PKS emulation
>    KVM: VMX: Enable PKS for nested VM
> 
>   arch/x86/include/asm/kvm_host.h | 17 +++---
>   arch/x86/include/asm/pkeys.h    |  1 +
>   arch/x86/include/asm/vmx.h      |  6 ++
>   arch/x86/kvm/cpuid.c            |  3 +-
>   arch/x86/kvm/mmu.h              | 23 ++++----
>   arch/x86/kvm/mmu/mmu.c          | 81 +++++++++++++++------------
>   arch/x86/kvm/vmx/capabilities.h |  6 ++
>   arch/x86/kvm/vmx/nested.c       | 38 ++++++++++++-
>   arch/x86/kvm/vmx/vmcs.h         |  1 +
>   arch/x86/kvm/vmx/vmcs12.c       |  2 +
>   arch/x86/kvm/vmx/vmcs12.h       |  6 +-
>   arch/x86/kvm/vmx/vmx.c          | 99 +++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/vmx.h          |  1 +
>   arch/x86/kvm/x86.c              | 11 +++-
>   arch/x86/kvm/x86.h              |  8 +++
>   arch/x86/mm/pkeys.c             |  6 ++
>   include/linux/pkeys.h           |  4 ++
>   17 files changed, 249 insertions(+), 64 deletions(-)
> 

Looks mostly good, but I'll only be able to include it after the bare 
metal implementation is in.

Paolo

