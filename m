Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221DD330CB2
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 12:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhCHLun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 06:50:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbhCHLub (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 06:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615204230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0TFSYLha6a0vpq1M3uSXuHRS2yOwWaJYpG7AjZVTwo=;
        b=guhBdftQv1BFmrW4vk44i+vEQRczvsg18iSDE9oQMbyHHRqDJTlUyRRsrzbbCHeLqsoUIn
        eWciuSv5PRykeTYXxTAhRu3Bij0d8KN+I6ivYoDnrVFWtAudcbWgphXfLib3/KWHz5LSEV
        f2yuAfWuEk5FwT837FS4BdM7akhYxhQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-f7cGjW9FPK6Gcuu3hWqiyw-1; Mon, 08 Mar 2021 06:50:29 -0500
X-MC-Unique: f7cGjW9FPK6Gcuu3hWqiyw-1
Received: by mail-wm1-f70.google.com with SMTP id n25so4856237wmk.1
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 03:50:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O0TFSYLha6a0vpq1M3uSXuHRS2yOwWaJYpG7AjZVTwo=;
        b=fVVejJlFF/dASD+7Ni2HRYSmG9bFB/x48JRzrEduTEmxzLEx5Y/axGLqklHAHWTqpr
         RPMzF+QINhkvY3+xbnyLNghvkH6PWH6F7LqmDGQdsrpICexznMWt4nkwzP0HORcS1Vnl
         dmu7iyn1TdzRwNpfaf4/DBp2o3UQE+qH+lKnJBlK8qfAeioktje0Ytm9FRey0Ry1G1up
         8YRYWc5aQicQ0iy7bSc5Nv1BMiOZLN2ODyecdDuQT57qbm0oGUbamZIEDG+N1Z2hHrPg
         oKxHKLye3JQ0HLPK3Hpr5Y5Yr31rF6d28IMFLqbBWuPL+Vyj4roeIzsIJMj3I9kEdpfy
         z9Pw==
X-Gm-Message-State: AOAM532JEtZd+J1bITJ+EzSqL4vbkH0Q17MhMGIIsEesk0j8zuszLDCs
        1e4bkc41MiGsrCMZ93Heg+joJF5RoRFDWtiw7tP41R6WoQq4ZLteouRpxQmbmgleOASQ2jvUXNA
        yTIe9zZLUqWaC
X-Received: by 2002:a5d:4dd2:: with SMTP id f18mr22511955wru.366.1615204228215;
        Mon, 08 Mar 2021 03:50:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJfXvs2sG6TtEy9A4UyNy1PtgCnl/jo51idx7hQhuh6QVMESxcW2SeBdv1/Mfl+RV0rw6hyw==
X-Received: by 2002:a5d:4dd2:: with SMTP id f18mr22511935wru.366.1615204228004;
        Mon, 08 Mar 2021 03:50:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id e8sm19283591wme.14.2021.03.08.03.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 03:50:27 -0800 (PST)
Subject: Re: [PATCH v4 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20210305183123.3978098-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1edcb01-41f5-d26f-e8d6-0dbd09a1eb89@redhat.com>
Date:   Mon, 8 Mar 2021 12:50:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 19:31, Sean Christopherson wrote:
> Clean up KVM's PV TLB flushing when running with EPT on Hyper-V, i.e. as
> a nested VMM.  No real goal in mind other than the sole patch in v1, which
> is a minor change to avoid a future mixup when TDX also wants to define
> .remote_flush_tlb.  Everything else is opportunistic clean up.
> 
> NOTE: Based on my NPT+SME bug fix series[*] due to multiple conflicts with
>        non-trivial resolutions.
> 
> [*] https://lkml.kernel.org/r/20210305011101.3597423-1-seanjc@google.com
> 
> 
> Patch 1 legitimately tested on VMX and SVM (including i386).  Patches 2+
> smoke tested by hacking usage of the relevant flows without actually
> routing to the Hyper-V hypercalls (partial hack-a-patch below).
> 
> -static inline int hv_remote_flush_root_ept(hpa_t root_ept,
> +static inline int hv_remote_flush_root_ept(struct kvm *kvm, hpa_t root_ept,
>                                             struct kvm_tlb_range *range)
>   {
> -       if (range)
> -               return hyperv_flush_guest_mapping_range(root_ept,
> -                               kvm_fill_hv_flush_list_func, (void *)range);
> -       else
> -               return hyperv_flush_guest_mapping(root_ept);
> +       if (range) {
> +               kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
> +               return 0;
> +       }
> +
> +       return -ENOMEM;
>   }
>   
>   static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> @@ -7753,8 +7754,7 @@ static __init int hardware_setup(void)
>                  vmx_x86_ops.update_cr8_intercept = NULL;
>   
>   #if IS_ENABLED(CONFIG_HYPERV)
> -       if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
> -           && enable_ept) {
> +       if (enable_ept) {
>                  vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
>                  vmx_x86_ops.tlb_remote_flush_with_range =
>                                  hv_remote_flush_tlb_with_range;
> 
> v4:
>    - Rebased to kvm/queue, commit fe5f0041c026 ("KVM/SVM: Move vmenter.S
>      exception fixups out of line"), plus the aforementioned series.
>    - Don't grab PCID for nested_cr3 (NPT). [Paolo]
>    - Collect reviews. [Vitaly]
> 
> v3:
>    - https://lkml.kernel.org/r/20201027212346.23409-1-sean.j.christopherson@intel.com
>    - Add a patch to pass the root_hpa instead of pgd to vmx_load_mmu_pgd()
>      and retrieve the active PCID only when necessary.  [Vitaly]
>    - Selectively collects reviews (skipped a few due to changes). [Vitaly]
>    - Explicitly invalidate hv_tlb_eptp instead of leaving it valid when
>      the mismatch tracker "knows" it's invalid. [Vitaly]
>    - Change the last patch to use "hv_root_ept" instead of "hv_tlb_pgd"
>      to better reflect what is actually being tracked.
> 
> v2:
>    - Rewrite everything.
>    - https://lkml.kernel.org/r/20201020215613.8972-1-sean.j.christopherson@intel.com
> 
> v1: ???
> 
> Sean Christopherson (11):
>    KVM: x86: Get active PCID only when writing a CR3 value
>    KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
>    KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB
>      flush
>    KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
>    KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
>    KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
>    KVM: VMX: Don't invalidate hv_tlb_eptp if the new EPTP matches
>    KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
>    KVM: VMX: Define Hyper-V paravirt TLB flush fields iff Hyper-V is
>      enabled
>    KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
>    KVM: VMX: Track root HPA instead of EPTP for paravirt Hyper-V TLB
>      flush
> 
>   arch/x86/include/asm/kvm_host.h |   4 +-
>   arch/x86/kvm/mmu.h              |   4 +-
>   arch/x86/kvm/svm/svm.c          |  10 ++-
>   arch/x86/kvm/vmx/vmx.c          | 134 ++++++++++++++++++--------------
>   arch/x86/kvm/vmx/vmx.h          |  19 ++---
>   5 files changed, 92 insertions(+), 79 deletions(-)
> 

Huh, I was sure I had queued this already for 5.12.  Well, done so now.

Paolo

