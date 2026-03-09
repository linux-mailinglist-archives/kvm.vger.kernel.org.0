Return-Path: <kvm+bounces-73271-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UGLFDySJrmnKFgIAu9opvQ
	(envelope-from <kvm+bounces-73271-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:47:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98FB2235A96
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FBA03035AA0
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 08:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D99338910;
	Mon,  9 Mar 2026 08:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvJhrhdh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9F23093C3;
	Mon,  9 Mar 2026 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773045832; cv=none; b=AAmuIBCuhISA+E+TDEaikBoadfVqzmIg4/IPNVMHTwswa43TWd6B23wY5mOrDIpqAPY+YsQFeGlXmnHAixEyS1xdk1G4SUeC53LlsZ9Ks7xmddaw9Cjs99liwKYJEw9CL/+f+l9pNg/UcT0RDzCpMxSbj4E5q7XCuXa3zcUDhe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773045832; c=relaxed/simple;
	bh=R0Tj8WHPpvIY04QiJfIurzlhzjfV000u26yyDgGvweo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ns9l44uiBiNooKuBXvbOtWpf2QAsUGZLfWOsXnSW9RZcFATx7B8tSsDjWMBv+3IohYv9HaJ6vgtKX7AnUEp276Y1GzTRyw3XFd/xkV8MipYHMlUG4aygOZtVJsXT+amKiPVJpfJ83vCnfhNjQI6ZrZigvWOf4ed1JT58+BbDudY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvJhrhdh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B812EC4CEF7;
	Mon,  9 Mar 2026 08:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773045832;
	bh=R0Tj8WHPpvIY04QiJfIurzlhzjfV000u26yyDgGvweo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LvJhrhdhbQozIAuWAlqXW3bj0cWo8FxnOWgkdMke7eRZtRR20Tv8o5cECmuZmGYK+
	 dBqhRaiCqlkEO0AdOUsxXmyF4MqENquSuSHBmz2RU47VGIJdubddTYCV9qRakBnbje
	 O5unNYzBed62xZ5MFgbrtjoTo28MBcjxmyBaGbRFpwxHRYoVzlpO3sSOS8ggVcqOFq
	 HbmwYbvG57oSLBYDozAq6nXOliqgesdIs76MP+Pa/lkgzIW3gkLP7SsXzNAn8IT0FP
	 Rwr0N9MBjMJld+itIy9r6hlCbW/vmJHmxt5o5a088yXOn46IJZ0xMCwU1Mzza1obzD
	 X5xgE1A2esdCQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Slaby
 <jirislaby@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, Stefano
 Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>, Linux Kernel
 <linux-kernel@vger.kernel.org>, Shinichiro Kawasaki
 <shinichiro.kawasaki@wdc.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, luto@kernel.org, Michal
 =?utf-8?Q?Koutn=C3=BD?=
 <MKoutny@suse.com>, Waiman Long <longman@redhat.com>, Marco Elver
 <elver@google.com>
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups,
 RCU stalls, timeout
In-Reply-To: <57c1e171-9520-4288-9e2d-10a72a499968@kernel.org>
References: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx>
 <20260306152458.GT606826@noisy.programming.kicks-ass.net>
 <87ldg42eu7.ffs@tglx> <87h5qr2rzi.ffs@tglx> <87eclu3coa.ffs@tglx>
 <87v7f61cnl.ffs@tglx> <57c1e171-9520-4288-9e2d-10a72a499968@kernel.org>
Date: Mon, 09 Mar 2026 09:43:48 +0100
Message-ID: <87pl5ds88r.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 98FB2235A96
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73271-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tglx@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.209];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sun, Mar 08 2026 at 18:23, Matthieu Baerts wrote:
> 08 Mar 2026 17:58:26 Thomas Gleixner <tglx@kernel.org>:
>> So I'm back to square one. I go and do what I should have done in the
>> first place. Write a debug patch with trace_printks and let the people
>> who can actually trigger the problem run with it.
>
> Happy to test such debug patches!

See below.

Enable the tracepoints either on the kernel command line:

    trace_event=sched_switch,mmcid:*

or before starting the test case:

    echo 1 >/sys/kernel/tracing/events/sched/sched_switch/enable
    echo 1 >/sys/kernel/tracing/events/mmcid/enable

I added a 50ms timeout into mm_cid_get() which freezes the trace and
emits a warning. If you enable panic_on_warn and ftrace_dump_on_oops,
then it dumps the trace buffer once it hits the warning.

Either kernel command line:

   panic_on_warn ftrace_dump_on_oops

or

  echo 1 >/proc/sys/kernel/panic_on_warn
  echo 1 >/proc/sys/kernel/ftrace_dump_on_oops

That should provide enough information to decode this mystery.

Thanks,

        tglx
