Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7792507C4
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 20:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHXSeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 14:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHXSep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 14:34:45 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A3BC061573
        for <kvm@vger.kernel.org>; Mon, 24 Aug 2020 11:34:44 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id j19so2129189oor.2
        for <kvm@vger.kernel.org>; Mon, 24 Aug 2020 11:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ftDcadPZ+90zpG6SMikhbMveZ60yu7NIA4sBtLqsA8=;
        b=TkRdR9ozUEkkNul3+YvoCqKvXEjbTc1PG188nVBM3Fkk8wGLt9N68sLUMdpzKta7t8
         DIbfTHBzfgCwpYidFOR9rYPpSndEAawR0iuXiTrNcTeQmmKoF2M1jH8NZCZI3mf4CzFk
         TOoXTozAjsts9dhcjd4MB7qSZ+/NGlG5OvsJXDwDVxsPSjKOY4FrDHICnubNEX1jDXlt
         9bz5xfBQtRkMYqP1aVad195GtH8AXFO3cp15sTdhEXoa648dxB4gXcJ+lcYSzh4RGdRb
         GPHRQWz1swFPVzdVKc0Z6QKuV+j1QVN1YVvCEe/uvSadVbxGQpJGYWul10YyfgPXfGvT
         apkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ftDcadPZ+90zpG6SMikhbMveZ60yu7NIA4sBtLqsA8=;
        b=f29TdLpbU52ytNNE6UpDnvQ/7xKV/xt3xgXhUCXJEehOTOtcAnXEjUntfLIUy4b1fc
         wlzYexxJBZRz4SQjnILFJPm78NbwuMSdyJznYbHeHgVARl7qz96ZghXCrch+dXaDl5Gj
         zcKemAVlbtI4OFZOZb9bn8XnvMNFcDlVWdxdyI01QhWRB6zshblX13YZH62LcDGaAHdm
         RgX/obJU1PLKAaKbJ8ub6mH2iK5BDNBHWh/aForjzEevJSF0Y6u4eHCk2Mys4cAqUFb/
         67OWFZt5k1b4MjnVuAbbT1ql1kqDugClG68VlY1Mbq+37QU6hXfluNRBwkGvJiRk+LsC
         9r7w==
X-Gm-Message-State: AOAM532J52dVFp2KnS4lmJ2ooylqgU6Hoofl6s1ldSFAIEiII2VW5Xhm
        RxnNehwiajweJhR3/XaAMejIDRPCC7YxyDku5PSJfA==
X-Google-Smtp-Source: ABdhPJwtvesBMFQ7mP6f+hBOhW+1UDL8BuEJIFbtYIiC+TO/19qwdm04S6G0SHClSM5WrCPptEhGeCO386mGiQJ4Maw=
X-Received: by 2002:a4a:87c8:: with SMTP id c8mr4578139ooi.81.1598294083309;
 Mon, 24 Aug 2020 11:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-6-aaronlewis@google.com> <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
 <bd7c54ae-73d1-0200-fbe7-10c8df408f8b@amazon.com> <CALMp9eSXS+b62C-kXjwPBeYF36ajYeGg2kBmsubz9s5V6C-83A@mail.gmail.com>
 <CALMp9eTUV9Z7hL_qtdKYvqYmm8wT1_oGaRLp55i3ttg1qLyecQ@mail.gmail.com>
 <cf256ff0-8336-06fc-b475-8ca00782c4ce@amazon.com> <CALMp9eQd4cmK2_2oEnTX7VUEA0N9gsEkdpKhLyWpQzWCQm4w-w@mail.gmail.com>
 <8851792a-d9f2-fe0c-33e7-cae7f3bb3919@amazon.com>
