Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF24954CB
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 20:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346919AbiATTQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 14:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiATTQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 14:16:27 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226C4C061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 11:16:27 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id o80so20773815yba.6
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 11:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LgnhRIvXZbEoD4dNyz5NkE0CJ53Si0Wk9Up+SOzAYhA=;
        b=o0PDYUEKjpAJB9YJb3t9C+jB2PyVuPdaf4pkP7QzpQGjwttuO4V6bAkg6ZwhH+0o7n
         w6rEaAmsW34ThZTLSkfmf3+Ry8zWG5uUJWFGZsqfD68jhT+TpIg+gESR/1ui84iExdXZ
         pXIz89dINxbGyM1TkNJTcWtPU9VovT8UpDY+CfrT32NrUzsLxSCYHH+q11bvcZzt1FIt
         /m2zCZ+noC5CtDQj6TEcUJAzkGW4vAY7r5SagGWwt5ugxZktJ1VcSGmLjyp7b1yolR9l
         mjDjMhtbGrMh0uopZEljedyO2f15zEIvPAKr72Wezz6KjaeA8jirH9oBzuP99x+0pl1E
         7Izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LgnhRIvXZbEoD4dNyz5NkE0CJ53Si0Wk9Up+SOzAYhA=;
        b=4CDnZZTH5dp5Ap/Uq1GCNuJK3RNoFeljJJhN3kPYDESlpc7FBcoSyU8Z5OctkqevMx
         0/rsyOn2H2iYEDzaT4beffyaGU5gHg1o2/73zL/LzFtYjFkf9migPBjA5tZyKVLGCvBS
         juNC2VTHrwtxOEoy7MefKmhb2MK5tRuOCXXJwrZgHdkZGDYmyboHwZ7j+dkT4fclZFFX
         /8X1qCru/mNN12we1FvY2gVgnzG/rGgnn4ggHrsIYncQaT/MpQQH9oI90AoojI5YZr6X
         noaFlbfXTMffNuL1jZvJ/06g4tgjOdyi+hHNgu6Ra1Vd0CaXqJBMTpdvhCZbMQ4dFNDl
         IL/g==
X-Gm-Message-State: AOAM533pfqifM7rF3kAoKeGPWxxDvPLD3dYgG3cEL62jlh+ZXBD2ocPI
        yLU/6Idmta5aZ3+BFID+klBZPosHyiyZfH0uSzaGJw==
X-Google-Smtp-Source: ABdhPJzXKfVdVRUPzsECQCVgkK1ZzL2Rx2Ozj606e8DptRmlTQ6MsPNzGhGIZvYZBAbyNTeoXXpzxUUp4c3YgUAq71E=
X-Received: by 2002:a25:d055:: with SMTP id h82mr694673ybg.543.1642706186084;
 Thu, 20 Jan 2022 11:16:26 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com> <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
 <YedWUJNnQK3HFrWC@google.com> <CAAeT=FyJAG1dEFLvrQ4UXrwUqBUhY0AKkjzFpyi74zCJZUEYVg@mail.gmail.com>
 <YeisZCJedWYJPLV5@google.com>
In-Reply-To: <YeisZCJedWYJPLV5@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 20 Jan 2022 11:16:15 -0800
Message-ID: <CAJHc60zhRyOad7AqtEFn-Ptro5BGVkfpB2wXWGw5EZMxOHUc=w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Sean Christopherson <seanjc@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 4:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 18, 2022, Reiji Watanabe wrote:
> > On Tue, Jan 18, 2022 at 4:07 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Jan 14, 2022, Reiji Watanabe wrote:
> > > > The restriction, with which KVM doesn't need to worry about the changes
> > > > in the registers after KVM_RUN, could potentially protect or be useful
> > > > to protect KVM and simplify future changes/maintenance of the KVM codes
> > > > that consumes the values.
> > >
> > > That sort of protection is definitely welcome, the previously mentioned CPUID mess
> > > on x86 would have benefit greatly by KVM being restrictive in the past.  That said,
> > > hooking KVM_RUN is likely the wrong way to go about implementing any restrictions.
> > > Running a vCPU is where much of the vCPU's state is explicitly consumed, but it's
> > > all too easy for KVM to implicity/indirectly consume state via a different ioctl(),
> > > e.g. if there are side effects that are visible in other registers, than an update
> > > can also be visible to userspace via KVM_{G,S}ET_{S,}REGS, at which point disallowing
> > > modifying state after KVM_RUN but not after reading/writing regs is arbitrary and
> > > inconsitent.
> >
> > Thank you for your comments !
> > I think I understand your concern, and that's a great point.
> > That's not the case for those pseudo registers though at least for now :)
> > BTW, is this concern specific to hooking KVM_RUN ? (Wouldn't it be the
> > same for the option with "if kvm->created_vcpus > 0" ?)
>
> Not really?  The goal with created_vcpus is to avoid having inconsistent state in
> "struct kvm_vcpu" with respect to the VM as whole.  "struct kvm" obvioulsy can't
> be inconsistent with itself, e.g. even if userspace consumes some side effect,
> that's simply "the state".  Did that make sense?  Hard to explain in writing :-)
>
> > > If possible, preventing modification if kvm->created_vcpus > 0 is ideal as it's
> > > a relatively common pattern in KVM, and provides a clear boundary to userpace
> > > regarding what is/isn't allowed.
> >
> > Yes, I agree that would be better in general.  For (pseudo) registers,
>
> What exactly are these pseudo registers?  If it's something that's an immutable
> property of the (virtual) system, then it might make sense to use a separate,
> non-vCPU mechanism for setting/getting their values.  Then you can easily restrict
> the <whatever> to pre-created_vcpus, e.g. see x86's KVM_SET_IDENTITY_MAP_ADDR.
>
In general, these pseudo-registers are reserved non-architectural
register spaces, currently being used to represent KVM-as-a-firmware's
versioning across guests' migrations [1]. That is, the user-space
configures these registers for the guests to see same 'firmware'
versions before and after migrations. The model is built over the
existing KVM_GET_REG_LIST and KVM_[SET|GET]_ONE_REG APIs. Since this
series' efforts falls into the same realm, the idea was keep this
consistent with the existing model to which VMMs (such as QEMU) are
already used to.

Granted, even though these registers should technically be immutable,
there was no similar protection employed for the existing
psuedo-registers. I was wondering if that could be of any value if we
start providing one; But I guess not, since it may break the
user-space's expectations of KVM (and probably why we didn't have it
earlier).

Regards,
Raghavendra

[1]: https://github.com/torvalds/linux/blob/master/Documentation/virt/kvm/arm/psci.rst

> > I would think preventing modification if kvm->created_vcpus > 0 might
> > not be a very good option for KVM/ARM though considering usage of
> > KVM_GET_REG_LIST and KVM_{G,S}ET_ONE_REG.
