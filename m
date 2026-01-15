Return-Path: <kvm+bounces-68216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF46D26F2D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 01266301519F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F863D300B;
	Thu, 15 Jan 2026 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pDE1qhg5"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283AF3C00AD
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499408; cv=none; b=hZnVMUhPPl50HdC/1kVH3QSJiT2nzr5yIKh0zRb88WCB1e1o9JpYI+wOL79Fz8XtkkpojyUtjWP/qa9mArj1SqvqGnkH3FK+9NMt5kNBDx2bYLnaW+EU3SJBPpBtNmWvdb6lM7IixUfuFwwFDM0FuRfaNZeylm9eYFvH9rElbyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499408; c=relaxed/simple;
	bh=+q4NpWQfclDdipw03fmvbYRUaJYnvDfHUfF8F2U7ZiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsUE+r2l8ROjqyLbrIEkRPRas1PMmQdrXZdaTkV+vCNx9b74NWwzefemDX/ekpGdVAfKfscK+krpgfdmtIJyQCTzSh5o5CvC30nNQIDFgJK59lY+GPpC23Wz1r3s+2IYdZBSQpIznt7Vmme+jv3ImfkyXgqfvm1ASrZWCWC+TDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pDE1qhg5; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 11:49:59 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768499405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wtw6YKUFFRSuFDlpZjw+2Awb0sSnFsWY00nk9kTaeXo=;
	b=pDE1qhg50UCQuUQh8YQstiZJfdi6ITDG7ndUfamfZFacUJy+rau6itNSEWA5HbITtWGf96
	+/GQT9dHPLTjTwZcyeMgN8Hle81TyGjtXEgr8ADoZ7sfXaKf+/4CD4k0exAMKCrnDs0qQc
	CeiVmHVl3UTW7tzDeDrsyhNY6o8cGfo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
Message-ID: <4kdukgjjxxe4fbu37wfkfistb4xlvw6seytrjtvs2cghk3krrd@jx7dx7wofkc2>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 15, 2026 at 11:40:17AM -0600, Andrew Jones wrote:
> On Wed, Jan 14, 2026 at 11:56:52AM +0000, Joey Gouly wrote:
> > Hi all,
> > 
> > This series is for adding support to running the kvm-unit-tests at EL2.
> > 
> > Changes since v4[1]:
> > 	- changed env var to support EL2=1,y,Y
> > 	- replaced ifdef in selftest with test_exception_prep()
> > 
> > Thanks,
> > Joey
> > 
> > [1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/
> >
> 
> Hi Joey,
> 
> So this series doesn't appear to regress current tests, but it also
> doesn't seem to completely work. I noticed these issues when running
> with EL2=1 (there could be more):
> 
>  - timer test times out
>  - all debug-bp fail
>  - all watchpoint received tests fail for debug-wp
>  - micro-bench hits the assert in gicv3_lpi_alloc_tables()
>    lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?
>

We should get the above fixed or skipped with some justification before we
merge. Also please add a test to .gitlab-ci.yml that has EL2=y. I assume
just a non-efi, gcc configuration would be sufficient.

Thanks,
drew

