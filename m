Return-Path: <kvm+bounces-66049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56362CC01B8
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 23:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E9736301559A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A14314B94;
	Mon, 15 Dec 2025 22:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QqCpZvXj"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F8F2E8B84
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 22:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765836757; cv=none; b=Vx2bdK+sVcxH0zX/s8ZPIej/2dO7R9JLCF2hZJ9nMVxOdmSPyuuLfacHyOLVMKNG61Acmu1aJlbGOVgokBazvkoCdTyMMnMPO+Ugu1vHt1guL7QCRVvlNqj4YhLf/v/4seoUf9fLVtKwNieyaqGkb+RguZ7turK6L6SLmRYU0tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765836757; c=relaxed/simple;
	bh=nPkH3c3/rxV5IKWAkK96RNqFJ+FTWB8jUxQkebaW4cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/RdqZy6pZi2kngJHcMSi21UrgtFq4QE+SJJxKjy09cpISwZR40yos1wydQHOM4VWsuw9O+i5XwIMifMwxMW57dw7ImvaXNbPiW1y2yGRWrhQbscbcZyGamKrAHf9InUhQufHdVU3OK6ftXFVJqYBqSdqKOfNLZIXLuhO0EQDeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QqCpZvXj; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Dec 2025 22:12:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765836748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sVm9cCoUArINfS7ckdaFcEfbx9Uo347WoKYfiEWGVcc=;
	b=QqCpZvXjMWEK0S9p0fU/OlAzZBvya2G6IwqvjoZqGYSv/ZIv/0kp3RvejLG8l6WrAihiei
	/pdBQNnTK69fiqazBZ4ASY7zXxhMim5kY7axM0LTam3NAhdgrPRambqI5J/IaLNQz+77vy
	SgXiwCXJZMuX1TeqX2Z+J1Yc7JIEDSw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Subject: Re: [kvm-unit-tests PATCH v2 2/2] x86/svm: Add unsupported
 instruction intercept test
Message-ID: <uddjlpv6cl54zt2zndreal4dotyr4pjjp6s633htrxa6vspr3c@tz67f5wd6w5w>
References: <20251215210026.2422155-1-chengkev@google.com>
 <20251215210026.2422155-3-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215210026.2422155-3-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 09:00:26PM +0000, Kevin Cheng wrote:
> Add tests that expect a nested vm exit, due to an unsupported
> instruction, to be handled by L0 even if L1 intercepts are set for that
> instruction.
> 
> The new test exercises bug fixed by:
> https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Ditto miscommunication around this tag, haven't really given it out yet.

> ---
>  x86/svm.h         |  5 +++-
>  x86/svm_tests.c   | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>  x86/unittests.cfg |  9 ++++++-
>  3 files changed, 75 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/svm.h b/x86/svm.h
> index c22c252fed001..e2158ab0622bb 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -406,7 +406,10 @@ struct __attribute__ ((__packed__)) vmcb {
>  #define SVM_EXIT_MONITOR	0x08a
>  #define SVM_EXIT_MWAIT		0x08b
>  #define SVM_EXIT_MWAIT_COND	0x08c
> -#define SVM_EXIT_NPF  		0x400
> +#define SVM_EXIT_XSETBV		0x08d
> +#define SVM_EXIT_RDPRU		0x08e
> +#define SVM_EXIT_INVPCID	0x0a2
> +#define SVM_EXIT_NPF		0x400
>  
>  #define SVM_EXIT_ERR		-1
>  
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index e732fb4eeea38..ec14f13c06d4b 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -3575,6 +3575,68 @@ static void svm_shutdown_intercept_test(void)
>  	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
>  }
>  
> +static void insn_invpcid(struct svm_test *test)
> +{
> +	struct invpcid_desc desc = {0};
> +
> +	invpcid_safe(0, &desc);
> +}

I know I suggested using invpcid_safe(), but I just realized we're just
passing 0's. So probably best to just add it in the assembly code below?
Any reason not to?

