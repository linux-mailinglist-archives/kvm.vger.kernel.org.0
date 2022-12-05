Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523C0642C5D
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiLEP7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiLEP66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:58:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA17C19C04
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 587EE6119B
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 15:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6DAC43470;
        Mon,  5 Dec 2022 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670255935;
        bh=KlgS04hOpJbXhFkEwK22oyJCLlMLobJeeM+DEl6IoxQ=;
        h=From:To:Cc:Subject:Date:From;
        b=iorLEdNCcSbEbj2U9R9KTtmk/B3esnS365oOj02UJCLFx80S7wvB2K1S+f8WkY4jG
         cmNsHIP7eKURISiMgIil4X72IwsSP2dZ14uZcXlT1fy2WJMIWAs6XrSYJC4lGnv8qG
         TAXt6mUJyrdcaJeOyzoDwjbyHQ2Iorq9nQxJM0p4FQ3ixUIM7wFqBI1S1KWVJVdEtT
         HuR2dNDRvH7yKp234rNWsfYmsf1kOm1Gm48YrdvzyfDQvC57TunUU0ePuBvapOSzQI
         zddJNiz8E3yOy6Hj66sVRDbWUOmej9VQXZG4+wtGPvv4dZJybo3J6Mh3eJGPSdnykt
         ipoRPKNeHV0pQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1p2Dro-00AbwS-M5;
        Mon, 05 Dec 2022 15:58:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Usama Arif <usama.arif@bytedance.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 6.2
Date:   Mon,  5 Dec 2022 15:58:45 +0000
Message-Id: <20221205155845.233018-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, andrew.jones@linux.dev, akpm@linux-foundation.org, anshuman.khandual@arm.com, acme@kernel.org, bagasdotme@gmail.com, bgardon@google.com, catalin.marinas@arm.com, cohuck@redhat.com, tabba@google.com, gshan@redhat.com, kuba@kernel.org, james.morse@arm.com, maciej.szmigiero@oracle.com, m.szyprowski@samsung.com, broonie@kernel.org, mark.rutland@arm.com, oliver.upton@linux.dev, pcc@google.com, peterx@redhat.com, philmd@linaro.org, qperret@google.com, reijiw@google.com, ricarkol@google.com, ryan.roberts@arm.com, seanjc@google.com, steven.price@arm.com, usama.arif@bytedance.com, vdonnefort@google.com, will@kernel.org, daizhiyuan@phytium.com.cn, suzuki.poulose@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the meat of the KVM/arm64 updates for 6.2, and it is quite
packed with stuff (see the tag for the laundry list).

Things to notice:

- We have the usual shared branch with arm64, due to the never-ending
  sysreg repainting. I'm sure it will stop one day...

- There is a lot of selftest conflicts with your own branch, see:

  https://lore.kernel.org/r/20221201112432.4cb9ae42@canb.auug.org.au
  https://lore.kernel.org/r/20221201113626.438f13c5@canb.auug.org.au
  https://lore.kernel.org/r/20221201115741.7de32422@canb.auug.org.au
  https://lore.kernel.org/r/20221201120939.3c19f004@canb.auug.org.au
  https://lore.kernel.org/r/20221201131623.18ebc8d8@canb.auug.org.au

  for a rather exhaustive collection.

- For the 6.3 cycle, we are going to experiment with Oliver taking
  care of most of the patch herding. I'm sure he'll do a great job,
  but if there is the odd mistake, please cut him some slack and blame
  me instead.

Please pull,

	M.

The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:

  Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.2

