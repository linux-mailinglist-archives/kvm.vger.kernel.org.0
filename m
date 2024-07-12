Return-Path: <kvm+bounces-21510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B283C92FC48
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66E2528248F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 14:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDEB172762;
	Fri, 12 Jul 2024 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="m1mxWTqB"
X-Original-To: kvm@vger.kernel.org
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0102217164E;
	Fri, 12 Jul 2024 14:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720793361; cv=none; b=As5WicGxZ8WUWrLr0zwI3HFLyJfpgctS2+e7XmjLC3xurFF3T99y4lh43aDW4lUPrvRcD26AuOSwFqn05GvqIpYuMlQvo87u73RlaiHcUjwb+QYBtJaIYbIudakvNVhJOXK210YFEH5AibwhJcFgIpxI/g9HBGQULynlYN9gkG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720793361; c=relaxed/simple;
	bh=SiJYJT7XiDpYkTbzDULKnqelMg+cHQSeUDbxuLed7Tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gAQX4j+HpHp4J7eQU2BGp1IWdJeQ4Uqgz4W/6EDNDgw2hEERaa1KwCRnPFmq82VKq3F7rQpT9kcCBpQfQqEgmX8x2EpZ95XxWtwFnt76jI9Ti6wBzyGUFlChEYWbDE+7lQ+pktAJRWNzs7q9Sr54DtbsOAvDQht7Aj5dQFd+BfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=m1mxWTqB; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1720793351;
	bh=SiJYJT7XiDpYkTbzDULKnqelMg+cHQSeUDbxuLed7Tc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m1mxWTqBg3RBa0a0UVKYRmRG+QerKjqXVnCfgNoTssjem7iP5SQS7ccDsDJEC27a3
	 c/ZORa5PbOMs6aWmPa0/noyfBR9as4UWpF4u6aGq4akS2THZ2UJLq0xTLXywRhEnoN
	 W5erc/MJeIc6DVDrlJxs8ZghXyHNlW4PVGp0fiyqtMsT6epMp7FhZQKUkVolWOSBB+
	 d1bxLzSuHz4dJ74nFQ1F6MzAB3wKvI3xuxYR7GKXZJhW/Hk9mNJeEkw4lf/tFuemkZ
	 pIzOOAyWadtQPsyzveFU0MWTYCC8x3l/AVJEbx7Pozg1SPiK3QP8Swg2bue/ZkKSkq
	 BCrJ8nZmB8O0A==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4WLD3p4MdZz19VK;
	Fri, 12 Jul 2024 10:09:10 -0400 (EDT)
Message-ID: <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
Date: Fri, 12 Jul 2024 10:09:03 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
To: Joel Fernandes <joel@joelfernandes.org>,
 Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Sean Christopherson <seanjc@google.com>, Ben Segall <bsegall@google.com>,
 Borislav Petkov <bp@alien8.de>,
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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <66912820.050a0220.15d64.10f5@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-07-12 08:57, Joel Fernandes wrote:
> On Mon, Jun 24, 2024 at 07:01:19AM -0400, Vineeth Remanan Pillai wrote:
[...]
>> Existing use cases
>> -------------------------
>>
>> - A latency sensitive workload on the guest might need more than one
>> time slice to complete, but should not block any higher priority task
>> in the host. In our design, the latency sensitive workload shares its
>> priority requirements to host(RT priority, cfs nice value etc). Host
>> implementation of the protocol sets the priority of the vcpu task
>> accordingly so that the host scheduler can make an educated decision
>> on the next task to run. This makes sure that host processes and vcpu
>> tasks compete fairly for the cpu resource.

AFAIU, the information you need to convey to achieve this is the priority
of the task within the guest. This information need to reach the host
scheduler to make informed decision.

One thing that is unclear about this is what is the acceptable
overhead/latency to push this information from guest to host ?
Is an hypercall OK or does it need to be exchanged over a memory
mapping shared between guest and host ?

Hypercalls provide simple ABIs across guest/host, and they allow
the guest to immediately notify the host (similar to an interrupt).

Shared memory mapping will require a carefully crafted ABI layout,
and will only allow the host to use the information provided when
the host runs. Therefore, if the choice is to share this information
only through shared memory, the host scheduler will only be able to
read it when it runs, so in hypercall, interrupt, and so on.

