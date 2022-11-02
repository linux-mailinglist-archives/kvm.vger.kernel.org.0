Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D173616CFF
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiKBSrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiKBSrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4335C2CE27
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p66-20020a257445000000b006ca0ba7608fso16940285ybc.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7uq7+6FJUtCM5yZaRMCgjXsjZDgsouXY7vk22+ZXIs=;
        b=XDgeZyKDTKKipX+i2aGyHNi3s+8pnkpnMI12cgPv4ojpprE+Fg9YnzSmNNsXX8HfJj
         iQbxfEndlSN9abt6doem7fwJJXekYak3qgfa1e23bo7K9164k5zp7hw1o60qcSIVJ2w5
         drYOm4FQw/MYk0vW8prIJdruby48uiOoct5SUhO7BjVnv3fPIL/h5KidH0sDSufi9qzW
         DpKq7TkYLamfrhWnqBMaBIHpEeY/o280to+UOlNzldbdEpoWBRgZHLGKJS+Sk0rLiOz7
         ZRGobOy+GEWhz0thGXVb31D7vBrs3byLm/297DioRssWpXwKLAWCIyi89HRJVJim6mxZ
         BR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7uq7+6FJUtCM5yZaRMCgjXsjZDgsouXY7vk22+ZXIs=;
        b=TTnSdC7GlkyGu24Yr0+rYgyUiM9c3em5/x/A3Hq7RfghtfYD5DGM3d7orP9JRVmCoR
         W3LAkWh8CoLr541Q7R3x4uMHzoRQXZ5L8mQF4hVt0CfrX1evhRpKNUjxfBL+2qaCLt77
         rtPQSGYeR7vWncS7ROxtNCOrlNZ3HvpQQGpW6mZ+GOCxFk3YacjrjEPOrT7phpPTw2Pb
         RyexEYkZiieF92JCSp9n98zv4Vq+u26hYp4fChxDXva8SfJ7ij7B1hINylHw+Zkv6k3D
         Qwk1lC6a6D7rq4lUFKcn45G1Fh2Cj9p8jOL3ZluzXKGOqfHKi5Hzh1SRJjSPgBjEAvuN
         TrXA==
X-Gm-Message-State: ACrzQf0d/Vpi8Nl26Yz3OyNf7BCJ7dJUaw+ORjefPDDvXWtJeClXgSra
        Zj1Nmlojxd4gMCOFJ1impwROgXFIyyg+iw==
X-Google-Smtp-Source: AMsMyM6ztd9xyXefhdqKbXs4TQ/5pf47M9ZV5C6tp0cuCubpRbzjdpMp5DlM5P9ogxJwG548M2iggV6hX5AAZA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:f4e:0:b0:6bc:9f5a:96f0 with SMTP id
 y14-20020a5b0f4e000000b006bc9f5a96f0mr177191ybr.10.1667414819125; Wed, 02 Nov
 2022 11:46:59 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:45 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-2-dmatlack@google.com>
Subject: [PATCH v4 01/10] KVM: selftests: Rename emulator_error_test to smaller_maxphyaddr_emulation_test
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

