Return-Path: <kvm+bounces-63723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5662FC6F27C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 15:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 812B2347400
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9B33446CB;
	Wed, 19 Nov 2025 14:02:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051F522A4E1
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763560953; cv=none; b=NPJHi2+f4rnewe/oNDpKWjBtHQtlhNCHKocL20UAUF/GfIEQidT9J71EvSwDZ1ZatGicJeThbl9ANBLphTC0SKJUYVH1fg7Pwe1u5ZoyZNXlDFCCm4utVZ/TPEcjzhUdsERFPfwRD+hmpKrv2CtKQrAI1eSjOwwT0iauNvnnrY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763560953; c=relaxed/simple;
	bh=sg5LnIhCKa/ybP8CAZ8E6GUF+XN1BhXl1pPxNHV+a6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XsSF2h79Pk1H/iSfLByfXWBz+W00gTYydgGN4LKdB613/0Gp4dWVe9mOqRDHZjZw257Cj4tmaVf5+7HWhydo5Y+iFuxVNj6SdairvtQAOyWn3eI7DR3JH2RF490L1ZIe4nALl0RBhUl4oD0dq+lp+zLX0BUDf2CFYox6nkeXiO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC00DFEC;
	Wed, 19 Nov 2025 06:02:23 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A5433F740;
	Wed, 19 Nov 2025 06:02:29 -0800 (PST)
Date: Wed, 19 Nov 2025 14:02:24 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251119140224.GA2210783@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20251119131827.GA2206028@e124191.cambridge.arm.com>
 <D63D4CE9-431B-4F76-B769-C4FFB37B76AF@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D63D4CE9-431B-4F76-B769-C4FFB37B76AF@gmail.com>

Hi Nadav,

On Wed, Nov 19, 2025 at 03:48:13PM +0200, Nadav Amit wrote:
> 
> 
> > On 19 Nov 2025, at 15:18, Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Thu, Sep 25, 2025 at 03:19:48PM +0100, Joey Gouly wrote:
> >> Hi all,
> >> 
> >> This series is for adding support to running the kvm-unit-tests at EL2. These
> >> have been tested with Linux 6.17-rc6 KVM nested virt.
> >> 
> >> This latest round I also tested using the run_tests.sh script with QEMU TCG,
> >> running at EL2.
> >> 
> >> The goal is to later extend and add new tests for Nested Virtualisation,
> >> however they should also work with bare metal as well.
> > 
> > Any comments on this series, would be nice to get it merged.
> 
> I wonder, does kvm-unit-tests run on bare-metal arm64 these days?
> 
> I ran it in-house some time ago (fixing several issues on the way),
> but IIRC this issue was never fixed upstream:
> 
> https://lore.kernel.org/all/C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com/
> 

I haven't tested on real bare-metal hardware, I have been booting directly in
QEMU with both .flat and .efi.


Thanks,
Joey

