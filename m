Return-Path: <kvm+bounces-40909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7628EA5EF0A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D935C3BD4A5
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 09:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3911126463D;
	Thu, 13 Mar 2025 09:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="seGUfAlm"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D5B263C8E
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741856849; cv=none; b=KRvvkms/ALLuf5d3knOYHa+7zZlmLiAtqVYKpQpLjiop82RVjAT6QLQMIg9fDlHZ81UWhbFzxoiOJhF4Pew36O8GBIahqWIy/tK/XUMEUw/C13n/f3hcjPOYycr7nJ7kOmnws19s/tYrMCvqzqU930HLCNXEOvRPI87uArJqVWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741856849; c=relaxed/simple;
	bh=3nWp5wg5Iobt2Yj51i/DlF2yVROASZ6SnIccJXDt994=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eW7kyxDvlZzH1G/dMCF5X+bHKsc0iGhGwRoRHC94H/z3ujy6uB9U6rUuILslvHed9CIUNF1YRK22aAGbr82+Q6M6TCIELvzg8o98Nu1AiEhaBV2StduOVRvriuspZ9vSPSKBKTO0Mr0sQq3gnlyojnG0GvKwfyKZGT0C5ViRrSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=seGUfAlm; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 13 Mar 2025 10:07:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741856843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iSYv1zTkOQiTsKwI2qlv4T0N3bOUEXnlvmIGfNWvntQ=;
	b=seGUfAlmHu46LoSOP+IcE6V1jY/Iy0Uo3vdOCWYwwxg4SSry20WB6eurnt30WynRy5a3BY
	hfg7cbZZcDJoDRhiMR4kfdc6rOpC2vhbFbowuA02zd+kDdrGJzx/dqVSq6z7ILBWJiEGAL
	8BZmbaUmNWw75T0z0I7KnVDh2g+D1ko=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, atishp@rivosinc.com
Subject: Re: [RFC kvm-unit-tests PATCH] riscv: Refactoring sbi fwft tests
Message-ID: <20250313-3f419c2cd96b0fef3c206b85@orel>
References: <20250313075845.411130-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313075845.411130-1-akshaybehl231@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 13, 2025 at 01:28:45PM +0530, Akshay Behl wrote:
> This patch refactors the current sbi fwft tests
> (pte_ad_hw_updating, misaligned_exc_deleg)
> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> ---
>  riscv/sbi-fwft.c | 58 +++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 45 insertions(+), 13 deletions(-)
> 
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index ac2e3486..bf735f62 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -19,6 +19,15 @@
>  
>  void check_fwft(void);
>  
> +static bool env_or_skip(const char *env)
> +{
> +	if (!getenv(env)) {
> +		report_skip("missing %s environment variable", env);
> +		return false;
> +	}
> +
> +	return true;
> +}

We already have this in riscv/sbi.c so we should share it. We can just
make it a static inline in sbi-tests.h

>  
>  static struct sbiret fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags)
>  {
> @@ -66,6 +75,13 @@ static void fwft_check_reserved(unsigned long id)
>  	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
>  }
>  
> +static void fwft_check_reset(uint32_t feature, unsigned long reset)
> +{
> +	struct sbiret ret = fwft_get(feature);
> +
> +	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
> +}

Yes, this is the function I suggested we add, but you neglected to add the
comment above it that I also suggested.

 /* Must be called before any fwft_set() call is made for @feature */

