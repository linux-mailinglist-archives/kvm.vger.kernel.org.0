Return-Path: <kvm+bounces-14591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E5CB8A3AA3
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 05:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA2B01F228D0
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 03:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA09818AEA;
	Sat, 13 Apr 2024 03:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KTL2Evxv"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CA21B285
	for <kvm@vger.kernel.org>; Sat, 13 Apr 2024 03:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712978580; cv=none; b=dVkDT2wNOnZtt/vrnGi9nukht3RLlO6nDmq5xLEacghtJlCAwdl3FbF43CDPeTdAzB4218o7YtuVVphU/xHoQYYlOo4mdHNnyTUBiCAElB0XKJrai6URfJuW9t/G+Jlfn/a/xGopQIkoHy8erQOWP0MHMQdJmaNT+YtHLBE6yiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712978580; c=relaxed/simple;
	bh=SCyDfC2Wmhsb4lLU3PzB0nKmdPQ0luzom0M5kYzTjIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqQznYj3RgT14AEAsYdGzbBxPrrMy4Xct/96OgWD+Is5Z4wRw9jxbfyJnqCLfYv+JW+++MilpALMTqOCCxPv2P1xsL2OceJDyrRSgHsfLSyTWd3m3BvqnR9yMYjVgRaPDecMDWG8Cz7F+4TertkJjIQhz/5hex1LpuP0XTWpaEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KTL2Evxv; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 11 Apr 2024 01:17:28 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712978575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oz320CoGCQmvXhdcOMPOAChCWDxikVcascNwYK/M4XM=;
	b=KTL2Evxvxfc5FCbFnPNAbGBqGjKrOD/UpfxiF0vY3RjeOdegk0lmRP6iVcemmXwvpIq6bh
	KfA16IHj8ExZ32rr2bMkDgYePCl7QC4Jbml8F0amHHdu5/XG6GRdFlvg6sXPQTSR8NLHMv
	b/FGAYuulDfNYLfsN/jt0jtWOFb6BzQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com,
	james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com,
	andrew.jones@linux.dev, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 00/33] Support for Arm Confidential
 Compute Architecture
Message-ID: <Zha7mFYTPJk34+cO@vm3>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Suzuki,

