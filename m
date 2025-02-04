Return-Path: <kvm+bounces-37279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A97A27FCC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 00:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 746723A5056
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 23:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E9621E08A;
	Tue,  4 Feb 2025 23:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IdJQbGFc"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4DA2040B5
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738713194; cv=none; b=T6+hvXxLJhOw/76+/n1IfktFffDDiCnunRZkuratbgYEA8r2PlFGfRRMoNpuIYDx9/A5MPo1CzxYvUpH+s2qQPycGyAQzQXgApx7cWxIzL29LlmujnrxzAr4fCXap3z9nzcLKVNLfIbaxoaAUPVyBPD9IgIqvmkeRApc/noIshA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738713194; c=relaxed/simple;
	bh=HDBETOnnDKYdUbldkmXtgxU6aLAk4EpTG/rCxjNdfTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1+SkSRqJGJyKhT8q+YGhPT7aobiogus5DRJXRXbwSZdgSbRlqRKp2L7jlIFQeTztOFT5XB3x7ZHpja06rgARg6EpQfvctP/lewZoGVK5lAC1wx94CDl10/7ZrW0bkwfGfA6F1V7g2bhos2nBU0MkIuJz1lsuflSbEVFmoVEelk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IdJQbGFc; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 4 Feb 2025 23:52:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738713180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Aty+ANBki8vd8K5qrbGPn1eFRL7U1+Ke6iGWT0ec40Y=;
	b=IdJQbGFcwdrAQZYo4ldhrPJfK+K3DW647JeHvI+fV3JfOpvYSaEnHJr1OK4wRok06P06C3
	1L9uJTC1ZB+KHMaiRRasHRgL1xTPYFR0u9f59apZgiEnvIMooyFJLV6qKjNXVsC90aL4PL
	73vvrkrHMQ+vqzvwvwWgjiNeollFHwM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/2] perf: arm_pmuv3: Remove cyclical dependency with
 kvm_host.h
Message-ID: <Z6KoUBdmjVRuqPnU@linux.dev>
References: <20250204195708.1703531-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204195708.1703531-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Tue, Feb 04, 2025 at 07:57:07PM +0000, Colton Lewis wrote:
> asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
> which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
> causes confusing compilation problems when trying to use anything in
> the chain.
> 
> Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
> because asm/kvm_host.h is huge and we only need a few functions from
> it. Move the required declarations to asm/arm_pmuv3.h.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Please do not move KVM namespaced functions into non-KVM headers. Having
a separate header for KVM<->PMUv3 driver interfaces is probably the
right thing to do, especially since you're going to be adding more with
partitioned PMU support.

-- 
Thanks,
Oliver

