Return-Path: <kvm+bounces-40246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6B8A54EB3
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:15:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1E671897DB4
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 15:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D587C20E016;
	Thu,  6 Mar 2025 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="awgjPrqG"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626851422A8
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741274113; cv=none; b=Zu97oua6imQ7ImEVTAoLwKJ0C2vD+30lTDxwOq9OW9P0dWKCpgrZZSQNo8dkYnA0AnQZWAYjg2a6P8H+iBysDrH0/v+l9nRP8oHdDxmVLNwLMmqywGNH81wf2sTtKX2Ah4gwHe6QoDcrsS5bN+1YqbeKskZ03eEpIr8bXyEabUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741274113; c=relaxed/simple;
	bh=YLnyndirqOvTPaPblji8B/aRLU9k3jAx/h3tWxpJvko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLtIDoUcgT28Oa6ab4hqzZOunk/LKzjogVmtlKKScklgI1OIUsgEtVR0tNE1V7TXTehOR/UhFGBC5hbmtBdaoj/kParmvaIwBCU6eObJj40Z6VHkF3GLA56LKK4na0cHCSY8fXTMRtkTHOz0EPqIgkVvB+EtI2hX78KkUj+5ENM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=awgjPrqG; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 6 Mar 2025 16:15:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741274108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVH0GxmWmcu/UgBN4gM6j99Mf09UV1MGgTDFHSQe7xs=;
	b=awgjPrqGX7DrTrDLvctmgTXfKtUMvPuFfeK/N5E6bNTd+ACdSlmnDf0ZqdV5yXyGiiMh36
	il9O9NP3lcdrQlffuKAnVnoWdPX8k7jgKkj8kd6/wTGQhL47Y8BGpq6V/jSjIx5NJoeCjL
	sAHkemNZe0+6p2zt+YTHY37ioxJCJo0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v7 6/6] riscv: sbi: Add SSE extension tests
Message-ID: <20250306-5f8b0b45873648fa93beccc7@orel>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
 <20250214114423.1071621-7-cleger@rivosinc.com>
 <20250227-93a15f012d9bda941ef44e38@orel>
 <d37dc38b-ba6d-48cd-8d23-9e2ce9c6581e@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d37dc38b-ba6d-48cd-8d23-9e2ce9c6581e@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 06, 2025 at 03:32:39PM +0100, Clément Léger wrote:
> 
> 
> On 28/02/2025 18:51, Andrew Jones wrote:
...
> >> +	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
> >> +	ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
> >> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save interrupted flags no error");
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
> >> +		flags = interrupted_flags[i];
> >> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
> >> +		sbiret_report_error(&ret, SBI_SUCCESS,
> >> +				    "Set interrupted flags bit 0x%lx value no error", flags);
> >> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
> >> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted flags after set no error");
> >> +		report(value == flags, "interrupted flags modified value ok: 0x%lx", value);
> > 
> > Do we also need to test with more than one flag set at a time?
> 
> That is already done a few lines above (see /* Restore full saved state */).

OK

> 
> > 
> >> +	}
> >> +
> >> +	/* Write invalid bit in flag register */
> >> +	flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT << 1;
> >> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
> >> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
> >> +			    flags);
> >> +#if __riscv_xlen > 32
> >> +	flags = BIT(32);
> >> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
> >> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
> > 
> > This should have a different report string than the test above.
> 
> The bit value format does differentiate the printf though.

OK

...
> >> +	ret = sbi_sse_unregister(event_id);
> >> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE unregister no error"))
> >> +		goto done;
> >> +
> >> +	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
> >> +
> >> +done:
> > 
> > Is it ok to leave this function with an event registered/enabled? If not,
> > then some of the goto's above should goto other labels which disable and
> > unregister.
> 
> No it's not but it's massive pain to keep everything coherent when it
> fails ;)
>

asserts/aborts are fine if we can't recover easily, but then we should
move the SSE tests out of the main SBI test into its own test so we
don't short-circuit all other tests that may follow it.

...
> >> +		/* Be sure global events are targeting the current hart */
> >> +		sse_global_event_set_current_hart(event_id);
> >> +
> >> +		sbi_sse_register(event_id, event_arg);
> >> +		value = arg->prio;
> >> +		sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
> >> +		sbi_sse_enable(event_id);
> > 
> > No return code checks for these SSE calls? If we're 99% sure they should
> > succeed, then I'd still check them with asserts.
> 
> I was a bit lazy here. Since the goal is *not* to check the event state
> themselve but rather the ordering, I didn't bother checking them. As
> said before, habndling error and event state properly in case of error
> seemed like a churn to me *just* for testing. I'll try something better
> as well though.
> 

We always want at least asserts() in order to catch the train when it
first goes off the rails, rather than after it smashed through a village
or two.

Thanks,
drew

