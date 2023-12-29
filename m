Return-Path: <kvm+bounces-5321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B82AA820101
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 18:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46A111F21ECF
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 17:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E83D12E48;
	Fri, 29 Dec 2023 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VNh3pAeH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68112B66
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 17:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703872755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yeKqaIlvVPoYPC4W0RMtxJ/Ybm4HjQYyUHUu8GgGRhQ=;
	b=VNh3pAeHrqDP3AeaSnR8jPEDZupvbzYI7MjlxctridVynSQaS8kTudNfi7CpUACF8s/Ev4
	gVSZRayTTfDwRNUF33/L+OeI5oB5/fmJP3xqD7L3z2NeZ3cCEe4uATJRm6GRe1hcguRo/k
	gVw1g2IcPlJDKjAhFs+rRJzxOP7x2EQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-py8S3ZiJMg-SdOVqM8iEZQ-1; Fri, 29 Dec 2023 12:59:14 -0500
X-MC-Unique: py8S3ZiJMg-SdOVqM8iEZQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40d3f53ca2aso36989715e9.0
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 09:59:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703872752; x=1704477552;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yeKqaIlvVPoYPC4W0RMtxJ/Ybm4HjQYyUHUu8GgGRhQ=;
        b=mWoggfyhuQzr1vyZAqwYPT7gZajsVKXmsGPUR8kvJ9FqiX86s5x631HK2SwWyPQRfz
         xvPqC5VhU5TziPuwFg5huwB61A5u6t8WB/FSKmVgUzWTQ8yhLc3dLlIEmHRkq6+0JyzY
         jf/YZ+CpIdMKfZDx8gw77W2MWOsL2v2DeRAkRVxeHiCyumW3AuiRKt6oxdri4H9j1Vrr
         4T9KuIBdygsHoWawK7wlZr6hX9R6EWLnmMwAgB6bkdmIQ4v4ivFUbWYrKctpnRrGrhG+
         foH83fQNa+i4My66BOCDz9VKLHSor6sRP+yAAJz4a326ZSU/SNgCU/gUMLpqY6dEHjLJ
         QkuA==
X-Gm-Message-State: AOJu0YyTTUw/bX8d3l1VkTFKziKUjnLXltmVeKqHLi7uHc/ebujb7BBx
	mB6p9R0w4rh7N9DYUbYTl3TmcCZUAZcEeFO3XgVeTKTNJTJFzq1qQopUU4DdYBWldXwPis1JMBu
	BgZuIDYsUEKo49TN5q761bLXrgQzQSWWpzJkQ0xHISw5j
X-Received: by 2002:a05:600c:4fcc:b0:40d:5166:f08a with SMTP id o12-20020a05600c4fcc00b0040d5166f08amr4881314wmq.134.1703872752404;
        Fri, 29 Dec 2023 09:59:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4XYAdhzlSJ84JJ/WzhDuQ96mOPSB8f7l3hWPGmgxlugzFemQsCgqo6ZAvHVkBoJdvDXd+2f4GHras+R8DhBc=
X-Received: by 2002:a05:600c:4fcc:b0:40d:5166:f08a with SMTP id
 o12-20020a05600c4fcc00b0040d5166f08amr4881309wmq.134.1703872752069; Fri, 29
 Dec 2023 09:59:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAE8KmOw1DzOr-GvQ9E+Y5RCX1GQ1h1Bumk5pB++9=SjMUPHxBg@mail.gmail.com>
 <ZT_HeK7GXdY-6L3t@google.com> <CAE8KmOxKkojqrqWE1RMa4YY3=of1AEFcDth_6b2ZCHJHzb8nng@mail.gmail.com>
 <CAE8KmOxd-Xib+qfiiBepP-ydjSAn32gjOTdLLUqm-i5vgzTv8w@mail.gmail.com>
In-Reply-To: <CAE8KmOxd-Xib+qfiiBepP-ydjSAn32gjOTdLLUqm-i5vgzTv8w@mail.gmail.com>
From: Prasad Pandit <ppandit@redhat.com>
Date: Fri, 29 Dec 2023 23:28:55 +0530
Message-ID: <CAE8KmOyffXD4k69vRAFwesaqrBGzFY3i+kefbkHcQf4=jNYzOA@mail.gmail.com>
Subject: Fwd: About patch bdedff263132 - KVM: x86: Route pending NMIs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello Sean,

On Tue, 31 Oct 2023 at 17:45, Prasad Pandit <ppandit@redhat.com> wrote:
> On Mon, 30 Oct 2023 at 20:41, Sean Christopherson <seanjc@google.com> wrote:
>>> -               kvm_make_request(KVM_REQ_NMI, vcpu);
>>> +               if (events->nmi.pending)
>>> +                       kvm_make_request(KVM_REQ_NMI, vcpu);
> >
> > This looks sane, but it should be unnecessary as KVM_REQ_NMI nmi_queued=0 should
> > be a (costly) nop.  Hrm, unless the vCPU is in HLT, in which case KVM will treat
> > a spurious KVM_REQ_NMI as a wake event.  When I made this change, my assumption
> > was that userspace would set KVM_VCPUEVENT_VALID_NMI_PENDING iff there was
> > relevant information to process.  But if I'm reading the code correctly, QEMU
> > invokes KVM_SET_VCPU_EVENTS with KVM_VCPUEVENT_VALID_NMI_PENDING at the end of
> > machine creation.
> >

QEMU:
qemu_thread_start
 kvm_start_vcpu_thread
  kvm_vcpu_thread_fn
   kvm_cpu_exec
    kvm_arch_put_registers
     kvm_put_vcpu_events (cpu=..., level=1)

