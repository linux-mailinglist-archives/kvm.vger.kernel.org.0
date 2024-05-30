Return-Path: <kvm+bounces-18372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C34E48D468E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 09:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D965B23F95
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 07:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A43F145FFC;
	Thu, 30 May 2024 07:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T1JDp4e7"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC984144312
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 07:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717055952; cv=none; b=thkDxotq4X9PBhvC1vpybv67nTS3Ox2MJ1oguY49NvCzqdfTv3VGW19hBWX+cMNW8Pl0NXb2EUiYWTC+Kr9MenL3Ul0TM4djSxr+bgSZ28kWZKr23brmK180Gu0JTSBmptnnEQdxknYuWr5svISYDTejxb1zNwj7rBIlTGFTcpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717055952; c=relaxed/simple;
	bh=x4RTL7GGVxTdMNVNuJ+EfcpaoHHQyiychP8r5xFjFcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvW2RhBh8napW9DdwZxNQhevQKi6RJeMAdl59aL/6apzDcp4pmeItM0zg6sPK7wqtY0hKEYTXmHOVoKridCCeBYDjmjzQv+TTa3m5R9mrOkrfDk/i8MClLaUfkoWfAwGSmn/2RxeI8SKe0PRpDFxksv/LD5yi3VxNP1IWswg/5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T1JDp4e7; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717055946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5qARTxaLbdlZYiuPUsTT1ic7ttNyDuJKm9VDNxbNK3g=;
	b=T1JDp4e7Bhqh9Bd7sN/9sjo49CiLRc/qJ18MfEMHSVnOZnAgpWH3RP8WIsuJT/xdtwALWt
	fw/bTC5Ji7izzHNbtCplIu/xGLZwcOI19aLZfV6uTSCoDGmHjmIdk9ATaXL1bEkhiBEFfg
	zLUqpEFtqYTC3g+swEZZKbTVAlKjDNU=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: joey.gouly@arm.com
Date: Thu, 30 May 2024 00:58:58 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 0/2] KVM/arm64 fixes for NV PAC support
Message-ID: <ZlgxwgqD23PAytHR@linux.dev>
References: <20240528100632.1831995-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528100632.1831995-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, May 28, 2024 at 11:06:30AM +0100, Marc Zyngier wrote:
> Here's a small series of fixes following the introduction of NV PAuth
> support in 6.10:
> 
> - address the relative priorities of Instruction abort, Illegal
>   Execution state, and PAC failure (already posted)
> 
> - Expose BTI to a NV guest now that we have PAC up and running
> 
> Unless someone shouts, I'll take these patches in the next batch of
> fixes.
> 

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

