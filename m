Return-Path: <kvm+bounces-21525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1BC92FDA4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06DFA1F21A1D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487E51741C5;
	Fri, 12 Jul 2024 15:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="iQJWzRTn"
X-Original-To: kvm@vger.kernel.org
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBFF5256;
	Fri, 12 Jul 2024 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720798355; cv=none; b=uiSl5sJNIhgsGvUG5fBKwHgT6N9mf2iTScci8co03KOy4mKmUWT5SpJ/XVcvxsoxqfwHN+3y9eJcIHFRwl/BYmtJf76xE8aEG/eh6qsFNCJNpXhPGGa8UPfQ8pp0Ef49i8CrcPfCyiStGHiGui2TeoBpHbSFfSNSiRP6JBHzvik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720798355; c=relaxed/simple;
	bh=AgqkuDLmqvlAMs/vYiBU4mSmTAYDOgKQnXRDiMrp7nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NWLMcrKgney3KWyJ+aN8hInvHIVkhB8hepcSIPBPkffhpeamVUOjCinCT6D59Nq4ryiT//Y6nMF3NuAJU+jymfoACf8S1pO/6kId2z9gJsNKzrC6ul7s2Zw9ORa23gWZyFSokfFFGlpd31BBTP3QLQE37e5AHuA9RYuMNvSwZsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=iQJWzRTn; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1720798351;
	bh=AgqkuDLmqvlAMs/vYiBU4mSmTAYDOgKQnXRDiMrp7nc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iQJWzRTn4ZXEkzHAfk4OVmsY1HZ0jbzmnUSp3O/f38r8v5duFftiUJJ/0MjxXhE8r
	 evG1ecc6dpiT7WeASVQuLkO4jqwiMEbhghIml6I8cfx0ZN0KJijyVAZfUf/bxH7xTt
	 +TyZbAgtVULTrzZ9D8GbHPe7gCN17tsCj4IdBClV+ZZom+gKmLCc4wBbvXDi/eeakD
	 wa8bQ70db/PeT5WWAEOmZwaRBLt1POLSlTugdZCWJGZ52ZFafno0cZ8ZU+4RrspXyk
	 qkn51nhmiwVjX5BBYHgqfm6v+ovVKri/PJ8rbJCKCig1v4tUP7r5/kVoRBhAH3JKWj
	 nZb+K9TflqxTQ==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4WLFvz0QXQz19dM;
	Fri, 12 Jul 2024 11:32:31 -0400 (EDT)
Message-ID: <01c3e7de-0c1a-45e0-aed6-c11e9fa763df@efficios.com>
Date: Fri, 12 Jul 2024 11:32:30 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
To: Sean Christopherson <seanjc@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
 Vineeth Remanan Pillai <vineeth@bitbyteword.org>,
 Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
 Daniel Bristot de Oliveira <bristot@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Steven Rostedt <rostedt@goodmis.org>, Suleiman Souhlal
 <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 himadrics@inria.fr, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, graf@amazon.com, drjunior.org@gmail.com
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com>
 <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com>
 <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <ZpFCKrRKluacu58x@google.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <ZpFCKrRKluacu58x@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-07-12 10:48, Sean Christopherson wrote:
