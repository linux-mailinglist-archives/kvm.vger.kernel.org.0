Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7A1613CC3
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJaSAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJaSAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:00:53 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D48213D1E
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so6021407pff.0
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7uq7+6FJUtCM5yZaRMCgjXsjZDgsouXY7vk22+ZXIs=;
        b=idUT8pzYHP+DmrkVsbwLYVLl4f8i7IupWtWnvPGzFF17KI5p12NgqyS5EPdFOcRVaz
         0zIsNA7z6z5/t8coxL2CtAN0lkQSPtzCcrd1wnDNnx/VtCIrm2RTZ2fEVNxGcHVYtgkq
         R0boZ4AeTDw9SJDTLdMUpSR9azMNXeh4qhI6HUgF1HVr8agpql0G2yyKvkg0UpB3W8mQ
         CeCuB0B1o7odvQrSgAik90cEMxh2dK5ToA+IMWmBFzQ7QeCkMzS1C1Q0s2bFz+5utJdV
         CvVxIHRzkljWyQLirwC6gF1+mvdFELkmwintV6pbnE2jNwZOmad0GKVNVvSR31LosC6p
         tMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7uq7+6FJUtCM5yZaRMCgjXsjZDgsouXY7vk22+ZXIs=;
        b=fUNqPvAfue8FOlPokXvRHRX3oZqEdwAlYPJFisDgDrIvUaP6gGt/rok8iN3BrD5Tkb
         JS9zf9z3+cljIMvTpTO1I4pX6aUZeUNmv9D2PcjpnEONa6iYhq/H8Sceps5GkVGq+JRA
         saQyPA3SQP5Sx7JPTb0JL5ldfFMHzafd4Au4GAK4UJ5cCQbvbsQdD4Ondo3wCCXA1Hax
         ULLJYr199kRD6XzI5m+a60AH7JyaJEx/Y2oel6jNz6tJ55d8BRLvKediB5W9UWy1ewV7
         RMORI4zuPH+kc3OEqTMsBxM9eDqVDONPc1T5w9/r1t4T5CE7GtxDpb0dj49K3gsxjkgl
         EzwA==
X-Gm-Message-State: ACrzQf2+Gq4Hqai25p11Wn9cm9aaAHZTn6gIBlyOO/6nOhGjQHqfIkKL
        uyF3jVIbh6MEVJ1+NjD6oTJo+zsSM5KaEg==
X-Google-Smtp-Source: AMsMyM5aAtth/wnG4FK4mgKAZVLU69CFPfghmYyZwBHpD7hl5uS3bpX3vKZDdxd/fjKoE/ciXf9lJ1zG2adASQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:158d:b0:56d:59f0:d273 with SMTP
 id u13-20020a056a00158d00b0056d59f0d273mr8294114pfk.51.1667239251867; Mon, 31
 Oct 2022 11:00:51 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:36 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-2-dmatlack@google.com>
Subject: [PATCH v3 01/10] KVM: selftests: Rename emulator_error_test to smaller_maxphyaddr_emulation_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename emulator_error_test to smaller_maxphyaddr_emulation_test and
update the comment at the top of the file to document that this is
explicitly a test to validate that KVM emulates instructions in response
to an EPT violation when emulating a smaller MAXPHYADDR.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore                         | 2 +-
 tools/testing/selftests/kvm/Makefile                           | 2 +-
 ...ulator_error_test.c => smaller_maxphyaddr_emulation_test.c} | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{emulator_error_test.c => smaller_maxphyaddr_emulation_test.c} (97%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2f0d705db9db..053e5d34cd03 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -17,7 +17,6 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
-/x86_64/emulator_error_test
 /x86_64/fix_hypercall_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
@@ -36,6 +35,7 @@
 /x86_64/set_boot_cpu_id
 /x86_64/set_sregs_test
 /x86_64/sev_migrate_tests
+/x86_64/smaller_maxphyaddr_emulation_test
 /x86_64/smm_test
 /x86_64/state_test
 /x86_64/svm_vmcall_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0172eb6cb6ee..ab133b731a2d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -81,7 +81,6 @@ TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
-TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
@@ -96,6 +95,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
+TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
 TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
similarity index 97%
rename from tools/testing/selftests/kvm/x86_64/emulator_error_test.c
rename to tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 236e11755ba6..6ed996988a5a 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -2,7 +2,8 @@
 /*
  * Copyright (C) 2020, Google LLC.
  *
- * Tests for KVM_CAP_EXIT_ON_EMULATION_FAILURE capability.
+ * Test that KVM emulates instructions in response to EPT violations when
+ * allow_smaller_maxphyaddr is enabled and guest.MAXPHYADDR < host.MAXPHYADDR.
  */
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
-- 
2.38.1.273.g43a17bfeac-goog

