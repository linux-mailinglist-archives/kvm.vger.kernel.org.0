Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDC4603526
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJRVqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiJRVqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCB1B56D6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lk10-20020a17090b33ca00b0020da9954852so10001533pjb.1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6BQYdzWfYe+F6aifR3ZdUK7foQ29QXcSEDEg5el9DVs=;
        b=VesTJ6dCeAsfNIOlSkXWGtBV3qVDFDPm/Xfg8R1f1sNmFxWzDQIBvrAEVazRBcDvUW
         C9GRZD9JU5MyvBE6OvapC5zBuibJtmsmK9VvuYUD7y+DFUs96RSZGCk+Zvu31BLz/bxC
         EhH/rRKJXwORCWNMOn+wC/jFpXcicmwAH8rudIMf4ewYBJQhhLOeeuyQef2apZEhABuT
         kgJzKlc8E5N9AYoyJfVW5APDFT2R5FikexGqIkPeLiCnFEM6WodOWx0HTjioD6sl2nDV
         LT3vY2I1fQ1a3p5VGR0mQvEYyXkaZM2Bej4Oessir1+NSFynirJHVQ5KXdpGQ8yJ67PO
         QY1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6BQYdzWfYe+F6aifR3ZdUK7foQ29QXcSEDEg5el9DVs=;
        b=bZ+ZHHdD1u2LOAqUe6+bAIBrSqvO3hyofSRLVIcMjuHjt0jP9cCyS+nbKyDT2xhb6F
         olhyyrQlkTIF/mSRheYBKDVpyoSAkURP6REyPrFPxsyYHjY+eAHNdfzUUplo+P4DyB4g
         TChEiu3KZrx2BNPdWpsImg+Gtd/TmYOxQmhHRjYLKK24QS2TATKi/eOnIZrOhQLhGCjj
         +R9+LPJ6v0dsdJOYysCife+g7u+npp7ZwSOHR5yqQ11K7Se23tvgY53VXxdhWtccUYOF
         DLrBRIlxsndHo2klRehQHr8KvrP9wMTm84kzK37px3VLdPpmDx03EyB3SMpWpx0KijPi
         Q/rg==
X-Gm-Message-State: ACrzQf1abLqJ/u/LkXdJEzQsVNRKkehGWzJBuHSEDvU7riAIT19LAuMz
        VFevm4xtuDGbOq+2qmWEnPDUx1y2lmRP+g==
X-Google-Smtp-Source: AMsMyM5BgbTUXapzu+3U/jJ6oxHpFMMKRB+/8o3t9eq9+he6yjbGejeoMJsBL+TJtXsTVTbSjGm4gCVLTgWyWA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:4811:b0:20a:fee1:8f69 with SMTP
 id a17-20020a17090a481100b0020afee18f69mr1878699pjh.0.1666129576971; Tue, 18
 Oct 2022 14:46:16 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:05 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-2-dmatlack@google.com>
Subject: [PATCH v2 1/8] KVM: selftests: Rename emulator_error_test to smaller_maxphyaddr_emulation_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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
---
 tools/testing/selftests/kvm/.gitignore                         | 2 +-
 tools/testing/selftests/kvm/Makefile                           | 2 +-
 ...ulator_error_test.c => smaller_maxphyaddr_emulation_test.c} | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{emulator_error_test.c => smaller_maxphyaddr_emulation_test.c} (97%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d625a3f83780..c484ff164000 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -16,7 +16,6 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
-/x86_64/emulator_error_test
 /x86_64/fix_hypercall_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
@@ -34,6 +33,7 @@
 /x86_64/set_boot_cpu_id
 /x86_64/set_sregs_test
 /x86_64/sev_migrate_tests
+/x86_64/smaller_maxphyaddr_emulation_test
 /x86_64/smm_test
 /x86_64/state_test
 /x86_64/svm_vmcall_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6448cb9f710f..90c19e1753f7 100644
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
@@ -95,6 +94,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
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
2.38.0.413.g74048e4d9e-goog

