Return-Path: <kvm+bounces-25184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 074A5961495
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 18:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39BFB1C23E34
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 16:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7D71C9EC8;
	Tue, 27 Aug 2024 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n42T1QgV"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21EE3E49E
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724777409; cv=none; b=RxyJGpRvkCrscsiFmxneyNCKWhuk8V/qZGqCfDt9W1rxvytx3exJfsdNhphTaFbpCRF0cFb/v7XWZhZcpKpPFjZpLLVRcSNWA+ye91FDUx3l6SF059opkMBlC1f1E9Vcnz73w48UQjZvf6G1ptGJ1qw+4TUqzPfBo0qvV7KE6hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724777409; c=relaxed/simple;
	bh=nRntgrt2V0NDgzhPQbaZzoEYdtOm7FE1ctWZTSMKXHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpS8t/6GsczBoFkiZ5nToN924zZmKXdEEhzYakdHYbwlNpHwHYPiF8NpzwZiTLzYYiMKA+n53vFey4yS8SlrDCQtAKNuz3psL70/8aweYqBpX3ZEpZEg4/ci5jLwB7HrDMHVgl6fUEyoIrD5YsTHka06OkVnXBcQ0XZRQ3GJ+Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n42T1QgV; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 27 Aug 2024 18:49:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724777402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YCAqNTAer09qKoYyT88cB9V7MLXjvzrELiA35wqkLb0=;
	b=n42T1QgVS/dLzhrpF+jsh8AnWCcmGNWLyAS0GsEaXR1tDslO6laGObf7n0Le2YhmIgn45k
	9r1iwvPqU08MvMsrm8s8uE+JACc3Hfa4vItFEXVSFus0buuRJloOYQPR8Dv0GPbEB9ql9r
	r0ridoG+eLMApAJHdRFTyQDAY9E+ngM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/report: Add helper methods to
 clear multiple prefixes
Message-ID: <20240827-bd7768e88d0b307a8923cfb6@orel>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
 <20240825170824.107467-2-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240825170824.107467-2-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 26, 2024 at 01:08:21AM GMT, James Raphael Tiovalen wrote:
> Add a method to pop a specified number of prefixes and another method to
> clear all prefixes.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/libcflat.h |  2 ++
>  lib/report.c   | 13 +++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 16a83880..0286ddec 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -96,6 +96,8 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>  					__attribute__((format(printf, 1, 2)));
>  extern void report_prefix_push(const char *prefix);
>  extern void report_prefix_pop(void);
> +extern void report_prefix_popn(int n);
> +extern void report_prefix_clear(void);
>  extern void report(bool pass, const char *msg_fmt, ...)
>  		__attribute__((format(printf, 2, 3), nonnull(2)));
>  extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> diff --git a/lib/report.c b/lib/report.c
> index 7f3c4f05..d45afedc 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -80,6 +80,19 @@ void report_prefix_pop(void)
>  	spin_unlock(&lock);
>  }
>  
> +void report_prefix_popn(int n)
> +{
> +	while (n--)
> +		report_prefix_pop();

I think I suggested this implementation, but thinking about it some more
this won't work well with other cpus pushing/popping simultaneously. We
need something like

 static void __report_prefix_pop(void)
 {
        char *p, *q;

        if (!*prefixes)
                return;

        for (p = prefixes, q = strstr(p, PREFIX_DELIMITER) + 2;
                        *q;
                        p = q, q = strstr(p, PREFIX_DELIMITER) + 2)
                ;
        *p = '\0';
 }

 void report_prefix_pop(void)
 {
        spin_lock(&lock);
	__report_prefix_pop();
        spin_unlock(&lock);
 }

 void report_prefix_popn(int n)
 {
        spin_lock(&lock);
        while (n--)
	        __report_prefix_pop();
        spin_unlock(&lock);
 }

> +}
> +
> +void report_prefix_clear(void)
> +{
> +	spin_lock(&lock);
> +	prefixes[0] = '\0';
> +	spin_unlock(&lock);
> +}

I'm also second guessing the utility of this one. We'd probably almost
never want to do this since most tests are designed with a

  main()
  {
     report_prefix_push("mytest");
     subtest1();
     subtest2();
     ...
     report_prefix_pop();
     ...
  }

type pattern and we wouldn't want to lose that "mytest" prefix when some
subtest calls clear. Let's just drop report_prefix_clear() for now.

> +
>  static void va_report(const char *msg_fmt,
>  		bool pass, bool xfail, bool kfail, bool skip, va_list va)
>  {
> -- 
> 2.43.0
>

Thanks,
drew