>> - Guest should be able to notify the host that it is running a lower
>> priority task so that the host can reschedule it if needed. As
>> mentioned before, the guest shares the priority with the host and the
>> host takes a better scheduling decision.

It is unclear to me whether this information needs to be "pushed"
from guest to host (e.g. hypercall) in a way that allows the host
to immediately act on this information, or if it is OK to have the
host read this information when its scheduler happens to run.

>> - Proactive vcpu boosting for events like interrupt injection.
>> Depending on the guest for boost request might be too late as the vcpu
>> might not be scheduled to run even after interrupt injection. Host
>> implementation of the protocol boosts the vcpu tasks priority so that
>> it gets a better chance of immediately being scheduled and guest can
>> handle the interrupt with minimal latency. Once the guest is done
>> handling the interrupt, it can notify the host and lower the priority
>> of the vcpu task.

This appears to be a scenario where the host sets a "high priority", and
the guest clears it when it is done with the irq handler. I guess it can
be done either ways (hypercall or shared memory), but the choice would
depend on the parameters identified above: acceptable overhead vs acceptable
latency to inform the host scheduler.

>> - Guests which assign specialized tasks to specific vcpus can share
>> that information with the host so that host can try to avoid
>> colocation of those cpus in a single physical cpu. for eg: there are
>> interrupt pinning use cases where specific cpus are chosen to handle
>> critical interrupts and passing this information to the host could be
>> useful.

How frequently is this topology expected to change ? Is it something that
is set once when the guest starts and then is fixed ? How often it changes
will likely affect the tradeoffs here.

>> - Another use case is the sharing of cpu capacity details between
>> guest and host. Sharing the host cpu's load with the guest will enable
>> the guest to schedule latency sensitive tasks on the best possible
>> vcpu. This could be partially achievable by steal time, but steal time
>> is more apparent on busy vcpus. There are workloads which are mostly
>> sleepers, but wake up intermittently to serve short latency sensitive
>> workloads. input event handlers in chrome is one such example.

OK so for this use-case information goes the other way around: from host
to guest. Here the shared mapping seems better than polling the state
through an hypercall.

>>
>> Data from the prototype implementation shows promising improvement in
>> reducing latencies. Data was shared in the v1 cover letter. We have
>> not implemented the capacity based placement policies yet, but plan to
>> do that soon and have some real numbers to share.
>>
>> Ideas brought up during offlist discussion
>> -------------------------------------------------------
>>
>> 1. rseq based timeslice extension mechanism[1]
>>
>> While the rseq based mechanism helps in giving the vcpu task one more
>> time slice, it will not help in the other use cases. We had a chat
>> with Steve and the rseq mechanism was mainly for improving lock
>> contention and would not work best with vcpu boosting considering all
>> the use cases above. RT or high priority tasks in the VM would often
>> need more than one time slice to complete its work and at the same,
>> should not be hurting the host workloads. The goal for the above use
>> cases is not requesting an extra slice, but to modify the priority in
>> such a way that host processes and guest processes get a fair way to
>> compete for cpu resources. This also means that vcpu task can request
>> a lower priority when it is running lower priority tasks in the VM.
> 
> I was looking at the rseq on request from the KVM call, however it does not
> make sense to me yet how to expose the rseq area via the Guest VA to the host
> kernel.  rseq is for userspace to kernel, not VM to kernel.
> 
> Steven Rostedt said as much as well, thoughts? Add Mathieu as well.

I'm not sure that rseq would help at all here, but I think we may want to
borrow concepts of data sitting in shared memory across privilege levels
and apply them to VMs.

If some of the ideas end up being useful *outside* of the context of VMs,
then I'd be willing to consider adding fields to rseq. But as long as it is
VM-specific, I suspect you'd be better with dedicated per-vcpu pages which
you can safely share across host/guest kernels.

> 
> This idea seems to suffer from the same vDSO over-engineering below, rseq
> does not seem to fit.
> 
> Steven Rostedt told me, what we instead need is a tracepoint callback in a
> driver, that does the boosting.

I utterly dislike changing the system behavior through tracepoints. They were
designed to observe the system, not modify its behavior. If people start abusing
them, then subsystem maintainers will stop adding them. Please don't do that.
Add a notifier or think about integrating what you are planning to add into the
driver instead.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