In-Reply-To: <8851792a-d9f2-fe0c-33e7-cae7f3bb3919@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 Aug 2020 11:34:30 -0700
Message-ID: <CALMp9eT_ymfa3QtKp4BSh7LutVAydDxQSzwLTC=t-UB=RRX1iQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace
 on rdmsr or wrmsr
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 11:09 AM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 24.08.20 19:23, Jim Mattson wrote:
> >
> > On Sun, Aug 23, 2020 at 6:35 PM Alexander Graf <graf@amazon.com> wrote:
> >>
> >>
> >>
> >> On 21.08.20 19:58, Jim Mattson wrote:
> >>>
> >>> On Thu, Aug 20, 2020 at 3:55 PM Jim Mattson <jmattson@google.com> wrote:
> >>>>
> >>>> On Thu, Aug 20, 2020 at 2:59 PM Alexander Graf <graf@amazon.com> wrote:
> >>>>
> >>>>> Do we really need to do all of this dance of differentiating in kernel
> >>>>> space between an exit that's there because user space asked for the exit
> >>>>> and an MSR access that would just generate a #GP?
> >>>>>
> >>>>> At the end of the day, user space *knows* which MSRs it asked to
> >>>>> receive. It can filter for them super easily.
> >>>>
> >>>> If no one else has an opinion, I can let this go. :-)
> >>>>
> >>>> However, to make the right decision in kvm_emulate_{rdmsr,wrmsr}
> >>>> (without the unfortunate before and after checks that Aaron added),
> >>>> kvm_{get,set}_msr should at least distinguish between "permission
> >>>> denied" and "raise #GP," so I can provide a deny list without asking
> >>>> for userspace exits on #GP.
> >>>
> >>> Actually, I think this whole discussion is moot. You no longer need
> >>> the first ioctl (ask for a userspace exit on #GP). The allow/deny list
> >>> is sufficient. Moreover, the allow/deny list checks can be in
> >>> kvm_emulate_{rdmsr,wrmsr} before the call to kvm_{get,set}_msr, so we
> >>> needn't be concerned with distinguishable error values either.
> >>>
> >>
> >> I also care about cases where I allow in-kernel handling, but for
> >> whatever reason there still would be a #GP injected into the guest. I
> >> want to record those events and be able to later have data that tell me
> >> why something went wrong.
> >>
> >> So yes, for your use case you do not care about the distinction between
> >> "deny MSR access" and "report invalid MSR access". However, I do care :).
> >
> > In that case, I'm going to continue to hold a hard line on the
> > distinction between a #GP for an invalid MSR access and the #GP for an
> > unknown MSR. If, for instance, you wanted to implement ignore_msrs in
> > userspace, as you've proposed in the past, this would be extremely
> > helpful. Without it, userspace gets an exit because (1) the MSR access
> > isn't in the allow list, (2) the MSR access is invalid, or (3) the MSR
> > is unknown to kvm. As you've pointed out, it is easy for userspace to
> > distinguish (1) from the others, since it provided the allow/deny list
> > in the first place. But how do you distinguish (2) from (3) without
> > replicating the logic in the kernel?
> >
> >> My stance on this is again that it's trivial to handle a few invalid MSR
> >> #GPs from user space and just not report anything. It should come at
> >> almost negligible performance cost, no?
> >
> > Yes, the performance cost should be negligible, but what is the point?
> > We're trying to design a good API here, aren't we?
> >
> >> As for your argumentation above, we have a second call chain into
> >> kvm_{get,set}_msr from the x86 emulator which you'd also need to cover.
> >>
> >> One thing we could do I guess is to add a parameter to ENABLE_CAP on
> >> KVM_CAP_X86_USER_SPACE_MSR so that it only bounces on certain return
> >> values, such as -ENOENT. I still fail to see cases where that's
> >> genuinely beneficial though.
> >
> > I'd like to see two completely independent APIs, so that I can just
> > request a bounce on -EPERM through a deny list.  I think it's useful
>
> Where would that bounce to? Which user space event does that trigger?
> Yet another one? Wouldn't 4 exit reasons just for MSR traps be a bit
> much? :)

All of the exits are either KVM_EXIT_X86_RDMSR or KVM_EXIT_X86_WRMSR.
Or, we could put the direction in the msr struct and just have one
exit reason.

> > to distinguish between -ENOENT and -EINVAL, but I have no issues wih
> > both causing an exit to userspace, if userspace has requested exits on
> > MSR #GPs.
>
> So imagine we took the first argument to ENABLE_CAP as filter:
>
>    (1<<0) REPORT_ENOENT
>    (1<<1) REPORT_EINVAL
>    (1<<2) REPORT_EPERM
>    (1<<31) REPORT_ANY
>
> Then we also add the reason to the kvm_run exit response and user space
> can differentiate easily between the different events.

I think this works well. I still have to call both APIs to satisfy my
use case, but I'm willing to cave on that request. (I just realized
that there is a very good use case for an allow/deny list *without*
exits to userspace: prohibiting kvm from doing cross-vendor MSR
emulation.)