On Fri, Apr 12, 2024 at 11:33:35AM +0100, Suzuki K Poulose wrote:
> This series adds support for running the kvm-unit-tests in the Arm CCA reference
> software architecture.
> 
> 
> The changes involve enlightening the boot/setup code with the Realm Service Interface
> (RSI). The series also includes new test cases that exercise the RSI calls.
> 
> Currently we only support "kvmtool" as the VMM for running Realms. There was
> an attempt to add support for running the test scripts using with kvmtool here [1],
> which hasn't progressed. It would be good to have that resolved, so that we can
> run all the tests without manually specifying the commandlines for each run.
> 
> For the purposes of running the Realm specific tests, we have added a "temporary"
> script "run-realm-tests" until the kvmtool support is added. We do not expect
> this to be merged.
> 
> 
> Base Realm Support
> -------------------
> 
> Realm IPA Space
> ---------------
> When running on in Realm world, the (Guest) Physical Address - aka Intermediate
> Physical Address (IPA) in Arm terminology - space of the VM is split into two halves,
> protected (lower half) and un-protected (upper half). A protected IPA will
> always map pages in the "realm world" and  the contents are not accessible to
> the host. An unprotected IPA on the other hand can be mapped to page in the
> "normal world" and thus shared with the host. All host emulated MMIO ranges must
> be in unprotected IPA space.
> 
> Realm can query the Realm Management Monitor for the configuration via RSI call
> (RSI_REALM_CONFIG) and identify the "boundary" of the "IPA" split.
> 
> As far as the hyp/VMM is concerned, there is only one "IPA space" (the lower
> half) of memory map. The "upper half" is "unprotected alias" of the memory map.
> 
> In the guest, this is achieved by "treating the MSB (1 << (IPA_WIDTH - 1))" as
> a protection attribute (we call it - PTE_NS_SHARED), where the Realm applies this
> to any address, it thinks is acccessed/managed by host (e.g., MMIO, shared pages).
> Given that this is runtime variable (but fixed for a given Realm), uses a
> variable to track the value.
> 
> All I/O regions are marked as "shared". Care is taken to ensure I/O access (uart)
> with MMU off uses the "Unprotected Physical address".
> 
> 
> Realm IPA State
> ---------------
> Additionally, each page (4K) in the protected IPA space has a state associated
> (Realm IPA State - RIPAS) with it. It is either of :
>    RIPAS_EMPTY
>    RIPAS_RAM
> 
> Any IPA backed by RAM, must be marked as RIPAS_RAM before an access is made to
> it. The hypervisor/VMM does this for the initial image loaded into the Realm
> memory before the Realm starts execution. Given the kvm-unit-test flat files do
> not contain a metadata header (e.g., like the arm64 Linux kernel Image),
> indicating the "actual image size in memory", the VMM cannot transition the
> area towards the end of the image (e.g., bss, stack) which are accessed very
> early during boot. Thus the early boot assembly code will mark the area upto
> the stack as RAM.
> 
> Once we land in the C code, we mark target relocation area for FDT and
> initrd as RIPAS_RAM. At this point, we can scan the FDT and mark all RAM memory
> blocks as RIPAS_RAM.
> 
> TODO: It would be good to add an image header to the flat files indicating the
> size, which can take the burden off doing the early assembly boot code RSI calls.
> 
> Shared Memory support
> ---------------------
> Given the "default" memory of a VM is not accessible to host, we add new page
> alloc/free routines for "memory shared" with the host. e.g., GICv3-ITS must use
> shared pages for ITS emulation.
> 
> RSI Test suites
> --------------
> There are new testcases added to exercise the RSI interfaces and the RMM flows.
> 
> Attestation and measurement services related RSI tests require parsing tokens
> and claims returned by the RMM. This is achieved with the help of QCBOR library
> [2], which is added as a submodule to the project. We have also added a wrapper
> library - libtokenverifier - around the QCBOR to parse the tokens according to
> the RMM specifications.
> 
> Running Arm CCA Stack
> -------------------
> 
> See more details on Arm CCA and how to build/run the entire stack here[0]
> The easiest way to run the Arm CCA stack is using shrinkwrap and the details
> are available in [0].
> 
> 
> The patches are also available here :
> 
>  https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v1
> 
> 
> Changes since rfc:
>   [ https://lkml.kernel.org/r/20230127114108.10025-1-joey.gouly@arm.com ]
>   - Add support for RMM-v1.0-EAC5, changes to RSI ABIs
>   - Some hardening checks (FDT overlapping the BSS sections)
>   - Selftest for memory stress
>   - Enable PMU/SVE tests for Realms
> 
>  [0] https://lkml.kernel.org/r/20240412084056.1733704-1-steven.price@arm.com
>  [1] https://lkml.kernel.org/r/20210702163122.96110-1-alexandru.elisei@arm.com
>  [2] https://github.com/laurencelundblade/QCBOR
> 
> Alexandru Elisei (3):
>   arm64: Expand SMCCC arguments and return values
>   arm: selftest: realm: skip pabt test when running in a realm
>   NOT-FOR-MERGING: add run-realm-tests
> 
> Djordje Kovacevic (1):
>   arm: realm: Add tests for in realm SEA
> 
> Gareth Stockwell (1):
>   arm: realm: add hvc and RSI_HOST_CALL tests
> 
> Jean-Philippe Brucker (1):
>   arm: Move io_init after vm initialization
> 
> Joey Gouly (10):
>   arm: Make physical address mask dynamic
>   arm64: Introduce NS_SHARED PTE attribute
>   arm: realm: Add RSI interface header
>   arm: realm: Make uart available before MMU is enabled
>   arm: realm: Add RSI version test
>   arm64: add ESR_ELx EC.SVE
>   arm64: enable SVE at startup
>   arm64: selftest: add realm SVE VL test
>   lib/alloc_page: Add shared page allocation support
>   arm: Add memtest support
> 
> Mate Toth-Pal (2):
>   arm: Add a library to verify tokens using the QCBOR library
>   arm: realm: Add Realm attestation tests
> 
> Subhasish Ghosh (1):
>   arm: realm: Add test for FPU/SIMD context save/restore
> 
> Suzuki K Poulose (14):
>   arm: Add necessary header files in asm/pgtable.h
>   arm: Detect FDT overlap with uninitialised data
>   arm: realm: Realm initialisation
>   arm: realm: Add support for changing the state of memory
>   arm: realm: Set RIPAS state for RAM
>   arm: realm: Early memory setup
>   arm: gic-v3-its: Use shared pages wherever needed
>   arm: realm: Enable memory encryption
>   qcbor: Add QCBOR as a submodule
>   arm: Add build steps for QCBOR library
>   arm: realm: add RSI interface for attestation measurements
>   arm: realm: Add helpers to decode RSI return codes
>   arm: realm: Add Realm attestation tests
>   arm: realm: Add a test for shared memory
> 
>  .gitmodules                         |    3 +
>  arm/Makefile.arm64                  |   25 +-
>  arm/cstart.S                        |   49 +-
>  arm/cstart64.S                      |  154 +++-
>  arm/fpu.c                           |  424 +++++++++
>  arm/realm-attest.c                  | 1251 +++++++++++++++++++++++++++
>  arm/realm-ns-memory.c               |   86 ++
>  arm/realm-rsi.c                     |  159 ++++
>  arm/realm-sea.c                     |  143 +++
>  arm/run-realm-tests                 |  112 +++
>  arm/selftest.c                      |  138 ++-
>  arm/unittests.cfg                   |   96 +-
>  lib/alloc_page.c                    |   20 +-
>  lib/alloc_page.h                    |   24 +
>  lib/arm/asm/arm-smccc.h             |   44 +
>  lib/arm/asm/io.h                    |    6 +
>  lib/arm/asm/pgtable.h               |    9 +
>  lib/arm/asm/psci.h                  |   13 +-
>  lib/arm/asm/rsi.h                   |   21 +
>  lib/arm/asm/sve-vl-test.h           |    9 +
>  lib/arm/gic-v3.c                    |    6 +-
>  lib/arm/io.c                        |   24 +-
>  lib/arm/mmu.c                       |   80 +-
>  lib/arm/psci.c                      |   19 +-
>  lib/arm/setup.c                     |   26 +-
>  lib/arm64/asm/arm-smccc.h           |    6 +
>  lib/arm64/asm/esr.h                 |    1 +
>  lib/arm64/asm/io.h                  |    6 +
>  lib/arm64/asm/pgtable-hwdef.h       |    6 -
>  lib/arm64/asm/pgtable.h             |   20 +
>  lib/arm64/asm/processor.h           |   34 +
>  lib/arm64/asm/rsi.h                 |   89 ++
>  lib/arm64/asm/smc-rsi.h             |  173 ++++
>  lib/arm64/asm/sve-vl-test.h         |   28 +
>  lib/arm64/asm/sysreg.h              |    7 +
>  lib/arm64/gic-v3-its.c              |    6 +-
>  lib/arm64/processor.c               |    1 +
>  lib/arm64/rsi.c                     |  188 ++++
>  lib/asm-generic/io.h                |   12 +
>  lib/libcflat.h                      |    1 +
>  lib/qcbor                           |    1 +
>  lib/token_verifier/attest_defines.h |   50 ++
>  lib/token_verifier/token_dumper.c   |  157 ++++
>  lib/token_verifier/token_dumper.h   |   15 +
>  lib/token_verifier/token_verifier.c |  591 +++++++++++++
>  lib/token_verifier/token_verifier.h |   77 ++
>  46 files changed, 4355 insertions(+), 55 deletions(-)
>  create mode 100644 .gitmodules
>  create mode 100644 arm/fpu.c
>  create mode 100644 arm/realm-attest.c
>  create mode 100644 arm/realm-ns-memory.c
>  create mode 100644 arm/realm-rsi.c
>  create mode 100644 arm/realm-sea.c
>  create mode 100755 arm/run-realm-tests
>  create mode 100644 lib/arm/asm/arm-smccc.h
>  create mode 100644 lib/arm/asm/rsi.h
>  create mode 100644 lib/arm/asm/sve-vl-test.h
>  create mode 100644 lib/arm64/asm/arm-smccc.h
>  create mode 100644 lib/arm64/asm/rsi.h
>  create mode 100644 lib/arm64/asm/smc-rsi.h
>  create mode 100644 lib/arm64/asm/sve-vl-test.h
>  create mode 100644 lib/arm64/rsi.c
>  create mode 160000 lib/qcbor
>  create mode 100644 lib/token_verifier/attest_defines.h
>  create mode 100644 lib/token_verifier/token_dumper.c
>  create mode 100644 lib/token_verifier/token_dumper.h
>  create mode 100644 lib/token_verifier/token_verifier.c
>  create mode 100644 lib/token_verifier/token_verifier.h

Thanks for the update! I'll go through the series one by one in the
coming weeks. Just curious one thing - do you guys wish to add Realm tests to the kvm-unit-test package, but not to kselftests?

Thanks,
Itaru.

> 
> -- 
> 2.34.1
> 

