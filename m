Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1DB626103
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 19:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbiKKSZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 13:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKSZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 13:25:42 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF024C245
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 10:25:40 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l14so7521788wrw.2
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 10:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G49Mn+39h2vPHN4AzQaatrKwexURVZpgkUVTRaS+5Pc=;
        b=WB/wwEOIACBjbBhKnyfseiSz3pDcL9oZTsaYCULkUqK3NEvW0UQwVPMxFjZ6EBZLBa
         epcz/PYPc+SWbDx2qfiyXulkJo0Tmc6G0c4IEY52tTo7MF7SL/hTwoQn1pyR3J7pHu6K
         12gNv78rx8nYNn6Xhlnm0u+lsZ9P4GNJ8g2ohlNkDb1Z553J2IqQOLizgZmzkYCx5b9v
         OPg7jOUuOgzbd4GyUJ0DDJ4Y9M7+lQoYivaRYQAtt9MPVrl7pXdoMAHvBe77mMwzsRaB
         b11UK9xHiz8WTKIxB4ZaapVY7+7CYkn2rLnQ6fQ5a5wwXeTYDEVi45qMMACsMWYMbE58
         X1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G49Mn+39h2vPHN4AzQaatrKwexURVZpgkUVTRaS+5Pc=;
        b=N0alVUalzASe3B7/fJHxpS2cMaXvCbq10ZbxOVCtJkeLFyB4wkqtvMslml1cJiAKY/
         5YMvqhKhmpLEtJBcyiKrCJAoRt3jMjmnME0fTx+jB1zmXLG3FEbFf2VSqQW1gnvQVsVN
         xJjnZbsuwhexGbLBCCcowCZP9qbv4m/cfxPBhm+QaNHgvZFyxQG5kYej3BOn/6dIX+de
         aj8uTXGWO3l4ggG4zTOhv1/QJ19WciKqUlYs7BmYlS/rD2WieLsjeVOKmX4Eqg9SEN2F
         p2fItGD+3+1+k5TeV4DuVbseqk/AvaJ+nyD2ln8uSt+vR/qHRpyN/dDq6MLnBK49vyEr
         Ywkg==
X-Gm-Message-State: ANoB5pkVQUgXSacU50nurSl5NgobM/QTWNNPig9TynkGu36NsMpuhLeG
        OeoHps/j3MjJUXWP5KnVv97etA==
X-Google-Smtp-Source: AA0mqf649pn/4HiKtJfKmwJfm2X7mYbRMg2bPJtphdYBi2AHk6GnUw0/kw8d4Q/eRXLE0FMEOrggXA==
X-Received: by 2002:adf:ea4d:0:b0:236:8fa1:47cf with SMTP id j13-20020adfea4d000000b002368fa147cfmr2101859wrn.50.1668191139036;
        Fri, 11 Nov 2022 10:25:39 -0800 (PST)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id n7-20020adffe07000000b002366f9bd717sm2921843wrr.45.2022.11.11.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 10:25:37 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 0B9BF1FFBC;
        Fri, 11 Nov 2022 18:25:36 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     f4bug@amsat.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        qemu-arm@nongnu.org (open list:ARM KVM CPUs),
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v5 04/20] target/arm: ensure KVM traps set appropriate MemTxAttrs
Date:   Fri, 11 Nov 2022 18:25:19 +0000
Message-Id: <20221111182535.64844-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221111182535.64844-1-alex.bennee@linaro.org>
References: <20221111182535.64844-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although most KVM users will use the in-kernel GIC emulation it is
perfectly possible not to. In this case we need to ensure the
MemTxAttrs are correctly populated so the GIC can divine the source
CPU of the operation.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - new for v3
v5
  - tags
  - use MEMTXATTRS_PCI
---
 target/arm/kvm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f022c644d2..bb4cdbfbd5 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -803,13 +803,14 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
 {
     ARMCPU *cpu;
     uint32_t switched_level;
+    MemTxAttrs attrs = MEMTXATTRS_CPU(cs);
 
     if (kvm_irqchip_in_kernel()) {
         /*
          * We only need to sync timer states with user-space interrupt
          * controllers, so return early and save cycles if we don't.
          */
-        return MEMTXATTRS_UNSPECIFIED;
+        return attrs;
     }
 
     cpu = ARM_CPU(cs);
@@ -850,7 +851,7 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
         qemu_mutex_unlock_iothread();
     }
 
-    return MEMTXATTRS_UNSPECIFIED;
+    return attrs;
 }
 
 void kvm_arm_vm_state_change(void *opaque, bool running, RunState state)
@@ -1005,6 +1006,7 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
     hwaddr xlat, len, doorbell_gpa;
     MemoryRegionSection mrs;
     MemoryRegion *mr;
+    MemTxAttrs attrs = MEMTXATTRS_PCI(dev);
 
     if (as == &address_space_memory) {
         return 0;
@@ -1014,8 +1016,7 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 
     RCU_READ_LOCK_GUARD();
 
-    mr = address_space_translate(as, address, &xlat, &len, true,
-                                 MEMTXATTRS_UNSPECIFIED);
+    mr = address_space_translate(as, address, &xlat, &len, true, attrs);
 
     if (!mr) {
         return 1;
-- 
2.34.1

