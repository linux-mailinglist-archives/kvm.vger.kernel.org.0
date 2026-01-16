Return-Path: <kvm+bounces-68281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81056D29630
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 01:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9D455301AE2B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D7925C802;
	Fri, 16 Jan 2026 00:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EUt/Y0RB"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C396F1F7569
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 00:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768522308; cv=none; b=ociFHG+JyBU3cCxwhLvzujbfVkS1wYexYlCbkBVzDibInlTfWpdYMzJAVphkpbW6bxfVWdaRDeU/1Lr4zeAb+R9N8+h08CA/+kO/BmI9PIIxanRht9HlpkevmtkeArqwLz11p1Bz7HOrUcLakYCaWhx8krIyjharmuj6F9Z4DAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768522308; c=relaxed/simple;
	bh=bRFver7cZwOfGbTEV+GLcl+F1g/JUfrqd0EcO0RXlmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRy7UaEleoNpRXg921W47LVRQk60Yv148YWgxhp4OANPlIxWL+b8ufkUpVCuAMzYqyPJr3gL5bL0b7xEDh7a1HXHNeLgqqOqWlESjIw2+NLj5F0y6NR85Nw22L9W1TCot5D1dBbqjofebZwBlGHp20/oLhwQw3LXN9EabO9x/tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EUt/Y0RB; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 18:11:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768522305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IG4gRqy5ADtduPU+UPf2wn/Gu7P8xF+BnHKaNUzMK9Q=;
	b=EUt/Y0RBcgA2hf6Hv0+44iEYePjCDRGjTADjON3pQ2duQoNRE5F9GHtT4RPqTOXP7XBgVt
	oDrAGyIyxSVmJB5eP2oPE/od/aFHkyb2ODNi0+XwrCTXe2NiWdFClfM607EiAEV2T0PJHL
	UBVnq7MD5qlU7orx4VWFp+QOY/2ZQn8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
Message-ID: <mzcfz55dvg5vmu7wksumnsprk7brfdheqhpwpoys2ybj77ewyb@3byxfse5ieal>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
 <20260115223237.GA1087383@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115223237.GA1087383@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 15, 2026 at 10:32:37PM +0000, Joey Gouly wrote:
> On Thu, Jan 15, 2026 at 11:40:12AM -0600, Andrew Jones wrote:
> > On Wed, Jan 14, 2026 at 11:56:52AM +0000, Joey Gouly wrote:
> > > Hi all,
> > > 
> > > This series is for adding support to running the kvm-unit-tests at EL2.
> > > 
> > > Changes since v4[1]:
> > > 	- changed env var to support EL2=1,y,Y
> > > 	- replaced ifdef in selftest with test_exception_prep()
> > > 
> > > Thanks,
> > > Joey
> > > 
> > > [1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/
> > >
> > 
> > Hi Joey,
> > 
> > So this series doesn't appear to regress current tests, but it also
> > doesn't seem to completely work. I noticed these issues when running
> > with EL2=1 (there could be more):
> > 
> >  - timer test times out
> >  - all debug-bp fail
> >  - all watchpoint received tests fail for debug-wp
> >  - micro-bench hits the assert in gicv3_lpi_alloc_tables()
> >    lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?
> 
> Timer and micro-bench are unexpected, maybe regressed, I will investigate.
> 
> debug/watchpoint I knew about, would be good if we could skip those, and
> someone more knowledgeable about debug could figure out the issue there?

I'm OK with that. You'll want to not select those tests or any others that
fail in your .gitlab-ci.yml test to ensure it passes. I'm not sure where
the best place to document known issues are. Thoughts that come to mind:

 1. add code to the failing tests to skip when they detect EL2 mode
 2. add a new known-issues/TODO type of text file to the git repo that
    points out the issues
 3. open gitlib issues to https://gitlab.com/jones-drew/kvm-unit-tests.git

I think (1) is best since it won't be as easily overlooked and forgotten.
(2) is better than (3), but it's unlikely anybody would look at either...

Thanks,
drew

