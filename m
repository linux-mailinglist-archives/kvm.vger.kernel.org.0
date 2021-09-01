Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31DC3FD29D
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 06:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241896AbhIAFAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 01:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhIAFAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 01:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A6F60232;
        Wed,  1 Sep 2021 04:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630472357;
        bh=Q2FwKGKWoZWfAPBVP99Q/ekB3fP6VqumPb1wzqe6Qqg=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=aGjJdeyHej8wH/ivFp9q5d3pewYxLqHCVEY0OxeiCITPPfEuLUvgTAEYE65yriA6w
         +7r9UpoxP6eTD7lmhpsMCWe+1D8F4pltXzK09fsYFKEKminqOjvZijoiyC7pRxFAOV
         VlFR6OSBb8J1xQiM4FZaw6nXDCH2rnAkZkPvDUqKnpbueY6Fo7IRVkdOSR/Nj+IYDk
         OHijHdmeqBfKGtCb8uPq1OZgAAsQEc/iGgOBdtEkVr3x/czkbWpIe1CyD0Hq41Xth/
         5HQdqa2gB16hSlCxLCQIXWlT3dO1wO6UPRrK2JhFmK6GpqKFa2A6my2yz90VOLZm+t
         otkKZOo5bCuWA==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id D4F6C27C0054;
        Wed,  1 Sep 2021 00:59:14 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 00:59:14 -0400
X-ME-Sender: <xms:nwgvYTYr5Ts2JNqrSREg7Sq5ejSNja9FyycpBzh8_-8d0S9MqD9ZWA>
    <xme:nwgvYSYGJFfYRY8T6sgNsy4q9mUU7EH1XcPCOWBDGbMWassVrw22D_WX5xnpRvkb-
    VsY9TYJwtBGO_XBPN4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvvddgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegjefghfdtledvfeegfeelvedtgfevkeeugfekffdvveeffeetieeh
    ueetveekfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:nwgvYV8aRQ7OIQPRq-LWqMNRgjwsBceO_rXtG2lLk-b8D-zL1nNfeQ>
    <xmx:nwgvYZoAlR8lpuNDi_-nbGwNECPzkRbpoKvgl9y1OU-jNCLk6hoxCw>
    <xmx:nwgvYephN6ezphITvjxk8ml4QEqG8nyMzzfTmiG0xo06AhMna2qOTw>
    <xmx:oggvYZ8CoHHfXl8K3giZ17biBW5LV5wxChnfJBYPAdfnER9CLfOKF8DIQjc>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B3238A002E4; Wed,  1 Sep 2021 00:59:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <ccff0e92-ee24-48e3-ab1f-85a253bb787c@www.fastmail.com>
In-Reply-To: <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
Date:   Tue, 31 Aug 2021 21:58:50 -0700
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

On Tue, Aug 31, 2021, at 12:07 PM, David Hildenbrand wrote:
> On 28.08.21 00:18, Sean Christopherson wrote:
> > On Thu, Aug 26, 2021, David Hildenbrand wrote:
> >> You'll end up with a VMA that corresponds to the whole file in a single
> >> process only, and that cannot vanish, not even in parts.
> > 
> > How would userspace tell the kernel to free parts of memory that it doesn't want
> > assigned to the guest, e.g. to free memory that the guest has converted to
> > not-private?
> 
> I'd guess one possibility could be fallocate(FALLOC_FL_PUNCH_HOLE).
> 
> Questions are: when would it actually be allowed to perform such a 
> destructive operation? Do we have to protect from that? How would KVM 
> protect from user space replacing private pages by shared pages in any 
> of the models we discuss?
> 

What do you mean?  If userspace maliciously replaces a shared page by a private page, then the guest crashes.

(The actual meaning here is a bit different on SNP-ES vs TDX.  In SNP-ES, a given GPA can be shared, private, or nonexistent.  A guest accesses it with a special bit set in the guest page tables to indicate whether it expects shared or private, and the CPU will produce an appropriate error if the bit doesn't match the page.  In TDX, there is actually an entirely separate shared vs private address space, and, in theory, a given "GPA" can exist as shared and as private at once.  The full guest n-bit GPA plus the shared/private bit is logically an N+1 bit address, and it's possible to map all of it at once, half shared, and half private.  In practice, the defined guest->host APIs don't really support that usage.
