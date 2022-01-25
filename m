Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F14849B8C2
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583704AbiAYQd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:33:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240178AbiAYQcW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:32:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643128331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNqYyYM/iBn+DAAAtNRM27AQBCsK9dS6alJG9G0Mm8Y=;
        b=fn/Op55SJXc/YE148E/l6ZYrhPDMduq/JHf+ogbr24ZSuAwoGS7pOscJ6srEox3393kqgS
        5CxwYDwjxGJqFyoa8qExHIqHnbmiMq2sniLyQmtoM/3uSdObNSIpL2cephYMJzESAlZ09Q
        eIOw5XV7e8EVJbEmDUFC4mtxDL7L5uw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-0OKNSrZcPvStFSUoNDhO2w-1; Tue, 25 Jan 2022 11:32:10 -0500
X-MC-Unique: 0OKNSrZcPvStFSUoNDhO2w-1
Received: by mail-ej1-f69.google.com with SMTP id x16-20020a170906135000b006b5b4787023so3651525ejb.12
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:32:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cNqYyYM/iBn+DAAAtNRM27AQBCsK9dS6alJG9G0Mm8Y=;
        b=7tTiNt3sb317mVAaBnxS0n/qnXl2QDOZ3yu6M5XTCsAX6RR1JO+vRsiFcAO72tcish
         tCWsRR0Y9hbqN6GQ+SNJ7eihJex4O7k8MUYNa+0bw7sVEARyOmCtdtpFvTkMXA3lthO2
         7yTl5wvZSt5h0BnAgcweLUXigi4OPeodMiEYgrmps0AlotY9rYXtZHTEiTpbGGC8fAM0
         uUGHADMrnlGWwTLlZJJ7FGBJwlpcvKF4HoeewWHP6fQAPxR/4/bB16szuPNzlsdJsU9y
         R1ZJkCKdAD/3rEuLR62vjIMlqhik20MpnnZqHr2U8aAwnyHzDmfkossnzyX+Udn4HRLY
         A2ZQ==
X-Gm-Message-State: AOAM532dN6pQQSbFpYJys9Osiesec6UC/Wczi9Rl9/BBCL4sSyg0CXGk
        CmegVhxOdAG34KIkbtFWlRMb3fYlntn2r5JdzCbUk6ZGPAInhlLX8cv+3OWPODCdfy0Wa3RMo2U
        Vti0vLnHnpjsc
X-Received: by 2002:a50:a6ce:: with SMTP id f14mr20928072edc.105.1643128328929;
        Tue, 25 Jan 2022 08:32:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSASetUeU4GpcHRpbiCIrbj8luDf2/3Cix9ETi+7A0qx8/4HBEGpSyg+gkpkvJjEYDSKM7dQ==
X-Received: by 2002:a50:a6ce:: with SMTP id f14mr20928057edc.105.1643128328738;
        Tue, 25 Jan 2022 08:32:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gz12sm6412927ejc.124.2022.01.25.08.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 08:32:08 -0800 (PST)
Message-ID: <1e36f9f1-e019-354f-7002-7b127353c321@redhat.com>
Date:   Tue, 25 Jan 2022 17:32:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 00/19] KVM: x86: Bulk removal of unused function
 parameters
Content-Language: en-US
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220125095909.38122-1-cloudliang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 10:58, Jinrong Liang wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Hi,
> 
> This patch set is a follow up to a similar patch [1], and may
> hopefully help to improve the code quality of KVM.
> 
> Basically, the cleanup is triggered by a compiler feature[2], but obviously
> there are a lot of false positives here, and so far we may apply at least
> this changset, which also helps the related developers to think more
> carefully about why these functions were declared that way in the first
> place or what is left after a series of loosely-coupled clean-ups.
> 
> [1] https://lore.kernel.org/kvm/20220124020456.156386-1-xianting.tian@linux.alibaba.com/
> [2] ccflags-y += -Wunused-parameter
> 
> Thanks,
> Like Xu
> 
> Jinrong Liang (19):
>    KVM: x86/mmu: Remove unused "kvm" of kvm_mmu_unlink_parents()
>    KVM: x86/mmu: Remove unused "kvm" of __rmap_write_protect()
>    KVM: x86/mmu: Remove unused "vcpu" of
>      reset_{tdp,ept}_shadow_zero_bits_mask()
>    KVM: x86/tdp_mmu: Remove unused "kvm" of kvm_tdp_mmu_get_root()
>    KVM: x86/mmu_audit: Remove unused "level" of audit_spte_after_sync()
>    KVM: x86/svm: Remove unused "vcpu" of svm_check_exit_valid()
>    KVM: x86/svm: Remove unused "vcpu" of nested_svm_check_tlb_ctl()
>    KVM: x86/svm: Remove unused "vcpu" of kvm_after_interrupt()
>    KVM: x86/sev: Remove unused "svm" of sev_es_prepare_guest_switch()
>    KVM: x86/sev: Remove unused "kvm" of sev_unbind_asid()
>    KVM: x86/sev: Remove unused "vector" of sev_vcpu_deliver_sipi_vector()
>    KVM: x86/i8259: Remove unused "addr" of elcr_ioport_{read,write}()
>    KVM: x86/ioapic: Remove unused "addr" and "length" of
>      ioapic_read_indirect()
>    KVM: x86/emulate: Remove unused "ctxt" of setup_syscalls_segments()
>    KVM: x86/emulate: Remove unused "ctxt" of task_switch_{16, 32}()
>    KVM: x86: Remove unused "vcpu" of kvm_arch_tsc_has_attr()
>    KVM: x86: Remove unused "vcpu" of kvm_scale_tsc()
>    KVM: Remove unused "kvm" of kvm_make_vcpu_request()
>    KVM: Remove unused "flags" of kvm_pv_kick_cpu_op()
> 
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/emulate.c          | 20 ++++++++------------
>   arch/x86/kvm/i8259.c            |  8 ++++----
>   arch/x86/kvm/ioapic.c           |  6 ++----
>   arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++-------------
>   arch/x86/kvm/mmu/mmu_audit.c    |  4 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++--
>   arch/x86/kvm/mmu/tdp_mmu.h      |  3 +--
>   arch/x86/kvm/svm/nested.c       |  4 ++--
>   arch/x86/kvm/svm/sev.c          | 12 ++++++------
>   arch/x86/kvm/svm/svm.c          | 10 +++++-----
>   arch/x86/kvm/svm/svm.h          |  4 ++--
>   arch/x86/kvm/vmx/vmx.c          |  2 +-
>   arch/x86/kvm/x86.c              | 25 ++++++++++++-------------
>   arch/x86/kvm/x86.h              |  2 +-
>   virt/kvm/kvm_main.c             |  9 ++++-----
>   16 files changed, 63 insertions(+), 75 deletions(-)
> 

Queued the patches I didn't comment on, thanks.

Paolo

