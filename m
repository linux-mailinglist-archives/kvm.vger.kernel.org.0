Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87E044EFC4
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 23:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhKLWzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 17:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKLWzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 17:55:12 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35759C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 14:52:21 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 13so21300763ljj.11
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 14:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L1s7nGnIB6dCuNnJNcZoNuqcA33irHKpUPtWeo73UTs=;
        b=Cqy5Q2B+LRePZFM4vHFSsphNhsx+o4PJDz6vJoauCIPzsQ9rFcJmRRC/xYKxYK/w8T
         bwVtnDMWLHpYbCBMIvGopLjmi9f3BtRB1WgPSuRDa+HK8Gagemb2hrF9WkNeHzux5W8e
         D1ceqKCbiwTNkwe2CqsD0NwjIHFJzWWexD4Lj1V7Jkpx4bgExYK/X68EQbkjrscDgaN0
         RQi6E3XFg9FPGTwVfWOvewLby+XaMnUreGEUfKziX/1yAtAeFjkLJNInexb8CTrmaF6k
         yX3LwVs1PLNXHApiIYvUmETHggkQjR4e/t5Mn/CHWK4Xa40S1eDd0URcoBn8qd7HZHso
         2uWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L1s7nGnIB6dCuNnJNcZoNuqcA33irHKpUPtWeo73UTs=;
        b=AWybVY4cXzEK+LXrNsW4nR/1TtVVJ4MXLkNKxosQ7GjDyi5zEVkNYDB0UM5xkDKcou
         xdTwTyZg9RQmKm1TVpKuAKcQFiLnXdNAR0+iwD5NA/zG0fxXCr2JFCabzM51ySDmmCXc
         gJSQXmAJ0zEeU2X8JPcDhlbHCDGbyuG/a7JSnc1/J9QaH12MtdwBuVmOGXpeYM3/gXrZ
         a7PFqVhx+yOL+NR0tA0j/h1Q00DpeHhQVlxPTcs2a3qCLmvbf5U/4CDs+ig7qhENPF7T
         /yyyBG3Ubfv5jt7IkapN4q9Mz7FZgeI5vc13VVTiAMANFNBPiL9R6xpGcnhnvXso02Fl
         0HKw==
X-Gm-Message-State: AOAM533FDDHX793UvrihcHlGFnSyAd1skgJd7QkrWKHPnJ6kLHGVNJEW
        4XybChS+dwKb5420HeMXc+HFZxhGNTqkoEEKhWGaNg==
X-Google-Smtp-Source: ABdhPJwwj5eGIKGYjmRmsUFldnSDs9DQ6xXnmwrqEsL/v24xHmIJ6wJBmrxxQ3u5Hxb9Lr//K3USh5BilC/M4RbFliU=
X-Received: by 2002:a2e:b013:: with SMTP id y19mr18569459ljk.132.1636757539156;
 Fri, 12 Nov 2021 14:52:19 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
 <YY7USItsMPNbuSSG@zn.tnic> <CAMkAt6o909yYq3NfRboF3U3V8k-2XGb9p_WcQuvSjOKokmMzMA@mail.gmail.com>
 <869622df-5bf6-0fbb-cac4-34c6ae7df119@kernel.org>
