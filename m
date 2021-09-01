Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD44E3FD298
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 06:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbhIAEyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 00:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhIAEyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 00:54:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E587B6101A;
        Wed,  1 Sep 2021 04:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630472035;
        bh=nJHxdGVB9MUzA7usFs/P6wCxX8aS0+2RcMRXbrMc4jU=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=NdgNEYZLRJsV8AN6Qx2bCbSg+7jy5uDS2x0o66RVxlSf2OnAe3jJROCgvUma4QdAs
         Yu6M0xY8tCxzDybwqLcGml4U8URAen1hVcjyZPtOMpuPyuvX7agt8JrL/GQyoexKiS
         dt7MRyFYOlEeqi0ePKj+tBjxZD2TCCytB63IDWIN5Bkv2tw1B/Fz1w+hPCy8H/ZxDn
         lNpFFz1xTk4c/6AW48tXzBK+Aq4mLdCLP2a/y8ut/jAVCcp+lx++yUfirBaRaer6xH
         jDBLWXHj1yPf98Cjtrdz5LGIvm0JIoirD5liMJ8hEI3Y3od0ac7nUrOuIElIr0/UON
         eHXEWOqPJE3oQ==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id EF66527C0054;
        Wed,  1 Sep 2021 00:53:52 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 00:53:52 -0400
X-ME-Sender: <xms:XQcvYVQQ-Avs7odMHzhmvRkPFHW0-4kI9hku0Lb9GRylUYSdCQodcw>
    <xme:XQcvYeyHsCTgE0jTftfWt00a699-QAEg-StvDAMzKvxLkAL2jWpMlsIt-lpQ40mWa
    MT9rJpLneqWQrLFwe4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegjefghfdtledvfeegfeelvedtgfevkeeugfekffdvveeffeetieeh
    ueetveekfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:XQcvYa0_OCYZcn2wa7889GFR5e7zHXeo7G9r_5OJAsf_26QdK4HBtQ>
    <xmx:XQcvYdD2h81Zk7wUjustzUVaxu7KE-G1rVYbn4Oc7aw532e7JrWlQQ>
    <xmx:XQcvYei6ps7Y4_OPRaxqzC5u7GiyRhpsSxam0AbAOI2IB4ppNJmhSw>
    <xmx:YAcvYZ2y1dLqpD-64Z3ZqvfMe2Qc-hNL1n79PDiRdZIPFpnklIMArXhGwnM>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3F5B7A002E4; Wed,  1 Sep 2021 00:53:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
In-Reply-To: <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
Date:   Tue, 31 Aug 2021 21:53:27 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Yu Zhang" <yu.c.zhang@linux.intel.com>,
        "David Hildenbrand" <david@redhat.com>
Cc:     "Sean Christopherson" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
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
        "Dave Hansen" <dave.hansen@intel.com>
Subject: =?UTF-8?Q?Re:_[RFC]_KVM:_mm:_fd-based_approach_for_supporting_KVM_guest_?=
 =?UTF-8?Q?private_memory?=
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
> On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:

> Thanks a lot for this summary. A question about the requirement: do we or
> do we not have plan to support assigned device to the protected VM?
> 
> If yes. The fd based solution may need change the VFIO interface as well(
> though the fake swap entry solution need mess with VFIO too). Because:
> 
> 1> KVM uses VFIO when assigning devices into a VM.
> 
> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
> guest pages will have to be mapped in host IOMMU page table to host pages,
> which are pinned during the whole life cycle fo the VM.
> 
> 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
> in vfio_dma_do_map().
> 
> 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
> and pin the page. 
> 
> But if we are using fd based solution, not every GPA can have a HVA, thus
> the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
> doubt if VFIO can be modified to support this easily.
> 
> 

Do you mean assigning a normal device to a protected VM or a hypothetical protected-MMIO device?

If the former, it should work more or less like with a non-protected VM. mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether anyone will actually do this, but it should be possible, at least in principle.  Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device with the understanding that the guest can't trust it wouldn't be entirely crazy ether.

If the latter, AFAIK there is no spec for how it would work even in principle. Presumably it wouldn't work quite like VFIO -- instead, the kernel could have a protection-virtual-io-fd mechanism, and that fd could be bound to a memslot in whatever way we settle on for binding secure memory to a memslot.
