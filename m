Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D075D1B2F16
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDUS2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgDUS2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:28:35 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D034AC0610D5
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 11:28:35 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p10so6494608ioh.7
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 11:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/3PsF04zrF6MzgGoqm//UZnOmmIVUYh6zinG2np9Tkc=;
        b=Up9A4X9f/2ssvYSgkgwRYrqYUSZgfF/Wy8rFyZ8zzGa4iuQu8wYnbzoVtprXdMoYp3
         J72ndGXpTr1H90AVhAOuKJ2+hA2xKGdDRgI1gvn7tyAQsykJM55rGOzbFXtAh1dIYdnD
         d1ikUTBcQx4DXn6zNKb11XR5w7zI6d32ZXtB/GScqlUeTgP7uf5umsJmw4IwxukLWxeW
         jHYZ4D7BW51SvUyLqyxlKQGrb81AwMohL+x6pREYN83GanpQeuvNnjErzDpVg7/sOr2r
         keGz+z7Sk5w90Ns78Or8ULZoObX4CswsOPl2dbgMwpp1x/6btzHdtE2TY7jb7HXas52c
         5poA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/3PsF04zrF6MzgGoqm//UZnOmmIVUYh6zinG2np9Tkc=;
        b=IC8y8BTl8K1mU91XHz9g9hzWGiMWcj0lu3IC/H1FUodhW/2PssfTTu/CHVCzj3a5jj
         wcged7r18cCJNAr0/AA8GRqsYSI5ywTrjsg3eMcDoGs0LOzHdrlrRY36bYJ0A2U52AXb
         UP4WaTH3Jh9jPdldKmQyoKvUEuqiCXHjy2lHxlSFM0kInm3aCCyj/9rsMWeoANZE1aBf
         3ZUUbeVaKNFYVlxAKmD97Es5AWnDD0zJ2DCM6ZDYHBoiA34gD/JAMmwSFS/6VTr/jEEv
         obtYXAtH0cra8TdPX3lwLMDICVJ249rn1ofiD8IiFsIdc9Qh7Zz9yeavRrwwCinuZFMP
         tZdA==
X-Gm-Message-State: AGi0PuZ1MgVz1z0X+NBL0C+L0ee+KwGLKq3XS/4y4vOQaaOm5TFEzVND
        ePMewMI8rktmxFW9Ts+Cbz5ZofVGQlHUTEd2UY/HWAcOWso=
X-Google-Smtp-Source: APiQypLs4ETqzfUxQvuUH5vB4LU+b8jMrCZcRp4UJDsZHDbHGm6ZW59w3yfO8npZCJbLMPE9wJRg+mwoEOv7A0KpR6Y=
X-Received: by 2002:a6b:c408:: with SMTP id y8mr21852320ioa.12.1587493714850;
 Tue, 21 Apr 2020 11:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200414000946.47396-1-jmattson@google.com> <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com> <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com> <CALMp9eS-s5doptTzVkE2o9jDYuGU3T=5azMhm3fCqLJPcABAOg@mail.gmail.com>
 <20200418042108.GF15609@linux.intel.com> <CALMp9eQpwnhD7H3a9wC=TnL3=OKmvHAmVFj=r9OBaWiBEGhR4Q@mail.gmail.com>
 <20200421044141.GE11134@linux.intel.com>
In-Reply-To: <20200421044141.GE11134@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 21 Apr 2020 11:28:23 -0700
Message-ID: <CALMp9eST-Fpbsg_x5exDxdAC-S+ekk+smyx5e0ymDqHLi-y8xQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 20, 2020 at 9:41 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Apr 20, 2020 at 10:18:42AM -0700, Jim Mattson wrote:
> > On Fri, Apr 17, 2020 at 9:21 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Wed, Apr 15, 2020 at 04:33:31PM -0700, Jim Mattson wrote:
> > > > On Tue, Apr 14, 2020 at 5:12 PM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > > >
> > > > > On Tue, Apr 14, 2020 at 09:47:53AM -0700, Jim Mattson wrote:
> > > > Yes, it's wrong in the abstract, but with respect to faults and the
> > > > VMX-preemption timer expiration, is there any way for either L1 or L2
> > > > to *know* that the virtual CPU has done something wrong?
> > >
> > > I don't think so?  But how is that relevant, i.e. if we can fix KVM instead
> > > of fudging the result, why wouldn't we fix KVM?
> >
> > I'm not sure that I can fix KVM. The missing #DB traps were relatively
> > straightforward, but as for the rest of this mess...
> >
> > Since you seem to have a handle on what needs to be done, I will defer to
> > you.
>
> I wouldn't go so far as to say I have a handle on it, more like I have an
> idea of how to fix one part of the overall problem with a generic "rule"
> change that also happens to (hopefully) resolve the #DB+MTF issue.
>
> Anyways, I'll send a patch.  Worst case scenario it fails miserably and we
> go with this patch :-)
>
> > > > Isn't it generally true that if you have an exception queued when you
> > > > transition from L2 to L1, then you've done something wrong? I wonder
> > > > if the call to kvm_clear_exception_queue() in prepare_vmcs12() just
> > > > serves to sweep a whole collection of problems under the rug.
> > >
> > > More than likely, yes.
> > >
> > > > > In general, interception of an event doesn't change the priority of events,
> > > > > e.g. INTR shouldn't get priority over NMI just because if L1 wants to
> > > > > intercept INTR but not NMI.
> > > >
> > > > Yes, but that's a different problem altogether.
> > >
> > > But isn't the fix the same?  Stop processing events if a higher priority
> > > event is pending, regardless of whether the event exits to L1.
> >
> > That depends on how you see the scope of the problem. One could argue
> > that the fix for everything that is wrong with KVM is actually the
> > same: properly emulate the physical CPU.
>
> Heh, there is that.
>
> What I'm arguing is that we shouldn't throw in a workaround knowing that
> it's papering over the underlying issue.  Preserving event priority
> irrespective of VM-Exit behavior is different, in that while it may not
> resolve all issues that are being masked by kvm_clear_exception_queue(),
> the change itself is correct when viewed in a vacuum.

The more I look at that call to kvm_clear_exception_queue(), the more
convinced I am that it's wrong. The comment above it says:

/*
* Drop what we picked up for L2 via vmx_complete_interrupts. It is
* preserved above and would only end up incorrectly in L1.
*/

The first sentence is just wrong. Vmx_complete_interrupts may not be
where the NMI/exception/interrupt came from. And the second sentence
is not entirely true. Only *injected* events are "preserved above" (by
the call to vmcs12_save_pending_event). However,
kvm_clear_exception_queue zaps both injected events and pending
events. Moreover, vmcs12_save_pending_event "preserves" the event by
stashing it in the IDT-vectoring info field of vmcs12, even when the
current VM-exit (from L2 to L1) did not (and in some cases cannot)
occur during event delivery (e.g. VMX-preemption timer expired).
