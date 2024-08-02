Return-Path: <kvm+bounces-23014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F48F945A15
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 10:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CEEF287883
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 08:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8BE1C232C;
	Fri,  2 Aug 2024 08:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SzNNVzhA"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0955E1CAB3
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722587813; cv=none; b=j6GCbzrLWgOlRaq0HDKy5T4y2GWxrbtC5I0NGfFzZ1u1NVIxOb/5XmHz1Okh72TsqegUr/BCgLQr8AL3UuNdc6Zwqld8ER4zg0PV/YFF+6oLOSPrhVAKR8OwFI6ACywp2XIr+3pGyM0NeLCUcL8z53MJkUvG+CSf5QXnctMKiIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722587813; c=relaxed/simple;
	bh=uH73t2uudehW4cmTGCt4ob5bIIcqZvMN2P0AqT2U35E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0Lk9fdd55mgTkAUMajggYyZ1PIBXA1ni3nwaK/6knmGaOSY5jjroQf/tkAUglQ+m5Exd6sDGIxeNrbRNAQHviC5ZeQosi+z2oUTqIMcAirUEzHduEAWobJbTdNTnYqueQfpQRe8UXAKCsIa2vYQGWYk1lvvjRoksTysXmRES00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SzNNVzhA; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Aug 2024 10:36:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722587807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FRlttjyDqNVgAy/GeHfeYkuOTli7qGERroWjKCD1nNU=;
	b=SzNNVzhAYjQJiuVFnUv6Vgf3GXJGOJYxkiqQ8I3hu+zAlXIHqpHWaBIEpO0vCMVqcHmEtX
	uGiENFxJceH1kz+SfwhR2W1xiaB8u0mhREzuywBsxetpVZY0k49QXXonjaLl5WxdVq1f95
	MshIZ9J7RaVVAOlAw6RXqtVbXO4nBog=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v6 5/5] riscv: sbi: Add test for timer
 extension
Message-ID: <20240802-e1bd80fc34bfd2caaf52d0b8@orel>
References: <20240730061821.43811-1-jamestiotio@gmail.com>
 <20240730061821.43811-6-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730061821.43811-6-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 30, 2024 at 02:18:20PM GMT, James Raphael Tiovalen wrote:
> Add a test for the set_timer function of the time extension. The test
> checks that:
> - The time extension is available
> - The installed timer interrupt handler is called
> - The timer interrupt is received within a reasonable time interval
> - The timer interrupt pending bit is cleared after the set_timer SBI
>   call is made
> - The timer interrupt can be cleared either by requesting a timer
>   interrupt infinitely far into the future or by masking the timer
>   interrupt

I've modified the "or by masking the timer interrupt" test to work as I'd
expect it to based on a bit more thought about what the SBI TIME extension
spec is trying to say (we should clarify the spec with the PR you've
written). I also added a test for ensuring a timer is pending immediately
when setting the time with a value of zero. All tests pass.

I also moved some code around a bit and a couple other minor cleanups.

And (drum roll, please), it's now merged!

Thanks,
drew

