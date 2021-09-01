Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55ADF3FD4E9
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 10:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242944AbhIAIKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 04:10:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242913AbhIAIKI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 04:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630483751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xehwNc5m+0VkuxXN2ywY3KTZndfyL4hPEsZFfPwosyo=;
        b=Gqfb2DC+SIKh/b+m6HsvIL3HWsTUEAqJJSW2rK3DlHaTqe96lAqoF3Rq3eIYDM3KTx4fwW
        E87coeCpedqZBVkRDI8yScIb8dwADF5OukhyJGyRtjVJ5eoE0fdITGv2uGDTVVYSA6K5xU
        ML6wStMWTLjrZzsij1G2yqu12QwdPoc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-2qpMDCE6M5i5Pv9KNoSXsg-1; Wed, 01 Sep 2021 04:09:10 -0400
X-MC-Unique: 2qpMDCE6M5i5Pv9KNoSXsg-1
Received: by mail-wr1-f71.google.com with SMTP id u2-20020adfdd42000000b001579f5d6779so515736wrm.8
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 01:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xehwNc5m+0VkuxXN2ywY3KTZndfyL4hPEsZFfPwosyo=;
        b=PT9I8L/A7Z5UB1Lh30kcfUVlYLKrllh12Q3tCwtSCQLuoxOzHxVgoZIn9E+MjTG5Pg
         g+dXVX18V8++2lfeP86EH1kPu4hVdXaYZtCqBBaiZ0YfOosyT81Qw6RZDelaCkcOBRZZ
         EZ5mexQYYdKm+J5/+ZbDbh3jCJOX2l6+TOhJneql+BImpYb87n/+uFkaUpiDqQsoem+W
         3MvkyHq98eGewGNXNH31xf4RKzagel4BlJ7790na88DPIvIMCXlfYNGIm33sVLeeDm+L
         i3ljRB4GlrGHdxTndIf/D4CHZ/8ATRmTJA4JSPexuBRdFEnikpc5Y2uzSONauzu+7GBj
         culw==
X-Gm-Message-State: AOAM531lDJ2KSPWqAeqzUh5JG04mIYO+fxsfuaghT0cIoff+xWjo/+kI
        xOl2cuQY3+u5aImcOQldu2O+m7tTZJ9tPXng4/L4qObpysN8+CViWTOu0n/5o+6Qj6134c1EoC8
        5FXMPn1m3o1iy
X-Received: by 2002:a1c:2684:: with SMTP id m126mr8402739wmm.65.1630483749528;
        Wed, 01 Sep 2021 01:09:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVg9SDEJVZUq3nbvsMK7CWfSbicB1cKUcx7fhtGFdGrRsx3YALb8TPN4qumsd3be+NY8b/Lw==
X-Received: by 2002:a1c:2684:: with SMTP id m126mr8402689wmm.65.1630483749203;
        Wed, 01 Sep 2021 01:09:09 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23f71.dip0.t-ipconnect.de. [79.242.63.113])
        by smtp.gmail.com with ESMTPSA id o7sm4481973wmc.46.2021.09.01.01.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 01:09:08 -0700 (PDT)
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
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
Message-ID: <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
Date:   Wed, 1 Sep 2021 10:09:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YS6lIg6kjNPI1EgF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> Do we have to protect from that? How would KVM protect from user space
>> replacing private pages by shared pages in any of the models we discuss?
> 
> The overarching rule is that KVM needs to guarantee a given pfn is never mapped[*]
> as both private and shared, where "shared" also incorporates any mapping from the
> host.  Essentially it boils down to the kernel ensuring that a pfn is unmapped
> before it's converted to/from private, and KVM ensuring that it honors any
> unmap notifications from the kernel, e.g. via mmu_notifier or via a direct callback
> as proposed in this RFC.

Okay, so the fallocate(PUNCHHOLE) from user space could trigger the 
respective unmapping and freeing of backing storage.

> 
> As it pertains to PUNCH_HOLE, the responsibilities are no different than when the
> backing-store is destroyed; the backing-store needs to notify downstream MMUs
> (a.k.a. KVM) to unmap the pfn(s) before freeing the associated memory.

Right.

> 
> [*] Whether or not the kernel's direct mapping needs to be removed is debatable,
>      but my argument is that that behavior is not visible to userspace and thus
>      out of scope for this discussion, e.g. zapping/restoring the direct map can
>      be added/removed without impacting the userspace ABI.

Right. Removing it shouldn't also be requited IMHO. There are other ways 
to teach the kernel to not read/write some online pages (filter 
/proc/kcore, disable hibernation, strict access checks for /dev/mem ...).

