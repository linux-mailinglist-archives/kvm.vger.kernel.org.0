Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AD26747B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 19:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfGLRoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 13:44:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36284 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbfGLRoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 13:44:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so5572847wme.1;
        Fri, 12 Jul 2019 10:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=p7pX/FqIHOnWiNSrnZqAdMVj6eE6J5y1TBm/upn0fD4=;
        b=tLwDV62XI3zqx3sYuVykrF+5RtoRfbFVXiRPsoZdGhGkcn6BjFnTqbaZCbbVOaboc8
         RfuHyNo8uYXhc8BPY7bNaTo9Avy/AlrL/nz4Mn0/gNcesRbWnvU1xumDhC3R/d6GvaT8
         iSuuTpB9iFXltyYAEtUzFr3QmGtPCfaCp9DgiNC4u8009ZGIgvaCHBApGfrjIJ49s0Ep
         wtc7UMsJQIpbkCQJEBiTvVSVw7cP2m6XsPHI67MoDyYZWX2OZ8e9UazbjLdZWFQxzTU0
         OBRDcXK+ltzobHGidr0xVkILw1P2WpoHd5j3iHSkefOfV779fwGVgWIxFa7LsrIINvgp
         CYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=p7pX/FqIHOnWiNSrnZqAdMVj6eE6J5y1TBm/upn0fD4=;
        b=a1FzYOONp8ua+HHau2+HB7l1ozAjzHp5BjZKj0TQJQovF6WDwB+h2BDlKaDVdIoRE/
         A22S+i8Yym4/SE+0wMImkY9YJ9mH7glQSefoQ6t/YP3kLhTBhyx/JDkBcJw4UtyFv5nM
         BFOs4gb1W8I+O1t7Z1qLbk3EYHifeFTwC31U3G6XdRRltphIl/zqgSyAwo9ld13TEYdA
         FmwBqBQScYUrFDMlQcwQlLcN/TN/QV5Vi7Lo+nL9P+31Y8TyWk19iH+D/06mJuOk+sXD
         bU6MggyTOknqm8LEGsyALVRw8pnveSsyjsUNtJzI1+3FSmvQZfNL6ZYlif9ZQ1WsMwG/
         G07w==
X-Gm-Message-State: APjAAAX3w7G/E0bLjanXjrfLWHVKPLi5N+DfnG3a0IKzMl4aJ2cEdv8T
        0SRoF/DlCByL9Aodre9BSgw+UXX0PFU=
X-Google-Smtp-Source: APXvYqy42DPzt6y8fYLodTo8gUNcxThsqZfzJzmFqdhehJBDBjUu37cLwUrtDbFScP3MfmeNaK5fmg==
X-Received: by 2002:a05:600c:34a:: with SMTP id u10mr10124024wmd.43.1562953465961;
        Fri, 12 Jul 2019 10:44:25 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p26sm12989686wrp.58.2019.07.12.10.44.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 10:44:25 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 5.3
Date:   Fri, 12 Jul 2019 19:44:24 +0200
Message-Id: <1562953464-55786-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 4b972a01a7da614b4796475f933094751a295a2f:

  Linux 5.2-rc6 (2019-06-22 16:01:36 -0700)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a45ff5994c9cde41af627c46abb9f32beae68943:

  Merge tag 'kvm-arm-for-5.3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2019-07-11 15:14:16 +0200)

----------------------------------------------------------------

ARM:
* support for chained PMU counters in guests
* improved SError handling
* handle Neoverse N1 erratum #1349291
* allow side-channel mitigation status to be migrated
* standardise most AArch64 system register accesses to msr_s/mrs_s
* fix host MPIDR corruption on 32bit
* selftests ckleanups

x86:
* PMU event {white,black}listing
* ability for the guest to disable host-side interrupt polling
* fixes for enlightened VMCS (Hyper-V pv nested virtualization),
* new hypercall to yield to IPI target
* support for passing cstate MSRs through to the guest
* lots of cleanups and optimizations

Generic:
* Some txt->rST conversions for the documentation

