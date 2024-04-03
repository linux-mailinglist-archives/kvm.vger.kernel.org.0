Return-Path: <kvm+bounces-13455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF2D896E33
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 13:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5239CB2743A
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 11:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D0D1420A5;
	Wed,  3 Apr 2024 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NE9BrmwE"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6463A1419BA
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 11:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712143639; cv=none; b=Mu6FjhDl1m/7Fbdc2/qpyvF7gu40tXH8Lp8284GZ2wvWS/pfcBwi20i9DbORjZG7kZjwBsxvDURR78lqOHP7YEmFr2cXuDGbUI07jVEc1qckkpEvr9RT5IhT0bpSib/acZTgVXoVgPIOvYye9fLhUlScUI5GGR5s+UrbQfBalqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712143639; c=relaxed/simple;
	bh=fK8Zou6245WkZyloKjOMfjVxgltMe+Unq8LJfbbOLtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMl1wKSGOJJr1GE/EZ6RlrP3+jvc+8/OnFYfGDuz0YB7bOMtdgmb+ufBIL2Aa576f5hyJcnaFDKERR6+P1or49aATfRvZleNTreNDxB8nQCgQsQLa7KEO0UstNSppEyYTXuOWyDkbZg5NqiDHdmOzi3JMmQqGs27NmUoOO2Qz6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NE9BrmwE; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 3 Apr 2024 13:27:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712143634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/sfkj1/tVlvo9huvXW4HBkRsP5hTdEiN/a9TD3eFR48=;
	b=NE9BrmwEH9GT1cxXLtPh0n/llUKh2/g5Bk4OA1894SZ4UM5Ba1Txo38AvB3e3ebYs/Ysa8
	TlB/fxq3YJxOH/bdLv/GenaJ/blaTgy3W1jSt/QzaIiSvZFVeXvepu8abuZg0KBO5M/r5t
	aHikYljJJBk4PjkZ+b5IoTCW1XP7LJU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Pavan Kumar Paluri <papaluri@amd.com>
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [kvm-unit-tests PATCH v4 0/2] UEFI Improvements
Message-ID: <20240403-e1c5baaf0963235f15bfaad2@orel>
References: <20240329131522.806983-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329131522.806983-1-papaluri@amd.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 29, 2024 at 08:15:20AM -0500, Pavan Kumar Paluri wrote:
> Patch-1: Introduces a fix for x86 arch which is ACPI-based to not get
> 	 into the path of fdt.
> 
> Patch-2: KUT UEFI-based guest may sometimes fail to exit boot services
> 	 due to a possible memory map update that might have taken place
> 	 between efi_get_memory_map() call and efi_exit_boot_services()
> 	call. As per UEFI specification (2.10), we need to try and keep
> 	updating the memory map as long as we get Invalid key failure.
> 
> =========
> Changelog
> =========
> v3 -> v4:
>     * Dropped patches 3 & 4 from the series as they are not relevant to 
>       UEFI improvements introduced in this patchset. This would aid in 
>       easier review and upstreaming.
>     * Addressed feedback (Andrew)
>     * Included R-b tag from Andrew Jones.
> 
> v2 -> v3:
>     * Included R-b tag from Andrew for Patch-1.
>     * Updated patch-2 to not leak memory map information during 
>       re-trials to efi_get_memory_map().
> 
> v1 -> v2:
>     * Incorporated feedback (Andrew, Mike, Tom)
>     * Updated patch-2 to keep trying to update memory map and calls to 
>       exit boot services as long as there is a failure.
>     * Split Page allocation and GHCB page attributes patch into two 
>       patches.
>  
> Pavan Kumar Paluri (2):
>   x86 EFI: Bypass call to fdt_check_header()
>   x86/efi: Retry call to efi exit boot services
> 
>  lib/efi.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> -- 
> 2.34.1
>

Merged.

Thanks,
drew

