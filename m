Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7B3FCD82
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 21:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240094AbhHaTIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 15:08:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235292AbhHaTIK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 15:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630436833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5ykmaiBHLn8tM3nLNz5TAEpWwFHOANe8ir9pHZRCuw=;
        b=WfhVXa4BaDOOgyBtclSpbzUhQpeVqniJBZ0/e0djmvu6Fdq2cmJ5eui5ZxN4ukT+yyxc8o
        q+eswU0bvA4kdXSmrZeZSK7Zp7jEcLmfE/4xobbL2pdoE/L3Snok6jeRJzc9O7ASPyfhJd
        RCsHeZcbJa0a7gg0eGTmJcpydosvK7k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-7afPYDxyOpyptovJfBilTQ-1; Tue, 31 Aug 2021 15:07:11 -0400
X-MC-Unique: 7afPYDxyOpyptovJfBilTQ-1
Received: by mail-wm1-f72.google.com with SMTP id p5-20020a7bcc85000000b002e7563efc4cso82813wma.4
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 12:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L5ykmaiBHLn8tM3nLNz5TAEpWwFHOANe8ir9pHZRCuw=;
        b=fqBsj5j6kIvDkvLTckLoylDnBicZ3cG1q0c8GeY1pRzhC7sdpxL1AxppW7wousXOv9
         aWmPtNUDgCuur/5wEcr8BcOZ/Jmi3FAuAIPnzZCn6XCdjSQpmgIz11Wmwbue/VjhbBBC
         zXG07ubgsJY6HWqNU4et65bCByy5dVnt2MN19NRQ3HsdRV8wbfYW+iML2dyI8MNDbBsj
         lJMqBdEXTG6aBDbASHxq5aia6VTmVI16o6eJfFkaToqyi+XydcEsuVXScPU25hf56UBY
         QdumwThCSCLcimR86LVTIzUfrxR+Et5RkUXliJ/Q9BOav0F3xdfPpsI4dbp/gP6RmjTz
         ZO2A==
X-Gm-Message-State: AOAM532ThYVCtTfhysSa+v1G5ignECgNWnyI+QYaCcAOCN8bejtctBcr
        ce8EFsdFiZStEg3PKgZFarntWNeTCep9f+j6gZVx3r9yDu9L6hcGW6NXXDZhv0bz1rRTv4o207A
        iaNB050bYN9IC
X-Received: by 2002:a1c:f414:: with SMTP id z20mr5923472wma.94.1630436830296;
        Tue, 31 Aug 2021 12:07:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQWrSDLLp1TcV1T+/bO+ed5HqV84f+I7rn+Kp+Rm6ixxZf1kGZm5sU+cR1zQ/9IfVLm1yr5g==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr5923456wma.94.1630436830087;
        Tue, 31 Aug 2021 12:07:10 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23bf5.dip0.t-ipconnect.de. [79.242.59.245])
        by smtp.gmail.com with ESMTPSA id n1sm18760006wrp.49.2021.08.31.12.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 12:07:09 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
Message-ID: <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
Date:   Tue, 31 Aug 2021 21:07:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YSlkzLblHfiiPyVM@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.08.21 00:18, Sean Christopherson wrote:
> On Thu, Aug 26, 2021, David Hildenbrand wrote:
>> You'll end up with a VMA that corresponds to the whole file in a single
>> process only, and that cannot vanish, not even in parts.
> 
> How would userspace tell the kernel to free parts of memory that it doesn't want
> assigned to the guest, e.g. to free memory that the guest has converted to
> not-private?

I'd guess one possibility could be fallocate(FALLOC_FL_PUNCH_HOLE).

Questions are: when would it actually be allowed to perform such a 
destructive operation? Do we have to protect from that? How would KVM 
protect from user space replacing private pages by shared pages in any 
of the models we discuss?

> 
>> Define "ordinary" user memory slots as overlay on top of "encrypted" memory
>> slots.  Inside KVM, bail out if you encounter such a VMA inside a normal
>> user memory slot. When creating a "encryped" user memory slot, require that
>> the whole VMA is covered at creation time. You know the VMA can't change
>> later.
> 
> This can work for the basic use cases, but even then I'd strongly prefer not to
> tie memslot correctness to the VMAs.  KVM doesn't truly care what lies behind
> the virtual address of a memslot, and when it does care, it tends to do poorly,
> e.g. see the whole PFNMAP snafu.  KVM cares about the pfn<->gfn mappings, and
> that's reflected in the infrastructure.  E.g. KVM relies on the mmu_notifiers
> to handle mprotect()/munmap()/etc...

Right, and for the existing use cases this worked. But encrypted memory 
breaks many assumptions we once made ...

I have somewhat mixed feelings about pages that are mapped into 
$WHATEVER page tables but not actually mapped into user space page 
tables. There is no way to reach these via the rmap.

We have something like that already via vfio. And that is fundamentally 
broken when it comes to mmu notifiers, page pinning, page migration, ...

> 
> As is, I don't think KVM would get any kind of notification if userpaces unmaps
> the VMA for a private memslot that does not have any entries in the host page
> tables.   I'm sure it's a solvable problem, e.g. by ensuring at least one page
> is touched by the backing store, but I don't think the end result would be any
> prettier than a dedicated API for KVM to consume.
> 
> Relying on VMAs, and thus the mmu_notifiers, also doesn't provide line of sight
> to page migration or swap.  For those types of operations, KVM currently just
> reacts to invalidation notifications by zapping guest PTEs, and then gets the
> new pfn when the guest re-faults on the page.  That sequence doesn't work for
> TDX or SEV-SNP because the trusteday agent needs to do the memcpy() of the page
> contents, i.e. the host needs to call into KVM for the actual migration.

Right, but I still think this is a kernel internal. You can do such 
handshake later in the kernel IMHO.

But I also already thought: is it really KVM that is to perform the 
migration or is it the fd-provider that performs the migration? Who says 
memfd_encrypted() doesn't default to a TDX "backend" on Intel CPUs that 
just knows how to migrate such a page?

I'd love to have some details on how that's supposed to work, and which 
information we'd need to migrate/swap/... in addition to the EPFN and a 
new SPFN.

> 
> There's also the memory footprint side of things; the fd-based approach avoids
> having to create host page tables for memory that by definition will never be
> used by the host.

While that is true, that is not a compelling argument IMHO. No need to 
try to be better than state of the art if it results in something 
cleaner/better* just sticking with state of the art. Just like we don't 
have special interfaces to map $WHATEVER into a guest and bypassing user 
space page tables.

* to be shown what actually is cleaner/better. We don't really have 
prototypes for either.

-- 
Thanks,

David / dhildenb

