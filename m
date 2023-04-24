Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7270C6ED398
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjDXRfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbjDXRfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:35:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222098A78
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8f53c7683fso8648287276.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682357741; x=1684949741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PlCRffwlluvTcg4OYSR3war9cGSGYSE48FIOpQiZMm0=;
        b=YsnUYERpjx3hyS/FVGd0DiglbF61qFpHgC8/qEkLSc5nZkp4RBNSJUIBbqa09BFz1f
         alOQmmmloLW09c21mDnXiZn5GIs14DaXOP8TEioepEmdMjfkk1H484Cp3t7wBW9VjKbd
         4hUL1AmGS9JgGTIDDokUXWKPKsTO3oM+BQV8jCOvM84FzRcdg8EHG7Sr5x1EYNJL26gL
         GjXeBoOy8mNT8bqJvPSxKbDI+ymLOk/6ClBzVbwVdNFF/XW/DSKlyk9Im9W7onruwmEF
         40p9oqk+l8jUprjgVgzQln3/tYnKX2CWL3ZjoiZjUeDnoacSV8sj5A2pRl3fAqxYQhWn
         uqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682357741; x=1684949741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PlCRffwlluvTcg4OYSR3war9cGSGYSE48FIOpQiZMm0=;
        b=VjZ7hX3OdSbf0gA/TEIcnKj4jrUHPuM3ffa6KNp6DZHKI4SLDWuqLGAXD+F0BzC7L5
         rPVqSx0ciipNcVyAqw3Umv3VHj+NoUncn/PEZBdDVIGupMRVvrrMouK3O5kbf8UCmKZ5
         foLw7TBmng5Fg8I85Ilg3PKgAmeC0BBUoiQ42G83pydsdA0ADZAP5Unx1raFlS4mtM8a
         FvfH8SgrxnmAGAiaxfLsI3Cc07HdePH/CSeCMbUvB4Grk9yIszGjuYM++xovHAnG1Xtc
         swIQBgqjbHmHVWWD/encz+qRMWAph6phhCVeRhVmrLVVIleDGDV3zzmDZTLaQw4Wu+sc
         gcOQ==
X-Gm-Message-State: AAQBX9dNn2ObAkslCc1zTnBR6Dj7fiyw7NWQrpUpoc0kQp6lq1x7Vq9C
        tOJ9VbKeNgFzsbqpsnekU9ZFV+rue68=
X-Google-Smtp-Source: AKy350YaiLevTV5PpVwQjoUBYjqPjh9BKZEedz+FRfshSSXRyjbbVIv0dT/rug1MJiBifO7omLTy+Vur7og=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d745:0:b0:b95:c0c5:6ca with SMTP id
 o66-20020a25d745000000b00b95c0c506camr5004560ybg.6.1682357741394; Mon, 24 Apr
 2023 10:35:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Apr 2023 10:35:26 -0700
In-Reply-To: <20230424173529.2648601-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424173529.2648601-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: PMU changes for 6.4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM x86/pmu changes for 6.4.  Hiding in the pile of selftests changes are a
a handful of small-but-important fixes.

Note, this superficially conflicts with the PRED_CMD/FLUSH_CMD changes
sitting in kvm/next due to "KVM: VMX: Refactor intel_pmu_{g,}set_msr() to
align with other helpers".  The resolution I have been using when preparing
kvm-x86/next for linux-next is to replace a "return 0" with a "break".

The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7:

  KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:18:07 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.4

for you to fetch changes up to 457bd7af1a17182e7f1f97eeb5d9107f8699e99d:

  KVM: selftests: Test the PMU event "Instructions retired" (2023-04-14 13:21:38 -0700)

----------------------------------------------------------------
KVM x86 PMU changes for 6.4:

 - Disallow virtualizing legacy LBRs if architectural LBRs are available,
   the two are mutually exclusive in hardware

 - Disallow writes to immutable feature MSRs (notably PERF_CAPABILITIES)
   after KVM_RUN, and overhaul the vmx_pmu_caps selftest to better
   validate PERF_CAPABILITIES

 - Apply PMU filters to emulated events and add test coverage to the
   pmu_event_filter selftest

 - Misc cleanups and fixes

----------------------------------------------------------------
Aaron Lewis (5):
      KVM: x86/pmu: Prevent the PMU from counting disallowed events
      KVM: selftests: Add a common helper for the PMU event filter guest code
      KVM: selftests: Add helpers for PMC asserts in PMU event filter test
      KVM: selftests: Print detailed info in PMU event filter asserts
      KVM: selftests: Test the PMU event "Instructions retired"

Like Xu (4):
      KVM: x86/pmu: Zero out pmu->all_valid_pmc_idx each time it's refreshed
      KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
      KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
      KVM: x86/pmu: Fix a typo in kvm_pmu_request_counter_reprogam()

Mathias Krause (1):
      KVM: x86: Shrink struct kvm_pmu

Sean Christopherson (25):
      KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are available
      KVM: x86: Rename kvm_init_msr_list() to clarify it inits multiple lists
      KVM: x86: Add a helper to query whether or not a vCPU has ever run
      KVM: x86: Add macros to track first...last VMX feature MSRs
      KVM: x86: Generate set of VMX feature MSRs using first/last definitions
      KVM: selftests: Split PMU caps sub-tests to avoid writing MSR after KVM_RUN
      KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN
      KVM: x86/pmu: WARN and bug the VM if PMU is refreshed after vCPU has run
      KVM: x86/pmu: Zero out LBR capabilities during PMU refresh
      KVM: selftests: Move 0/initial value PERF_CAPS checks to dedicated sub-test
      KVM: selftests: Assert that full-width PMC writes are supported if PDCM=1
      KVM: selftests: Print out failing MSR and value in vcpu_set_msr()
      KVM: selftests: Verify KVM preserves userspace writes to "durable" MSRs
      KVM: selftests: Drop now-redundant checks on PERF_CAPABILITIES writes
      KVM: selftests: Test all fungible features in PERF_CAPABILITIES
      KVM: selftests: Test all immutable non-format bits in PERF_CAPABILITIES
      KVM: selftests: Expand negative testing of guest writes to PERF_CAPABILITIES
      KVM: selftests: Test post-KVM_RUN writes to PERF_CAPABILITIES
      KVM: selftests: Drop "all done!" printf() from PERF_CAPABILITIES test
      KVM: selftests: Refactor LBR_FMT test to avoid use of separate macro
      KVM: selftests: Add negative testcase for PEBS format in PERF_CAPABILITIES
      KVM: selftests: Verify LBRs are disabled if vPMU is disabled
      KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with other helpers
      KVM: selftests: Use error codes to signal errors in PMU event filter test
      KVM: selftests: Copy full counter values from guest in PMU event filter test

 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/kvm/cpuid.c                               |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/pmu.c                                 |  21 +-
 arch/x86/kvm/pmu.h                                 |   2 +-
 arch/x86/kvm/svm/pmu.c                             |   2 +-
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c                       | 135 ++++++-----
 arch/x86/kvm/vmx/vmx.c                             |  16 +-
 arch/x86/kvm/x86.c                                 | 102 ++++++---
 arch/x86/kvm/x86.h                                 |  13 ++
 .../selftests/kvm/include/x86_64/processor.h       |  41 +++-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 252 ++++++++++++---------
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       | 248 ++++++++++++++++----
 14 files changed, 565 insertions(+), 275 deletions(-)
