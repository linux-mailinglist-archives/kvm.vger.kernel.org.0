Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A0745158D
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbhKOUmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344947AbhKOTZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:47 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B88C09676A
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:41:27 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id s139so36643918oie.13
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DvmCs80nJQRJulfMPNgITfN/kpc9dv/WOKQeVjWwio4=;
        b=D2Mt+z865FvjQUumFXEdNURlsU2N9UC/MMmG8rlUqPypkNsBqmKRw0im+95vMwMZt+
         lOyHOqJBT2Wf61emETZgh/H8MwFKn+7mxNspVDUE3ab/thq8z8MqaNv5E3cFC88Dhb1D
         kozJOtu5iF3U6ReVV+IClUxB/KJuaaQOSaFzBpZV/RSinsd98IOm4cNGt+PpulbFPi4G
         fh0anmlEfno22cJKa2/xdP2buGHXZVvlyBs3T5g9PgR1ul84hlgBs7kIQv+hZicSWIx/
         DFY+BXoYlqwxk1FLb90BO7ox0VLE0OsYnIeGGKqSrw6S20pm4gRfEwAzqEUKSDwO5qAw
         9xyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DvmCs80nJQRJulfMPNgITfN/kpc9dv/WOKQeVjWwio4=;
        b=kJ9s00vL64SgzWHqQcxPT+SPcns8tTuwTpZLRq38RG9ra0+npn2oADlz6xu4yj6m+J
         OpIVkkSznaJuVgd4yVGTyrd1NL4YkRyhLBMFP99jehGx3WOjWeDI2ZLkEuPa3oSnS1e3
         jV4c1wqAvc3nlfOQxyDtINwhfEIDchkinvXqQbBml/KGd7p9ndpI4vr6Xehe7mhS94yM
         WBZFcidoM2BwyKI+kzwEp1SmwplZgr+Y6tGDSw6qvIBg2S9UjguojA532K3le6AOZkOO
         tyMlDUGgUCewV0o1MtMJq112b7iV0+uGtx1B6EjNhJ7zyG35TG2X092W5mY5g3hvX22v
         pZZg==
X-Gm-Message-State: AOAM5320NIjqm8Xd8GE6NK8iA2RtOFCjxxen+TMdwxrsRrNpoZr5Vwx+
        9djWbY+5lLKZ5Dp6u1tV4zR+GJcx7ettm1yaCxrxbw==
X-Google-Smtp-Source: ABdhPJw+kw8Q07aUefBFMr3P/o64UhYLq5zXtIiaN0731ps80GxSYVXnY4M15E2ojpsZr+HhuXIh46aqRnH7y2V4Jys=
X-Received: by 2002:a54:4515:: with SMTP id l21mr746806oil.15.1637001686230;
 Mon, 15 Nov 2021 10:41:26 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YZJTA1NyLCmVtGtY@work-vm> <YZKmSDQJgCcR06nE@google.com>
In-Reply-To: <YZKmSDQJgCcR06nE@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 15 Nov 2021 10:41:15 -0800
Message-ID: <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
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
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:26 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 15, 2021, Dr. David Alan Gilbert wrote:
> > * Sean Christopherson (seanjc@google.com) wrote:
> > > On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > > > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> > > > > Or, is there some mechanism that prevent guest-private memory from being
> > > > > accessed in random host kernel code?
> > >
> > > Or random host userspace code...
> > >
> > > > So I'm currently under the impression that random host->guest accesses
> > > > should not happen if not previously agreed upon by both.
> > >
> > > Key word "should".
> > >
> > > > Because, as explained on IRC, if host touches a private guest page,
> > > > whatever the host does to that page, the next time the guest runs, it'll
> > > > get a #VC where it will see that that page doesn't belong to it anymore
> > > > and then, out of paranoia, it will simply terminate to protect itself.
> > > >
> > > > So cloud providers should have an interest to prevent such random stray
> > > > accesses if they wanna have guests. :)
> > >
> > > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> >
> > Would it necessarily have been a host bug?  A guest telling the host a
> > bad GPA to DMA into would trigger this wouldn't it?
>
> No, because as Andy pointed out, host userspace must already guard against a bad
> GPA, i.e. this is just a variant of the guest telling the host to DMA to a GPA
> that is completely bogus.  The shared vs. private behavior just means that when
> host userspace is doing a GPA=>HVA lookup, it needs to incorporate the "shared"
> state of the GPA.  If the host goes and DMAs into the completely wrong HVA=>PFN,
> then that is a host bug; that the bug happened to be exploited by a buggy/malicious
> guest doesn't change the fact that the host messed up.

"If the host goes and DMAs into the completely wrong HVA=>PFN, then
that is a host bug; that the bug happened to be exploited by a
buggy/malicious guest doesn't change the fact that the host messed
up."
^^^
Again, I'm flabbergasted that you are arguing that it's OK for a guest
to exploit a host bug to take down host-side processes or the host
itself, either of which could bring down all other VMs on the machine.

I'm going to repeat -- this is not OK! Period.

Again, if the community wants to layer some orchestration scheme
between host userspace, host kernel, and guest, on top of the code to
inject the #VC into the guest, that's fine. This proposal is not
stopping that. In fact, the two approaches are completely orthogonal
and compatible.

But so far I have heard zero reasons why injecting a #VC into the
guest is wrong. Other than just stating that it's wrong.

Again, the guest must be able to detect buggy and malicious host-side
writes to private memory. Or else "confidential computing" doesn't
work. Assuming that's not true is not a valid argument to dismiss
injecting a #VC exception into the guest.
