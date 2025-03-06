Return-Path: <kvm+bounces-40245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE16A54E75
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:01:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F6D916CE45
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 15:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B44188713;
	Thu,  6 Mar 2025 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JFO5gqFH"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24B146A63
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741273263; cv=none; b=fbhhBzg5KnF0RztdUdjH0zs67KQDbkqRmJCayB+eTf/MhTSJlcMTTbL/fdom6Yg2/yfHHpJM8WzhxMzrGh9KJrTZ7p6Krtu2J8qOO9GzoDmZXKkqlk11Ydlfuyk58pRcbCztG4ltW1oLd6EZZ4NeXFpYQiWJhVRM5PG2F5ytCXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741273263; c=relaxed/simple;
	bh=oZADMNrFoa4M4+Mlpki/zDF0vLGa5k7RADpclaPMpZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R77CI4FEPynIURVmbDFCBsixvgoatIdtUkwU0PYNDCPfMu29j4J00PjLD1Vu9e5Rc+HGttUZKyPEZjEBnPS/ht6sTemrMbbHmMXpjnMs9il8SVsb4vjWRPiQo3sWdHiPlayWbd8Y8u9zszNJhhXtMIVYNCLrxEAmkYhbleuuWN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JFO5gqFH; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 6 Mar 2025 16:00:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741273257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hn7c/6RNePAc/TyMQA2ogLwul4UMrfndhIbIlRb9pCg=;
	b=JFO5gqFHGTXBa01sVBxBNEFv+1jFfKJddl7i/zpAQqO9KhGyJrpzrkD1vQx9A/PfsOU9Lh
	jlHxreja1PsXMI+35oMFvw1D6lVi9PYPA4xgGomTLRWkeERRWvphkoaY2tF6/POs82grns
	zxLRpAEJDpxeTsbrBhMQycPQe1/MDoE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH] riscv: Add fwft landing_pad tests
Message-ID: <20250306-f537bf6f4eb921242929127e@orel>
References: <20250306113942.10880-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250306113942.10880-1-akshaybehl231@gmail.com>
X-Migadu-Flow: FLOW_OUT


Hi Akshay,

You may want to CC potential reviewers like myself and Clément to ensure
your patches don't get overlooked.

On Thu, Mar 06, 2025 at 05:09:42PM +0530, Akshay Behl wrote:
> Added invalid value, invalid flags, locking and other checks for fwft landing_pad feature.

Please keep commit message lines around 70 chars long.

While the patch is true to the commit message, I think we should add
the full landing pad test at the same time, i.e. after successfully
enabling the feature we should check that it works, and without the
feature enabled we should check that it doesn't work, like
fwft_check_pte_ad_hw_updating() does for ADUE. I think the kvm-unit-tests
framework should have everything needed for that already, but, if not,
we can add what's necessary.

> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> ---
>  riscv/sbi-fwft.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
> 
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index ac2e3486..5d88d683 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -329,6 +329,87 @@ adue_done:
>  	report_prefix_pop();
>  }
>  
> +static struct sbiret fwft_landing_pad_set(unsigned long value, unsigned long flags)
> +{
> +	return fwft_set(SBI_FWFT_LANDING_PAD, value, flags);
> +}
> +
> +static struct sbiret fwft_landing_pad_get(void)
> +{
> +	return fwft_get(SBI_FWFT_LANDING_PAD);
> +}

After making the changes pointed out below there will only be a couple
places where we can use these wrappers, so we could probably drop them.

> +
> +static void fwft_check_landing_pad(void)
> +{
> +	struct sbiret ret;

Add a blank line here.

> +	report_prefix_push("landing_pad");
> +
> +	ret = fwft_landing_pad_get();
> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> +		report_skip("SBI_FWFT_LANDING_PAD is not supported");

You can drop the "SBI_FWFT_LANDING_PAD is " since the "landing_pad" prefix
will be included in the skip message already.

> +		return;
> +	} else if (!sbiret_report_error(&ret, SBI_SUCCESS, "get landing pad feature"))
> +		return;

The above if-else is the same as fwft_check_pte_ad_hw_updating() so we
could factor it out.

> +
> +	report(ret.value == 0, "initial landing pad feature value is 0");
> +

Let's write "resets to 0" for the above report instead of "initial..."

If value isn't zero then it'd be useful to output what it is.
sbiret_report() will do that. Since we'll want to check the reset value of
all FWFT features then we could write a function like

 /* Must be called before any fwft_set() call is made for @feature */
 static void fwft_check_reset(uint32_t feature, unsigned long reset)
 {
	struct sbiret ret = fwft_get(feature);

	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
 }

to be used by all features.

> +	/* Invalid value test */
> +	ret = fwft_landing_pad_set(2, 0);
> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +			    "set landing pad feature invalid value 2");

Drop "landing pad feature" from the report line, we have that info in the
prefix already. Same comment for all report lines below.

