Return-Path: <kvm+bounces-35370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC47A1060D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 12:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01115161A30
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 11:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4A72361E7;
	Tue, 14 Jan 2025 11:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iVt8KeJu"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210222361C8
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 11:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736855954; cv=none; b=kmM2a29mNvfcGFqFMaqZQun4i3fgar0uf13uv+Tkk2+Lzka81MY0JaGzKNVMkWaqHbmREKxmXNFRx5H/o3zLBFKX1ciCITtIRaJ3p6tOrL7d5UCxKXRvL4w8hFgFkIfRYeHdFGj72dk5pdXyUaprfTUdyli7KERFZ+qOwlsXs90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736855954; c=relaxed/simple;
	bh=IV/vsA0p5LP/HTIDj7cBlGl2dD4eRH7mCPB2qSv0pJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rrz8+Gx1SkM6Nunbc2D5td4qDHOBROefZPLkOrfARqY7P8tHnYgB1w9b0Bogwrb3lTY/10x3bl0TtBgS+V32cvfKVjkQ/3kumx5gpdNyoeuzKNs62THZKyhDSlqqpgAZW8mys5UOIFWsFqsCkpnliOGetZKg6XJgRHjskQhLRw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iVt8KeJu; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 14 Jan 2025 12:59:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736855948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ox55oql2rRXAzJeVGKoYQQU+DDSlyXeFZoboOP1k/Fk=;
	b=iVt8KeJuwn6hmqnXKMsPBzzL6YxO9JEC8MdUr1CYxmBdR738Bp++KWfxBe1GV8ABguZmgP
	EJgFGqDEHbiDYrT3Dwexl9IB3siS43GJbwcB+u55eoFpfMATvU8SdeNm7Z5mKdUP3aUhdC
	UqvqasdgTjtC9l6ZhqeT5VnZm4UpHw4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v4 5/5] riscv: sbi: Add SSE extension tests
Message-ID: <20250114-bfcab3a5629c66ef1215060a@orel>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
 <20241125162200.1630845-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241125162200.1630845-6-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT


Continuing review...

On Mon, Nov 25, 2024 at 05:21:54PM +0100, Clément Léger wrote:
...
> +static void sse_test_inject_global(unsigned long event_id)
> +{
> +	unsigned long ret;
> +	unsigned int cpu;
> +	struct sse_handler_arg args;
> +	volatile struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
> +	enum sbi_sse_state state;
> +
> +	args.handler = sse_foreign_cpu_handler;
> +	args.handler_data = (void *)&test_arg;
> +	args.stack = sse_alloc_stack();
> +
> +	report_prefix_push("global_dispatch");
> +
> +	ret = sse_event_register(event_id, &args);
> +	if (ret)

print/report something here?

> +		goto done;
> +
> +	for_each_online_cpu(cpu) {
> +		test_arg.expected_cpu = cpu;
> +		/* For test_arg content to be visible for other CPUs */
> +		smp_wmb();
> +		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART, cpu);
> +		if (ret) {
> +			report_fail("Failed to set preferred hart");
> +			goto done;
> +		}
> +
> +		ret = sse_event_enable(event_id);
> +		if (ret) {
> +			report_fail("Failed to enable SSE event");
> +			goto done;
> +		}
> +
> +		ret = sse_event_inject(event_id, cpu);
> +		if (ret) {
> +			report_fail("Failed to inject event");
> +			goto done;
> +		}
> +
> +		while (!test_arg.done) {
> +			/* For shared test_arg structure */
> +			smp_rmb();
> +		}
> +
> +		test_arg.done = false;
> +
> +		/* Wait for event to be in ENABLED state */
> +		do {
> +			ret = sse_get_state(event_id, &state);
> +			if (ret) {
> +				report_fail("Failed to get event state");
> +				goto done;
> +			}
> +		} while (state != SBI_SSE_STATE_ENABLED);
> +
> +		ret = sse_event_disable(event_id);
> +		if (ret) {
> +			report_fail("Failed to disable SSE event");
> +			goto done;
> +		}
> +
> +		report_pass("Global event on CPU %d", cpu);
> +	}

Breaking this into two parts

 for_each_online_cpu() {
    ... inject event ...
 }
 ... wait a bit ...
 for_each_online_cpu() {
    ... check results ...
 }

would allow testing that the SBI implementation can handle
simultaneous requests.

> +
> +done:
> +	ret = sse_event_unregister(event_id);
> +	if (ret)
> +		report_fail("Failed to unregister event");

