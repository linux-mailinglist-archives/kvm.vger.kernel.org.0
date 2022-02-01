Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BB44A5DA6
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 14:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiBANsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 08:48:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238862AbiBANsB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 08:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643723281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvjdmFpP+aywoc255+AEdYPS7LfT6vlQYF3LS6kxF8U=;
        b=dxupm4QpOdmI3LgVzGjYHXOfzLkwgO7bntUsR/h+laFGj6iAx4p/M7pc1BIdV08Uechhpk
        Rwu6lTplku3LmTP440vScbiEDc0MufDnPBcV7z0z5gR8lqTzye1PY4pVxSiTswgSWJHcl6
        areCW9ljAoHkRuKmLIoHomAj2SU/J1U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-H3klWfZoMSG1NN0RCq9Kkg-1; Tue, 01 Feb 2022 08:47:59 -0500
X-MC-Unique: H3klWfZoMSG1NN0RCq9Kkg-1
Received: by mail-ed1-f72.google.com with SMTP id l16-20020aa7c3d0000000b004070ea10e7fso8649878edr.3
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 05:47:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jvjdmFpP+aywoc255+AEdYPS7LfT6vlQYF3LS6kxF8U=;
        b=mtCRIjj2kEATduYWmKd622cXIEMm421o1wffqYoHosu/RAySPmAx4xDfcJxfMt4Yi9
         nikHrgHNMq0O8XnSfj79e1B+DpegkVjqJBvRKgg7gelVijjq4RWTl/7k0RvWld+Qx/5U
         0EBb92R8q6Zul+TvE46fpp/YhRAEbGIjExfiyOjOi/t/3PTg2Hb3k1FwENms6mgyEtX2
         Lh81XjMZAC7n3yqfQE4j5/8OfzOELTcikJjLik3ztVjlYFwCmGJgbvD+7ZtzJbziDL8r
         jaR+RA1ShhOHn/V+wwL4uDhbSQay8xPZ01mcnFOdq1k28m4yc1TCTCM0aEVar+i9xiyu
         dxlA==
X-Gm-Message-State: AOAM530iy0o/YNtixfX7DbArd0TyNm/vLBQJeHIsoTF0SMxI9dDHv5rJ
        giq84XapHtlMzd87OwkqKc+JByCgUnjl4SOtUIp5vu+ZUjakURaqQL6CfKgBqaTsx3P9a43uBpL
        qi3IXJlboPxG6
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr24890197edd.203.1643723278785;
        Tue, 01 Feb 2022 05:47:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxrAn6f7jQ1xsfRbMafBTd7spTEbJU55+LKoGfzGdlknXLbTTVI9SS+8IKsUIyGryLogcl9+w==
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr24890170edd.203.1643723278466;
        Tue, 01 Feb 2022 05:47:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z6sm14841091ejd.35.2022.02.01.05.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 05:47:57 -0800 (PST)
Message-ID: <e509c138-941e-fa9c-d832-e447ce62a4b2@redhat.com>
Date:   Tue, 1 Feb 2022 14:47:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 0/8] KVM: x86: Hyper-V hypercall fix and cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>
References: <20211207220926.718794-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211207220926.718794-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 23:09, Sean Christopherson wrote:
> Fix a bug where KVM incorrectly skips an "all_cpus" IPI request, and misc
> cleanups and enhancements for KVM handling of Hyper-V hypercalls.
> 
> Based on kvm/queue, commit 1cf84614b04a ("KVM: x86: Exit to ...").
> 
> v3:
>    - Collect reviews. [Vitaly]
>    - Add BUILD_BUG_ON() to protect KVM_HV_MAX_SPARSE_VCPU_SET_BITS. [Vitaly]
>    - Fix misc typos. [Vitaly]
>    - Opportunistically rename "cnt" to "rep_cnt" in tracepoint. [Vitaly]
>    - Drop var_cnt checks for debug hypercalls due to lack of documentation
>      as to their expected behavior. [Vitaly]
>    - Tweak the changelog regarding the TLFS spec issue to reference the
>      bug filed by Vitaly.
> 
> v2: https://lore.kernel.org/all/20211030000800.3065132-1-seanjc@google.com/
> 
> Sean Christopherson (8):
>    KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI
>      req
>    KVM: x86: Get the number of Hyper-V sparse banks from the VARHEAD
>      field
>    KVM: x86: Refactor kvm_hv_flush_tlb() to reduce indentation
>    KVM: x86: Add a helper to get the sparse VP_SET for IPIs and TLB
>      flushes
>    KVM: x86: Don't bother reading sparse banks that end up being ignored
>    KVM: x86: Shove vp_bitmap handling down into sparse_set_to_vcpu_mask()
>    KVM: x86: Reject fixeds-size Hyper-V hypercalls with non-zero
>      "var_cnt"
>    KVM: x86: Add checks for reserved-to-zero Hyper-V hypercall fields
> 
>   arch/x86/kvm/hyperv.c             | 175 ++++++++++++++++++------------
>   arch/x86/kvm/trace.h              |  14 ++-
>   include/asm-generic/hyperv-tlfs.h |   7 ++
>   3 files changed, 123 insertions(+), 73 deletions(-)
> 

Queued 2-8, thanks.

Paolo

