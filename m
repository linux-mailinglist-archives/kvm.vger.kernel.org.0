Return-Path: <kvm+bounces-14392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E258A26A3
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8ED12823B4
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 06:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D18F2BB07;
	Fri, 12 Apr 2024 06:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W+3A7Cse"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DDF1F5F6
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712903489; cv=none; b=YRpck+dMDkneYwib6pCDGpQTECEhJscpQuLZioqW0GJf9a9DQvtVLuPX6rY1/CVbu1fd/Uh7ODaS6LnZyX5V70j5wrHqMFAoMiTxClSJ4HUM2sGyezVFr2JYfZUt4za4ulOufFxTZprxEXXGBfGVxr16W56xRLJdP8eWvOyWfqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712903489; c=relaxed/simple;
	bh=D2PiIwepiC0Z8UXY/goLO0UKjblrFEHdz0YLXj89EjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9H3A6mS2U0RJmb9aG5mDVY4DLkngm7voIGHZaTuj1cEDAKp2YcflCyC21+Wrsa2IlArY0cXOYRZtPIcSVIGH0kPzYzrNBp2H3rQWBnEboRkigBYRJJzjgSVULK/khWzrLt8l01hMijosw9sgIwcAHq2uIkeDfwjOwH2/HcJcGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W+3A7Cse; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 12 Apr 2024 08:31:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712903484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y0zNv7GN+b0fZObPzOvHWREBqaGgwzwrjjFCesNKrvQ=;
	b=W+3A7CsevvsmGk4Yp59xpMRFIdBSfa7vW33XbZj1w7RC4NmvuodToqHlev83Z6snBl+HQ2
	kCRUM1WgCEId1s3bLDCNOmXHXf6Qg6LYgk8L3JiqKgnC9dY2c5orEh1ysz+V+43A7GxJU3
	e4zPQBZ2QRMhl+wKRusbpKfOE3OPdM0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: vsntk18@gmail.com
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com, 
	jroedel@suse.de, papaluri@amd.com, zxwang42@gmail.com, 
	Vasant Karasulli <vkarasulli@suse.de>, Varad Gautam <varad.gautam@suse.com>
Subject: Re: [kvm-unit-tests PATCH v6 03/11] lib: Define unlikely()/likely()
 macros in libcflat.h
Message-ID: <20240412-9de83cb19c41400b32584104@orel>
References: <20240411172944.23089-1-vsntk18@gmail.com>
 <20240411172944.23089-4-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411172944.23089-4-vsntk18@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 11, 2024 at 07:29:36PM +0200, vsntk18@gmail.com wrote:
> From: Vasant Karasulli <vkarasulli@suse.de>
> 
> So that they can be shared across testcases and lib/.
> Linux's x86 instruction decoder refrences them.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> ---
>  lib/libcflat.h | 3 +++
>  x86/kvmclock.c | 4 ----
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 700f4352..283da08a 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -167,4 +167,7 @@ extern void setup_vm(void);
>  #define SZ_1G			(1 << 30)
>  #define SZ_2G			(1ul << 31)
> 
> +#define unlikely(x)	__builtin_expect(!!(x), 0)
> +#define likely(x)	__builtin_expect(!!(x), 1)

Please put these in lib/linux/compiler.h

Thanks,
drew

> +
>  #endif
> diff --git a/x86/kvmclock.c b/x86/kvmclock.c
> index f9f21032..487c12af 100644
> --- a/x86/kvmclock.c
> +++ b/x86/kvmclock.c
> @@ -5,10 +5,6 @@
>  #include "kvmclock.h"
>  #include "asm/barrier.h"
> 
> -#define unlikely(x)	__builtin_expect(!!(x), 0)
> -#define likely(x)	__builtin_expect(!!(x), 1)
> -
> -
>  struct pvclock_vcpu_time_info __attribute__((aligned(4))) hv_clock[MAX_CPU];
>  struct pvclock_wall_clock wall_clock;
>  static unsigned char valid_flags = 0;
> --
> 2.34.1
> 

