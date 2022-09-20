Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE85BF0F7
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiITXRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiITXRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:17:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5058872874
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:17:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d82so4149989pfd.10
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=NdfL9W5NxvpNSJ2SoHnGTe5tTTGd1yf9FcjqLZQefvA=;
        b=mi2N4J0kRP7x1/aNZEDxuryC6deH9uZDLMYnZyy5Dj5pSThyXj879+Q86AiNJZirRF
         z5Z8LRoJait/EI8Sxw7JFqbCGS2LpYR56t7yalJTAD5kUcJpaqDQUtkOQqbTcvWgIdfq
         aao3FTwBo56tOL66K4WasnqHAKXERbFHExlrMN9P7zBAdnJ51XoBO7Y2GssRkGEkl7av
         IFQrehC8Bv6LDiXsRLShRcshtjE7Se8lp35pZbPmK/tDtgLrdx2URIi0zq1w4qDeeCOj
         5+QQKtc0oLl/TiAZfEKjpdyE2bZZYah9TzmgbnTnt3oPjgGYk37+o9iykcn1sJEQwrVi
         gkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NdfL9W5NxvpNSJ2SoHnGTe5tTTGd1yf9FcjqLZQefvA=;
        b=5qcaXA5qixeTgPVF0Vkpa0JjrhG20olTWWM6XcPeQqdHTFpLEOT6XdAli/O7Q/txFg
         G6ndl1IGF70fuZ3QS2KIUCNjBExQUifCvjeYld2SapOsdgOTk7yG6R9pmVVHDqKqpUc9
         bKoGWmicPaR7ZbL6BTtwOIdv1O0XrljhwwAUU2kWG4O4DpjEWqPINNwfxOZv1sW4S9PT
         japb66VSO2m+I/UyybtQy+48o5jdFSp2YzIHrrs+nwPb2K/i5voNmRYwuV9XOvJn3yd0
         WM6oPEC9gCMzWDLUlbY2UcWkfA0W5//ycg8w7VQaqoTcWAkufgXfI2geghoOhND8VbK8
         WWnw==
X-Gm-Message-State: ACrzQf1HBWt9R7GsYVJ2rUW3X2lXrvhvL7KZxdci7fkkfbA0ctGBvbUA
        x/9M86C50vdpOQwldDC0zhL/ng==
X-Google-Smtp-Source: AMsMyM6Mr0R+nsZQmU9e53ONQI722MYgJJu3iv3+v6icEG3Blc5KJzO+8Qn02xrLf6sGEWGdeB7f8w==
X-Received: by 2002:a63:8bc8:0:b0:438:bc9e:edc4 with SMTP id j191-20020a638bc8000000b00438bc9eedc4mr21824991pge.20.1663715823594;
        Tue, 20 Sep 2022 16:17:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090332c200b0015e8d4eb26esm430806plr.184.2022.09.20.16.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 16:17:03 -0700 (PDT)
Date:   Tue, 20 Sep 2022 23:16:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [GIT PULL] KVM: x86: First batch of updates for 6.1, i.e. kvm/queue
Message-ID: <YypJ62Q9bHXv07qg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First batch of x86 updates for 6.1, i.e. for kvm/queue.  I was planning to get
this out (much) earlier and in a smaller batch, but KVM Forum and the INIT bug
I initially missed in the nested events series threw a wrench in those plans.

Note, there's one arm64 patch hiding in here to account KVM's stage-2 page
tables in the kernel's memory stats.

For 6.1, I am planning/hoping on also grabbing:

  - APICv/AVIC fixes/cleanups (Sean)
  - The aforementioned nested events series (Paolo, Sean)
  - Hyper-V TLB flush enhancements (Vitaly)
  - Small-ish PMU fixes (Like, Sean)
  - Misc cleanups (Miaohe, et al)

There are also three patches/series that should probably go into 6.0, but if
that doesn't happen they definitely need to go into 6.1:

  https://lore.kernel.org/all/20220802071240.84626-1-cloudliang@tencent.com
  https://lore.kernel.org/all/20220907080657.42898-1-linmiaohe@huawei.com
  https://lore.kernel.org/all/20220824033057.3576315-1-seanjc@google.com

Thanks!


The following changes since commit 372d07084593dc7a399bf9bee815711b1fb1bcf2:

  KVM: selftests: Fix ambiguous mov in KVM_ASM_SAFE() (2022-08-19 07:38:05 -0400)

are available in the Git repository at:

  https://github.com/sean-jc/linux.git tags/kvm-x86-6.1-1

for you to fetch changes up to 5df50a4a9b60afba4dd2be76d0f0fb8ae8c9beab:

  KVM: x86: Allow force_emulation_prefix to be written without a reload (2022-09-20 12:40:25 -0700)

