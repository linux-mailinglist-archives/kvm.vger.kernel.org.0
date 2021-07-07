Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202FB3BED3A
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 19:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhGGRmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 13:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhGGRms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 13:42:48 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6B4C061574
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 10:40:08 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id e1-20020a0568200601b029024ea261f0ccso700652oow.2
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 10:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FGC3+NBUEVI+ZfndkKLHE+Cb7/A4WbYHYCf8v9nal3c=;
        b=qse2jeTvjM7fIlq2ZDFhkI+coONaPbZYjpZ735nlyaesflJjTPtAX97Apf3wcZWeVR
         cLoWmWgGdlH+gMkUpfuV/UDwrmRqcSrCSr5AwrjaV6y184G0DWcZd5tQQXBmPvgtyOHA
         DTCCwbfEDsAAmlPTAHRGFPc+oIyItp/GkvqtO8ZZ1/iBXJI47lTigsFoFdR6gSKgnXBU
         6VEb3emx2V3XM9eNMozTLJYkRx1+ZsdYuzDxpWebgqgeuq+19qyF6LBvkVYNriVw5vdD
         RW403YPqzN5bXee4oRF8o6tXp+utehbuvaufGTDp5IWAhcPA58P4NR++7LuNTwt4Vbux
         suRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FGC3+NBUEVI+ZfndkKLHE+Cb7/A4WbYHYCf8v9nal3c=;
        b=QizGREvOnsXhUlB2hQZmHGXtz3E7Pp2nEXKZBT4+bV/zPSxv7lm3DKjB7IatBnQl2j
         GdeNoAVrzdTTu8SfuJryJVNWnFPTDr7dsMSbPL6+VWsZYZPA5A+mfh22qMN82/4HbxUd
         38sli0bKvgQzTnIBKCVUZ1YjUMTIFrWt+BwscJ4Prohi5ufX3qggDWMDCp5rG1pnurAt
         Fw4IpkTTm7Tbab3dzT2R21c8iumCGFKD/Y3AAH3OoGHY01pU38/Ry6yVF31DuHRVYZ3K
         6pal8nSrXNsvxUAXJxeTwE2CN/ZBCyZZgycFHZ1q4CTFNgWkk151LrNVCvef0HYHe+4A
         lZ9A==
X-Gm-Message-State: AOAM532dEzKLV/3wx8ELtUZY2ikPx3CdV+NbKAW1UC0q8XLZhL8gA0nP
        8OtncPivuW5hknnWkB2SbUifbFmhL2OxmXSOfv2dEg==
X-Google-Smtp-Source: ABdhPJx/VKW1zBdn163LFBKXO3qLbbhMOR9AyG6CJf1AfvvVHY3UtJzzmYGBq3owKLI9RFgVkxmfV1wpZSmmW5Is9k4=
X-Received: by 2002:a4a:c3c5:: with SMTP id e5mr19177386ooq.82.1625679607637;
 Wed, 07 Jul 2021 10:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210628124814.1001507-1-stsp2@yandex.ru> <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
 <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru> <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
 <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru> <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
 <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru> <CALMp9eQo6aUCz6+KOWJLhOXJET+4HHVA-HyhjHzAjnfFgTec4Q@mail.gmail.com>
 <6b263403-f959-6d9a-2bbe-15a684df6f50@yandex.ru> <CALMp9eRk1x-yTragM8OdQP3VSesVOAzezBs4acbqdiJz=nW-Qw@mail.gmail.com>
 <4795d507-22a0-d7ec-c324-a2a87febf97c@yandex.ru>
