Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C3E44F720
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 08:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhKNHop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 02:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhKNHoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 02:44:18 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BF9C061746
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 23:41:22 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id o15-20020a9d410f000000b0055c942cc7a0so21450509ote.8
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 23:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEl8pUyPdu8dWglxcmM2AFwvu3sjrwE52t1dq7OvmyI=;
        b=GTfhVUMILBRMcmbX0uDr3r96tVbHG888gOAidYX8RaKrS4MvB2MgTxshS/RmkPdVCZ
         RdgglUUfb65voHbEv/tuZFy3+tfwO6vRghjwsCW7vZ8cGrOYr4urxYowWa85qJ/EyVUn
         bbmod8GxmXTo+r1ViIFnklNEP3EkrAOKZwbNa/hh1E0GVqM2FMIsstoU3EcpMGztE3GV
         Rxr336bgKkh9AKX+OVM9kvzKYFf2ZNBiBJnB9gSLvINhiFTL7Igz52+EsexoKZg1V3lT
         dmutXkZcHmaQ6FZ6WKp3WDfUKbZOVLUz0geXPdnoavu6+Ou2eXY5/Nz0C4mSiU3b7Kc8
         OgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEl8pUyPdu8dWglxcmM2AFwvu3sjrwE52t1dq7OvmyI=;
        b=ooV9GeG6O7RQFnBwgcuniBYrVolr56ZgWTca+02OWP1r7J6/ep/z/1aqeP4H5XNiXQ
         d/L0xE5jYQK1JanzHP5dsUGTxhzNxuUmk8vfQQEEoml3UFVrY3DkqP1fJ7WVd7bhyySi
         LRnNYFHf2d7cMOgAmmZPOsLprhW2S2vfmXeZ+EcvCZxiJNjvBKrRs3Tfw/fTmeKFJ5GZ
         sJVn9Ba3OfLVUNbr8n1dcJarrTbJybIz0a4RUvgH3YF8nsNZE4nsQddSnwxXmYpnGAM1
         uK2xZb+iXgvjIA74cEFEcDXEiEoM9as/nVeC/FKvOX+KNdt6uNDpfEEZxuPhlEeWjrKA
         vh6g==
X-Gm-Message-State: AOAM530bbcofhi2Fv13uWX3sfCcPvcO6pb4KvwmmXwr18vW/fhN5JBY8
        Ug7RrQCfkfnUoMMJdjHcqRgG1HW7CshFafPMGzbSGA==
X-Google-Smtp-Source: ABdhPJyvs99INqk1PmO0KDPewAuQ93vzw5FTqPd5+5RTQC48tx1y9C6LKAk3lzClSSsXgAvZf15tBdja15MoM4TeakQ=
X-Received: by 2002:a9d:644e:: with SMTP id m14mr23277722otl.29.1636875681818;
 Sat, 13 Nov 2021 23:41:21 -0800 (PST)
MIME-Version: 1.0
References: <YY6z5/0uGJmlMuM6@zn.tnic> <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com> <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
 <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com> <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
 <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com>
 <YY8Mi36N/e4PzGP0@google.com> <CAA03e5F=7T3TcJBksiJ9ovafX65YfzAc0S+uYu5LjfTQ60yC7w@mail.gmail.com>
 <YZADwHxsx5cZ6m47@google.com>
