Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDFC2795D3
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 03:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgIZBOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 21:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729685AbgIZBOL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 21:14:11 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601082848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/MfC+wTSjbqTRPcN7Qitt4qsrANTjIPAEkx0OnCxwU=;
        b=UmRqI6bw2yF5fCm/7b2z+70ToBYjnkwT/HkQkR2AZHWxrtTsWz5GDVe+X2U1F2WaAAzDN6
        nP0BIeH2atPMel3v/L1Ao/eDNYSmfHoVb1WkugS/GUa93pV6bF5jdWoNKRPJ4/ZYzPLX0+
        nYyg7g1JIYbhL8epcyFpcyMcBo0blXo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-Ar2eIQgaPxeTpeyhbLATYw-1; Fri, 25 Sep 2020 21:14:04 -0400
X-MC-Unique: Ar2eIQgaPxeTpeyhbLATYw-1
Received: by mail-wr1-f71.google.com with SMTP id a12so1769514wrg.13
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 18:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T/MfC+wTSjbqTRPcN7Qitt4qsrANTjIPAEkx0OnCxwU=;
        b=jhjcnPHGn5CXOBdmDZ/lZ1TEXCXH5Qj2jnCPjmbdTyX1/yYBilvWVGxcEwWqAYACIC
         kfkSNvEK9b3WoNhUe0WEhaIug49MtVJgBKwhGb1XVCPhTWtx0tKTpjAQr5x/7vjK2bu4
         qw4Dk/k32ZaulaW0hqI2z7gzPKwHBtGxuqk3M6qnZqFG44fX0P4nmgUHEVfk6ijDzUBF
         DZiQOYKWqikhd1ui4J17gWWnMi0AXFfH2OfBxtxt5NG4l9sFgFcUfsA6pN7BlJdtlqSy
         CaVNLdogBh3XMQqGhRRQUFaXi9Ng1+wuApMe4361skNfcTb5fFxIi1gc6VfHyvgYRTTo
         hSRA==
X-Gm-Message-State: AOAM532ppIehu/ipySk4E9QHgK+VoM2bZ5Yj80a84kqFBQ+PtoaihTWl
        bRv/luSqW3nN+pINQVmGJ84GhjesWna25FIYxk7b1UMPTJez9iQqOLoUAIVaodVw/3VLNgTWIES
        LS6EN8hYiJPj6
X-Received: by 2002:adf:efc9:: with SMTP id i9mr7380938wrp.187.1601082843253;
        Fri, 25 Sep 2020 18:14:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOQhtTbairjCMi0UAH/ZepweDc9c30EinOjCbyKbkBsucQ0wIQCZO+Q2lO5AO1syUaFBB+Nw==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr7380913wrp.187.1601082842935;
        Fri, 25 Sep 2020 18:14:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id h16sm5117997wre.87.2020.09.25.18.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 18:14:02 -0700 (PDT)
