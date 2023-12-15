Return-Path: <kvm+bounces-4580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3580A814DB0
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 17:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A09241F253FD
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 16:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EF145C09;
	Fri, 15 Dec 2023 16:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l/prYTqF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8132245BE5
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-db410931c23so768096276.2
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 08:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702659419; x=1703264219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tedB6dzGtFnZ2/TTckAyrV84Fj9w//nedimy7msq/vI=;
        b=l/prYTqFnj/8QUIraDNSix/1WvD9o3qpSQzlfGPhZ9nezjQ63oYlk5PcH8nnfI8t2U
         V0vVJXuNSOOZp/Hj+PtSAxwpjwm7bDOfE7LNraM5CzYOm3cN3GBz6XXlznKrRP+T8U0E
         kHD1Lact0a5WwW/czjzPNsXwV4gqwSXYAmTIVH6+vutglQPl7IMlIis57Nk3X3whmaKo
         VnnuYVMKVwXPBmRUVJ1dEgr80tLXxfQcYUdtHBGnhkSbqM8PuAUAdaUA3odGwJ80xEtW
         phvqGHDK+KZOqnJ0BUvrj/RhrmoN9M/TTkIj9j0AxuBkQOIexvpTOdkFM6XoBe6Bclz7
         QsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702659419; x=1703264219;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tedB6dzGtFnZ2/TTckAyrV84Fj9w//nedimy7msq/vI=;
        b=Y/ODFt8qGrOBp7+gEU405bGXiXlxnWneguZW+nE/YEP0dbtGlvFLSreKrfR3iI8L0r
         bH99Gm1zjomSVHiWWg7CG/AX+SI1GPIm94UZhQRCFOL+Zb9P1GKBznv06z/3uJhWgfrn
         OrAVjG6phnBhXxwW8xhYjVzjx/gXdNEPrjj4wWa0CZbDiyGyDEMTqC8LNYzBapJMxmxX
         jDBdDNiFw89yebfkLmvgwpSJlJoQWVK4Ln/YNmRm9COOn8xEXy8hIeuc+KXnY9ZZGHzQ
         TbpP8j8Zt/aQ4MEVTeA9MG9vU/ebGL8ZnySA1DxekOHK9BzNfQc9F3jjdh3EAom40QjL
         jp6A==
X-Gm-Message-State: AOJu0YyGdl0OnF7xuvt4FMHTCcYWJwURqPS51UAUaa9Myk9DJDZdO67d
	xCzcNQq9YHZZ1XSYbzTmqg67462+vB8=
X-Google-Smtp-Source: AGHT+IHVIw5v9gkKRIyDQB+tzsM2jhf1AroENr4CCUApEftHVR60jPLwilhj6NINZ/rxmZnW3lio+y8QeLA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:28a:b0:daf:5829:5b68 with SMTP id
 v10-20020a056902028a00b00daf58295b68mr96578ybh.7.1702659419487; Fri, 15 Dec
 2023 08:56:59 -0800 (PST)
Date: Fri, 15 Dec 2023 08:56:57 -0800
In-Reply-To: <CAO7JXPik9eMgef6amjCk5JPeEhg66ghDXowWQESBrd_fAaEsCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAO7JXPhQ3zPzsNeuUphLx7o_+DOfJrmCoyRXXjcQMEzrKnGc9g@mail.gmail.com>
 <ZXuiM7s7LsT5hL3_@google.com> <CAO7JXPik9eMgef6amjCk5JPeEhg66ghDXowWQESBrd_fAaEsCA@mail.gmail.com>
Message-ID: <ZXyFWTSU3KRk7EtQ@google.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
From: Sean Christopherson <seanjc@google.com>
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>, 
	Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023, Vineeth Remanan Pillai wrote:
> > > >
> > > I get your point. A generic way would have been more preferable, but =
I
> > > feel the scenario we are tackling is a bit more time critical and kvm
> > > is better equipped to handle this. kvm has control over the VM/vcpu
> > > execution and hence it can take action in the most effective way.
> >
> > No, KVM most definitely does not.  Between sched, KVM, and userspace, I=
 would
> > rank KVM a very distant third.  Userspace controls when to do KVM_RUN, =
to which
> > cgroup(s) a vCPU task is assigned, the affinity of the task, etc.  sche=
d decides
> > when and where to run a vCPU task based on input from userspace.
> >
> > Only in some edge cases that are largely unique to overcommitted CPUs d=
oes KVM
> > have any input on scheduling whatsoever.   And even then, KVM's view is=
 largely
> > limited to a single VM, e.g. teaching KVM to yield to a vCPU running in=
 a different
> > VM would be interesting, to say the least.
> >
> Over committed case is exactly what we are trying to tackle.

Yes, I know.  I was objecting to the assertion that "kvm has control over t=
he
VM/vcpu execution and hence it can take action in the most effective way". =
 In
overcommit use cases, KVM has some *influence*, and in non-overcommit use c=
ases,
KVM is essentially not in the picture at all.

> Sorry for not making this clear in the cover letter. ChromeOS runs on low=
-end
> devices (eg: 2C/2T cpus) and does not have enough compute capacity to
> offload scheduling decisions. In-band scheduling decisions gave the
> best results.
>=20
> > > One example is the place where we handle boost/unboost. By the time
> > > you come out of kvm to userspace it would be too late.
> >
> > Making scheduling decisions in userspace doesn't require KVM to exit to=
 userspace.
