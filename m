Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A643F5153DD
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380093AbiD2SnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380086AbiD2SnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:15 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C98FD64D7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:56 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id bj12-20020a170902850c00b0015adf30aaccso4559938plb.15
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wjJUfUvHaodK4HMSxgaucfTWEgiY6ldqAfb1+kdosNE=;
        b=OeRwQFpC26LuaImy7GQAQs0KqKVjBxi1/t4aU0oHxYY8BDwRTK9j12rRWCcJtbkWVY
         i42v7gQMsI78UhJVSwpSZPb0ObkmSwj+yysqbjhdpFHfGLDM5v161doeWVlI1h5+ZooA
         3oLRh3A0872Snx0SyWBsZAzG+8YCvWoGNkVAH8CPCON31hHWUgk4tpx8W3LuahqZm9w5
         u2G3A35UarkoeXP2WTrIUXVfj834WAu1m66MOfT6xPpvtLJoBCaYONzn9FdvRPxrQss3
         jfEhows8XqPCR6XDraO7yiXaYaFLnLNxLg5Xopx6Ud/5zfOz4msc6imFDqjETGmT0SMp
         2v6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wjJUfUvHaodK4HMSxgaucfTWEgiY6ldqAfb1+kdosNE=;
        b=ayjXe8zi8Z9stELT2gQY/FE5hnV8eo3HWG2OBdwCiZ8eaS1uFjJOUN2f9fnFLesghp
         0VAFJuQ/BBTsjVqeHUIy92v9F2BC+L1G5o3PAmixkVlj/ocVseSjoJCMF4idV8GSb4z1
         8KTzAY+QjoeigmZbF9uoq9X0/TUal/oE3IO1ocXgRz8WBylTe0KdjAPlGa1pR9Gzb3i6
         O9TXmtsY+MrpNtT9aZgLYOmt0a3r0EpuPeCGO8T8/6WmTxLdtsnZV1JL5MqiwMkgAqO+
         wanOqa85guZgh5faimmRXtERHQ9A/42+uFZPWWLntqS6GzVYOp5UrKX1csL+T1sgSdPr
         dHkA==
X-Gm-Message-State: AOAM530HxumAqqYqe0VFV+wm4aJRr4FN71wsR7Io9cdsXkxnLPJLyVZm
        l2Yd1aVg+2i8xnvIvHr/FyhlDYtc64Abaw==
X-Google-Smtp-Source: ABdhPJydUc9991xbXugE3Lpb1J0qAvA9R82A/ijBmSbBtgsf+x9KCl4Kig916CHsHIgNrH9AI4zo+jl1SPxbAA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4ad1:b0:1da:2c51:9405 with SMTP
 id mh17-20020a17090b4ad100b001da2c519405mr5404720pjb.216.1651257596091; Fri,
 29 Apr 2022 11:39:56 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:34 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 8/9] KVM: selftests: Clean up LIBKVM files in Makefile
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
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

Break up the long lines for LIBKVM and alphabetize each architecture.
This makes reading the Makefile easier, and will make reading diffs to
LIBKVM easier.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile | 36 ++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c1eb6acb30de..1ba0d01362bd 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -37,11 +37,37 @@ ifeq ($(ARCH),riscv)
 	UNAME_M := riscv
 endif
 
-LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
-LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
-LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
-LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
+LIBKVM += lib/assert.c
+LIBKVM += lib/elf.c
+LIBKVM += lib/guest_modes.c
+LIBKVM += lib/io.c
+LIBKVM += lib/kvm_util.c
+LIBKVM += lib/perf_test_util.c
+LIBKVM += lib/rbtree.c
+LIBKVM += lib/sparsebit.c
+LIBKVM += lib/test_util.c
+
+LIBKVM_x86_64 += lib/x86_64/apic.c
+LIBKVM_x86_64 += lib/x86_64/handlers.S
+LIBKVM_x86_64 += lib/x86_64/processor.c
+LIBKVM_x86_64 += lib/x86_64/svm.c
+LIBKVM_x86_64 += lib/x86_64/ucall.c
+LIBKVM_x86_64 += lib/x86_64/vmx.c
+
+LIBKVM_aarch64 += lib/aarch64/gic.c
+LIBKVM_aarch64 += lib/aarch64/gic_v3.c
+LIBKVM_aarch64 += lib/aarch64/handlers.S
+LIBKVM_aarch64 += lib/aarch64/processor.c
+LIBKVM_aarch64 += lib/aarch64/spinlock.c
+LIBKVM_aarch64 += lib/aarch64/ucall.c
+LIBKVM_aarch64 += lib/aarch64/vgic.c
+
+LIBKVM_s390x += lib/s390x/diag318_test_handler.c
+LIBKVM_s390x += lib/s390x/processor.c
+LIBKVM_s390x += lib/s390x/ucall.c
+
+LIBKVM_riscv += lib/riscv/processor.c
+LIBKVM_riscv += lib/riscv/ucall.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
-- 
2.36.0.464.gb9c8b46e94-goog

