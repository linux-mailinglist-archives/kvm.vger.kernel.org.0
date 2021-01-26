Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB53304C32
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbhAZWdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:33:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729634AbhAZRDv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 12:03:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611680539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4ZKb8bFlXRVvfL07LOhyv8cAdRu+Z/S+GDSbvfqb1Y=;
        b=Quyr2BbYcbKL2yiRH2J+TQAj7dwQCXprDhtVQ3k1LYcgNweqBohiMbZdmZxIckNtm1cjxB
        yPuryyojPhEx4D3Kg+SQcix7geEHv8dXKioXiV9dK28BqWz5ffs3eZkrGPYuTSGa107Ht5
        ABhQ03+BHZA/PhfKFd8idqfnuBswdtU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-vz9LJ8zWMUGzk8Wbb3Da4Q-1; Tue, 26 Jan 2021 11:47:03 -0500
X-MC-Unique: vz9LJ8zWMUGzk8Wbb3Da4Q-1
Received: by mail-ej1-f72.google.com with SMTP id by20so5164481ejc.1
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 08:47:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I4ZKb8bFlXRVvfL07LOhyv8cAdRu+Z/S+GDSbvfqb1Y=;
        b=mn0WLJqCgBQTp+Sc0v7yh8KGZgzzS4/sqzteb72jS79N3N0IsUyZugKRgj1REk27CZ
         3sYX43T98PTTPJrDixtqh0L5hM7mW0oDzjaxcIhY2tnErmpeSv+JWdz8wzyyLl0TCx0e
         zZpBJBoERYQVoIwVKt+DbXi5w5lX7QshEaqE2z0JGKbyJEbphJhp78ilHXWQQVuVhAD1
         +XkJcF52pKIdlKPmXY2spqarqPDprzSnG06bXFG0jAD6U4/VIAneazTY6Oxa84RWp6I6
         0fCkw8JlHfGx0NLEp/qDZ0HI1PW2Psv/ZmnZB2aQXxH7giCfMJ3Z8zlM/KTncWSz9GZ2
         UiXQ==
X-Gm-Message-State: AOAM530f12F/gGC9ZYIm7PMbBnUICO+PFAa5uYCJPYmvEA1asYFORXUA
        cBmFucEPT31aNw1whPhOIRDLqUHcDCtL6L2mEXD6+RD1QxD4dDLh8BQP8K20Tk/lq3N154qmuFY
        ckNm41VH2mr6K
X-Received: by 2002:a50:ee94:: with SMTP id f20mr5409155edr.222.1611679622183;
        Tue, 26 Jan 2021 08:47:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWAWMTdXHRABB/i4tSZ9e4vzIsNpvFRyrBXtBgagESBXWm++q9yOphXqQ8dkTSGP0xwomHmQ==
X-Received: by 2002:a50:ee94:: with SMTP id f20mr5409148edr.222.1611679622048;
        Tue, 26 Jan 2021 08:47:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dj25sm12571694edb.5.2021.01.26.08.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:47:01 -0800 (PST)
Subject: Re: [PATCH v2 0/3] Use static_call for kvm_x86_ops
To:     Jason Baron <jbaron@akamai.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
References: <cover.1610680941.git.jbaron@akamai.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7efb7e51-611c-e4eb-be32-fefafb664309@redhat.com>
Date:   Tue, 26 Jan 2021 17:47:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <cover.1610680941.git.jbaron@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 04:27, Jason Baron wrote:
> Hi,
> 
> Convert kvm_x86_ops to use static_call. Shows good performance
> gains for cpuid loop micro-benchmark (results in patch 3/3).

Queued, thanks.

Paolo

> Thanks,
> 
> -Jason
> 
> 
> Changes from v1:
> -Introduce kvm-x86-ops header with eye towards using this to define
>   svm_x86_ops and vmx_x86_ops in follow on patches (Paolo, Sean)
> -add new patch (1/3), that adds a vmx/svm prefix to help facilitate
>   svm_x86_ops and vmx_x86_ops future conversions.
> -added amd perf numbres to description of patch 3/3
> 
> Jason Baron (3):
>    KVM: X86: append vmx/svm prefix to additional kvm_x86_ops functions
>    KVM: x86: introduce definitions to support static calls for kvm_x86_ops
>    KVM: x86: use static calls to reduce kvm_x86_ops overhead
> 
>   arch/x86/include/asm/kvm-x86-ops.h | 127 +++++++++++++++
>   arch/x86/include/asm/kvm_host.h    |  21 ++-
>   arch/x86/kvm/cpuid.c               |   2 +-
>   arch/x86/kvm/hyperv.c              |   4 +-
>   arch/x86/kvm/irq.c                 |   3 +-
>   arch/x86/kvm/kvm_cache_regs.h      |  10 +-
>   arch/x86/kvm/lapic.c               |  30 ++--
>   arch/x86/kvm/mmu.h                 |   6 +-
>   arch/x86/kvm/mmu/mmu.c             |  15 +-
>   arch/x86/kvm/mmu/spte.c            |   2 +-
>   arch/x86/kvm/pmu.c                 |   2 +-
>   arch/x86/kvm/svm/svm.c             |  20 +--
>   arch/x86/kvm/trace.h               |   4 +-
>   arch/x86/kvm/vmx/nested.c          |   2 +-
>   arch/x86/kvm/vmx/vmx.c             |  30 ++--
>   arch/x86/kvm/vmx/vmx.h             |   2 +-
>   arch/x86/kvm/x86.c                 | 307 +++++++++++++++++++------------------
>   arch/x86/kvm/x86.h                 |   6 +-
>   18 files changed, 369 insertions(+), 224 deletions(-)
>   create mode 100644 arch/x86/include/asm/kvm-x86-ops.h
> 

