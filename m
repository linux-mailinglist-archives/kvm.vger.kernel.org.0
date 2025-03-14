Return-Path: <kvm+bounces-41058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C226A61200
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:06:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 004B47AC9A0
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 13:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3683A1FF602;
	Fri, 14 Mar 2025 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qt7A+jjd"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B201FECD7
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741957577; cv=none; b=YDuVM8nKo3jY1Ba5rDMXqFKlQu2Yk1nY0LFn0J+W7D3Vts0quA3Ih2sMBXMLM5JnBKRQzqZO3EjN0YgctzHGinZoGekBvV5OIOo/2wElH9fvO4lQ+terQdYOy6irF9W9hJY9RNKY/762rpNlRwKcaRcxll4/mrpN3JplDY3xiyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741957577; c=relaxed/simple;
	bh=jWYC3l/X7RCTru27D9HBK2LHAOLEY0xgwRuVigXMpCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syCNBRNoCjBFtUgxPLuFtQOUlbjFG/91LMxBoZ2DlYLwH0BHSG991OCCsSs0dxf1d1JNubvoEUmwIfnRCHtLGE4f/9O+2A3tQ3B7+XLR9DapZh59/kCLj4F8L0/7bhKKnX3GEGoLQrzgAW3z2y2JgpoB2HGWZ1fNmB7jWVq7TVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qt7A+jjd; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Mar 2025 14:06:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741957572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nXG9bZIXoZ73nsstowcLvW7wv03XBMEdZ2ZnOb4mhno=;
	b=Qt7A+jjdtO8UcCBA+h7G1lyrMXP+pauYHZWiZAIXcGSC8xoyYCpqIMRhocJ4bz9ueZag6q
	KCZ5Y6snH9AmPwzX2gZ5e3+iiuX2cIUwf6z9I3FKvg+7V2dxdV/cymHyrYuq0zy4EXY8Hs
	UP8eV+xsYVnVU9iwUncMWfMsR4xmsOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, atishp@rivosinc.com
Subject: Re: [RFC kvm-unit-tests PATCH v2] riscv: Refactoring sbi fwft tests
Message-ID: <20250314-de170e6be9663465ab8f577e@orel>
References: <20250313075845.411130-1-akshaybehl231@gmail.com>
 <20250313171223.551383-1-akshaybehl231@gmail.com>
 <20250314-e4eb6916a20814ac24aae5e6@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314-e4eb6916a20814ac24aae5e6@orel>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 01:57:45PM +0100, Andrew Jones wrote:
> On Thu, Mar 13, 2025 at 10:42:23PM +0530, Akshay Behl wrote:
> > This patch refactors the current sbi fwft tests
> > (pte_ad_hw_updating, misaligned_exc_deleg)
> > 
> > v2:
> >  - Made env_or_skip and env_enabled methods shared by adding
> >    them to sbi-tests.h
> >  - Used env_enabled check instead of env_or_skip for
> >    platform support
> >  - Added the reset to 0/1 test back for pte_ad_hw_updating
> >  - Made other suggested changes
> 
> The v2 changelog should go under the '---' below to keep it out of the
> file commit message.
> 
> > 
> > Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> > ---
> >  riscv/sbi-tests.h | 22 ++++++++++++++++++++++
> >  riscv/sbi-fwft.c  | 38 +++++++++++++++++++++++++++-----------
> >  riscv/sbi.c       | 17 -----------------
> >  3 files changed, 49 insertions(+), 28 deletions(-)
> > 
> > diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
> > index b081464d..91eba7b7 100644
> > --- a/riscv/sbi-tests.h
> > +++ b/riscv/sbi-tests.h
> > @@ -70,6 +70,28 @@
> >  #define sbiret_check(ret, expected_error, expected_value) \
> >  	sbiret_report(ret, expected_error, expected_value, "check sbi.error and sbi.value")
> >  
> > +/**
> > + * Check if environment variable exists, skip test if missing
> > + *
> > + * @param env The environment variable name to check
> > + * @return true if environment variable exists, false otherwise
> > + */

I also dropped this comment block. The '/**' made check-kerneldoc complain
and the comment didn't tell us anything that the four lines of code that
the function has was already easily telling us.

Thanks,
drew

