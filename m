Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF135806DE
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 23:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiGYVgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 17:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiGYVgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 17:36:32 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0351FDF18
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 14:36:32 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d7so11576934plr.9
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 14:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=+doZQZxlMuEhcuGqqQ5/oeWImu28Ka3xLPG/pHfx2Us=;
        b=ETOYeW+ZiIVv0xkK4OmMjejlWg5TXLJW+TIeCNLlaBamklI5+QyXeMzu1p54WohUIU
         bGOlLLDgw/fO1fJryhFkdwL2/zs7DPqEqlgmmNyiQYBK+DPNd/1ReWrEl/FRdJCF5YmU
         sRHE1Kkxop65iBVF8C2f8O2ftkdwxUt/yf8uUAJGNwGDYdNLqOIpL96Cv0p797e0Bz1C
         EHUsvJbCfutgEZbc+pOSeWDDOmVNNgiGsWszmFwCDp45kwI378zgJOu+iJOG0PXFFtNb
         tl8ICuNXXUJ0Jc+/mN12hQPo5jIIC2FfTUaEzX05Hr5GzyNLWYP2i+xU4jNnKkwtC2wZ
         /MCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=+doZQZxlMuEhcuGqqQ5/oeWImu28Ka3xLPG/pHfx2Us=;
        b=XJQENYNHg9oF19Ur+uElVFC7dLC2LvNHkyJ2hIRR1Bq9bzFlUT0Lq2dkumXeA8u4HG
         jzhKNXCin9lwEYqNi1Cz9sxGLo6NizOIk2e+/KfHdDGdVxeoZCuz3/Y7pR4KKSYSofpM
         rbre+2RoHeX14CvU4+2WWgVjQ17osQ15YsxWvSDSIBfXohWX6Wb5Ry8I9BSaR09DNyw5
         TLPVIQnbQNtHgq3/nzGx7M3zY4mwHwNmLwVUO9E82dprTXxdrzxQ78umKLbjxPEseHe1
         v9bMehR/IN+Cu8faP/zVX4cRRMt95BNbwT8vdqKXuHb8CC7ZJa3sap78vWJyKg6q5IsP
         FrIQ==
X-Gm-Message-State: AJIora9n9Xq/ossinpgTutEdg+84LUU9qTv5E6l3J4d5wfE5TaqPewES
        HXGtxg7gthk8VD63zuN9PuPnEoEENeFBpQ==
X-Google-Smtp-Source: AGRyM1tQKzU7rC0i1R158UDwQjHG7rS5u1pJl9URTO0ks10MoIA+CpEi5BrZtETVYxWkGd6cKBfADA==
X-Received: by 2002:a17:90b:4d11:b0:1f0:414b:586e with SMTP id mw17-20020a17090b4d1100b001f0414b586emr34291262pjb.111.1658784991354;
        Mon, 25 Jul 2022 14:36:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902e30c00b0016bdb5a3e37sm9590309plc.250.2022.07.25.14.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 14:36:30 -0700 (PDT)
Date:   Mon, 25 Jul 2022 21:36:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>,
        Manali Shukla <manali.shukla@amd.com>,
        Jim Mattson <jmattson@google.com>
Subject: [kvm-unit-tests GIT PULL v2] x86: Fixes, cleanups, and new sub-tests
Message-ID: <Yt8M2yxuZ3kZFySA@google.com>
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

Attempt #2.  Only difference is the addition of two patches[*] (effectively just
one when all is said and done) to fix the x2APIC+INIT+SIPI SVM test bug.

[*] https://lore.kernel.org/all/20220725201336.2158604-1-seanjc@google.com


The following changes since commit 7b2e41767bb8caf91972ee32e4ca85ec630584e2:

  Merge branch 's390x-next-2022-07' into 'master' (2022-07-21 14:41:56 +0000)

are available in the Git repository at:

  https://github.com/sean-jc/kvm-unit-tests.git tags/for_paolo

for you to fetch changes up to f7b730bcac4432f9ea239faeb963392d1854b9b0:

  nVMX: Add subtest to verify VMXON succeeds/#UDs on good/bad CR0/CR4 (2022-07-25 13:20:29 -0700)

----------------------------------------------------------------
x86 fixes, cleanups, and new sub-tests:

  - Bug fix for the VMX-preemption timer expiration test
  - Refactor SVM tests to split out NPT tests
  - Add tests for MCE banks to MSR test
  - Add SMP Support for x86 UEFI tests
  - x86: nVMX: Add VMXON #UD test (and exception cleanup)
  - PMU cleanup and related nVMX bug fixes

----------------------------------------------------------------
Jim Mattson (1):
      x86: VMX: Fix the VMX-preemption timer expiration test

