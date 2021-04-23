Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EBD3698BC
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhDWR6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWR6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 13:58:43 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9205CC061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 10:58:06 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id k18so45021014oik.1
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 10:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n4VIZG2P7B8V2vXgtHYhjIJ8XA1EJNkPxL13SDl0iz8=;
        b=hM9z+6CCKxf9ONUzQyd7wCqcRPW2pk6TI7VM33g8vZpzn1Vq3SKX3YbT9EEBPHphY/
         JzLm7hUNLYhMHgty/WF2T1SjBxx8FG5SYJSGsFzkn7vn8n1vtJzcAvpMzgytCoeDJHZj
         Ckyjsv6dikmo0RUsLma+45SmjL2r7/IP5bh0LuchbzVG8oYMfSU4ovxpJ/335ymuFtFt
         p4hg/AfsQ8fXuYcN+mxqeMsCT27T01Ih+waUM6bTEJAKxHLA41CZOs0CPeA2U1lSxiXK
         HNOpi3lQaJZdaZ/FmUFBa2EU1VSF1twQNvNYBOK7smzwyIUdM1Ti46psizehc2m6q5bY
         etfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n4VIZG2P7B8V2vXgtHYhjIJ8XA1EJNkPxL13SDl0iz8=;
        b=glTkqQHAw7YtoCzMUS8WOLbQ7OQLiEfjsw3IpBIDnn8ufuV7zINSeMYCu9JDykxwNP
         6ytTCcumHX6XN1W8ZFBLrCYeDM19Biw0KGcWCrgKWVOQIeseP49ReTMnojiYy0CedAJ6
         OyfkwKVSrsmcQSkzh8ELboNcmwj7F8T+z8MU1QQdErvs0k2M5YhOe1aap0eKyYxB+PvK
         WlUki9CXZ4HuN+7qWGjfDLUy/AlLtQFR/AX6yU2psLFQHJrP8y1spFnNAHFxgBYbwixa
         jGgzuufD1a+py9czpJR0JkAvNafLW1pZt3iCZwGvT4FUHFnQ9VEYrRZPAESi5NHmUr8c
         8uCA==
X-Gm-Message-State: AOAM533Tn/frrPrsM2w//O7ybiZSPm2t1eUkdpiEtrDtozUGfTAnjTUY
        lF+9f3Oaop9DWdjvLfxDqpPK6rfmLGjMs4xC1lzO2Q==
X-Google-Smtp-Source: ABdhPJwb/5l3RWxTXP8kLkG/EcBwGsE0nv3fqKKD08yZvv/th9h1Q/Qmq2rjYPX7AMv9yhOSCsoo86/fxSJr90TO6Ho=
X-Received: by 2002:aca:3cd6:: with SMTP id j205mr3692449oia.28.1619200685603;
 Fri, 23 Apr 2021 10:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org> <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org> <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
 <cunk0oug2t3.fsf@dme.org> <YILo26WQNvZNmtX0@google.com> <cunbla4ncdd.fsf@dme.org>
 <YIMF8b2jD3b8IfPP@google.com> <cun8s58nax7.fsf@dme.org>
In-Reply-To: <cun8s58nax7.fsf@dme.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Apr 2021 10:57:55 -0700
Message-ID: <CALMp9eS5nT2vuOWVg=A7rm1utK-6Pcq-akX5+szc24PeY4NDyA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 10:55 AM David Edmondson <dme@dme.org> wrote:
>
> On Friday, 2021-04-23 at 17:37:53 GMT, Sean Christopherson wrote:
>
> > On Fri, Apr 23, 2021, David Edmondson wrote:
> >> On Friday, 2021-04-23 at 15:33:47 GMT, Sean Christopherson wrote:
> >>
> >> > On Thu, Apr 22, 2021, David Edmondson wrote:
> >> >> Agreed. As Jim indicated in his other reply, there should be no new data
> >> >> leaked by not zeroing the bytes.
> >> >>
> >> >> For now at least, this is not a performance critical path, so clearing
> >> >> the payload doesn't seem too onerous.
> >> >
> >> > I feel quite strongly that KVM should _not_ touch the unused bytes.
> >>
> >> I'm fine with that, but...
> >>
> >> > As Jim pointed out, a stream of 0x0 0x0 0x0 ... is not benign, it will
> >> > decode to one or more ADD instructions.  Arguably 0x90, 0xcc, or an
> >> > undending stream of prefixes would be more appropriate so that it's
> >> > less likely for userspace to decode a bogus instruction.
> >>
> >> ...I don't understand this position. If the user-level instruction
> >> decoder starts interpreting bytes that the kernel did *not* indicate as
> >> valid (by setting insn_size to include them), it's broken.
> >
> > Yes, so what's the point of clearing the unused bytes?
>
> Given that it doesn't prevent any known leakage, it's purely aesthetic,
> which is why I'm happy not to bother.
>
> > Doing so won't magically fix a broken userspace.  That's why I argue
> > that 0x90 or 0xcc would be more appropriate; there's at least a
> > non-zero chance that it will help userspace avoid doing something
> > completely broken.
>
> Perhaps an invalid instruction would be more useful in this respect, but
> INT03 fills a similar purpose.
>
> > On the other hand, userspace can guard against a broken _KVM_ by initializing
> > vcpu->run with a known pattern and logging if KVM exits to userspace with
> > seemingly bogus data.  Crushing the unused bytes to zero defeats userspace's
> > sanity check, e.g. if the actual memcpy() of the instruction bytes copies the
> > wrong number of bytes, then userspace's magic pattern will be lost and debugging
> > the KVM bug will be that much harder.
> >
> > This is very much not a theoretical problem, I have debugged two separate KVM
> > bugs in the last few months where KVM completely failed to set
> > vcpu->run->exit_reason before exiting to userspace.  The exit_reason is a bit of
> > a special case because it's disturbingly easy for KVM to get confused over return
> > values and unintentionally exit to userspace, but it's not a big stretch to
> > imagine a bug where KVM provides incomplete data.
>
> Understood.
>
> So is the conclusion that KVM should copy only insn_size bytes rather
> than the full 15?

Insn_size should almost always be 15. It will only be less when the
emulator hits a page crossing before fetching 15 bytes and it can't
fetch from the second page.

> dme.
> --
> But they'll laugh at you in Jackson, and I'll be dancin' on a Pony Keg.
