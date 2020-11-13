Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111BE2B1AA9
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 13:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgKMMEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 07:04:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbgKMLgU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 06:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605267378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KS2gzxwe2L87PtFz5vQ1RhEQgR8wNZBK0sfzPULcu7o=;
        b=Nz2iO3lMeGSwRDlhKPLBQaJf4pWtw1rvV45nbwMT8NTnW/jPDJMutrxP5zLIJsxePgGC/+
        lqEK9YGZkw+lD92QNhg7S4OhJF5qkHvKXXmJTM+rT2+y7pmoPc+rXQXDAnsOvOvWXqOEgI
        RUyjFr/y8b3A486Wzvlvj2/cnKn7XFY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-4xrL7VHnNXaOX_9FlrVtvA-1; Fri, 13 Nov 2020 06:36:17 -0500
X-MC-Unique: 4xrL7VHnNXaOX_9FlrVtvA-1
Received: by mail-wm1-f70.google.com with SMTP id u123so3068115wmu.5
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 03:36:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KS2gzxwe2L87PtFz5vQ1RhEQgR8wNZBK0sfzPULcu7o=;
        b=a6ezleHgidb3lDw6DOO6h8v0aLexJtJtWZcRmbS81YQorLAsPP2pOJkvhL8NVqAluo
         sXtiC5GGvPx3OUovxXDrtPyDA6brtmyKxmus6El0RkzWmPVbz2N0+9zmDJ+q9XCQ0Q7w
         +6s0XEe3TyjDb3hkabOj2yri+5ghXFJTSp7uFuzqkCAH9T8LWgwISJyElJ3CZOBLbmxN
         zUWbn4a6b5i38zSrNmm2zhLmJAVJrksmynQM9sdLiYyRocdo+EcR1FK5titXqE9xSTEf
         geOk5ZVxlDFoYad+rpCLF224gGQ3F70Er7kd4ZNW3Fae++Xi8GN35sdt3CwvgADZya24
         rJmQ==
X-Gm-Message-State: AOAM531LRo9ZcDhvBCYU87ikdixafibHSwx3kBB7jwilEtZjoTOiN0do
        y8i8cQpA8UCXovCZeq2hjzhMeVzznQgSIyBA1zkcntYLOZj8OnpQHLo8gCDkL9z7tVVSW5v0olD
        44W08azk8q2zP
X-Received: by 2002:adf:d188:: with SMTP id v8mr2843716wrc.167.1605267375675;
        Fri, 13 Nov 2020 03:36:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCm0Ta3PICoFUYN57ryHX4hbOc9tjQT5NoiiL6jlhQd5K67/cBAJCbuSadSBT4N599467vIw==
X-Received: by 2002:adf:d188:: with SMTP id v8mr2843695wrc.167.1605267375442;
        Fri, 13 Nov 2020 03:36:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b14sm10981498wrx.35.2020.11.13.03.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 03:36:14 -0800 (PST)
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stas Sergeev <stsp@users.sourceforge.net>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <287166fd-0db1-ace1-3abe-96c5600fd30b@redhat.com>
Date:   Fri, 13 Nov 2020 12:36:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/20 03:44, Sean Christopherson wrote:
> Two bug fixes to handle KVM_SET_SREGS without a preceding KVM_SET_CPUID2.
> 
> The overarching issue is that kvm_x86_ops.set_cr4() can fail, but its
> invocation from __set_sregs(), a.k.a. KVM_SET_SREGS, ignores the result.
> Fix the issue by moving all validity checks out of .set_cr4() in one way
> or another.
> 
> I intentionally omitted a Cc to stable.  The first bug fix in particular
> may break stable trees as it simply removes a check, and I don't know that
> stable trees have the generic CR4 reserved bit check that is needed to
> prevent the guest from setting VMXE when nVMX is not allowed.
> 
> Sean Christopherson (6):
>    KVM: VMX: Drop guest CPUID check for VMXE in vmx_set_cr4()
>    KVM: VMX: Drop explicit 'nested' check from vmx_set_cr4()
>    KVM: SVM: Drop VMXE check from svm_set_cr4()
>    KVM: x86: Move vendor CR4 validity check to dedicated kvm_x86_ops hook
>    KVM: x86: Return bool instead of int for CR4 and SREGS validity checks
>    KVM: selftests: Verify supported CR4 bits can be set before
>      KVM_SET_CPUID2
> 
>   arch/x86/include/asm/kvm_host.h               |  3 +-
>   arch/x86/kvm/svm/nested.c                     |  2 +-
>   arch/x86/kvm/svm/svm.c                        | 12 ++-
>   arch/x86/kvm/svm/svm.h                        |  2 +-
>   arch/x86/kvm/vmx/nested.c                     |  2 +-
>   arch/x86/kvm/vmx/vmx.c                        | 35 +++----
>   arch/x86/kvm/vmx/vmx.h                        |  2 +-
>   arch/x86/kvm/x86.c                            | 28 +++---
>   arch/x86/kvm/x86.h                            |  2 +-
>   .../selftests/kvm/include/x86_64/processor.h  | 17 ++++
>   .../selftests/kvm/include/x86_64/vmx.h        |  4 -
>   .../selftests/kvm/x86_64/set_sregs_test.c     | 92 ++++++++++++++++++-
>   12 files changed, 153 insertions(+), 48 deletions(-)
> 

Queued, thanks.

Paolo