----------------------------------------------------------------

There are two trivial conflicts in ARM64 docs and includes.

Andre Przywara (3):
      arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests
      KVM: arm/arm64: Add save/restore support for firmware workaround state
      KVM: doc: Add API documentation on the KVM_REG_ARM_WORKAROUNDS register

Andrew Jones (3):
      kvm: selftests: ucall improvements
      kvm: selftests: introduce aarch64_vcpu_setup
      kvm: selftests: introduce aarch64_vcpu_add_default

Andrew Murray (5):
      KVM: arm/arm64: Rename kvm_pmu_{enable/disable}_counter functions
      KVM: arm/arm64: Extract duplicated code to own function
      KVM: arm/arm64: Re-create event when setting counter value
      KVM: arm/arm64: Remove pmc->bitmask
      KVM: arm/arm64: Support chained PMU counters

Dave Martin (1):
      KVM: arm64: Migrate _elx sysreg accessors to msr_s/mrs_s

Eric Hankland (1):
      KVM: x86: PMU Event Filter

Eugene Korenevsky (2):
      kvm: vmx: fix limit checking in get_vmx_mem_address()
      kvm: vmx: segment limit check: use access length

Gustavo A. R. Silva (1):
      KVM: irqchip: Use struct_size() in kzalloc()

James Morse (8):
      arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64_HAS_RAS
      KVM: arm64: Abstract the size of the HYP vectors pre-amble
      KVM: arm64: Make indirect vectors preamble behaviour symmetric
      KVM: arm64: Consume pending SError as early as possible
      KVM: arm64: Defer guest entry when an asynchronous exception is pending
      arm64: Update silicon-errata.txt for Neoverse-N1 #1349291
      KVM: arm64: Re-mask SError after the one instruction window
      KVM: arm64: Skip more of the SError vaxorcism

Jan Beulich (1):
      x86/kvm/VMX: drop bad asm() clobber from nested_vmx_check_vmentry_hw()

Jim Mattson (2):
      kvm: nVMX: Remove unnecessary sync_roots from handle_invept
      kvm: x86: Pass through AMD_STIBP_ALWAYS_ON in GET_SUPPORTED_CPUID

Junaid Shahid (2):
      kvm: Convert kvm_lock to a mutex
      kvm: x86: Do not release the page inside mmu_set_spte()

Kai Huang (2):
      kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
      kvm: x86: Fix reserved bits related calculation errors caused by MKTME

KarimAllah Ahmed (1):
      KVM: Properly check if "page" is valid in kvm_vcpu_unmap

Krish Sadhukhan (1):
      KVM nVMX: Check Host Segment Registers and Descriptor Tables on vmentry of nested guests

Like Xu (1):
      KVM: x86: Add Intel CPUID.1F cpuid emulation support

Liran Alon (1):
      KVM: x86: Use DR_TRAP_BITS instead of hard-coded 15

Luke Nowakowski-Krijger (3):
      Documentation: virtual: Convert paravirt_ops.txt to .rst
      Documentation: kvm: Convert cpuid.txt to .rst
      Documentation: virtual: Add toctree hooks

Marc Zyngier (1):
      KVM: arm/arm64: Initialise host's MPIDRs by reading the actual register

Marcelo Tosatti (1):
      kvm: x86: add host poll control msrs

