Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2688219ED7
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 13:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgGILIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 07:08:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726965AbgGILIm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 07:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594292920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/VQ/bbKphw/VMeQL/b68UkYDq7JQp1wzTsPmr8cUuhg=;
        b=Tb7S7YvMyKbMQefnOWgVFfTA7XlyXLqLbmGSh4G35nLMCvJISFMaGpVcTj54Z5dypBqJgw
        /ZM24EGWN8pDj+t5wBiM6vsCWztREI75X/I7UQ5KrrJi06OS0+sAvzqu0hoAzZUqihSFBa
        NI4aFoIWpUg7MauduOMQ+OwF5f9jxZE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-9l6Fs8IHMXar2qpnRqRfaw-1; Thu, 09 Jul 2020 07:08:37 -0400
X-MC-Unique: 9l6Fs8IHMXar2qpnRqRfaw-1
Received: by mail-wr1-f72.google.com with SMTP id w4so1649691wrm.5
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 04:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/VQ/bbKphw/VMeQL/b68UkYDq7JQp1wzTsPmr8cUuhg=;
        b=d4OZvxEKYa+lqVtXArsfX97PXO+IUO1ZpuZsr4kI137PiTK2MylEHLDk6MvZw10VJy
         rjuBCfWnWy1ufETplQ8TOuodOD0XSZ30a3aQMGbVvdZKrdHIxsD+SkPBprxxA8P6X4BV
         g2lFg5K0lg2EnwcaOvTlNLEeonX1mq23M++SvM/rNJTtrjiHvTV0jIvX4WH1InaZHS5v
         s1AEI2E80E2HOus2k/Wf2RV7xpYhtCdXml4oaYt6rJSfFuJN8PJeBjuxp2sccRbV7KWJ
         mJoGl2K3RvS2nfJe31lQvvjcGJvcnaHE8t9HhMJY1/o84RzLhPysAYt0TBSGoc0gx+Bm
         A1PA==
X-Gm-Message-State: AOAM532YY59k1MPDfpIyYi8cRW01Hon/9dLb6n34KUdbOzRcHpLJGRCY
        d+fHPKdSxh8qsbo7scE8u+aUmJ10/LeJYSnT92s1a7E9Cs4TWNbpWnNfcu3A+cUQb1vuWD3k1Jx
        61WXreZnOHpDb
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr12896156wmh.108.1594292915872;
        Thu, 09 Jul 2020 04:08:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5KP0WqaysJjvrDs462rnOxXBxhY7HW8t+OBDNH5uf4ec8HztZjYBRTlo2jYdog4oXLc4CRQ==
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr12896128wmh.108.1594292915485;
        Thu, 09 Jul 2020 04:08:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id w14sm5051815wrt.55.2020.07.09.04.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 04:08:34 -0700 (PDT)
Subject: Re: [PATCH v4 0/5] Refactor handling flow of KVM_SET_CPUID*
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200709043426.92712-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2814b87-5b15-e165-9042-a650e0acf9e1@redhat.com>
Date:   Thu, 9 Jul 2020 13:08:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709043426.92712-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 06:34, Xiaoyao Li wrote:
> 4 Patches of v3 has been queued into kvm/queue branch. This v4 contains
> the rest to refactor the flow of KVM_SET_CPUID* as:
> 
> 1. cpuid check: check if userspace provides legal CPUID settings;
> 
> 2. cpuid update: Update userspace provided CPUID settings. It currently
>    only contains kvm_update_cpuid_runtime, which updates special CPUID
>    bits based on the vcpu state, e.g., OSXSAVE, OSPKE. In the future, we
>    can re-introduce kvm_update_cpuid() if KVM needs to force on/off some
>    bits.
> 
> 3. update vcpu states: Update vcpu states/settings based on the final updated
>    CPUID settings. 
> 
> v4:
>  - remove 4 queued patches
>  - rebased to kvm/queue: c16ced9cc67a "x86/kvm/vmx: Use native read/write_cr2()"
>  - fix one bug in v3 to call kvfree(cpuid_entries) in kvm_vcpu_ioctl_set_cpuid()
>  - rename "update_vcpu_model" to "vcpu_after_set_cpuid" [Paolo]	
>  - Add a new patch to extrace kvm_update_cpuid_runtime()
> 
> v3:
> https://lkml.kernel.org/r/20200708065054.19713-1-xiaoyao.li@intel.com
>  - Add a note in KVM api doc to state the previous CPUID configuration
>    is not reliable if current KVM_SET_CPUID* fails [Jim]
>  - Adjust Patch 2 to reduce code churn [Sean]
>  - Commit message refine to add more justification [Sean]
>  - Add a new patch 7
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
> Xiaoyao Li (5):
>   KVM: x86: Introduce kvm_check_cpuid()
>   KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()
>   KVM: x86: Rename kvm_update_cpuid() to kvm_vcpu_after_set_cpuid()
>   KVM: x86: Rename cpuid_update() callback to vcpu_after_set_cpuid()
>   KVM: x86: Move kvm_x86_ops.vcpu_after_set_cpuid() into
>     kvm_vcpu_after_set_cpuid()
> 
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/cpuid.c            | 99 +++++++++++++++++++++------------
>  arch/x86/kvm/cpuid.h            |  2 +-
>  arch/x86/kvm/lapic.c            |  2 +-
>  arch/x86/kvm/svm/svm.c          |  4 +-
>  arch/x86/kvm/vmx/nested.c       |  3 +-
>  arch/x86/kvm/vmx/vmx.c          |  4 +-
>  arch/x86/kvm/x86.c              | 10 ++--
>  8 files changed, 76 insertions(+), 50 deletions(-)
> 

Queued, thanks.

Paolo

