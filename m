Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D665B628AFF
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 22:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbiKNVDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 16:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiKNVDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 16:03:23 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C4C101C2
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:03:21 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id y203so12230166pfb.4
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=its+pARkJYA7xNWGB1Ehdxix5JvTMzadoEg9pZYyusA=;
        b=KsQnIXo6w0o4/Oz07LP4Cb/vCsRUucSEwq7AbtlgRmYrBPpij7a5M+JN7WKLpvEgYU
         /IPFFg8W+0M3BphKWPnMOXmUxuwMtZvqR36b+xJeVKjpQoX0pL7Iz8jOiacYi4nkwyIR
         da4vyyawpjhkACNUGM05Ta5t0ted13jdBjGnRe5mn3iQOSCDMKEhIpdxshctf3kyAQcB
         zPKuPhiyY5x+ai4fspVEXStXGYgLfirZWQ50JDXgmJo0u/9ftGC8SZiYJzkxKwxx/TEb
         f16uG4PXxkJDNWfy75BcKqw0n6QI/PyAFG1npVmGK2wp1+NJKaaULA1kbotwU/WlgSM5
         FRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=its+pARkJYA7xNWGB1Ehdxix5JvTMzadoEg9pZYyusA=;
        b=a/9zAuljlDwUOolooUaF4BZcUaaFHXWCS8du5xFEzDpyTjhI+Kjp6NuAzrbpWuuqm1
         F+y2taLqT75YZFXNEphLVL0cSz4DifI2+cPM/WLn6GQFqZubOVniFjLJp27vgiejtI5i
         FClFoC8eH4hUpVP+iE13C9BRBglTO50HovDHsn9y62i6wZv0mkWhOTQFj1moRs+wrbph
         srdyWXAYyty0zxxE56QVMdPLQPdzgeaiag0E/G0bYJp3dB9Ic0t7GMGm8MUvCEMmbYX5
         DVqlvnVASfS+7XaO3KqaQQ3fYHHZqJpFZmy/KnnDHRX7tUp6pB1Dx43qlm3bY1aONg+2
         zKyA==
X-Gm-Message-State: ANoB5pluK60bl07VpKAy+2UzTrQk8MZolX9W4wAB7SWzeeiB/TGbZEyO
        bussBiBwsRVlTUz+HQCev2AMOQ==
X-Google-Smtp-Source: AA0mqf6Ta0FLZqP5jdzO+71o665K8cHbIj6djMcgwIbsMszSq6pjLJAZJxXhxpWJQD20qrIJpF73Ow==
X-Received: by 2002:a63:4d61:0:b0:44b:412c:1a3c with SMTP id n33-20020a634d61000000b0044b412c1a3cmr12895204pgl.417.1668459800991;
        Mon, 14 Nov 2022 13:03:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a17090a9dcb00b001faafa42a9esm6864622pjv.26.2022.11.14.13.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 13:03:20 -0800 (PST)
Date:   Mon, 14 Nov 2022 21:03:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new sub-tests
Message-ID: <Y3KtFCBIQFHl1uOJ@google.com>
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
waiting for review/merge for quite some time.  The SEV-ES fix in particular
is semi-urgent as some Google folks spent a few days re-debugging the issue.

The big PMU cleanup is included here even though you had previously said it was
pulled, as there are/were superficial conflicts with the nSVM/nVMX exception
changes.  I went with a slightly different resolution for the !PERFCTR_CORE AMD
PMU fix; it seemed more intuitive/correct to switch on PERFCTR_CORE before
querying v2. This is what I ended up with (and actually tested this time):

		if (this_cpu_has(X86_FEATURE_PERFCTR_CORE)) {
			/* Performance Monitoring Version 2 Supported */
			if (this_cpu_has(X86_FEATURE_AMD_PMU_V2)) {
				pmu.version = 2;
				pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
			} else {
				pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
			}
			pmu.msr_gp_counter_base = MSR_F15H_PERF_CTR0;
			pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
		} else {
			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
			pmu.msr_gp_counter_base = MSR_K7_PERFCTR0;
			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
		}

The new "xapic" test will fail without the corresponding KVM fixes[*], but those
fixes are a bit overdue as well.

[*] https://lore.kernel.org/all/20221001005915.2041642-1-seanjc@google.com

 
The following changes since commit 73d9d850f1c2c9f0df321967e67acda0d2c305ea:

  x86/pmu: Disable inlining of measure() (2022-11-02 18:37:16 +0100)

are available in the Git repository at:

  https://github.com/kvm-x86/kvm-unit-tests tags/for_paolo

for you to fetch changes up to 952cf19c9143e307fe229af8bf909016a02fcc6c:

  x86/pmu: Add AMD Guest PerfMonV2 testcases (2022-11-14 11:00:13 -0800)