In-Reply-To: <YZADwHxsx5cZ6m47@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 13 Nov 2021 23:41:10 -0800
Message-ID: <CAA03e5HwYtn+eG1f5eP-SrZPyE4D2uf0v10=VkVoTNQQk87Kew@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 13, 2021 at 10:28 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 12, 2021, Marc Orr wrote:
> > On Fri, Nov 12, 2021 at 4:53 PM Sean Christopherson <seanjc@google.com> wrote:
> > > On Fri, Nov 12, 2021, Peter Gonda wrote:
> > > > Having a way for userspace to lock pages as shared was an idea I just
> > > > proposed the simplest solution to start the conversation.
> > >
> > > Assuming you meant that to read:
> > >
> > >   Having a way for userspace to lock pages as shared is an alternative idea; I
> > >   just proposed the simplest solution to start the conversation.
> > >
> > > The unmapping[*] guest private memory proposal is essentially that, a way for userspace
> > > to "lock" the state of a page by requiring all conversions to be initiated by userspace
> > > and by providing APIs to associate a pfn 1:1 with a KVM instance, i.e. lock a pfn to
> > > a guest.
> > >
> > > Andy's DMA example brings up a very good point though.  If the shared and private
> > > variants of a given GPA are _not_ required to point at a single PFN, which is the
> > > case in the current unmapping proposal, userspace doesn't need to do any additional
> > > juggling to track guest conversions across multiple processes.
> > >
> > > Any process that's accessing guest (shared!) memory simply does its locking as normal,
> > > which as Andy pointed out, is needed for correctness today.  If the guest requests a
> > > conversion from shared=>private without first ensuring the gfn is unused (by a host
> > > "device"), the host will side will continue accessing the old, shared memory, which it
> > > locked, while the guest will be doing who knows what.  And if the guest provides a GPA
> > > that isn't mapped shared in the VMM's address space, it's conceptually no different
> > > than if the guest provided a completely bogus GPA, which again needs to be handled today.
> > >
> > > In other words, if done properly, differentiating private from shared shouldn't be a
> > > heavy lift for host userspace.
> > >
> > > [*] Actually unmapping memory may not be strictly necessary for SNP because a
> > >     #PF(RMP) is likely just as good as a #PF(!PRESENT) when both are treated as
> > >     fatal, but the rest of the proposal that allows KVM to understand the stage
> > >     of a page and exit to userspace accordingly applies.
> >
> > Thanks for this explanation. When you write "while the guest will be
> > doing who knows what":
> >
> > Isn't that a large weakness of this proposal? To me, it seems better
> > for debuggability to corrupt the private memory (i.e., convert the
> > page to shared) so the guest can detect the issue via a PVALIDATE
> > failure.
>
> The behavior is no different than it is today for regular VMs.

Isn't this counter to the sketch you laid out earlier where you wrote:

--- QUOTE START ---
  - if userspace accesses guest private memory, it gets SIGSEGV or whatever.
  - if kernel accesses guest private memory, it does BUG/panic/oops[*]
  - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.
--- QUOTE END ---

Here, the guest does not get killed. Which seems hard to debug.

> > The main issue I see with corrupting the guest memory is that we may
> > not know whether the host is at fault or the guest.
>
> Yes, one issue is that bugs in the host will result in downstream errors in the
> guest, as opposed to immediate, synchronous detection in the guest.  IMO that is
> a significant flaw.

Nobody wants bugs in the host. Once we've hit one -- and we will --
we're in a bad situation. The question is how will we handle these
bugs. I'm arguing that we should design the system to be as robust as
possible.

I agree that immediate, synchronous detection in the guest is ideal.
But at what cost? Is it worth killing _ALL_ VMs on the system? That's
what we're doing when we crash host-wide processes, or even worse, the
kernel itself.

The reality is that guests must be able to detect writes to their
private memory long after they have occurred. Both SNP and TDX are
designed this way! For SNP the guest gets a PVALIDATE failure when it
reads the corrupted memory. For TDX, my understanding is that the
hardware fails to verify an HMAC over a page when it's read by the
guest.

The argument I'm making is that the success of confidential VMs -- in
both SNP and TDX -- depends on the guest being able to detect that its
private memory has been corrupted in a delayed and asynchronous
fashion. We should be leveraging this fact to make the entire system
more robust and reliable.

> Another issue is that the host kernel, which despite being "untrusted", absolutely
> should be acting in the best interests of the guest.  Allowing userspace to inject
> #VC, e.g. to attempt to attack the guest by triggering a spurious PVALIDATE, means
> the kernel is failing miserably on that front.

The host is acting in the best interests of the guest. That's why
we're having this debate :-). No-one here is trying to write host code
to sabotage the guest. Quite the opposite.

But what happens when we mess up? That's what this conversation is really about.

If allowing userspace to inject #VC into the guest means that the host
can continue to serve other guests, that seems like a win. The
alternative, to blow up the host, essentially expands the blast radius
from a single guest to all guests.

Also, these attacks go both ways. As we already discussed, the guest
may try to trick the host into writing its own private memory. Yes,
the entire idea to literally make that impossible is a good one -- in
theory. But it's also very complicated. And what happens if we get
that wrong? Now our entire host is at risk from a single guest.

Leveraging the system-wide design of SNP and TDX -- where a detecting
writes to private memory asynchronously is table stakes -- increases
the reliability of the entire system. And, as Peter mentioned earlier
on, we can always incorporate any future work to make writing private
memory impossible into SNP, on top of the code to convert the shared
page to private. This way, we get reliability in depth, and minimize
the odds of crashing the host -- and its VMs.
