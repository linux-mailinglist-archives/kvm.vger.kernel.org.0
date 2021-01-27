Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37EE30630A
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344186AbhA0SMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 13:12:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343858AbhA0SMQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 13:12:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611771050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/kgM17qMrEPrlxe0M/aOkXhDJH0p+mZ7iXasHYPaVmQ=;
        b=VOuG7FQNy3x+eSROODRSopmmgF9MTLr63/TbK11Dup05DZgUh3AGHynNHy9Lx/KSTlq3CH
        58Mm1bJmfcjrAH6dWp0VtDigMpBqmz/KyNNjnBwoxZbtWnSFW8cyMrwyWMxTTQCL2XIelO
        9YOWSBeOUUOcP2vGuPxmoux3bUD+BYo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-srTM3j1FNUSJX8TH7v2CsQ-1; Wed, 27 Jan 2021 13:10:47 -0500
X-MC-Unique: srTM3j1FNUSJX8TH7v2CsQ-1
Received: by mail-ej1-f70.google.com with SMTP id le12so1025152ejb.13
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 10:10:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/kgM17qMrEPrlxe0M/aOkXhDJH0p+mZ7iXasHYPaVmQ=;
        b=ERYgs+8CwBfRvImsgNw8q8/oD2cAwjoNk0MwXxjezfC49cyRpCf+RvWUKri4tTe7kf
         cub6JYLShDMdFDAY2qVtSfRy1VKiIvvf3CX5fL+geagV4oy9USMuzy/JNOdoehGdbsQ2
         ohjqREQkiDg1efKHCatTZeILDHoaMfV9lFM3pH7/D7eiQvRjPINjerMrYKK0gMz3nRP6
         BprVd9oVzwocPn0eU6nmc9+eMwPPDGzyB8WYkXpHSR+fwiFgHFXk1dZyevaZfDX0kUH9
         w5SgxIidyhzrrVDpVNHcB2IUPaynVTwTmwwlJjODdliU8IMRjtNY4JB7ItcBfxWgdPA4
         co0Q==
X-Gm-Message-State: AOAM530FtCWUu/a2gCjmzAdvUuDsL8IwYQOnmYCnkbzNZn7iaVj/nxBO
        aLc4/CaLvfzWf4iiO/HREL5+lhZGRsunaOSSem+mp+J1QBHAQ/9yHin30kEhCn/y4DGtUqlgaVY
        weRXaJZqKFOcz
X-Received: by 2002:a05:6402:22a8:: with SMTP id cx8mr10433024edb.32.1611771046519;
        Wed, 27 Jan 2021 10:10:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9W120WFC2awgy1BcLquy0pty7SpJY3ERbY32X3IB/MhCJf4ewJvvzO1xNBE89pDlsgBIVug==
X-Received: by 2002:a05:6402:22a8:: with SMTP id cx8mr10433007edb.32.1611771046361;
        Wed, 27 Jan 2021 10:10:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w6sm1167293ejj.116.2021.01.27.10.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 10:10:45 -0800 (PST)
Subject: Re: [PATCH v3 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7ed340f1-f6f7-4682-65be-6bc02f25d612@redhat.com>
Date:   Wed, 27 Jan 2021 19:10:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/20 22:23, Sean Christopherson wrote:
> Clean up KVM's PV TLB flushing when running with EPT on Hyper-V, i.e. as
> a nested VMM.  No real goal in mind other than the sole patch in v1, which
> is a minor change to avoid a future mixup when TDX also wants to define
> .remote_flush_tlb.  Everything else is opportunistic clean up.
> 
> Patch 1 legitimately tested on VMX (no SVM), everything else effectively
> build tested only.
> 
> v3:
>    - Add a patch to pass the root_hpa instead of pgd to vmx_load_mmu_pgd()
>      and retrieve the active PCID only when necessary.  [Vitaly]
>    - Selectively collects reviews (skipped a few due to changes). [Vitaly]
>    - Explicitly invalidate hv_tlb_eptp instead of leaving it valid when
>      the mismatch tracker "knows" it's invalid. [Vitaly]
>    - Change the last patch to use "hv_root_ept" instead of "hv_tlb_pgd"
>      to better reflect what is actually being tracked.
> 
> v2: Rewrite everything.
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
>   arch/x86/kvm/mmu.h              |   2 +-
>   arch/x86/kvm/svm/svm.c          |   4 +-
>   arch/x86/kvm/vmx/vmx.c          | 134 ++++++++++++++++++--------------
>   arch/x86/kvm/vmx/vmx.h          |  19 ++---
>   5 files changed, 87 insertions(+), 76 deletions(-)
> 

Queued, thanks.

Paolo