Subject: Re: [PATCH 00/22] Introduce the TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34785fca-4d6d-88d7-f90a-2e17815d02e6@redhat.com>
Date:   Sat, 26 Sep 2020 03:14:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> Over the years, the needs for KVM's x86 MMU have grown from running small
> guests to live migrating multi-terabyte VMs with hundreds of vCPUs. Where
> we previously depended on shadow paging to run all guests, we now have
> two dimensional paging (TDP). This patch set introduces a new
> implementation of much of the KVM MMU, optimized for running guests with
> TDP. We have re-implemented many of the MMU functions to take advantage of
> the relative simplicity of TDP and eliminate the need for an rmap.
> Building on this simplified implementation, a future patch set will change
> the synchronization model for this "TDP MMU" to enable more parallelism
> than the monolithic MMU lock. A TDP MMU is currently in use at Google
> and has given us the performance necessary to live migrate our 416 vCPU,
> 12TiB m2-ultramem-416 VMs.
> 
> This work was motivated by the need to handle page faults in parallel for
> very large VMs. When VMs have hundreds of vCPUs and terabytes of memory,
> KVM's MMU lock suffers extreme contention, resulting in soft-lockups and
> long latency on guest page faults. This contention can be easily seen
> running the KVM selftests demand_paging_test with a couple hundred vCPUs.
> Over a 1 second profile of the demand_paging_test, with 416 vCPUs and 4G
> per vCPU, 98% of the time was spent waiting for the MMU lock. At Google,
> the TDP MMU reduced the test duration by 89% and the execution was
> dominated by get_user_pages and the user fault FD ioctl instead of the
> MMU lock.
> 
> This series is the first of two. In this series we add a basic
> implementation of the TDP MMU. In the next series we will improve the
> performance of the TDP MMU and allow it to execute MMU operations
> in parallel.
> 
> The overall purpose of the KVM MMU is to program paging structures
> (CR3/EPT/NPT) to encode the mapping of guest addresses to host physical
> addresses (HPA), and to provide utilities for other KVM features, for
> example dirty logging. The definition of the L1 guest physical address
> (GPA) to HPA mapping comes in two parts: KVM's memslots map GPA to HVA,
> and the kernel MM/x86 host page tables map HVA -> HPA. Without TDP, the
> MMU must program the x86 page tables to encode the full translation of
> guest virtual addresses (GVA) to HPA. This requires "shadowing" the
> guest's page tables to create a composite x86 paging structure. This
> solution is complicated, requires separate paging structures for each
> guest CR3, and requires emulating guest page table changes. The TDP case
> is much simpler. In this case, KVM lets the guest control CR3 and programs
> the EPT/NPT paging structures with the GPA -> HPA mapping. The guest has
> no way to change this mapping and only one version of the paging structure
> is needed per L1 paging mode. In this case the paging mode is some
> combination of the number of levels in the paging structure, the address
> space (normal execution or system management mode, on x86), and other
> attributes. Most VMs only ever use 1 paging mode and so only ever need one
> TDP structure.
> 
> This series implements a "TDP MMU" through alternative implementations of
> MMU functions for running L1 guests with TDP. The TDP MMU falls back to
> the existing shadow paging implementation when TDP is not available, and
> interoperates with the existing shadow paging implementation for nesting.
> The use of the TDP MMU can be controlled by a module parameter which is
> snapshot on VM creation and follows the life of the VM. This snapshot
> is used in many functions to decide whether or not to use TDP MMU handlers
> for a given operation.
> 
> This series can also be viewed in Gerrit here:
> https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
> (Thanks to Dmitry Vyukov <dvyukov@google.com> for setting up the
> Gerrit instance)
> 
> Ben Gardon (22):
>   kvm: mmu: Separate making SPTEs from set_spte
>   kvm: mmu: Introduce tdp_iter
>   kvm: mmu: Init / Uninit the TDP MMU
>   kvm: mmu: Allocate and free TDP MMU roots
>   kvm: mmu: Add functions to handle changed TDP SPTEs
>   kvm: mmu: Make address space ID a property of memslots
>   kvm: mmu: Support zapping SPTEs in the TDP MMU
>   kvm: mmu: Separate making non-leaf sptes from link_shadow_page
>   kvm: mmu: Remove disallowed_hugepage_adjust shadow_walk_iterator arg
>   kvm: mmu: Add TDP MMU PF handler
>   kvm: mmu: Factor out allocating a new tdp_mmu_page
>   kvm: mmu: Allocate struct kvm_mmu_pages for all pages in TDP MMU
>   kvm: mmu: Support invalidate range MMU notifier for TDP MMU
>   kvm: mmu: Add access tracking for tdp_mmu
>   kvm: mmu: Support changed pte notifier in tdp MMU
>   kvm: mmu: Add dirty logging handler for changed sptes
>   kvm: mmu: Support dirty logging for the TDP MMU
>   kvm: mmu: Support disabling dirty logging for the tdp MMU
>   kvm: mmu: Support write protection for nesting in tdp MMU
>   kvm: mmu: NX largepage recovery for TDP MMU
>   kvm: mmu: Support MMIO in the TDP MMU
>   kvm: mmu: Don't clear write flooding count for direct roots
> 
>  arch/x86/include/asm/kvm_host.h |   17 +
>  arch/x86/kvm/Makefile           |    3 +-
>  arch/x86/kvm/mmu/mmu.c          |  437 ++++++----
>  arch/x86/kvm/mmu/mmu_internal.h |   98 +++
>  arch/x86/kvm/mmu/paging_tmpl.h  |    3 +-
>  arch/x86/kvm/mmu/tdp_iter.c     |  198 +++++
>  arch/x86/kvm/mmu/tdp_iter.h     |   55 ++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 1315 +++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.h      |   52 ++
>  include/linux/kvm_host.h        |    2 +
>  virt/kvm/kvm_main.c             |    7 +-
>  11 files changed, 2022 insertions(+), 165 deletions(-)
>  create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
>  create mode 100644 arch/x86/kvm/mmu/tdp_iter.h
>  create mode 100644 arch/x86/kvm/mmu/tdp_mmu.c
>  create mode 100644 arch/x86/kvm/mmu/tdp_mmu.h
> 

Ok, I've not finished reading the code but I have already an idea of
what it's like.  I really think we should fast track this as the basis
for more 5.11 work.  I'll finish reviewing it and, if you don't mind, I
might make some of the changes myself so I have the occasion to play and
get accustomed to the code; speak up if you disagree with them though!
Another thing I'd like to add is a few tracepoints.

Paolo

