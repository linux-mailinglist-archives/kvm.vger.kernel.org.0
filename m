Return-Path: <kvm+bounces-41063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 180CAA61365
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:12:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1EBB883A3F
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5674020110B;
	Fri, 14 Mar 2025 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A2OhWF5J"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50271FF7C1
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741961482; cv=none; b=GFbaN2Mz5BZEc//KrjSvmD+754P1h/wHbjxpivAHkMZ22u/xDf08pwlGWMShVQ96BMT18ekXRXV+F0NJrC+OEzfSgx5WiXK6P4AgysE6fWLrWaq7Voz7MRQbbsSJI9saFVkUDTmSiUzKeem3ustM/T10Q78o9Cg6rOnD8+SZwVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741961482; c=relaxed/simple;
	bh=zBCgISH3posrm6P5IkNvIF504v8Bf1gHw3iaJezx0rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hmxu6mZtop4Rucg+xjXgrEHhMLocHCwA+zcx/4vAPMi8Cfa5aGQYJ5jR2I6/0xJR5vUaD8QetJ9QLqKW2Ek5BRukUbBGjIRc4ZlGR446FL4G6CNdxByfoXT0hRfIDFNKyDw8OOxq29Bdk9B45ja1bqpHbLJMo33c0LY4WritwBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A2OhWF5J; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Mar 2025 15:11:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741961477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iE/wJzW/iMea/0NTGsZB5pMBUzUt6UFrylXVlwTLhN4=;
	b=A2OhWF5J+h372lLcm8Kiy+kwtYrhFwPi7CL0wsgT+V2w3D8A+iPvEGcHmpQcD3e4oTwQYu
	bEsnOmAp3CPC8M8G4wazS6PF1q2dxDx56m9Yijdo2qfo2HW+UMndj+shsymEM11CAPw1hz
	lkPlvDg4l+AFMMt4jv5mcteEJTmOlVE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v9 6/6] riscv: sbi: Add SSE extension tests
Message-ID: <20250314-0940c2c0dcd92b285f43e4ca@orel>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
 <20250314111030.3728671-7-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250314111030.3728671-7-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 12:10:29PM +0100, Clément Léger wrote:
...
> +static void sse_test_inject_local(uint32_t event_id)
> +{
> +	int cpu;
> +	uint64_t timeout;
> +	struct sbiret ret;
> +	struct sse_local_per_cpu *cpu_args, *cpu_arg;
> +	struct sse_foreign_cpu_test_arg *handler_arg;
> +
> +	cpu_args = calloc(NR_CPUS, sizeof(struct sbi_sse_handler_arg));
> +
> +	report_prefix_push("local_dispatch");
> +	for_each_online_cpu(cpu) {
> +		cpu_arg = &cpu_args[cpu];
> +		cpu_arg->handler_arg.event_id = event_id;
> +		cpu_arg->args.stack = sse_alloc_stack();
> +		cpu_arg->args.handler = sse_foreign_cpu_handler;
> +		cpu_arg->args.handler_data = (void *)&cpu_arg->handler_arg;
> +		cpu_arg->state = SBI_SSE_STATE_UNUSED;
> +	}
> +
> +	on_cpus(sse_register_enable_local, cpu_args);
> +	for_each_online_cpu(cpu) {
> +		cpu_arg = &cpu_args[cpu];
> +		ret = cpu_arg->ret;
> +		if (ret.error) {
> +			report_fail("CPU failed to register/enable event: %ld", ret.error);
> +			goto cleanup;
> +		}
> +
> +		handler_arg = &cpu_arg->handler_arg;
> +		WRITE_ONCE(handler_arg->expected_cpu, cpu);
> +		/* For handler_arg content to be visible for other CPUs */
> +		smp_wmb();
> +		ret = sbi_sse_inject(event_id, cpus[cpu].hartid);
> +		if (ret.error) {
> +			report_fail("CPU failed to inject event: %ld", ret.error);
> +			goto cleanup;
> +		}
> +	}
> +
> +	for_each_online_cpu(cpu) {
> +		handler_arg = &cpu_args[cpu].handler_arg;
> +		smp_rmb();
> +
> +		timeout = sse_event_get_complete_timeout();
> +		while (!READ_ONCE(handler_arg->done) || timer_get_cycles() < timeout) {

I pointed this out in the last review, the || should be a &&. We don't
want to keep waiting until we reach the timeout if we get the done signal
earlier.

> +			/* For handler_arg update to be visible */
> +			smp_rmb();
> +			cpu_relax();
> +		}
> +		report(READ_ONCE(handler_arg->done), "Event handled");
> +		WRITE_ONCE(handler_arg->done, false);
> +	}
> +
> +cleanup:
> +	on_cpus(sbi_sse_disable_unregister_local, cpu_args);
> +	for_each_online_cpu(cpu) {
> +		cpu_arg = &cpu_args[cpu];
> +		ret = READ_ONCE(cpu_arg->ret);
> +		if (ret.error)
> +			report_fail("CPU failed to disable/unregister event: %ld", ret.error);
> +	}
> +
> +	for_each_online_cpu(cpu) {
> +		cpu_arg = &cpu_args[cpu];
> +		sse_free_stack(cpu_arg->args.stack);
> +	}
> +
> +	report_prefix_pop();
> +}
> +
> +static void sse_test_inject_global_cpu(uint32_t event_id, unsigned int cpu,
> +				       struct sse_foreign_cpu_test_arg *test_arg)
> +{
> +	unsigned long value;
> +	struct sbiret ret;
> +	uint64_t timeout;
> +	enum sbi_sse_state state;
> +
> +	WRITE_ONCE(test_arg->expected_cpu, cpu);
> +	/* For test_arg content to be visible for other CPUs */
> +	smp_wmb();
> +	value = cpu;
> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Set preferred hart"))
> +		return;
> +
> +	ret = sbi_sse_enable(event_id);
> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Enable event"))
> +		return;
> +
> +	ret = sbi_sse_inject(event_id, cpu);
> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Inject event"))
> +		goto disable;
> +
> +	smp_rmb();
> +	timeout = sse_event_get_complete_timeout();
> +	while (!READ_ONCE(test_arg->done) || timer_get_cycles() < timeout) {

same comment

> +		/* For shared test_arg structure */
> +		smp_rmb();
> +		cpu_relax();
> +	}
> +
> +	report(READ_ONCE(test_arg->done), "event handler called");
> +	WRITE_ONCE(test_arg->done, false);
> +
> +	timeout = sse_event_get_complete_timeout();
> +	/* Wait for event to be back in ENABLED state */
> +	do {
> +		ret = sse_event_get_state(event_id, &state);
> +		if (ret.error)
> +			goto disable;
> +		cpu_relax();
> +	} while (state != SBI_SSE_STATE_ENABLED || timer_get_cycles() < timeout);

same comment

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

