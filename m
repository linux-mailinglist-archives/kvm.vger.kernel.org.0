Return-Path: <kvm+bounces-57723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789FAB5973D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F5D317CF87
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A14BA4A;
	Tue, 16 Sep 2025 13:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qrm5PMfb"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FA615A8
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758028611; cv=none; b=eEwAip5rnTfSA1WlFxvMRC5wqR7PaYRcyDv2SqtYd7hr13LI/1CTDuL7LT53xsILZqklOwOLPPldK66FfwNuZevQAYlDh0KtqLxEtktCPC/VTSMscgBYbdCELZ3HNe48tSVk/5VHDUKvH8t4eRtkhK364oIz4ds72yfSdrBqgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758028611; c=relaxed/simple;
	bh=QzKNoQ/jQJodKztgUU4q3uw9r/4Gyt/T9sffIK9AVec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLHddhpyHcOOo9VqcPpXT4MpIdHrpKVtLnCq4KyareRY07gyAyYV7XcnGwxO20er588tqYVI0JoUug2b7uRhuUjT0T2buG2mwphSwuRcOBVaHFukFvxBTMlX7EPsvybOL7Cbt6D36P85XyQYzbm8UefZGMXPpcG2Ew8LOckTJUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qrm5PMfb; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 16 Sep 2025 08:16:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758028607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w4UPGVwXwdB6ooQ9EzJ26/PxWaWFYIHrZOmo5RUZrxs=;
	b=qrm5PMfb/wVkpQaeFOrnsPZQB9XoHgB2XmR9aaeQybZk15tGgUJw7p1nGgmdabAPQ4WUTv
	e/PNsffBY2MOpELZANHEDoXrPG1Em4FfoNdQxaKunXQCsdkkbhGiMfr9IKehUA69y7I2Gg
	+7Z1KUNHbQ9X9GrpQMtHjFRh7hTIXew=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib: make limits.h more Clang friendly
Message-ID: <20250916-bf9bec5dc6fa08a183dff78f@orel>
References: <20250915221241.372800-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915221241.372800-1-minipli@grsecurity.net>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 16, 2025 at 12:12:41AM +0200, Mathias Krause wrote:
> Clang doesn't define the __${FOO}_WIDTH__ preprocessor defines, breaking
> the build for, at least, the ARM target.
> 
> Switch over to use __SIZEOF_${FOO}__ instead which both, gcc and Clang
> do define accordingly.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  lib/limits.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/limits.h b/lib/limits.h
> index 650085c68e5d..5106e73dd5a2 100644
> --- a/lib/limits.h
> +++ b/lib/limits.h
> @@ -12,29 +12,29 @@
>  # endif
>  #endif
>  
> -#if __SHRT_WIDTH__ == 16
> +#if __SIZEOF_SHORT__ == 2
>  # define SHRT_MAX	__INT16_MAX__
>  # define SHRT_MIN	(-SHRT_MAX - 1)
>  # define USHRT_MAX	__UINT16_MAX__
>  #endif
>  
> -#if __INT_WIDTH__ == 32
> +#if __SIZEOF_INT__ == 4
>  # define INT_MAX	__INT32_MAX__
>  # define INT_MIN	(-INT_MAX - 1)
>  # define UINT_MAX	__UINT32_MAX__
>  #endif
>  
> -#if __LONG_WIDTH__ == 64
> +#if __SIZEOF_LONG__ == 8
>  # define LONG_MAX	__INT64_MAX__
>  # define LONG_MIN	(-LONG_MAX - 1)
>  # define ULONG_MAX	__UINT64_MAX__
> -#elif __LONG_WIDTH__ == 32
> +#elif __SIZEOF_LONG__ == 4
>  # define LONG_MAX	__INT32_MAX__
>  # define LONG_MIN	(-LONG_MAX - 1)
>  # define ULONG_MAX	__UINT32_MAX__
>  #endif
>  
> -#if __LONG_LONG_WIDTH__ == 64
> +#if __SIZEOF_LONG_LONG__ == 8
>  # define LLONG_MAX	__INT64_MAX__
>  # define LLONG_MIN	(-LLONG_MAX - 1)
>  # define ULLONG_MAX	__UINT64_MAX__
> -- 
> 2.47.3
>

Merged.

Thanks,
drew

