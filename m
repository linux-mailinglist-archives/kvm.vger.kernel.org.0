Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF822186F3
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgGHMKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 08:10:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27612 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728903AbgGHMK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 08:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594210227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gdi2UbJBJuu6JYx/nUObEDZIDgGFSVB4CBfepRfkmlo=;
        b=YvISopvoZzKVxbx/KX26npTeRxbTQwSrH3cGaq7yz0TmzQzWaEckhWVq3PTjelEzZK4Y5K
        In23BUqlTRAkX6nUpxVeki69cvg9G3wwlYJ33LGlI2lIIex3HRFlNWlCfwfNEyIXdHT/32
        KaJs/00DZo/KUBWYQ7St/e/OfXIFNGs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-W89nig75PSKxQ5G2af2szA-1; Wed, 08 Jul 2020 08:10:25 -0400
X-MC-Unique: W89nig75PSKxQ5G2af2szA-1
Received: by mail-wr1-f72.google.com with SMTP id g14so51723700wrp.8
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 05:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gdi2UbJBJuu6JYx/nUObEDZIDgGFSVB4CBfepRfkmlo=;
        b=ICoj4+i88z6NFm02H6tDvQlem5D0ENHj33u8U5i0q9wt5PRWbO0KOtjEj5r3B9uFgi
         sCcSqYaeypDzSGtHT++2viTnFMytK44ppc+QnV1IJEuG+OrRN+3hh8CLbwGYR5cY2Izl
         1L1aqxVaPmwdKZXNg2j9hrOC8iQ6hV106nL+nZl6jZQEK7/0CTXrDsHwvPO5TVVEJTwX
         xzD/dZLLHWeI68kW5ySzVBcGKD8kC7Nv7IlSLLBbnT1AX1tOZKBbAtAfI8KNRP3+StFR
         xz8G3bck2xDWnfUsapuq7/PrnqZnb8ejsQBheoTICa+YuiVpEkbhCaLuL9ONG0ngz3fY
         Q0FQ==
X-Gm-Message-State: AOAM530EYOo3+JqFZPQAhfRAaCvR0jhbEqBdh119ccW3l5cfKLYTM2FT
        6CVRXM2kew2z0/LGeF+gqdtquMCWvBksNDaSijhk2My0rQzn2RFmiuxaZWE6KxVRyoYdtLKNVH/
        3fYXTc8Yjom1h
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr59902306wrt.5.1594210224384;
        Wed, 08 Jul 2020 05:10:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycDGuCTbVScWdZ8BMWhOLTWcYfXhmWtqLlk6irp7YWRr/BpzK+7dnLvhE3faLT0FGeK7f2QQ==
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr59902286wrt.5.1594210224146;
        Wed, 08 Jul 2020 05:10:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id s8sm5290162wru.38.2020.07.08.05.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 05:10:23 -0700 (PDT)
Subject: Re: [PATCH v3 0/8] Refactor handling flow of KVM_SET_CPUID*
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <55ce27bc-7ff7-3552-0e2d-ce69c66fd68e@redhat.com>
Date:   Wed, 8 Jul 2020 14:10:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708065054.19713-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 08:50, Xiaoyao Li wrote:
> This serial is the extended version of
> https://lkml.kernel.org/r/20200528151927.14346-1-xiaoyao.li@intel.com
> 
> First two patches are bug fixing, and the others aim to refactor the flow
> of SET_CPUID* as:
> 
> 1. cpuid check: check if userspace provides legal CPUID settings;
> 
> 2. cpuid update: Update some special CPUID bits based on current vcpu
>                  state, e.g., OSXSAVE, OSPKE, ...
> 
> 3. update vcpu model: Update vcpu model (settings) based on the final CPUID
>                       settings. 
> 
> v3:
>  - Add a note in KVM api doc to state the previous CPUID configuration
>    is not reliable if current KVM_SET_CPUID* fails [Jim]
>  - Adjust Patch 2 to reduce code churn [Sean]
>  - Commit message refine to add more justification [Sean]
>  - Add a new patch (7)
> 
> v2:
> https://lkml.kernel.org/r/20200623115816.24132-1-xiaoyao.li@intel.com
>  - rebase to kvm/queue: a037ff353ba6 ("Merge branch 'kvm-master' into HEAD")
>  - change the name of kvm_update_state_based_on_cpuid() to
>    kvm_update_vcpu_model() [Sean]
>  - Add patch 5 to rename kvm_x86_ops.cpuid_date() to
>    kvm_x86_ops.update_vcpu_model()
> 
> v1:
> https://lkml.kernel.org/r/20200529085545.29242-1-xiaoyao.li@intel.com
> 
> Xiaoyao Li (8):
>   KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID* fails
>   KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
>   KVM: X86: Introduce kvm_check_cpuid()
>   KVM: X86: Split kvm_update_cpuid()
>   KVM: X86: Rename cpuid_update() to update_vcpu_model()
>   KVM: X86: Move kvm_x86_ops.update_vcpu_model() into
>     kvm_update_vcpu_model()
>   KVM: lapic: Use guest_cpuid_has() in kvm_apic_set_version()
>   KVM: X86: Move kvm_apic_set_version() to kvm_update_vcpu_model()
> 
>  Documentation/virt/kvm/api.rst  |   4 ++
>  arch/x86/include/asm/kvm_host.h |   2 +-
>  arch/x86/kvm/cpuid.c            | 107 ++++++++++++++++++++------------
>  arch/x86/kvm/cpuid.h            |   3 +-
>  arch/x86/kvm/lapic.c            |   4 +-
>  arch/x86/kvm/svm/svm.c          |   4 +-
>  arch/x86/kvm/vmx/nested.c       |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |   4 +-
>  arch/x86/kvm/x86.c              |   1 +
>  9 files changed, 81 insertions(+), 50 deletions(-)
> 

Queued patches 1/2/3/7/8, thanks.

Paolo

