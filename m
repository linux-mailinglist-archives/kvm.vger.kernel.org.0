Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D8541B54D
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 19:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbhI1RmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 13:42:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242198AbhI1RmQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 13:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632850836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i/mLExJpGEltWuxQX4FZe3M+4GoSDCEzgPhBEr5FMEA=;
        b=eDKUMRN6BkhN+Eve4uu+X6/Wjg2AAbS1BrpkZA2hqlmxdUHBKA09wDjy/TN7CZGQ3lp6bd
        UYhF0b9Rw79j+HKbs7T2Y84l+Q71TY3GB+ekNy9cwvFShgmTWzDUPJY9BuBeJEhdihmpvz
        M+ruup6NTszz9tcw9eU4tAZIyj4jI20=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-xcyWU6tvPLKClPm4n4sLCA-1; Tue, 28 Sep 2021 13:40:34 -0400
X-MC-Unique: xcyWU6tvPLKClPm4n4sLCA-1
Received: by mail-ed1-f72.google.com with SMTP id l29-20020a50d6dd000000b003d80214566cso22587824edj.21
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 10:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i/mLExJpGEltWuxQX4FZe3M+4GoSDCEzgPhBEr5FMEA=;
        b=Vj9+aT1rS+GrdH6tjJYAcP42alNTTldec2Slr8BDgrY9OJXHzSr29HzmZD60BwUuHN
         WULKtlKpT/GmjGFcsaTMH62jWmDM4GqoahlL3tLFiX7RivyjqFFIZBf4PzYU2m1c1WuC
         8m8K//Yee+wf2W6o/DjtzoIfUQwNyqOLWr4NSR2AS+5q6K9NA99KqunDXT70gbVRYJAc
         eG967GKCd6QjjnYsT13j1mq5f0qy25C094bKDk1FceBxp6udr8Kzg5Dutplf56Q2sxR8
         3GvU9hVApsVsqnfgxqA0KxLexENzX2de81DnXwayZzkTxvYUOjX+vht4HE0ZjlfJUbBH
         Soeg==
X-Gm-Message-State: AOAM530b+mAVGWX0HSPJfInGF52jkpB9dKGSia968q5g/wYn4xGdw8t7
        AId80WkfHMOJT6QG0P9QGnpljTRZmtwFyFlLK+YUKHSNJBIWgcCk2lTvkJRp/8TXO8vbS2la/ud
        xXEHMs5qWEzo2
X-Received: by 2002:a05:6402:54d:: with SMTP id i13mr9049822edx.389.1632850833766;
        Tue, 28 Sep 2021 10:40:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1uRsUYkFrmzr9SFSboTh9F3ISbwn7GohEYiy/YAAhZwF2yzR3R6MUzDSzYRWA2nhcLdM6ag==
X-Received: by 2002:a05:6402:54d:: with SMTP id i13mr9049801edx.389.1632850833583;
        Tue, 28 Sep 2021 10:40:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y3sm13952710eda.9.2021.09.28.10.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 10:40:32 -0700 (PDT)
Message-ID: <c3db653e-4ea2-3e99-aed6-c6e8a76e2ece@redhat.com>
Date:   Tue, 28 Sep 2021 19:40:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/4] KVM: allow mapping non-refcounted pages
Content-Language: en-US
To:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210825025009.2081060-1-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210825025009.2081060-1-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/08/21 04:50, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This patch series adds support for mapping non-refcount VM_IO and
> VM_PFNMAP memory into the guest.
> 
> Currently, the gfn_to_pfn functions require being able to pin the target
> pfn, so they will fail if the pfn returned by follow_pte isn't a
> ref-counted page.  However, the KVM secondary MMUs do not require that
> the pfn be pinned, since they are integrated with the mmu notifier API.
> This series adds a new set of gfn_to_pfn_page functions which parallel
> the gfn_to_pfn functions but do not pin the pfn. The new functions
> return the page from gup if it was present, so callers can use it and
> call put_page when done.
> 
> The gfn_to_pfn functions should be depreciated, since as they are unsafe
> due to relying on trying to obtain a struct page from a pfn returned by
> follow_pte. I added new functions instead of simply adding another
> optional parameter to the existing functions to make it easier to track
> down users of the deprecated functions.
> 
> This series updates x86 and arm64 secondary MMUs to the new API.
> 
> v2 -> v3:
>   - rebase on kvm next branch

Hi David,

this needs a rebase.  I have pushed my current queue, but note that 
parts of it are still untested.

A bigger question here is the gfn_to_pfn caches and how to properly 
invalidate them.  However your patch doesn't make things worse (only a 
bit inconsistent because pointing certain MSRs to a VM_PFNMAP|VM_IO page 
can fail).

Paolo

> v1 -> v2:
>   - Introduce new gfn_to_pfn_page functions instead of modifying the
>     behavior of existing gfn_to_pfn functions, to make the change less
>     invasive.
>   - Drop changes to mmu_audit.c
>   - Include Nicholas Piggin's patch to avoid corrupting refcount in the
>     follow_pte case, and use it in depreciated gfn_to_pfn functions.
>   - Rebase on kvm/next
> 
> David Stevens (4):
>    KVM: mmu: introduce new gfn_to_pfn_page functions
>    KVM: x86/mmu: use gfn_to_pfn_page
>    KVM: arm64/mmu: use gfn_to_pfn_page
>    KVM: mmu: remove over-aggressive warnings
> 
>   arch/arm64/kvm/mmu.c            |  26 +++--
>   arch/x86/kvm/mmu/mmu.c          |  50 +++++----
>   arch/x86/kvm/mmu/mmu_internal.h |   3 +-
>   arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
>   arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
>   arch/x86/kvm/x86.c              |   6 +-
>   include/linux/kvm_host.h        |  17 +++
>   virt/kvm/kvm_main.c             | 188 +++++++++++++++++++++++---------
>   9 files changed, 220 insertions(+), 103 deletions(-)
> 

