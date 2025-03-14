Return-Path: <kvm+bounces-41057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C451AA611D8
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 13:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFD6F3BDCB2
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1201FF1CA;
	Fri, 14 Mar 2025 12:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wlKORWwC"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C45A1FF1AC
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 12:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741957070; cv=none; b=htI2sgUbkJaemG6Fz/7u7rcyZb9TasW0H0FCK2zrkrcu37WPPo0v4laq5RFu+D0zVUNNwdA2Xcf5grDNFPj10K+X3AHZMX/7NIv7dY7MEbxhHg29RgQXTU7qLvYGYmVSiffHiiowEiy90rRYknoOK2lkUGt3h6ys7M4vKvvE9k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741957070; c=relaxed/simple;
	bh=4ZEh+voBEdpoEpfWMXheTg6VYdym2NBkqpInYKOYY4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AN1zTJqFqr48tYQSUy/TX4w7M1NIxsYBPcvwTWcd9Dtwx0dfW6r7tva5OutMj7qWyS8bCbFUEqIV7yRoEkFuFlvKiLoWVfOtRqydw0VL4UD/e6ScYZS1b65HCWrwwMSdzN2jFIvsHiZQWwkUIBDF1YsZIg3b4C9ViocT3c11gEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wlKORWwC; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Mar 2025 13:57:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741957065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6q0v8NrCFM7wbtKTHgHhsYrIfle/TRqZbS8RO+9mFZo=;
	b=wlKORWwCH17oIBHTrJ9AYlr4pwr63pf81dA9ZXdgl56siFutrnSevz6eWYwshCbo8jhuAO
	xNuBhA6ebEQfnhkEKBY47xMxf0J9/uE4LvirO9JG/hk9O87BYfsG37y89YuG0uqbVXImAJ
	pAH1xVzm+gF7LxYe0JaZ4I9o0KcGky8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, atishp@rivosinc.com
Subject: Re: [RFC kvm-unit-tests PATCH v2] riscv: Refactoring sbi fwft tests
Message-ID: <20250314-e4eb6916a20814ac24aae5e6@orel>
References: <20250313075845.411130-1-akshaybehl231@gmail.com>
 <20250313171223.551383-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313171223.551383-1-akshaybehl231@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 13, 2025 at 10:42:23PM +0530, Akshay Behl wrote:
> This patch refactors the current sbi fwft tests
> (pte_ad_hw_updating, misaligned_exc_deleg)
> 
> v2:
>  - Made env_or_skip and env_enabled methods shared by adding
>    them to sbi-tests.h
>  - Used env_enabled check instead of env_or_skip for
>    platform support
>  - Added the reset to 0/1 test back for pte_ad_hw_updating
>  - Made other suggested changes

The v2 changelog should go under the '---' below to keep it out of the
file commit message.

> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> ---
>  riscv/sbi-tests.h | 22 ++++++++++++++++++++++
>  riscv/sbi-fwft.c  | 38 +++++++++++++++++++++++++++-----------
>  riscv/sbi.c       | 17 -----------------
>  3 files changed, 49 insertions(+), 28 deletions(-)
> 
> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
> index b081464d..91eba7b7 100644
> --- a/riscv/sbi-tests.h
> +++ b/riscv/sbi-tests.h
> @@ -70,6 +70,28 @@
>  #define sbiret_check(ret, expected_error, expected_value) \
>  	sbiret_report(ret, expected_error, expected_value, "check sbi.error and sbi.value")
>  
> +/**
> + * Check if environment variable exists, skip test if missing
> + *
> + * @param env The environment variable name to check
> + * @return true if environment variable exists, false otherwise
> + */
> +static inline bool env_or_skip(const char *env)
> +{
> +	if (!getenv(env)) {
> +		report_skip("missing %s environment variable", env);
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static inline bool env_enabled(const char *env)
> +{
> +	char *s = getenv(env);
> +
> +	return s && (*s == '1' || *s == 'y' || *s == 'Y');
> +}

We should include libcflat.h now that we've added these functions. Make
sure the include is under the '#ifndef __ASSEMBLER__' (and above the
'#include <asm/sbi.h>')

> +
>  void sbi_bad_fid(int ext);
>  
>  #endif /* __ASSEMBLER__ */
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index ac2e3486..581cbf6b 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -66,6 +66,14 @@ static void fwft_check_reserved(unsigned long id)
>  	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
>  }
>  
> +/* Must be called before any fwft_set() call is made for @feature */
> +static void fwft_check_reset(uint32_t feature, unsigned long reset)
> +{
> +	struct sbiret ret = fwft_get(feature);
> +
> +	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
> +}
> +
>  static void fwft_check_base(void)
>  {
>  	report_prefix_push("base");
> @@ -99,18 +107,28 @@ static struct sbiret fwft_misaligned_exc_get(void)
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
> +		if (env_enabled("SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG")) {
> +			sbiret_report_error(&ret, SBI_SUCCESS, "supported");
> +			return;
> +		}
> +		report_skip("not supported by platform");
>  		return;
>  	}
>  
>  	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Get misaligned deleg feature"))
>  		return;
>  
> +	if (env_or_skip("MISALIGNED_EXC_DELEG_RESET")) {
> +		expected = strtoul(getenv("MISALIGNED_EXC_DELEG_RESET"), NULL, 0);
> +		fwft_check_reset(SBI_FWFT_MISALIGNED_EXC_DELEG, expected);
> +	}
> +
>  	ret = fwft_misaligned_exc_set(2, 0);
>  	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>  			    "Set misaligned deleg feature invalid value 2");
> @@ -129,16 +147,10 @@ static void fwft_check_misaligned_exc_deleg(void)
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
> @@ -261,7 +273,11 @@ static void fwft_check_pte_ad_hw_updating(void)
>  	report_prefix_push("pte_ad_hw_updating");
>  
>  	ret = fwft_get(SBI_FWFT_PTE_AD_HW_UPDATING);
> -	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> +	if (ret.error != SBI_SUCCESS) {
> +		if (env_enabled("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING")) {
> +			sbiret_report_error(&ret, SBI_SUCCESS, "supported");
> +			return;
> +		}
>  		report_skip("not supported by platform");
>  		return;
>  	} else if (!sbiret_report_error(&ret, SBI_SUCCESS, "get")) {
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 0404bb81..219f7187 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -131,23 +131,6 @@ static phys_addr_t get_highest_addr(void)
>  	return highest_end - 1;
>  }
>  
> -static bool env_enabled(const char *env)
> -{
> -	char *s = getenv(env);
> -
> -	return s && (*s == '1' || *s == 'y' || *s == 'Y');
> -}
> -
> -static bool env_or_skip(const char *env)
> -{
> -	if (!getenv(env)) {
> -		report_skip("missing %s environment variable", env);
> -		return false;
> -	}
> -
> -	return true;
> -}
> -
>  static bool get_invalid_addr(phys_addr_t *paddr, bool allow_default)
>  {
>  	if (env_enabled("INVALID_ADDR_AUTO")) {
> -- 
> 2.34.1
>

Other than the two comments above, it looks good. I've made the changes
myself while applying to riscv/sbi

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