If we came here from the 'goto done' for sse_event_register(), then I'd
expect unregister to fail since we failed to register.

> +
> +	sse_free_stack(args.stack);
> +	report_prefix_pop();
> +}
> +
> +struct priority_test_arg {
> +	unsigned long evt;
> +	bool called;
> +	u32 prio;
> +	struct priority_test_arg *next_evt_arg;
> +	void (*check_func)(struct priority_test_arg *arg);
> +};
> +
> +static void sse_hi_priority_test_handler(void *arg, struct pt_regs *regs,
> +					 unsigned int hartid)
> +{
> +	struct priority_test_arg *targ = arg;
> +	struct priority_test_arg *next = targ->next_evt_arg;
> +
> +	targ->called = 1;

nit: = true

> +	if (next) {
> +		sse_event_inject(next->evt, current_thread_info()->hartid);
> +		if (sse_event_pending(next->evt))
> +			report_fail("Higher priority event is pending");
> +		if (!next->called)
> +			report_fail("Higher priority event was not handled");

Should change these if-report-fails to report()'s

> +	}
> +}
> +
> +static void sse_low_priority_test_handler(void *arg, struct pt_regs *regs,
> +					  unsigned int hartid)
> +{
> +	struct priority_test_arg *targ = arg;
> +	struct priority_test_arg *next = targ->next_evt_arg;
> +
> +	targ->called = 1;
  
nit: = true

> +
> +	if (next) {
> +		sse_event_inject(next->evt, current_thread_info()->hartid);
> +
> +		if (!sse_event_pending(next->evt))
> +			report_fail("Lower priority event is pending");
> +
> +		if (next->called)
> +			report_fail("Lower priority event %s was handle before %s",
> +			      sse_evt_name(next->evt), sse_evt_name(targ->evt));

Should change these if-report-fails to report()'s

> +	}
> +}
> +
> +static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
> +					    unsigned int in_args_size,
> +					    sse_handler_fn handler,
> +					    const char *test_name)
> +{
> +	unsigned int i;
> +	int ret;
> +	unsigned long event_id;
> +	struct priority_test_arg *arg;
> +	unsigned int args_size = 0;
> +	struct sse_handler_arg event_args[in_args_size];
> +	struct priority_test_arg *args[in_args_size];
> +	void *stack;
> +	struct sse_handler_arg *event_arg;
> +
> +	report_prefix_push(test_name);
> +
> +	for (i = 0; i < in_args_size; i++) {
> +		arg = &in_args[i];
> +		event_id = arg->evt;
> +		if (!sse_evt_can_inject(event_id))
> +			continue;
> +
> +		args[args_size] = arg;
> +		args_size++;
> +	}
> +
> +	if (!args_size) {
> +		report_skip("No event injectable");
> +		report_prefix_pop();
> +		goto skip;
> +	}
> +
> +	for (i = 0; i < args_size; i++) {
> +		arg = args[i];
> +		event_id = arg->evt;
> +		stack = sse_alloc_stack();
> +
> +		event_arg = &event_args[i];
> +		event_arg->handler = handler;
> +		event_arg->handler_data = (void *)arg;
> +		event_arg->stack = stack;
> +
> +		if (i < (args_size - 1))
> +			arg->next_evt_arg = args[i + 1];
> +		else
> +			arg->next_evt_arg = NULL;
> +
> +		/* Be sure global events are targeting the current hart */
> +		sse_global_event_set_current_hart(event_id);
> +
> +		sse_event_register(event_id, event_arg);
> +		sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIORITY, arg->prio);
> +		sse_event_enable(event_id);
> +	}
> +
> +	/* Inject first event */
> +	ret = sse_event_inject(args[0]->evt, current_thread_info()->hartid);
> +	report(ret == SBI_SUCCESS, "SSE injection no error");
> +
> +	for (i = 0; i < args_size; i++) {
> +		arg = args[i];
> +		event_id = arg->evt;
> +
> +		if (!arg->called)
> +			report_fail("Event %s handler called", sse_evt_name(arg->evt));

report()

> +
> +		sse_event_disable(event_id);
> +		sse_event_unregister(event_id);
> +
> +		event_arg = &event_args[i];
> +		sse_free_stack(event_arg->stack);
> +	}
> +
> +skip:
> +	report_prefix_pop();
> +}
> +
> +static struct priority_test_arg hi_prio_args[] = {
> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
> +};
> +
> +static struct priority_test_arg low_prio_args[] = {
> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
> +};
> +
> +static struct priority_test_arg prio_args[] = {
> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 5},
> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 15},
> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 25},
> +};
> +
> +static struct priority_test_arg same_prio_args[] = {
> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 0},
> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 10},
> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 10},
> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
> +};
> +
> +static void sse_test_injection_priority(void)
> +{
> +	report_prefix_push("prio");
> +
> +	sse_test_injection_priority_arg(hi_prio_args, ARRAY_SIZE(hi_prio_args),
> +					sse_hi_priority_test_handler, "high");
> +
> +	sse_test_injection_priority_arg(low_prio_args, ARRAY_SIZE(low_prio_args),
> +					sse_low_priority_test_handler, "low");
> +
> +	sse_test_injection_priority_arg(prio_args, ARRAY_SIZE(prio_args),
> +					sse_low_priority_test_handler, "changed");
> +
> +	sse_test_injection_priority_arg(same_prio_args, ARRAY_SIZE(same_prio_args),
> +					sse_low_priority_test_handler, "same_prio_args");
> +
> +	report_prefix_pop();
> +}
> +
> +static bool sse_can_inject(unsigned long event_id)
> +{
> +	int ret;
> +	unsigned long status;
> +
> +	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
> +	report(ret == 0, "SSE get attr status no error");

I'm not sure we need this report()

> +	if (ret)
> +		return 0;

nit: return false

> +
> +	return !!(status & BIT(SBI_SSE_ATTR_STATUS_INJECT_OFFSET));
> +}
> +
> +static void boot_secondary(void *data)
> +{
> +	sse_hart_unmask();
> +}
> +
> +static void sse_check_mask(void)
> +{
> +	int ret;
> +
> +	/* Upon boot, event are masked, check that */
> +	ret = sse_hart_mask();
> +	report(ret == SBI_ERR_ALREADY_STARTED, "SSE hart mask at boot time ok");

The spec says that trying to mask twice should return
SBI_ERR_ALREADY_STOPPED. If this test is passing then we probably have it
backwards in opensbi too.

> +
> +	ret = sse_hart_unmask();
> +	report(ret == SBI_SUCCESS, "SSE hart no error ok");
> +	ret = sse_hart_unmask();
> +	report(ret == SBI_ERR_ALREADY_STOPPED, "SSE hart unmask twice error ok");

Should be SBI_ERR_ALREADY_STARTED

> +
> +	ret = sse_hart_mask();
> +	report(ret == SBI_SUCCESS, "SSE hart mask no error");
> +	ret = sse_hart_mask();
> +	report(ret == SBI_ERR_ALREADY_STARTED, "SSE hart mask twice ok");

SBI_ERR_ALREADY_STOPPED

> +}
> +
> +void check_sse(void)
> +{
> +	unsigned long i, event;
> +
> +	report_prefix_push("sse");
> +	sse_check_mask();

I guess the mask check should come after the sbi_probe()

> +
> +	/*
> +	 * Dummy wakeup of all processors since some of them will be targeted
> +	 * by global events without going through the wakeup call as well as
> +	 * unmasking all 
> +	 */
> +	on_cpus(boot_secondary, NULL);
> +
> +	if (!sbi_probe(SBI_EXT_SSE)) {
> +		report_skip("SSE extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
> +		event = sse_event_infos[i].event_id;
> +		report_prefix_push(sse_event_infos[i].name);
> +		if (!sse_can_inject(event)) {
> +			report_skip("Event does not support injection");

Let's output the event ID too.

> +			report_prefix_pop();
> +			continue;
> +		} else {
> +			sse_event_infos[i].can_inject = true;
> +		}
> +		sse_test_attr(event);
> +		sse_test_register_error(event);
> +		sse_test_inject_simple(event);
> +		if (sse_event_is_global(event))
> +			sse_test_inject_global(event);
> +		else
> +			sse_test_inject_local(event);
> +
> +		report_prefix_pop();
> +	}
> +
> +	sse_test_injection_priority();
> +
> +	report_prefix_pop();
> +}
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 6f4ddaf1..33d5e40d 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -32,6 +32,8 @@
>  
>  #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
>  
> +void check_sse(void);
> +
>  static long __labs(long a)
>  {
>  	return __builtin_labs(a);
> @@ -1451,6 +1453,7 @@ int main(int argc, char **argv)
>  	check_hsm();
>  	check_dbcn();
>  	check_susp();
> +	check_sse();
>  
>  	return report_summary();
>  }
> -- 
> 2.45.2
> 

Thanks,
drew

