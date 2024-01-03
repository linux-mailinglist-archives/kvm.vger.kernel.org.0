Return-Path: <kvm+bounces-5593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B9D82362C
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 21:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1C121F2562F
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 20:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09EE1D539;
	Wed,  3 Jan 2024 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="iP5B2JSV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F76B1D522
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 20:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7811c02cfecso708877385a.2
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 12:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1704312551; x=1704917351; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pM/8dQfYS9UuYC/k2nrRJhStfDT3AcSvNyR2TpRbd0w=;
        b=iP5B2JSVTUDaFhZSQQ7ubaw5kIOmh2mtr6VMQA9xuaImDIUUcUXslCNF133QBbteJW
         SgOwsV9PsTa4W0L9a8sr3gqxC2lkx8B9Lp617BOjkwm55OVNS6VVZIZIyc02yS1udIcd
         eCsv7NjeP0IOG+ExYspPvkmO/9IcMIHFWu9UQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704312551; x=1704917351;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pM/8dQfYS9UuYC/k2nrRJhStfDT3AcSvNyR2TpRbd0w=;
        b=I59aw7TEv2IXmJk86zP+hvWh/vv9lvuDQYaCBt4/jJeNmciLHLyXjjcJ8esdS6daJS
         50nEnFWKZuZWAMJ6Ou3y+Mm8OoLeyz1yUBJdJX5t7iCwsKmJ2EXlKrHijsugAdEswK9g
         n50lR/Myyi7K2iVmKXwrxNclUTAp75jpmt+SJJbTpGGfLkbD/HtQ72Jf6iPZnpKLt6+T
         x4dn15uuOV6n1h8GIIQCH9hgdDzDusbg9Uv5ph2DhgZ2d/V84sbi7MBvy+E7AA2qOg0w
         uT0YWQ6ZvMuy0skkRR8fv2FaDZ/+lCxNTXq7rImNr6XrIcQOeXdIGgUBof8wRHF4UTUw
         Zxtw==
X-Gm-Message-State: AOJu0Yxtxlyc/CCeY5Cqyf0Zb7gTZqfurYk7c8pTnGnMPbWEt2QPu1A8
	BICKHubGTfnyfnyRFIRuFIxwsbo3KRSz9A==
X-Google-Smtp-Source: AGHT+IEDlOVbK+1wecfwRGZEXxfPCLa4shUGFn+dWsCL1mobQgvnwjenM/WmHyzusLqLkKMPH6B53Q==
X-Received: by 2002:a05:620a:2482:b0:781:3c4b:350 with SMTP id i2-20020a05620a248200b007813c4b0350mr20140060qkn.56.1704312550967;
        Wed, 03 Jan 2024 12:09:10 -0800 (PST)
Received: from localhost (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id x15-20020ae9e90f000000b00781baa4db60sm2808979qkf.66.2024.01.03.12.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 12:09:10 -0800 (PST)
Message-ID: <6595bee6.e90a0220.57b35.76e9@mx.google.com>
X-Google-Original-Message-ID: <20240103200907.GA654520@JoelBox.>
Date: Wed, 3 Jan 2024 15:09:07 -0500
From: Joel Fernandes <joel@joelfernandes.org>
To: David Vernet <void@manifault.com>
Cc: Sean Christopherson <seanjc@google.com>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>,
	Barret Rhoden <brho@google.com>, David Dunn <daviddunn@google.com>,
	julia.lawall@inria.fr, himadrispandya@gmail.com,
	jean-pierre.lozi@inria.fr, ast@kernel.org, paulmck@kernel.org
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com>
 <20231215181014.GB2853@maniforge>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215181014.GB2853@maniforge>

Hi David,

On Fri, Dec 15, 2023 at 12:10:14PM -0600, David Vernet wrote:
> On Thu, Dec 14, 2023 at 08:38:47AM -0800, Sean Christopherson wrote:
> > +sched_ext folks
> 
> Thanks for the cc.

Just back from holidays, sorry for the late reply. But it was a good break to
go over your email in more detail ;-).

