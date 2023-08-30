Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B0378D0F0
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 02:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241364AbjH3AHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 20:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241380AbjH3AGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 20:06:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AE3CC2
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58fc448ee4fso67585567b3.2
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693354007; x=1693958807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd4yetGTY62yJXPgiOO+0Jkv2SYpuv9CraTxCb4gpfw=;
        b=Oy1HL0MHLl5ba/H00HjFrtWC7ww/JPCHfqzO7zdDwZDFAygjZvrOQ38osWAIkdprhb
         kZalqIptizf2YbDEw8sDOC20480LRThqP85NCF7UMtHVW3yvu+oMRtLpTerZHklRMGGF
         Ue5b0Mwkkhxx+B5MrPK3JPGfASQKswM7Y4Grrq9ZWC/WujBCR6/iqPFBK4mKOakls2KI
         fp4IZBgQNY97ssXfA+YT6QWd1mXDe/FW1X4gZUwreyRDa1KY1wxbzdVDc1ndwyb+7/A7
         9oiklg1tYWk+lljv0SIUD+ABrkItIjKPEV6gem7QdxWkH56KUaJ7YZ6OK90mprrodqmO
         jBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693354007; x=1693958807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gd4yetGTY62yJXPgiOO+0Jkv2SYpuv9CraTxCb4gpfw=;
        b=kd6555nsIZB1NPsWm6VS293oPDlNhHl4FdccRf/ROMypji2mZ+V77BkpRWfxZSzFMh
         K4UefOTu84y42eQOGsRRcsdt56v0NRLm6AVx19RVZ1/T6nHAym9drMj8lTHMJbvsb/Xx
         qqMs4z8KepKSwNKWA8g1du3n2RVo+kQ/dS3rmec8WnECD7Cua8OeP0eAbOu9ZzWgT8nk
         6/e5BPHnHqHeU6KOR+HC5WExmxsmgvtpqcxdrSvuV3mZ64qUs5XxGtl/lQS3yx5kv/DZ
         LbGvrmIViesTY364OS16W3mBMPl8XsC/uKZnUrW9ZHwgIlDeLmY/P9NH1Le3Oz5jUi4Y
         EaVg==
X-Gm-Message-State: AOJu0YzyIlF/rHWJUt6D+yerdybg9+PtiDdauRnmFR0E6T2MTm04dAa4
        5xl76ZUAhGvr9znSQ4t8Xr3xj1P6UEo=
X-Google-Smtp-Source: AGHT+IHlRDycfwd46sL4kKObgZgRjmDHzhwgH3IKMb4Ypi2p2YLIVCUM7JyKEiL4IXj3QmaCA6Ft1z/tPSU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:181f:b0:d77:f4f5:9e4 with SMTP id
 cf31-20020a056902181f00b00d77f4f509e4mr17459ybb.2.1693354007321; Tue, 29 Aug
 2023 17:06:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Aug 2023 17:06:31 -0700
In-Reply-To: <20230830000633.3158416-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230830000633.3158416-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Selftests changes for 6.6.  The big highlight (and really the highlight of all
the x86 pull requests IMO) is the addition of printf() support in guest code,
courtesy of Aaron.

Speaking of which, the vast majority of this has been merged into the s390 tree,
i.e. if you do the s390 pull request first you'll already have most of this.
The immutable tag I created has waaaay more stuff than was strictly needed by
the s390 folks, but I forgot to create the tag earlier and I wasn't sure if
they had already merged kvm-x86/selftests, so I went with the approach I was
most confident wouldn't throw a wrench in s390 or delay their pull request, even
though the result is rather gross.

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.6

for you to fetch changes up to c92b922a8c526e1bb11945a703cba9f85976de7e:

  KVM: x86: Update MAINTAINTERS to include selftests (2023-08-25 09:04:34 -0700)

----------------------------------------------------------------
KVM: x86: Selftests changes for 6.6:

 - Add testcases to x86's sync_regs_test for detecting KVM TOCTOU bugs

 - Add support for printf() in guest code and covert all guest asserts to use
   printf-based reporting

 - Clean up the PMU event filter test and add new testcases

 - Include x86 selftests in the KVM x86 MAINTAINERS entry

----------------------------------------------------------------
Aaron Lewis (5):
      KVM: selftests: Add strnlen() to the string overrides
      KVM: selftests: Add guest_snprintf() to KVM selftests
      KVM: selftests: Add additional pages to the guest to accommodate ucall
      KVM: selftests: Add string formatting options to ucall
      KVM: selftests: Add a selftest for guest prints and formatted asserts

Bibo Mao (1):
      KVM: selftests: use unified time type for comparison

Jinrong Liang (6):
      KVM: selftests: Add x86 properties for Intel PMU in processor.h
      KVM: selftests: Drop the return of remove_event()
      KVM: selftests: Introduce "struct __kvm_pmu_event_filter" to manipulate filter
      KVM: selftests: Add test cases for unsupported PMU event filter input values
      KVM: selftests: Test if event filter meets expectations on fixed counters
      KVM: selftests: Test gp event filters don't affect fixed event filters

Michal Luczaj (4):
      KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
      KVM: selftests: Extend x86's sync_regs_test to check for CR4 races
      KVM: selftests: Extend x86's sync_regs_test to check for event vector races
      KVM: selftests: Extend x86's sync_regs_test to check for exception races

Minjie Du (1):
      KVM: selftests: Remove superfluous variable assignment