----------------------------------------------------------------
KVM x86 updates for 6.1, batch #1:

 - Account x86 and arm64 page table allocations in memory stats.

 - Tracepoint cleanups/fixes for nested VM-Enter and emulated MSR accesses.

 - Drop eVMCS controls filtering for KVM on Hyper-V, all known versions of
   Hyper-V now support eVMCS fields associated with features that are
   enumerated to the guest.

 - Use KVM's sanitized VMCS config to generate "default" nested VMX MSR
   values.

 - Myriad event/exception fixes and cleanups, most notably to morph pending
   exceptions to VM-Exits (if they're intercepted) when the exception is
   queued, e.g. to avoid incorrectly triggering #DF.

 - Precisely track NX huge page accounting.

 - A handful of fixes for memory leaks in error paths.

 - Cleanups for VMREAD trampoline and VMX's VM-Exit assembly flow.

 - Misc typo cleanups.

----------------------------------------------------------------
Aaron Lewis (1):
      KVM: x86: Delete duplicate documentation for KVM_X86_SET_MSR_FILTER

David Matlack (1):
      KVM: nVMX: Add tracepoint for nested VM-Enter

Hou Wenlong (2):
      KVM: x86: Return emulator error if RDMSR/WRMSR emulation failed
      KVM: x86: Add missing trace points for RDMSR/WRMSR in emulator path

Jilin Yuan (1):
      KVM: x86/mmu: fix repeated words in comments

Jim Mattson (1):
      KVM: x86: VMX: Replace some Intel model numbers with mnemonics

Jinpeng Cui (1):
      KVM: x86/mmu: remove superfluous local variable "r"

Junaid Shahid (1):
      kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init() fails

Liam Ni (1):
      KVM:x86: Clean up ModR/M "reg" initialization in reg op decoding

Miaohe Lin (2):
      KVM: x86/mmu: fix memoryleak in kvm_mmu_vendor_module_init()
      KVM: fix memoryleak in kvm_init()

Michal Luczaj (1):
      KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Mingwei Zhang (3):
      KVM: x86: Update trace function for nested VM entry to support VMX
      KVM: x86: Print guest pgd in kvm_nested_vmenter()
      KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()

Oliver Upton (1):
      KVM: selftests: Require DISABLE_NX_HUGE_PAGES cap for NX hugepage test

Paolo Bonzini (1):
      KVM: SVM: remove unnecessary check on INIT intercept

Sean Christopherson (44):
      KVM: x86: Use u64 for address and error code in page fault tracepoint
      KVM: x86: Check for existing Hyper-V vCPU in kvm_hv_vcpu_init()
      KVM: x86: Report error when setting CPUID if Hyper-V allocation fails
      KVM: nVMX: Treat eVMCS as enabled for guest iff Hyper-V is also enabled
      KVM: nVMX: Use CC() macro to handle eVMCS unsupported controls checks
      KVM: nVMX: WARN once and fail VM-Enter if eVMCS sees VMFUNC[63:32] != 0
      KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02
      KVM: nVMX: Always emulate PERF_GLOBAL_CTRL VM-Entry/VM-Exit controls
      KVM: VMX: Don't toggle VM_ENTRY_IA32E_MODE for 32-bit kernels/KVM
      KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not setup
      KVM: x86/mmu: Bug the VM if KVM attempts to double count an NX huge page
      KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
      KVM: x86/mmu: Rename NX huge pages fields/functions for consistency
      KVM: x86/mmu: Properly account NX huge page workaround for nonpaging MMUs
      KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting SPTE
      KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual pages
      KVM: x86/mmu: Add helper to convert SPTE value to its shadow page
      KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"
      KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS
      KVM: x86: Don't check for code breakpoints when emulating on exception
      KVM: x86: Allow clearing RFLAGS.RF on forced emulation to test code #DBs
      KVM: x86: Suppress code #DBs on Intel if MOV/POP SS blocking is active
      KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
      KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag
      KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)
      KVM: x86: Use DR7_GD macro instead of open coding check in emulator
      KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU is not in WFS
      KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit
      KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
      KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
      KVM: x86: Make kvm_queued_exception a properly named, visible struct
      KVM: x86: Formalize blocking of nested pending exceptions
      KVM: x86: Use kvm_queue_exception_e() to queue #DF
      KVM: x86: Hoist nested event checks above event injection logic
      KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after potential VM-Exit
      KVM: nVMX: Add a helper to identify low-priority #DB traps
      KVM: nVMX: Document priority of all known events on Intel CPUs
      KVM: x86: Morph pending exceptions to pending VM-Exits at queue time
      KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions
      KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle behavior
      KVM: x86: Rename inject_pending_events() to kvm_check_and_inject_events()
      KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
      KVM: selftests: Add an x86-only test to verify nested exception queueing
      KVM: x86: Allow force_emulation_prefix to be written without a reload

Uros Bizjak (2):
      KVM/VMX: Avoid stack engine synchronization uop in __vmx_vcpu_run
      KVM: VMX: Do not declare vmread_error() asmlinkage

