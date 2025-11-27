Return-Path: <kvm+bounces-64863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A9AC8DD16
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 11:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 27F6D34534E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 10:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EACF329E4F;
	Thu, 27 Nov 2025 10:41:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2315379DA
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 10:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764240069; cv=none; b=NUIoKA52JAjYdT7x2kKpnSEVoUQI9Un0jVHaQiB5PmHy+nazPL5gAjdyLGh2pGAVu3zHsLWuKk0GiGJCrQVlkVnFAToKPEHIZLX8xEWtK1IG9JSyPzp2PfFC7Ae87AqtW2kagKrRZPIImTLvn0MR5BSnMXOBX+IdFbr1UEj39Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764240069; c=relaxed/simple;
	bh=L8S7X2ILcrEGd7YmC0JEf3ASiZy8DsNlBWR/cTWH2ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+OyrVHo3BjRuhlAuMU5OA7ayZPN5XYiAVGgBQbhun791XBE+tUvjF5M01TJM3c7zkuGixQoUyaFyIk57CM8Jq1TC/wqz7QFLrtKm9Cy0CZmqiHOrweZ6ev7cY/hmsJXAwvRKkIiac++bSdlPArzkisGlo1QD76c3OyKQwR9ey4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 074D81477;
	Thu, 27 Nov 2025 02:40:59 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 313993F6A8;
	Thu, 27 Nov 2025 02:41:05 -0800 (PST)
Date: Thu, 27 Nov 2025 10:40:59 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 10/10] arm64: add EL2 environment
 variable
Message-ID: <20251127104059.GA3237269@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-11-joey.gouly@arm.com>
 <6e735f02-dbd6-4807-95b3-4043049d4557@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e735f02-dbd6-4807-95b3-4043049d4557@redhat.com>

On Thu, Nov 27, 2025 at 11:34:56AM +0100, Eric Auger wrote:
> Hi Joey,
> 
> On 9/25/25 4:19 PM, Joey Gouly wrote:
> > This variable when set to 1 will cause QEMU/kvmtool to start at EL2.
> 
> Misses the Sob.

If this counts:
Signed-off-by: Joey Gouly <joey.gouly@arm.com>

I have fixed kvm-unit-tests to add that automatically to my commits now, thanks.

> 
> Besides Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks,
Joey

> 
> Eric
> 
> > ---
> >  arm/run | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/arm/run b/arm/run
> > index 858333fc..2a9c0de0 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -59,6 +59,10 @@ function arch_run_qemu()
> >  		M+=",highmem=off"
> >  	fi
> >  
> > +	if [ "$EL2" = "1" ]; then
> > +		M+=",virtualization=on"
> > +	fi
> > +
> >  	if ! $qemu $M -device '?' | grep -q virtconsole; then
> >  		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> >  		exit 2
> > @@ -116,6 +120,9 @@ function arch_run_kvmtool()
> >  	fi
> >  
> >  	command="$(timeout_cmd) $kvmtool run"
> > +	if [ "$EL2" = "1" ]; then
> > +		command+=" --nested"
> > +	fi
> >  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
> >  		run_test_status $command --kernel "$@" --aarch32
> >  	else
> 

