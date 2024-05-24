Return-Path: <kvm+bounces-18146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B45F68CEA35
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 21:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 676E1281A7E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 19:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB8F44376;
	Fri, 24 May 2024 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s6eqr+MU"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22434084E
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 19:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716578024; cv=none; b=PH2XsswaAtjPUG55bG5xg1mAlCltKAPrxmpfcKLDAQ0BdUrdZs5YiigP6Wvdnt6jZoRAShEls6mwE9/TbTO/FLO96zclp9BTAErcPlmXhI3DwjsYe736+Es04ZYD6kXe/fBjJR7jezY0C98SuRs2S0VAfQ9dNxEGmkZ/AJg5++I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716578024; c=relaxed/simple;
	bh=vc8o9K8NBRIua7Rfv4KJbf4Bv/uDlTV4rNenfgWdEUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCKivHSeooa7VqDHdfmlSvXgNb+PHT2vBUDIhT2CYBnsrm0Lo9vsBLPHlRr8tdo8Na058jrusBLuEGt6VJLZSJcULcWbfGMB36l7mC08owK0bShnjW9mLjSUnS7nz3O2w81reIeRz3jnGOanrsZnwbo6d4LP/rKJN8QmaUSquqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s6eqr+MU; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716578019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e4xsaOPA9gGcOVUExbmRnE5sLYdiYNTU9786Z4HVcqU=;
	b=s6eqr+MU60pWRFwhNU+4ZWkEJor1/+cwcaF8l4PLRDqBjk7nkjvaHWsWFSiDqnpeB7MqJf
	6l1/nUfRWNViZ73VEibqQk4J+hKAXs1muec2S8sRvyGI5618GVieyp1iioGQVNX0d1v9e5
	PNuXDHTmcC5MCsrJv6oaCQOAkIqp69Y=
X-Envelope-To: t@linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: nsg@linux.ibm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
Date: Fri, 24 May 2024 12:13:34 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, t@linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM/arm64 fixes for AArch32 handling
Message-ID: <ZlDm3m0g9xSeG9TO@linux.dev>
References: <20240524141956.1450304-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524141956.1450304-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, May 24, 2024 at 03:19:53PM +0100, Marc Zyngier wrote:
> The (very much unloved) AArch32 handling has recently been found
> lacking in a number of ways:
> 
> - Nina spotted a brown paper-bag quality bug in the register narrowing
>   code when writing one of the core registers (GPRs, PSTATE) from
>   userspace

Yuck!

> - We never allowed System mode to be restored. Nobody ever complained,
>   but this is wrong nonetheless
> 
> - The handling of traps failing their condition check went from dodgy
>   to outright broken when the handling of ESR_EL2 was upgraded from 32
>   to 64 bit (patch already posted).
> 
> All these are stable material, and I plan to merge them after -rc1
> is released.

Please do!

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