> > +static inline bool env_or_skip(const char *env)
> > +{
> > +	if (!getenv(env)) {
> > +		report_skip("missing %s environment variable", env);
> > +		return false;
> > +	}
> > +	return true;
> > +}
> > +
> > +static inline bool env_enabled(const char *env)
> > +{
> > +	char *s = getenv(env);
> > +
> > +	return s && (*s == '1' || *s == 'y' || *s == 'Y');
> > +}
> 
> We should include libcflat.h now that we've added these functions. Make
> sure the include is under the '#ifndef __ASSEMBLER__' (and above the
> '#include <asm/sbi.h>')
> 
> > +
> >  void sbi_bad_fid(int ext);
> >  
> >  #endif /* __ASSEMBLER__ */
> > diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> > index ac2e3486..581cbf6b 100644
> > --- a/riscv/sbi-fwft.c
> > +++ b/riscv/sbi-fwft.c
> > @@ -66,6 +66,14 @@ static void fwft_check_reserved(unsigned long id)
> >  	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
> >  }
> >  
> > +/* Must be called before any fwft_set() call is made for @feature */
> > +static void fwft_check_reset(uint32_t feature, unsigned long reset)
> > +{
> > +	struct sbiret ret = fwft_get(feature);
> > +
> > +	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
> > +}
> > +
> >  static void fwft_check_base(void)
> >  {
> >  	report_prefix_push("base");
> > @@ -99,18 +107,28 @@ static struct sbiret fwft_misaligned_exc_get(void)
> >  static void fwft_check_misaligned_exc_deleg(void)
> >  {
> >  	struct sbiret ret;
> > +	unsigned long expected;
> >  
> >  	report_prefix_push("misaligned_exc_deleg");
> >  
> >  	ret = fwft_misaligned_exc_get();
> > -	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> > -		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
> > +	if (ret.error != SBI_SUCCESS) {
> > +		if (env_enabled("SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG")) {
> > +			sbiret_report_error(&ret, SBI_SUCCESS, "supported");
> > +			return;
> > +		}
> > +		report_skip("not supported by platform");
> >  		return;
> >  	}
> >  
> >  	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Get misaligned deleg feature"))
> >  		return;
> >  
> > +	if (env_or_skip("MISALIGNED_EXC_DELEG_RESET")) {
> > +		expected = strtoul(getenv("MISALIGNED_EXC_DELEG_RESET"), NULL, 0);
> > +		fwft_check_reset(SBI_FWFT_MISALIGNED_EXC_DELEG, expected);
> > +	}
> > +
> >  	ret = fwft_misaligned_exc_set(2, 0);
> >  	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> >  			    "Set misaligned deleg feature invalid value 2");
> > @@ -129,16 +147,10 @@ static void fwft_check_misaligned_exc_deleg(void)
> >  #endif
> >  
> >  	/* Set to 0 and check after with get */
> > -	ret = fwft_misaligned_exc_set(0, 0);
> > -	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0");
> > -	ret = fwft_misaligned_exc_get();
> > -	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg feature expected value 0");
> > +	fwft_set_and_check_raw("", SBI_FWFT_MISALIGNED_EXC_DELEG, 0, 0);
> >  
> >  	/* Set to 1 and check after with get */
> > -	ret = fwft_misaligned_exc_set(1, 0);
> > -	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 1");
> > -	ret = fwft_misaligned_exc_get();
> > -	sbiret_report(&ret, SBI_SUCCESS, 1, "Get misaligned deleg feature expected value 1");
> > +	fwft_set_and_check_raw("", SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
> >  
> >  	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
> >  
> > @@ -261,7 +273,11 @@ static void fwft_check_pte_ad_hw_updating(void)
> >  	report_prefix_push("pte_ad_hw_updating");
> >  
> >  	ret = fwft_get(SBI_FWFT_PTE_AD_HW_UPDATING);
> > -	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> > +	if (ret.error != SBI_SUCCESS) {
> > +		if (env_enabled("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING")) {
> > +			sbiret_report_error(&ret, SBI_SUCCESS, "supported");
> > +			return;
> > +		}
> >  		report_skip("not supported by platform");
> >  		return;
> >  	} else if (!sbiret_report_error(&ret, SBI_SUCCESS, "get")) {
> > diff --git a/riscv/sbi.c b/riscv/sbi.c
> > index 0404bb81..219f7187 100644
> > --- a/riscv/sbi.c
> > +++ b/riscv/sbi.c
> > @@ -131,23 +131,6 @@ static phys_addr_t get_highest_addr(void)
> >  	return highest_end - 1;
> >  }
> >  
> > -static bool env_enabled(const char *env)
> > -{
> > -	char *s = getenv(env);
> > -
> > -	return s && (*s == '1' || *s == 'y' || *s == 'Y');
> > -}
> > -
> > -static bool env_or_skip(const char *env)
> > -{
> > -	if (!getenv(env)) {
> > -		report_skip("missing %s environment variable", env);
> > -		return false;
> > -	}
> > -
> > -	return true;
> > -}
> > -
> >  static bool get_invalid_addr(phys_addr_t *paddr, bool allow_default)
> >  {
> >  	if (env_enabled("INVALID_ADDR_AUTO")) {
> > -- 
> > 2.34.1
> >
> 
> Other than the two comments above, it looks good. I've made the changes
> myself while applying to riscv/sbi
> 
> https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
> 
> Thanks,
> drew