---
 include/trace/events/mmcid.h |  138 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |   10 +++
 kernel/sched/sched.h         |   20 +++++-
 3 files changed, 165 insertions(+), 3 deletions(-)

--- /dev/null
+++ b/include/trace/events/mmcid.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mmcid
+
+#if !defined(_TRACE_MMCID_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MMCID_H
+
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(mmcid_class,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int cid),
+
+	TP_ARGS(mm, cid),
+
+	TP_STRUCT__entry(
+		__field( void *,	mm	)
+		__field( unsigned int,	cid	)
+	),
+
+	TP_fast_assign(
+		__entry->mm	= mm;
+		__entry->cid	= cid;
+	),
+
+	TP_printk("mm=%p cid=%08x", __entry->mm, __entry->cid)
+);
+
+DEFINE_EVENT(mmcid_class, mmcid_getcid,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int cid),
+
+	TP_ARGS(mm, cid)
+);
+
+DEFINE_EVENT(mmcid_class, mmcid_putcid,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int cid),
+
+	TP_ARGS(mm, cid)
+);
+
+DECLARE_EVENT_CLASS(mmcid_task_class,
+
+	TP_PROTO(struct task_struct *t, struct mm_struct *mm, unsigned int cid),
+
+	TP_ARGS(t, mm, cid),
+
+	TP_STRUCT__entry(
+		__field( void *,	t	)
+		__field( void *,	mm	)
+		__field( unsigned int,	cid	)
+	),
+
+	TP_fast_assign(
+		__entry->t	= t;
+		__entry->mm	= mm;
+		__entry->cid	= cid;
+	),
+
+	TP_printk("t=%p mm=%p cid=%08x", __entry->t, __entry->mm, __entry->cid)
+);
+
+DEFINE_EVENT(mmcid_task_class, mmcid_task_update,
+
+	TP_PROTO(struct task_struct *t, struct mm_struct *mm, unsigned int cid),
+
+	TP_ARGS(t, mm, cid)
+);
+
+DECLARE_EVENT_CLASS(mmcid_cpu_class,
+
+	TP_PROTO(unsigned int cpu, struct mm_struct *mm, unsigned int cid),
+
+	TP_ARGS(cpu, mm, cid),
+
+	TP_STRUCT__entry(
+		__field( unsigned int,	cpu	)
+		__field( void *,	mm	)
+		__field( unsigned int,	cid	)
+	),
+
+	TP_fast_assign(
+		__entry->cpu	= cpu;
+		__entry->mm	= mm;
+		__entry->cid	= cid;
+	),
+
+	TP_printk("cpu=%u mm=%p cid=%08x", __entry->cpu, __entry->mm, __entry->cid)
+);
+
+DEFINE_EVENT(mmcid_cpu_class, mmcid_cpu_update,
+
+	TP_PROTO(unsigned int cpu, struct mm_struct *mm, unsigned int cid),
+
+	TP_ARGS(cpu, mm, cid)
+);
+
+DECLARE_EVENT_CLASS(mmcid_user_class,
+
+	TP_PROTO(struct task_struct *t, struct mm_struct *mm),
+
+	TP_ARGS(t, mm),
+
+	TP_STRUCT__entry(
+		__field( void *,	t	)
+		__field( void *,	mm	)
+		__field( unsigned int,	users	)
+	),
+
+	TP_fast_assign(
+		__entry->t	= t;
+		__entry->mm	= mm;
+		__entry->users	= mm->mm_cid.users;
+	),
+
+	TP_printk("t=%p mm=%p users=%u", __entry->t, __entry->mm, __entry->users)
+);
+
+DEFINE_EVENT(mmcid_user_class, mmcid_user_add,
+
+	TP_PROTO(struct task_struct *t, struct mm_struct *mm),
+
+	TP_ARGS(t, mm)
+);
+
+DEFINE_EVENT(mmcid_user_class, mmcid_user_del,
+
+	TP_PROTO(struct task_struct *t, struct mm_struct *mm),
+
+	     TP_ARGS(t, mm)
+);
+
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -86,6 +86,7 @@
 #include <linux/sched/rseq_api.h>
 #include <trace/events/sched.h>
 #include <trace/events/ipi.h>
+#include <trace/events/mmcid.h>
 #undef CREATE_TRACE_POINTS
 
 #include "sched.h"
@@ -10569,7 +10570,9 @@ static inline void mm_cid_transit_to_tas
 		unsigned int cid = cpu_cid_to_cid(t->mm_cid.cid);
 
 		t->mm_cid.cid = cid_to_transit_cid(cid);
+		trace_mmcid_task_update(t, t->mm, t->mm_cid.cid);
 		pcp->cid = t->mm_cid.cid;
+		trace_mmcid_cpu_update(task_cpu(t), t->mm, pcp->cid);
 	}
 }
 
