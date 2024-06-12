Return-Path: <kvm+bounces-19418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1BF904CCD
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47F541C242DC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA7C16B73F;
	Wed, 12 Jun 2024 07:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OpBrqRxC"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D38168C33
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718177170; cv=none; b=MtRoYe4QZRvdis4FnHE0ZEtl+s3EBHfdsqxy4psLjKeWJa/nw71zWzJ4wjyGK10b1z/3IReymB2+0xwhYC6m/heQYgNPYKmuOlmMKBFoIu/k7pC6gKyDqyDjnP6eciT5h3SsQSb/UIsnAHKtTaZZq0S5VZc3KTyrY5hxSS7mlhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718177170; c=relaxed/simple;
	bh=6uG0kG06//bUMsxADp+JsslN5JNIT0eYPN29yoJLVuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qG+00QeVFyVY9fDx9yQCxoedYuw7LB9VGYlamRLYbXDG4mYfobw71tRqB5SAHOEpbZdwzkPpKHGhixQ1tg3VYZajAkRRSW7WGcv1FJ6de3aWoSy0ZJ0o/mHen21dAlGuBKRAuzd+IkSajthsHVtcVkrSXATYBIeLfanEYU6mqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OpBrqRxC; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718177166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5YuQn5IrAUYtmbzCV9i0/B6NGjQuNoPZLzpKUN9oVV8=;
	b=OpBrqRxCjpyZUNsoUlgKjxwgbMlJBuNrf3NFF8PCul+SMsRawTFcZk+2I0vXG57v0zICk8
	tuy6MZMkTzEG8jLSsIe+flYk5u3XQ1keborCHXC7u1U+Gareizr2iGpagZkJR9ZnslyMBb
	w6/vNH/pGyBLSbNSRc9OKpIzRpVUb7A=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: lvivier@redhat.com
X-Envelope-To: linuxppc-dev@lists.ozlabs.org
X-Envelope-To: kvm@vger.kernel.org
Date: Wed, 12 Jun 2024 09:26:04 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v10 12/15] scripts/arch-run.bash: Fix
 run_panic() success exit status
Message-ID: <20240612-eef98a649a0764215ea0d91f@orel>
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-13-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612052322.218726-13-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 12, 2024 at 03:23:17PM GMT, Nicholas Piggin wrote:
> run_qemu_status() looks for "EXIT: STATUS=%d" if the harness command
> returned 1, to determine the final status of the test. In the case of
> panic tests, QEMU should terminate before successful exit status is
> known, so the run_panic() command must produce the "EXIT: STATUS" line.
> 
> With this change, running a panic test returns 0 on success (panic),
> and the run_test.sh unit test correctly displays it as PASS rather than
> FAIL.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 8643bab3b..9bf2f0bbd 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -378,6 +378,7 @@ run_panic ()
>  	else
>  		# some QEMU versions report multiple panic events
>  		echo "PASS: guest panicked"
> +		echo "EXIT: STATUS=1"
>  		ret=1
>  	fi
>  
> -- 
> 2.45.1
>

Do we also need an 'echo "EXIT: STATUS=3"' in the if-arm of this if-else?

Thanks,
drew