Vitaly Kuznetsov (23):
      x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
      x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
      KVM: x86: Zero out entire Hyper-V CPUID cache before processing entries
      KVM: nVMX: Refactor unsupported eVMCS controls logic to use 2-d array
      KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
      KVM: nVMX: Support several new fields in eVMCSv1
      KVM: x86: hyper-v: Cache HYPERV_CPUID_NESTED_FEATURES CPUID leaf
      KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
      KVM: selftests: Switch to updated eVMCSv1 definition
      KVM: nVMX: Support PERF_GLOBAL_CTRL with enlightened VMCS
      KVM: VMX: Get rid of eVMCS specific VMX controls sanitization
      KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
      KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in setup_vmcs_config()
      KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
      KVM: VMX: Extend VMX controls macro shenanigans
      KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of setup_vmcs_config()
      KVM: VMX: Add missing VMEXIT controls to vmcs_config
      KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
      KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()
      KVM: nVMX: Always set required-1 bits of pinbased_ctls to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
      KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
      KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
      KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up nested MSR

Wonhyuk Yang (1):
      KVM: Add extra information in kvm_page_fault trace point

Yosry Ahmed (3):
      mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.
      KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
      KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats

ye xingchen (1):
      KVM: x86: Remove the unneeded "ret" in kvm_vm_ioctl_set_tss_addr()

 Documentation/admin-guide/cgroup-v2.rst                     |   5 +
 Documentation/filesystems/proc.rst                          |   4 +
 Documentation/virt/kvm/api.rst                              | 113 ++--------------------
 arch/arm64/kvm/mmu.c                                        |  36 ++++++-
 arch/x86/include/asm/hyperv-tlfs.h                          |  22 ++++-
 arch/x86/include/asm/kvm-x86-ops.h                          |   2 +-
 arch/x86/include/asm/kvm_host.h                             |  67 ++++++++------
 arch/x86/kvm/cpuid.c                                        |  18 +++-
 arch/x86/kvm/emulate.c                                      |  31 +++----
 arch/x86/kvm/hyperv.c                                       |  70 +++++++-------
 arch/x86/kvm/hyperv.h                                       |   6 +-
 arch/x86/kvm/mmu/mmu.c                                      | 142 ++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h                             |  33 +++----
 arch/x86/kvm/mmu/paging_tmpl.h                              |   8 +-
 arch/x86/kvm/mmu/spte.c                                     |  12 +++
 arch/x86/kvm/mmu/spte.h                                     |  17 ++++
 arch/x86/kvm/mmu/tdp_mmu.c                                  |  55 +++++++----
 arch/x86/kvm/mmu/tdp_mmu.h                                  |   2 +
 arch/x86/kvm/svm/nested.c                                   | 124 ++++++++++++-------------
 arch/x86/kvm/svm/svm.c                                      |  32 +++----
 arch/x86/kvm/trace.h                                        |  49 +++++++---
 arch/x86/kvm/vmx/capabilities.h                             |  14 +--
 arch/x86/kvm/vmx/evmcs.c                                    | 190 +++++++++++++++++++++++++------------
 arch/x86/kvm/vmx/evmcs.h                                    |  10 +-
 arch/x86/kvm/vmx/nested.c                                   | 435 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
 arch/x86/kvm/vmx/nested.h                                   |   2 +-
 arch/x86/kvm/vmx/sgx.c                                      |   2 +-
 arch/x86/kvm/vmx/vmenter.S                                  |  24 ++---
 arch/x86/kvm/vmx/vmx.c                                      | 315 ++++++++++++++++++++++++++++++--------------------------------
 arch/x86/kvm/vmx/vmx.h                                      | 172 +++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx_ops.h                                  |   2 +-
 arch/x86/kvm/x86.c                                          | 536 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 arch/x86/kvm/x86.h                                          |  11 ++-
 drivers/base/node.c                                         |   2 +
 fs/proc/meminfo.c                                           |   2 +
 include/linux/kvm_host.h                                    |  13 +++
 include/linux/mmzone.h                                      |   1 +
 mm/memcontrol.c                                             |   1 +
 mm/page_alloc.c                                             |   6 +-
 mm/vmstat.c                                                 |   1 +
 tools/testing/selftests/kvm/.gitignore                      |   1 +
 tools/testing/selftests/kvm/Makefile                        |   1 +
 tools/testing/selftests/kvm/include/x86_64/evmcs.h          |  45 ++++++++-
 tools/testing/selftests/kvm/include/x86_64/svm_util.h       |   7 +-
 tools/testing/selftests/kvm/include/x86_64/vmx.h            |  53 +----------
 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c | 295 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c     |  24 ++---
 virt/kvm/kvm_main.c                                         |   7 +-
 48 files changed, 1957 insertions(+), 1063 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
