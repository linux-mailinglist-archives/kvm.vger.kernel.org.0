Return-Path: <kvm+bounces-41511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE31A69768
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 027794811AD
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F9A20AF69;
	Wed, 19 Mar 2025 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ThXiZDXk"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F661DFD98
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 18:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742407300; cv=none; b=jCsYO1Q3FXnttegpjC1VZW935u+W/po2UwmY80cSf0t3wQV6PS5Mt2l1UKBx49Lcl/4G1ke/6UknpTttdY8QCE/dCQMmvzrR9eos7pXbtevKtKN3/3W4lzsBTrVXQaC1Dvs6bflUDrc/7N7K9nicjvLB4oXPtm+/LAYTqUsYfqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742407300; c=relaxed/simple;
	bh=ozrsp8lQbU75KXAdu3yGzkQ4vlD+a7yW9bwEsScQpvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQP8KSMxChuW1PsuoxqlGnpl9XtSev5FNaLuar6qRth2nlAbgZyHeOwLHtmGhzk2DxMBUrWJzX7Cq2sXyhPzwsN9gDseTsd+3sIiPOCo2xBcxujX2aj0zb5vxXqjbr06xtyAXbAjmxxlxjg6bGzuFGPpUfHo7nwGkAE+CeU5d7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ThXiZDXk; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Mar 2025 19:01:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742407295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3cPypWvZWL+yCXURrCTAIOf/TsaF6PV1P+aYAM5N5BE=;
	b=ThXiZDXkqAT7qVn0ArUMnVWq9STNeHk8SlqWGgaW8qY+YwCeGyStzsl0tskCE3irgAF0on
	d1O1tbtGallmMhI1wey6XjsR5w1q0c6k8VXfvI/cj1Vv0oMLotAGFJG9StoFtg7y6RJjxh
	4yjFM6CRkrTBmDt1UOR+KADNO++0MiA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 0/8] riscv: add SBI SSE extension tests
Message-ID: <20250319-ff9d4b4904195050638f77f1@orel>
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

Hi Clément,

I'd like to merge this, but we still have 50 failures with the latest
opensbi and over 30 with the opensbi QEMU provides. Testing with [1]
and bumping the timeout to 6000 allowed me to avoid failures, however
we can't count on that for CI.

[1] https://lists.infradead.org/pipermail/opensbi/2025-March/008190.html

I'm thinking about just doing the following. What do you think?

Thanks,
drew

diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
index a31c84c32303..fb4ee7dd44b2 100644
--- a/riscv/sbi-sse.c
+++ b/riscv/sbi-sse.c
@@ -1217,7 +1217,6 @@ void check_sse(void)
 {
        struct sse_event_info *info;
        unsigned long i, event_id;
-       bool sbi_skip_inject = false;
        bool supported;

        report_prefix_push("sse");
@@ -1228,6 +1227,13 @@ void check_sse(void)
                return;
        }

+       if (sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
+           sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7)) {
+               report_skip("OpenSBI < v1.7 detected, skipping tests");
+               report_prefix_pop();
+               return;
+       }
+
        sse_check_mask();

        /*
@@ -1237,18 +1243,6 @@ void check_sse(void)
         */
        on_cpus(sse_secondary_boot_and_unmask, NULL);

-       /* Check for OpenSBI to support injection */
-       if (sbi_get_imp_id() == SBI_IMPL_OPENSBI) {
-               if (sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 6)) {
-                       /*
-                        * OpenSBI < v1.6 crashes kvm-unit-tests upon injection since injection
-                        * arguments (a6/a7) were reversed. Skip injection tests.
-                        */
-                       report_skip("OpenSBI < v1.6 detected, skipping injection tests");
-                       sbi_skip_inject = true;
-               }
-       }
-
        sse_test_invalid_event_id();

        for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
@@ -1265,14 +1259,12 @@ void check_sse(void)
                sse_test_attrs(event_id);
                sse_test_register_error(event_id);

-               if (!sbi_skip_inject)
-                       run_inject_test(info);
+               run_inject_test(info);

                report_prefix_pop();
        }

-       if (!sbi_skip_inject)
-               sse_test_injection_priority();
+       sse_test_injection_priority();

        report_prefix_pop();
 }

On Mon, Mar 17, 2025 at 05:46:45PM +0100, Clément Léger wrote:
> This series adds tests for SBI SSE extension as well as needed
> infrastructure for SSE support. It also adds test specific asm-offsets
> generation to use custom OFFSET and DEFINE from the test directory.
> 
> These tests can be run using an OpenSBI version that implements latest
> specifications modification [1]
> 
> Link: https://github.com/rivosinc/opensbi/tree/dev/cleger/sse [1]
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

