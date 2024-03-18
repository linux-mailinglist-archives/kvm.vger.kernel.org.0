Return-Path: <kvm+bounces-12008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 697A387EECA
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 18:28:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A249A1C220B0
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73AD5578A;
	Mon, 18 Mar 2024 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t7lwWS/X"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F255555776
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710782906; cv=none; b=KpzYUmljteMWsqMgeQAcoKV+AaiY6VPPnOIyPrM4vugrvA4jUnmP4RanL4vL7rSzlEhsisjw0Ft/U8vW+Ij7BjSmeTy8xR5R7XDcsZEjf6p9zArAzcnAJ1dedGAtzU0PgQc7aBa0oMDlzPtTnSswfFk8Q2v5cZsckKL+L3whiUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710782906; c=relaxed/simple;
	bh=jUx0Y2Yfj+JLIu3V0IDmehz7eefD8mR6aD29KhGjCWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdGp2vcrYsN2fwu2wiQi0WU15zmtyaSnOyqT2prn7r1AU4Uz2f9LJ/TKAwev3f3XLbnWFh6Hlx0QKBF2KDHlBl1Ge36kmek5fG+tXm1CILAq1uXxS9AmepHCSBqabGieiVifGEC0oGiXcIVf0MOaZeMSPSM5V3MQeDMUDxO+ubM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t7lwWS/X; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 18 Mar 2024 18:28:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710782902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aE3Cdm27gQAq1L4DD0ngQ5QDE6ThfIThCpJFqNgswlQ=;
	b=t7lwWS/XeIYUejYKTEJuOXHDNP8ALJ1UTcO88h98EO5embfxMUZhnYjKGq9VkPrDQTXsLy
	1Mks1TCmLwZycGP8XZQiFST9m1KUR2/QVKbLFX3PSsdo9D8/yZOuVOA5+Kag/7yFGB/j62
	SnkAPYXR9B5FzNbPxANtC2DukiZx2GQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 00/13] Enable EFI support
Message-ID: <20240318-3fd0fb4ca9e43c2fe5e20ccb@orel>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 05, 2024 at 06:08:59PM +0100, Andrew Jones wrote:
> This series starts with some fixes for backtraces for bugs found
> when tracing with riscv EFI builds. The series then brings EFI
> support to riscv, basing the approach heavily on arm64's support
> (including arm64's improvements[1]). It should now be possible
> to launch tests from EFI-capable bootloaders.
> 
> [1] https://lore.kernel.org/all/20240305164623.379149-20-andrew.jones@linux.dev/
> 
> v2:
>  - Rebase on v3 of arm's efi improvement series
>  - Just make base_address a weak function rather than duplicate it
>  - Always preserve .so files (they're useful for debug)
>  - Build the sieve test for EFI
>  - Pick up a couple tags
> 
> Thanks,
> drew
> 
> Andrew Jones (13):
>   riscv: Call abort instead of assert on unhandled exceptions
>   riscv: show_regs: Prepare for EFI images
>   treewide: lib/stack: Fix backtrace
>   treewide: lib/stack: Make base_address arch specific
>   riscv: Import gnu-efi files
>   riscv: Tweak the gnu-efi imported code
>   riscv: Enable building for EFI
>   riscv: efi: Switch stack in _start
>   efi: Add support for obtaining the boot hartid
>   riscv: Refactor setup code
>   riscv: Enable EFI boot
>   riscv: efi: Add run script
>   riscv: efi: Use efi-direct by default
>

Merged.

Thanks,
drew