----------------------------------------------------------------
x86 fixes, cleanups, and new sub-tests:

 - PMU fixes and cleanups
 - PMU support for AMD CPUs
 - PMU PEBS tests
 - APIC logical ID tests
 - xAPIC ID aliasing test
 - nSVM exception tests (and dedup of nVMX code)
 - Bug fix for VMREAD/VMWRITE #PF tests
 - MOV/POP SS code #DB test
 - Bug fix for SEV-ES guests (#VC before IDT is configured)

----------------------------------------------------------------
Like Xu (22):
      x86/pmu: Add PDCM check before accessing PERF_CAP register
      x86/pmu: Test emulation instructions on full-width counters
      x86/pmu: Pop up FW prefix to avoid out-of-context propagation
      x86/pmu: Report SKIP when testing Intel LBR on AMD platforms
      x86/pmu: Fix printed messages for emulated instruction test
      x86/pmu: Introduce __start_event() to drop all of the manual zeroing
      x86/pmu: Introduce multiple_{one, many}() to improve readability
      x86/pmu: Reset the expected count of the fixed counter 0 when i386
      x86: create pmu group for quick pmu-scope testing
      x86/pmu: Refine info to clarify the current support
      x86/pmu: Update rdpmc testcase to cover #GP path
      x86/pmu: Rename PC_VECTOR to PMI_VECTOR for better readability
      x86/pmu: Add lib/x86/pmu.[c.h] and move common code to header files
      x86/pmu: Snapshot PMU perf_capabilities during BSP initialization
      x86/pmu: Track GP counter and event select base MSRs in pmu_caps
      x86/pmu: Add helper to get fixed counter MSR index
      x86/pmu: Track global status/control/clear MSRs in pmu_caps
      x86: Add tests for Guest Processor Event Based Sampling (PEBS)
      x86/pmu: Add global helpers to cover Intel Arch PMU Version 1
      x86/pmu: Add gp_events pointer to route different event tables
      x86/pmu: Update testcases to cover AMD PMU
      x86/pmu: Add AMD Guest PerfMonV2 testcases

Manali Shukla (4):
      x86: nSVM: Add an exception test framework and tests
      x86: nSVM: Move #BP test to exception test framework
      x86: nSVM: Move #OF test to exception test framework
      x86: nSVM: Move part of #NM test to exception test framework

Michal Luczaj (1):
      x86/emulator: Test code breakpoint with MOV/POP-SS blocking active

Sean Christopherson (27):
      x86/emulator: Delete unused declarations (copy-pasted from realmode.c)
      x86/emulator: Move basic "MOV" test to its own helper function
      x86/emulator: Make chunks of "emulator" test 32-bit friendly
      x86/emulator: Convert remaining spaces to tabs (indentation)
      x86: Handle all known exceptions with ASM_TRY()
      nVMX: Use ASM_TRY() for VMREAD and VMWRITE page fault tests
      nVMX: Dedup the bulk of the VMREAD/VMWRITE #PF tests
      nVMX: Add "nop" after setting EFLAGS.TF to guarantee single-step #DB
      x86: Move helpers to generate misc exceptions to processor.h
      nVMX: Move #OF test to generic exceptions test
      nVMX: Drop one-off INT3=>#BP test
      nVMX: Move #NM test to generic exception test framework
      nVMX: Expect #GP on VMXON with "generic" invalid CR0/CR4 bits
      x86/apic: Add test config to allow running apic tests against SVM's AVIC
      x86/apic: Replaces spaces with tabs to fix indentation in apic.c
      x86/apic: Add helpers to query current APIC state, e.g. xAPIC vs. x2APIC
      x86/apic: Assert that vCPU0's APIC is enabled at the start of the test
      x86/apic: Restore APIC to original state after every sub-test
      x86/apic: Enable IRQs on vCPU0 for all tests
      x86/apic: Run tests that modify APIC ID and/or APIC_BASE after other tests
      x86/apic: Add test for logical mode IPI delivery (cluster and flat)
      x86/apic: Add test to verify aliased xAPIC IDs both receive IPI
      x86: Add a helper for the BSP's final init sequence common to all flavors
      x86/pmu: Snapshot CPUID.0xA PMU capabilities during BSP initialization
      x86/pmu: Drop wrappers that just passthrough pmu_caps fields
      x86/pmu: Reset GP and Fixed counters during pmu_init().
      x86/pmu: Add pmu_caps flag to track if CPU is Intel (versus AMD)

Vasant Karasulli (1):
      x86: efi: set up the IDT before accessing MSRs.

 lib/x86/asm/setup.h |   1 +
 lib/x86/desc.c      |  10 +-
 lib/x86/msr.h       |  30 +++++
 lib/x86/pmu.c       |  69 +++++++++++
 lib/x86/pmu.h       | 187 +++++++++++++++++++++++++++++
 lib/x86/processor.h | 120 ++++++++++++++-----
 lib/x86/setup.c     |  33 ++++--
 x86/Makefile.common |   2 +
 x86/Makefile.x86_64 |   3 +-
 x86/apic.c          | 940 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------
 x86/cstart.S        |   4 +-
 x86/cstart64.S      |   4 +-
 x86/emulator.c      | 921 +++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------------------------------
 x86/emulator64.c    | 464 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/pmu.c           | 360 ++++++++++++++++++++++++++++++++------------------------
 x86/pmu_lbr.c       |  24 +---
 x86/pmu_pebs.c      | 433 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/svm_tests.c     | 195 ++++++++++++++----------------
 x86/unittests.cfg   |  26 +++-
 x86/vmx.c           | 178 ++++++++++------------------
 x86/vmx_tests.c     | 215 +++++----------------------------
 21 files changed, 2592 insertions(+), 1627 deletions(-)
 create mode 100644 lib/x86/pmu.c
 create mode 100644 lib/x86/pmu.h
 create mode 100644 x86/emulator64.c
 create mode 100644 x86/pmu_pebs.c
