Return-Path: <kvm+bounces-4543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE023813ED2
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 01:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 336C01F22C47
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 00:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F36A809;
	Fri, 15 Dec 2023 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D/ezQFnb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA549363
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 00:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-db7dd9a8bd6so120700276.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 16:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702601269; x=1703206069; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J/OqsU/wKLZASXzbR9+FvmNwQRC2skgcu27wx2pyGOk=;
        b=D/ezQFnbztLQk90UqjM6w7qI3F3l3NMP17lxOWt/K12lv4vIlDMTfX7g9LVinyZIdq
         K2gc70HEs2m6olRfdWuAIqgGbisxEZyDZoezCKarDt3EhTbpxZqDYohpe2xvaaGaKIeC
         Ve3guYraFNYcDYMKevtSY+AlBS+AaXClmTiNgwHTkhPnqPbm9nQtTXSNC4ImC1vq0WFr
         FOM5slsTJ38DA6jiy0/Ft9sLfK5MIsTYQUPO3hQ+9hW0S92y4m+TqXMQIxxcgbvseLli
         zv1u+Q2je8VPkexYe9DLSou5SgTka5wDdeEor436NQ9zXP0I5zJCF5GmyPVuspFdEM+9
         glmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702601269; x=1703206069;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J/OqsU/wKLZASXzbR9+FvmNwQRC2skgcu27wx2pyGOk=;
        b=X6LDRJT9+mzmAwbFAINz13Sa6sw3K017rl1NSWgyAvOarNT92iAjJKNylNSqcOMICi
         IHH3g2nvEBJqCgGp/OiyOTjKFlB9rHpBz5RdqGYRTRPnwrGiQo6WIRETkscVJQsR6PGl
         F8yzO2Ert6rNIA22qgT64i9ZPDbH7MeMiI0t9S/U0ApWGAykHVLrr+cNjLT25p5jpH3V
         y5lpojKFDIbTc4Qx6G2o676gImQaHKaw2tkjEA1wFdMx3KHIOQ2USvd47zLMTqjGnU/a
         qZc4CkR7f3DC4Se57PJXCg+DPqx8m6vZmc3O2shQQgmzF/CeB71imwRK6IZ67fLare1f
         wCxw==
X-Gm-Message-State: AOJu0YxyprG/zX/K/YA4fRIz/62V98WYYRI0e9+/U/04m/q9TlmBa7Vf
	d1BdX6jhdV0xmMGU87ZogwTM81/gZVE=
X-Google-Smtp-Source: AGHT+IHCTrULdWUnuMZ3DE3sjKqJ0QjQ3AsQRHIFsQZLGwiEy5A8Nj70e5TPwcElCWV0m7/BeSSDs+5Svmo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:86ce:0:b0:dbc:d2e9:39e7 with SMTP id
 y14-20020a2586ce000000b00dbcd2e939e7mr36518ybm.10.1702601268729; Thu, 14 Dec
 2023 16:47:48 -0800 (PST)
Date: Thu, 14 Dec 2023 16:47:47 -0800
In-Reply-To: <CAO7JXPhQ3zPzsNeuUphLx7o_+DOfJrmCoyRXXjcQMEzrKnGc9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAO7JXPhQ3zPzsNeuUphLx7o_+DOfJrmCoyRXXjcQMEzrKnGc9g@mail.gmail.com>
Message-ID: <ZXuiM7s7LsT5hL3_@google.com>
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

On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> On Thu, Dec 14, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> > > On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > Now when I think about it, the implementation seems to
> > > suggest that we are putting policies in kvm. Ideally, the goal is:
> > > - guest scheduler communicates the priority requirements of the workl=
oad
> > > - kvm applies the priority to the vcpu task.
> >
> > Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if the =
problem
> > is that userspace doesn't have the right knobs to adjust the priority o=
f a task
> > quickly and efficiently, then wouldn't it be better to solve that probl=
em in a
> > generic way?
> >
> I get your point. A generic way would have been more preferable, but I
> feel the scenario we are tackling is a bit more time critical and kvm
> is better equipped to handle this. kvm has control over the VM/vcpu
> execution and hence it can take action in the most effective way.

No, KVM most definitely does not.  Between sched, KVM, and userspace, I wou=
ld
rank KVM a very distant third.  Userspace controls when to do KVM_RUN, to w=
hich
cgroup(s) a vCPU task is assigned, the affinity of the task, etc.  sched de=
cides
when and where to run a vCPU task based on input from userspace.

Only in some edge cases that are largely unique to overcommitted CPUs does =
KVM
have any input on scheduling whatsoever.   And even then, KVM's view is lar=
gely
limited to a single VM, e.g. teaching KVM to yield to a vCPU running in a d=
ifferent
VM would be interesting, to say the least.

> One example is the place where we handle boost/unboost. By the time
> you come out of kvm to userspace it would be too late.=20

Making scheduling decisions in userspace doesn't require KVM to exit to use=
rspace.
It doesn't even need to require a VM-Exit to KVM.  E.g. if the scheduler (w=
hether
it's in kernel or userspace) is running on a different logical CPU(s), then=
 there's