> > On Wed, Dec 13, 2023, Vineeth Pillai (Google) wrote:
> > > Double scheduling is a concern with virtualization hosts where the host
> > > schedules vcpus without knowing whats run by the vcpu and guest schedules
> > > tasks without knowing where the vcpu is physically running. This causes
> > > issues related to latencies, power consumption, resource utilization
> > > etc. An ideal solution would be to have a cooperative scheduling
> > > framework where the guest and host shares scheduling related information
> > > and makes an educated scheduling decision to optimally handle the
> > > workloads. As a first step, we are taking a stab at reducing latencies
> > > for latency sensitive workloads in the guest.
> > > 
> > > This series of patches aims to implement a framework for dynamically
> > > managing the priority of vcpu threads based on the needs of the workload
> > > running on the vcpu. Latency sensitive workloads (nmi, irq, softirq,
> > > critcal sections, RT tasks etc) will get a boost from the host so as to
> > > minimize the latency.
> > > 
> > > The host can proactively boost the vcpu threads when it has enough
> > > information about what is going to run on the vcpu - fo eg: injecting
> > > interrupts. For rest of the case, guest can request boost if the vcpu is
> > > not already boosted. The guest can subsequently request unboost after
> > > the latency sensitive workloads completes. Guest can also request a
> > > boost if needed.
> > > 
> > > A shared memory region is used to communicate the scheduling information.
> > > Guest shares its needs for priority boosting and host shares the boosting
> > > status of the vcpu. Guest sets a flag when it needs a boost and continues
> > > running. Host reads this on next VMEXIT and boosts the vcpu thread. For
> > > unboosting, it is done synchronously so that host workloads can fairly
> > > compete with guests when guest is not running any latency sensitive
> > > workload.
> > 
> > Big thumbs down on my end.  Nothing in this RFC explains why this should be done
> > in KVM.  In general, I am very opposed to putting policy of any kind into KVM,
> > and this puts a _lot_ of unmaintainable policy into KVM by deciding when to
> > start/stop boosting a vCPU.
> 
> I have to agree, not least of which is because in addition to imposing a
> severe maintenance tax, these policies are far from exhaustive in terms
> of what you may want to do for cooperative paravirt scheduling.

Just to clarify the 'policy' we are discussing here, it is not about 'how to
schedule' but rather 'how/when to boost/unboost'. We want the existing
scheduler (or whatever it might be in the future) to make the actual decision
about how to schedule.

In that sense, I agree with Sean that we are probably forcing a singular
policy on when and how to boost which might not work for everybody (in theory
anyway). And I am perfectly OK with the BPF route as I mentioned in the other
email. So perhaps we can use a tracepoint in the VMEXIT path to run a BPF
program (?). And we still have to figure out how to run BPF programs in the
interrupt injections patch (I am currently studying those paths more also
thanks to Sean's email describing them).

> I think
> something like sched_ext would give you the best of all worlds: no
> maintenance burden on the KVM maintainers, more options for implementing
> various types of policies, performant, safe to run on the host, no need
> to reboot when trying a new policy, etc. More on this below.

I think switching to sched_ext just for this is overkill, we don't want
to change the scheduler yet which is a much more invasive/involved changed.
For instance, we want the features of this patchset to work for ARM as well
which heavily depends on EAS/cpufreq.

[...]
> > Concretely, boosting vCPUs for most events is far too coarse grained.  E.g. boosting
> > a vCPU that is running a low priority workload just because the vCPU triggered
> > an NMI due to PMU counter overflow doesn't make sense.  Ditto for if a guest's
> > hrtimer expires on a vCPU running a low priority workload.
> >
> > And as evidenced by patch 8/8, boosting vCPUs based on when an event is _pending_
> > is not maintainable.  As hardware virtualizes more and more functionality, KVM's
> > visilibity into the guest effectively decreases, e.g. Intel and AMD both support
> > with IPI virtualization.
> > 
> > Boosting the target of a PV spinlock kick is similarly flawed.  In that case, KVM
> > only gets involved _after_ there is a problem, i.e. after a lock is contended so
> > heavily that a vCPU stops spinning and instead decided to HLT.  It's not hard to
> > imagine scenarios where a guest would want to communicate to the host that it's
> > acquiring a spinlock for a latency sensitive path and so shouldn't be scheduled
> > out.  And of course that's predicated on the assumption that all vCPUs are subject
> > to CPU overcommit.
> > 
> > Initiating a boost from the host is also flawed in the sense that it relies on
> > the guest to be on the same page as to when it should stop boosting.  E.g. if
> > KVM boosts a vCPU because an IRQ is pending, but the guest doesn't want to boost
> > IRQs on that vCPU and thus doesn't stop boosting at the end of the IRQ handler,
> > then the vCPU could end up being boosted long after its done with the IRQ.
> > 
> > Throw nested virtualization into the mix and then all of this becomes nigh
> > impossible to sort out in KVM.  E.g. if an L1 vCPU is a running an L2 vCPU, i.e.
> > a nested guest, and L2 is spamming interrupts for whatever reason, KVM will end
> > repeatedly boosting the L1 vCPU regardless of the priority of the L2 workload.
> > 
> > For things that aren't clearly in KVM's domain, I don't think we should implement
> > KVM-specific functionality until every other option has been tried (and failed).
> > I don't see any reason why KVM needs to get involved in scheduling, beyond maybe
> > providing *input* regarding event injection, emphasis on *input* because KVM
> > providing information to userspace or some other entity is wildly different than
> > KVM making scheduling decisions based on that information.
> > 
> > Pushing the scheduling policies to host userspace would allow for far more control
> > and flexibility.  E.g. a heavily paravirtualized environment where host userspace
> > knows *exactly* what workloads are being run could have wildly different policies
> > than an environment where the guest is a fairly vanilla Linux VM that has received
> > a small amount of enlightment.
> > 
> > Lastly, if the concern/argument is that userspace doesn't have the right knobs
> > to (quickly) boost vCPU tasks, then the proposed sched_ext functionality seems
> > tailor made for the problems you are trying to solve.
> >
> > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
> 
> I very much agree. There are some features missing from BPF that we'd
> need to add to enable this, but they're on the roadmap, and I don't
> think they'd be especially difficult to implement.
> 
> The main building block that I was considering is a new kptr [0] and set
> of kfuncs [1] that would allow a BPF program to have one or more R/W
> shared memory regions with a guest.

I really like your ideas around sharing memory across virt boundary using
BPF. The one concern I would have is that, this does require loading a BPF
program from the guest userspace, versus just having a guest kernel that
'does the right thing'.

On the host, I would have no problem loading a BPF program as a one-time
thing, but on the guest it may be more complex as we don't always control the
guest userspace and their BPF loading mechanisms. Example, an Android guest
needs to have its userspace modified to load BPF progs, etc. Not hard
problems, but flexibility comes with more cost. Last I recall, Android does
not use a lot of the BPF features that come with the libbpf library because
they write their own userspace from scratch (due to licensing). OTOH, if this
was an Android kernel-only change, that would simplify a lot.

Still there is a lot of merit to sharing memory with BPF and let BPF decide
the format of the shared memory, than baking it into the kernel... so thanks
for bringing this up! Lets talk more about it... Oh, and there's my LSFMMBPF
invitiation request ;-) ;-).

