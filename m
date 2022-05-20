Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7006652F63E
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348253AbiETXdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354107AbiETXdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2016199B36
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:09 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oj9-20020a17090b4d8900b001df6cd6813cso7675614pjb.9
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iQaFMbmFoi2VGc8icwKYFgNyKRkuTYMPuUBun/zPSQs=;
        b=lbmqY0lTpfPO6GThJE9LiVwX/TU2OszrIGc/LWBpEHSNzQUQTs6AcY2Ek0DzTC9rB0
         pP/I2kNfhUB3kCo5TX+6eJAvh458sFxynaypdHj2uSp0mpz/22F4b5S2bZK71bdH/Tzd
         FHqeGrytW8/d0Dr4B2F0QTiDzbt9cgvMyD59rVuYIK0k6SoI4krHfSCyi0ne9gLOkb2H
         baNyTKE8nLFvuGdhWPYl0uR/COZeRj46t272ZjjU+uY4jEY/B/isQmyvftlgNrzAkGMa
         wIRdoeCXpYrPpO9YAUUUZOsByBcGKytplAXqw3kI82LW+/kwrHZFsmSKsown5+1sR1mj
         hxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iQaFMbmFoi2VGc8icwKYFgNyKRkuTYMPuUBun/zPSQs=;
        b=dsBy0dCSAArj/1dyPUJp4cbhtr3gpIoM3tY3Pl0K4RJEQ0h6z7nEzmCwbz8sLXR3gs
         sGqAsdw4c2TyUKBKhrnUCWT6o3R9Q45SoEg1j2H2FGp7TUM35Nnj4WbUBkskOmnQkDur
         BpUGdgnDzOrN5R5/r+Q5UvyyagREUL2XfIaggj7YgQGAmTW5CYWZCys0g+WZXYN//mRz
         l3UfZbf8CiFjW5bGeWSbpdF+b6LdKNoAK9+7mb+HFynNU16KvhChArRrE3A58NGX1m1t
         Gb7MIM3oF0JRIuo1ID0X1z+S5hJutVKxPpGxkn9OvIvFQ2j67LRldImbnfj6LOS7UCGj
         8SzA==
X-Gm-Message-State: AOAM53229EzKl2BqO03QX8+Yt5KoASXPpqsKewYPljnavyG60pnFJsOw
        VYuBZkAWO4LsS8tiG6wrXtNe5sace130GQ==
X-Google-Smtp-Source: ABdhPJx/EhlpBumoO2tCpEy2FzVyp65osVtC/KCdk1bGp5WRtZEybYyRK8YNXeN14NTYB5Rg4oi3WlCaLNnSeg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f7cd:b0:161:7287:11b6 with SMTP
 id h13-20020a170902f7cd00b00161728711b6mr11783004plw.70.1653089589191; Fri,
 20 May 2022 16:33:09 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:47 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 09/11] KVM: selftests: Clean up LIBKVM files in Makefile
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Break up the long lines for LIBKVM and alphabetize each architecture.
This makes reading the Makefile easier, and will make reading diffs to
LIBKVM easier.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile | 36 ++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0889fc17baa5..83b9ffa456ea 100644
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
2.36.1.124.g0e6072fb45-goog

