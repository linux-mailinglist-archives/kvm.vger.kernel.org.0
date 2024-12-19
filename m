Return-Path: <kvm+bounces-34125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 798D49F773C
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65C5B188E5D9
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA84A21D008;
	Thu, 19 Dec 2024 08:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tC43fJUH"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037C218ADB
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 08:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596853; cv=none; b=VW6Ih0VQIxIrYfuKxpQSWN+oeh2hHmLQioTlCNrpRi5MadSPV+amFFDVIwcx33cIRNG+0O53XeFf2j/p30aZhhIr/J1bPUD/ke4nWWOz+bNY2O8RJH4xSOqUrTEryWiiKT7NBnthaB1WD1MYu5I5q5EhdPfakB4L8kwksAzXuEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596853; c=relaxed/simple;
	bh=9Kg0EpyGbNWmbLXzmSnkWZzB/4WEIkUM06TEMZ3mse0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvKY0UHWgGcyKnTIxT4DZkfeJTwPn/oDwCf3pLo4yRxYVa/JbLkJJhUAXb9shiv+zp+htYa6+ltib4oJ/AQchIgzfr4JiB2Y0KV6M7y8EgzJ9Mdls8QSW9+/3o3izjXV7OxEXZXYDo27oRf/2IgQGWmGe1Je5/3CHx8zXt6skzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tC43fJUH; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 19 Dec 2024 09:27:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734596847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d71FDRw7sb/hwKp15A9H9JDZgsrFxTPnUW1N4IE71dk=;
	b=tC43fJUHnDsdTf6dJqeyuQ5ch84/FltV77h05CNCWBgyMRDZT2NkzfzILlYLJ6V38yTppx
	/e6yYd55o7CzYbt+VtY77vIWICDaqN/+n/utdACJci/lMr8PoxD6mtlIk/u8PGEDIgmPxC
	Z2dnWQd2j78JrPf6/DkiKjRPK9hympc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/3] riscv: Add Image header to flat
 binaries
Message-ID: <20241219-d78dcb3804da755f52c2a8a3@orel>
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

Sounds good.

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

