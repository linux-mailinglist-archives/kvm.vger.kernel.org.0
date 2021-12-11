Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A6B470FC2
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 02:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345539AbhLKBMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 20:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345535AbhLKBMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 20:12:43 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9DDC061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:09:08 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r25so34556530edq.7
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cN4yXFTqfgVJa1oaEGfeLCdiiw2LUDhIEs3ya5VXxmM=;
        b=KAtvdKlzZXkvszza1LnK0cIOUbHAEVdmS0zRjRNODJyFuKJp4SJ6iE2SGt/6N6RMNo
         z8N3fj4iX1W7rupM4FL966cNIoo5kpPTZ7I5qgkIp9aP5BuxyC9wCzUZdRhc+dEzT+qf
         d8Jr4s1Z0+MfhAbf1qyjj6c99sz92tyDFFR0j86B5oYzQ/S4jLVUYj8MYHsjM/IcYVAP
         Ie5n6/Tue2SZqLBHtn7AUxnfqr1d+/Pst5txcPiBYDrJbb+Qr+CtNMkFSHi6Dc3TDdFe
         oZdID4+PydnmYHFfCGUdotSBGjRa1DNNQcdcZM4pHZrJtmfidw+xUuOTWGfzqNangg1F
         O8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cN4yXFTqfgVJa1oaEGfeLCdiiw2LUDhIEs3ya5VXxmM=;
        b=oKeky4j5DDbxlBC2EfptF4XjFlxdwG4CehV4JqBCPcpg7nrZUiHWWxpvPqVtAXewvk
         zuVvHM5UgQ2Wf1bfsgDbZ1533Hb8cdc8PC2OJE9Qg+adlg3rOdFSsbo3GeX6ak1wKITh
         8OjsWjGYGqteIIQ04nay57SoX9agIR4dE6Y9X0dQcUX3pJwOV86dqWEn2NFjmliRINH+
         9ikTXWHCkCnQaOP0ULZdwk7DN17WYQjWn2472uBE+P2kD9wR+tbYKugQzK44rUzLpK5M
         ne+H3oeCqaA3AMWOXIhTnifhGfmFy6qw+koL8eZ85Dtqu1Rlpf4TmdwlxLlnk40KlRC6
         0cvg==
X-Gm-Message-State: AOAM5319UFDf92/bYoNUjj0nXlkfO50KBE0iUJ3C4pM88gGXU94XQLzi
        wDvYX4U3n3uuRPZXwr7BvZI=
X-Google-Smtp-Source: ABdhPJyyWfeN5SqSikQu7NBJ2nqR419EkfWD1TQBYoVRgkWVY34FamLZdv0zmlFim0V6HWpORg219A==
X-Received: by 2002:a05:6402:3481:: with SMTP id v1mr44650402edc.337.1639184946580;
        Fri, 10 Dec 2021 17:09:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id hg19sm2185144ejc.1.2021.12.10.17.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 17:09:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
Date:   Sat, 11 Dec 2021 02:09:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211210163625.2886-1-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211210163625.2886-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 17:36, David Woodhouse wrote:
> Introduce the basic concept of 2 level event channels for kernel delivery,
> which is just a simple matter of a few test_and_set_bit calls on a mapped
> shared info page.
> 
> This can be used for routing MSI of passthrough devices to PIRQ event
> channels in a Xen guest, and we can build on it for delivering IPIs and
> timers directly from the kernel too.

Queued patches 1-5, thanks.

Paolo

> v1: Use kvm_map_gfn() although I didn't quite see how it works.
> 
> v2: Avoid kvm_map_gfn() and implement a safe mapping with invalidation
>      support for myself.
> 
> v3: Reinvent gfn_to_pfn_cache with sane invalidation semantics, for my
>      use case as well as nesting.
> 
> v4: Rework dirty handling, as it became apparently that we need an active
>      vCPU context to mark pages dirty so it can't be done from the MMU
>      notifier duing the invalidation; it has to happen on unmap.
> 
> v5: Fix sparse warnings reported by kernel test robot <lkp@intel.com>.
> 
>      Fix revalidation when memslots change but the resulting HVA stays
>      the same. We can use the same kernel mapping in that case, if the
>      HVA → PFN translation was valid before. So that probably means we
>      shouldn't unmap the "old_hva". Augment the test case to exercise
>      that one too.
> 
>      Include the fix for the dirty ring vs. Xen shinfo oops reported
>      by butt3rflyh4ck <butterflyhuangxx@gmail.com>.
> 
> v6: Paolo's review feedback, rebase onto kvm/next dropping the patches
>      which are already merged.
> 
> Again, the *last* patch in the series (this time #6) is for illustration
> and is not intended to be merged as-is.
> 
> David Woodhouse (6):
>        KVM: Warn if mark_page_dirty() is called without an active vCPU
>        KVM: Reinstate gfn_to_pfn_cache with invalidation support
>        KVM: x86/xen: Maintain valid mapping of Xen shared_info page
>        KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery
>        KVM: x86: Fix wall clock writes in Xen shared_info not to mark page dirty
>        KVM: x86: First attempt at converting nested virtual APIC page to gpc
> 
>   Documentation/virt/kvm/api.rst                     |  33 ++
>   arch/x86/include/asm/kvm_host.h                    |   4 +-
>   arch/x86/kvm/Kconfig                               |   1 +
>   arch/x86/kvm/irq_comm.c                            |  12 +
>   arch/x86/kvm/vmx/nested.c                          |  50 ++-
>   arch/x86/kvm/vmx/vmx.c                             |  12 +-
>   arch/x86/kvm/vmx/vmx.h                             |   2 +-
>   arch/x86/kvm/x86.c                                 |  15 +-
>   arch/x86/kvm/x86.h                                 |   1 -
>   arch/x86/kvm/xen.c                                 | 341 +++++++++++++++++++--
>   arch/x86/kvm/xen.h                                 |   9 +
>   include/linux/kvm_dirty_ring.h                     |   6 -
>   include/linux/kvm_host.h                           | 110 +++++++
>   include/linux/kvm_types.h                          |  18 ++
>   include/uapi/linux/kvm.h                           |  11 +
>   .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 184 ++++++++++-
>   virt/kvm/Kconfig                                   |   3 +
>   virt/kvm/Makefile.kvm                              |   1 +
>   virt/kvm/dirty_ring.c                              |  11 +-
>   virt/kvm/kvm_main.c                                |  19 +-
>   virt/kvm/kvm_mm.h                                  |  44 +++
>   virt/kvm/mmu_lock.h                                |  23 --
>   virt/kvm/pfncache.c                                | 337 ++++++++++++++++++++
>   23 files changed, 1161 insertions(+), 86 deletions(-)
> 
> 
> 

