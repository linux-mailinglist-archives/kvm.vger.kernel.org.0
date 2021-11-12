Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0115F44EEC1
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 22:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhKLVmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 16:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233668AbhKLVmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 16:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 416BF60C51;
        Fri, 12 Nov 2021 21:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636753195;
        bh=waHo1CcQKrQyHk7BDC+PtufEDituE6Y2wer+XQEleQw=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=RIwdlHdBwpYa+2eA7c1MEbNSm+nn/f8lo/LyXp52GXWcgvTdNSRM+3iBnDP6ConnU
         5+pyBhwVtnGgO1eaE3jviZEDasOoCcg3YeMJln8ojv0vIivM27GpUMMNQOcl2A8KcA
         CacvzeTa0HsYG+d9tN1KR0Dw72SirD5YaC2wZGAq5EYja7jG30ZyCe+eEIiWPx4GcO
         Av5aWBwvHzRkLSHXKqVLcyHhjLQ3wA8Hq6qCvwaXwTo8h5Gtu7YNf4ivi5/9vh1Z55
         CUOsPNfWIAHmt/xSKoO4SA6bxlmvhmwfNxx92qi4n3B+Pa+2D6fm/6+JVvClim7jIv
         YQxij4rFZL3Nw==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0964827C0054;
        Fri, 12 Nov 2021 16:39:51 -0500 (EST)
Received: from imap48 ([10.202.2.98])
  by compute6.internal (MEProxy); Fri, 12 Nov 2021 16:39:51 -0500
X-ME-Sender: <xms:JN-OYUxAX7EKNeSAG4h4HZTnoCfK_xuW6e_yJFHMPYzjuufHfSjrIg>
    <xme:JN-OYYTEWI_x62tX37_7cO4oBnF6gLevpwfROiCMeWkaXDgrGyDUxKbENyIKss_Nm
    qu-xvdiiJ5IwsK5YlI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrvdefgddugeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpedthfehtedtvdetvdetudfgueeuhfdtudegvdelveelfedvteelfffg
    fedvkeegfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:JN-OYWWcamLfjf29sR-10us6eZx54CrAxYgPetvQddbNdxaAFhUX6A>
    <xmx:JN-OYSjB5reOsxYg2_C4-3qqR4rXPNOj_1-E0MjbZKl6tWnReXlyaA>
    <xmx:JN-OYWDy7ZuHDgn3ZxZjgra0tPyHkroLqCehzOLYOIRyrV00WSXPDw>
    <xmx:J9-OYeZ7rb5MkiwIslZPVGMayNMYekJkYHuNdQDyRitTqpuJ0bs5Uruvdlw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 503AE21E006E; Fri, 12 Nov 2021 16:39:48 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1371-g2296cc3491-fm-20211109.003-g2296cc34
Mime-Version: 1.0
Message-Id: <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com>
In-Reply-To: <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
Date:   Fri, 12 Nov 2021 13:39:28 -0800
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Marc Orr" <marcorr@google.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Peter Gonda" <pgonda@google.com>,
        "Brijesh Singh" <brijesh.singh@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "kvm list" <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Joerg Roedel" <jroedel@suse.de>,
        "Tom Lendacky" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Sergio Lopez" <slp@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
        "David Rientjes" <rientjes@google.com>,
        "Dov Murik" <dovmurik@linux.ibm.com>,
        "Tobin Feldman-Fitzthum" <tobin@ibm.com>,
        "Michael Roth" <Michael.Roth@amd.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Sathyanarayanan Kuppuswamy" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor
 Support
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Fri, Nov 12, 2021, at 1:30 PM, Marc Orr wrote:
> On Fri, Nov 12, 2021 at 12:38 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Fri, Nov 12, 2021, Borislav Petkov wrote:
>> > On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrote:
>> > > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
>> >
>> > What do you suggest instead?
>>
>> Let userspace decide what is mapped shared and what is mapped private.  The kernel
>> and KVM provide the APIs/infrastructure to do the actual conversions in a thread-safe
>> fashion and also to enforce the current state, but userspace is the control plane.
>>
>> It would require non-trivial changes in userspace if there are multiple processes
>> accessing guest memory, e.g. Peter's networking daemon example, but it _is_ fully
>> solvable.  The exit to userspace means all three components (guest, kernel,
>> and userspace) have full knowledge of what is shared and what is private.  There
>> is zero ambiguity:
>>
>>   - if userspace accesses guest private memory, it gets SIGSEGV or whatever.
>>   - if kernel accesses guest private memory, it does BUG/panic/oops[*]
>>   - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.
>>
>> This is the direction KVM TDX support is headed, though it's obviously still a WIP.
>>
>> And ideally, to avoid implicit conversions at any level, hardware vendors' ABIs
>> define that:
>>
>>   a) All convertible memory, i.e. RAM, starts as private.
>>   b) Conversions between private and shared must be done via explicit hypercall.
>>
>> Without (b), userspace and thus KVM have to treat guest accesses to the incorrect
>> type as implicit conversions.
>>
>> [*] Sadly, fully preventing kernel access to guest private is not possible with
>>     TDX, especially if the direct map is left intact.  But maybe in the future
>>     TDX will signal a fault instead of poisoning memory and leaving a #MC mine.
>
> In this proposal, consider a guest driver instructing a device to DMA
> write a 1 GB memory buffer. A well-behaved guest driver will ensure
> that the entire 1 GB is marked shared. But what about a malicious or
> buggy guest? Let's assume a bad guest driver instructs the device to
> write guest private memory.
>
> So now, the virtual device, which might be implemented as some host
> side process, needs to (1) check and lock all 4k constituent RMP
> entries (so they're not converted to private while the DMA write is
> taking palce), (2) write the 1 GB buffer, and (3) unlock all 4 k
> constituent RMP entries? If I'm understanding this correctly, then the
> synchronization will be prohibitively expensive.

Let's consider a very very similar scenario: consider a guest driver setting up a 1 GB DMA buffer.  The virtual device, implemented as host process, needs to (1) map (and thus lock *or* be prepared for faults) in 1GB / 4k pages of guest memory (so they're not *freed* while the DMA write is taking place), (2) write the buffer, and (3) unlock all the pages.  Or it can lock them at setup time and keep them locked for a long time if that's appropriate.

Sure, the locking is expensive, but it's nonnegotiable.  The RMP issue is just a special case of the more general issue that the host MUST NOT ACCESS GUEST MEMORY AFTER IT'S FREED.

--Andy