In-Reply-To: <4795d507-22a0-d7ec-c324-a2a87febf97c@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 7 Jul 2021 10:39:56 -0700
Message-ID: <CALMp9eT_6Na6LQepeHHNgYSzHO0aJ3yftge_7fNCRtd5WNNdAw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 7, 2021 at 9:58 AM stsp <stsp2@yandex.ru> wrote:
>
> 07.07.2021 19:46, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Wed, Jul 7, 2021 at 9:34 AM stsp <stsp2@yandex.ru> wrote:
> >> 07.07.2021 19:16, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>> On Tue, Jul 6, 2021 at 4:06 PM stsp <stsp2@yandex.ru> wrote:
> >>>> 07.07.2021 02:00, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>> On Wed, 2021-07-07 at 00:50 +0300, stsp wrote:
> >>>>>> 06.07.2021 23:29, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>>>> On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
> >>>>>>>> 06.07.2021 14:49, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>>>>>> Now about the KVM's userspace API where this is exposed:
> >>>>>>>>>
> >>>>>>>>> I see now too that KVM_SET_REGS clears the pending exception.
> >>>>>>>>> This is new to me and it is IMHO *wrong* thing to do.
> >>>>>>>>> However I bet that someone somewhere depends on this,
> >>>>>>>>> since this behavior is very old.
> >>>>>>>> What alternative would you suggest?
> >>>>>>>> Check for ready_for_interrupt_injection
> >>>>>>>> and never call KVM_SET_REGS if it indicates
> >>>>>>>> "not ready"?
> >>>>>>>> But what if someone calls it nevertheless?
> >>>>>>>> Perhaps return an error from KVM_SET_REGS
> >>>>>>>> if exception is pending? Also KVM_SET_SREGS
> >>>>>>>> needs some treatment here too, as it can
> >>>>>>>> also be called when an exception is pending,
> >>>>>>>> leading to problems.
> >>>>>>> As I explained you can call KVM_GET_VCPU_EVENTS before calling
> >>>>>>> KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
> >>>>>>> that was filled by KVM_GET_VCPU_EVENTS.
> >>>>>>> That will preserve all the cpu events.
> >>>>>> The question is different.
> >>>>>> I wonder how _should_ the KVM
> >>>>>> API behave when someone calls
> >>>>>> KVM_SET_REGS/KVM_SET_SREGS
> >>>>> KVM_SET_REGS should not clear the pending exception.
> >>>>> but fixing this can break API compatibilitly if some
> >>>>> hypervisor (not qemu) relies on it.
> >>>>>
> >>>>> Thus either a new ioctl is needed or as I said,
> >>>>> KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS can be used
> >>>>> to preserve the events around that call as workaround.
> >>>> But I don't need to preserve
> >>>> events. Canceling is perfectly
> >>>> fine with me because, if I inject
> >>>> the interrupt at that point, the
> >>>> exception will be re-triggered
> >>>> anyway after interrupt handler
> >>>> returns.
> >>> The exception will not be re-triggered if it was a trap,
> >> But my assumption was that
> >> everything is atomic, except
> >> PF with shadow page tables.
> >> I guess you mean the cases
> >> when the exception delivery
> >> causes EPT fault, which is a bit
> >> of a corner case.
> > No, that's not what I mean. Consider the #DB exception, which is
> > intercepted in all configurations to circumvent a DoS attack. Some #DB
> > exceptions modify DR6. Once the exception has been 'injected,' DR6 has
> > already been modified. If you do not complete the injection, but you
> > deliver an interrupt instead, then the interrupt handler can see a DR6
> > value that is architecturally impossible.
>
> Yes, I understand that part.
> It seems to be called the "exception
> payload" in kvm sources, and
> includes also CR2 for #PF.
> So of course if there are many
> non-atomic cases, rather than
> just one, then there are no doubts
> we need to check ready_for_injection.
> Its just that I was looking at that
> non-atomicity as a kvm's quirk,
> but its probably the fundamental
> part of vmx instead.

You could argue that it's a Linux quirk. Without EINTR, this probably
wouldn't be an issue.

> There is still the problem that
> KVM_SET_REGS cancels the
> injection and KVM_SET_SREGS not.
> But I realize you may want to leave
> it that way for compatibility.

Sadly, broken userspace APIs often have to remain broken. The "fix" is
probably to introduce KVM_SET_REGS2.
