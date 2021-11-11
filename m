Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47BD44D7CD
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 15:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhKKOJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:09:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhKKOJH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 09:09:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636639577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mz051CqN1il+dA+L7pOpHy4Rh5epXYb1k7VG3Plo7Yk=;
        b=BqlK+2ysHJrwUxzdrqkV/NseB4mbuax7LgGuBUaczS9OKfvGjLW1p3R5oohGfLSYgVPWrT
        akhz8dIWtLIxP+DoZKFpPgR/m38dU7deI27CMB4DRPvQRGJ+NFz+YEuSsWs6ARbHK744/j
        5J2bSGRlVhfni07oRewwx9b+hvCxBHQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-f7BwpHOXPTG9l8k492Rnyw-1; Thu, 11 Nov 2021 09:06:16 -0500
X-MC-Unique: f7BwpHOXPTG9l8k492Rnyw-1
Received: by mail-wm1-f71.google.com with SMTP id 67-20020a1c0046000000b0032cd88916e5so2772005wma.6
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 06:06:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mz051CqN1il+dA+L7pOpHy4Rh5epXYb1k7VG3Plo7Yk=;
        b=2gXQMtE395WKtyhBy4GYFrqgDfGy0cqZIBwQFCbOECWWN18Z9GyvzJQg+VQkUtvL52
         KsGck7DCpuKxrg6/E0jWyVv9oAniltxksJ5oq6SXO7AMVUSY9LT1ncFaBTD0g+oGnohS
         vzP7ESZsnYXMVkugEr089uvDQFa+dtNzWRvnKchqCgepRWdw2HiZcy8O5/yuc4/GEyWs
         EzRjgko7gplu5WQgQu1Sb4n23JQLV4ofN9/LkDw2a5cAStIujKRubaNFw6MiarwB0FCL
         XWkgAdMi/on6qB9Kln9IEhh3c/Iy95g3ZDDzaJSJAJj7F0KAaxaRN/QNaFJL3317sbqc
         /0Zw==
X-Gm-Message-State: AOAM5323fR5mlihAwCX1cl3To564nU7NVGMJ9nTj9DbTEJvr9j2eFvU/
        blUag/cEpiFt/VJnCTXo+d4P5L3v+/xCQjUBzWpolvX4MCu1P8BpwU2D+EPG1ENunqZWL0ms04l
        ckcu8zVmPa48Q
X-Received: by 2002:a1c:4686:: with SMTP id t128mr8412187wma.194.1636639575404;
        Thu, 11 Nov 2021 06:06:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnmeV/GdfwYMLdDvm0j8NSwj/h0xEUckijmROHxrHDUhEC4Xmn+LcBSDQ6FmrRmXjqroy88Q==
X-Received: by 2002:a1c:4686:: with SMTP id t128mr8412162wma.194.1636639575187;
        Thu, 11 Nov 2021 06:06:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id t9sm3273302wrx.72.2021.11.11.06.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 06:06:14 -0800 (PST)
Message-ID: <15d22245-16be-9665-4d3d-91b643ff044d@redhat.com>
Date:   Thu, 11 Nov 2021 15:06:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v4 0/4] KVM: x86: MSR filtering and related fixes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>
References: <20211109013047.2041518-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211109013047.2041518-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/21 02:30, Sean Christopherson wrote:
> Fix a nVMX MSR interception check bug, fix two intertwined nVMX bugs bugs
> related to MSR filtering (one directly, one indirectly), and additional
> cleanup on top.  The main SRCU fix from the original series was merged,
> but these got left behind (luckily, becaues the main fix was buggy).
> 
> Side topic, getting a VM to actually barf on RDMSR(SPEC_CTRL) is comically
> difficult: -spec-ctrl,-stibp,-ssbd,-ibrs-all,-ibpb,-amd-stibp,-amd-ssbd.
> QEMU and KVM really, really want to expose SPEC_CTRL to the guest :-)
> 
> v4:
>    - Rebase to 0d7d84498fb4 ("KVM: x86: SGX must obey the ... protocol")
>    - Fix inverted passthrough check for SPEC_CTRL. [Vitaly]
>    - Add patch to fix MSR bitmap enabling check in helper.
> 
> v3:
>    - Rebase to 9f6090b09d66 ("KVM: MMU: make spte .... in make_spte")
> 
> v2:
>    - https://lkml.kernel.org/r/20210318224310.3274160-1-seanjc@google.com
>    - Make the macro insanity slightly less insane. [Paolo]
> 
> v1: https://lkml.kernel.org/r/20210316184436.2544875-1-seanjc@google.com
> 
> Sean Christopherson (4):
>    KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in
>      use
>    KVM: nVMX: Handle dynamic MSR intercept toggling
>    KVM: VMX: Macrofy the MSR bitmap getters and setters
>    KVM: nVMX: Clean up x2APIC MSR handling for L2
> 
>   arch/x86/kvm/vmx/nested.c | 164 +++++++++++++++-----------------------
>   arch/x86/kvm/vmx/vmx.c    |  61 ++------------
>   arch/x86/kvm/vmx/vmx.h    |  28 +++++++
>   3 files changed, 97 insertions(+), 156 deletions(-)
> 

Queued, thanks.

Paolo