> This could enable a wide swath of
> BPF paravirt use cases that are not limited to scheduling, but in terms
> of sched_ext, the BPF scheduler could communicate with the guest
> scheduler over this shared memory region in whatever manner was required
> for that use case.
> 
> [0]: https://lwn.net/Articles/900749/
> [1]: https://lwn.net/Articles/856005/

Thanks, I had no idea about these. I have a question -- would it be possible
to call the sched_setscheduler() function in core.c via a kfunc? Then we can
trigger the boost from a BPF program on the host side. We could start simple
from there.

I agree on the rest below. I just wanted to emphasize though that this patch
series does not care about what the scheduler does. It merely hints the
scheduler via a priority setting that something is an important task. That's
a far cry from how to actually schedule and the spirit here is to use
whatever scheduler the user has to decide how to actually schedule.

thanks,

 - Joel


> For example, the guest could communicate scheduling intention such as:
> 
> - "Don't preempt me and/or boost me (because I'm holding a spinlock, in an
>   NMI region, running some low-latency task, etc)".
> - "VCPU x prefers to be on a P core", and then later, "Now it prefers an
>   E core". Note that this doesn't require pinning or anything like that.
>   It's just the VCPU requesting some best-effort placement, and allowing
>   that policy to change dynamically depending on what the guest is
>   doing.
> - "Try to give these VCPUs their own fully idle cores if possible, but
>   these other VCPUs should ideally be run as hypertwins as they're
>   expected to have good cache locality", etc.
> 
> In general, some of these policies might be silly and not work well,
> others might work very well for some workloads / architectures and not
> as well on others, etc. sched_ext would make it easy to try things out
> and see what works well, without having to worry about rebooting or
> crashing the host, and ultimately without having to implement and
> maintain some scheduling policy directly in KVM. As Sean said, the host
> knows exactly what workloads are being run and could have very targeted
> and bespoke policies that wouldn't be appropriate for a vanilla Linux
> VM.
> 
> Finally, while it's not necessarily related to paravirt scheduling
> specifically, I think it's maybe worth mentioning that sched_ext would
> have allowed us to implement a core-sched-like policy when L1TF first
> hit us. It was inevitable that we'd need a core-sched policy build into
> the core kernel as well, but we could have used sched_ext as a solution
> until core sched was merged. Tejun implemented something similar in an
> example scheduler where only tasks in the same cgroup are ever allowed
> to run as hypertwins [3]. The point is, you can do basically anything
> you want with sched_ext. For paravirt, I think there are a ton of
> interesting possibilities, and I think those possibilities are better
> explored and implemented with sched_ext rather than implementing
> policies directly in KVM.
> 
> [3]: https://lore.kernel.org/lkml/20231111024835.2164816-27-tj@kernel.org/



