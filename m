Return-Path: <kvm+bounces-4574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31EFC814A95
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 574501C23396
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27A11E52A;
	Fri, 15 Dec 2023 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="r1fNm65C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF771C29
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6d9dc789f23so610203a34.3
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 06:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702650882; x=1703255682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kCRrQ4qzCxFO8CXRtBozslrzSmbi/SlmRIdStHjuHc=;
        b=r1fNm65CrRMlhy5vipf6JeZj8Txk0jj5bJDPvtP1O55yiBiU4aE6HY5yoTmSVj/v/c
         ytoto/7UAqYR1XyXh5kEuHdMzrEtb3VAdrMZ6DJHDkaI/E1VTojqDjz0IFSGMhqKYPwY
         cwJvArujZ6ooGj3+6UJZHcg4fwiXx2eMjZXPEdt5Z0U3GtXM4VcL1y795s60hsLyEoOi
         kp2VKRJN3bVVcASMe8ojWARykiNjQ1DWl3ajy/UBFY9wrEobfKwjHQ8kTu7QNWpPpMDx
         qStoGQlsr9r8DOuUgVDRl0AG6J21njrmCuW62TGB0zDnyDNfs2PpnnfDNE2KmWMObgmz
         mYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702650882; x=1703255682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kCRrQ4qzCxFO8CXRtBozslrzSmbi/SlmRIdStHjuHc=;
        b=s0gOew9V8URUb51HVJ9vNBE+AlBYzLKJnkpoJBAMs69M1g53IwFVEqc+0FDchiGfXJ
         sjXl+BDdyA+Nqgb7HeICT6ONZmcN2XnFOhFnaL6QI7nfXpU3oD2aDxJYXZY1o2RpsPoJ
         IHjAWBJ0RXDiN/jaWq9Wt1+99leuf4+RkfR84427zPMpNpWtCW9ZQneL5x74j9CHUYEt
         h+Qjyi6UVovcFE1ftP7DtP6ahlKSXcEkB7PCHd7qRKVell21LktGGXFCujkT4cpOPOaq
         +4qlcuUG9GAyTFl8y4V67eX2hSBqjEapwA8N0jNAvV6rvl9R2itRtgjMRL7j4R7oNjVU
         Ohaw==
X-Gm-Message-State: AOJu0YyZ3CZipag5BYkcAwpiTlM4D7/P/ce5DcumOZAFUksvijUavm6Z
	y7P8fiutkQnymeCnEsJXrJcK7YgjntDAYGPf3a6rJw==
X-Google-Smtp-Source: AGHT+IHNyMKSgoigIvPUwTuAwpIUW7vtMA2r7qyq9s+SeM8a3bIzNl6GHkunX/sRz1iWP8NJY/9/HNvdiD9ZUcRzHRk=
X-Received: by 2002:a05:6830:1e7b:b0:6da:4f16:4f5a with SMTP id
 m27-20020a0568301e7b00b006da4f164f5amr763203otr.11.1702650881933; Fri, 15 Dec
 2023 06:34:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAO7JXPhQ3zPzsNeuUphLx7o_+DOfJrmCoyRXXjcQMEzrKnGc9g@mail.gmail.com>
 <ZXuiM7s7LsT5hL3_@google.com>
In-Reply-To: <ZXuiM7s7LsT5hL3_@google.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Fri, 15 Dec 2023 09:34:31 -0500
Message-ID: <CAO7JXPik9eMgef6amjCk5JPeEhg66ghDXowWQESBrd_fAaEsCA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > >
> > I get your point. A generic way would have been more preferable, but I
> > feel the scenario we are tackling is a bit more time critical and kvm
> > is better equipped to handle this. kvm has control over the VM/vcpu
> > execution and hence it can take action in the most effective way.
>
> No, KVM most definitely does not.  Between sched, KVM, and userspace, I w=
ould
> rank KVM a very distant third.  Userspace controls when to do KVM_RUN, to=
 which
> cgroup(s) a vCPU task is assigned, the affinity of the task, etc.  sched =
decides
> when and where to run a vCPU task based on input from userspace.
>
> Only in some edge cases that are largely unique to overcommitted CPUs doe=
s KVM
> have any input on scheduling whatsoever.   And even then, KVM's view is l=
argely
> limited to a single VM, e.g. teaching KVM to yield to a vCPU running in a=
 different
