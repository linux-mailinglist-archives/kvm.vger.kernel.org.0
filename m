Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D65417097
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 13:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245143AbhIXLHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 07:07:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244510AbhIXLHY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 07:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632481551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NGzlAoX2GPM/b4VJue8hqV3G1uTjkUj5MmWqkb9W5Ic=;
        b=BVh5ix2TfUtvtBkPZ0YyjOGqLxqwSe0V34bBBZCyLmd28jrROiBtm+xXmAd/rnSC28G2rt
        H1qczq41nvGkU+jWEsLO8ejDvmXyG4QoYYFF1W00hbZUp4hmzbsBmvHBN1erTp2QOCDBuH
        HG8ZKq3MvX1vdo+rwKeMD1NG5Lxb1NA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-i2NTXVsfPm2RxoE2WjQ6zw-1; Fri, 24 Sep 2021 07:05:49 -0400
X-MC-Unique: i2NTXVsfPm2RxoE2WjQ6zw-1
Received: by mail-ed1-f69.google.com with SMTP id h6-20020a50c386000000b003da01adc065so9855009edf.7
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 04:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NGzlAoX2GPM/b4VJue8hqV3G1uTjkUj5MmWqkb9W5Ic=;
        b=vfHJTx6+3cVi0my1Od96hXjFClZIDY1zcyHOHPec82BG9m+BMJlJH2UTj/Z0IYBEvj
         z7cOJkv29UFJxP62YjU14rWWf8YKD7meYJPmW67POxTJmSE5M37FfTm2cmd2hMh/Lx6Z
         SAhVBWu9JSQQ16daDibOkxXa9YLBokWskB5lxNhcZmRvxsL108LUbnxGb0DyNks7KQIL
         Lf6ednWYZIqXQmxuGpbTteYEBdvb4bATzthwnmW3LBz+RdzQJn8A6eC8EXnoS7wjU8s0
         sdZXc3suOFu6fbSYQ4bu9zQ/sPvFuEASzkTg2gnaMIjo8qWkcn5CVv0t5nEC+dUq7vOD
         G3iA==
X-Gm-Message-State: AOAM531qVUbzDxO/kFMj0PBCqvM6gxBIP2GHJTRsM3Lmqp1GCUAGdBVY
        q9DnaMqLC/fSCOK31l+b1xnVrM1Ijqwf3Xj9bSR0pvvZwlvosjy4nU7XNNzUEVRdnSHjXudNdKa
        UqCPbdEiERkBp
X-Received: by 2002:aa7:d8c5:: with SMTP id k5mr4242800eds.194.1632481548574;
        Fri, 24 Sep 2021 04:05:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfzp2K4L1iOF8N6KcKFVW1RH7jZxkebv9jD6peAPK9Blum6gNeKJwgyNGV1gmUAiGt50UZnw==
X-Received: by 2002:aa7:d8c5:: with SMTP id k5mr4242776eds.194.1632481548340;
        Fri, 24 Sep 2021 04:05:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d11sm4905318ejo.35.2021.09.24.04.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 04:05:47 -0700 (PDT)
Message-ID: <a7e0bd04-bce9-9acb-1bb4-731d69181536@redhat.com>
Date:   Fri, 24 Sep 2021 13:05:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 0/8] KVM: Various fixes and improvements around kicking
 vCPUs
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210903075141.403071-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210903075141.403071-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/21 09:51, Vitaly Kuznetsov wrote:
> Changes since v4 (Sean):
> - Add Reviewed-by: tag to PATCHes 3 and 5.
> - Drop unneeded 'vcpu' initialization from PATCH4.
> - Return -ENOMEM from kvm_init() when cpumask allocation fails and drop
>   unnecessary braces (PATCH 7).
> - Drop cpumask_available() check from kvm_kick_many_cpus() and convert
>   kvm_make_vcpu_request()'s parameter from 'cpumask_var_t' to
>   'struct cpumask *' (PATCH 8)
> 
> This series is a continuation to Sean's "[PATCH 0/2] VM: Fix a benign race
> in kicking vCPUs" work and v2 for my "KVM: Optimize
> kvm_make_vcpus_request_mask() a bit"/"KVM: x86: Fix stack-out-of-bounds
> memory access from ioapic_write_indirect()" patchset.

Now queued 3-4-5-7-8 as well, thanks.

Paolo

>  From Sean:
> 
> "Fix benign races when kicking vCPUs where the task doing the kicking can
> consume a stale vcpu->cpu.  The races are benign because of the
> impliciations of task migration with respect to interrupts and being in
> guest mode, but IMO they're worth fixing if only as an excuse to
> document the flows.
> 
> Patch 2 is a tangentially related cleanup to prevent future me from
> trying to get rid of the NULL check on the cpumask parameters, which
> _looks_ like it can't ever be NULL, but has a subtle edge case due to the
> way CONFIG_CPUMASK_OFFSTACK=y handles cpumasks."
> 
> Patch3 is a preparation to untangling kvm_make_all_cpus_request_except()
> and kvm_make_vcpus_request_mask().
> 
> Patch4 is a minor optimization for kvm_make_vcpus_request_mask() for big
> guests.
> 
> Patch5 is a minor cleanup.
> 
> Patch6 fixes a real problem with ioapic_write_indirect() KVM does
> out-of-bounds access to stack memory.
> 
> Patches7 and 8 get rid of dynamic cpumask allocation for kicking vCPUs.
> 
> Sean Christopherson (2):
>    KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
>    KVM: KVM: Use cpumask_available() to check for NULL cpumask when
>      kicking vCPUs
> 
> Vitaly Kuznetsov (6):
>    KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with
>      vcpu_mask==NULL
>    KVM: Optimize kvm_make_vcpus_request_mask() a bit
>    KVM: Drop 'except' parameter from kvm_make_vcpus_request_mask()
>    KVM: x86: Fix stack-out-of-bounds memory access from
>      ioapic_write_indirect()
>    KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
>    KVM: Make kvm_make_vcpus_request_mask() use pre-allocated
>      cpu_kick_mask
> 
>   arch/x86/include/asm/kvm_host.h |   1 -
>   arch/x86/kvm/hyperv.c           |  18 ++---
>   arch/x86/kvm/ioapic.c           |  10 +--
>   arch/x86/kvm/x86.c              |   8 +--
>   include/linux/kvm_host.h        |   3 +-
>   virt/kvm/kvm_main.c             | 115 +++++++++++++++++++++++---------
>   6 files changed, 101 insertions(+), 54 deletions(-)
> 