Sean Christopherson (33):
      KVM: selftests: Make TEST_ASSERT_EQ() output look like normal TEST_ASSERT()
      KVM: selftests: Add a shameful hack to preserve/clobber GPRs across ucall
      KVM: selftests: Add formatted guest assert support in ucall framework
      KVM: selftests: Add arch ucall.h and inline simple arch hooks
      KVM: selftests: Add #define of expected KVM exit reason for ucall
      KVM: selftests: Convert aarch_timer to printf style GUEST_ASSERT
      KVM: selftests: Convert debug-exceptions to printf style GUEST_ASSERT
      KVM: selftests: Convert ARM's hypercalls test to printf style GUEST_ASSERT
      KVM: selftests: Convert ARM's page fault test to printf style GUEST_ASSERT
      KVM: selftests: Convert ARM's vGIC IRQ test to printf style GUEST_ASSERT
      KVM: selftests: Convert the memslot performance test to printf guest asserts
      KVM: selftests: Convert s390's memop test to printf style GUEST_ASSERT
      KVM: selftests: Convert s390's tprot test to printf style GUEST_ASSERT
      KVM: selftests: Convert set_memory_region_test to printf-based GUEST_ASSERT
      KVM: selftests: Convert steal_time test to printf style GUEST_ASSERT
      KVM: selftests: Convert x86's CPUID test to printf style GUEST_ASSERT
      KVM: selftests: Convert the Hyper-V extended hypercalls test to printf asserts
      KVM: selftests: Convert the Hyper-V feature test to printf style GUEST_ASSERT
      KVM: selftests: Convert x86's KVM paravirt test to printf style GUEST_ASSERT
      KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest asserts
      KVM: selftests: Convert x86's nested exceptions test to printf guest asserts
      KVM: selftests: Convert x86's set BSP ID test to printf style guest asserts
      KVM: selftests: Convert the nSVM software interrupt test to printf guest asserts
      KVM: selftests: Convert x86's TSC MSRs test to use printf guest asserts
      KVM: selftests: Convert the x86 userspace I/O test to printf guest assert
      KVM: selftests: Convert VMX's PMU capabilities test to printf guest asserts
      KVM: selftests: Convert x86's XCR0 test to use printf-based guest asserts
      KVM: selftests: Rip out old, param-based guest assert macros
      KVM: selftests: Print out guest RIP on unhandled exception
      KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers
      KVM: selftests: Reload "good" vCPU state if vCPU hits shutdown
      KVM: selftests: Explicit set #UD when *potentially* injecting exception
      KVM: x86: Update MAINTAINTERS to include selftests

Thomas Huth (1):
      KVM: selftests: Rename the ASSERT_EQ macro

 MAINTAINERS                                        |   2 +
 arch/x86/kvm/x86.c                                 |  13 +-
 tools/testing/selftests/kvm/Makefile               |   6 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c        |   8 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  22 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |   8 +-
 tools/testing/selftests/kvm/aarch64/hypercalls.c   |  20 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |  17 +-
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   3 +-
 tools/testing/selftests/kvm/guest_print_test.c     | 219 ++++++++++++++
 .../selftests/kvm/include/aarch64/arch_timer.h     |  12 +-
 .../testing/selftests/kvm/include/aarch64/ucall.h  |  20 ++
 tools/testing/selftests/kvm/include/riscv/ucall.h  |  20 ++
 tools/testing/selftests/kvm/include/s390x/ucall.h  |  19 ++
 tools/testing/selftests/kvm/include/test_util.h    |  18 +-
 tools/testing/selftests/kvm/include/ucall_common.h |  98 +++----
 .../selftests/kvm/include/x86_64/processor.h       |   5 +
 tools/testing/selftests/kvm/include/x86_64/ucall.h |  13 +
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   8 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |  11 +-
 tools/testing/selftests/kvm/lib/guest_sprintf.c    | 307 ++++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   6 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |  11 -
 tools/testing/selftests/kvm/lib/s390x/ucall.c      |  10 -
 tools/testing/selftests/kvm/lib/sparsebit.c        |   1 -
 tools/testing/selftests/kvm/lib/string_override.c  |   9 +
 tools/testing/selftests/kvm/lib/ucall_common.c     |  44 +++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  18 +-
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |  36 ++-
 .../testing/selftests/kvm/max_guest_memory_test.c  |   2 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |   4 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c      |  62 ++--
 tools/testing/selftests/kvm/s390x/memop.c          |  13 +-
 tools/testing/selftests/kvm/s390x/tprot.c          |  11 +-
 .../testing/selftests/kvm/set_memory_region_test.c |  21 +-
 tools/testing/selftests/kvm/steal_time.c           |  20 +-
 tools/testing/selftests/kvm/x86_64/cpuid_test.c    |  12 +-
 .../kvm/x86_64/dirty_log_page_splitting_test.c     |  18 +-
 .../kvm/x86_64/exit_on_emulation_failure_test.c    |   2 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c        |   3 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c |  29 +-
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |   8 +-
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |  35 ++-
 .../selftests/kvm/x86_64/nested_exceptions_test.c  |  16 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 317 +++++++++++++++------
 .../selftests/kvm/x86_64/recalc_apic_map_test.c    |   6 +-
 .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c |   6 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |  22 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 132 +++++++++
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |  34 +--
 .../selftests/kvm/x86_64/userspace_io_test.c       |  10 +-
 .../vmx_exception_with_invalid_guest_state.c       |   2 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |  31 +-
 .../selftests/kvm/x86_64/xapic_state_test.c        |   8 +-
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |  29 +-
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |  20 +-
 56 files changed, 1389 insertions(+), 468 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c