> VM would be interesting, to say the least.
>
Over committed case is exactly what we are trying to tackle. Sorry for
not making this clear in the cover letter. ChromeOS runs on low-end
devices (eg: 2C/2T cpus) and does not have enough compute capacity to
offload scheduling decisions. In-band scheduling decisions gave the
best results.

> > One example is the place where we handle boost/unboost. By the time
> > you come out of kvm to userspace it would be too late.
>
> Making scheduling decisions in userspace doesn't require KVM to exit to u=
serspace.
> It doesn't even need to require a VM-Exit to KVM.  E.g. if the scheduler =
(whether
> it's in kernel or userspace) is running on a different logical CPU(s), th=
en there's
> no need to trigger a VM-Exit because the scheduler can incorporate inform=
ation
> about a vCPU in real time, and interrupt the vCPU if and only if somethin=
g else
> needs to run on that associated CPU.  From the sched_ext cover letter:
>
>  : Google has also experimented with some promising, novel scheduling pol=
icies.
>  : One example is =E2=80=9Ccentral=E2=80=9D scheduling, wherein a single =
CPU makes all
>  : scheduling decisions for the entire system. This allows most cores on =
the
>  : system to be fully dedicated to running workloads, and can have signif=
icant
>  : performance improvements for certain use cases. For example, central
>  : scheduling with VCPUs can avoid expensive vmexits and cache flushes, b=
y
>  : instead delegating the responsibility of preemption checks from the ti=
ck to
>  : a single CPU. See scx_central.bpf.c for a simple example of a central
>  : scheduling policy built in sched_ext.
>
This makes sense when the host has enough compute resources for
offloading scheduling decisions. In an over committed system, the
scheduler running out-of-band would need to get cpu time to make
decisions and starvation of scheduler may make the situation worse. We
could probably tune the priorities of the scheduler to have least
latencies, but in our experience this was not scaling due to the
nature of cpu interruptions happening in a consumer devices..

> > Currently we apply the boost soon after VMEXIT before enabling preempti=
on so
> > that the next scheduler entry will consider the boosted priority. As so=
on as
> > you enable preemption, the vcpu could be preempted and boosting would n=
ot
> > help when it is boosted. This timing correctness is very difficult to a=
chieve
> > if we try to do it in userland or do it out-of-band.
>
> Hooking VM-Exit isn't necessarily the fastest and/or best time to make sc=
heduling
> decisions about vCPUs.  Presumably the whole point of this is to allow ru=
nning
> high priority, latency senstive workloads in the guest.  As above, the id=
eal scenario
> is that a vCPU running a high priority workload would never exit in the f=
irst place.
>
> Is it easy to get there?  No.  But it's definitely possible.
>
Low end devices do not have the luxury of dedicating physical cpus to
vcpus and having an out-of-band scheduler also adds to the load of the
system. In this RFC, a boost request doesn't induce an immeidate
VMEXIT, but just sets a shared memory flag and continues to run. On
the very next VMEXIT, kvm checks the shared memory and passes it to
scheduler. This technique allows for avoiding extra VMEXITs for
boosting, but still uses the fast in-band scheduling mechanism to
achieve the desired results.

> > [...snip...]
> > > > > Lastly, if the concern/argument is that userspace doesn't have th=
e right knobs
> > > > > to (quickly) boost vCPU tasks, then the proposed sched_ext functi=
onality seems
> > > > > tailor made for the problems you are trying to solve.
> > > > >
> > > > > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.or=
g
> > > > >
> > > > You are right, sched_ext is a good choice to have policies
> > > > implemented. In our case, we would need a communication mechanism a=
s
> > > > well and hence we thought kvm would work best to be a medium betwee=
n
> > > > the guest and the host.
> > >
> > > Making KVM be the medium may be convenient and the quickest way to ge=
t a PoC
> > > out the door, but effectively making KVM a middle-man is going to be =
a huge net
> > > negative in the long term.  Userspace can communicate with the guest =
just as
> > > easily as KVM, and if you make KVM the middle-man, then you effective=
ly *must*
> > > define a relatively rigid guest/host ABI.
> > >
> > > If instead the contract is between host userspace and the guest, the =
ABI can be
> > > much more fluid, e.g. if you (or any setup) can control at least some=
 amount of
> > > code that runs in the guest, then the contract between the guest and =
host doesn't
> > > even need to be formally defined, it could simply be a matter of bund=
ling host
> > > and guest code appropriately.
> > >
> > > If you want to land support for a given contract in upstream reposito=
ries, e.g.
> > > to broadly enable paravirt scheduling support across a variety of use=
rsepace VMMs
> > > and/or guests, then yeah, you'll need a formal ABI.  But that's still=
 not a good
> > > reason to have KVM define the ABI.  Doing it in KVM might be a wee bi=
t easier because
> > > it's largely just a matter of writing code, and LKML provides a centr=
alized channel
> > > for getting buyin from all parties.  But defining an ABI that's indep=
endent of the
> > > kernel is absolutely doable, e.g. see the many virtio specs.
> > >
> > > I'm not saying KVM can't help, e.g. if there is information that is k=
nown only
> > > to KVM, but the vast majority of the contract doesn't need to be defi=
ned by KVM.
> > >
> > As you mentioned, custom contract between guest and host userspace is
> > really flexible, but I believe tackling scheduling(especially latency)
> > issues is a bit more difficult with generic approaches. Here kvm does
> > have some information known only to kvm(which could be shared - eg:
> > interrupt injection) but more importantly kvm has some unique
> > capabilities when it comes to scheduling. kvm and scheduler are
> > cooperating currently for various cases like, steal time accounting,
> > vcpu preemption state, spinlock handling etc. We could possibly try to
> > extend it a little further in a non-intrusive way.
>
> I'm not too worried about the code being intrusive, I'm worried about the
> maintainability, longevity, and applicability of this approach.
>
> IMO, this has a significantly lower ceiling than what is possible with so=
mething
> like sched_ext, e.g. it requires a host tick to make scheduling decisions=
, and
> because it'd require a kernel-defined ABI, would essentially be limited t=
o knobs
> that are broadly useful.  I.e. every bit of information that you want to =
add to
> the guest/host ABI will need to get approval from at least the affected s=
ubsystems
> in the guest, from KVM, and possibly from the host scheduler too.  That's=
 going
> to make for a very high bar.
>
Just thinking out  loud, The ABI could be very simple to start with. A
shared page with dedicated guest and host areas. Guest fills details
about its priority requirements, host fills details about the actions
it took(boost/unboost, priority/sched class etc). Passing this
information could be in-band or out-of-band. out-of-band could be used
by dedicated userland schedulers. If both guest and host agrees on
in-band during guest startup, kvm could hand over the data to
scheduler using a scheduler callback. I feel this small addition to
kvm could be maintainable and by leaving the protocol for interpreting
shared memory to guest and host, this would be very generic and cater
to multiple use cases. Something like above could be used both by
low-end devices and high-end server like systems and guest and host
could have custom protocols to interpret the data and make decisions.

In this RFC, we have a miniature form of the above, where we have a
shared memory area and the scheduler callback is basically
sched_setscheduler. But it could be made very generic as part of ABI
design. For out-of-band schedulers, this call back could be setup by
sched_ext, a userland scheduler and any similar out-of-band scheduler.

I agree, getting a consensus and approval is non-trivial. IMHO, this
use case is compelling for such an ABI because out-of-band schedulers
might not give the desired results for low-end devices.

> > Having a formal paravirt scheduling ABI is something we would want to
> > pursue (as I mentioned in the cover letter) and this could help not
> > only with latencies, but optimal task placement for efficiency, power
> > utilization etc. kvm's role could be to set the stage and share
> > information with minimum delay and less resource overhead.
>
> Making KVM middle-man is most definitely not going to provide minimum del=
ay or
> overhead.  Minimum delay would be the guest directly communicating with t=
he host
> scheduler.  I get that convincing the sched folks to add a bunch of parav=
irt
> stuff is a tall order (for very good reason), but that's exactly why I Cc=
'd the
> sched_ext folks.
>
As mentioned above, guest directly talking to host scheduler without
involving kvm would mean an out-of-band scheduler and the
effectiveness depends on how fast the scheduler gets to run. In lowend
compute devices, that would pose a challenge. In such scenarios, kvm
seems to be a better option to provide minimum delay and cpu overhead.

Sorry for not being clear in the cover letter, the goal is to have a
minimal latency and overhead framework that would work for low-end
devices as well where we have constrained cpu capacity. A design with
focus on the constraints of systems with not enough compute capacity
to spare, but caters to generic use cases as well is what we are
striving for. This would be useful for cloud providers whose offerings
are mostly over-committed VMs and we have seen interest from such
crowd.

Thanks,
Vineeth

