Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E8F3698CB
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243436AbhDWSCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 14:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhDWSCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 14:02:47 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75364C061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 11:02:09 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso44119241otb.13
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 11:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9znl9Akv85D3Qa3syKCKwQJTs1YevENL5QJ6YQadVOk=;
        b=cxKhUbzgM6ob3kxiT/vVdlXCsjLJz4BfJwJYp4Dp20WNvtvij203JFmdcS134pwqmq
         WjoKz8ijZTEUWjO0bV8+KHsFn9CSrVsFAO5MijskQahl2DWYpFQEIdhwwi1UZ1UXF34q
         Wu0SH/ZbDZRXyERZfhNMv+6DWPAyj8uKGGIKGvBu4ceDxX+4pWqlwQGRg9fp8rweE4nF
         bwzrvO5OB3oR/FwUnNy/slU9csr/NhqVW1EEUJsmAyHpo01kXm0BSKSBpkedluUUWerS
         OhlCITL6pgjHt7kkfDBcPjE6Yw7OKw9wGh540aDZnhEdyHKFRGExkhcXMDxFMduArn9s
         NE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9znl9Akv85D3Qa3syKCKwQJTs1YevENL5QJ6YQadVOk=;
        b=CeVBs+OAqUBiOl5f5svTgdy4LrUc5Baa2RJoZU6GJ5P4ScK7W5F7pBDafxCQiZtwLy
         9vPIW48UylRoSXFsF5Bzx7FYKhoYxUP442R2obeZ7MOzNJR4f5M7K0pZ0FAS6X9jGPvb
         jOjbpJIsrT9IVF6kwJfksg2MqNtvBCPe+R0BjsfiR/8rf+7CL2S2oj+dOKthZupkSzhx
         bf3/KC0OxDAMQfelvM/qDMrBE9PTSagujKEFsX+hbNla3Z+1UpM7xGPjO0SfkCAgLNLE
         kV/oBH1xNsWLseooc88ZUzcXWGmBbmSzcBBcXmhMVyi20fsI6KMpOj0omEHmjq3VWuBZ
         KiMg==
X-Gm-Message-State: AOAM5319ICpj7W6fIVCZh2NWlaVNl4l/CxhSQNO0OMcqsGlHuybulbe1
        JVT+NS2QE+MTnja1j7s5VDbQhskrc/VDmC4XQXQq9w==
X-Google-Smtp-Source: ABdhPJw5hCBdsjlniF/uTz+qPCn677XUgN1ABtEQkKgCDdS7l3Wosw1n1iw8SmTgMJPEa/KSsJMWxse5L8BGdYeW8A8=
X-Received: by 2002:a05:6830:16c8:: with SMTP id l8mr4386425otr.56.1619200928654;
 Fri, 23 Apr 2021 11:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org> <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org> <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
 <cunk0oug2t3.fsf@dme.org> <YILo26WQNvZNmtX0@google.com> <cunbla4ncdd.fsf@dme.org>
 <YIMF8b2jD3b8IfPP@google.com> <cun8s58nax7.fsf@dme.org> <CALMp9eS5nT2vuOWVg=A7rm1utK-6Pcq-akX5+szc24PeY4NDyA@mail.gmail.com>
In-Reply-To: <CALMp9eS5nT2vuOWVg=A7rm1utK-6Pcq-akX5+szc24PeY4NDyA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Apr 2021 11:01:58 -0700
Message-ID: <CALMp9eTfSSmzL1qqv7p9Zz7pHNuBy1TGc0Pp3O8oZqeXUWBdKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 10:57 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Apr 23, 2021 at 10:55 AM David Edmondson <dme@dme.org> wrote:
> >
> > On Friday, 2021-04-23 at 17:37:53 GMT, Sean Christopherson wrote:
> >
> > > On Fri, Apr 23, 2021, David Edmondson wrote:
> > >> On Friday, 2021-04-23 at 15:33:47 GMT, Sean Christopherson wrote:
> > >>
> > >> > On Thu, Apr 22, 2021, David Edmondson wrote:
> > >> >> Agreed. As Jim indicated in his other reply, there should be no new data
> > >> >> leaked by not zeroing the bytes.
> > >> >>
> > >> >> For now at least, this is not a performance critical path, so clearing
> > >> >> the payload doesn't seem too onerous.
> > >> >
> > >> > I feel quite strongly that KVM should _not_ touch the unused bytes.
> > >>
> > >> I'm fine with that, but...
> > >>
> > >> > As Jim pointed out, a stream of 0x0 0x0 0x0 ... is not benign, it will
> > >> > decode to one or more ADD instructions.  Arguably 0x90, 0xcc, or an
> > >> > undending stream of prefixes would be more appropriate so that it's
> > >> > less likely for userspace to decode a bogus instruction.
> > >>
> > >> ...I don't understand this position. If the user-level instruction
> > >> decoder starts interpreting bytes that the kernel did *not* indicate as
> > >> valid (by setting insn_size to include them), it's broken.
> > >
> > > Yes, so what's the point of clearing the unused bytes?
> >
> > Given that it doesn't prevent any known leakage, it's purely aesthetic,
> > which is why I'm happy not to bother.
> >
> > > Doing so won't magically fix a broken userspace.  That's why I argue
> > > that 0x90 or 0xcc would be more appropriate; there's at least a
> > > non-zero chance that it will help userspace avoid doing something
> > > completely broken.
> >
> > Perhaps an invalid instruction would be more useful in this respect, but
> > INT03 fills a similar purpose.
> >
> > > On the other hand, userspace can guard against a broken _KVM_ by initializing
> > > vcpu->run with a known pattern and logging if KVM exits to userspace with
> > > seemingly bogus data.  Crushing the unused bytes to zero defeats userspace's
> > > sanity check, e.g. if the actual memcpy() of the instruction bytes copies the
> > > wrong number of bytes, then userspace's magic pattern will be lost and debugging
> > > the KVM bug will be that much harder.
> > >
> > > This is very much not a theoretical problem, I have debugged two separate KVM
> > > bugs in the last few months where KVM completely failed to set
> > > vcpu->run->exit_reason before exiting to userspace.  The exit_reason is a bit of
> > > a special case because it's disturbingly easy for KVM to get confused over return
> > > values and unintentionally exit to userspace, but it's not a big stretch to
> > > imagine a bug where KVM provides incomplete data.
> >
> > Understood.
> >
> > So is the conclusion that KVM should copy only insn_size bytes rather
> > than the full 15?
>
> Insn_size should almost always be 15. It will only be less when the
> emulator hits a page crossing before fetching 15 bytes and it can't
> fetch from the second page.

Oh, or if the CS limit is reached. (cf. AMD's APM, volume 2, section
15.8.4: Nested and intercepted #PF).


> > dme.
> > --
> > But they'll laugh at you in Jackson, and I'll be dancin' on a Pony Keg.
