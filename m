Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BE144F060
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhKMBH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbhKMBH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:07:57 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E43C0613F5
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:05:05 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id be32so21056913oib.11
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DoF0Ia8gB0FxoSQiktgrGCfWwj/V1cH0vVB1clEUCF8=;
        b=ITzc7+0kQAmWYXhAmimjxk82k/xEHCZWzT11EGl6cC4US/AA6CdOSxt2/jxS65Pbon
         gVK1LxS+XjqBptYCnBxT+xssYafJgGOXbQKtCLgnEo1GtdMp3vGkdvJi6PHKckIWhTtC
         lMYdIFk+xe0I6v3rWZSEjGWeo0INV2c397fXmkwk0VJG5vMdswi6/Ks5W6G01/b0t7LC
         kkGPrHLDDvGNB7Qq9M8ABsvwZ3itgj8jDy4oLw4ywUj62edmEdy7czKTT49bEZqLX9nW
         EJsVkcxQzXB5cgCTe71IjiVXt+daJzQsVSqicpvQw7TpfAwa43bgEPFCfTRzZyby95ct
         ef4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DoF0Ia8gB0FxoSQiktgrGCfWwj/V1cH0vVB1clEUCF8=;
        b=XeOcwtqF2imBMSThvDKkAJVxpwGtUbbopd/tJGxhryABexvRNSbyfVnhu/R53Bx3+g
         K9tDootyoUATUy8bxmACkkKMSogsVf/LmfFajr05/vnbGXJFvUILbkYv3+UOoIZGov9s
         kuOAIkL6/LMA2PJ/iZKQ/7V29xKPZNiY/Gq5KZBcTVDrhOOSmNWKmVlCNU+6ZecswHy0
         Xhk7h9jWvIc66tO3VL+FdIPuGyoAP1Je5LECdmi4yOopF9eCM7pCYgF8Ds+xsenlrM55
         d1AvXBvC0McggjQz4INrYWulDx9OsHvt0Mk3lmuZtyw+X62nJwjLMUft+N9on2IVx3HT
         fLmA==
X-Gm-Message-State: AOAM533YHgj+f3jEi8FAy+bW88i7TVEEkVrexE9aCJe7ZGR7lABIxWns
        AY8nv69e6psvHXw2ja8GzuoMZmFA0f8zqZCI4RVUdg==
X-Google-Smtp-Source: ABdhPJwv/XgVHaUA1q6+Mn4hnMhye2TH34P12buJknP56UzIvmoiJ+A2b/hM8L6/u//Um7uyezPz6zvi6Zn/D64nllw=
X-Received: by 2002:a54:4515:: with SMTP id l21mr16407083oil.15.1636765504954;
 Fri, 12 Nov 2021 17:05:04 -0800 (PST)
MIME-Version: 1.0
References: <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
 <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com> <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
 <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com> <YY8Mi36N/e4PzGP0@google.com>
In-Reply-To: <YY8Mi36N/e4PzGP0@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 12 Nov 2021 17:04:53 -0800
Message-ID: <CAA03e5F=7T3TcJBksiJ9ovafX65YfzAc0S+uYu5LjfTQ60yC7w@mail.gmail.com>
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

On Fri, Nov 12, 2021 at 4:53 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 12, 2021, Peter Gonda wrote:
> > On Fri, Nov 12, 2021 at 2:43 PM Marc Orr <marcorr@google.com> wrote:
> > >
> > > On Fri, Nov 12, 2021 at 1:39 PM Andy Lutomirski <luto@kernel.org> wrote:
> > > > Let's consider a very very similar scenario: consider a guest driver
> > > > setting up a 1 GB DMA buffer.  The virtual device, implemented as host
> > > > process, needs to (1) map (and thus lock *or* be prepared for faults) in
> > > > 1GB / 4k pages of guest memory (so they're not *freed* while the DMA
> > > > write is taking place), (2) write the buffer, and (3) unlock all the
> > > > pages.  Or it can lock them at setup time and keep them locked for a long
> > > > time if that's appropriate.
> > > >
> > > > Sure, the locking is expensive, but it's nonnegotiable.  The RMP issue is
> > > > just a special case of the more general issue that the host MUST NOT
> > > > ACCESS GUEST MEMORY AFTER IT'S FREED.
> > >
> > > Good point.
> >
> > Thanks for the responses Andy.
> >
> > Having a way for userspace to lock pages as shared was an idea I just
> > proposed the simplest solution to start the conversation.
>
> Assuming you meant that to read:
>
>   Having a way for userspace to lock pages as shared is an alternative idea; I
>   just proposed the simplest solution to start the conversation.
>
> The unmapping[*] guest private memory proposal is essentially that, a way for userspace
> to "lock" the state of a page by requiring all conversions to be initiated by userspace
> and by providing APIs to associate a pfn 1:1 with a KVM instance, i.e. lock a pfn to
> a guest.
>
> Andy's DMA example brings up a very good point though.  If the shared and private
> variants of a given GPA are _not_ required to point at a single PFN, which is the
> case in the current unmapping proposal, userspace doesn't need to do any additional
> juggling to track guest conversions across multiple processes.
>
> Any process that's accessing guest (shared!) memory simply does its locking as normal,
> which as Andy pointed out, is needed for correctness today.  If the guest requests a
> conversion from shared=>private without first ensuring the gfn is unused (by a host
> "device"), the host will side will continue accessing the old, shared memory, which it
> locked, while the guest will be doing who knows what.  And if the guest provides a GPA
> that isn't mapped shared in the VMM's address space, it's conceptually no different
> than if the guest provided a completely bogus GPA, which again needs to be handled today.
>
> In other words, if done properly, differentiating private from shared shouldn't be a
> heavy lift for host userspace.
>
> [*] Actually unmapping memory may not be strictly necessary for SNP because a
>     #PF(RMP) is likely just as good as a #PF(!PRESENT) when both are treated as
>     fatal, but the rest of the proposal that allows KVM to understand the stage
>     of a page and exit to userspace accordingly applies.

Thanks for this explanation. When you write "while the guest will be
doing who knows what":

Isn't that a large weakness of this proposal? To me, it seems better
for debuggability to corrupt the private memory (i.e., convert the
page to shared) so the guest can detect the issue via a PVALIDATE
failure.

The main issue I see with corrupting the guest memory is that we may
not know whether the host is at fault or the guest. Though, we can
probably in many cases be sure it's the host, if the pid associated
with the page fault is NOT a process associated with virtualization.
But if it is a process associated with virtualization, we legitimately
might not know. (I think if the pid is the kernel itself, it's
probably a host-side bug, but I'm still not confident on this; for
example, the guest might be able to coerce KVM's built-in emulator to
write guest private memory.)
