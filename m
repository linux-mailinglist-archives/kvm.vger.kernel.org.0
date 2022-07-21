Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE48257D59A
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 23:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbiGUVNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 17:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGUVNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 17:13:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEC64E61D
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:13:22 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y9so2833683pff.12
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=R29vX9lnm5E2ALoXSODPX5B+OVWYf2pEM47zs8qVmSg=;
        b=bZDcAodXUszt0aajt8ki4D5pEYTGP8OfncVNA7G8D22pyVU3pirrIuiteI+gWBlzLj
         QcFz8G8Oqx6i0OPOS68raMUHqkG+47C+kOyB/gGSY3alf0mCKmOOc+x17XDP6tGj14XD
         JMuS+sAB+aRGgweV4I5GI2RSIgwbVYXwHT3QQq/Al5/6UEGXKijGz2KzsiOvXI9O4PnT
         dVzjFfcW1JTf4rr9hnTNUTw+6tblEv7E5vWvX3kmT2DJeBUBLTOJV9LuyDpt2401zZe8
         S6tDkQMa+w+qCOtTt9EkaCptVudsbt/LbBAlMpCAKTH1p5f4XjrZUxoyEQHwsxaHHfNh
         3+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=R29vX9lnm5E2ALoXSODPX5B+OVWYf2pEM47zs8qVmSg=;
        b=VTiNPMp2Fqox86i8uZ+pEZjYELNFeagpkU0kncU1XXgI0CiZUqf21VPCn8ZxzPioDv
         n4IKMS9oZzMnCNaflmHM8i+G+5V1u23gd32IIkLhYrapgGoDP7yHVDk5IHqDunnzQvjR
         CM5bQYtL2MsWdUi5DzcdM1fsnwpMaZYCAxBVpY37qkeos2T3DjzubVOJGH0Q/9GBD3W2
         TrrwxwG2UFkjJ1jDratQeP/dOmnALhPA4BQJ6Bwj8IxX6dSgSbl41jwiBlfRnJUgBqfX
         Y4fxS6YeZaSVrEoLAGP8532PoAE72ZJDjGtOFl1zQJhKbnZIAfhY7G/+lt3tKe6NLHt/
         9jjQ==
X-Gm-Message-State: AJIora/uDcTHPj0uiIqert4WU7TA7eRQGrGH8BUi4xQvmA1J3CdtyhY7
        Uf9sXZq/gIjBnf5uKj/Myx7I6uBt764WUw==
X-Google-Smtp-Source: AGRyM1vvwnf0xP9I413DnNsLihWazs524W/N+ugGu704FGmbrpVYunEdqhvwPAPiT5iMJOd2l1kH5w==
X-Received: by 2002:a05:6a00:14d2:b0:52a:d2a1:5119 with SMTP id w18-20020a056a0014d200b0052ad2a15119mr139224pfu.36.1658438002082;
        Thu, 21 Jul 2022 14:13:22 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id jj6-20020a170903048600b00161947ecc82sm2144660plb.199.2022.07.21.14.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:13:21 -0700 (PDT)
Date:   Thu, 21 Jul 2022 21:13:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>,
        Manali Shukla <manali.shukla@amd.com>,
        Jim Mattson <jmattson@google.com>
Subject: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new sub-tests
Message-ID: <YtnBbb1pleBpIl2J@google.com>
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

Please pull/merge a pile of x86 cleanups and fixes, most of which have been
waiting for review/merge for quite some time.  The only non-trivial changes that
haven't been posted are the massaged version of the PMU cleanup patches.

Note, the very last commit will fail spectacularly on kvm/queue due to a KVM
bug: https://lore.kernel.org/all/20220607213604.3346000-4-seanjc@google.com.

Other than that, tested on Intel and AMD, both 64-bit and 32-bit.

Thanks!


The following changes since commit 7b2e41767bb8caf91972ee32e4ca85ec630584e2:

  Merge branch 's390x-next-2022-07' into 'master' (2022-07-21 14:41:56 +0000)

are available in the Git repository at:

  https://github.com/sean-jc/kvm-unit-tests.git tags/for_paolo

for you to fetch changes up to ff081d8ad4a4e53a9d129cde1bc9f249d65cdf32:

  nVMX: Add subtest to verify VMXON succeeds/#UDs on good/bad CR0/CR4 (2022-07-21 13:33:16 -0700)

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

Sean Christopherson (21):
      x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate file.
      x86: nSVM: Run non-NPT nSVM tests with PT_USER_MASK enabled
      x86: nSVM: Add macros to create SVM's NPT tests, reduce boilerplate code
      x86: msr: Take the MSR index and name separately in low level helpers
      x86: msr: Add tests for MCE bank MSRs
      x86: Use an explicit magic string to detect that dummy.efi passes
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
 lib/x86/apic.c            |    2 -
 lib/x86/asm/setup.h       |    3 +
 lib/x86/desc.c            |   46 +-
 lib/x86/desc.h            |    5 +-
 lib/x86/processor.h       |  455 +++++++++++--------
 lib/x86/setup.c           |   82 +++-
 lib/x86/smp.c             |  150 ++++++-
 lib/x86/smp.h             |   11 +
 lib/x86/vm.c              |   22 +-
 lib/x86/vm.h              |   10 +
 scripts/runtime.bash      |    2 +-
 x86/Makefile.common       |    2 +
 x86/Makefile.x86_64       |    2 +
 x86/access.c              |    8 +-
 x86/cstart.S              |   48 +-
 x86/cstart64.S            |  125 +-----
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
 37 files changed, 3161 insertions(+), 2658 deletions(-)
 create mode 100644 x86/svm_npt.c
 create mode 100644 x86/trampolines.S
