Return-Path: <kvm+bounces-27613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BF819882EC
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 12:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BD941C21956
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 10:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD54189B88;
	Fri, 27 Sep 2024 10:59:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040FA188732
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 10:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727434757; cv=none; b=XfF9I7aM19t878vM2mkTACZYillPATTMOqAJWV8jB0UmgCPbI0jlo1DwDvUJyEbcg5gKvNSHn9DR1p4GQWYIicngrIlbO0x8PcodEg54H8znGH9hz0S+v7KA0NOrz9IvtD4N9eVI55kby7ORYvwKYYbAOuf5QMOh4Y33XBhmRI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727434757; c=relaxed/simple;
	bh=EU4pxLS8rUHNF48vnD3s6Ce9WpwsDE4z/ta7DcmWlG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3HTAc8PZS341gfCSxa1ZQIP1fWOmJDnbhxxDqrzswOoEVG670XHw5OuoRj8ouK19ORbIXb+nQApTKV4GodvphER/aQ1IvLoweD4dNy8Pig969xTFQiMol4ucUqWTatq+3hZJq/xrZZ9xtNPGt0a1nmjLl33HGfPtwPDrb1ueho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 837A41474;
	Fri, 27 Sep 2024 03:59:43 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D78E73F587;
	Fri, 27 Sep 2024 03:59:12 -0700 (PDT)
Date: Fri, 27 Sep 2024 11:59:07 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Another reviewer reshuffle
Message-ID: <20240927105907.GA814573@e124191.cambridge.arm.com>
References: <20240927104956.1223658-1-maz@kernel.org>
 <ZvaOiuvmZNq__ivV@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvaOiuvmZNq__ivV@linux.dev>

On Fri, Sep 27, 2024 at 12:52:58PM +0200, Oliver Upton wrote:
> On Fri, Sep 27, 2024 at 11:49:56AM +0100, Marc Zyngier wrote:
> > It has been a while since James had any significant bandwidth to
> > review KVM/arm64 patches. But in the meantime, Joey has stepped up
> > and did a really good job reviewing some terrifying patch series.
> > 
> > Having talked with the interested parties, it appears that James
> > is unlikely to have time for KVM in the near future, and that Joey
> > is willing to take more responsibilities.
> > 
> > So let's appoint Joey as an official reviewer, and give James some
> > breathing space, as well as my personal thanks. I'm sure he will
> > be back one way or another!
> 
> Yes, thank you James for everything, I'm sure we'll still be seeing you
> around ;-)
> 
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Joey Gouly <joey.gouly@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Zenghui Yu <yuzenghui@huawei.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Welcome to the party, Joey!

Thanks!

Acked-by: Joey Gouly <joey.gouly@arm.com>

> 
> Acked-by: Oliver Upton <oliver.upton@linux.dev>
> 
> -- 
> Thanks,
> Oliver