In-Reply-To: <869622df-5bf6-0fbb-cac4-34c6ae7df119@kernel.org>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 12 Nov 2021 15:52:07 -0700
Message-ID: <CAMkAt6rCgK9=rPe7DyPaoNYW-c8uk0YGeCKLAPR-aHe4x7GviA@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 2:20 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On 11/12/21 13:12, Peter Gonda wrote:
> > On Fri, Nov 12, 2021 at 1:55 PM Borislav Petkov <bp@alien8.de> wrote:
> >>
> >> On Fri, Nov 12, 2021 at 08:37:59PM +0000, Sean Christopherson wrote:
> >>> Let userspace decide what is mapped shared and what is mapped private.
> >>
> >> With "userspace", you mean the *host* userspace?
> >>
> >>> The kernel and KVM provide the APIs/infrastructure to do the actual
> >>> conversions in a thread-safe fashion and also to enforce the current
> >>> state, but userspace is the control plane.
> >>>
> >>> It would require non-trivial changes in userspace if there are multiple processes
> >>> accessing guest memory, e.g. Peter's networking daemon example, but it _is_ fully
> >>> solvable.  The exit to userspace means all three components (guest, kernel,
> >>> and userspace) have full knowledge of what is shared and what is private.  There
> >>> is zero ambiguity:
> >>>
> >>>    - if userspace accesses guest private memory, it gets SIGSEGV or whatever.
> >>
> >> That SIGSEGV is generated by the host kernel, I presume, after it checks
> >> whether the memory belongs to the guest?
> >>
> >>>    - if kernel accesses guest private memory, it does BUG/panic/oops[*]
> >>
> >> If *it* is the host kernel, then you probably shouldn't do that -
> >> otherwise you just killed the host kernel on which all those guests are
> >> running.
> >
> > I agree, it seems better to terminate the single guest with an issue.
> > Rather than killing the host (and therefore all guests). So I'd
> > suggest even in this case we do the 'convert to shared' approach or
> > just outright terminate the guest.
> >
> > Are there already examples in KVM of a KVM bug in servicing a VM's
> > request results in a BUG/panic/oops? That seems not ideal ever.
> >
> >>
> >>>    - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.
> >>
> >> Yah, that's the easy one.
> >>
> >>> This is the direction KVM TDX support is headed, though it's obviously still a WIP.
> >>>
> >>> And ideally, to avoid implicit conversions at any level, hardware vendors' ABIs
> >>> define that:
> >>>
> >>>    a) All convertible memory, i.e. RAM, starts as private.
> >>>    b) Conversions between private and shared must be done via explicit hypercall.
> >>
> >> I like the explicit nature of this but devil's in the detail and I'm no
> >> virt guy...
> >
> > This seems like a reasonable approach that can help with the issue of
> > terminating the entity behaving poorly. Could this feature be an
> > improvement that comes later? This improvement could be gated behind a
> > per VM KVM CAP, a kvm module param, or insert other solution here, to
> > not blind side userspace with this change?
> >
> >>
> >>> Without (b), userspace and thus KVM have to treat guest accesses to the incorrect
> >>> type as implicit conversions.
> >>>
> >>> [*] Sadly, fully preventing kernel access to guest private is not possible with
> >>>      TDX, especially if the direct map is left intact.  But maybe in the future
> >>>      TDX will signal a fault instead of poisoning memory and leaving a #MC mine.
> >>
> >> Yah, the #MC thing sounds like someone didn't think things through. ;-\
> >
> > Yes #MC in TDX seems much harder to deal with than the #PF for SNP.
> > I'd propose TDX keeps the host kernel safe bug not have that solution
> > block SNP. As suggested above I like the idea but it seems like it can
> > come as a future improvement to SNP support.
> >
>
> Can you clarify what type of host bug you're talking about here?  We're
> talking about the host kernel reading or writing guest private memory
> through the direct map or kmap, right?  It seems to me that the way this
> happens is:

An example bug I am discussing looks like this:
* Guest wants to use virt device on some shared memory.
* Guest forgets to ask host to RMPUPDATE page to shared state (hypervisor owned)
* Guest points virt device at pages
* Virt device writes to page, since they are still private guest
userspace causes RMP fault #PF.

This seems like a trivial attack malicious guests could do.

>
> struct page *guest_page = (get and refcount a guest page);
>
> ...
>
> guest switches the page to private;
>
> ...
>
> read or write the page via direct map or kmap.
>
>
> This naively *looks* like something a malicious or buggy guest could
> induce the host kernel to do.  But I think that, if this actually
> occurs, it's an example of a much more severe host bug.  In particular,
> there is nothing special about the guest switching a page to private --
> the guest or QEMU could just as easily have freed (hotunplugged) a
> shared guest page or ballooned it or swapped it or otherwise deallocated
> it.  And, if the host touches a page/pfn that the guest has freed, this
> is UAF, is a huge security hole if the guest has any degree of control,
> and needs to kill the host kernel if detected.
>
> Now we can kind of sweep it under the rug by saying that changing a page
> from shared to private isn't really freeing the page -- it's just
> modifying the usage of the page.  But to me that sounds like saying
> "reusing a former user memory page as a pagetable isn't *really* freeing
> it if the kernel kept a pointer around the whole time and the page
> allocator wasn't involved".

This is different from the QEMU hotunplug because in that case QEMU is
aware of the memory change. Currently QEMU (userspace) is completely
unaware of which pages are shared and which are private. So how does
userspace know the  memory has been "freed"?

>
> So let's please just consider these mode transitions to be equivalent to
> actually freeing the page at least from a locking perspective, and then
> the way to prevent these bugs and the correct action to take if they
> occur is clear.
>
> (On TDX, changing a page shared/private state is very much like freeing
> and reallocating -- they're in different page tables and, in principle
> anyway, there is no actual relationship between a shared page and a
> supposedly matching private page except that some bits of the GPA happen
> to match.  The hardware the TD module fully support both being mapped at
> once at the same "address", at least according to the specs I've read.)
>
> --Andy