@@ -10602,7 +10605,9 @@ static void mm_cid_fixup_cpus_to_tasks(s
 			if (!cid_in_transit(cid)) {
 				cid = cid_to_transit_cid(cid);
 				rq->curr->mm_cid.cid = cid;
+				trace_mmcid_task_update(rq->curr, rq->curr->mm, cid);
 				pcp->cid = cid;
+				trace_mmcid_cpu_update(cpu, mm, cid);
 			}
 		}
 	}
@@ -10613,7 +10618,9 @@ static inline void mm_cid_transit_to_cpu
 {
 	if (cid_on_task(t->mm_cid.cid)) {
 		t->mm_cid.cid = cid_to_transit_cid(t->mm_cid.cid);
+		trace_mmcid_task_update(t, t->mm, t->mm_cid.cid);
 		pcp->cid = t->mm_cid.cid;
+		trace_mmcid_cpu_update(task_cpu(t), t->mm, pcp->cid);
 	}
 }
 
@@ -10685,6 +10692,7 @@ static bool sched_mm_cid_add_user(struct
 {
 	t->mm_cid.active = 1;
 	mm->mm_cid.users++;
+	trace_mmcid_user_add(t, mm);
 	return mm_update_max_cids(mm);
 }
 
@@ -10727,6 +10735,7 @@ void sched_mm_cid_fork(struct task_struc
 	} else {
 		mm_cid_fixup_cpus_to_tasks(mm);
 		t->mm_cid.cid = mm_get_cid(mm);
+		trace_mmcid_task_update(t, t->mm, t->mm_cid.cid);
 	}
 }
 
@@ -10739,6 +10748,7 @@ static bool sched_mm_cid_remove_user(str
 		mm_unset_cid_on_task(t);
 	}
 	t->mm->mm_cid.users--;
+	trace_mmcid_user_del(t, t->mm);
 	return mm_update_max_cids(t->mm);
 }
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -75,6 +75,7 @@
 #include <linux/delayacct.h>
 #include <linux/mmu_context.h>
 
+#include <trace/events/mmcid.h>
 #include <trace/events/power.h>
 #include <trace/events/sched.h>
 
@@ -3809,6 +3810,7 @@ static __always_inline bool cid_on_task(
 
 static __always_inline void mm_drop_cid(struct mm_struct *mm, unsigned int cid)
 {
+	trace_mmcid_putcid(mm, cid);
 	clear_bit(cid, mm_cidmask(mm));
 }
 
@@ -3817,6 +3819,7 @@ static __always_inline void mm_unset_cid
 	unsigned int cid = t->mm_cid.cid;
 
 	t->mm_cid.cid = MM_CID_UNSET;
+	trace_mmcid_task_update(t, t->mm, t->mm_cid.cid);
 	if (cid_on_task(cid))
 		mm_drop_cid(t->mm, cid);
 }
@@ -3838,6 +3841,7 @@ static inline unsigned int __mm_get_cid(
 		return MM_CID_UNSET;
 	if (test_and_set_bit(cid, mm_cidmask(mm)))
 		return MM_CID_UNSET;
+	trace_mmcid_getcid(mm, cid);
 	return cid;
 }
 
@@ -3845,9 +3849,17 @@ static inline unsigned int mm_get_cid(st
 {
 	unsigned int cid = __mm_get_cid(mm, READ_ONCE(mm->mm_cid.max_cids));
 
-	while (cid == MM_CID_UNSET) {
-		cpu_relax();
-		cid = __mm_get_cid(mm, num_possible_cpus());
+	if (cid == MM_CID_UNSET) {
+		ktime_t t0 = ktime_get();
+
+		while (cid == MM_CID_UNSET) {
+			cpu_relax();
+			cid = __mm_get_cid(mm, num_possible_cpus());
+			if (ktime_get() - t0 > 50 * NSEC_PER_MSEC) {
+				tracing_off();
+				WARN_ON_ONCE(1);
+			}
+		}
 	}
 	return cid;
 }
@@ -3874,6 +3886,7 @@ static inline unsigned int mm_cid_conver
 static __always_inline void mm_cid_update_task_cid(struct task_struct *t, unsigned int cid)
 {
 	if (t->mm_cid.cid != cid) {
+		trace_mmcid_task_update(t, t->mm, cid);
 		t->mm_cid.cid = cid;
 		rseq_sched_set_ids_changed(t);
 	}
@@ -3881,6 +3894,7 @@ static __always_inline void mm_cid_updat
 
 static __always_inline void mm_cid_update_pcpu_cid(struct mm_struct *mm, unsigned int cid)
 {
+	trace_mmcid_cpu_update(smp_processor_id(), mm, cid);
 	__this_cpu_write(mm->mm_cid.pcpu->cid, cid);
 }
 

