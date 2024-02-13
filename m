Return-Path: <kvm+bounces-8637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C70D853C11
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 21:12:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC6D5286898
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 20:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7A260B9E;
	Tue, 13 Feb 2024 20:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gaknWtD7"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEBD60B88
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 20:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707855147; cv=none; b=OxdeC4oaQF/ettTB/xGTKYdXFLaBu1ZHNXIqqRfNpY7ANcvNeeoScQl5PLJFQfmz+aO3n8Pmt5/eKDbPbqnK9NjUAUJOFuBInwLeLhZYOJ4sHcm+YlZkQaF4vv0kmVQtoO/QkLGBHj3WFxZ8OxCMX0Rz0R5paTaxJiqv8EhcJMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707855147; c=relaxed/simple;
	bh=WzClOifpUCSoYB1Gr9NXXGUfJ+JOmYmKWTDQuwaxiRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWWuHVnOgFvCSS5nMXs72P2dvZfzpky+g2LPTZodNybCMwG5ClLs1ltf9SOK3L6S7iFOZHYtaVpy8AQyY+PZNnFt3YBE/chw4P3PamfYTMVwwoBOuJ6Nz4oYVmjXWT6hDygvQOt62HSpKTSwvZSckxJz+iJiMx5jNpT2Ft3wGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gaknWtD7; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Feb 2024 12:12:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707855143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ynvcun4Y8ZFlfFtT4gj87TNcq60Lzv8L5cy3V0DM2g=;
	b=gaknWtD7n6/VN29uhilsWT819EYmFiEjAGhQwHAGgX+2Z4hnXnh/JZQKCHj4890NhvfADc
	3SgZMXDJSeCH5W85ySuI8VTgUGytg0q5wQV0W5G1RtEm092yItcmgCZfv4vollSNKJ7vbw
	bkWKua0XYQmHDvlfRJEjs24ZYMHzQHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] KVM: arm64: Improvements to LPI injection
Message-ID: <ZcvNIQmLMHcGnC7m@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 13, 2024 at 09:32:37AM +0000, Oliver Upton wrote:

[...]

> Clearly the RCU synchronization is a bounding issue in this case. I
> think other scenarios where the cache is overcommitted (16 vCPUs, 16
> devices, 17 events / device) are able to hide effects somewhat, as other
> threads can make forward progress while others are stuck waiting on RCU.
> 
> A few ideas on next steps:
> 
>  1) Rework the lpi_list_lock as an rwlock. This would obviate the need
>     for RCU protection in the LPI cache as well as memory allocations on
>     the injection path. This is actually what I had in the internal
>     version of the series, although it was very incomplete.
> 
>     I'd expect this to nullify the improvement on the
>     slightly-overcommitted case and 'fix' the pathological case.
> 
>  2) call_rcu() and move on. This feels somewhat abusive of the API, as
>     the guest can flood the host with RCU callbacks, but I wasn't able
>     to make my machine fall over in any mean configuration of the test.
> 
>     I haven't studied the degree to which such a malicious VM could
>     adversely affect neighboring workloads.
> 
>  3) Redo the whole ITS representation with xarrays and allow RCU readers
>     outside of the ITS lock. I haven't fully thought this out, and if we
>     pursue this option then we will need a secondary data structure to
>     track where ITSes have been placed in guest memory to avoid taking
>     the SRCU lock. We can then stick RCU synchronization in ITS command
>     processing, which feels right to me, and dump the translation cache
>     altogether.
> 
>     I'd expect slightly worse average case performance in favor of more
>     consistent performance.

Marc and I had an off-list conversation about this and agreed on option
4!

It is somewhat similar in spirit to (3), in that KVM will maintain an
xarray translation cache per ITS, indexed by (device_id, event_id). This
will be a perfect cache that can fit the entire range addressed by the
ITS. The memory overheads of the xarray are not anticipated to be
consequential, as the ITS memory footprint already scales linearly with
the number of entries in the ITS.

Separately the DB -> ITS translation will be resolved by walking the
ITSes present in the VM.

The existing invalidation calls will be scoped to an ITS besides the
case where the guest disables LPIs on a redistributor.

-- 
Thanks,
Oliver

