Return-Path: <kvm+bounces-5484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 339DB8225B6
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 00:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCF4728496D
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA171799B;
	Tue,  2 Jan 2024 23:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qQmf0p3Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E174617985
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 23:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5534180f0e9so2227a12.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 15:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704239388; x=1704844188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtCri9auB/Q0wVXXcm5aP1kh1WsTIZcHi83DzvjBb0g=;
        b=qQmf0p3QbELZptVm0RUAqHMRMmldx2Vo0R/L2b0f4eTOFzwWqSqa2GGoT6RaMMJHcL
         9nkQM8anwMK5glENdDvjWSiXiRXYaCt4+/6jxKThOZFFlZuP69q+/FGTljn6KboUjSzR
         npOp/+DlMrTgKs3Zzwpzj+5MgTrItX92aowwdRHngeHwerub5EG7ZqDc7FXkc5/d1kUq
         2h0sXlAf8Zh6qDzSdCZRUlSU654+bIqXbeXNE/nym6g8qxskeL77WB/GOTCy3a1L5Hf+
         kxfu9I96jPT+AHF2u+xDpL7tvA01BQR59hd4K6KQGrh5CdWzIbnz2Wi/0GL/GvMxTtWD
         auqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704239388; x=1704844188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtCri9auB/Q0wVXXcm5aP1kh1WsTIZcHi83DzvjBb0g=;
        b=pIE8lZ4gou0VPipnVgzzJPHrF51zvYqnwqZZ11W7Rb0jVEX/VHvraGeEtqLAULYTa8
         bE/NEhK+oYWFNkB8ThnBhAr+fd0NrmxeN540QPZ4kqgfOe6E3Nu+wN2L78Zg8JBzGIXy
         zaGRrW30gAVAjAdz1iJr5sAB03OKpRQLBZZgu0IismrNiFtS2TwCFYwubqpUYI+4Asz3
         AGVtv4A5OjyMhlIr+2J6i8/mZZ/XSZx1sZm3m4PYSmVS7Wy4mHGn0iYWHV9wkr/ta34R
         LfcSd8exUQoNcDiv3NS0ig/3kPMWQJINrvnEiMlWOy0stNuPf13emtoIT1foL8JCu2n4
         dZJQ==
X-Gm-Message-State: AOJu0Yxp6fegCnQ9AaIPGhSZbijDdoMwxjXqkvOyNcVPEhwEsMcG/1pg
	uWRcNsbUMlI9Did8nfsNe8GANCyK5NSNHHl25q5BNTnm+KCQ
X-Google-Smtp-Source: AGHT+IGLzRfQSuZglF/+kGu5BJRT0gfs0HEEx2DIZYn1v0w0Z07C9waYBqr1tLLRL6Eoju2TMnitTc9n/3zrgF6hBCo=
X-Received: by 2002:a50:d60b:0:b0:54c:f4fd:3427 with SMTP id
 x11-20020a50d60b000000b0054cf4fd3427mr13814edi.7.1704239387819; Tue, 02 Jan
 2024 15:49:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
 <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com> <481be19e33915804c855a55181c310dd8071b546.camel@redhat.com>
In-Reply-To: <481be19e33915804c855a55181c310dd8071b546.camel@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 2 Jan 2024 15:49:32 -0800
Message-ID: <CALMp9eQcRF_oS2rc_xF1H3=pfHB7ggts44obZgvh-K03UYJLSQ@mail.gmail.com>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC deadline timers
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 2, 2024 at 2:21=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.com>=
 wrote:
>
> On Thu, 2023-12-21 at 11:09 -0800, Jim Mattson wrote:
> > On Thu, Dec 21, 2023 at 8:52=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat=
.com> wrote:
> > >
> > > Hi!
> > >
> > > Recently I was tasked with triage of the failures of 'vmx_preemption_=
timer'
> > > that happen in our kernel CI pipeline.
> > >
> > >
> > > The test usually fails because L2 observes TSC after the
> > > preemption timer deadline, before the VM exit happens.
> > >
> > > This happens because KVM emulates nested preemption timer with HR tim=
ers,
> > > so it converts the preemption timer value to nanoseconds, taking in a=
ccount
> > > tsc scaling and host tsc frequency, and sets HR timer.
> > >
> > > HR timer however as I found out the hard way is bound to CLOCK_MONOTO=
NIC,
> > > and thus its rate can be adjusted by NTP, which means that it can run=
 slower or
> > > faster than KVM expects, which can result in the interrupt arriving e=
arlier,
> > > or late, which is what is happening.
> > >
> > > This is how you can reproduce it on an Intel machine:
> > >
> > >
> > > 1. stop the NTP daemon:
> > >       sudo systemctl stop chronyd.service
> > > 2. introduce a small error in the system time:
> > >       sudo date -s "$(date)"
> > >
> > > 3. start NTP daemon:
> > >       sudo chronyd -d -n  (for debug) or start the systemd service ag=
ain
> > >
> > > 4. run the vmx_preemption_timer test a few times until it fails:
> > >
> > >
> > > I did some research and it looks like I am not the first to encounter=
 this:
> > >
> > > From the ARM side there was an attempt to support CLOCK_MONOTONIC_RAW=
 with
