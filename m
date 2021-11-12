Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7055D44EFC9
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 23:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhKLW5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 17:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhKLW5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 17:57:14 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7852C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 14:54:22 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id k37so25893016lfv.3
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 14:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3NQdFGcDVG2JjfnOpdeoQHmcElnD9tk5T9TB7oLbDK4=;
        b=r3dDCXEZkM+k571XU2EKqa8ZvMbUOqLaG1ZtJYrepKQf1i4VLU14Meciy3mRyhJeG7
         LND2XIG9Sn7tH7eOksKceNqEl33+9Z3Hie5MLtCFe3USQ58kEJQRO+TOnK2fLyei96CS
         2GpIhnPedfVj1vjes0bI3QKfemARHgiAd9apcHUetJ0YZNaxNeOMo6oFY6YfQ7sisleU
         Bqzc1xTxUDDZQ3xMSeu596xH9bM60Q80ut4BDpwGFdNul8WE6p+5v0rR7Vc9d5q/i6Dz
         ON9huOgL4kbnru8b17TxqW1+yOokAZC4L647o37nuR9pCz5XCSGhNWqjSjddfDfAxuEX
         ZH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3NQdFGcDVG2JjfnOpdeoQHmcElnD9tk5T9TB7oLbDK4=;
        b=3MW0Vm8PN2ItUfK1f6IgBemxtDM85wXr/6gq7BveUwy0wU1addYAbedxKH+QJ+nJGe
         KF4I/tOgJRxIlloNzNEgHyhW5t4Z5lkkV3oiF/aG16Fq8JBMdD3XVEi0c/AzFzY7lQaI
         kg/a5AVZDGBLEXscNdVGqeBb3tdtCpCw+Pt83xkatINuMAJ2xhdArj3j1aa4UFO9H1IP
         3YtzFWj2O3RN1Qpz8aM/Zh8SIqSTGmx2+4cgudXnwUZfH5MkbxJ5k+0t9gELgv1ZFOKy
         Qz2VWerNYzSqC7CgTlnMSrtapS3lfb8YBkEVLPaOWHbcUr2uJU9g0T/7mvNO7DEY91Y6
         oECw==
X-Gm-Message-State: AOAM5321ylVSmJn56zsRZbLxedWrDtmilo5mpe4VjlgX0SmWO55jd1sw
        y7m5TpzMDTV497dbltlRUz+1JXfQCb+WtJwN3tz2Cw==
X-Google-Smtp-Source: ABdhPJynmFltlI6U1GhsgqUrEbW7pfoilOaw0qhDblA/+afTrHXkohHbxH17eNpN4smESxrgB/7qd3uMp8uwDBdwFok=
X-Received: by 2002:a19:7902:: with SMTP id u2mr17022058lfc.644.1636757660891;
 Fri, 12 Nov 2021 14:54:20 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
 <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com> <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
In-Reply-To: <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 12 Nov 2021 15:54:09 -0700
Message-ID: <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Marc Orr <marcorr@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 2:43 PM Marc Orr <marcorr@google.com> wrote:
>
> On Fri, Nov 12, 2021 at 1:39 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> >
> >
> > On Fri, Nov 12, 2021, at 1:30 PM, Marc Orr wrote:
> > > On Fri, Nov 12, 2021 at 12:38 PM Sean Christopherson <seanjc@google.c=
om> wrote:
> > >>
> > >> On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > >> > On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrot=
e:
> > >> > > Yes, but IMO inducing a fault in the guest because of _host_ bug=
 is wrong.
> > >> >
> > >> > What do you suggest instead?
> > >>
> > >> Let userspace decide what is mapped shared and what is mapped privat=
e.  The kernel
> > >> and KVM provide the APIs/infrastructure to do the actual conversions=
 in a thread-safe
> > >> fashion and also to enforce the current state, but userspace is the =
control plane.
> > >>
> > >> It would require non-trivial changes in userspace if there are multi=
ple processes
> > >> accessing guest memory, e.g. Peter's networking daemon example, but =
it _is_ fully
> > >> solvable.  The exit to userspace means all three components (guest, =
kernel,
> > >> and userspace) have full knowledge of what is shared and what is pri=
vate.  There
> > >> is zero ambiguity:
> > >>
> > >>   - if userspace accesses guest private memory, it gets SIGSEGV or w=
hatever.
> > >>   - if kernel accesses guest private memory, it does BUG/panic/oops[=
*]
> > >>   - if guest accesses memory with the incorrect C/SHARED-bit, it get=
s killed.
> > >>
> > >> This is the direction KVM TDX support is headed, though it's obvious=
ly still a WIP.
> > >>
> > >> And ideally, to avoid implicit conversions at any level, hardware ve=
ndors' ABIs
> > >> define that:
> > >>
> > >>   a) All convertible memory, i.e. RAM, starts as private.
> > >>   b) Conversions between private and shared must be done via explici=
t hypercall.
> > >>
> > >> Without (b), userspace and thus KVM have to treat guest accesses to =
the incorrect
> > >> type as implicit conversions.
> > >>
> > >> [*] Sadly, fully preventing kernel access to guest private is not po=
ssible with
> > >>     TDX, especially if the direct map is left intact.  But maybe in =
the future
> > >>     TDX will signal a fault instead of poisoning memory and leaving =
a #MC mine.
> > >
> > > In this proposal, consider a guest driver instructing a device to DMA
> > > write a 1 GB memory buffer. A well-behaved guest driver will ensure
> > > that the entire 1 GB is marked shared. But what about a malicious or
> > > buggy guest? Let's assume a bad guest driver instructs the device to
> > > write guest private memory.
> > >
> > > So now, the virtual device, which might be implemented as some host
> > > side process, needs to (1) check and lock all 4k constituent RMP
> > > entries (so they're not converted to private while the DMA write is
> > > taking palce), (2) write the 1 GB buffer, and (3) unlock all 4 k
> > > constituent RMP entries? If I'm understanding this correctly, then th=
e
> > > synchronization will be prohibitively expensive.
> >
> > Let's consider a very very similar scenario: consider a guest driver se=
tting up a 1 GB DMA buffer.  The virtual device, implemented as host proces=
s, needs to (1) map (and thus lock *or* be prepared for faults) in 1GB / 4k=
 pages of guest memory (so they're not *freed* while the DMA write is takin=
g place), (2) write the buffer, and (3) unlock all the pages.  Or it can lo=
ck them at setup time and keep them locked for a long time if that's approp=
riate.
> >
> > Sure, the locking is expensive, but it's nonnegotiable.  The RMP issue =
is just a special case of the more general issue that the host MUST NOT ACC=
ESS GUEST MEMORY AFTER IT'S FREED.
>
> Good point.

Thanks for the responses Andy.

Having a way for userspace to lock pages as shared was an idea I just
proposed the simplest solution to start the conversation. So what we
could do here is change map to error if the selected region has
private pages, if the region is mapped we can then lock the pages
shared. Now processes mapping guest memory that are well behaved can
be safe from RMP violations. That seems like a reasonable solution for
allowing userspace to know if guest memory is accessible or not. Or do
you have other ideas to meet your other comment:

> SEV-SNP, TDX, and any reasonable software solution all require that the
> host know which pages are private and which pages are shared.  Sure, the
> old SEV-ES Linux host implementation was very simple, but it's nasty and
> fundamentally can't support migration.
