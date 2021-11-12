Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0E744EEC6
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 22:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbhKLVqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 16:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbhKLVqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 16:46:16 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09984C061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 13:43:25 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id bf8so20340200oib.6
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 13:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p6BJgAR2dKpdI5PQSFC6gOgUXqAUQZJtadmObr7tjTY=;
        b=AnRQXnEvNzvr8lmbdoVBi472Kzz/I2xvy53cquSxtFszpAe3zph3LuOPEc5/48deXh
         xzvEzM60QjlA+Vpeqcr5k2Xs9hIpwxJHjlaBy+UJ+tVrUBkcD59RCdQ+/DT38Ot+4p9h
         v0AIhXq1nE9873XX18Cuk0CjaQh/m87fMJI7jgMcSqhzslXXtaw6E3pz1r6NeJVqvqhN
         K7/P/WRPlJwR11gNsOk5JE/VBsulqTP5MhsyHwJIlWm8Cg31Kz6C4pLrDMcWcLhAv+2h
         1h3Rk1x09vCadHQBu9BU9p2uxYWPHVizVC0N06lkIufqe7Tq8CJVeVZLg5AIwOIU7Q0y
         7plA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p6BJgAR2dKpdI5PQSFC6gOgUXqAUQZJtadmObr7tjTY=;
        b=Qd7KYpQNrRF2W5rlITiY2DXIAkDLE5vfLUcAh1VWxNUfRFthlVUZZxnuDXZ2qR7Rb+
         GYq1Kc6brkyDVbZ2p3Lpt1sj9UlA4RoaI2GkkvXBE/Pyyw8p115blKzBip1vlnv8DJlr
         Qw1vZbZV/0pKEGqCpTGbGtF0uPkcj5tnMQmOvKA9XDsMWBQa9+WxYux/5UjHnXdkszzh
         R9YFhjphbMh8q/gpo2fMbWLzJP8jL40D3/d4XMLATb/BzUMPXXClphV2R9e+g/1x35Fa
         9kczPEXSuGCl5CZU9LAlM6GXfiOVZUX7YoQkDF8+dIxbUzFi7H/Ccn32o1lYjZcV04BI
         zzGw==
X-Gm-Message-State: AOAM530ziRoKJRKdDKqtetg0mgOPxo5bHpu/YiLcHsML3pPsysHw6ZMF
        1yHPPujpUo221eiGdn9zydD2etL+WiSY4X/hJ5F34w==
X-Google-Smtp-Source: ABdhPJwN1DMFj8lwZlramd1I0OGWe2kSl7QSbL+hhwnl5gfxV3O28d9EPTR8alNht5b3hCsOpj1PmUPMkqmyQaJMInE=
X-Received: by 2002:aca:2319:: with SMTP id e25mr28956699oie.164.1636753404063;
 Fri, 12 Nov 2021 13:43:24 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com> <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com>
In-Reply-To: <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 12 Nov 2021 13:43:13 -0800
Message-ID: <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 1:39 PM Andy Lutomirski <luto@kernel.org> wrote:
>
>
>
> On Fri, Nov 12, 2021, at 1:30 PM, Marc Orr wrote:
> > On Fri, Nov 12, 2021 at 12:38 PM Sean Christopherson <seanjc@google.com=
> wrote:
> >>
> >> On Fri, Nov 12, 2021, Borislav Petkov wrote:
> >> > On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrote:
> >> > > Yes, but IMO inducing a fault in the guest because of _host_ bug i=
s wrong.
> >> >
> >> > What do you suggest instead?
> >>
> >> Let userspace decide what is mapped shared and what is mapped private.=
  The kernel
> >> and KVM provide the APIs/infrastructure to do the actual conversions i=
n a thread-safe
> >> fashion and also to enforce the current state, but userspace is the co=
ntrol plane.
> >>
> >> It would require non-trivial changes in userspace if there are multipl=
e processes
> >> accessing guest memory, e.g. Peter's networking daemon example, but it=
 _is_ fully
> >> solvable.  The exit to userspace means all three components (guest, ke=
rnel,
> >> and userspace) have full knowledge of what is shared and what is priva=
te.  There
> >> is zero ambiguity:
> >>
> >>   - if userspace accesses guest private memory, it gets SIGSEGV or wha=
tever.
> >>   - if kernel accesses guest private memory, it does BUG/panic/oops[*]
> >>   - if guest accesses memory with the incorrect C/SHARED-bit, it gets =
killed.
> >>
> >> This is the direction KVM TDX support is headed, though it's obviously=
 still a WIP.
> >>
> >> And ideally, to avoid implicit conversions at any level, hardware vend=
ors' ABIs
> >> define that:
> >>
> >>   a) All convertible memory, i.e. RAM, starts as private.
> >>   b) Conversions between private and shared must be done via explicit =
hypercall.
> >>
> >> Without (b), userspace and thus KVM have to treat guest accesses to th=
e incorrect
> >> type as implicit conversions.
> >>
> >> [*] Sadly, fully preventing kernel access to guest private is not poss=
ible with
> >>     TDX, especially if the direct map is left intact.  But maybe in th=
e future
> >>     TDX will signal a fault instead of poisoning memory and leaving a =
#MC mine.
> >
> > In this proposal, consider a guest driver instructing a device to DMA
> > write a 1 GB memory buffer. A well-behaved guest driver will ensure
> > that the entire 1 GB is marked shared. But what about a malicious or
> > buggy guest? Let's assume a bad guest driver instructs the device to
> > write guest private memory.
> >
> > So now, the virtual device, which might be implemented as some host
> > side process, needs to (1) check and lock all 4k constituent RMP
> > entries (so they're not converted to private while the DMA write is
> > taking palce), (2) write the 1 GB buffer, and (3) unlock all 4 k
> > constituent RMP entries? If I'm understanding this correctly, then the
> > synchronization will be prohibitively expensive.
>
> Let's consider a very very similar scenario: consider a guest driver sett=
ing up a 1 GB DMA buffer.  The virtual device, implemented as host process,=
 needs to (1) map (and thus lock *or* be prepared for faults) in 1GB / 4k p=
ages of guest memory (so they're not *freed* while the DMA write is taking =
place), (2) write the buffer, and (3) unlock all the pages.  Or it can lock=
 them at setup time and keep them locked for a long time if that's appropri=
ate.
>
> Sure, the locking is expensive, but it's nonnegotiable.  The RMP issue is=
 just a special case of the more general issue that the host MUST NOT ACCES=
S GUEST MEMORY AFTER IT'S FREED.

Good point.