for you to fetch changes up to 753d734f3f347e7fc49b819472bbf61dcfc1a16f:

  Merge remote-tracking branch 'arm64/for-next/sysregs' into kvmarm-master/next (2022-12-05 14:39:53 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 6.2

- Enable the per-vcpu dirty-ring tracking mechanism, together with an
  option to keep the good old dirty log around for pages that are
  dirtied by something other than a vcpu.

- Switch to the relaxed parallel fault handling, using RCU to delay
  page table reclaim and giving better performance under load.

- Relax the MTE ABI, allowing a VMM to use the MAP_SHARED mapping
  option, which multi-process VMMs such as crosvm rely on.

- Merge the pKVM shadow vcpu state tracking that allows the hypervisor
  to have its own view of a vcpu, keeping that state private.

- Add support for the PMUv3p5 architecture revision, bringing support
  for 64bit counters on systems that support it, and fix the
  no-quite-compliant CHAIN-ed counter support for the machines that
  actually exist out there.

- Fix a handful of minor issues around 52bit VA/PA support (64kB pages
  only) as a prefix of the oncoming support for 4kB and 16kB pages.

- Add/Enable/Fix a bunch of selftests covering memslots, breakpoints,
  stage-2 faults and access tracking. You name it, we got it, we
  probably broke it.

- Pick a small set of documentation and spelling fixes, because no
  good merge window would be complete without those.

As a side effect, this tag also drags:

- The 'kvmarm-fixes-6.1-3' tag as a dependency to the dirty-ring
  series

- A shared branch with the arm64 tree that repaints all the system
  registers to match the ARM ARM's naming, and resulting in
  interesting conflicts

----------------------------------------------------------------
Anshuman Khandual (1):
      KVM: arm64: PMU: Replace version number '0' with ID_AA64DFR0_EL1_PMUVer_NI

Catalin Marinas (4):
      mm: Do not enable PG_arch_2 for all 64-bit architectures
      arm64: mte: Fix/clarify the PG_mte_tagged semantics
      KVM: arm64: Simplify the sanitise_mte_tags() logic
      arm64: mte: Lock a page for MTE tag initialisation

Fuad Tabba (3):
      KVM: arm64: Add hyp_spinlock_t static initializer
      KVM: arm64: Add infrastructure to create and track pKVM instances at EL2
      KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1

Gavin Shan (14):
      KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
      KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
      KVM: Support dirty ring in conjunction with bitmap
      KVM: arm64: Enable ring-based dirty memory tracking
      KVM: selftests: Use host page size to map ring buffer in dirty_log_test
      KVM: selftests: Clear dirty ring states between two modes in dirty_log_test
      KVM: selftests: Automate choosing dirty ring size in dirty_log_test
      KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
      KVM: selftests: memslot_perf_test: Consolidate loop conditions in prepare_vm()
      KVM: selftests: memslot_perf_test: Probe memory slots for once
      KVM: selftests: memslot_perf_test: Support variable guest page size
      KVM: selftests: memslot_perf_test: Consolidate memory
      KVM: selftests: memslot_perf_test: Report optimal memory slots
      KVM: Push dirty information unconditionally to backup bitmap

James Morse (38):
      arm64/sysreg: Standardise naming for ID_MMFR0_EL1
      arm64/sysreg: Standardise naming for ID_MMFR4_EL1
      arm64/sysreg: Standardise naming for ID_MMFR5_EL1
      arm64/sysreg: Standardise naming for ID_ISAR0_EL1
      arm64/sysreg: Standardise naming for ID_ISAR4_EL1
      arm64/sysreg: Standardise naming for ID_ISAR5_EL1
      arm64/sysreg: Standardise naming for ID_ISAR6_EL1
      arm64/sysreg: Standardise naming for ID_PFR0_EL1
      arm64/sysreg: Standardise naming for ID_PFR1_EL1
      arm64/sysreg: Standardise naming for ID_PFR2_EL1
      arm64/sysreg: Standardise naming for ID_DFR0_EL1
      arm64/sysreg: Standardise naming for ID_DFR1_EL1
      arm64/sysreg: Standardise naming for MVFR0_EL1
      arm64/sysreg: Standardise naming for MVFR1_EL1
      arm64/sysreg: Standardise naming for MVFR2_EL1
      arm64/sysreg: Extend the maximum width of a register and symbol name
      arm64/sysreg: Convert ID_MMFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR1_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR2_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR3_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR4_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR1_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR2_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR3_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR4_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR5_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR6_EL1 to automatic generation
      arm64/sysreg: Convert ID_PFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_PFR1_EL1 to automatic generation
      arm64/sysreg: Convert ID_PFR2_EL1 to automatic generation
      arm64/sysreg: Convert MVFR0_EL1 to automatic generation
      arm64/sysreg: Convert MVFR1_EL1 to automatic generation
      arm64/sysreg: Convert MVFR2_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR5_EL1 to automatic generation
      arm64/sysreg: Convert ID_AFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_DFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_DFR1_EL1 to automatic generation

Marc Zyngier (32):
      Merge tag 'kvmarm-fixes-6.1-3' into kvm-arm64/dirty-ring
      arm64: Add ID_DFR0_EL1.PerfMon values for PMUv3p7 and IMP_DEF
      KVM: arm64: PMU: Align chained counter implementation with architecture pseudocode
      KVM: arm64: PMU: Always advertise the CHAIN event
      KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
      KVM: arm64: PMU: Narrow the overflow checking when required
      KVM: arm64: PMU: Only narrow counters that are not 64bit wide
      KVM: arm64: PMU: Add counter_index_to_*reg() helpers
      KVM: arm64: PMU: Simplify setting a counter to a specific value
      KVM: arm64: PMU: Do not let AArch32 change the counters' top 32 bits
      KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
      KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be set from userspace
      KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be set from userspace
      KVM: arm64: PMU: Implement PMUv3p5 long counter support
      KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the guest
      KVM: arm64: PMU: Simplify vcpu computation on perf overflow notification
      KVM: arm64: PMU: Make kvm_pmc the main data structure
      KVM: arm64: PMU: Simplify PMCR_EL0 reset handling
      KVM: arm64: PMU: Sanitise PMCR_EL0.LP on first vcpu run
      KVM: arm64: PMU: Fix period computation for 64bit counters with 32bit overflow
      Merge branch kvm-arm64/selftest/memslot-fixes into kvmarm-master/next
      Merge branch kvm-arm64/selftest/linked-bps into kvmarm-master/next
      Merge branch kvm-arm64/selftest/s2-faults into kvmarm-master/next
      Merge branch kvm-arm64/selftest/access-tracking into kvmarm-master/next
      Merge branch kvm-arm64/52bit-fixes into kvmarm-master/next
      Merge branch kvm-arm64/dirty-ring into kvmarm-master/next
      Merge branch kvm-arm64/parallel-faults into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-vcpu-state into kvmarm-master/next
      Merge branch kvm-arm64/mte-map-shared into kvmarm-master/next
      Merge branch kvm-arm64/pmu-unchained into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.2 into kvmarm-master/next
      Merge remote-tracking branch 'arm64/for-next/sysregs' into kvmarm-master/next

Oliver Upton (19):
      KVM: arm64: Combine visitor arguments into a context structure
      KVM: arm64: Stash observed pte value in visitor context
      KVM: arm64: Pass mm_ops through the visitor context
      KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
      KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
      KVM: arm64: Use an opaque type for pteps
      KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make
      KVM: arm64: Protect stage-2 traversal with RCU
      KVM: arm64: Atomically update stage 2 leaf attributes in parallel walks
      KVM: arm64: Split init and set for table PTE
      KVM: arm64: Make block->table PTE changes parallel-aware
      KVM: arm64: Make leaf->leaf PTE changes parallel-aware
      KVM: arm64: Make table->block changes parallel-aware
      KVM: arm64: Handle stage-2 faults in parallel
      KVM: arm64: Take a pointer to walker data in kvm_dereference_pteref()
      KVM: arm64: Don't acquire RCU read lock for exclusive table walks
      KVM: arm64: Reject shared table walks in the hyp code
      KVM: selftests: Have perf_test_util signal when to stop vCPUs
      KVM: selftests: Build access_tracking_perf_test for arm64

Peter Collingbourne (4):
      mm: Add PG_arch_3 page flag
      KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
      KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
      Documentation: document the ABI changes for KVM_CAP_ARM_MTE

Quentin Perret (14):
      KVM: arm64: Move hyp refcount manipulation helpers to common header file
      KVM: arm64: Allow attaching of non-coalescable pages to a hyp pool
      KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory
      KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2
      KVM: arm64: Prevent the donation of no-map pages
      KVM: arm64: Add helpers to pin memory shared with the hypervisor at EL2
      KVM: arm64: Add per-cpu fixmap infrastructure at EL2
      KVM: arm64: Add generic hyp_memcache helpers
      KVM: arm64: Consolidate stage-2 initialisation into a single function
      KVM: arm64: Instantiate guest stage-2 page-tables at EL2
      KVM: arm64: Return guest memory from EL2 via dedicated teardown memcache
      KVM: arm64: Unmap 'kvm_arm_hyp_percpu_base' from the host
      KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
      KVM: arm64: Don't unnecessarily map host kernel sections at EL2

Reiji Watanabe (9):
      KVM: arm64: selftests: Use FIELD_GET() to extract ID register fields
      KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in debug-exceptions
      KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from debug-exceptions
      KVM: arm64: selftests: Add helpers to enable debug exceptions
      KVM: arm64: selftests: Stop unnecessary test stage tracking of debug-exceptions
      KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
      KVM: arm64: selftests: Add a test case for a linked breakpoint
      KVM: arm64: selftests: Add a test case for a linked watchpoint
      KVM: arm64: selftests: Test with every breakpoint/watchpoint

Ricardo Koller (14):
      KVM: selftests: Add a userfaultfd library
      KVM: selftests: aarch64: Add virt_get_pte_hva() library function
      KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
      KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h macros
      tools: Copy bitfield.h from the kernel sources
      KVM: selftests: Stash backing_src_type in struct userspace_mem_region
      KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
      KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and vm_vaddr_alloc()
      KVM: selftests: Use the right memslot for code, page-tables, and data allocations
      KVM: selftests: aarch64: Add aarch64/page_fault_test
      KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
      KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
      KVM: selftests: aarch64: Add readonly memslot tests into page_fault_test
      KVM: selftests: aarch64: Add mix of tests into page_fault_test

Ryan Roberts (3):
      KVM: arm64: Fix kvm init failure when mode!=vhe and VA_BITS=52.
      KVM: arm64: Fix PAR_TO_HPFAR() to work independently of PA_BITS.
      KVM: arm64: Fix benign bug with incorrect use of VA_BITS

Usama Arif (1):
      KVM: arm64: Fix pvtime documentation

Will Deacon (9):
      KVM: arm64: Unify identifiers used to distinguish host and hypervisor
      KVM: arm64: Implement do_donate() helper for donating memory
      KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
      KVM: arm64: Rename 'host_kvm' to 'host_mmu'
      KVM: arm64: Initialise hypervisor copies of host symbols unconditionally
      KVM: arm64: Provide I-cache invalidation by virtual address at EL2
      KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
      KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()
      arm64/sysreg: Remove duplicate definitions from asm/sysreg.h

Zhiyuan Dai (1):
      KVM: arm64: Fix typo in comment

 Documentation/virt/kvm/api.rst                     |   41 +-
 Documentation/virt/kvm/arm/pvtime.rst              |   14 +-
 Documentation/virt/kvm/devices/arm-vgic-its.rst    |    5 +-
 Documentation/virt/kvm/devices/vcpu.rst            |    2 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/include/asm/kvm_arm.h                   |    8 +-
 arch/arm64/include/asm/kvm_asm.h                   |    7 +-
 arch/arm64/include/asm/kvm_host.h                  |   76 +-
 arch/arm64/include/asm/kvm_hyp.h                   |    3 +
 arch/arm64/include/asm/kvm_mmu.h                   |    2 +-
 arch/arm64/include/asm/kvm_pgtable.h               |  175 ++-
 arch/arm64/include/asm/kvm_pkvm.h                  |   38 +
 arch/arm64/include/asm/mte.h                       |   65 +-
 arch/arm64/include/asm/pgtable.h                   |    4 +-
 arch/arm64/include/asm/sysreg.h                    |  138 ---
 arch/arm64/include/uapi/asm/kvm.h                  |    1 +
 arch/arm64/kernel/cpufeature.c                     |  212 ++--
 arch/arm64/kernel/elfcore.c                        |    2 +-
 arch/arm64/kernel/hibernate.c                      |    2 +-
 arch/arm64/kernel/image-vars.h                     |   15 -
 arch/arm64/kernel/mte.c                            |   21 +-
 arch/arm64/kvm/Kconfig                             |    2 +
 arch/arm64/kvm/arm.c                               |   90 +-
 arch/arm64/kvm/guest.c                             |   18 +-
 arch/arm64/kvm/hyp/hyp-constants.c                 |    3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h           |   27 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |   18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   68 ++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h         |   10 +-
 arch/arm64/kvm/hyp/nvhe/cache.S                    |   11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  110 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c                  |    2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  521 ++++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |  167 ++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |   29 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  436 ++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   98 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  652 ++++++------
 arch/arm64/kvm/hyp/vhe/Makefile                    |    2 +-
 arch/arm64/kvm/mmu.c                               |  193 ++--
 arch/arm64/kvm/pkvm.c                              |  138 ++-
 arch/arm64/kvm/pmu-emul.c                          |  482 ++++-----
 arch/arm64/kvm/reset.c                             |   29 -
 arch/arm64/kvm/sys_regs.c                          |  157 ++-
 arch/arm64/kvm/vgic/vgic-its.c                     |   20 +
 arch/arm64/lib/mte.S                               |    2 +-
 arch/arm64/mm/copypage.c                           |    7 +-
 arch/arm64/mm/fault.c                              |    4 +-
 arch/arm64/mm/mteswap.c                            |   16 +-
 arch/arm64/tools/gen-sysreg.awk                    |    2 +-
 arch/arm64/tools/sysreg                            |  754 +++++++++++++
 arch/x86/include/asm/kvm_host.h                    |    2 -
 arch/x86/kvm/x86.c                                 |   15 +-
 fs/proc/page.c                                     |    3 +-
 include/kvm/arm_pmu.h                              |   15 +-
 include/kvm/arm_vgic.h                             |    1 +
 include/linux/kernel-page-flags.h                  |    1 +
 include/linux/kvm_dirty_ring.h                     |   20 +-
 include/linux/kvm_host.h                           |   10 +-
 include/linux/page-flags.h                         |    3 +-
 include/trace/events/mmflags.h                     |    9 +-
 include/uapi/linux/kvm.h                           |    1 +
 mm/Kconfig                                         |    8 +
 mm/huge_memory.c                                   |    3 +-
 tools/include/linux/bitfield.h                     |  176 ++++
 tools/testing/selftests/kvm/.gitignore             |    1 +
 tools/testing/selftests/kvm/Makefile               |    3 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c        |    3 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |  311 ++++--
 .../selftests/kvm/aarch64/page_fault_test.c        | 1112 ++++++++++++++++++++
 .../selftests/kvm/access_tracking_perf_test.c      |    8 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |  228 +---
 tools/testing/selftests/kvm/dirty_log_test.c       |   53 +-
 .../selftests/kvm/include/aarch64/processor.h      |   35 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |   31 +-
 .../testing/selftests/kvm/include/perf_test_util.h |    3 +
 .../selftests/kvm/include/userfaultfd_util.h       |   45 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   55 +-
 tools/testing/selftests/kvm/lib/elf.c              |    3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   84 +-
 tools/testing/selftests/kvm/lib/perf_test_util.c   |    3 +
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   29 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |    8 +-
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |  186 ++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   13 +-
 .../kvm/memslot_modification_stress_test.c         |    6 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |  317 ++++--
 virt/kvm/Kconfig                                   |    6 +
 virt/kvm/dirty_ring.c                              |   46 +-
 virt/kvm/kvm_main.c                                |   65 +-
 91 files changed, 6073 insertions(+), 1773 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c