Paolo Bonzini (25):
      kvm: selftests: hide vcpu_setup in processor code
      KVM: x86: clean up conditions for asynchronous page fault handling
      KVM: x86: move MSR_IA32_POWER_CTL handling to common code
      kvm: nVMX: small cleanup in handle_exception
      KVM: nVMX: Rename prepare_vmcs02_*_full to prepare_vmcs02_*_rare
      KVM: VMX: simplify vmx_prepare_switch_to_{guest,host}
      KVM: x86: introduce is_pae_paging
      KVM: nVMX: shadow pin based execution controls
      KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS
      KVM: nVMX: allow setting the VMFUNC controls MSR
      KVM: nVMX: list VMX MSRs in KVM_GET_MSR_INDEX_LIST
      Documentation: kvm: document CPUID bit for MSR_KVM_POLL_CONTROL
      KVM: svm: add nrips module parameter
      KVM: cpuid: do_cpuid_ent works on a whole CPUID function
      KVM: cpuid: extract do_cpuid_7_mask and support multiple subleafs
      KVM: cpuid: set struct kvm_cpuid_entry2 flags in do_cpuid_1_ent
      KVM: cpuid: rename do_cpuid_1_ent
      KVM: cpuid: remove has_leaf_count from struct kvm_cpuid_param
      KVM: x86: make FNAME(fetch) and __direct_map more similar
      KVM: x86: remove now unneeded hugepage gfn adjustment
      KVM: x86: change kvm_mmu_page_get_gfn BUG_ON to WARN_ON
      KVM: x86: add tracepoints around __direct_map and FNAME(fetch)
      KVM: LAPIC: ARBPRI is a reserved register for x2APIC
      kvm: LAPIC: write down valid APIC registers
      Merge tag 'kvm-arm-for-5.3' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD

Saar Amar (1):
      KVM: x86: Fix apic dangling pointer in vcpu

Sean Christopherson (41):
      KVM: Directly return result from kvm_arch_check_processor_compat()
      KVM: VMX: Fix handling of #MC that occurs during VM-Entry
      KVM: VMX: Read cached VM-Exit reason to detect external interrupt
      KVM: VMX: Store the host kernel's IDT base in a global variable
      KVM: x86: Move kvm_{before,after}_interrupt() calls to vendor code
      KVM: VMX: Handle NMIs, #MCs and async #PFs in common irqs-disabled fn
      KVM: nVMX: Intercept VMWRITEs to read-only shadow VMCS fields
      KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES
      KVM: nVMX: Track vmcs12 offsets for shadowed VMCS fields
      KVM: nVMX: Lift sync_vmcs12() out of prepare_vmcs12()
      KVM: nVMX: Use descriptive names for VMCS sync functions and flags
      KVM: nVMX: Add helpers to identify shadowed VMCS fields
      KVM: nVMX: Sync rarely accessed guest fields only when needed
      KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value
      KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
      KVM: nVMX: Write ENCLS-exiting bitmap once per vmcs02
      KVM: nVMX: Don't rewrite GUEST_PML_INDEX during nested VM-Entry
      KVM: nVMX: Don't "put" vCPU or host state when switching VMCS
      KVM: nVMX: Don't reread VMCS-agnostic state when switching VMCS
      KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped
      KVM: nVMX: Don't speculatively write virtual-APIC page address
      KVM: nVMX: Don't speculatively write APIC-access page address
      KVM: nVMX: Update vmcs12 for MSR_IA32_CR_PAT when it's written
      KVM: nVMX: Update vmcs12 for SYSENTER MSRs when they're written
      KVM: nVMX: Update vmcs12 for MSR_IA32_DEBUGCTLMSR when it's written
      KVM: nVMX: Don't update GUEST_BNDCFGS if it's clean in HV eVMCS
      KVM: nVMX: Copy PDPTRs to/from vmcs12 only when necessary
      KVM: nVMX: Use adjusted pin controls for vmcs02
      KVM: VMX: Add builder macros for shadowing controls
      KVM: VMX: Shadow VMCS pin controls
      KVM: VMX: Shadow VMCS primary execution controls
      KVM: VMX: Shadow VMCS secondary execution controls
      KVM: nVMX: Shadow VMCS controls on a per-VMCS basis
      KVM: nVMX: Don't reset VMCS controls shadow on VMCS switch
      KVM: VMX: Explicitly initialize controls shadow at VMCS allocation
      KVM: nVMX: Preserve last USE_MSR_BITMAPS when preparing vmcs02
      KVM: nVMX: Preset *DT exiting in vmcs02 when emulating UMIP
      KVM: VMX: Drop hv_timer_armed from 'struct loaded_vmcs'
      KVM: VMX: Leave preemption timer running when it's disabled
      KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on nested entry w/o EPT
      KVM: x86: Unconditionally enable irqs in guest context

