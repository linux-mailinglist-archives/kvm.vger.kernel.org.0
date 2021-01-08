Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1612EEA9B
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 01:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbhAHA4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 19:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729503AbhAHA4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 19:56:06 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659FBC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 16:55:26 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id 75so8620478ilv.13
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 16:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZnmKthVAiWe8sv/LE5kigV4DNRxPV19TU/ErS22n0DQ=;
        b=dRLEWSZMWtVoapId8WgxnfcKOoxNgQwuZH0bcsnEsF7HSicoRYX90rKqfJzqCugeXB
         gl7ndP2fCPtrXA7FIU72leIxtzig6zMYsqoRPoNmiXz3hWtFReoKM2xvPnMW0ITgFIvY
         e5hl+GAd117Up9s7bkcKQRq7lMjsZvsdD7BZvWRVvnXQKLCOBwPVKHVDrkpFWiKK60hE
         mzKjxu9U9eyJI5D5dsFNADAq1rhUNnWLK1r9FYTYFdppQX3f1HJAzrpmE4VgbGymJAEX
         Uw7ATDH6aGbLxns+cV6w28cnttPozgD3Lvj/VHMevrDUhPalrmRLbdOt6mWSNvWAUiCP
         ynVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZnmKthVAiWe8sv/LE5kigV4DNRxPV19TU/ErS22n0DQ=;
        b=GlituxiA8tL2wLifvLzvf/kXWQcBqV/S5kUFnudgUhHTr/JqMmpsb0r87grs/ujzQS
         rw7+DPnNjB2ROMCW7NWKlRWdTPztB70ajkNi3gAUKkK2dGK/waa1WP8A4wlpLaSwuNFj
         6Ns8I6LW8pwVRZVgz3r/5RC2PzrqMxAi24+VmawkOFdUM3NGk1vaKXulRwAgy2rQd6xC
         ZFaRmJVDuEIA01aTtNyHuu79WmhdzljC/AjeUhI7WheKgMvBWSmnfGh3VWwu9yDVW612
         Jg/rCNhFkkkMaOeNtX6LqAMb3Z20ekwfwoyomYhpc6vw59pbQOfU4pl40vahd+vv4VCw
         Io9g==
X-Gm-Message-State: AOAM532oJt6Qx9gOHmgy0VKOgEyQS3umd9nWxEEbAfjviSv6TVuSssSM
        jkOc2Vp/uWjAZzFuofww+9lZvAgCfO5T/scc0kvLEA==
X-Google-Smtp-Source: ABdhPJxksTzeBMfDEYbJ70Yf0HqsQyioNATCP8ATBuBwX7pFaFopyKgoNEOnaRvhFIc7WyzoZ7pjebxjukxrGC0zgjY=
X-Received: by 2002:a92:400a:: with SMTP id n10mr1578986ila.212.1610067325502;
 Thu, 07 Jan 2021 16:55:25 -0800 (PST)
MIME-Version: 1.0
References: <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server> <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com> <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server> <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
 <20210107170728.GA16965@ashkalra_ubuntu_server> <X/dEQRZpSb+oQloX@google.com>
 <20210107184125.GA17388@ashkalra_ubuntu_server> <X/dfjElmMpiEvr9B@google.com>
In-Reply-To: <X/dfjElmMpiEvr9B@google.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 7 Jan 2021 16:54:49 -0800
Message-ID: <CABayD+fHUSVCQP7muax5E-ZbAVMt0g1vXYjtJ22+m_+Y5SE=2Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>,
        "Grimm, Jon" <jon.grimm@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Supporting merging of consecutive entries (or not) is less important
to get right since it doesn't change any of the APIs. If someone runs
into performance issues, they can loop back and fix this then. I'm
slightly concerned with the behavior for overlapping regions. I also
have slight concerns with how we handle re-encrypting small chunks of
larger unencrypted regions. I don't think we've seen these in
practice, but nothing precludes them afaik.

On Thu, Jan 7, 2021 at 11:23 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jan 07, 2021, Ashish Kalra wrote:
> > On Thu, Jan 07, 2021 at 09:26:25AM -0800, Sean Christopherson wrote:
> > > On Thu, Jan 07, 2021, Ashish Kalra wrote:
> > > > Hello Steve,
> > > >
> > > > On Wed, Jan 06, 2021 at 05:01:33PM -0800, Steve Rutherford wrote:
> > > > > Avoiding an rbtree for such a small (but unstable) list seems correct.
> > > > >
> > > > > For the unencrypted region list strategy, the only questions that I
> > > > > have are fairly secondary.
> > > > > - How should the kernel upper bound the size of the list in the face
> > > > > of malicious guests, but still support large guests? (Something
> > > > > similar to the size provided in the bitmap API would work).
> > > >
> > > > I am thinking of another scenario, where a malicious guest can make
> > > > infinite/repetetive hypercalls and DOS attack the host.
> > > >
> > > > But probably this is a more generic issue, this can be done by any guest
> > > > and under any hypervisor, i don't know what kind of mitigations exist
> > > > for such a scenario ?
> > > >
> > > > Potentially, the guest memory donation model can handle such an attack,
> > > > because in this model, the hypervisor will expect only one hypercall,
> > > > any repetetive hypercalls can make the hypervisor disable the guest ?
> > >
> > > KVM doesn't need to explicitly bound its tracking structures, it just needs to
> > > use GFP_KERNEL_ACCOUNT when allocating kernel memory for the structures so that
> > > the memory will be accounted to the task/process/VM.  Shadow MMU pages are the
> > > only exception that comes to mind; they're still accounted properly, but KVM
> > > also explicitly limits them for a variety of reasons.
> > >
> > > The size of the list will naturally be bounded by the size of the guest; and
> > > assuming KVM proactively merges adjancent regions, that upper bound is probably
> > > reasonably low compared to other allocations, e.g. the aforementioned MMU pages.
> > >
> > > And, using a list means a malicious guest will get automatically throttled as
> > > the latency of walking the list (to merge/delete existing entries) will increase
> > > with the size of the list.
> >
> > Just to add here, potentially there won't be any proactive
> > merging/deletion of existing entries, as the only static entries will be
> > initial guest MMIO regions, which are contigious guest PA ranges but not
> > necessarily adjacent.
>
> My point was that, if the guest is malicious, eventually there will be adjacent
> entries, e.g. the worst case scenario is that the encrypted status changes on
> every 4k page.  Anyways, not really all that important, I mostly thinking out
> loud :-)

Agreed. Tagging this with GFP_KERNEL_ACCOUNT means we don't need to
upper bound the number of pages. I now don't think there is any
unusual DoS potential here. Perhaps, if the guest tries really hard to
make a massive list, they could get a softlockup on the host. Not sure
how important that is to fix.
