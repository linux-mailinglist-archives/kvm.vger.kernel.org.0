Return-Path: <kvm+bounces-5478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7FF822555
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 00:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CFC3284764
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216E817742;
	Tue,  2 Jan 2024 23:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vVB9yxY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AE71772B
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 23:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e8e0c7f9a8so120567157b3.0
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 15:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704236447; x=1704841247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tqlmEzajDROIF5qTRj878vrgM+Kigc/uXZWYA8u+3w=;
        b=4vVB9yxYCWeNoUietzq1BHauHblLcriEvmJHeULFek5R4WdOwRM/cfQ+cV95F7orGZ
         coF2HzXw5qRgrygxrQyxwnLzILQKZQ7RnNxdgD1njjwZL9v8lMxOi3OUXCDEvqyGLn0E
         O0a385uHg/k+Q391DSh+1WUVFcmt1Xhra3DZZACfzlLhSddIQqMYgJgAsx88/1t7IHEr
         641mi+fx/VwfEBrKnAW0EBETWUEw5F3/JKyd8JO2CoBzouTWPg3QCKXVRfRAM+ofb1bJ
         CqkMz90C8Ks5dd4JCPtS/Fz52eDR7GnIVX0foyPpzb4HXbeYmeq/LxZ50/FPzMxiFYgX
         m6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704236447; x=1704841247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tqlmEzajDROIF5qTRj878vrgM+Kigc/uXZWYA8u+3w=;
        b=ZNswptzaZuCqT9H8ZRqj46Dt58cVZhgQCq0ozephq6sGrE+9yrAY2czA/rFm8JrKc2
         ET+sJsZs/zlmFULweWa9j4yX6lweXanCyaRzTvg9M5memt3okMIvsbTO1Wl1G7hTl4n+
         wPfIih5ODMl/lpU9vTeHZonl2Mgn/i2thcWJ+2SN1UgPrzxZK4qUAgCHNXS/NE7gTdpT
         MjbmlLTfCoodFy/eb8js4A7og3EsgthUQ4iTAwNngK7UR85OthRHZA6EYjsDgNoiL/Zt
         pt2nBLsnUZrJF1jiFKrJEKFAHeQvOlXncxE7atUO0aHBE4lImpOw5/2IL/s8seacMd/e
         wxpw==
X-Gm-Message-State: AOJu0YxtWCz+0vsEfLcqD61eP0kgDjHN1nX0o7FTavvBWMgIRurUXtl4
	Qc1ZVVshUaN5081LKiVGi9UWBkyP1LiDrCO9BQ==
X-Google-Smtp-Source: AGHT+IFXcXspzuNVTYbn8+kiPcoVwbsTYY4jYe2D4wm7w3m6NJggdGj3QTz8CCJNVpxLSJj7v+zE+Zg6lv8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d816:0:b0:5d8:ef49:748 with SMTP id
 a22-20020a0dd816000000b005d8ef490748mr56080ywe.5.1704236446839; Tue, 02 Jan
 2024 15:00:46 -0800 (PST)
Date: Tue, 2 Jan 2024 15:00:45 -0800
In-Reply-To: <CAE8KmOyffXD4k69vRAFwesaqrBGzFY3i+kefbkHcQf4=jNYzOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAE8KmOw1DzOr-GvQ9E+Y5RCX1GQ1h1Bumk5pB++9=SjMUPHxBg@mail.gmail.com>
 <ZT_HeK7GXdY-6L3t@google.com> <CAE8KmOxKkojqrqWE1RMa4YY3=of1AEFcDth_6b2ZCHJHzb8nng@mail.gmail.com>
 <CAE8KmOxd-Xib+qfiiBepP-ydjSAn32gjOTdLLUqm-i5vgzTv8w@mail.gmail.com> <CAE8KmOyffXD4k69vRAFwesaqrBGzFY3i+kefbkHcQf4=jNYzOA@mail.gmail.com>
Message-ID: <ZZSVnT0Ovk5QrasA@google.com>
Subject: Re: Fwd: About patch bdedff263132 - KVM: x86: Route pending NMIs
From: Sean Christopherson <seanjc@google.com>
To: Prasad Pandit <ppandit@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 29, 2023, Prasad Pandit wrote:
> Hello Sean,
> 
> On Tue, 31 Oct 2023 at 17:45, Prasad Pandit <ppandit@redhat.com> wrote:
> > On Mon, 30 Oct 2023 at 20:41, Sean Christopherson <seanjc@google.com> wrote:
> >>> -               kvm_make_request(KVM_REQ_NMI, vcpu);
> >>> +               if (events->nmi.pending)
> >>> +                       kvm_make_request(KVM_REQ_NMI, vcpu);
> > >
> > > This looks sane, but it should be unnecessary as KVM_REQ_NMI nmi_queued=0 should
> > > be a (costly) nop.  Hrm, unless the vCPU is in HLT, in which case KVM will treat
> > > a spurious KVM_REQ_NMI as a wake event.  When I made this change, my assumption
> > > was that userspace would set KVM_VCPUEVENT_VALID_NMI_PENDING iff there was
> > > relevant information to process.  But if I'm reading the code correctly, QEMU
> > > invokes KVM_SET_VCPU_EVENTS with KVM_VCPUEVENT_VALID_NMI_PENDING at the end of
> > > machine creation.
> > >

...

