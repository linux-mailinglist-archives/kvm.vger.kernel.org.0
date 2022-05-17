Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE07C52AB7E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352517AbiEQTFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346834AbiEQTFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350FD107
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:41 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z16-20020a17090a015000b001dbc8da29a1so1810367pje.7
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BbT3qIQqY75tltcSOWTXutdvIAEglFmPYbpzXMtd0+s=;
        b=FMcPD/W1tVzarYM9qnqX9+feK+EwoKvnZrBfUOxTHC1V+2iZiB6x2A48vClUhD1r7E
         HXy62gg5Fz7aZPe/wWBkAzFB6yu9VdLKcOihsH7SFEWYJwqt9Ms72ZRtRPJuALhGycPj
         QOWS7b+bArHO2R2BQY2Zp+9hg2Ts0Fmb+0cdEuNjmRYYQbmLtYKsyrTWYnjWVQExv5V8
         muyZtOK9R5WOHrHWXJ9OHdr466u6xcj97mxxLZGNACrVeEWxGp+QPnt1Z3RKeGDpmNmH
         agssaQqahj47w07HCVkubK6K7Pcmpullh24hORGJAV6zXTW/KHIF9g2Ns1jqmBDnbvWS
         fc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BbT3qIQqY75tltcSOWTXutdvIAEglFmPYbpzXMtd0+s=;
        b=jbaMxNtZOdcdx/u03aPHRgRayl3je5xeKFyc5BPfSmMaXc9UWq6DP5WKn6dv2jaV+j
         BiOsr2IDAmc1Y8Pdz9IBX7ypjTQ9F56pm/8/9iivBk4j2bj7833UgEINgXxGHYB9h3cK
         ETvjTzZxucNcRgW6Cecc2vd0JvFJGk+hmwe6CQCqrVgsbyrJQ9WnywAbIUQOFIpWiVAG
         0z6lsvQc6vwHMrikx5TczF87LzaeOLNY8gHL75pxuu/7Z74R1VFH/Y0yTkKsF2nxUBqR
         Da0qC9JAlmGSFkqTafbN78wsErsKhJo+7nOxQ45QXm1FhCYe6FdQUQ5v7inLD5whus3e
         XHBg==
X-Gm-Message-State: AOAM531Ce0yaqQh4EPtmGq3EQ0gz/QShYL5OHxduDybbNtT7fLgYYIwY
        NcEEkKvex0c2FZBGZWsSKAcAJgEZ8Gu3gg==
X-Google-Smtp-Source: ABdhPJxDo4a3LXUH6qD+1SS7Ok+dJTJ3GE/vu2EpBYI8HUJS9b+b8QHX9dnpaNq3CiK5ZmXbBECKX6+c4YYrQw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e808:b0:161:946c:d2a5 with SMTP
 id u8-20020a170902e80800b00161946cd2a5mr7988639plg.93.1652814340415; Tue, 17
 May 2022 12:05:40 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:23 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 09/10] KVM: selftests: Clean up LIBKVM files in Makefile
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
2.36.0.550.gb090851708-goog