> +
> +asm(
> +	"insn_rdtscp: rdtscp;ret\n\t"
> +	"insn_skinit: skinit;ret\n\t"
> +	"insn_xsetbv: xor %eax, %eax; xor %edx, %edx; xor %ecx, %ecx; xsetbv;ret\n\t"
> +	"insn_rdpru: xor %ecx, %ecx; rdpru;ret\n\t"
> +);
> +
> +extern void insn_rdtscp(struct svm_test *test);
> +extern void insn_skinit(struct svm_test *test);
> +extern void insn_xsetbv(struct svm_test *test);
> +extern void insn_rdpru(struct svm_test *test);
> +
> +struct insn_table {
> +	const char *name;
> +	u64 intercept;
> +	void (*insn_func)(struct svm_test *test);
> +	u32 reason;
> +};
> +
> +static struct insn_table insn_table[] = {
> +	{ "RDTSCP", INTERCEPT_RDTSCP, insn_rdtscp, SVM_EXIT_RDTSCP},
> +	{ "SKINIT", INTERCEPT_SKINIT, insn_skinit, SVM_EXIT_SKINIT},
> +	{ "XSETBV", INTERCEPT_XSETBV, insn_xsetbv, SVM_EXIT_XSETBV},
> +	{ "RDPRU", INTERCEPT_RDPRU, insn_rdpru, SVM_EXIT_RDPRU},
> +	{ "INVPCID", INTERCEPT_INVPCID, insn_invpcid, SVM_EXIT_INVPCID},
> +	{ NULL },
> +};
> +
> +/*
> + * Test that L1 does not intercept instructions that are not advertised in
> + * guest CPUID.
> + */

We should probably add assertions that the guest CPU does not have the
features, in case wrong QEMU parameters are passed in unittests.cfg, or
KVM starts advertising RDPRU (for example).

> +static void svm_unsupported_instruction_intercept_test(void)
> +{
> +	u32 cur_insn;
> +	u32 exit_code;
> +
> +	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
> +
> +	for (cur_insn = 0; insn_table[cur_insn].name != NULL; ++cur_insn) {
> +		test_set_guest(insn_table[cur_insn].insn_func);
> +		vmcb_set_intercept(insn_table[cur_insn].intercept);
> +		svm_vmrun();
> +		exit_code = vmcb->control.exit_code;
> +
> +		if (exit_code == SVM_EXIT_EXCP_BASE + UD_VECTOR)
> +			report_pass("UD Exception injected");
> +		else if (exit_code == insn_table[cur_insn].reason)
> +			report_fail("L1 should not intercept %s when instruction is not advertised in guest CPUID",
> +				    insn_table[cur_insn].name);
> +		else
> +			report_fail("Unknown exit reason, 0x%x", exit_code);
> +	}
> +}
> +
>  struct svm_test svm_tests[] = {
>  	{ "null", default_supported, default_prepare,
>  	  default_prepare_gif_clear, null_test,
> @@ -3716,6 +3778,7 @@ struct svm_test svm_tests[] = {
>  	TEST(svm_tsc_scale_test),
>  	TEST(pause_filter_test),
>  	TEST(svm_shutdown_intercept_test),
> +	TEST(svm_unsupported_instruction_intercept_test),
>  	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
>  
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 522318d32bf68..5a2084e457167 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -253,11 +253,18 @@ arch = x86_64
>  [svm]
>  file = svm.flat
>  smp = 2
> -test_args = "-pause_filter_test"
> +test_args = "-pause_filter_test -svm_unsupported_instruction_intercept_test"
>  qemu_params = -cpu max,+svm -m 4g
>  arch = x86_64
>  groups = svm
>  
> +[svm_unsupported_instruction_intercept_test]
> +file = svm.flat
> +test_args = "svm_unsupported_instruction_intercept_test"
> +qemu_params = -cpu max,+svm,-rdtscp,-xsave,-invpcid,-skinit

Maybe add a comment about rdpru?

> +arch = x86_64
> +groups = svm
> +
>  [svm_pause_filter]
>  file = svm.flat
>  test_args = pause_filter_test
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