> > > timer subsystem which was even merged but then reverted due to issues=
:
> > >
> > > https://lore.kernel.org/all/1452879670-16133-3-git-send-email-marc.zy=
ngier@arm.com/T/#u
> > >
> > > It looks like this issue was later worked around in the ARM code:
> > >
> > >
> > > commit 1c5631c73fc2261a5df64a72c155cb53dcdc0c45
> > > Author: Marc Zyngier <maz@kernel.org>
> > > Date:   Wed Apr 6 09:37:22 2016 +0100
> > >
> > >     KVM: arm/arm64: Handle forward time correction gracefully
> > >
> > >     On a host that runs NTP, corrections can have a direct impact on
> > >     the background timer that we program on the behalf of a vcpu.
> > >
> > >     In particular, NTP performing a forward correction will result in
> > >     a timer expiring sooner than expected from a guest point of view.
> > >     Not a big deal, we kick the vcpu anyway.
> > >
> > >     But on wake-up, the vcpu thread is going to perform a check to
> > >     find out whether or not it should block. And at that point, the
> > >     timer check is going to say "timer has not expired yet, go back
> > >     to sleep". This results in the timer event being lost forever.
> > >
> > >     There are multiple ways to handle this. One would be record that
> > >     the timer has expired and let kvm_cpu_has_pending_timer return
> > >     true in that case, but that would be fairly invasive. Another is
> > >     to check for the "short sleep" condition in the hrtimer callback,
> > >     and restart the timer for the remaining time when the condition
> > >     is detected.
> > >
> > >     This patch implements the latter, with a bit of refactoring in
> > >     order to avoid too much code duplication.
> > >
> > >     Cc: <stable@vger.kernel.org>
> > >     Reported-by: Alexander Graf <agraf@suse.de>
> > >     Reviewed-by: Alexander Graf <agraf@suse.de>
> > >     Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > >     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > >
> > >
> > > So to solve this issue there are two options:
> > >
> > >
> > > 1. Have another go at implementing support for CLOCK_MONOTONIC_RAW ti=
mers.
> > >    I don't know if that is feasible and I would be very happy to hear=
 a feedback from you.
> > >
> > > 2. Also work this around in KVM. KVM does listen to changes in the ti=
mekeeping system
> > >   (kernel calls its update_pvclock_gtod), and it even notes rates of =
both regular and raw clocks.
> > >
> > >   When starting a HR timer I can adjust its period for the difference=
 in rates, which will in most
> > >   cases produce more correct result that what we have now, but will s=
till fail if the rate
> > >   is changed at the same time the timer is started or before it expir=
es.
> > >
> > >   Or I can also restart the timer, although that might cause more har=
m than
> > >   good to the accuracy.
> > >
> > >
> > > What do you think?
> >
> > Is this what the "adaptive tuning" in the local APIC TSC_DEADLINE
> > timer is all about (lapic_timer_advance_ns =3D -1)?
>
>
> Hi,
>
> I don't think that 'lapic_timer_advance' is designed for that but it does
> mask this problem somewhat.
>
> The goal of 'lapic_timer_advance' is to decrease time between deadline pa=
ssing and start
> of guest timer irq routine by making the deadline happen a bit earlier (b=
y timer_advance_ns), and then busy-waiting
> (hopefully only a bit) until the deadline passes, and then immediately do=
 the VM entry.
>
> This way instead of overhead of VM exit and VM entry that both happen aft=
er the deadline,
> only the VM entry happens after the deadline.
>
>
> In relation to NTP interference: If the deadline happens earlier than exp=
ected, then
> KVM will busy wait and decrease the 'timer_advance_ns', and next time the=
 deadline
> will happen a bit later thus adopting for the NTP adjustment somewhat.
>
> Note though that 'timer_advance_ns' variable is unsigned and adjust_lapic=
_timer_advance can underflow
> it, which can be fixed.
>
> Now if the deadline happens later than expected, then the guest will see =
this happen,
> but at least adjust_lapic_timer_advance should increase the 'timer_advanc=
e_ns' so next
> time the deadline will happen earlier which will also eventually hide the=
 problem.
>
> So overall I do think that implementing the 'lapic_timer_advance' for nes=
ted VMX preemption timer
> is a good idea, especially since this feature is not really nested in som=
e sense - the timer is
> just delivered as a VM exit but it is always delivered to L1, so VMX pree=
mption timer can
> be seen as just an extra L1's deadline timer.
>
> I do think that nested VMX preemption timer should use its own value of t=
imer_advance_ns, thus
> we need to extract the common code and make both timers use it. Does this=
 make sense?

Alternatively, why not just use the hardware VMX-preemption timer to
deliver the virtual VMX-preemption timer?

Today, I believe that we only use the hardware VMX-preemption timer to
deliver the virtual local APIC timer. However, it shouldn't be that
hard to pick the first deadline of {VMX-preemption timer, local APIC
timer} at each emulated VM-entry to L2.

> Best regards,
>         Maxim Levitsky
>
>
> >  If so, can we
> > leverage that for the VMX-preemption timer as well?
> > > Best regards,
> > >         Maxim Levitsky
> > >
> > >
> > >
>
>
>
>

