Return-Path: <kvm+bounces-41739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14309A6C81B
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 08:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08BDC3B1883
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 07:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F3D18C006;
	Sat, 22 Mar 2025 07:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VESwZjAt"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E364418B48B
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742629140; cv=none; b=mKKnGi0N65WxIMzQIE7rtN8dKiZ1GxzQPGwF67tm5p8S9pfs94D3WgaS2932NMdqDYgS/Zs0wkLneLj0buFkvCWjR40zaGJpCWCQFiUEKelE1nNrOcwHQzLtLueITIV35ttOMC5axWIglKXoEMOjIoPvCeS8M4jwOL5DHt9etTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742629140; c=relaxed/simple;
	bh=A/vnPmseNm/3JNIiOd7yNgmrdDnweKKP7TNR3Bhkx7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yc+48BjfSGwuijiYjqoL1sjaxuBjB8cDSJwT+3kALsfh6NCYfzQYAV5f3WY31Cm/BL/UejnOx8gnFvCl0RFOyFn5THGBcQ2RA2k0OB8zG1QpVMqDwv6kZ2j9ihy7Nh6sBMqMUARv6y1bHNzZ3EIOY5adRmsZxKBFKSwODUrabhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VESwZjAt; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 08:38:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742629134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LfhLC5sqlQafvn+0xKuGq6lbyGDnAKhNMAnd1fBQhlg=;
	b=VESwZjAtgGFlpg1o5TeXxmhOoUv1TwxNO0ti/JhuAwz1krBJf52IW9zCiXNJDk8mW2p76e
	pcrSavYBy1rGVnZfNOyZdeWUaCMIK09C/X5kheZpCsKbJObdGzxgQWzBCPyd/jWzQlggb4
	W9lRSOzDPnrlAGs+uOdkM2qdVbLgXoc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	atishp@rivosinc.com, akshaybehl231@gmail.com
Subject: Re: [kvm-unit-tests PATCH 3/3] riscv: sbi: Use kfail for known
 opensbi failures
Message-ID: <20250322-3d41f407f8d352d262718c20@orel>
References: <20250321165403.57859-5-andrew.jones@linux.dev>
 <20250321165403.57859-8-andrew.jones@linux.dev>
 <dba5ed81-6557-45aa-8246-0c9e6d6c18a0@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dba5ed81-6557-45aa-8246-0c9e6d6c18a0@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 21, 2025 at 09:22:19PM +0100, Clément Léger wrote:
> 
> 
> On 21/03/2025 17:54, Andrew Jones wrote:
> > Use kfail for the opensbi s/SBI_ERR_DENIED/SBI_ERR_DENIED_LOCKED/
> > change. We expect it to be fixed in 1.7, so only kfail for opensbi
> > which has a version less than that. Also change the other uses of
> > kfail to only kfail for opensbi versions less than 1.7.
> > 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >  riscv/sbi-fwft.c | 20 +++++++++++++-------
> >  riscv/sbi.c      |  6 ++++--
> >  2 files changed, 17 insertions(+), 9 deletions(-)
> > 
> > diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> > index 3d225997c0ec..c52fbd6e77a6 100644
> > --- a/riscv/sbi-fwft.c
> > +++ b/riscv/sbi-fwft.c
> > @@ -83,19 +83,21 @@ static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
> >  
> >  	report_prefix_push("locked");
> >  
> > +	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> > +		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
> > +
> >  	for (int i = 0; i < nr_values; ++i) {
> >  		ret = fwft_set(feature, test_values[i], 0);
> > -		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> > -			"Set to %lu without lock flag", test_values[i]);
> > +		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
> > +				   "Set to %lu without lock flag", test_values[i]);
> >  
> >  		ret = fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
> > -		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> > -			"Set to %lu with lock flag", test_values[i]);
> > +		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
> > +				   "Set to %lu with lock flag", test_values[i]);
> >  	}
> >  
> >  	ret = fwft_get(feature);
> > -	sbiret_report(&ret, SBI_SUCCESS, locked_value,
> > -		"Get value %lu", locked_value);
> > +	sbiret_report(&ret, SBI_SUCCESS, locked_value, "Get value %lu", locked_value);
> 
> Reformatting ?

Yup, and the "Set..." strings above. I missed that the format was wrong
when I applied the fwft_feature_lock_test_values patch and just lazily
fixed it up with this patch. I still haven't merged to the master
branch yet, so I can still squash a formatting fix into the
fwft_feature_lock_test_values patch in order to make this patch cleaner.

> 
> >  
> >  	report_prefix_pop();
> >  }
> > @@ -103,6 +105,7 @@ static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
> >  static void fwft_feature_lock_test(uint32_t feature, unsigned long locked_value)
> >  {
> >  	unsigned long values[] = {0, 1};
> > +
> 
> That's some spurious newline here.

It's also reformatting.

> 
> 
> >  	fwft_feature_lock_test_values(feature, 2, values, locked_value);
> >  }
> >  
> > @@ -317,7 +320,10 @@ static void fwft_check_pte_ad_hw_updating(void)
> >  	report(ret.value == 0 || ret.value == 1, "first get value is 0/1");
> >  
> >  	enabled = ret.value;
> > -	report_kfail(true, !enabled, "resets to 0");
> > +
> > +	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> > +		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
> > +	report_kfail(kfail, !enabled, "resets to 0");
> >  
> >  	install_exception_handler(EXC_LOAD_PAGE_FAULT, adue_read_handler);
> >  	install_exception_handler(EXC_STORE_PAGE_FAULT, adue_write_handler);
> > diff --git a/riscv/sbi.c b/riscv/sbi.c
> > index 83bc55125d46..edb1a6bef1ac 100644
> > --- a/riscv/sbi.c
> > +++ b/riscv/sbi.c
> > @@ -515,10 +515,12 @@ end_two:
> >  	sbiret_report_error(&ret, SBI_SUCCESS, "no targets, hart_mask_base is 1");
> >  
> >  	/* Try the next higher hartid than the max */
> > +	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> > +		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
> >  	ret = sbi_send_ipi(2, max_hartid);> -	report_kfail(true, ret.error
> == SBI_ERR_INVALID_PARAM, "hart_mask got expected error (%ld)", ret.error);
> > +	sbiret_kfail_error(kfail, &ret, SBI_ERR_INVALID_PARAM, "hart_mask");
> >  	ret = sbi_send_ipi(1, max_hartid + 1);
> > -	report_kfail(true, ret.error == SBI_ERR_INVALID_PARAM, "hart_mask_base got expected error (%ld)", ret.error);
> > +	sbiret_kfail_error(kfail, &ret, SBI_ERR_INVALID_PARAM, "hart_mask_base");
> >  
> >  	report_prefix_pop();
> >  
> 
> Hi Andrew,
> 
> I tried thinking of some way to factorize the version check but can't
> really find something elegant. Without the spurious newline:

I'll move the reformatting to the fwft_feature_lock_test_values patch,
but I'm generally not overly opposed to sneaking a couple reformatting
fixes into patches when the reformatting is obvious enough.

> 
> Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,
drew

> 
> Thanks,
> 
> Clément
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

