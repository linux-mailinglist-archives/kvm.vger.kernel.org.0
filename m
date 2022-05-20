Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA752F569
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353807AbiETV5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353809AbiETV5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:46 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C1E1A0ADC
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h128-20020a636c86000000b003c574b3422aso4693573pgc.12
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iQaFMbmFoi2VGc8icwKYFgNyKRkuTYMPuUBun/zPSQs=;
        b=HSVY+mAllOBZya3h0V5nQ1b9YLbmIIHsNIDA4j4q+Coc5Ph4jC8n9q6CTN2UsSRCvA
         RhgeWTANX/dTR2/6G3QqVAKsPxBzSiS+AIRjbfV+sbH3qT5W69Bg2wsC0kbtwmzTQ+W2
         adyWn0IQSVw7EJZUKjE3djAo9loDgeuu+juT+69R2BuLZ0QR2ATgxCH53e/fGaFn5mpo
         q30yONoKWGrWv08uE8Se7ZV7POjEAqxDAfxYTVxizT02kn1TX5elFXt0rbqul8SomPbX
         MKvqoZP5vLmY8IXh2G3WduPTjI/hicULvbqQ1deovc7wWSujY9A5t/C00pAzbqmnm4d7
         F8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iQaFMbmFoi2VGc8icwKYFgNyKRkuTYMPuUBun/zPSQs=;
        b=p1R4rdHdTBlUUkIlmNun8jRng45bKVRT4+akqSdxL581IEKMRCdQNg2h5kSLfBibZJ
         Eg80TO0wDywNgEoto5QdjbI45YpBsRXUxVrw4BVJbXZpHC3dNCXzEqT73QBnnc2UMrDh
         +Mw2dZLZ36xLnNzKvkBtYeGqXAArgqTdx1fTZy3WAIM/VCf7477RjG2raLpNAHUNNFWv
         ZYnivUzxqrStelox5vLD6HLp5YR+bbBQsLxkJ1RfQjbU5HRDCPsvDt1Up/ZtmAfuDQpN
         zNoAeBdCyd5w2X+DRbDndnzA/mrIdhP7nR7L/8BCIPQ9RWr/I4NnPzNiOY8btRFQpjEx
         wrCA==
X-Gm-Message-State: AOAM532LIYhJ5QfAmaFg08RgSwbDaEmjwavmb/9epcQ+YLzBaVZ68Js7
        8wju33rzcfA1AXtn/oIyDm+cx/GtpN/w9g==
X-Google-Smtp-Source: ABdhPJxnXie0TPyJPxH209jH4UJBFHy4lGoLluujVymHpmkzQR2AlpDIZHUGR9tyymWUKsKmIfUMChFug9xYZg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:2a8a:b0:1df:26ba:6333 with SMTP
 id j10-20020a17090a2a8a00b001df26ba6333mr474198pjd.0.1653083862365; Fri, 20
 May 2022 14:57:42 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:22 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 09/10] KVM: selftests: Clean up LIBKVM files in Makefile
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