> 
>>>> Define "ordinary" user memory slots as overlay on top of "encrypted" memory
>>>> slots.  Inside KVM, bail out if you encounter such a VMA inside a normal
>>>> user memory slot. When creating a "encryped" user memory slot, require that
>>>> the whole VMA is covered at creation time. You know the VMA can't change
>>>> later.
>>>
>>> This can work for the basic use cases, but even then I'd strongly prefer not to
>>> tie memslot correctness to the VMAs.  KVM doesn't truly care what lies behind
>>> the virtual address of a memslot, and when it does care, it tends to do poorly,
>>> e.g. see the whole PFNMAP snafu.  KVM cares about the pfn<->gfn mappings, and
>>> that's reflected in the infrastructure.  E.g. KVM relies on the mmu_notifiers
>>> to handle mprotect()/munmap()/etc...
>>
>> Right, and for the existing use cases this worked. But encrypted memory
>> breaks many assumptions we once made ...
>>
>> I have somewhat mixed feelings about pages that are mapped into $WHATEVER
>> page tables but not actually mapped into user space page tables. There is no
>> way to reach these via the rmap.
>>
>> We have something like that already via vfio. And that is fundamentally
>> broken when it comes to mmu notifiers, page pinning, page migration, ...
> 
> I'm not super familiar with VFIO internals, but the idea with the fd-based
> approach is that the backing-store would be in direct communication with KVM and
> would handle those operations through that direct channel.

Right. The problem I am seeing is that e.g., try_to_unmap() might not be 
able to actually fully unmap a page, because some non-synchronized KVM 
MMU still maps a page. It would be great to evaluate how the fd 
callbacks would fit into the whole picture, including the current rmap.

I guess I'm missing the bigger picture how it all fits together on the 
!KVM side.

> 
>>> As is, I don't think KVM would get any kind of notification if userpaces unmaps
>>> the VMA for a private memslot that does not have any entries in the host page
>>> tables.   I'm sure it's a solvable problem, e.g. by ensuring at least one page
>>> is touched by the backing store, but I don't think the end result would be any
>>> prettier than a dedicated API for KVM to consume.
>>>
>>> Relying on VMAs, and thus the mmu_notifiers, also doesn't provide line of sight
>>> to page migration or swap.  For those types of operations, KVM currently just
>>> reacts to invalidation notifications by zapping guest PTEs, and then gets the
>>> new pfn when the guest re-faults on the page.  That sequence doesn't work for
>>> TDX or SEV-SNP because the trusteday agent needs to do the memcpy() of the page
>>> contents, i.e. the host needs to call into KVM for the actual migration.
>>
>> Right, but I still think this is a kernel internal. You can do such
>> handshake later in the kernel IMHO.
> 
> It is kernel internal, but AFAICT it will be ugly because KVM "needs" to do the
> migration and that would invert the mmu_notifer API, e.g. instead of "telling"
> secondary MMUs to invalidate/change a mappings, the mm would be "asking"
> secondary MMus "can you move this?".  More below.

In my thinking, the the rmap via mmu notifiers would do the unmapping 
just as we know it (from primary MMU -> secondary MMU). Once 
try_to_unmap() succeeded, the fd provider could kick-off the migration 
via whatever callback.

> 
>> But I also already thought: is it really KVM that is to perform the
>> migration or is it the fd-provider that performs the migration? Who says
>> memfd_encrypted() doesn't default to a TDX "backend" on Intel CPUs that just
>> knows how to migrate such a page?
>>
>> I'd love to have some details on how that's supposed to work, and which
>> information we'd need to migrate/swap/... in addition to the EPFN and a new
>> SPFN.
> 
> KVM "needs" to do the migration.  On TDX, the migration will be a SEAMCALL,
> a post-VMXON instruction that transfers control to the TDX-Module, that at
> minimum needs a per-VM identifier, the gfn, and the page table level.  The call

The per-VM identifier and the GFN would be easy to grab. Page table 
level, not so sure -- do you mean the general page table depth? Or if 
it's mapped as 4k vs. 2M ... ? The latter could be answered by the fd 
provider already I assume.

Does the page still have to be mapped into the secondary MMU when 
performing the migration via TDX? I assume not, which would simplify 
things a lot.

> into the TDX-Module would also need to take a KVM lock (probably KVM's mmu_lock)
> to satisfy TDX's concurrency requirement, e.g. to avoid "spurious" errors due to
> the backing-store attempting to migrate memory that KVM is unmapping due to a
> memslot change.

Something like that might be handled by fixing private memory slots 
similar to in my draft, right?

> 
> The per-VM identifier may not apply to SEV-SNP, but I believe everything else
> holds true.

Thanks!

-- 
Thanks,

David / dhildenb

