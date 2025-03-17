Return-Path: <kvm+bounces-41232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE244A6524C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E215D3ADB6C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 14:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5545623E35D;
	Mon, 17 Mar 2025 14:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C2cVaibU"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DAF22759C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742220418; cv=none; b=CU6Jr8HeJjtFO+N9GpSp5HBKccPv8EZhmyNjppQ7r++jnj0kDIwtOcCdVRwswWOUln1xDIikkgKUkEDoKe51pU/O6KB6Ytv76DHR5VrpaMwMxSGS9F+51qSeE2bVn8uyrJHJMjH9TPswcI3e8X3xwNYmgGEP5bJC5kydR0c9sac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742220418; c=relaxed/simple;
	bh=UoGa+vKR2t6VuobmP944gXr+lihV+L+v/NWUH9e74CA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2zxeQ9log96qw3X4NwALLMOD+vWnjthKzI3YCkzA8l7F1pwgEuqY8gN5Xntt4UMiTY5WyUWP8W1HYK80mhLQUxvugXOWyU+/xWpNQ3pVALjQAZ8l+CCxpeaTQYYKbmyspU9SDw6uWtgu1jmGvYyJd/UmSjk0ysFV5hS6eK0Dgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C2cVaibU; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 17 Mar 2025 15:06:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742220412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wss88VUd3dbCFczW0s5ffm7y3Bwzv0TgpH/oNvGdxCM=;
	b=C2cVaibUbS/gIzC1dvWWnMy4ER/tBzWgs4ToaCS5SBVmpc2Tf+/1B3BH0SewohelABt13i
	LHfYBJzDBbEVlvdLveAl9S2uffe1cuDFUAC9zVErZWKo8RYph8VleaFPKKnChvUWHGMF1D
	3Qjd2ln0+zUOEj1DFGZvSs09A3oT/nY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Akshay Behl <akshaybehl231@gmail.com>, kvm@vger.kernel.org, 
	atishp@rivosinc.com
Subject: Re: [kvm-unit-tests PATCH] riscv: Refactor SBI FWFT lock tests
Message-ID: <20250317-99cb18316f78fe06236b5695@orel>
References: <20250316123209.100561-1-akshaybehl231@gmail.com>
 <0432fb3a-98db-45c5-8630-43ad52f27769@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0432fb3a-98db-45c5-8630-43ad52f27769@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 09:20:27AM +0100, Clément Léger wrote:
> 
> 
> On 16/03/2025 13:32, Akshay Behl wrote:
> > This patch adds a generic function for lock tests for all
> > the sbi fwft features. It expects the feature is already
> > locked before being called and tests the locked feature.
> > 
> > Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> > ---
> >  riscv/sbi-fwft.c | 48 ++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 32 insertions(+), 16 deletions(-)
> > 
> > diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> > index 581cbf6b..5c0a7f6f 100644
> > --- a/riscv/sbi-fwft.c
> > +++ b/riscv/sbi-fwft.c
> > @@ -74,6 +74,33 @@ static void fwft_check_reset(uint32_t feature, unsigned long reset)
> >  	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
> >  }
> >  
> > +/* Must be called after locking the feature using SBI_FWFT_SET_FLAG_LOCK */
> > +static void fwft_feature_lock_test(int32_t feature, unsigned long locked_value)
                                        ^
                                        ^ uint32_t

> > +{
> > +    struct sbiret ret;
> > +    unsigned long alt_value = locked_value ? 0 : 1;
> 
> Hi Akshay,
> 
> This will work for boolean FWFT features but might not work for PMLEN
> for instance. It could be good to pass the alt value (or values for
> PMLEN) as an argument to this function.

Yup,

 static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
                                           unsigned long test_values[])
 {
	for (i = 0; i < nr_values; ++i) {
	    ... test without lock flag ...
	    ... test with lock flag ...
	}

	... test get ...
 }
 
 static void fwft_feature_lock_test(uint32_t feature)
 {
    unsigned long values[] = { 0, 1 };

    fwft_feature_lock_test_values(feature, 2, values);
 }

So we have fwft_feature_lock_test() for boolean features (likely most of
them) and also fwft_feature_lock_test_values() for everything else.

Thanks,
drew

> 
> Thanks,
> 
> Clément
> 
> > +
> > +    ret = fwft_set(feature, locked_value, 0);
> > +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> > +        "Set locked feature to %lu without lock", locked_value);
> > +
> > +    ret = fwft_set(feature, locked_value, SBI_FWFT_SET_FLAG_LOCK);
> > +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> > +        "Set locked feature to %lu with lock", locked_value);
> > +
> > +    ret = fwft_set(feature, alt_value, 0);
> > +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> > +        "Set locked feature to %lu without lock", alt_value);
> > +
> > +    ret = fwft_set(feature, alt_value, SBI_FWFT_SET_FLAG_LOCK);
> > +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> > +        "Set locked feature to %lu with lock", alt_value);
> > +
> > +    ret = fwft_get(feature);
> > +    sbiret_report(&ret, SBI_SUCCESS, locked_value,
> > +        "Get locked feature value %lu", locked_value);
> > +}
> > +
> >  static void fwft_check_base(void)
> >  {
> >  	report_prefix_push("base");
> > @@ -181,11 +208,9 @@ static void fwft_check_misaligned_exc_deleg(void)
> >  	/* Lock the feature */
> >  	ret = fwft_misaligned_exc_set(0, SBI_FWFT_SET_FLAG_LOCK);
> >  	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0 and lock");
> > -	ret = fwft_misaligned_exc_set(1, 0);
> > -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> > -			    "Set locked misaligned deleg feature to new value");
> > -	ret = fwft_misaligned_exc_get();
> > -	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg locked value 0");
> > +
> > +	/* Test feature lock */
> > +	fwft_feature_lock_test(SBI_FWFT_MISALIGNED_EXC_DELEG, 0);
> >  
> >  	report_prefix_pop();
> >  }
> > @@ -326,17 +351,8 @@ adue_inval_tests:
> >  	else
> >  		enabled = !enabled;
> >  
> > -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 0);
> > -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", !enabled);
> > -
> > -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 1);
> > -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", !enabled);
> > -
> > -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 0);
> > -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", enabled);
> > -
> > -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 1);
> > -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", enabled);
> > +	/* Test the feature lock */
> > +	fwft_feature_lock_test(SBI_FWFT_PTE_AD_HW_UPDATING, enabled);
> >  
> >  adue_done:
> >  	install_exception_handler(EXC_LOAD_PAGE_FAULT, NULL);
> 

