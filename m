Return-Path: <kvm+bounces-41741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B839A6C895
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E35104654CF
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 09:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E461D89E3;
	Sat, 22 Mar 2025 09:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MEu+/iuX"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DBF78F3B
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 09:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742635104; cv=none; b=cjfYqRA1nRBK62NIJZ5GKvLyTo4Qh3CvvDX7M1Rtq7nEn5I6x/8LTn3twFPeL2DXc/bBV/NYaWrngNYHj0VclE3FIfXO3QXe/ZQHoVDYi1tmsFqcMvKhoLUE5CzT6f87/mqldNPIamoqsMumUvmprRsMGZQh1O35R6cCyKQTRYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742635104; c=relaxed/simple;
	bh=lHXBFWKS1hfYLTyBiLEYJk5JWUCMrcgZwfa6nufemxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehSHPxO3rXNcQmgMS3VQbI+NI3y+7OiXkRPZrSa619PGEYXnNsc6g2zARa25IfeeZ3uAN36i33YkBYdm5ceba67ZZqF6EfQ2f2z0njmmUYI4xF1b6KAdAPWcHV4noENdEtRnX2xlLNzoTBiPwngVE7Ss+VPKXAIN5W6N/sqKZ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MEu+/iuX; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 10:18:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742635099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A+0gDrg46cGQWiY41gGhhXJguy46XsWB3N4Gaf4MZEg=;
	b=MEu+/iuX+hLxudKDKwDDpJGGPL/FH6+6+HeIIHYuggTAczCucpJsKkZqGiTnTJ3kb2zsYS
	KYuJZ4lP5oWm2MbPMHJPzc/zGNovCb98ChunrfZy+2xFA2Qdftno+Br5RnZ4oMSdRG66tE
	8/uT8HWVbEce4HHoHW2oipvrmBVW9ds=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/3] riscv: Add Image header to flat
 binaries
Message-ID: <20250322-dc5bf69b7718ec682bc54780@orel>
References: <20241210044442.91736-1-samuel.holland@sifive.com>
 <20241210044442.91736-2-samuel.holland@sifive.com>
 <20241218-d2753dad681a37b3b15c7c75@orel>
 <dbb66354-b08d-49f6-82a4-840be58bddb1@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbb66354-b08d-49f6-82a4-840be58bddb1@sifive.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 18, 2024 at 05:06:09PM -0600, Samuel Holland wrote:
> Hi Drew,
> 
> On 2024-12-18 4:13 AM, Andrew Jones wrote:
> > On Mon, Dec 09, 2024 at 10:44:40PM -0600, Samuel Holland wrote:
> >> This allows flat binaries to be understood by U-Boot's booti command and
> >> its PXE boot flow.
> >>
> >> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> >> ---
> >>  riscv/cstart.S | 16 +++++++++++++++-
> >>  1 file changed, 15 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/riscv/cstart.S b/riscv/cstart.S
> >> index b7ee9b9c..106737a1 100644
> >> --- a/riscv/cstart.S
> >> +++ b/riscv/cstart.S
> >> @@ -39,15 +39,29 @@
> >>   * The hartid of the current core is in a0
> >>   * The address of the devicetree is in a1
> >>   *
> >> - * See Linux kernel doc Documentation/riscv/boot.rst
> >> + * See Linux kernel doc Documentation/arch/riscv/boot.rst and
> >> + * Documentation/arch/riscv/boot-image-header.rst
> >>   */
> >>  .global start
> >>  start:
> >> +	j	1f
> >> +	.balign	8
> >> +	.dword	0				// text offset
> > 
> > When I added a header like this for the bpi I needed the text offset to be
> > 0x200000, like Linux has it.  Did you do something to avoid that?
> 
> It turns out that U-Boot on my board is configured to ignore the first 0x200000
> bytes of DRAM entirely, so the binary ended up at the right address for the
> wrong reason. I can send a v2 with this field changed to 0x200000 (which also
> works on my board).

I made this change while applying to riscv/sbi

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

> 
> Regards,
> Samuel
> 
> >> +	.dword	stacktop - ImageBase		// image size
> >> +	.dword	0				// flags
> >> +	.word	(0 << 16 | 2 << 0)		// version
> >> +	.word	0				// res1
> >> +	.dword	0				// res2
> >> +	.ascii	"RISCV\0\0\0"			// magic
> >> +	.ascii	"RSC\x05"			// magic2
> >> +	.word	0				// res3
> >> +
> >>  	/*
> >>  	 * Stash the hartid in scratch and shift the dtb address into a0.
> >>  	 * thread_info_init() will later promote scratch to point at thread
> >>  	 * local storage.
> >>  	 */
> >> +1:
> >>  	csrw	CSR_SSCRATCH, a0
> >>  	mv	a0, a1
> >>  
> >> -- 
> >> 2.39.3 (Apple Git-146)
> >>
> > 
> > Thanks,
> > drew
> 

