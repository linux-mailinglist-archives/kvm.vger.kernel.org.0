Return-Path: <kvm+bounces-34162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED5A59F7DD4
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FBD9165BEC
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F767225765;
	Thu, 19 Dec 2024 15:19:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D8841C64;
	Thu, 19 Dec 2024 15:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734621562; cv=none; b=QR7vpYH4FwjG2ikbgjLw/PhT8a4jofZcHovcIUUZH+VED73IuvrvwCY9Mk5baKUn3D3/pBtXA8j82XPBm3HLbcdabgzf4I28rHYzzmmq8giJDYXeLE/1nsB7CYqWU79sCbdWMwvAVSdUge82pSxEvcj5Fs5l0LAef6tBkxXq5DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734621562; c=relaxed/simple;
	bh=fBWXg6wVnO1J7mURuPv8bT8PV8B7peZFqKBsIrvLNBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCRWOhmJG/JcXijCODoBWhj4QYboV6LAfEn0aqSpB/S927JBBbmcfLxcbs1xsALqbg6JBEJcpL+nLMLnKbWN1Us+zybkakD23EbjzjmYo9yqc/TUOZUU2dlb7BlfxZcOHwAhYuyUtzGgLLPxK9LA6I+pROCHIVDvd12f7kl6yx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quad.stoffel.home; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quad.stoffel.home
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 1DE191E1AF;
	Thu, 19 Dec 2024 10:14:04 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id B5E07A0C0E; Thu, 19 Dec 2024 10:14:03 -0500 (EST)
Date: Thu, 19 Dec 2024 10:14:03 -0500
From: John Stoffel <john@quad.stoffel.home>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	James Houghton <jthoughton@google.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH v4 00/16] KVM: selftests: "tree" wide overhauls
Message-ID: <Z2Q4O78gZZt-53DI@quad.stoffel.home>
References: <20241128005547.4077116-1-seanjc@google.com>
 <173455833964.3185228.5614329030867008316.b4-ty@google.com>
 <Z2NIwmRDaZBc_V4o@google.com>
 <Z2N-UlxgYlGT_1Or@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2N-UlxgYlGT_1Or@google.com>

