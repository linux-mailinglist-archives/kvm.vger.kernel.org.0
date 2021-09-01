Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEEB3FDF16
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbhIAPzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 11:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244935AbhIAPzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 11:55:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2908A61027;
        Wed,  1 Sep 2021 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630511674;
        bh=rLGcbcuexPZZqKGMPzQ7o2DdekXmW57gDobAJ62qy1c=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=ncrlQPza2dPS4GXdhHyt3VmJVAW0nfjSF5MJEPqHls+Aa1zkTTFh5BFFUP6Q4jVQd
         ns+w4qJZZFrmQKFR1tQ6oMvJyLoqgn1Np8PkFl+8M7CBybYJcEQRLNyRJyxnPJ0nD+
         kJweF8aIJWsDcj+yXHcQ2kt8t5xRq/t7o6DuCuuaRnQqKxjPLruXsxfKv8uhn3i8Bw
         w2sO9eBazO7ApsmcUphuRkZpQZgTSGpNOtIWWt9KGsD1h3pqrUYlE0UQTSmG9bU5Zm
         zP0l9hLrNAtuEGAAURJpxi9+6UvRV9siKn0JJmR4Ur//Qr0kT6cCJ/9Lgrxqipc2/n
         zRLnnUrq1/kcw==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 43B1027C0054;
        Wed,  1 Sep 2021 11:54:31 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 11:54:31 -0400
X-ME-Sender: <xms:M6IvYV97U_LYg7Yc-D0gAG4SQkMTffLae3HtSDV2H79jQqbsRRS0wg>
    <xme:M6IvYZv97JPomvBjbmYRJ_oUrlIPUPFpDbbq_UdfI8iq9s-vwDmEOnvMurXGpVnxr
    zRN9vhGmu6B_OvwHHM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegjefghfdtledvfeegfeelvedtgfevkeeugfekffdvveeffeetieeh
    ueetveekfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:M6IvYTCVBRS5Uj8oxAw4N-DxWBZGX2TNG-4G71ASbMUQ6NK_6lmlpg>
    <xmx:M6IvYZcRjffvDfI5LVr0SHNRvNxZ51ZsOwEsEMFXbkUvxYi79olieg>
    <xmx:M6IvYaPrVYrq9_f9tuIxz9T-FSeUvU2lmsVHqs3QNanNjb6UIp2Ocg>
    <xmx:N6IvYdjcCsGxn0PMH_lRIilnFCEmryC9wQ5YUcrR4WWN_igb2M7wecBzurQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 81596A002E4; Wed,  1 Sep 2021 11:54:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
In-Reply-To: <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
Date:   Wed, 01 Sep 2021 08:54:02 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "David Hildenbrand" <david@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>, "kvm list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Joerg Roedel" <jroedel@suse.de>,
        "Andi Kleen" <ak@linux.intel.com>,
        "David Rientjes" <rientjes@google.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Varad Gautam" <varad.gautam@suse.com>,
        "Dario Faggioli" <dfaggioli@suse.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-mm@kvack.org,
        linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Sathyanarayanan Kuppuswamy" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Yu Zhang" <yu.c.zhang@linux.intel.com>
