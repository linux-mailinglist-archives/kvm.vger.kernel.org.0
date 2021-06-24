Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705F43B2995
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 09:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhFXHp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 03:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231734AbhFXHp0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 03:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624520587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Ee7updzwSXDScwuOwS9Mi80C6tuY/612ATdebIhkns=;
        b=P8KPjFqDEZHlpUNZfk0iuP59/B3gddZ7Xe4Zm9WgUsZ9/6wV37ApwtQSpGZ3le9oISRiwW
        86WCS3TDXYurC36zJB8ArcqFuoyKas+PUzF3GkFpbpxV7Z25z42p78kgzFhHFxLWP0jGWk
        l6RPzli43t5RLJD3zsP99JbHULE9i6Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-yyqLHdeINZOiBnZrglarxQ-1; Thu, 24 Jun 2021 03:43:06 -0400
X-MC-Unique: yyqLHdeINZOiBnZrglarxQ-1
Received: by mail-ed1-f71.google.com with SMTP id p19-20020aa7c4d30000b0290394bdda6d9cso2838422edr.21
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 00:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Ee7updzwSXDScwuOwS9Mi80C6tuY/612ATdebIhkns=;
        b=iU9XnH4ELmBNCVQQxVhRoFzgrMEXxpKlxF5nXxPCRouXxpNGjTSzcG4qTORZuSuqkY
         tds/ppDAS5dA9zRU6BuTKt5Gnr6tLUWRbOgKke7STl0PUlOfqSrUHwVyL8RRfIKIHdR1
         AYGZNJXwL7XK245+piotBlApBNAd8ffpigzqT+Mjm/KN8mzV64kvI4TEOZHUJ8i4e77K
         Rt7IsBDb/DCxRV579xub2tLB4R64tvDCjdLshkErhvIP9845OXCvKDY1BL7atqWI7xwx
         n1Yj6OeFutxofaQaU5VxppM3ZmzNhbnWSoJPhDlA9iFqXYSMaHOidEvCJ0vYLZwZ4k7x
         i6og==
X-Gm-Message-State: AOAM532vcLTmjLT0eYLUGq0hEKIdX1+/k5VbpLvpMzTrmotw5VVy3++H
        eyBQvMiv6FqdOnfpH/Ti10SGI0fAyl3hwdKTViHAayfi1cDLZjoYRVQFyDCLpjcp8IusHz4oxSn
        GfNwuJKQoFVE4
X-Received: by 2002:a17:906:d20b:: with SMTP id w11mr4039384ejz.242.1624520585304;
        Thu, 24 Jun 2021 00:43:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQSSRwPS6ea2idy2dt/9VFPF5iJN22Sg5bUpEw+GW0oYQnd2fQHWwj9sl6kPJ78MXVifTBLg==
X-Received: by 2002:a17:906:d20b:: with SMTP id w11mr4039368ejz.242.1624520585127;
        Thu, 24 Jun 2021 00:43:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dh23sm1357519edb.53.2021.06.24.00.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 00:43:04 -0700 (PDT)
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210623230552.4027702-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66d6d077-9766-1711-d8dc-795bde299b97@redhat.com>
Date:   Thu, 24 Jun 2021 09:43:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 01:05, Sean Christopherson wrote:
> A few fixes centered around enumerating guest MAXPHYADDR and handling the
> C-bit in KVM.
> 
> DISCLAIMER: I have no idea if patch 04, "Truncate reported guest
> MAXPHYADDR to C-bit if SEV is" is architecturally correct.  The APM says
> the following about the C-bit in the context of SEV, but I can't for the
> life of me find anything in the APM that clarifies whether "effectively
> reduced" is supposed to apply to _only_ SEV guests, or any guest on an
> SEV enabled platform.
> 
>    Note that because guest physical addresses are always translated through
>    the nested page tables, the size of the guest physical address space is
>    not impacted by any physical address space reduction indicated in
>    CPUID 8000_001F[EBX]. If the C-bit is a physical address bit however,
>    the guest physical address space is effectively reduced by 1 bit.
> 
> In practice, I have observed that Rome CPUs treat the C-bit as reserved for
> non-SEV guests (another disclaimer on this below).  Long story short, commit
> ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
> exposed the issue by inadvertantly causing selftests to start using GPAs
> with bit 47 set.
> 
> That said, regardless of whether or not the behavior is intended, it needs
> to be addressed by KVM.  I think the only difference is whether this is
> KVM's _only_ behavior, or whether it's gated by an erratum flag.
> 
> The second disclaimer is that I haven't tested with memory encryption
> disabled in hardware.  I wrote the patch assuming/hoping that only CPUs
> that report SEV=1 treat the C-bit as reserved, but I haven't actually
> tested the SEV=0 case on e.g. CPUs with only SME (we might have these
> platforms, but I've no idea how to access/find them), or CPUs with SME/SEV
> disabled in BIOS (again, I've no idea how to do this with our BIOS).

I'm merging patches 1-3 right away, though not sending them to Linus 
(they will be picked up by stable after the 5.14 merge window); for 
patch 4, I'm creating a separate file for the "common" parts of 
paging_tmpl.h, called paging.h.

Paolo

> Sean Christopherson (7):
>    KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is
>      enabled
>    KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR
>    KVM: x86: Truncate reported guest MAXPHYADDR to C-bit if SEV is
>      supported
>    KVM: x86/mmu: Do not apply HPA (memory encryption) mask to GPAs
>    KVM: VMX: Refactor 32-bit PSE PT creation to avoid using MMU macro
>    KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
>    KVM: x86/mmu: Use separate namespaces for guest PTEs and shadow PTEs
> 
>   arch/x86/kvm/cpuid.c            | 38 +++++++++++++++++---
>   arch/x86/kvm/mmu.h              | 11 ++----
>   arch/x86/kvm/mmu/mmu.c          | 63 ++++++++-------------------------
>   arch/x86/kvm/mmu/mmu_audit.c    |  6 ++--
>   arch/x86/kvm/mmu/mmu_internal.h | 14 ++++++++
>   arch/x86/kvm/mmu/paging_tmpl.h  | 52 ++++++++++++++++++++++++++-
>   arch/x86/kvm/mmu/spte.c         |  2 +-
>   arch/x86/kvm/mmu/spte.h         | 34 +++++++-----------
>   arch/x86/kvm/mmu/tdp_iter.c     |  6 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>   arch/x86/kvm/svm/svm.c          | 37 ++++++++++++++-----
>   arch/x86/kvm/vmx/vmx.c          |  2 +-
>   arch/x86/kvm/x86.c              |  3 ++
>   arch/x86/kvm/x86.h              |  1 +
>   14 files changed, 170 insertions(+), 101 deletions(-)
> 