no need to trigger a VM-Exit because the scheduler can incorporate informat=
ion
about a vCPU in real time, and interrupt the vCPU if and only if something =
else
needs to run on that associated CPU.  From the sched_ext cover letter:

 : Google has also experimented with some promising, novel scheduling polic=
ies.
 : One example is =E2=80=9Ccentral=E2=80=9D scheduling, wherein a single CP=
U makes all
 : scheduling decisions for the entire system. This allows most cores on th=
e
 : system to be fully dedicated to running workloads, and can have signific=
ant
 : performance improvements for certain use cases. For example, central
 : scheduling with VCPUs can avoid expensive vmexits and cache flushes, by
 : instead delegating the responsibility of preemption checks from the tick=
 to
 : a single CPU. See scx_central.bpf.c for a simple example of a central
 : scheduling policy built in sched_ext.

> Currently we apply the boost soon after VMEXIT before enabling preemption=
 so
> that the next scheduler entry will consider the boosted priority. As soon=
 as
> you enable preemption, the vcpu could be preempted and boosting would not
> help when it is boosted. This timing correctness is very difficult to ach=
ieve
> if we try to do it in userland or do it out-of-band.

Hooking VM-Exit isn't necessarily the fastest and/or best time to make sche=
duling
decisions about vCPUs.  Presumably the whole point of this is to allow runn=
ing
high priority, latency senstive workloads in the guest.  As above, the idea=
l scenario
is that a vCPU running a high priority workload would never exit in the fir=
st place.

Is it easy to get there?  No.  But it's definitely possible.

> [...snip...]
> > > > Lastly, if the concern/argument is that userspace doesn't have the =
right knobs
> > > > to (quickly) boost vCPU tasks, then the proposed sched_ext function=
ality seems
> > > > tailor made for the problems you are trying to solve.
> > > >
> > > > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
> > > >
> > > You are right, sched_ext is a good choice to have policies
> > > implemented. In our case, we would need a communication mechanism as
> > > well and hence we thought kvm would work best to be a medium between
> > > the guest and the host.
> >
> > Making KVM be the medium may be convenient and the quickest way to get =
a PoC
> > out the door, but effectively making KVM a middle-man is going to be a =
huge net
> > negative in the long term.  Userspace can communicate with the guest ju=
st as
> > easily as KVM, and if you make KVM the middle-man, then you effectively=
 *must*
> > define a relatively rigid guest/host ABI.
> >
> > If instead the contract is between host userspace and the guest, the AB=
I can be
> > much more fluid, e.g. if you (or any setup) can control at least some a=
mount of
> > code that runs in the guest, then the contract between the guest and ho=
st doesn't
> > even need to be formally defined, it could simply be a matter of bundli=
ng host
> > and guest code appropriately.
> >
> > If you want to land support for a given contract in upstream repositori=
es, e.g.
> > to broadly enable paravirt scheduling support across a variety of users=
epace VMMs
> > and/or guests, then yeah, you'll need a formal ABI.  But that's still n=
ot a good
> > reason to have KVM define the ABI.  Doing it in KVM might be a wee bit =
easier because
> > it's largely just a matter of writing code, and LKML provides a central=
ized channel
> > for getting buyin from all parties.  But defining an ABI that's indepen=
dent of the
> > kernel is absolutely doable, e.g. see the many virtio specs.
> >
> > I'm not saying KVM can't help, e.g. if there is information that is kno=
wn only
> > to KVM, but the vast majority of the contract doesn't need to be define=
d by KVM.
> >
> As you mentioned, custom contract between guest and host userspace is
> really flexible, but I believe tackling scheduling(especially latency)
> issues is a bit more difficult with generic approaches. Here kvm does
> have some information known only to kvm(which could be shared - eg:
> interrupt injection) but more importantly kvm has some unique
> capabilities when it comes to scheduling. kvm and scheduler are
> cooperating currently for various cases like, steal time accounting,
> vcpu preemption state, spinlock handling etc. We could possibly try to
> extend it a little further in a non-intrusive way.

I'm not too worried about the code being intrusive, I'm worried about the
maintainability, longevity, and applicability of this approach.

IMO, this has a significantly lower ceiling than what is possible with some=
thing
like sched_ext, e.g. it requires a host tick to make scheduling decisions, =
and
because it'd require a kernel-defined ABI, would essentially be limited to =
knobs
that are broadly useful.  I.e. every bit of information that you want to ad=
d to
the guest/host ABI will need to get approval from at least the affected sub=
systems
in the guest, from KVM, and possibly from the host scheduler too.  That's g=
oing
to make for a very high bar.

> Having a formal paravirt scheduling ABI is something we would want to
> pursue (as I mentioned in the cover letter) and this could help not
> only with latencies, but optimal task placement for efficiency, power
> utilization etc. kvm's role could be to set the stage and share
> information with minimum delay and less resource overhead.

Making KVM middle-man is most definitely not going to provide minimum delay=
 or
overhead.  Minimum delay would be the guest directly communicating with the=
 host
scheduler.  I get that convincing the sched folks to add a bunch of paravir=
t
stuff is a tall order (for very good reason), but that's exactly why I Cc'd=
 the
sched_ext folks.

> We could use schedulers (vanilla, sched_ext, ...) to actually make decisi=
ons
> based on the information it receives.

