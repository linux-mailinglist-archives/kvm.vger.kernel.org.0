Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65F635868
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 10:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFEITt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 04:19:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfFEITs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 04:19:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x558EEm4080311;
        Wed, 5 Jun 2019 08:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=gyPOJ2pQ7vFk4n0O6nuPDA/Zh23y4LlPAzR4+5D8Uvo=;
 b=0qRJOsOMdwPWJNPJRuHydQqMU0i+xT5cwgGVZT0p0dL4aJUyrTionVfagoAox/82PO7d
 QE3T3UxM2NW9JjtEsXOCC6dFdZYAcakmCJSEYuiP6nS1N1ekEv8tUcyitpwK96129goo
 d+UeoX75zflcOa3Mbk2l2t/kqI3w6gOQYBryABjRJ40g4O+Hd7X6v+CBswP99738rDP6
 UrpvxvQlc6g4PjKNF4v5dawkTWmdFnxEtxZ4oLcGzFMarLnvBFLbXxA+n+rrQR3eQ6Tb
 xga5YHZCIUT36aa8/vg0VSK/Rofmyk0XAdvlIBb9duUNljbdWbgxvZU/jOL6gizoAyJk zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0qh6qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 08:18:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x558GWVc036913;
        Wed, 5 Jun 2019 08:16:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2swnha1m1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 08:16:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x558GZiT007364;
        Wed, 5 Jun 2019 08:16:36 GMT
Received: from [192.168.0.110] (/70.36.60.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Jun 2019 01:16:35 -0700
Subject: Re: [patch 1/3] drivers/cpuidle: add cpuidle-haltpoll driver
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LDhMKNbcODwqE=?= =?UTF-8?B?w4XCmQ==?= 
        <rkrcmar@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.212931277@amt.cnet>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <15699d6a-946a-bb8d-ec83-0fa2118c6546@oracle.com>
Date:   Wed, 5 Jun 2019 01:16:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603225254.212931277@amt.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906050053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906050053
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-06-03 3:52 p.m., Marcelo Tosatti wrote:
> The cpuidle_kvm driver allows the guest vcpus to poll for a specified
> amount of time before halting. This provides the following benefits
> to host side polling:
> 
>          1) The POLL flag is set while polling is performed, which allows
>             a remote vCPU to avoid sending an IPI (and the associated
>             cost of handling the IPI) when performing a wakeup.
> 
>          2) The HLT VM-exit cost can be avoided.
> 
> The downside of guest side polling is that polling is performed
> even with other runnable tasks in the host.
> 
> Results comparing halt_poll_ns and server/client application
> where a small packet is ping-ponged:
> 
> host                                        --> 31.33
> halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
> halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)
> 
> For the SAP HANA benchmarks (where idle_spin is a parameter
> of the previous version of the patch, results should be the
> same):
> 
> hpns == halt_poll_ns
> 
>                            idle_spin=0/   idle_spin=800/    idle_spin=0/
>                            hpns=200000    hpns=0            hpns=800000
> DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
> InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
> DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)	   1.29   (-3.7%)
> UpdateC00T03 (1 thread)   4.72           4.18 (-12%)	   4.53   (-5%)
> 
> ---
>   Documentation/virtual/guest-halt-polling.txt |   78 ++++++++++++
>   arch/x86/kernel/process.c                    |    2
>   drivers/cpuidle/Kconfig                      |   10 +
>   drivers/cpuidle/Makefile                     |    1
>   drivers/cpuidle/cpuidle-haltpoll-trace.h     |   65 ++++++++++
>   drivers/cpuidle/cpuidle-haltpoll.c           |  172 +++++++++++++++++++++++++++
>   6 files changed, 327 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/Documentation/virtual/guest-halt-polling.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/Documentation/virtual/guest-halt-polling.txt	2019-06-03 19:31:36.003302371 -0300
> @@ -0,0 +1,78 @@
> +Guest halt polling
> +==================
> +
> +The cpuidle_haltpoll driver allows the guest vcpus to poll for a specified
> +amount of time before halting. This provides the following benefits
> +to host side polling:
> +
> +	1) The POLL flag is set while polling is performed, which allows
> +	   a remote vCPU to avoid sending an IPI (and the associated
> + 	   cost of handling the IPI) when performing a wakeup.
> +
> +	2) The HLT VM-exit cost can be avoided.
Nit: s/HLT// (also in the commit message). We might be using
MWAIT passthrough via default_idle_call()

