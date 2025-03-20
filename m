Return-Path: <kvm+bounces-41571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC8FA6A87F
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C66F2484685
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3BF222580;
	Thu, 20 Mar 2025 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fofr0KGh"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C951FB3
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480811; cv=none; b=Rv3WOKn1gHyGIo9uilxhefyK/l1mM6kqDPYopgSS7RCKIpCTdG+ecVhPXvAu3k2a0nA4lOLflGVd3NMNIncdaUnacsTcHDAsALdTliBcDSQnQYCVspgrc998xwjYLk6LGtTxeNy9cwHwndceGP4APNcSA64w4msfGXzHt1hKHJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480811; c=relaxed/simple;
	bh=aohDWMzMhaZ5idaRC1xW4rrOQeaFTq3zqjXVQd4CiuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIJKocDcgmvS20il7JehOcV/zV9mgXgYe8aSqmHBIfIBaVXn9eDDAv4rPA9TgOkkySZUOy7yjUuwTtoQvwfXo1nliuB0s2EfD790qdBLigxHub3B/VMT30hq6ajaLbszwpFwe9+8ga0fy791L5dfh6zh9q4+jEzwEx3cnc+sfcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fofr0KGh; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Mar 2025 15:26:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742480807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c65I6kNtFA1k1VBOi7FptW6z8Ux97R+lY3N7yYJXjr0=;
	b=Fofr0KGhYTwvCgkbawgUoodEJwMObOfZexd2wzyBPsX31kX+3fiqN/XhtPw06/3sBypgai
	wxfdyo18EcRyBoxaOj9+zkv2z04octnXQRrTH4wSLg5++BYV82KRBET7u5AFA35OsHgXwH
	mKfclbatfx8wEVV7SXAEcE18nu5vQ5o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 0/8] riscv: add SBI SSE extension tests
Message-ID: <20250320-55d10bb6d1d91dbe7b15501a@orel>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 05:46:45PM +0100, Clément Léger wrote:
> This series adds tests for SBI SSE extension as well as needed
> infrastructure for SSE support. It also adds test specific asm-offsets
> generation to use custom OFFSET and DEFINE from the test directory.
> 
> These tests can be run using an OpenSBI version that implements latest
> specifications modification [1]
> 
> Link: https://github.com/rivosinc/opensbi/tree/dev/cleger/sse [1]

Applied to riscv/sbi with the fixups pointed out.

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

> 
> ---
> 
> V11:
>  - Use mask inside sbi_impl_opensbi_mk_version()
>  - Mask the SBI version with a new mask
>  - Use assert inside sbi_get_impl_id/version()
>  - Remove sbi_check_impl()
>  - Increase completion timeout as events failed completing under 1000
>    micros when system is loaded.
> 
> V10:
>  - Use && instead of || for timeout handling
>  - Add SBI patches which introduce function to get implementer ID and
>    version as well as implementer ID defines.
>  - Skip injection tests in OpenSBI < v1.6
> 
> V9:
>  - Use __ASSEMBLER__ instead of __ASSEMBLY__
>  - Remove extra spaces
>  - Use assert to check global event in
>    sse_global_event_set_current_hart()
>  - Tabulate SSE events names table
>  - Use sbi_sse_register() instead of sbi_sse_register_raw() in error
>    testing
>  - Move a report_pass() out of error path
>  - Rework all injection tests with better error handling
>  - Use an env var for sse event completion timeout
>  - Add timeout for some potentially infinite while() loops
> 
> V8:
>  - Short circuit current event tests if failure happens
>  - Remove SSE from all report strings
>  - Indent .prio field
>  - Add cpu_relax()/smp_rmb() where needed
>  - Add timeout for global event ENABLED state check
>  - Added BIT(32) aliases tests for attribute/event_id.
> 
> V7:
>  - Test ids/attributes/attributes count > 32 bits
>  - Rename all SSE function to sbi_sse_*
>  - Use event_id instead of event/evt
>  - Factorize read/write test
>  - Use virt_to_phys() for attributes read/write.
>  - Extensively use sbiret_report_error()
>  - Change check function return values to bool.
>  - Added assert for stack size to be below or equal to PAGE_SIZE
>  - Use en env variable for the maximum hart ID
>  - Check that individual read from attributes matches the multiple
>    attributes read.
>  - Added multiple attributes write at once
>  - Used READ_ONCE/WRITE_ONCE
>  - Inject all local event at once rather than looping fopr each core.
>  - Split test_arg for local_dispatch test so that all CPUs can run at
>    once.
>  - Move SSE entry and generic code to lib/riscv for other tests
>  - Fix unmask/mask state checking
> 
> V6:
>  - Add missing $(generated-file) dependencies for "-deps" objects
>  - Split SSE entry from sbi-asm.S to sse-asm.S and all SSE core functions
>    since it will be useful for other tests as well (dbltrp).
> 
> V5:
>  - Update event ranges based on latest spec
>  - Rename asm-offset-test.c to sbi-asm-offset.c
> 
> V4:
>  - Fix typo sbi_ext_ss_fid -> sbi_ext_sse_fid
>  - Add proper asm-offset generation for tests
>  - Move SSE specific file from lib/riscv to riscv/
> 
> V3:
>  - Add -deps variable for test specific dependencies
>  - Fix formatting errors/typo in sbi.h
>  - Add missing double trap event
>  - Alphabetize sbi-sse.c includes
>  - Fix a6 content after unmasking event
>  - Add SSE HART_MASK/UNMASK test
>  - Use mv instead of move
>  - move sbi_check_sse() definition in sbi.c
>  - Remove sbi_sse test from unitests.cfg
> 
> V2:
>  - Rebased on origin/master and integrate it into sbi.c tests
> 
> Clément Léger (8):
>   kbuild: Allow multiple asm-offsets file to be generated
>   riscv: Set .aux.o files as .PRECIOUS
>   riscv: Use asm-offsets to generate SBI_EXT_HSM values
>   lib: riscv: Add functions for version checking
>   lib: riscv: Add functions to get implementer ID and version
>   riscv: lib: Add SBI SSE extension definitions
>   lib: riscv: Add SBI SSE support
>   riscv: sbi: Add SSE extension tests
> 
>  scripts/asm-offsets.mak |   22 +-
>  riscv/Makefile          |    5 +-
>  lib/riscv/asm/csr.h     |    1 +
>  lib/riscv/asm/sbi.h     |  177 +++++-
>  lib/riscv/sbi-sse-asm.S |  102 ++++
>  lib/riscv/asm-offsets.c |    9 +
>  lib/riscv/sbi.c         |  105 +++-
>  riscv/sbi-tests.h       |    1 +
>  riscv/sbi-asm.S         |    6 +-
>  riscv/sbi-asm-offsets.c |   11 +
>  riscv/sbi-sse.c         | 1278 +++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c             |    2 +
>  riscv/.gitignore        |    1 +
>  13 files changed, 1707 insertions(+), 13 deletions(-)
>  create mode 100644 lib/riscv/sbi-sse-asm.S
>  create mode 100644 riscv/sbi-asm-offsets.c
>  create mode 100644 riscv/sbi-sse.c
>  create mode 100644 riscv/.gitignore
> 
> -- 
> 2.47.2
> 