On Wed, Dec 18, 2024 at 06:00:50PM -0800, Sean Christopherson wrote:
> On Wed, Dec 18, 2024, Sean Christopherson wrote:
> > On Wed, Dec 18, 2024, Sean Christopherson wrote:
> > > On Wed, 27 Nov 2024 16:55:31 -0800, Sean Christopherson wrote:
> > > > Two separate series (mmu_stress_test[1] and $ARCH[2]), posted as one to
> > > > avoid unpleasant conflicts, and because I hope to land both in kvm/next
> > > > shortly after 6.12-rc1 since they impact all of KVM selftests.
> > > > 
> > > > mmu_stress_test
> > > > ---------------
> > > > Convert the max_guest_memory_test into a more generic mmu_stress_test.
> > > > The basic gist of the "conversion" is to have the test do mprotect() on
> > > > guest memory while vCPUs are accessing said memory, e.g. to verify KVM
> > > > and mmu_notifiers are working as intended.
> > > > 
> > > > [...]
> > > 
> > > As I am running out of time before I disappear for two weeks, applied to:
> > > 
> > >    https://github.com/kvm-x86/linux.git selftests_arch
> > > 
> > > Other KVM maintainers, that branch is officially immutable.  I also pushed a tag,
> > > kvm-selftests-arch-6.14, just in case I pull a stupid and manage to clobber the
> > > branch.  My apologies if this causes pain.  AFAICT, there aren't any queued or
> > > in-flight patches that git's rename magic can't automatically handle, so hopefully
> > > this ends up being pain-free.
> > > 
> > > Paolo, here's a pull request if you want to pull this into kvm/next long before
> > > the 6.14 merge window.  Diff stats at the very bottom (hilariously long).
> > 
> > Argh!  I completely forget to build test this on non-x86, and missed that arm64
> > snuck in 75cd027cbcb1 ("KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely 
> > ignored").  *sigh*
> > 
> > Given that I just sent out mail, I'm going to cross my fingers and hope that no
> > one has merged the above branch/tag.  I've deleted the branch and tags from the
> > remote, but kept the tag locally just in case.
> > 
> > Please holler if you managed to grab the broken branch/tag.  If no one screams,
> > I'll assume I got luckly and will push a fixed version (with different names) later
> > today.
> 
> Third time is the charm.  Compile tested on all architectures, and runtime tested
> on x86 and arm64.
> 
>   https://github.com/kvm-x86/linux.git selftests_treewide_6.14
> 
> ---
> The following changes since commit 3522c419758ee8dca5a0e8753ee0070a22157bc1:
> 
>   Merge tag 'kvm-riscv-fixes-6.13-1' of https://github.com/kvm-riscv/linux into HEAD (2024-12-13 13:59:20 -0500)
> 
> are available in the Git repository at:
> 
>   https://github.com/kvm-x86/linux.git tags/kvm-selftests-treewide-6.14
> 
> for you to fetch changes up to 9af04539d474dda4984ff4909d4568e6123c8cba:
> 
>   KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR (2024-12-18 14:15:05 -0800)
> 
> ----------------------------------------------------------------
> KVM selftests "tree"-wide changes for 6.14:
> 
>  - Rework vcpu_get_reg() to return a value instead of using an out-param, and
>    update all affected arch code accordingly.
> 
>  - Convert the max_guest_memory_test into a more generic mmu_stress_test.
>    The basic gist of the "conversion" is to have the test do mprotect() on
>    guest memory while vCPUs are accessing said memory, e.g. to verify KVM
>    and mmu_notifiers are working as intended.
> 
>  - Play nice with treewrite builds of unsupported architectures, e.g. arm

nit:  treewide, not treewrite

>    (32-bit), as KVM selftests' Makefile doesn't do anything to ensure the
>    target architecture is actually one KVM selftests supports.
> 
>  - Use the kernel's $(ARCH) definition instead of the target triple for arch
>    specific directories, e.g. arm64 instead of aarch64, mainly so as not to
>    be different from the rest of the kernel.
> 
> ----------------------------------------------------------------
> Sean Christopherson (16):
>       KVM: Move KVM_REG_SIZE() definition to common uAPI header
>       KVM: selftests: Return a value from vcpu_get_reg() instead of using an out-param
>       KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
>       KVM: selftests: Check for a potential unhandled exception iff KVM_RUN succeeded
>       KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
>       KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
>       KVM: selftests: Compute number of extra pages needed in mmu_stress_test
>       KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
>       KVM: selftests: Enable mmu_stress_test on arm64
>       KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
>       KVM: selftests: Precisely limit the number of guest loops in mmu_stress_test
>       KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
>       KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
>       KVM: selftests: Provide empty 'all' and 'clean' targets for unsupported ARCHs
>       KVM: selftests: Use canonical $(ARCH) paths for KVM selftests directories
>       KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR
> --
> 
> [01/16] KVM: Move KVM_REG_SIZE() definition to common uAPI header
>         https://github.com/kvm-x86/linux/commit/915d2f0718a4
> [02/16] KVM: selftests: Return a value from vcpu_get_reg() instead of using an out-param
>         https://github.com/kvm-x86/linux/commit/09bb926d2907
> [03/16] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
>         https://github.com/kvm-x86/linux/commit/fe85ce31b289
> [04/16] KVM: selftests: Check for a potential unhandled exception iff KVM_RUN succeeded
>         https://github.com/kvm-x86/linux/commit/d6533c151338
> [05/16] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/b12391498d1e
> [06/16] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/55e164df482a
> [07/16] KVM: selftests: Compute number of extra pages needed in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/1ddd3ea75ac3
> [08/16] KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
>         https://github.com/kvm-x86/linux/commit/c35d8f579e50
> [09/16] KVM: selftests: Enable mmu_stress_test on arm64
>         https://github.com/kvm-x86/linux/commit/8abe7632a1ee
> [10/16] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/3a0422526404
> [11/16] KVM: selftests: Precisely limit the number of guest loops in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/82b542e11848
> [12/16] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/80b7859a3a43
> [13/16] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
>         https://github.com/kvm-x86/linux/commit/b6c304aec648
> [14/16] KVM: selftests: Provide empty 'all' and 'clean' targets for unsupported ARCHs
>         https://github.com/kvm-x86/linux/commit/43fbd8cd389f
> [15/16] KVM: selftests: Use canonical $(ARCH) paths for KVM selftests directories
>         https://github.com/kvm-x86/linux/commit/67730e6c53d7
> [16/16] KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR
>         https://github.com/kvm-x86/linux/commit/9af04539d474
> 
> 
>  MAINTAINERS                                                                          |  12 +--
>  arch/arm64/include/uapi/asm/kvm.h                                                    |   3 -
>  arch/riscv/include/uapi/asm/kvm.h                                                    |   3 -
>  include/uapi/linux/kvm.h                                                             |   4 +
>  tools/testing/selftests/kvm/.gitignore                                               |   1 +
>  tools/testing/selftests/kvm/Makefile                                                 | 345 ++------------------------------------------------------------------------------
>  tools/testing/selftests/kvm/Makefile.kvm                                             | 330 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/testing/selftests/kvm/{aarch64 => arm64}/aarch32_id_regs.c                     |  10 +--
>  tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer.c                          |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer_edge_cases.c               |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/debug-exceptions.c                    |   4 +-
>  tools/testing/selftests/kvm/{aarch64 => arm64}/get-reg-list.c                        |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/hypercalls.c                          |   6 +-
>  tools/testing/selftests/kvm/{aarch64 => arm64}/mmio_abort.c                          |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/no-vgic-v3.c                          |   2 +-
>  tools/testing/selftests/kvm/{aarch64 => arm64}/page_fault_test.c                     |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/psci_test.c                           |   8 +-
>  tools/testing/selftests/kvm/{aarch64 => arm64}/set_id_regs.c                         |  22 +++---
>  tools/testing/selftests/kvm/{aarch64 => arm64}/smccc_filter.c                        |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/vcpu_width_config.c                   |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_init.c                           |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_irq.c                            |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_lpi_stress.c                     |   0
>  tools/testing/selftests/kvm/{aarch64 => arm64}/vpmu_counter_access.c                 |  19 +++--
>  tools/testing/selftests/kvm/dirty_log_perf_test.c                                    |   2 +-
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/arch_timer.h                  |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/delay.h                       |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic.h                         |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3.h                      |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3_its.h                  |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/kvm_util_arch.h               |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/processor.h                   |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/spinlock.h                    |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/ucall.h                       |   0
>  tools/testing/selftests/kvm/include/{aarch64 => arm64}/vgic.h                        |   0
>  tools/testing/selftests/kvm/include/kvm_util.h                                       |  10 ++-
>  tools/testing/selftests/kvm/include/{s390x => s390}/debug_print.h                    |   0
>  tools/testing/selftests/kvm/include/{s390x => s390}/diag318_test_handler.h           |   0
>  tools/testing/selftests/kvm/include/{s390x => s390}/facility.h                       |   0
>  tools/testing/selftests/kvm/include/{s390x => s390}/kvm_util_arch.h                  |   0
>  tools/testing/selftests/kvm/include/{s390x => s390}/processor.h                      |   0
>  tools/testing/selftests/kvm/include/{s390x => s390}/sie.h                            |   0
>  tools/testing/selftests/kvm/include/{s390x => s390}/ucall.h                          |   0
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/apic.h                           |   2 -
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/evmcs.h                          |   3 -
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/hyperv.h                         |   3 -
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/kvm_util_arch.h                  |   0
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/mce.h                            |   2 -
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/pmu.h                            |   0
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/processor.h                      |   2 -
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/sev.h                            |   0
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/svm.h                            |   6 --
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/svm_util.h                       |   3 -
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/ucall.h                          |   0
>  tools/testing/selftests/kvm/include/{x86_64 => x86}/vmx.h                            |   2 -
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic.c                             |   0
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_private.h                     |   0
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3.c                          |   0
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3_its.c                      |   0
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/handlers.S                        |   0
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/processor.c                       |   8 +-
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/spinlock.c                        |   0
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/ucall.c                           |   0
>  tools/testing/selftests/kvm/lib/{aarch64 => arm64}/vgic.c                            |   0
>  tools/testing/selftests/kvm/lib/kvm_util.c                                           |   3 +-
>  tools/testing/selftests/kvm/lib/riscv/processor.c                                    |  66 ++++++++--------
>  tools/testing/selftests/kvm/lib/{s390x => s390}/diag318_test_handler.c               |   0
>  tools/testing/selftests/kvm/lib/{s390x => s390}/facility.c                           |   0
>  tools/testing/selftests/kvm/lib/{s390x => s390}/processor.c                          |   0
>  tools/testing/selftests/kvm/lib/{s390x => s390}/ucall.c                              |   0
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/apic.c                               |   0
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/handlers.S                           |   0
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/hyperv.c                             |   0
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/memstress.c                          |   2 +-
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/pmu.c                                |   0
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/processor.c                          |   2 -
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/sev.c                                |   0
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/svm.c                                |   1 -
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/ucall.c                              |   0
>  tools/testing/selftests/kvm/lib/{x86_64 => x86}/vmx.c                                |   2 -
>  tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c}           | 162 ++++++++++++++++++++++++++++++++++----
>  tools/testing/selftests/kvm/riscv/arch_timer.c                                       |   2 +-
>  tools/testing/selftests/kvm/riscv/ebreak_test.c                                      |   2 +-
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c                                     |   2 +-
>  tools/testing/selftests/kvm/{s390x => s390}/cmma_test.c                              |   0
>  tools/testing/selftests/kvm/{s390x => s390}/config                                   |   0
>  tools/testing/selftests/kvm/{s390x => s390}/cpumodel_subfuncs_test.c                 |   0
>  tools/testing/selftests/kvm/{s390x => s390}/debug_test.c                             |   0
>  tools/testing/selftests/kvm/{s390x => s390}/memop.c                                  |   0
>  tools/testing/selftests/kvm/{s390x => s390}/resets.c                                 |   2 +-
>  tools/testing/selftests/kvm/{s390x => s390}/shared_zeropage_test.c                   |   0
>  tools/testing/selftests/kvm/{s390x => s390}/sync_regs_test.c                         |   0
>  tools/testing/selftests/kvm/{s390x => s390}/tprot.c                                  |   0
>  tools/testing/selftests/kvm/{s390x => s390}/ucontrol_test.c                          |   0
>  tools/testing/selftests/kvm/set_memory_region_test.c                                 |   6 +-
>  tools/testing/selftests/kvm/steal_time.c                                             |   3 +-
>  tools/testing/selftests/kvm/{x86_64 => x86}/amx_test.c                               |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/apic_bus_clock_test.c                    |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/cpuid_test.c                             |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c                    |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/debug_regs.c                             |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/dirty_log_page_splitting_test.c          |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/exit_on_emulation_failure_test.c         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/feature_msrs_test.c                      |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/fix_hypercall_test.c                     |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/flds_emulation.h                         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hwcr_msr_test.c                          |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_clock.c                           |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_cpuid.c                           |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_evmcs.c                           |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_extended_hypercalls.c             |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_features.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_ipi.c                             |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_svm_test.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_tlb_flush.c                       |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/kvm_clock_test.c                         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/kvm_pv_test.c                            |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/max_vcpuid_cap_test.c                    |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/monitor_mwait_test.c                     |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/nested_exceptions_test.c                 |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.c                     |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.sh                    |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/platform_info_test.c                     |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/pmu_counters_test.c                      |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/pmu_event_filter_test.c                  |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_conversions_test.c           |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_kvm_exits_test.c             |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/recalc_apic_map_test.c                   |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/set_boot_cpu_id.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/set_sregs_test.c                         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/sev_init2_tests.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/sev_migrate_tests.c                      |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/sev_smoke_test.c                         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/smaller_maxphyaddr_emulation_test.c      |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/smm_test.c                               |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/state_test.c                             |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/svm_int_ctl_test.c                       |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_shutdown_test.c               |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_soft_inject_test.c            |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/svm_vmcall_test.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/sync_regs_test.c                         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/triple_fault_event_test.c                |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/tsc_msrs_test.c                          |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/tsc_scaling_sync.c                       |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/ucna_injection_test.c                    |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/userspace_io_test.c                      |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/userspace_msr_exit_test.c                |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_apic_access_test.c                   |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_close_while_nested_test.c            |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_dirty_log_test.c                     |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_exception_with_invalid_guest_state.c |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_invalid_nested_guest_state.c         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_msrs_test.c                          |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_nested_tsc_scaling_test.c            |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_pmu_caps_test.c                      |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_preemption_timer_test.c              |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_set_nested_state_test.c              |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/vmx_tsc_adjust_test.c                    |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/xapic_ipi_test.c                         |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/xapic_state_test.c                       |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/xcr0_cpuid_test.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/xen_shinfo_test.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/xen_vmcall_test.c                        |   0
>  tools/testing/selftests/kvm/{x86_64 => x86}/xss_msr_test.c                           |   0
>  164 files changed, 587 insertions(+), 480 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/Makefile.kvm
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/aarch32_id_regs.c (95%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer_edge_cases.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/debug-exceptions.c (99%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/get-reg-list.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/hypercalls.c (98%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/mmio_abort.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/no-vgic-v3.c (98%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/page_fault_test.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/psci_test.c (96%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/set_id_regs.c (97%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/smccc_filter.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/vcpu_width_config.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_init.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_irq.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_lpi_stress.c (100%)
>  rename tools/testing/selftests/kvm/{aarch64 => arm64}/vpmu_counter_access.c (97%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/arch_timer.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/delay.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3_its.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/kvm_util_arch.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/processor.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/spinlock.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/ucall.h (100%)
>  rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/vgic.h (100%)
>  rename tools/testing/selftests/kvm/include/{s390x => s390}/debug_print.h (100%)
>  rename tools/testing/selftests/kvm/include/{s390x => s390}/diag318_test_handler.h (100%)
>  rename tools/testing/selftests/kvm/include/{s390x => s390}/facility.h (100%)
>  rename tools/testing/selftests/kvm/include/{s390x => s390}/kvm_util_arch.h (100%)
>  rename tools/testing/selftests/kvm/include/{s390x => s390}/processor.h (100%)
>  rename tools/testing/selftests/kvm/include/{s390x => s390}/sie.h (100%)
>  rename tools/testing/selftests/kvm/include/{s390x => s390}/ucall.h (100%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/apic.h (98%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/evmcs.h (99%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/hyperv.h (99%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/kvm_util_arch.h (100%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/mce.h (94%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/pmu.h (100%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/processor.h (99%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/sev.h (100%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm.h (98%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm_util.h (94%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/ucall.h (100%)
>  rename tools/testing/selftests/kvm/include/{x86_64 => x86}/vmx.h (99%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic.c (100%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_private.h (100%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3.c (100%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3_its.c (100%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/handlers.S (100%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/processor.c (98%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/spinlock.c (100%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/ucall.c (100%)
>  rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/vgic.c (100%)
>  rename tools/testing/selftests/kvm/lib/{s390x => s390}/diag318_test_handler.c (100%)
>  rename tools/testing/selftests/kvm/lib/{s390x => s390}/facility.c (100%)
>  rename tools/testing/selftests/kvm/lib/{s390x => s390}/processor.c (100%)
>  rename tools/testing/selftests/kvm/lib/{s390x => s390}/ucall.c (100%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/apic.c (100%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/handlers.S (100%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/hyperv.c (100%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/memstress.c (98%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/pmu.c (100%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/processor.c (99%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/sev.c (100%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/svm.c (99%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/ucall.c (100%)
>  rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/vmx.c (99%)
>  rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (60%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/cmma_test.c (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/config (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/cpumodel_subfuncs_test.c (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/debug_test.c (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/memop.c (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/resets.c (99%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/shared_zeropage_test.c (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/sync_regs_test.c (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/tprot.c (100%)
>  rename tools/testing/selftests/kvm/{s390x => s390}/ucontrol_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/amx_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/apic_bus_clock_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/cpuid_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/debug_regs.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/dirty_log_page_splitting_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/exit_on_emulation_failure_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/feature_msrs_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/fix_hypercall_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/flds_emulation.h (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hwcr_msr_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_clock.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_cpuid.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_evmcs.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_extended_hypercalls.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_features.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_ipi.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_svm_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_tlb_flush.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/kvm_clock_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/kvm_pv_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/max_vcpuid_cap_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/monitor_mwait_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/nested_exceptions_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.sh (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/platform_info_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/pmu_counters_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/pmu_event_filter_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_conversions_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_kvm_exits_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/recalc_apic_map_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/set_boot_cpu_id.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/set_sregs_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_init2_tests.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_migrate_tests.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_smoke_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/smaller_maxphyaddr_emulation_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/smm_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/state_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_int_ctl_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_shutdown_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_soft_inject_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_vmcall_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/sync_regs_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/triple_fault_event_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/tsc_msrs_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/tsc_scaling_sync.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/ucna_injection_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/userspace_io_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/userspace_msr_exit_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_apic_access_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_close_while_nested_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_dirty_log_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_exception_with_invalid_guest_state.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_invalid_nested_guest_state.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_msrs_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_nested_tsc_scaling_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_pmu_caps_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_preemption_timer_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_set_nested_state_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_tsc_adjust_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/xapic_ipi_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/xapic_state_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/xcr0_cpuid_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/xen_shinfo_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/xen_vmcall_test.c (100%)
>  rename tools/testing/selftests/kvm/{x86_64 => x86}/xss_msr_test.c (100%)
> 

-- 

