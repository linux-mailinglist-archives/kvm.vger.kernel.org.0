Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8952505E8
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 19:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgHXRX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 13:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgHXRXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 13:23:36 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C85FC061573
        for <kvm@vger.kernel.org>; Mon, 24 Aug 2020 10:23:35 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id n128so8971733oif.0
        for <kvm@vger.kernel.org>; Mon, 24 Aug 2020 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZaVERIAEdRy3ETc5WnqbSxKD5D4e1XJlj569NNDLiPM=;
        b=WRwqqa7gABYmkvrLDG8p+oCsHmi4Sp6tPAsnIXL/RofbvA4L4gWYcV9SBYGN998SSC
         fTr+uTfOPciAnBwfsDUJvMURl2zs5YxwgKycytT7NcqFjxW0nbnZw5biXVvMTgYHRsrR
         cqwwjGjhVg3jsJXeM4hBVTumPWGoWRV9LPp2siTrOZOwg55ndAb7ww8YqRJI8FWJvML7
         e3mxZwecjHY129Cn6PIxJPFJPQyfLC8W5KGIm+mUG2vAd/eBohrcDMSjWuKM+J0sVuSI
         T6n0P2FgpcCco+eegilSqGQ71cem/v2Q523Gno4UzCSviqy7f/t/tTps9AdD1WzJt2YH
         YtVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZaVERIAEdRy3ETc5WnqbSxKD5D4e1XJlj569NNDLiPM=;
        b=HzwMcEEx5cTRRdgIqmf5UFAA5EaOMpUsZceDxt7orENHd2FStUP8lzxsHJ7KcSjXkl
         63e3hIZJ7Dr9spOxsTUUZIrnNu6XeUJYBqicu3IuUYe+nEPJhWSOnS+Hpa9bhWfUI7bd
         LS0RZ2JYNYwyahRLUuV/5fosgXirGdIZi5ETw7K/jIwVv4A/pMygFAf53ZuFHbRRrxg7
         F0oSwaqhBO/o3LOsJKq34gCEAUL5N8DtxdCgsLHcSFhrJP2LH4VSTf6+fhPlSNhpxa7w
         n79gvlB/zGxDc2RKpzWTqWXhGqZaVW8aEbx8moGELoHH3fRaHIktINauIwvrnfb5IdoC
         o6Qw==
X-Gm-Message-State: AOAM5318a7xS4F9RbEFD2dAk06onO84mvUw+KM4DTHXkm4p3LqjF7nhr
        ulee3ppoyYUrQ0hYipuTEdrZz9giWkaJDCl3B5iTJQ==
X-Google-Smtp-Source: ABdhPJyJp+pgdROusolxBVWizc8Fc/MMk+PrTu7H6mlpxGmeWXKNhu+Ad4K3Znch9dGDDIVT0+rJ/Sn4eUG1ayIPGBk=
X-Received: by 2002:aca:b942:: with SMTP id j63mr260429oif.28.1598289813372;
 Mon, 24 Aug 2020 10:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-6-aaronlewis@google.com> <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
 <bd7c54ae-73d1-0200-fbe7-10c8df408f8b@amazon.com> <CALMp9eSXS+b62C-kXjwPBeYF36ajYeGg2kBmsubz9s5V6C-83A@mail.gmail.com>
 <CALMp9eTUV9Z7hL_qtdKYvqYmm8wT1_oGaRLp55i3ttg1qLyecQ@mail.gmail.com> <cf256ff0-8336-06fc-b475-8ca00782c4ce@amazon.com>
In-Reply-To: <cf256ff0-8336-06fc-b475-8ca00782c4ce@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 Aug 2020 10:23:21 -0700
Message-ID: <CALMp9eQd4cmK2_2oEnTX7VUEA0N9gsEkdpKhLyWpQzWCQm4w-w@mail.gmail.com>
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

On Sun, Aug 23, 2020 at 6:35 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 21.08.20 19:58, Jim Mattson wrote:
> >
> > On Thu, Aug 20, 2020 at 3:55 PM Jim Mattson <jmattson@google.com> wrote:
> >>
> >> On Thu, Aug 20, 2020 at 2:59 PM Alexander Graf <graf@amazon.com> wrote:
> >>
> >>> Do we really need to do all of this dance of differentiating in kernel
> >>> space between an exit that's there because user space asked for the exit
> >>> and an MSR access that would just generate a #GP?
> >>>
> >>> At the end of the day, user space *knows* which MSRs it asked to
> >>> receive. It can filter for them super easily.
> >>
> >> If no one else has an opinion, I can let this go. :-)
> >>
> >> However, to make the right decision in kvm_emulate_{rdmsr,wrmsr}
> >> (without the unfortunate before and after checks that Aaron added),
> >> kvm_{get,set}_msr should at least distinguish between "permission
> >> denied" and "raise #GP," so I can provide a deny list without asking
> >> for userspace exits on #GP.
> >
> > Actually, I think this whole discussion is moot. You no longer need
> > the first ioctl (ask for a userspace exit on #GP). The allow/deny list
> > is sufficient. Moreover, the allow/deny list checks can be in
> > kvm_emulate_{rdmsr,wrmsr} before the call to kvm_{get,set}_msr, so we
> > needn't be concerned with distinguishable error values either.
> >
>
> I also care about cases where I allow in-kernel handling, but for
> whatever reason there still would be a #GP injected into the guest. I
> want to record those events and be able to later have data that tell me
> why something went wrong.
>
> So yes, for your use case you do not care about the distinction between
> "deny MSR access" and "report invalid MSR access". However, I do care :).

In that case, I'm going to continue to hold a hard line on the
distinction between a #GP for an invalid MSR access and the #GP for an
unknown MSR. If, for instance, you wanted to implement ignore_msrs in
userspace, as you've proposed in the past, this would be extremely
helpful. Without it, userspace gets an exit because (1) the MSR access
isn't in the allow list, (2) the MSR access is invalid, or (3) the MSR
is unknown to kvm. As you've pointed out, it is easy for userspace to
distinguish (1) from the others, since it provided the allow/deny list
in the first place. But how do you distinguish (2) from (3) without
replicating the logic in the kernel?

> My stance on this is again that it's trivial to handle a few invalid MSR
> #GPs from user space and just not report anything. It should come at
> almost negligible performance cost, no?

Yes, the performance cost should be negligible, but what is the point?
We're trying to design a good API here, aren't we?

> As for your argumentation above, we have a second call chain into
> kvm_{get,set}_msr from the x86 emulator which you'd also need to cover.
>
> One thing we could do I guess is to add a parameter to ENABLE_CAP on
> KVM_CAP_X86_USER_SPACE_MSR so that it only bounces on certain return
> values, such as -ENOENT. I still fail to see cases where that's
> genuinely beneficial though.

I'd like to see two completely independent APIs, so that I can just
request a bounce on -EPERM through a deny list.  I think it's useful
to distinguish between -ENOENT and -EINVAL, but I have no issues wih
both causing an exit to userspace, if userspace has requested exits on
MSR #GPs.