> On Fri, Jul 12, 2024, Mathieu Desnoyers wrote:
>> On 2024-07-12 08:57, Joel Fernandes wrote:
>>> On Mon, Jun 24, 2024 at 07:01:19AM -0400, Vineeth Remanan Pillai wrote:
>> [...]
>>>> Existing use cases
>>>> -------------------------
>>>>
>>>> - A latency sensitive workload on the guest might need more than one
>>>> time slice to complete, but should not block any higher priority task
>>>> in the host. In our design, the latency sensitive workload shares its
>>>> priority requirements to host(RT priority, cfs nice value etc). Host
>>>> implementation of the protocol sets the priority of the vcpu task
>>>> accordingly so that the host scheduler can make an educated decision
>>>> on the next task to run. This makes sure that host processes and vcpu
>>>> tasks compete fairly for the cpu resource.
>>
>> AFAIU, the information you need to convey to achieve this is the priority
>> of the task within the guest. This information need to reach the host
>> scheduler to make informed decision.
>>
>> One thing that is unclear about this is what is the acceptable
>> overhead/latency to push this information from guest to host ?
>> Is an hypercall OK or does it need to be exchanged over a memory
>> mapping shared between guest and host ?
>>
>> Hypercalls provide simple ABIs across guest/host, and they allow
>> the guest to immediately notify the host (similar to an interrupt).
> 
> Hypercalls have myriad problems.  They require a VM-Exit, which largely defeats
> the purpose of boosting the vCPU priority for performance reasons.  They don't
> allow for delegation as there's no way for the hypervisor to know if a hypercall
> from guest userspace should be allowed, versus anything memory based where the
> ability for guest userspace to access the memory demonstrates permission (else
> the guest kernel wouldn't have mapped the memory into userspace).

OK, this answers my question above: the overhead of the hypercall pretty
much defeats the purpose of this priority boosting.

> 
>>>> Ideas brought up during offlist discussion
>>>> -------------------------------------------------------
>>>>
>>>> 1. rseq based timeslice extension mechanism[1]
>>>>
>>>> While the rseq based mechanism helps in giving the vcpu task one more
>>>> time slice, it will not help in the other use cases. We had a chat
>>>> with Steve and the rseq mechanism was mainly for improving lock
>>>> contention and would not work best with vcpu boosting considering all
>>>> the use cases above. RT or high priority tasks in the VM would often
>>>> need more than one time slice to complete its work and at the same,
>>>> should not be hurting the host workloads. The goal for the above use
>>>> cases is not requesting an extra slice, but to modify the priority in
>>>> such a way that host processes and guest processes get a fair way to
>>>> compete for cpu resources. This also means that vcpu task can request
>>>> a lower priority when it is running lower priority tasks in the VM.
> 
> Then figure out a way to let userspace boot a task's priority without needing a
> syscall.  vCPUs are not directly schedulable entities, the task doing KVM_RUN
> on the vCPU fd is what the scheduler sees.  Any scheduling enhancement that
> benefits vCPUs by definition can benefit userspace tasks.

Yes.

> 
>>> I was looking at the rseq on request from the KVM call, however it does not
>>> make sense to me yet how to expose the rseq area via the Guest VA to the host
>>> kernel.  rseq is for userspace to kernel, not VM to kernel.
> 
> Any memory that is exposed to host userspace can be exposed to the guest.  Things
> like this are implemented via "overlay" pages, where the guest asks host userspace
> to map the magic page (rseq in this case) at GPA 'x'.  Userspace then creates a
> memslot that overlays guest RAM to map GPA 'x' to host VA 'y', where 'y' is the
> address of the page containing the rseq structure associated with the vCPU (in
> pretty much every modern VMM, each vCPU has a dedicated task/thread).
> 
> A that point, the vCPU can read/write the rseq structure directly.

This helps me understand what you are trying to achieve. I disagree with
some aspects of the design you present above: mainly the lack of
isolation between the guest kernel and the host task doing the KVM_RUN.
We do not want to let the guest kernel store to rseq fields that would
result in getting the host task killed (e.g. a bogus rseq_cs pointer).
But this is something we can improve upon once we understand what we
are trying to achieve.

> 
> The reason us KVM folks are pushing y'all towards something like rseq is that
> (again, in any modern VMM) vCPUs are just tasks, i.e. priority boosting a vCPU
> is actually just priority boosting a task.  So rather than invent something
> virtualization specific, invent a mechanism for priority boosting from userspace
> without a syscall, and then extend it to the virtualization use case.
> 
[...]

OK, so how about we expose "offsets" tuning the base values ?

- The task doing KVM_RUN, just like any other task, has its "priority"
   value as set by setpriority(2).

- We introduce two new fields in the per-thread struct rseq, which is
   mapped in the host task doing KVM_RUN and readable from the scheduler:

   - __s32 prio_offset; /* Priority offset to apply on the current task priority. */

   - __u64 vcpu_sched;  /* Pointer to a struct vcpu_sched in user-space */

     vcpu_sched would be a userspace pointer to a new vcpu_sched structure,
     which would be typically NULL except for tasks doing KVM_RUN. This would
     sit in its own pages per vcpu, which takes care of isolation between guest
     kernel and host process. Those would be RW by the guest kernel as
     well and contain e.g.:

     struct vcpu_sched {
         __u32 len;  /* Length of active fields. */

         __s32 prio_offset;
         __s32 cpu_capacity_offset;
         [...]
     };

So when the host kernel try to calculate the effective priority of a task
doing KVM_RUN, it would basically start from its current priority, and offset
by (rseq->prio_offset + rseq->vcpu_sched->prio_offset).

The cpu_capacity_offset would be populated by the host kernel and read by the
guest kernel scheduler for scheduling/migration decisions.

I'm certainly missing details about how priority offsets should be bounded for
given tasks. This could be an extension to setrlimit(2).

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