> +
> +The downside of guest side polling is that polling is performed
> +even with other runnable tasks in the host.
> +
> +The basic logic as follows: A global value, guest_halt_poll_ns,
> +is configured by the user, indicating the maximum amount of
> +time polling is allowed. This value is fixed.
> +
> +Each vcpu has an adjustable guest_halt_poll_ns
> +("per-cpu guest_halt_poll_ns"), which is adjusted by the algorithm
I believe the per-cpu variable is halt_poll_ns (below as well.)


> +in response to events (explained below).
> +
> +Module Parameters
> +=================
> +
> +The cpuidle_haltpoll module has 5 tunable module parameters:
> +
> +1) guest_halt_poll_ns:
> +Maximum amount of time, in nanoseconds, that polling is
> +performed before halting.
> +
> +Default: 200000
> +
> +2) guest_halt_poll_shrink:
> +Division factor used to shrink per-cpu guest_halt_poll_ns when
> +wakeup event occurs after the global guest_halt_poll_ns.
> +
> +Default: 2
> +
> +3) guest_halt_poll_grow:
> +Multiplication factor used to grow per-cpu guest_halt_poll_ns
> +when event occurs after per-cpu guest_halt_poll_ns
> +but before global guest_halt_poll_ns.
> +
> +Default: 2
> +
> +4) guest_halt_poll_grow_start:
> +The per-cpu guest_halt_poll_ns eventually reaches zero
> +in case of an idle system. This value sets the initial
> +per-cpu guest_halt_poll_ns when growing. This can
> +be increased from 10000, to avoid misses during the initial
> +growth stage:
> +
> +10000, 20000, 40000, ... (example assumes guest_halt_poll_grow=2).
> +
> +Default: 10000
> +
> +5) guest_halt_poll_allow_shrink:
> +
> +Bool parameter which allows shrinking. Set to N
> +to avoid it (per-cpu guest_halt_poll_ns will remain
> +high once achieves global guest_halt_poll_ns value).
> +
> +Default: Y
> +
> +The module parameters can be set from the debugfs files in:
> +
> +	/sys/module/cpuidle_haltpoll/parameters/
> +
> +Further Notes
> +=============
> +
> +- Care should be taken when setting the guest_halt_poll_ns parameter as a
> +large value has the potential to drive the cpu usage to 100% on a machine which
> +would be almost entirely idle otherwise.
> +
> Index: linux-2.6.git/arch/x86/kernel/process.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/process.c	2019-05-29 14:46:14.527005582 -0300
> +++ linux-2.6.git/arch/x86/kernel/process.c	2019-06-03 19:31:36.004302375 -0300
> @@ -580,7 +580,7 @@
>   	safe_halt();
>   	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>   }
> -#ifdef CONFIG_APM_MODULE
> +#if defined(CONFIG_APM_MODULE) || defined(CONFIG_HALTPOLL_CPUIDLE_MODULE)
>   EXPORT_SYMBOL(default_idle);
>   #endif
>   
> Index: linux-2.6.git/drivers/cpuidle/Kconfig
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/Kconfig	2019-05-29 14:46:14.668006053 -0300
> +++ linux-2.6.git/drivers/cpuidle/Kconfig	2019-06-03 19:31:36.004302375 -0300
> @@ -51,6 +51,16 @@
>   source "drivers/cpuidle/Kconfig.powerpc"
>   endmenu
>   
> +config HALTPOLL_CPUIDLE
> +       tristate "Halt poll cpuidle driver"
> +       depends on X86
> +       default y
> +       help
> +         This option enables halt poll cpuidle driver, which allows to poll
> +         before halting in the guest (more efficient than polling in the
> +         host via halt_poll_ns for some scenarios).
> +
> +
>   endif
>   
>   config ARCH_NEEDS_CPU_IDLE_COUPLED
> Index: linux-2.6.git/drivers/cpuidle/Makefile
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/Makefile	2019-05-29 14:44:43.030700871 -0300
> +++ linux-2.6.git/drivers/cpuidle/Makefile	2019-06-03 19:31:36.004302375 -0300
> @@ -7,6 +7,7 @@
>   obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
>   obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
>   obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
> +obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
>   
>   ##################################################################################
>   # ARM SoC drivers
> Index: linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll-trace.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll-trace.h	2019-06-03 19:31:36.005302378 -0300
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#if !defined(_HALTPOLL_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
> +#define _HALTPOLL_TRACE_H_
> +
> +#include <linux/stringify.h>
> +#include <linux/types.h>
> +#include <linux/tracepoint.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM cpuidle_haltpoll
> +
> +TRACE_EVENT(cpuidle_haltpoll_success,
> +	    TP_PROTO(unsigned int cpu_halt_poll_ns, u64 block_ns),
> +	    TP_ARGS(cpu_halt_poll_ns, block_ns),
> +
> +	    TP_STRUCT__entry(
> +			     __field(unsigned int, cpu_halt_poll_ns)
> +			     __field(u64,	   block_ns)
> +			    ),
> +
> +	    TP_fast_assign(
> +			   __entry->cpu_halt_poll_ns = cpu_halt_poll_ns;
> +			   __entry->block_ns = block_ns;
> +			  ),
> +
> +	    TP_printk("cpu_halt_poll_ns %u block_ns %lld",
> +			  __entry->cpu_halt_poll_ns,
> +			  __entry->block_ns)
> +);
> +
> +TRACE_EVENT(cpuidle_haltpoll_fail,
> +		TP_PROTO(unsigned int prev_cpu_halt_poll_ns,
> +			 unsigned int cpu_halt_poll_ns,
> +			 u64 block_ns),
> +		TP_ARGS(prev_cpu_halt_poll_ns, cpu_halt_poll_ns, block_ns),
> +
> +		TP_STRUCT__entry(
> +				__field(unsigned int, prev_cpu_halt_poll_ns)
> +				__field(unsigned int, cpu_halt_poll_ns)
> +				__field(u64,	   block_ns)
> +				),
> +
> +		TP_fast_assign(
> +			      __entry->prev_cpu_halt_poll_ns =
> +					prev_cpu_halt_poll_ns;
> +			      __entry->cpu_halt_poll_ns = cpu_halt_poll_ns;
> +			      __entry->block_ns = block_ns;
> +			      ),
> +
> +		TP_printk("prev_cpu_halt_poll_ns %u cpu_halt_poll_ns %u block_ns %lld",
> +			      __entry->prev_cpu_halt_poll_ns,
> +			      __entry->cpu_halt_poll_ns,
> +			      __entry->block_ns)
> +);
> +
> +#endif /* _HALTPOLL_TRACE_H_ */
> +
> +/* This part must be outside protection */
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../drivers/cpuidle/
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE cpuidle-haltpoll-trace
> +#include <trace/define_trace.h>
> +
> +
> Index: linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-03 19:31:36.005302378 -0300
> @@ -0,0 +1,172 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * cpuidle driver for halt polling.
> + *
> + * Copyright 2019 Red Hat, Inc. and/or its affiliates.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + *
> + * Authors: Marcelo Tosatti <mtosatti@redhat.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/cpuidle.h>
> +#include <linux/module.h>
> +#include <linux/timekeeping.h>
> +#include <linux/sched/idle.h>
> +#define CREATE_TRACE_POINTS
> +#include "cpuidle-haltpoll-trace.h"
> +
> +unsigned int guest_halt_poll_ns = 200000;
> +module_param(guest_halt_poll_ns, uint, 0644);
> +
> +/* division factor to shrink halt_poll_ns */
> +unsigned int guest_halt_poll_shrink = 2;
> +module_param(guest_halt_poll_shrink, uint, 0644);
> +
> +/* multiplication factor to grow per-cpu halt_poll_ns */
> +unsigned int guest_halt_poll_grow = 2;
> +module_param(guest_halt_poll_grow, uint, 0644);
> +
> +/* value in ns to start growing per-cpu halt_poll_ns */
> +unsigned int guest_halt_poll_grow_start = 10000;
> +module_param(guest_halt_poll_grow_start, uint, 0644);
> +
> +/* value in ns to start growing per-cpu halt_poll_ns */
> +bool guest_halt_poll_allow_shrink = true;
> +module_param(guest_halt_poll_allow_shrink, bool, 0644);
> +
> +static DEFINE_PER_CPU(unsigned int, halt_poll_ns);
> +
> +static void adjust_haltpoll_ns(unsigned int block_ns,
> +			       unsigned int *cpu_halt_poll_ns)
> +{
> +	unsigned int val;
> +	unsigned int prev_halt_poll_ns = *cpu_halt_poll_ns;
> +
> +	/* Grow cpu_halt_poll_ns if
> +	 * cpu_halt_poll_ns < block_ns < guest_halt_poll_ns
> +	 */
> +	if (block_ns > *cpu_halt_poll_ns && block_ns <= guest_halt_poll_ns) {
> +		val = *cpu_halt_poll_ns * guest_halt_poll_grow;
> +
> +		if (val < guest_halt_poll_grow_start)
> +			val = guest_halt_poll_grow_start;
> +		if (val > guest_halt_poll_ns)
> +			val = guest_halt_poll_ns;
> +
> +		*cpu_halt_poll_ns = val;
> +	} else if (block_ns > guest_halt_poll_ns &&
> +		   guest_halt_poll_allow_shrink) {
> +		unsigned int shrink = guest_halt_poll_shrink;
> +
> +		val = *cpu_halt_poll_ns;
> +		if (shrink == 0)
> +			val = 0;
> +		else
> +			val /= shrink;
Nit, feel free to ignore: we could check for guest_halt_poll_shrink
along with guest_halt_poll_allow_shrink and get rid of this whole
conditional.

Ankur

> +		*cpu_halt_poll_ns = val;
> +	}
> +
> +	trace_cpuidle_haltpoll_fail(prev_halt_poll_ns, *cpu_halt_poll_ns,
> +				    block_ns);
> +}
> +
> +static int haltpoll_enter_idle(struct cpuidle_device *dev,
> +			  struct cpuidle_driver *drv, int index)
> +{
> +	int do_halt = 0;
> +	unsigned int *cpu_halt_poll_ns;
> +	ktime_t start, now;
> +	int cpu = smp_processor_id();
> +
> +	cpu_halt_poll_ns = per_cpu_ptr(&halt_poll_ns, cpu);
> +
> +	/* No polling */
> +	if (guest_halt_poll_ns == 0) {
> +		if (current_clr_polling_and_test()) {
> +			local_irq_enable();
> +			return index;
> +		}
> +		default_idle();
> +		return index;
> +	}
> +
> +	local_irq_enable();
> +
> +	now = start = ktime_get();
> +	if (!current_set_polling_and_test()) {
> +		ktime_t end_spin;
> +
> +		end_spin = ktime_add_ns(now, *cpu_halt_poll_ns);
> +
> +		while (!need_resched()) {
> +			cpu_relax();
> +			now = ktime_get();
> +
> +			if (!ktime_before(now, end_spin)) {
> +				do_halt = 1;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (do_halt) {
> +		u64 block_ns;
> +
> +		/*
> +		 * No events while busy spin window passed,
> +		 * halt.
> +		 */
> +		local_irq_disable();
> +		if (current_clr_polling_and_test()) {
> +			local_irq_enable();
> +			return index;
> +		}
> +		default_idle();
> +		block_ns = ktime_to_ns(ktime_sub(ktime_get(), start));
> +		adjust_haltpoll_ns(block_ns, cpu_halt_poll_ns);
> +	} else {
> +		u64 block_ns = ktime_to_ns(ktime_sub(now, start));
> +
> +		trace_cpuidle_haltpoll_success(*cpu_halt_poll_ns, block_ns);
> +		current_clr_polling();
> +	}
> +
> +	return index;
> +}
> +
> +static struct cpuidle_driver haltpoll_driver = {
> +	.name = "haltpoll_idle",
> +	.owner = THIS_MODULE,
> +	.states = {
> +		{ /* entry 0 is for polling */ },
> +		{
> +			.enter			= haltpoll_enter_idle,
> +			.exit_latency		= 0,
> +			.target_residency	= 0,
> +			.power_usage		= -1,
> +			.name			= "Halt poll",
> +			.desc			= "Halt poll idle",
> +		},
> +	},
> +	.safe_state_index = 0,
> +	.state_count = 2,
> +};
> +
> +static int __init haltpoll_init(void)
> +{
> +	return cpuidle_register(&haltpoll_driver, NULL);
> +}
> +
> +static void __exit haltpoll_exit(void)
> +{
> +	cpuidle_unregister(&haltpoll_driver);
> +}
> +
> +module_init(haltpoll_init);
> +module_exit(haltpoll_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Marcelo Tosatti <mtosatti@redhat.com>");
> +
> 
> 