Suthikulpanit, Suravee (1):
      kvm: svm/avic: Do not send AVIC doorbell to self

Uros Bizjak (1):
      KVM: VMX: remove unneeded 'asm volatile ("")' from vmcs_write64

Vitaly Kuznetsov (3):
      KVM/nSVM: properly map nested VMCB
      x86/KVM/nVMX: don't use clean fields data on enlightened VMLAUNCH
      x86/kvm/nVMX: fix VMCLEAR when Enlightened VMCS is in use

Wanpeng Li (12):
      KVM: LAPIC: Extract adaptive tune timer advancement logic
      KVM: LAPIC: Delay trace_kvm_wait_lapic_expire tracepoint to after vmexit
      KVM: LAPIC: Optimize timer latency further
      KVM: Documentation: Add disable pause exits to KVM_CAP_X86_DISABLE_EXITS
      KVM: X86: Provide a capability to disable cstate msr read intercepts
      KVM: X86: Emulate MSR_IA32_MISC_ENABLE MWAIT bit
      KVM: VMX: check CPUID before allowing read/write of IA32_XSS
      KVM: X86: Yield to IPI target if necessary
      KVM: X86: Implement PV sched yield hypercall
      KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
      KVM: LAPIC: remove the trailing newline used in the fmt parameter of TP_printk
      KVM: LAPIC: Retry tune per-vCPU timer_advance_ns if adaptive tuning goes insane

Wei Yang (3):
      kvm: x86: check kvm_apic_sw_enabled() is enough
      kvm: x86: use same convention to name kvm_lapic_{set,clear}_vector()
      kvm: x86: offset is ensure to be in range

Xiaoyao Li (1):
      kvm: x86: refine kvm_get_arch_capabilities()

