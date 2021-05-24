Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6D438EDBB
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 17:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhEXPlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 11:41:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234152AbhEXPjB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 11:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621870650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwoIxOxl2r2xIjwfirZmXNL1cV9XOqsSrH6Pev8GZW8=;
        b=C6IB79VFoHoSkomIcpikbDYAKzZML5yUnxNMgZzO6h6rQRBoAk3giuMc+VrvUawvsGGdBU
        Ad3RrUgFRzQJzAbFCK++5bfVmVJoeZi11YQmMPTLvXThX8mcO/BFPJCmTVX7O9azq8wOi5
        UcMstYW1/hb9QUe1tdSDZZV/BVayZFg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-dP37vE1zMouJH_JYv4s5eA-1; Mon, 24 May 2021 11:37:28 -0400
X-MC-Unique: dP37vE1zMouJH_JYv4s5eA-1
Received: by mail-ej1-f70.google.com with SMTP id mp38-20020a1709071b26b02903df8ccd76fbso931136ejc.23
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 08:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uwoIxOxl2r2xIjwfirZmXNL1cV9XOqsSrH6Pev8GZW8=;
        b=tuoihT5WH5L79y10zfw4QJ0x0k9f2hT3mLyq3XWcOaPoxs+/frpLMpBygA5/KDknTH
         y7yx7Q8VFnx2K7oCj+PJRMwAtukEgbow/XR/5M0ygdDJi5yLklQCf1PlwWbFVsiSkqv0
         wwcfU4PAQgT0BNSIIp68WKCcjyJ28cBIJlb/d7IAlNBXFvcaBSvU+sZskXxw+xrlZMX9
         Tvez+Z0IPFoYJs8yunFBd8nRS5a/Y0EuUOfE09BsQnXz78UDdWcn680Z1n34gYV9tlak
         hp3GxyziGUNBDVxP8mnPuxk5INnMdVATBzI4D9x7wgRr2k+gNZJaouVKinDvqW0Gu/gw
         grIA==
X-Gm-Message-State: AOAM530gPyJC1EWzWjPYNXHT4CUEuP3PJ1LnOzlKZ400FUKKMrN8mUPg
        rbkoLZCOrpzWEJwQXc2M4lutJcGGAvrhYM4usopVlLqmKas0TXeEOiHmUkjmPLnvCAGqxdIQ9xc
        2SGMhGe0Oz17U
X-Received: by 2002:a17:906:5608:: with SMTP id f8mr23894090ejq.390.1621870647587;
        Mon, 24 May 2021 08:37:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV4HYWCQYEhf+JFOjvNGGj/EBWUVsvsXzhiz2dQtb0oV8ZsNF79LkF8LDkAH//6I7bKCQfAw==
X-Received: by 2002:a17:906:5608:: with SMTP id f8mr23894062ejq.390.1621870647347;
        Mon, 24 May 2021 08:37:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b25sm9658855edv.9.2021.05.24.08.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 08:37:26 -0700 (PDT)
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
References: <20210521102449.21505-1-ilstam@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 00/12] KVM: Implement nested TSC scaling
Message-ID: <92071380-a81f-7db2-6954-6abd4e390905@redhat.com>
Date:   Mon, 24 May 2021 17:37:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521102449.21505-1-ilstam@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 12:24, Ilias Stamatis wrote:
> KVM currently supports hardware-assisted TSC scaling but only for L1;
> the feature is not exposed to nested guests. This patch series adds
> support for nested TSC scaling and allows both L1 and L2 to be scaled
> with different scaling factors. That is achieved by "merging" the 01 and
> 02 values together.
> 
> Most of the logic in this series is implemented in common code (by doing
> the necessary restructurings), however the patches add support for VMX
> only. Adding support for SVM should be easy at this point and Maxim
> Levitsky has volunteered to do this (thanks!).
> 
> Changelog:
> v3:
>    - Applied Sean's feedback
>    - Refactored patches 7 to 10
> 
> v2:
>    - Applied all of Maxim's feedback
>    - Added a mul_s64_u64_shr function in math64.h
>    - Added a separate kvm_scale_tsc_l1 function instead of passing an
>      argument to kvm_scale_tsc
>    - Implemented the 02 fields calculations in common code
>    - Moved all of write_l1_tsc_offset's logic to common code
>    - Added a check for whether the TSC is stable in patch 10
>    - Used a random L1 factor and a negative offset in patch 10
> 
> Ilias Stamatis (12):
>    math64.h: Add mul_s64_u64_shr()
>    KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
>    KVM: X86: Rename kvm_compute_tsc_offset() to
>      kvm_compute_tsc_offset_l1()
>    KVM: X86: Add a ratio parameter to kvm_scale_tsc()
>    KVM: VMX: Add a TSC multiplier field in VMCS12
>    KVM: X86: Add functions for retrieving L2 TSC fields from common code
>    KVM: X86: Add functions that calculate L2's TSC offset and multiplier
>    KVM: X86: Move write_l1_tsc_offset() logic to common code and rename
>      it
>    KVM: VMX: Remove vmx->current_tsc_ratio and decache_tsc_multiplier()
>    KVM: VMX: Set the TSC offset and multiplier on nested entry and exit
>    KVM: VMX: Expose TSC scaling to L2
>    KVM: selftests: x86: Add vmx_nested_tsc_scaling_test
> 
>   arch/x86/include/asm/kvm-x86-ops.h            |   4 +-
>   arch/x86/include/asm/kvm_host.h               |  14 +-
>   arch/x86/kvm/svm/svm.c                        |  29 ++-
>   arch/x86/kvm/vmx/nested.c                     |  33 ++-
>   arch/x86/kvm/vmx/vmcs12.c                     |   1 +
>   arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
>   arch/x86/kvm/vmx/vmx.c                        |  49 ++--
>   arch/x86/kvm/vmx/vmx.h                        |  11 +-
>   arch/x86/kvm/x86.c                            |  91 +++++--
>   include/linux/math64.h                        |  19 ++
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 242 ++++++++++++++++++
>   13 files changed, 417 insertions(+), 82 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
> 
> --
> 2.17.1
> 

Queued, thanks.

The new kvm_x86_ops should go in kvm_x86_ops.nested, but those are not 
yet static_calls so we can leave that for later.

Paolo

