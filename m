Return-Path: <kvm+bounces-41803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0CBA6DAE1
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 14:14:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 687AA3B058C
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 13:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76BF25EFA6;
	Mon, 24 Mar 2025 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KmVRmpHV"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824F3257448
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742822011; cv=none; b=FlHx2/ixf6N1TrrtAICBHAtkUfzxR5rNJgkx9qU6AE1+zWwH4/oZAHP8edxjd65MRVSQl+IuI6OoRKRc0lVDiUQzmRLm3DNyj3YRKT5YF/B/FayzTdbsCuSFvu3aZPrG+2r+fHf6vLklC+5zYGRe2aD4gDRszf0aQAYeWwHjTN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742822011; c=relaxed/simple;
	bh=cFQjfndprJ1cFN+ao/KGhan0LlEH0OfM4e91hq0Y/XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nm7z9fYbkw1W7tVjkqrIFakCA/s76DFcXR3A6BoARUmM7RthPqwpQni6fDJwbrQPYRoBY8JAav2kS7lumQyFa+n5hOPWzctXSrdp/V+uyTKC2Tcb3zFEl/vC2WxaYk1A4ali0Cu3OjKSoMIGiquPd3W33A3TJNurv8FhhrFvy7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KmVRmpHV; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 24 Mar 2025 14:13:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742821996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W+lo7ZJTmaQcIg4xRXI3NSrRPyI/Hr06T/3WGXyDV+w=;
	b=KmVRmpHVdghjXdxP6nw9wJnCjjJist9dS8Mtziz78U1YauSna9vS2diH/pXsb0nMtVSouo
	aNBLSRtOh1q8v/oWPFaaZa38BjYVADDytc5LKHYceYXnS7JxzhDr0yhm+INt/05rFtV1m0
	yS3otZzwOlpo5gpYVrtgEPNon62Q3gM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	eric.auger@redhat.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <20250324-37628351a72ca339819b528d@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
 <Z9_tg6WhKvIJtBai@raptor>
 <20250324-5d22d8ad79a9db37b1cf6961@orel>
 <Z-E2v1sKiPG_pt9x@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-E2v1sKiPG_pt9x@raptor>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 24, 2025 at 10:41:03AM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Mon, Mar 24, 2025 at 09:19:27AM +0100, Andrew Jones wrote:
> > On Sun, Mar 23, 2025 at 11:16:19AM +0000, Alexandru Elisei wrote:
> > ...
> > > > > +if [ -z "$qemu_cpu" ]; then
> > > > > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > > > > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > > > > +		qemu_cpu="host"
> > > > >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > > > > -			processor+=",aarch64=off"
> > > > > +			qemu_cpu+=",aarch64=off"
> > > > >  		fi
> > > > > +	elif [ "$ARCH" = "arm64" ]; then
> > > > > +		qemu_cpu="cortex-a57"
> > > > > +	else
> > > > > +		qemu_cpu="cortex-a15"
> > > > 
> > > > configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> > > > need to duplicate it here.
> > > 
> > > That was my first instinct too, having the default value in config.mak seemed
> > > like the correct solution.
> > > 
> > > But the problem with this is that the default -cpu type depends on -accel (set
> > > via unittests.cfg or as an environment variable), host and test architecture
> > > combination. All of these variables are known only at runtime.
> > > 
> > > Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
> > > above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
> > > in config.mak, but arm/run using it only under certain conditions is worse than
> > > not having it at all. arm/run choosing the default value **all the time** is at
> > > least consistent.
> > 
> > I think having 'DEFAULT' in the name implies that it will only be used if
> > there's nothing better, and we don't require everything in config.mak to
> > be used (there's even some s390x-specific stuff in there for all
> > architectures...)
> 
> I'm still leaning towards having the default value and the heuristics for
> when to pick it in one place ($ARCH/run) as being more convenient, but I
> can certainly see your point of view.

I wouldn't mind it only being in $ARCH/run, but this series adds the same
logic to $ARCH/run and to ./configure. I think an additional, potentially
unused, variable in config.mak is better than code duplication.

Thanks,
drew