qemu_thread_start (args=0x559fdc852110) at ../util/qemu-thread-posix.c:534
 kvm_vcpu_thread_fn (arg=0x559fdc84cdc0) at ../accel/kvm/kvm-accel-ops.c:56
  qemu_wait_io_event (cpu=0x559fdc84cdc0) at ../softmmu/cpus.c:435
   qemu_wait_io_event_common (cpu=0x559fdc84cdc0) at ../softmmu/cpus.c:411
    process_queued_cpu_work (cpu=0x559fdc84cdc0) at ../cpus-common.c:351
     do_kvm_cpu_synchronize_post_reset (cpu=0x559fdc84cdc0, arg=...)
at ../accel/kvm/kvm-all.c:2808
      kvm_arch_put_registers (cpu=0x559fdc84cdc0, level=2) at
../target/i386/kvm/kvm.c:4664
       kvm_put_vcpu_events (cpu=0x559fdc84cdc0, level=2) at
../target/i386/kvm/kvm.c:4308

qemu_thread_start (args=0x559fdc852110) at ../util/qemu-thread-posix.c:534
 kvm_vcpu_thread_fn (arg=0x559fdc84cdc0) at ../accel/kvm/kvm-accel-ops.c:56
  qemu_wait_io_event (cpu=0x559fdc84cdc0) at ../softmmu/cpus.c:435
   qemu_wait_io_event_common (cpu=0x559fdc84cdc0) at ../softmmu/cpus.c:411
    process_queued_cpu_work (cpu=0x559fdc84cdc0) at ../cpus-common.c:351
     do_kvm_cpu_synchronize_post_init (cpu=0x559fdc84cdc0, arg=...) at
../accel/kvm/kvm-all.c:2819
      kvm_arch_put_registers (cpu=0x559fdc84cdc0, level=3) at
../target/i386/kvm/kvm.c:4664
       kvm_put_vcpu_events (cpu=0x559fdc84cdc0, level=3) at
../target/i386/kvm/kvm.c:4308

Kernel:
  kvm_vcpu_ioctl
   mutex_lock_killable(&vcpu->mutex)
    kvm_arch_vcpu_ioctl(, KVM_SET_VCPU_EVENTS, ... )
   mutex_unlock(&vcpu->mutex);
     -> kvm_vcpu_ioctl_x86_set_vcpu_events()

* Above are 3 different ways in which KVM_SET_VCPU_EVENTS ioctl(2) gets called.
        QEMU/target/i386/kvm/kvm.c: kvm_put_vcpu_events()
         if (level >= KVM_PUT_RESET_STATE) {
             events.flags |= KVM_VCPUEVENT_VALID_NMI_PENDING;
  But KVM_VCPUEVENT_VALID_NMI_PENDING is set only when level >=
2(KVM_PUT_RESET_STATE). ie. in the first (level=1) case _NMI_PENDING
is not set.

* In the real-time host set-up I have, KVM_VCPUEVENT_VALID_NMI_PENDING
is called twice for each VCPU and after that kernel goes into what
looks like a lock contention loop. Each time
KVM_VCPUEVENT_VALID_NMI_PENDING is called with 'cpu->env->nmi_injected
= 0' and  'cpu->env->nmi_pending = 0'.  ie. for each VCPU two NMI
events are injected via - kvm_make_request(KVM_REQ_NMI, vcpu), when
vcpu has no NMIs pending.

# perf lock report -t
                Name   acquired  contended     avg wait   total wait
  max wait     min wait

           CPU 3/KVM     154017     154017     62.19 us      9.58 s
 101.01 us      1.49 us
           CPU 9/KVM     152796     152796     62.67 us      9.58 s
  95.92 us      1.49 us
           CPU 7/KVM     151554     151554     63.16 us      9.57 s
 102.70 us      1.48 us
           CPU 1/KVM     151273     151273     65.30 us      9.88 s
  98.88 us      1.52 us
           CPU 6/KVM     151107     151107     63.34 us      9.57 s
 107.64 us      1.50 us
           CPU 8/KVM     151038     151038     63.37 us      9.57 s
 102.93 us      1.51 us
           CPU 2/KVM     150701     150701     63.52 us      9.57 s
  99.24 us      1.50 us
           CPU 5/KVM     150695     150695     63.56 us      9.58 s
 142.15 us      1.50 us
           CPU 4/KVM     150527     150527     63.60 us      9.57 s
 102.04 us      1.44 us
     qemu-system-x86        665        665     65.92 us     43.84 ms
 100.67 us      1.55 us
           CPU 0/KVM             2          2    210.46 us    420.92
us    411.89 us      9.03 us
     qemu-system-x86          1          1    404.91 us    404.91 us
 404.91 us    404.91 us
        TC tc-pc.ram               1          1    414.22 us    414.22
us    414.22 us    414.22 us
  === output for debug===
bad: 10, total: 13
bad rate: 76.92 %
histogram of events caused bad sequence
    acquire: 0
   acquired: 10
  contended: 0
    release: 0


* VCPU#0 thread seems to wait indefinitely to get
qemu_mutex_iothread_lock() to make any progress. The proposed patch
above to check 'events->nmi_pending' for non-zero value helps to fix
this issue.

...wdyt?

Thank you.
---
  - Prasad
PS: The kvm_make_request() routine has following comment, I wonder if
this is what is happening with empty NMI events.
         Request that don't require vCPU action should never be logged in
         vcpu->requests.  The vCPU won't clear the request, so it will stay
         logged indefinitely and prevent the vCPU from entering the guest.