> +	ret = fwft_landing_pad_set(0xFFFFFFFF, 0);
> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +				"set landing pad feature invalid value 0xFFFFFFFF");
> +
> +	/* Set to 1 and check with get */
> +	ret = fwft_landing_pad_set(1, 0);
> +	sbiret_report_error(&ret, SBI_SUCCESS,
> +			    "set landing pad feature to 1");
> +	ret = fwft_landing_pad_get();
> +	sbiret_report(&ret, SBI_SUCCESS, 1,
> +		      "get landing pad feature expected value 1");

On harts which don't support Zicfilp this won't succeed. We could get
SBI_ERR_NOT_SUPPORTED or SBI_ERR_DENIED and then we'll want to bail
out early. Whether or not we report SKIP or FAIL depends on what
we expect, though. I'd say we should report SKIP by default and
allow the user to state when they do expect success. We give the
user control over tests with environment variables. So we can
create "SBI_HAVE_FWFT_LANDING_PAD", which, when enabled, means anything
other than SBI_SUCCESS when attempting to set landing pad to 1 is
an error. We should do the same for the other features like
PTE_AD_HW_UPDATING, so that's another opportunity for some code
factoring.

> +
> +	/* Set to 0 and check with get */
> +	ret = fwft_landing_pad_set(0, 0);
> +	sbiret_report_error(&ret, SBI_SUCCESS,
> +			    "set landing pad feature to 0");
> +	ret = fwft_landing_pad_get();
> +	sbiret_report(&ret, SBI_SUCCESS, 0,
> +		      "get landing pad feature expected value 0");

We have fwft_set_and_check_raw() which could be used for the above tests.

> +
> +#if __riscv_xlen > 32
> +	/* Test using invalid flag bits */

The comment is wrong since the next test tests an invalid 'value'.

Also, BIT(32) isn't invalid because it sets a bit above 31, but simply
because the spec doesn't define that value. I think it's a good idea to
test, though, in case an SBI implementation isn't paying attention to
high bits.

> +	ret = fwft_landing_pad_set(BIT(32), 0);
> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +			    "Set misaligned deleg with invalid value > 32bits");

Copy+paste error "misaligned deleg", but again we have a prefix so we
shouldn't be repeating the feature in each report.

> +	ret = fwft_landing_pad_set(1, BIT(32));
> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +			    "set landing pad feature with invalid flag > 32 bits");
> +#endif

We can do yet more refactoring by creating an fwft_inval_input() test
since all features will test flags the same way and likely even value
(0/1 only). Since value might not be 0/1, then we could factor the
flags checking out to allow it to be called separately. So,

 static void fwft_inval_flags(uint32_t feature, unsigned long value)
 {
   /* invalid flags tests */
 }
 static void fwft_inval_input(uint32_t feature)
 {
    /* invalid value tests where 0/1 are valid */
    fwft_inval_flags(feature, 0);
 }

> +
> +	/* Locking test */
> +	ret = fwft_landing_pad_set(1, SBI_FWFT_SET_FLAG_LOCK);
> +	sbiret_report_error(&ret, SBI_SUCCESS,
> +			    "set landing pad feature to 1 and lock");
> +
> +	/* Attempt without the lock flag */
> +	ret = fwft_landing_pad_set(0, 0);
> +	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +			    "attempt to set locked landing pad feature to 0 without lock flag");
> +
> +	/* Attempt with the lock flag still should fail */
> +	ret = fwft_landing_pad_set(0, SBI_FWFT_SET_FLAG_LOCK);
> +	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +			    "attempt to set locked landing pad feature to 0 with lock flag");

We should also test attempting to set the locked feature with the same
value. It should still return SBI_ERR_DENIED_LOCKED, i.e. the SBI
implementation shouldn't check that the value is the same and return
SBI_SUCCESS since nothing would change. It should be checked with and
without the lock flag set.

As Clement pointed out while reviewing fwft_check_pte_ad_hw_updating(),
we could probably factor out the lock tests into a generic function
that all features can use. Let's do that.

> +
> +	/* Verify that the value remains locked at 1 */
> +	ret = fwft_landing_pad_get();
> +	sbiret_report(&ret, SBI_SUCCESS, 1,
> +		      "get locked landing pad feature expected value 1");
> +
> +	report_prefix_pop();
> +}
> +
>  void check_fwft(void)
>  {
>  	report_prefix_push("fwft");
> @@ -344,6 +425,7 @@ void check_fwft(void)
>  	fwft_check_base();
>  	fwft_check_misaligned_exc_deleg();
>  	fwft_check_pte_ad_hw_updating();
> +	fwft_check_landing_pad();
>  
>  	report_prefix_pop();
>  }
> -- 
> 2.34.1
>

So, I think we need some refactoring of the current tests which should
come in separate patches at the start of a series and then we need 
separate patches adding support to the framework to test landing pads
work if we don't have all the support we need already, and then we
need a complete FWFT landing pad test which not only checks the SBI
interface works, but that the feature is actually getting enabled
and disabled.

Thanks,
drew

