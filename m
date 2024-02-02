Return-Path: <kvm+bounces-7852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C55D8471DC
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:25:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAC6FB2AA87
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 14:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76881145335;
	Fri,  2 Feb 2024 14:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A2e5ZvIR"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0EF145332
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 14:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706883784; cv=none; b=Z79Szm5Vhe4Xyk22ZqqaAvnyKMegpgezHkj9Y9+ak9bNsxcTHgPOXqcy7foeVkW2gEPBJEO0Vy31Wjd00GM8WIWjdcrOrQIt4y6YI34xUTMyh2Oqg7YjNQYtMGHnFchtxOJAVRBzfIZGCZyzqdgy1zmTlCFIeIBRHMvhpu3jtr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706883784; c=relaxed/simple;
	bh=o/CxHtMHct/p3/M0YDsOR5zVnB7CaoXvuoPYTaQMFRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSgz5jcpo4yG7ljWZLESp3Np4TIOeizkESTYFeKknSiOKSJZWnIfO0SY7+z/2/7Me68H+cI1m9vrP1tiLScB5+x58ZFhRBz9d836mhm5llU3F4OIImz85nNOpanApz/0JnIXxDihtQ762u8IjYTRo2Np7IOJIf26LpNTmWWeToI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A2e5ZvIR; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Feb 2024 15:22:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706883779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Px3nMvWeSyv0f0LL38am1XpF0fc9FEreGCFoqZZHAWA=;
	b=A2e5ZvIRMa3Jgm1MQ6a6p5EkNAsG2SO7pbmklcr8ERAK4ghBTrWUPzNQvVYfuSGovz/JyS
	XaqBPF0TxkgweVDbxzY0cDI7HMTs4xj3jUOJfqLFU1daX5LyYglYGFMPot+cb2jcueNu/P
	O2HyPZ1COXKxaOW2wMevhX5EPpeZJ8k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com, 
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 00/24] Introduce RISC-V
Message-ID: <20240202-af0abddd2969c13006cbbe1a@orel>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 26, 2024 at 03:23:25PM +0100, Andrew Jones wrote:
> v2:
>  - While basing [1] on this series I found two bugs (one in exception
>    return and another in isa string parsing). I also decided to expose
>    a get_pte() function to unit tests and also an isa-extension-by-name
>    function to check for arbitrary extensions. Finally, I picked up
>    Thomas' gitlab-ci suggestion and his tags.
> 
> (Having [1] and the selftests running makes me pretty happy with the
> series, so, unless somebody shouts, I'll merge this sometime next week.)
> 
> [1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commit/e9c6c58b1c799de77fd39970b358a7592ecd048f

With the fix for __clzdi2(), the makefile refactoring to add the %.aux.o
target, and Eric's tags, I'm pleased to announce that I've created a v3
branch and merged it.  Bring on the riscv tests!

Thanks,
drew


> 
> Thanks,
> drew
> 
> Original cover letter follows:
> 
> This series adds another architecture to kvm-unit-tests (RISC-V, both
> 32-bit and 64-bit). Much of the code is borrowed from arm/arm64 by
> mimicking its patterns or by first making the arm code more generic
> and moving it to the common lib.
> 
> This series brings UART, SMP, MMU, and exception handling support.
> One should be able to start writing CPU validation tests in a mix
> of C and asm as well as write SBI tests, as is the plan for the SBI
> verification framework. kvm-unit-tests provides backtraces on asserts
> and input can be given to the tests through command line arguments,
> environment variables, and the DT (there's already an ISA string
> parser for extension detection).
> 
> This series only targets QEMU TCG and KVM, but OpenSBI may be replaced
> with other SBI implementations, such as RustSBI. It's a goal to target
> bare-metal as soon as possible, so EFI support is already in progress
> and will be posted soon. More follow on series will come as well,
> bringing interrupt controller support for timer and PMU testing,
> support to run tests in usermode, and whatever else people need for
> their tests.
> 
> 
> Andrew Jones (24):
>   configure: Add ARCH_LIBDIR
>   riscv: Initial port, hello world
>   arm/arm64: Move cpumask.h to common lib
>   arm/arm64: Share cpu online, present and idle masks
>   riscv: Add DT parsing
>   riscv: Add initial SBI support
>   riscv: Add run script and unittests.cfg
>   riscv: Add riscv32 support
>   riscv: Add exception handling
>   riscv: Add backtrace support
>   arm/arm64: Generalize wfe/sev names in smp.c
>   arm/arm64: Remove spinlocks from on_cpu_async
>   arm/arm64: Share on_cpus
>   riscv: Compile with march
>   riscv: Add SMP support
>   arm/arm64: Share memregions
>   riscv: Populate memregions and switch to page allocator
>   riscv: Add MMU support
>   riscv: Enable the MMU in secondaries
>   riscv: Enable vmalloc
>   lib: Add strcasecmp and strncasecmp
>   riscv: Add isa string parsing
>   gitlab-ci: Add riscv64 tests
>   MAINTAINERS: Add riscv
> 
>  .gitlab-ci.yml               |  17 +++
>  MAINTAINERS                  |   8 ++
>  Makefile                     |   2 +-
>  arm/Makefile.common          |   2 +
>  arm/selftest.c               |   3 +-
>  configure                    |  16 +++
>  lib/arm/asm/gic-v2.h         |   2 +-
>  lib/arm/asm/gic-v3.h         |   2 +-
>  lib/arm/asm/gic.h            |   2 +-
>  lib/arm/asm/setup.h          |  14 --
>  lib/arm/asm/smp.h            |  45 +-----
>  lib/arm/mmu.c                |   3 +-
>  lib/arm/setup.c              |  93 +++----------
>  lib/arm/smp.c                | 135 +-----------------
>  lib/arm64/asm/cpumask.h      |   1 -
>  lib/{arm/asm => }/cpumask.h  |  42 +++++-
>  lib/ctype.h                  |  10 ++
>  lib/elf.h                    |  11 ++
>  lib/ldiv32.c                 |  16 +++
>  lib/linux/const.h            |   2 +
>  lib/memregions.c             |  82 +++++++++++
>  lib/memregions.h             |  29 ++++
>  lib/on-cpus.c                | 154 +++++++++++++++++++++
>  lib/on-cpus.h                |  14 ++
>  lib/riscv/.gitignore         |   1 +
>  lib/riscv/asm-offsets.c      |  62 +++++++++
>  lib/riscv/asm/asm-offsets.h  |   1 +
>  lib/riscv/asm/barrier.h      |  20 +++
>  lib/riscv/asm/bitops.h       |  21 +++
>  lib/riscv/asm/bug.h          |  20 +++
>  lib/riscv/asm/csr.h          | 100 ++++++++++++++
>  lib/riscv/asm/io.h           |  87 ++++++++++++
>  lib/riscv/asm/isa.h          |  33 +++++
>  lib/riscv/asm/memory_areas.h |   1 +
>  lib/riscv/asm/mmu.h          |  32 +++++
>  lib/riscv/asm/page.h         |  21 +++
>  lib/riscv/asm/pgtable.h      |  42 ++++++
>  lib/riscv/asm/processor.h    |  29 ++++
>  lib/riscv/asm/ptrace.h       |  46 +++++++
>  lib/riscv/asm/sbi.h          |  54 ++++++++
>  lib/riscv/asm/setup.h        |  15 ++
>  lib/riscv/asm/smp.h          |  29 ++++
>  lib/riscv/asm/spinlock.h     |   7 +
>  lib/riscv/asm/stack.h        |  12 ++
>  lib/riscv/bitops.c           |  47 +++++++
>  lib/riscv/io.c               |  97 +++++++++++++
>  lib/riscv/isa.c              | 126 +++++++++++++++++
>  lib/riscv/mmu.c              | 205 +++++++++++++++++++++++++++
>  lib/riscv/processor.c        |  64 +++++++++
>  lib/riscv/sbi.c              |  40 ++++++
>  lib/riscv/setup.c            | 188 +++++++++++++++++++++++++
>  lib/riscv/smp.c              |  70 ++++++++++
>  lib/riscv/stack.c            |  32 +++++
>  lib/string.c                 |  14 ++
>  lib/string.h                 |   2 +
>  riscv/Makefile               | 106 ++++++++++++++
>  riscv/cstart.S               | 259 +++++++++++++++++++++++++++++++++++
>  riscv/flat.lds               |  75 ++++++++++
>  riscv/run                    |  41 ++++++
>  riscv/sbi.c                  |  41 ++++++
>  riscv/selftest.c             | 100 ++++++++++++++
>  riscv/sieve.c                |   1 +
>  riscv/unittests.cfg          |  37 +++++
>  63 files changed, 2616 insertions(+), 267 deletions(-)
>  delete mode 100644 lib/arm64/asm/cpumask.h
>  rename lib/{arm/asm => }/cpumask.h (72%)
>  create mode 100644 lib/memregions.c
>  create mode 100644 lib/memregions.h
>  create mode 100644 lib/on-cpus.c
>  create mode 100644 lib/on-cpus.h
>  create mode 100644 lib/riscv/.gitignore
>  create mode 100644 lib/riscv/asm-offsets.c
>  create mode 100644 lib/riscv/asm/asm-offsets.h
>  create mode 100644 lib/riscv/asm/barrier.h
>  create mode 100644 lib/riscv/asm/bitops.h
>  create mode 100644 lib/riscv/asm/bug.h
>  create mode 100644 lib/riscv/asm/csr.h
>  create mode 100644 lib/riscv/asm/io.h
>  create mode 100644 lib/riscv/asm/isa.h
>  create mode 100644 lib/riscv/asm/memory_areas.h
>  create mode 100644 lib/riscv/asm/mmu.h
>  create mode 100644 lib/riscv/asm/page.h
>  create mode 100644 lib/riscv/asm/pgtable.h
>  create mode 100644 lib/riscv/asm/processor.h
>  create mode 100644 lib/riscv/asm/ptrace.h
>  create mode 100644 lib/riscv/asm/sbi.h
>  create mode 100644 lib/riscv/asm/setup.h
>  create mode 100644 lib/riscv/asm/smp.h
>  create mode 100644 lib/riscv/asm/spinlock.h
>  create mode 100644 lib/riscv/asm/stack.h
>  create mode 100644 lib/riscv/bitops.c
>  create mode 100644 lib/riscv/io.c
>  create mode 100644 lib/riscv/isa.c
>  create mode 100644 lib/riscv/mmu.c
>  create mode 100644 lib/riscv/processor.c
>  create mode 100644 lib/riscv/sbi.c
>  create mode 100644 lib/riscv/setup.c
>  create mode 100644 lib/riscv/smp.c
>  create mode 100644 lib/riscv/stack.c
>  create mode 100644 riscv/Makefile
>  create mode 100644 riscv/cstart.S
>  create mode 100644 riscv/flat.lds
>  create mode 100755 riscv/run
>  create mode 100644 riscv/sbi.c
>  create mode 100644 riscv/selftest.c
>  create mode 120000 riscv/sieve.c
>  create mode 100644 riscv/unittests.cfg
> 
> -- 
> 2.43.0
> 