Manali Shukla (5):
      x86: nSVM: Extract core functionality of main() to helper run_svm_tests()
      x86: Add flags to control behavior of set_mmu_range()
      x86: nSVM: Build up the nested page table dynamically
      x86: nSVM: Correct indentation for svm.c
      x86: nSVM: Correct indentation for svm_tests.c

Sean Christopherson (23):
      x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate file.
      x86: nSVM: Run non-NPT nSVM tests with PT_USER_MASK enabled
      x86: nSVM: Add macros to create SVM's NPT tests, reduce boilerplate code
      x86: msr: Take the MSR index and name separately in low level helpers
      x86: msr: Add tests for MCE bank MSRs
      x86: Use an explicit magic string to detect that dummy.efi passes
      x86: apic: Play nice with x2APIC being enabled when getting "pre-boot" ID
      x86: cstart64: Put APIC into xAPIC after loading TSS
      x86: Rename ap_init() to bringup_aps()
      x86: Add ap_online() to consolidate final "AP is alive!" code
      x86: Use BIT() to define architectural bits
      x86: Replace spaces with tables in processor.h
      x86: Use "safe" terminology instead of "checking"
      x86: Use "safe" helpers to implement unsafe CRs accessors
      x86: Provide result of RDMSR from "safe" variant
      nVMX: Check the results of VMXON/VMXOFF in feature control test
      nVMX: Check result of VMXON in INIT/SIPI tests
      nVMX: Wrap VMXON in ASM_TRY(), a.k.a. in exception fixup
      nVMX: Simplify test_vmxon() by returning directly on failure
      x86: Drop cpuid_osxsave(), just use this_cpu_has(X86_FEATURE_OSXSAVE)
      nVMX: Move wrappers of this_cpu_has() to nVMX's VM-Exit test
      nVMX: Rename monitor_support() to this_cpu_has_mwait(), drop #define
      nVMX: Add subtest to verify VMXON succeeds/#UDs on good/bad CR0/CR4

Varad Gautam (10):
      x86: Share realmode trampoline between i386 and x86_64
      x86: Move ap_init() to smp.c
      x86: Move load_idt() to desc.c
      x86: desc: Split IDT entry setup into a generic helper
      x86: Move load_gdt_tss() to desc.c
      x86: efi: Provide a stack within testcase memory
      x86: efi: Provide percpu storage
      x86: Move 32-bit => 64-bit transition code to trampolines.S
      x86: efi, smp: Transition APs from 16-bit to 32-bit mode
      x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI

Yang Weijiang (4):
      x86: nVMX: Use report_skip() to print messages when VMX tests are skipped
      x86: Use helpers to fetch supported perf capabilities
      x86: Skip perf related tests when platform cannot support
      x86: Check platform pmu capabilities before run lbr tests

 lib/alloc_page.h          |    3 +
 lib/x86/apic.c            |   16 +-
 lib/x86/asm/setup.h       |    3 +
 lib/x86/desc.c            |   46 +-
 lib/x86/desc.h            |    5 +-
 lib/x86/processor.h       |  455 +++++++++++--------
 lib/x86/setup.c           |   81 +++-
 lib/x86/smp.c             |  150 ++++++-
 lib/x86/smp.h             |   11 +
 lib/x86/vm.c              |   22 +-
 lib/x86/vm.h              |   10 +
 scripts/runtime.bash      |    2 +-
 x86/Makefile.common       |    2 +
 x86/Makefile.x86_64       |    2 +
 x86/access.c              |    8 +-
 x86/cstart.S              |   48 +-
 x86/cstart64.S            |  127 +-----
 x86/dummy.c               |    8 +
 x86/efi/crt0-efi-x86_64.S |    3 +
 x86/efi/efistart64.S      |   79 ++--
 x86/la57.c                |    2 +-
 x86/msr.c                 |  113 ++++-
 x86/pcid.c                |   28 +-
 x86/pmu.c                 |  116 ++---
 x86/pmu_lbr.c             |   35 +-
 x86/rdpru.c               |    4 +-
 x86/svm.c                 |  219 ++++-----
 x86/svm.h                 |    5 +-
 x86/svm_npt.c             |  380 ++++++++++++++++
 x86/svm_tests.c           | 3365 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------
 x86/trampolines.S         |  129 ++++++
 x86/unittests.cfg         |    6 +
 x86/vmexit.c              |   12 +-
 x86/vmx.c                 |  141 ++++--
 x86/vmx.h                 |   31 +-
 x86/vmx_tests.c           |  136 +++---
 x86/xsave.c               |   31 +-
 37 files changed, 3170 insertions(+), 2664 deletions(-)
 create mode 100644 x86/svm_npt.c
 create mode 100644 x86/trampolines.S
