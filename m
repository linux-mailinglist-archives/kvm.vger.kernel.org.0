Return-Path: <kvm+bounces-16685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF768BC90B
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C0871C2167C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22D21428F2;
	Mon,  6 May 2024 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GgKG6xSa"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042D1411D5
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 08:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714982498; cv=none; b=WzVB7wdtF3u/Ur0jOGbdM/S4GO3DzPD/5udyaQOrYY4moL90S1rgEemIP0XCLWYc81Kl/uLac6+7K7myRYnGi6SnJnla9Ojv/F12f+eaalEaQc5wNoonN0nL3giEpf0tUgNPYma4cQNsdcwv4tefSeKv6ZCsDmuHD4H95OsXd+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714982498; c=relaxed/simple;
	bh=SL9wNHf399QUMGynYDszUeSeMdemSdUp3L30LcwRM1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVOmK+7UulbyTVaIqNuEE6rKV2ZATXzaWHuWXJOetttwob6DrbBMAbzBfIMGXt8lfDtFwCOL+mF/LQpuElO1LZqjXLPdmlN5mi7PzGBYNb+HWNsJwi2bCIyMgkR6OyJlQHFRvV7Y+L/H5NNE+qSUCDeREs8OODlJKR8MiKBr450=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GgKG6xSa; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 6 May 2024 10:01:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714982494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7/dKDnsWOprmuXZHAB4ViI0IKkujsH7xFR49QJKEfrY=;
	b=GgKG6xSaM7zIPZp/d4hkvStj4BG1loLavwOoHyC+9paiNGEcUkx5Wv3w2PxMRby37Y/zr6
	2QOUGkhJEnxbR4037Vm6eKLFod8DSjxsm7RtxKXs9S0porK+fZ9u88BXv17FYBkEqA4Wos
	A3ymP1L2DCaetDX4dhpiZ7b256djpWE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
	Laurent Vivier <lvivier@redhat.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v9 02/31] report: Add known failure
 reporting option
Message-ID: <20240506-c712c1cc4467cd154bbc7ee8@orel>
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-3-npiggin@gmail.com>
 <aed85321-7e8e-4202-9f91-791229ef9455@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed85321-7e8e-4202-9f91-791229ef9455@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, May 06, 2024 at 09:25:37AM GMT, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > There are times we would like to test a function that is known to fail
> > in some conditions due to a bug in implementation (QEMU, KVM, or even
> > hardware). It would be nice to count these as known failures and not
> > report a summary failure.
> > 
> > xfail is not the same thing, xfail means failure is required and a pass
> > causes the test to fail. So add kfail for known failures.
> 
> Actually, I wonder whether that's not rather a bug in report_xfail()
> instead. Currently, when you call report_xfail(true, ...), the result is
> *always* counted as a failure, either as an expected failure (if the test
> really failed), or as a normal failure (if the test succeeded). What's the
> point of counting a successful test as a failure??
> 
> Andrew, you've originally introduced report_xfail in commit a5af7b8a67e,
> could you please comment on this?
> 

An expected failure passes when the test fails and fails when the test
passes, i.e.

  XFAIL == PASS (but separately accounted with 'xfailures')
  XPASS == FAIL

If we expect something to fail and it passes then this may be due to the
thing being fixed, so we should change the test to expect success, or
due to the test being written incorrectly for our expectations. Either
way, when an expected failure doesn't fail, it means our expectations are
wrong and we need to be alerted to that, hence a FAIL is reported.

Thanks,
drew

> IMHO we should rather do something like this instead:
> 
> diff --git a/lib/report.c b/lib/report.c
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -98,7 +98,7 @@ static void va_report(const char *msg_fmt,
>                 skipped++;
>         else if (xfail && !pass)
>                 xfailures++;
> -       else if (xfail || !pass)
> +       else if (!xfail && !pass)
>                 failures++;
> 
>         spin_unlock(&lock);
> 
>  Thomas
> 

