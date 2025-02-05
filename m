Return-Path: <kvm+bounces-37281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B7BA27FD8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 01:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 222B9165A5D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 00:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF53DF71;
	Wed,  5 Feb 2025 00:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a9d73MEr"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3165FDF5C
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 00:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738713627; cv=none; b=WwyueWrkTQHhSQ7tOf+T+hx2gfBkYAWCs3V5FI+I+281IkbaxPYY7Ilu32gM9q4quRe5DhM9oDxEq9G5Hm+rsxrstKCOmKwGrZJYwM8ZHGZbSXlXBSWfP6SGRpWPE80c9diKVRJ7GF8bsOga+1o3Kll9tHBM6r7FakOn+wJsr2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738713627; c=relaxed/simple;
	bh=4bUW/OLEo2ALx/TpncGtCsLvYOuiCOTA0BybxP3ag6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bz8O4Rf+c2U0AqR9h9EVNl/P+tF4Bull1uBN3mXZOOLqo15+GIWErghJs/s64OjUX8fxSe7/PJv1MhEcxECT7e6mDPApChRHyHe+wkQYh8V7CV/Pg6mBFE+SS/MR5T/pxEiRRiJw1Ht9LRly44gjen4syvJ99C8fN61pj3pdlG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a9d73MEr; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 5 Feb 2025 00:00:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738713618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YEGeIQ/RCr8VvVfV06i+b8+5DnmNJQ5h/zFNOrFOtFg=;
	b=a9d73MErLZkqToq5s+8YSzdC0AyZo9DB+BMttxD0hdRmFHTbVhUWGiZHiceUQZ13C6JtEJ
	WmcuaNSUjlOBaeh875NRSsyTcFEhlKKscQ/r/IF8LDTvGikCumau/trvdxKsMMtYPFgMyN
	kqYiNeLaAHcxV6r1q2q+9yGGYwcruhc=
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
Subject: Re: [PATCH 2/2] perf: arm_pmuv3: Uninvert dependency between
 {asm,perf}/arm_pmuv3.h
Message-ID: <Z6KqDR3S_AWXXLJK@linux.dev>
References: <20250204195708.1703531-1-coltonlewis@google.com>
 <20250204195708.1703531-2-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204195708.1703531-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 04, 2025 at 07:57:08PM +0000, Colton Lewis wrote:
> perf/arm_pmuv3.h includes asm/arm_pmuv3.h at the bottom of the
> file. This counterintiutive decision was presumably made so
> asm/arm_pmuv3.h would be included everywhere perf/arm_pmuv3.h was even
> though the actual dependency relationship goes the other way because
> asm/arm_pmuv3.h depends on the PMEVN_SWITCH macro that was presumably
> put there to avoid duplicating it in the asm files for arm and arm64.
> 
> Extract the relevant macro to its own file to avoid this unusual
> structure so it may be included in the asm headers without worrying
> about ordering issues.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Is the intention of this change to allow asm/arm_pmuv3.h to be directly
included? If yes, what's the issue with using perf/arm_pmuv3.h?

We already use definitions from the non-arch header in KVM anyway...

-- 
Thanks,
Oliver