> +
>  static void fwft_check_base(void)
>  {
>  	report_prefix_push("base");
> @@ -99,18 +115,32 @@ static struct sbiret fwft_misaligned_exc_get(void)
>  static void fwft_check_misaligned_exc_deleg(void)
>  {
>  	struct sbiret ret;
> +	unsigned long expected;
>  
>  	report_prefix_push("misaligned_exc_deleg");
>  
>  	ret = fwft_misaligned_exc_get();
> -	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> -		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
> +	if (ret.error != SBI_SUCCESS) {
> +		if (env_or_skip("SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG")) {

We don't want env_or_skip() here since we don't want to output SKIP
logs for _HAVE_ environment variables. env_or_skip() is for getting
expected values for tests. In those cases, without the env, there's
no expected value to compare with, so we must skip the test.

> +			expected = (unsigned long)strtoul(getenv("SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG"), NULL, 0);
> +			if (expected == 1)

We have env_enabled() in riscv/sbi.c which we can move to sbi-tests.h as a
static inline. That's what we should use here. (It doesn't use strtoul,
since there's no need to in order to compare with the string "1".)

> +			{

This { should be on the same line as the if.

> +				report_fail("not supported by platform");

This should be sbiret_report_error(&ret, SBI_SUCCESS, "supported") since
SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG says it's supported and we want to see
what error code we get when it's not success.

> +				return;
> +			}
> +		}
> +		report_skip("not supported by platform");
>  		return;
>  	}
>  
>  	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Get misaligned deleg feature"))
>  		return;
>  
> +	if (env_or_skip("MISALIGNED_EXC_DELEG_RESET")) {
> +		expected = (unsigned long)strtoul(getenv("MISALIGNED_EXC_DELEG_RESET"), NULL, 0);

No need for the (unsigned long) cast. strtoul() returns an unsigned long
(it even says it will in its name).

> +		fwft_check_reset(SBI_FWFT_MISALIGNED_EXC_DELEG, expected);
> +	}
> +
>  	ret = fwft_misaligned_exc_set(2, 0);
>  	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>  			    "Set misaligned deleg feature invalid value 2");
> @@ -129,16 +159,10 @@ static void fwft_check_misaligned_exc_deleg(void)
>  #endif
>  
>  	/* Set to 0 and check after with get */
> -	ret = fwft_misaligned_exc_set(0, 0);
> -	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0");
> -	ret = fwft_misaligned_exc_get();
> -	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg feature expected value 0");
> +	fwft_set_and_check_raw("", SBI_FWFT_MISALIGNED_EXC_DELEG, 0, 0);
>  
>  	/* Set to 1 and check after with get */
> -	ret = fwft_misaligned_exc_set(1, 0);
> -	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 1");
> -	ret = fwft_misaligned_exc_get();
> -	sbiret_report(&ret, SBI_SUCCESS, 1, "Get misaligned deleg feature expected value 1");
> +	fwft_set_and_check_raw("", SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
>  
>  	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
>  
> @@ -257,11 +281,20 @@ static void fwft_check_pte_ad_hw_updating(void)
>  {
>  	struct sbiret ret;
>  	bool enabled;
> +	unsigned long expected;
>  
>  	report_prefix_push("pte_ad_hw_updating");
>  
>  	ret = fwft_get(SBI_FWFT_PTE_AD_HW_UPDATING);
> -	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> +	if (ret.error != SBI_SUCCESS) {
> +		if (env_or_skip("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING")) {
> +			expected = (unsigned long)strtoul(getenv("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING"), NULL, 0);
> +			if (expected == 1)
> +			{
> +				report_fail("not supported by platform");
> +				return;
> +			}
> +		}

same comments as above

>  		report_skip("not supported by platform");
>  		return;
>  	} else if (!sbiret_report_error(&ret, SBI_SUCCESS, "get")) {
> @@ -269,10 +302,9 @@ static void fwft_check_pte_ad_hw_updating(void)
>  		return;
>  	}
>  
> -	report(ret.value == 0 || ret.value == 1, "first get value is 0/1");
> +	fwft_check_reset(SBI_FWFT_PTE_AD_HW_UPDATING, 1);

The reset value of PTE_AD_HW_UPDATING isn't 1. It's 0. See the spec.

>  
>  	enabled = ret.value;
> -	report_kfail(true, !enabled, "resets to 0");

This removes a test case that proved opensbi is broken. Always refer
to the spec when writing tests. We don't want to write tests (and
especially not change tests) just to output PASS.

Until we've fixed opensbi this test needs to stay as it is, i.e. with
the check for 0 or 1 for the get and then the kfail report for when
it's 1.

>  
>  	install_exception_handler(EXC_LOAD_PAGE_FAULT, adue_read_handler);
>  	install_exception_handler(EXC_STORE_PAGE_FAULT, adue_write_handler);
> -- 
> 2.34.1
> 

Thanks,
drew

