Return-Path: <kvm+bounces-35289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BD1A0B7B8
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 14:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EEF616589C
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 13:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9344230D3D;
	Mon, 13 Jan 2025 13:08:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DC318E361
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 13:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736773683; cv=none; b=DP0dC6UBRWJ/XXYYnBhKeeHC0UktePvlFZYNyKcbRo2rGlgP1dlJYS7sfjeeN9UvClXrdfvDMin1JgCddU4YXcJdDOWwBCu3CuDvdlT94jdL39adQ5o0DrwvPAvPrgMW40/mm50eaIEHg/oesQGRrdTw5UGLEo4c14qtiE0lBWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736773683; c=relaxed/simple;
	bh=R66NVMPghcnfZJx+J08oBtWuzclSmaBa4x6v2qtHMLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQPleykmrCGSZnZasomyMNvJiZZw/cF7Lro18W6pahKLUWYUnP1Bb6tzehh626J82s78+Z9rQKYqTsZ48QMphNCUGDmNpd+Q8+MLtFhCbdp7wSroAH/312B2KOivsq2KpX6QmdkkJvvQDJoBPCE5YouHenEwWXGJpV086fCsUuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2854F12FC;
	Mon, 13 Jan 2025 05:08:28 -0800 (PST)
Received: from arm.com (unknown [10.57.5.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4AEF3F673;
	Mon, 13 Jan 2025 05:07:57 -0800 (PST)
Date: Mon, 13 Jan 2025 13:07:53 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] Makefile: add portable mode
Message-ID: <Z4UQKTLWpVs5RNbA@arm.com>
References: <20250105175723.2887586-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250105175723.2887586-1-jon@nutanix.com>

Hi,

On Sun, Jan 05, 2025 at 10:57:23AM -0700, Jon Kohler wrote:
> Add a 'portable' mode that packages all relevant flat files and helper
> scripts into a tarball named 'kut-portable.tar.gz'.
> 
> This mode is useful for compiling tests on one machine and running them
> on another without needing to clone the entire repository. It allows
> the runner scripts and unit test configurations to remain local to the
> machine under test.

Have you tried make standalone? You can then copy the tests directory, or even a
particular test.

Thanks,
Alex

> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> 
> ---
>  .gitignore |  2 ++
>  Makefile   | 17 +++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 2168e013..643220f8 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -18,6 +18,8 @@ cscope.*
>  /lib/config.h
>  /config.mak
>  /*-run
> +/kut-portable
> +kut-portable.tar.gz
>  /msr.out
>  /tests
>  /build-head
> diff --git a/Makefile b/Makefile
> index 7471f728..c6333c1a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -125,6 +125,23 @@ all: directories $(shell (cd $(SRCDIR) && git rev-parse --verify --short=8 HEAD)
>  standalone: all
>  	@scripts/mkstandalone.sh
>  
> +portable: all
> +	rm -f kut-portable.tar.gz
> +	rm -rf kut-portable
> +	mkdir -p kut-portable/scripts/s390x
> +	mkdir -p kut-portable/$(TEST_DIR)
> +	cp build-head kut-portable
> +	cp errata.txt kut-portable
> +	cp config.mak kut-portable
> +	sed -i '/^ERRATATXT/cERRATATXT=errata.txt' kut-portable/config.mak
> +	cp run_tests.sh kut-portable
> +	cp -r scripts/* kut-portable/scripts
> +	cp $(TEST_DIR)-run kut-portable
> +	cp $(TEST_DIR)/*.flat kut-portable/$(TEST_DIR)
> +	cp $(TEST_DIR)/unittests.cfg kut-portable/$(TEST_DIR)
> +	cp $(TEST_DIR)/run kut-portable/$(TEST_DIR)
> +	tar -czf kut-portable.tar.gz kut-portable
> +
>  install: standalone
>  	mkdir -p $(DESTDIR)
>  	install tests/* $(DESTDIR)
> -- 
> 2.43.0
> 
> 

