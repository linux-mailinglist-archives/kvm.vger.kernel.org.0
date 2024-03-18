Return-Path: <kvm+bounces-12000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C0187EDEC
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D9D5B22DA2
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739285821B;
	Mon, 18 Mar 2024 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uvq+TOp2"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2085787B
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710780487; cv=none; b=t2ABSnHRHez7DeOrSlVSINzjErsQEugwkUM3WOLFlbBvafEZpc8PP2jqCx/G58m4HNsy9H2tBsi53znjLVu6Vha+fXJ5er7uj+CfEn43uno3DaWj7X432kcTGRCHZpFZCt8Ub7Ym42EUOLcILuIHTQKl0ERb340N6pCdAV8ieOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710780487; c=relaxed/simple;
	bh=byVLjBQ+PDKkjG98lJBvuTPI9sOWJC+KcaUGTHpUfw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tua+fz9JRp3gRkdQraIoBvoykBuCYyqeItVHOhc1zn20b4R8LNFa58774YrPxFw4L/TPY1fC85gF0twU/t233ujScG+gqFicyhtTOQVKtczVuGZwYGzKWmuCc4M0KS6pF5ooXPXYYZUyIu56+FXvaDf2d+z2PCn/wYmSvvyKO4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uvq+TOp2; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 18 Mar 2024 17:47:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710780482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dfWnUvJx9zSzTytX26V2scFE+BhFjwp/e/8ZZRBVnVk=;
	b=uvq+TOp2eTS3R0SZ2xSLxaoQVYzgCuUP3YVelBKPW+bNEuoO8V8vvX/kxJD0HTGNUY5FXN
	DWgu67/tTk3UfrJ0Zivp7gm03tXhrC+n9KpX62zKmX9huAfmEm1ex89dRVH2OfrxEwrT8g
	qtEJ+7vPiXNmjjtaiyT7E0rb1YJlIes=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	nikos.nikoleris@arm.com, shahuang@redhat.com, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 00/18] arm64: EFI improvements
Message-ID: <20240318-28422707d47001e973cc5a37@orel>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 05, 2024 at 05:46:24PM +0100, Andrew Jones wrote:
> This series collects one fix ("Update MAX_SMP probe") with a bunch of
> improvements to the EFI setup code and run script. With the series
> applied one can add --enable-efi-direct when configuring and then
> run the EFI tests on QEMU much, much faster by using direct kernel
> boot for them (and environment variables will work too). The non-
> direct (original) way of running the EFI tests has also been sped up
> a bit by not running the dummy test and not generating the dtb twice.
> The cleanups in the setup code allow duplicated code to be removed
> (by sharing with the non-EFI setup code) and eventually for riscv
> to share some code too with the introduction of memregions_efi_init().
> 
> v3:
>  - Dropped fdt_valid
>  - Factored out qemu_args+=(-machine acpi=off) [Nikos]
>  - Ensure etext is page aligned
>  - Picked up Nikos's r-b's
> 
> v2:
>  - Add another improvement (patches 15-17), which is to stop mapping
>    EFI regions which we consider reserved (including
>    EFI_BOOT_SERVICES_DATA regions which requires moving the primary stack)
>  - Add EFI gitlab CI tests
>  - Fix one typo in configure help text
> 
> 
> Andrew Jones (17):
>   runtime: Update MAX_SMP probe
>   runtime: Add yet another 'no kernel' error message
>   arm64: efi: Don't create dummy test
>   arm64: efi: Remove redundant dtb generation
>   arm64: efi: Move run code into a function
>   arm64: efi: Remove EFI_USE_DTB
>   arm64: efi: Improve device tree discovery
>   lib/efi: Add support for loading the initrd
>   arm64: efi: Allow running tests directly
>   arm/arm64: Factor out some initial setup
>   arm/arm64: Factor out allocator init from mem_init
>   arm64: Simplify efi_mem_init
>   arm64: Add memregions_efi_init
>   arm64: efi: Don't map reserved regions
>   arm64: efi: Fix _start returns from failed _relocate
>   arm64: efi: Switch to our own stack
>   arm64: efi: Add gitlab CI
> 
> Shaoqin Huang (1):
>   arm64: efi: Make running tests on EFI can be parallel
> 
>  .gitlab-ci.yml              |  32 ++++-
>  arm/efi/crt0-efi-aarch64.S  |  37 ++++--
>  arm/efi/elf_aarch64_efi.lds |   1 +
>  arm/efi/run                 |  64 ++++++----
>  arm/run                     |   6 +-
>  configure                   |  17 +++
>  lib/arm/mmu.c               |   6 +-
>  lib/arm/setup.c             | 227 ++++++++++++++----------------------
>  lib/efi.c                   |  84 +++++++++++--
>  lib/linux/efi.h             |  29 +++++
>  lib/memregions.c            |  53 +++++++++
>  lib/memregions.h            |   6 +
>  run_tests.sh                |   5 +-
>  scripts/runtime.bash        |  21 ++--
>  14 files changed, 389 insertions(+), 199 deletions(-)
> 
> -- 
> 2.44.0
>

Merged.

Thanks,
drew

