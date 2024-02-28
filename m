Return-Path: <kvm+bounces-10242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B10486AEED
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E546D281405
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B793BBD6;
	Wed, 28 Feb 2024 12:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pqQnPSIw"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A491936132
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 12:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709122577; cv=none; b=U/kUGJnQJHirva5PygQHnRIs0Zyhmy3Q0x6aXlgi8I/L/8X/UTfrRS/gHQ9htt9VVYSigO6seV1iiFgyzKVblmwaDkq/kmbrHEMlXd44eoq581bPolbbnMS12cuX27fcYcdDOIVUYIxTXddd4z+7WkF5Ikbo0KRi+avTfrh1XaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709122577; c=relaxed/simple;
	bh=Rx1ad3KfzUYeaF0IPgydkOVAlLymTlXB9sOfeAZrLWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QB39js/3Q9aXPc6ALvCln7fALrKkfPIhVva0nd9MY74OXpTDNmsmz7wT8TIT4JY8yKweneUROMUTgSpX3Hal/EncQvlBYXfwXjRdnJOwYkFmCkuqd1j1Xpsi9LqJxc1rtXLZuslRvu+yp4CWeGvfwsu2zcwm7+i5Dg4qQPTaqC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pqQnPSIw; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 13:16:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709122573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wM98DJQbhZYjRdplTBCkZEIdEO7RGCuW3V3a9owHybw=;
	b=pqQnPSIwB9gF/E/daD75fzl480laee7IEPIMXVOAUhpEWRm0533/KLZrWm3qI08axtxkER
	ZkGExNnn/5BZWQVoMjpBNO/qs8K24SHvhi8q+ucjaAmI32Ub9qORK6CgDJ287qnQDTuZ3v
	CeQabBnvIsovTkeSuhzl22zkC2DVmt0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 32/32] powerpc: gitlab CI update
Message-ID: <20240228-86aa66c910b91dfebb8afee8@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-33-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226101218.1472843-33-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:12:18PM +1000, Nicholas Piggin wrote:
> This adds testing for the powernv machine, and adds a gitlab-ci test
> group instead of specifying all tests in .gitlab-ci.yml.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  .gitlab-ci.yml        | 16 ++++++----------
>  powerpc/unittests.cfg | 15 ++++++++-------
>  2 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 61f196d5d..51a593021 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -69,11 +69,9 @@ build-ppc64be:
>   - cd build
>   - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
>   - make -j2
> - - ACCEL=tcg ./run_tests.sh
> -     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
> -     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
> -     emulator
> -     | tee results.txt
> + - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci | tee results.txt
> + - if grep -q FAIL results.txt ; then exit 1 ; fi
> + - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-ppc64le:
> @@ -82,11 +80,9 @@ build-ppc64le:
>   - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
>   - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
>   - make -j2
> - - ACCEL=tcg ./run_tests.sh
> -     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
> -     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
> -     emulator
> -     | tee results.txt
> + - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci | tee results.txt
> + - if grep -q FAIL results.txt ; then exit 1 ; fi
> + - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  

We're slowly migrating all tests like these to

 grep -q PASS results.txt && ! grep -q FAIL results.txt

Here's a good opportunity to change ppc's.

Thanks,
drew