Yi Wang (1):
      kvm: x86: Fix -Wmissing-prototypes warnings

 Documentation/arm64/silicon-errata.txt             |   1 +
 Documentation/virtual/index.rst                    |  18 +
 Documentation/virtual/kvm/api.txt                  |  28 +
 Documentation/virtual/kvm/arm/psci.txt             |  31 +
 Documentation/virtual/kvm/cpuid.rst                | 107 +++
 Documentation/virtual/kvm/cpuid.txt                |  83 ---
 Documentation/virtual/kvm/hypercalls.txt           |  11 +
 Documentation/virtual/kvm/index.rst                |  11 +
 Documentation/virtual/kvm/locking.txt              |   4 +-
 Documentation/virtual/kvm/msr.txt                  |   9 +
 .../virtual/{paravirt_ops.txt => paravirt_ops.rst} |  19 +-
 arch/arm/include/asm/kvm_emulate.h                 |  10 +
 arch/arm/include/asm/kvm_host.h                    |  18 +-
 arch/arm/include/asm/kvm_hyp.h                     |  13 +-
 arch/arm/include/uapi/asm/kvm.h                    |  12 +
 arch/arm64/include/asm/assembler.h                 |   4 +
 arch/arm64/include/asm/cpufeature.h                |   6 +
 arch/arm64/include/asm/kvm_asm.h                   |   6 +
 arch/arm64/include/asm/kvm_emulate.h               |  30 +-
 arch/arm64/include/asm/kvm_host.h                  |  23 +-
 arch/arm64/include/asm/kvm_hyp.h                   |  50 +-
 arch/arm64/include/asm/sysreg.h                    |  35 +-
 arch/arm64/include/uapi/asm/kvm.h                  |  10 +
 arch/arm64/kernel/cpu_errata.c                     |  23 +-
 arch/arm64/kernel/traps.c                          |   4 +
 arch/arm64/kvm/hyp/entry.S                         |  36 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |  30 +-
 arch/arm64/kvm/hyp/switch.c                        |  14 +-
 arch/arm64/kvm/hyp/sysreg-sr.c                     |  78 +--
 arch/arm64/kvm/hyp/tlb.c                           |  12 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   2 +-
 arch/arm64/kvm/regmap.c                            |   4 +-
 arch/arm64/kvm/sys_regs.c                          |  60 +-
 arch/arm64/kvm/va_layout.c                         |   7 +-
 arch/mips/kvm/mips.c                               |   4 +-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/s390/include/asm/kvm_host.h                   |   1 -
 arch/s390/kvm/kvm-s390.c                           |   9 +-
 arch/x86/include/asm/kvm_host.h                    |  11 +-
 arch/x86/include/uapi/asm/kvm.h                    |  19 +-
 arch/x86/include/uapi/asm/kvm_para.h               |   3 +
 arch/x86/include/uapi/asm/vmx.h                    |   1 -
 arch/x86/kernel/kvm.c                              |  21 +
 arch/x86/kvm/Kconfig                               |   1 +
 arch/x86/kvm/cpuid.c                               | 247 ++++---
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/irq.h                                 |   1 -
 arch/x86/kvm/irq_comm.c                            |   2 +-
 arch/x86/kvm/lapic.c                               | 123 ++--
 arch/x86/kvm/lapic.h                               |   8 +-
 arch/x86/kvm/mmu.c                                 | 182 +++--
 arch/x86/kvm/mmutrace.h                            |  59 ++
 arch/x86/kvm/paging_tmpl.h                         |  42 +-
 arch/x86/kvm/pmu.c                                 |  63 ++
 arch/x86/kvm/pmu.h                                 |   1 +
 arch/x86/kvm/svm.c                                 |  51 +-
 arch/x86/kvm/trace.h                               |   2 +-
 arch/x86/kvm/vmx/evmcs.c                           |  18 +
 arch/x86/kvm/vmx/evmcs.h                           |   1 +
 arch/x86/kvm/vmx/nested.c                          | 763 +++++++++++++--------
 arch/x86/kvm/vmx/nested.h                          |   4 +-
 arch/x86/kvm/vmx/ops.h                             |   1 -
 arch/x86/kvm/vmx/vmcs.h                            |  17 +-
 arch/x86/kvm/vmx/vmcs12.h                          |  57 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h              |  79 ++-
 arch/x86/kvm/vmx/vmx.c                             | 449 ++++++------
 arch/x86/kvm/vmx/vmx.h                             | 124 ++--
 arch/x86/kvm/x86.c                                 | 229 +++++--
 arch/x86/kvm/x86.h                                 |  10 +
 include/kvm/arm_pmu.h                              |  11 +-
 include/linux/kvm_host.h                           |   5 +-
 include/uapi/linux/kvm.h                           |   7 +-
 include/uapi/linux/kvm_para.h                      |   1 +
 tools/include/uapi/linux/kvm.h                     |   4 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |   3 +-
 .../selftests/kvm/include/aarch64/processor.h      |   4 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   3 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  50 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   9 +-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   2 -
 tools/testing/selftests/kvm/lib/ucall.c            |  19 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   5 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |   2 +-
 .../selftests/kvm/x86_64/kvm_create_max_vcpus.c    |   2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c      |   2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |   2 +-
 virt/kvm/arm/arch_timer.c                          |  24 +-
 virt/kvm/arm/arm.c                                 |   7 +-
 virt/kvm/arm/pmu.c                                 | 350 ++++++++--
 virt/kvm/arm/psci.c                                | 149 +++-
 virt/kvm/irqchip.c                                 |   4 +-
 virt/kvm/kvm_main.c                                |  41 +-
 92 files changed, 2692 insertions(+), 1432 deletions(-)
 create mode 100644 Documentation/virtual/index.rst
 create mode 100644 Documentation/virtual/kvm/cpuid.rst
 delete mode 100644 Documentation/virtual/kvm/cpuid.txt
 create mode 100644 Documentation/virtual/kvm/index.rst
 rename Documentation/virtual/{paravirt_ops.txt => paravirt_ops.rst} (65%)
