Return-Path: <kvm+bounces-5467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 222DC8224A6
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 880511F236B6
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F306171C8;
	Tue,  2 Jan 2024 22:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OFw+aqMg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6BF171BA
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RshiW/YYDsnsJFyUGAY3lZJunQEflUHgqX3fmfeIPig=;
	b=OFw+aqMgPiJ+PdzsXosLmlauazCgwsu1urt2PJd9oS9vc9BknKT01zn6N7L8DGIa8awogi
	HhDeYaqbvYhx5TyYHSCMqgW/zCZGlpA61gaNck/Mjybap844Wk53Zmlb648E5kohScy1/z
	UWf2oR5J9yN1c5q3fGpS4qFNyxh/O+o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-vtCPcd0XO6Gp7ekc5PFavA-1; Tue, 02 Jan 2024 17:21:53 -0500
X-MC-Unique: vtCPcd0XO6Gp7ekc5PFavA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40d5aa2f118so54592515e9.3
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:21:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234112; x=1704838912;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RshiW/YYDsnsJFyUGAY3lZJunQEflUHgqX3fmfeIPig=;
        b=YjX8P/ij6bTNlES9I2Xr6+BvcsnfpHrcap0F38TEP9vu6q3Ie3BwMUPw7GiUg3KoVQ
         tmggMrcbHRLntDWelryjdvGQ5mBL8Ix8Q1kdJBig0Nge6KeuaE+uW3v1GH5eZSScUjDd
         0/NuHmhKFOXpuJYmIQUFmLPBp0t1Alc5BHukStl6Bw+5TIWz7DePE5ROKO608Pt07+L7
         anr70F9ZgCANsTTtOrRhfboE9Itjpqqz9m/h3sLJR93/MX0BzUVM26bXrdCzYFwZ2+nb
         cdRZPa0eyNPC7TnvmltndZ3mwP80Y7GFqvf3OQ6H0SHQk4Q0PvFvC9ETZhrF1UeCozv5
         z9jQ==
X-Gm-Message-State: AOJu0YxRWo1wXwsZYLQBouZHX9X2E8Zhi59NdDqrcjbtazti27HGpHEz
	6d38WJwP95oXnxjLFHYJbGV4g1tfMklveuE8gfuet6xZSKhH83a61HZ7uj89IpGG4K8UQwQEeU+
	e5yec9MyBWmJrVHbd8u4j
X-Received: by 2002:a05:600c:348b:b0:40d:900a:73fb with SMTP id a11-20020a05600c348b00b0040d900a73fbmr46506wmq.65.1704234112077;
        Tue, 02 Jan 2024 14:21:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHttI9eUM+Qn9TcD1hg1dJMoZ4pPtRP0PZJy071YvTYKD1xOPdFR2WiqYRxkhiRo/VCjHX3oQ==
X-Received: by 2002:a05:600c:348b:b0:40d:900a:73fb with SMTP id a11-20020a05600c348b00b0040d900a73fbmr46498wmq.65.1704234111753;
        Tue, 02 Jan 2024 14:21:51 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id l26-20020a1c791a000000b0040d839de5c2sm303457wme.33.2024.01.02.14.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:21:51 -0800 (PST)
Message-ID: <481be19e33915804c855a55181c310dd8071b546.camel@redhat.com>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC
 deadline timers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Marc
 Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vitaly
 Kuznetsov <vkuznets@redhat.com>
Date: Wed, 03 Jan 2024 00:21:49 +0200
In-Reply-To: <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com>
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
	 <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2023-12-21 at 11:09 -0800, Jim Mattson wrote:
> On Thu, Dec 21, 2023 at 8:52 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > 
> > Hi!
> > 
> > Recently I was tasked with triage of the failures of 'vmx_preemption_timer'
> > that happen in our kernel CI pipeline.
> > 
> > 
> > The test usually fails because L2 observes TSC after the
> > preemption timer deadline, before the VM exit happens.
> > 
> > This happens because KVM emulates nested preemption timer with HR timers,
> > so it converts the preemption timer value to nanoseconds, taking in account
> > tsc scaling and host tsc frequency, and sets HR timer.
> > 
> > HR timer however as I found out the hard way is bound to CLOCK_MONOTONIC,
> > and thus its rate can be adjusted by NTP, which means that it can run slower or
> > faster than KVM expects, which can result in the interrupt arriving earlier,
> > or late, which is what is happening.
> > 
> > This is how you can reproduce it on an Intel machine:
> > 
> > 
> > 1. stop the NTP daemon:
> >       sudo systemctl stop chronyd.service
> > 2. introduce a small error in the system time:
> >       sudo date -s "$(date)"
> > 
> > 3. start NTP daemon:
> >       sudo chronyd -d -n  (for debug) or start the systemd service again
> > 
> > 4. run the vmx_preemption_timer test a few times until it fails:
> > 
> > 
> > I did some research and it looks like I am not the first to encounter this:
> > 
> > From the ARM side there was an attempt to support CLOCK_MONOTONIC_RAW with
> > timer subsystem which was even merged but then reverted due to issues:
> > 
> > https://lore.kernel.org/all/1452879670-16133-3-git-send-email-marc.zyngier@arm.com/T/#u
> > 
> > It looks like this issue was later worked around in the ARM code:
> > 
> > 
> > commit 1c5631c73fc2261a5df64a72c155cb53dcdc0c45
> > Author: Marc Zyngier <maz@kernel.org>
> > Date:   Wed Apr 6 09:37:22 2016 +0100
> > 
> >     KVM: arm/arm64: Handle forward time correction gracefully
> > 
> >     On a host that runs NTP, corrections can have a direct impact on
> >     the background timer that we program on the behalf of a vcpu.
> > 
> >     In particular, NTP performing a forward correction will result in
> >     a timer expiring sooner than expected from a guest point of view.
> >     Not a big deal, we kick the vcpu anyway.
> > 
> >     But on wake-up, the vcpu thread is going to perform a check to
> >     find out whether or not it should block. And at that point, the
> >     timer check is going to say "timer has not expired yet, go back
> >     to sleep". This results in the timer event being lost forever.
> > 
> >     There are multiple ways to handle this. One would be record that
> >     the timer has expired and let kvm_cpu_has_pending_timer return
> >     true in that case, but that would be fairly invasive. Another is
> >     to check for the "short sleep" condition in the hrtimer callback,
> >     and restart the timer for the remaining time when the condition
> >     is detected.
> > 
> >     This patch implements the latter, with a bit of refactoring in
> >     order to avoid too much code duplication.
> > 
> >     Cc: <stable@vger.kernel.org>
> >     Reported-by: Alexander Graf <agraf@suse.de>
> >     Reviewed-by: Alexander Graf <agraf@suse.de>
> >     Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > 
> > So to solve this issue there are two options:
> > 
> > 
> > 1. Have another go at implementing support for CLOCK_MONOTONIC_RAW timers.
> >    I don't know if that is feasible and I would be very happy to hear a feedback from you.
> > 
> > 2. Also work this around in KVM. KVM does listen to changes in the timekeeping system
> >   (kernel calls its update_pvclock_gtod), and it even notes rates of both regular and raw clocks.
> > 
> >   When starting a HR timer I can adjust its period for the difference in rates, which will in most
> >   cases produce more correct result that what we have now, but will still fail if the rate
> >   is changed at the same time the timer is started or before it expires.
> > 
> >   Or I can also restart the timer, although that might cause more harm than
> >   good to the accuracy.
> > 
> > 
> > What do you think?
> 
> Is this what the "adaptive tuning" in the local APIC TSC_DEADLINE
> timer is all about (lapic_timer_advance_ns = -1)?


Hi,

I don't think that 'lapic_timer_advance' is designed for that but it does
mask this problem somewhat.

The goal of 'lapic_timer_advance' is to decrease time between deadline passing and start
of guest timer irq routine by making the deadline happen a bit earlier (by timer_advance_ns), and then busy-waiting 
(hopefully only a bit) until the deadline passes, and then immediately do the VM entry.

This way instead of overhead of VM exit and VM entry that both happen after the deadline,
only the VM entry happens after the deadline.


In relation to NTP interference: If the deadline happens earlier than expected, then
KVM will busy wait and decrease the 'timer_advance_ns', and next time the deadline
will happen a bit later thus adopting for the NTP adjustment somewhat.

Note though that 'timer_advance_ns' variable is unsigned and adjust_lapic_timer_advance can underflow
it, which can be fixed.

Now if the deadline happens later than expected, then the guest will see this happen, 
but at least adjust_lapic_timer_advance should increase the 'timer_advance_ns' so next
time the deadline will happen earlier which will also eventually hide the problem.

So overall I do think that implementing the 'lapic_timer_advance' for nested VMX preemption timer
is a good idea, especially since this feature is not really nested in some sense - the timer is
just delivered as a VM exit but it is always delivered to L1, so VMX preemption timer can 
be seen as just an extra L1's deadline timer.

I do think that nested VMX preemption timer should use its own value of timer_advance_ns, thus
we need to extract the common code and make both timers use it. Does this make sense?

Best regards,
	Maxim Levitsky


>  If so, can we
> leverage that for the VMX-preemption timer as well?
> > Best regards,
> >         Maxim Levitsky
> > 
> > 
> > 