Subject: =?UTF-8?Q?Re:_[RFC]_KVM:_mm:_fd-based_approach_for_supporting_KVM_guest_?=
 =?UTF-8?Q?private_memory?=
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 1, 2021, at 1:09 AM, David Hildenbrand wrote:
> >> Do we have to protect from that? How would KVM protect from user space
> >> replacing private pages by shared pages in any of the models we discuss?
> > 
> > The overarching rule is that KVM needs to guarantee a given pfn is never mapped[*]
> > as both private and shared, where "shared" also incorporates any mapping from the
> > host.  Essentially it boils down to the kernel ensuring that a pfn is unmapped
> > before it's converted to/from private, and KVM ensuring that it honors any
> > unmap notifications from the kernel, e.g. via mmu_notifier or via a direct callback
> > as proposed in this RFC.
> 
> Okay, so the fallocate(PUNCHHOLE) from user space could trigger the 
> respective unmapping and freeing of backing storage.
> 
> > 
> > As it pertains to PUNCH_HOLE, the responsibilities are no different than when the
> > backing-store is destroyed; the backing-store needs to notify downstream MMUs
> > (a.k.a. KVM) to unmap the pfn(s) before freeing the associated memory.
> 
> Right.
> 
> > 
> > [*] Whether or not the kernel's direct mapping needs to be removed is debatable,
> >      but my argument is that that behavior is not visible to userspace and thus
> >      out of scope for this discussion, e.g. zapping/restoring the direct map can
> >      be added/removed without impacting the userspace ABI.
> 
> Right. Removing it shouldn't also be requited IMHO. There are other ways 
> to teach the kernel to not read/write some online pages (filter 
> /proc/kcore, disable hibernation, strict access checks for /dev/mem ...).
> 
> > 
> >>>> Define "ordinary" user memory slots as overlay on top of "encrypted" memory
> >>>> slots.  Inside KVM, bail out if you encounter such a VMA inside a normal
> >>>> user memory slot. When creating a "encryped" user memory slot, require that
> >>>> the whole VMA is covered at creation time. You know the VMA can't change
> >>>> later.
> >>>
> >>> This can work for the basic use cases, but even then I'd strongly prefer not to
> >>> tie memslot correctness to the VMAs.  KVM doesn't truly care what lies behind
> >>> the virtual address of a memslot, and when it does care, it tends to do poorly,
> >>> e.g. see the whole PFNMAP snafu.  KVM cares about the pfn<->gfn mappings, and
> >>> that's reflected in the infrastructure.  E.g. KVM relies on the mmu_notifiers
> >>> to handle mprotect()/munmap()/etc...
> >>
> >> Right, and for the existing use cases this worked. But encrypted memory
> >> breaks many assumptions we once made ...
> >>
> >> I have somewhat mixed feelings about pages that are mapped into $WHATEVER
> >> page tables but not actually mapped into user space page tables. There is no
> >> way to reach these via the rmap.
> >>
> >> We have something like that already via vfio. And that is fundamentally
> >> broken when it comes to mmu notifiers, page pinning, page migration, ...
> > 
> > I'm not super familiar with VFIO internals, but the idea with the fd-based
> > approach is that the backing-store would be in direct communication with KVM and
> > would handle those operations through that direct channel.
> 
> Right. The problem I am seeing is that e.g., try_to_unmap() might not be 
> able to actually fully unmap a page, because some non-synchronized KVM 
> MMU still maps a page. It would be great to evaluate how the fd 
> callbacks would fit into the whole picture, including the current rmap.
> 
> I guess I'm missing the bigger picture how it all fits together on the 
> !KVM side.

The big picture is fundamentally a bit nasty.  Logically (ignoring the implementation details of rmap, mmu_notifier, etc), you can call try_to_unmap and end up with a page that is Just A Bunch Of Bytes (tm).  Then you can write it to disk, memcpy to another node, compress it, etc. When it gets faulted back in, you make sure the same bytes end up somewhere and put the PTEs back.

With guest-private memory, this doesn't work.  Forget about the implementation: you simply can't take a page of private memory, quiesce it so the guest can't access it without faulting, and turn it into Just A Bunch Of Bytes.  TDX does not have that capability.  (Any system with integrity-protected memory won't without having >PAGE_SIZE bytes or otherwise storing metadata, but TDX can't do this at all.)  SEV-ES *can* (I think -- I asked the lead architect), but that's not the same thing as saying it's a good idea.

So if you want to migrate a TDX page from one NUMA node to another, you need to do something different (I don't know all the details), you will have to ask Intel to explain how this might work in the future (it wasn't in the public docs last time I looked), but I'm fairly confident that it does not resemble try_to_unmap().

Even on SEV, where a page *can* be transformed into a Just A Bunch Of Bytes, the operation doesn't really look like try_to_unmap().  As I understand it, it's more of:

look up the one-and-only guest and GPA at which this page is mapped.
tear down the NPT PTE.  (SEV, unlike TDX, uses paging structures in normal memory.)
Ask the magic SEV mechanism to turn the page into swappable data
Go to town.

This doesn't really resemble the current rmap + mmu_notifier code, and shoehorning this into mmu_notifier seems like it may be uglier and more code than implementing it more directly in the backing store.

If you actually just try_to_unmap() a SEV-ES page (and it worked, which it currently won't), you will have data corruption or cache incoherency.

If you want to swap a page on TDX, you can't.  Sorry, go directly to jail, do not collect $200.

So I think there are literally zero code paths that currently call try_to_unmap() that will actually work like that on TDX.  If we run out of memory on a TDX host, we can kill the guest completely and reclaim all of its memory (which probably also involves killing QEMU or whatever other user program is in charge), but that's really our only option.

--Andy
