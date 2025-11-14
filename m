Return-Path: <kvm+bounces-63237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 47746C5E81A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD9234E2160
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504E2335BDC;
	Fri, 14 Nov 2025 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BsyHlbba"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377BB2BE7B4
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 16:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763139556; cv=none; b=HOn1UbfIfBjrvQgNZ61ZLqWPNawKNiGK7zQtlX80QlOkC7piZyzzQfqprGqsGkov22AOk6tRww4gs9VWXSeTWxb4qfShbEGbM9ENQzp7xGCYdpLtL75/rPKeNFCNCQSfMmbFo7WdRD+9WirDHO3fo/gasuKd9PixXqTdKMjT1dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763139556; c=relaxed/simple;
	bh=+dOQ7jRG4S/0pvgJaFhI7M+3TShnbhUgsgzHa+LjAJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dx8SPTG5v+bhiOuEBfNGQ79XW5gbCMt/s9f86gD7uWJob02aV3z/Dm7/nq68HgFoG9g9cxI27OcYV8B6X5amL/dtlkhOkxNoN8xHqFvvorp0R5VXiym65sfrOPHYIU6tQ6/5IClopWVZLv6VkRDstaqghSz4AQUzQT0uMK5cXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BsyHlbba; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Nov 2025 16:58:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763139552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HDFxcpDYjv5rvsXJWGP4wSDpRQhQscs1GzAfSTNXJq0=;
	b=BsyHlbba0J+QOdz3E0yVUG6D90OoOnaFtW/Ek/w0q9+bHR7DdoKb+mSzRgIEkV0UMzG3f8
	xjHzAjUWMQYR9w/xthw1Px8uINzOJwBtU8LExCN7bfoALQSoZu2Alm9jtDAUwUsJ5hTW3G
	syDagLyT+xtWevN4zHBAT+eK8olBOWw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Use GUEST_ASSERT_EQ() to check exit
 codes in Hyper-V SVM test
Message-ID: <ukijxjc4bprwhls6c2v3i7l7ghxqhabe42lje2fgke7rnuxocs@5nakwleh3wiw>
References: <20251114164001.1791718-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114164001.1791718-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 14, 2025 at 08:40:01AM -0800, Sean Christopherson wrote:
> Use GUEST_ASSERT_EQ() instead of GUEST_ASSERT(x == SVM_EXIT_<code>) in the
> Hyper-V SVM test so that the test prints the actual vs. expected values on
> failure.  E.g. instead of printing:
> 
>   vmcb->control.exit_code == SVM_EXIT_VMMCALL
> 
> print:
> 
>  0x7c != 0x81 (vmcb->control.exit_code != SVM_EXIT_VMMCALL)
> 
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM:
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

For the record, there are a few more instances:

$ git grep "GUEST_ASSERT(vmcb->control.exit_code"
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == HV_SVM_EXITCODE_ENL);
tools/testing/selftests/kvm/x86/hyperv_svm_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
tools/testing/selftests/kvm/x86/state_test.c:   GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
tools/testing/selftests/kvm/x86/state_test.c:   GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
tools/testing/selftests/kvm/x86/svm_int_ctl_test.c:     GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c:  __GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c:  __GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_HLT,
tools/testing/selftests/kvm/x86/svm_vmcall_test.c:      GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);

There's also a lot for VMX, you can find all/most of them by running git
grep "vmreadz(VM_EXIT_REASON)".

> ---
>  .../testing/selftests/kvm/x86/hyperv_svm_test.c  | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
> index 0ddb63229bcb..7fb988df5f55 100644
> --- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
> +++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
> @@ -94,7 +94,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
>  
>  	GUEST_SYNC(2);
>  	run_guest(vmcb, svm->vmcb_gpa);
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_VMMCALL);
>  	GUEST_SYNC(4);
>  	vmcb->save.rip += 3;
>  
> @@ -102,13 +102,13 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
>  	vmcb->control.intercept |= 1ULL << INTERCEPT_MSR_PROT;
>  	__set_bit(2 * (MSR_FS_BASE & 0x1fff), svm->msr + 0x800);
>  	run_guest(vmcb, svm->vmcb_gpa);
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
>  	vmcb->save.rip += 2; /* rdmsr */
>  
>  	/* Enable enlightened MSR bitmap */
>  	hve->hv_enlightenments_control.msr_bitmap = 1;
>  	run_guest(vmcb, svm->vmcb_gpa);
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
>  	vmcb->save.rip += 2; /* rdmsr */
>  
>  	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
> @@ -117,13 +117,13 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
>  	vmcb->control.clean |= HV_VMCB_NESTED_ENLIGHTENMENTS;
>  	run_guest(vmcb, svm->vmcb_gpa);
>  	/* Make sure we don't see SVM_EXIT_MSR here so eMSR bitmap works */
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_VMMCALL);
>  	vmcb->save.rip += 3; /* vmcall */
>  
>  	/* Now tell KVM we've changed MSR-Bitmap */
>  	vmcb->control.clean &= ~HV_VMCB_NESTED_ENLIGHTENMENTS;
>  	run_guest(vmcb, svm->vmcb_gpa);
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
>  	vmcb->save.rip += 2; /* rdmsr */
>  
>  
> @@ -132,16 +132,16 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
>  	 * no VMCALL exit expected.
>  	 */
>  	run_guest(vmcb, svm->vmcb_gpa);
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
>  	vmcb->save.rip += 2; /* rdmsr */
>  	/* Enable synthetic vmexit */
>  	*(u32 *)(hv_pages->partition_assist) = 1;
>  	run_guest(vmcb, svm->vmcb_gpa);
> -	GUEST_ASSERT(vmcb->control.exit_code == HV_SVM_EXITCODE_ENL);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  HV_SVM_EXITCODE_ENL);
>  	GUEST_ASSERT(vmcb->control.exit_info_1 == HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH);
>  
>  	run_guest(vmcb, svm->vmcb_gpa);
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_VMMCALL);
>  	GUEST_SYNC(6);
>  
>  	GUEST_DONE();
> 
> base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