> * Above are 3 different ways in which KVM_SET_VCPU_EVENTS ioctl(2) gets called.
>         QEMU/target/i386/kvm/kvm.c: kvm_put_vcpu_events()
>          if (level >= KVM_PUT_RESET_STATE) {
>              events.flags |= KVM_VCPUEVENT_VALID_NMI_PENDING;
>   But KVM_VCPUEVENT_VALID_NMI_PENDING is set only when level >=
> 2(KVM_PUT_RESET_STATE). ie. in the first (level=1) case _NMI_PENDING
> is not set.
> 
> * In the real-time host set-up I have, KVM_VCPUEVENT_VALID_NMI_PENDING
> is called twice for each VCPU and after that kernel goes into what
> looks like a lock contention loop. Each time
> KVM_VCPUEVENT_VALID_NMI_PENDING is called with 'cpu->env->nmi_injected
> = 0' and  'cpu->env->nmi_pending = 0'.  ie. for each VCPU two NMI
> events are injected via - kvm_make_request(KVM_REQ_NMI, vcpu), when
> vcpu has no NMIs pending.
> 
> # perf lock report -t
>                 Name   acquired  contended     avg wait   total wait   max wait     min wait
> 
>            CPU 3/KVM     154017     154017     62.19 us      9.58 s   101.01 us      1.49 us
>            CPU 9/KVM     152796     152796     62.67 us      9.58 s    95.92 us      1.49 us
>            CPU 7/KVM     151554     151554     63.16 us      9.57 s   102.70 us      1.48 us
>            CPU 1/KVM     151273     151273     65.30 us      9.88 s    98.88 us      1.52 us
>            CPU 6/KVM     151107     151107     63.34 us      9.57 s   107.64 us      1.50 us
>            CPU 8/KVM     151038     151038     63.37 us      9.57 s   102.93 us      1.51 us
>            CPU 2/KVM     150701     150701     63.52 us      9.57 s    99.24 us      1.50 us
>            CPU 5/KVM     150695     150695     63.56 us      9.58 s   142.15 us      1.50 us
>            CPU 4/KVM     150527     150527     63.60 us      9.57 s   102.04 us      1.44 us
>      qemu-system-x86        665        665     65.92 us     43.84 ms  100.67 us      1.55 us
>            CPU 0/KVM          2          2    210.46 us    420.92 us  411.89 us      9.03 us
>      qemu-system-x86          1          1    404.91 us    404.91 us  404.91 us    404.91 us
>         TC tc-pc.ram          1          1    414.22 us    414.22 us  414.22 us    414.22 us
>   === output for debug===
> bad: 10, total: 13
> bad rate: 76.92 %
> histogram of events caused bad sequence
>     acquire: 0
>    acquired: 10
>   contended: 0
>     release: 0
> 
> 
> * VCPU#0 thread seems to wait indefinitely to get qemu_mutex_iothread_lock() to
> make any progress.

Heh, I don't know that I would describe "412 microseconds" as "indefinitely", but
it's certainly a long time, especially during boot.

> The proposed patch above to check 'events->nmi_pending' for non-zero value helps
> to fix this issue.
> 
> ...wdyt?

Piecing things together, the issue is I was wrong about the -EAGAIN exit being
benign.

 : Hmm, but even that should be benign unless userspace is stuffing other guest
 : state.  E.g. KVM will spuriously exit to userspace with -EAGAIN while the vCPU
 : is in KVM_MP_STATE_UNINITIALIZED, and I don't see a way for the vCPU to be put
 : into a blocking state after transitioning out of UNINITIATED via INIT+SIPI without
 : processing KVM_REQ_NMI.

QEMU responds to the spurious exit by bailing from the vCPU's inner runloop, and
when that happens, the associated task (briefly) acquires a global mutex, the
so called BQL (Big QEMU Lock).  I assumed that QEMU would eat the -EAGAIN and do
nothing interesting, but QEMU interprets the -EAGAIN as "there might be a global
state change the vCPU needs to handle".

As you discovered, having 9 vCPUs constantly acquiring and releasing a single
mutex makes for slow going when vCPU0 needs to acquire said mutex, e.g. to do
emulated MMIO.

Ah, and the other wrinkle is that KVM won't actually yield during KVM_RUN for
UNINITIALIZED vCPUs, i.e. all those vCPU tasks will stay at 100% utilization even
though there's nothing for them to do.  That may or may not matter in your case,
but it would be awful behavior in a setup with oversubscribed vCPUs.

I'm not 100% confident there isn't something else going on, e.g. a 400+ microsecond
wait time is a little odd, but this is inarguably a KVM regression and I doubt
it's worth anyone's time to dig deeper.

Can you give me a Signed-off-by for this?  I'll write a changelog and post a
proper patch.

# cat ~test/rpmbuild/SOURCES/linux-kernel-test.patch
+++ linux-5.14.0-372.el9/arch/x86/kvm/x86.c     2023-10-30
09:05:05.172815973 -0400
@@ -5277,7 +5277,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_e
        if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
                vcpu->arch.nmi_pending = 0;
                atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
-               kvm_make_request(KVM_REQ_NMI, vcpu);
+               if (events->nmi.pending)
+                       kvm_make_request(KVM_REQ_NMI, vcpu);
        }
        static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);

> PS: The kvm_make_request() routine has following comment, I wonder if
> this is what is happening with empty NMI events.
>          Request that don't require vCPU action should never be logged in
>          vcpu->requests.  The vCPU won't clear the request, so it will stay
>          logged indefinitely and prevent the vCPU from entering the guest.

Yeah, that's kinda sorta what's happening, although that comment is about requests
that are never cleared in *any* path, e.g. violation of that rule causes a vCPU
to be 100% stuck.