> > It doesn't even need to require a VM-Exit to KVM.  E.g. if the schedule=
r (whether
> > it's in kernel or userspace) is running on a different logical CPU(s), =
then there's
> > no need to trigger a VM-Exit because the scheduler can incorporate info=
rmation
> > about a vCPU in real time, and interrupt the vCPU if and only if someth=
ing else
> > needs to run on that associated CPU.  From the sched_ext cover letter:
> >
> >  : Google has also experimented with some promising, novel scheduling p=
olicies.
> >  : One example is =E2=80=9Ccentral=E2=80=9D scheduling, wherein a singl=
e CPU makes all
> >  : scheduling decisions for the entire system. This allows most cores o=
n the
> >  : system to be fully dedicated to running workloads, and can have sign=
ificant
> >  : performance improvements for certain use cases. For example, central
> >  : scheduling with VCPUs can avoid expensive vmexits and cache flushes,=
 by
> >  : instead delegating the responsibility of preemption checks from the =
tick to
> >  : a single CPU. See scx_central.bpf.c for a simple example of a centra=
l
> >  : scheduling policy built in sched_ext.
> >
> This makes sense when the host has enough compute resources for
> offloading scheduling decisions.

Yeah, again, I know.  The point I am trying to get across is that this RFC =
only
benefits/handles one use case, and doesn't have line of sight to being exte=
nsible
to other use cases.

> > > As you mentioned, custom contract between guest and host userspace is
> > > really flexible, but I believe tackling scheduling(especially latency=
)
> > > issues is a bit more difficult with generic approaches. Here kvm does
> > > have some information known only to kvm(which could be shared - eg:
> > > interrupt injection) but more importantly kvm has some unique
> > > capabilities when it comes to scheduling. kvm and scheduler are
> > > cooperating currently for various cases like, steal time accounting,
> > > vcpu preemption state, spinlock handling etc. We could possibly try t=
o
> > > extend it a little further in a non-intrusive way.
> >
> > I'm not too worried about the code being intrusive, I'm worried about t=
he
> > maintainability, longevity, and applicability of this approach.
> >
> > IMO, this has a significantly lower ceiling than what is possible with =
something
> > like sched_ext, e.g. it requires a host tick to make scheduling decisio=
ns, and
> > because it'd require a kernel-defined ABI, would essentially be limited=
 to knobs
> > that are broadly useful.  I.e. every bit of information that you want t=
o add to
> > the guest/host ABI will need to get approval from at least the affected=
 subsystems
> > in the guest, from KVM, and possibly from the host scheduler too.  That=
's going
> > to make for a very high bar.
> >
> Just thinking out  loud, The ABI could be very simple to start with. A
> shared page with dedicated guest and host areas. Guest fills details
> about its priority requirements, host fills details about the actions
> it took(boost/unboost, priority/sched class etc). Passing this
> information could be in-band or out-of-band. out-of-band could be used
> by dedicated userland schedulers. If both guest and host agrees on
> in-band during guest startup, kvm could hand over the data to
> scheduler using a scheduler callback. I feel this small addition to
> kvm could be maintainable and by leaving the protocol for interpreting
> shared memory to guest and host, this would be very generic and cater
> to multiple use cases. Something like above could be used both by
> low-end devices and high-end server like systems and guest and host
> could have custom protocols to interpret the data and make decisions.
>=20
> In this RFC, we have a miniature form of the above, where we have a
> shared memory area and the scheduler callback is basically
> sched_setscheduler. But it could be made very generic as part of ABI
> design. For out-of-band schedulers, this call back could be setup by
> sched_ext, a userland scheduler and any similar out-of-band scheduler.
>=20
> I agree, getting a consensus and approval is non-trivial. IMHO, this
> use case is compelling for such an ABI because out-of-band schedulers
> might not give the desired results for low-end devices.
>=20
> > > Having a formal paravirt scheduling ABI is something we would want to
> > > pursue (as I mentioned in the cover letter) and this could help not
> > > only with latencies, but optimal task placement for efficiency, power
> > > utilization etc. kvm's role could be to set the stage and share
> > > information with minimum delay and less resource overhead.
> >
> > Making KVM middle-man is most definitely not going to provide minimum d=
elay or
> > overhead.  Minimum delay would be the guest directly communicating with=
 the host
> > scheduler.  I get that convincing the sched folks to add a bunch of par=
avirt
> > stuff is a tall order (for very good reason), but that's exactly why I =
Cc'd the
> > sched_ext folks.
> >
> As mentioned above, guest directly talking to host scheduler without
> involving kvm would mean an out-of-band scheduler and the
> effectiveness depends on how fast the scheduler gets to run.

No, the "host scheduler" could very well be a dedicated in-kernel paravirt
scheduler.  It could be a sched_ext BPF program that for all intents and pu=
rposes
is in-band.

You are basically proposing that KVM bounce-buffer data between guest and h=
ost.
I'm saying there's no _technical_ reason to use a bounce-buffer, just do ze=
ro copy.

> In lowend compute devices, that would pose a challenge. In such scenarios=
, kvm
> seems to be a better option to provide minimum delay and cpu overhead.

