Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02AC6A245C
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjBXWhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBXWhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:14 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8EB6F431
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id m18-20020a17090a7f9200b002375a3cbc9bso141912pjl.9
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gl/R2pHmzxEtw7c5AzqBzH8DjfqeBWUHfv5NABoXY6w=;
        b=Y8RkJ8NDJ2nOACFvJWBok7vgyzhvjkkZehsC1eC08ZR7gTAXKVqlU3cbZCjWYjZy/Y
         wZdG+RSlLRug1WLrkGmJoFW3r3qRs9gf8iwitXOisQSXVcQ3wLiB6w0L+g0u7dF0Q3jx
         9U0RBVv81TWHOSdzKE+jVBj0U44xQCawGTvkZS+WhTkGvV9F1mo7GN1O1G79U1nRMUre
         riByX1CUy9IrphDavMpsjjXVyGdgp5p82QhN1rR0YFPqAc2AUPEZMjs8yLfpLkVV1FHq
         Wl4dwrf3tNRU4N0tmlPVSscR7YVPMkJF2f4KbdCsDxeNg0gPHNEmFyl3gcGeQQxYRXES
         6mcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gl/R2pHmzxEtw7c5AzqBzH8DjfqeBWUHfv5NABoXY6w=;
        b=GOAAg52uIPuj1CupRh4ImfqUWRb4lH9XwmOPOagPu887MjCgXLrzEPse8ndiuPWE/L
         JpP6SHG0l/MJVnANgiMd3uT/AKmllXIewDrKNnGbHpwuSjwMs4qos2Qxe/nFn7t9nriz
         v5SVFBTIvs8jsOkKpgUooXEVBcfMYdlnpYBz1qRmbQ47RxVam5P3YAjSuXx6jEYYGtzY
         BszEpnfQXII01FUXUUGQsm3FUVDzxlogo/kwBqIizQViO/WxBZ2CWzOQO8yZfGBnDMQH
         8CcD+z34Ad/Z42Vi61Kq+61ZciVnLETS8Xj2fBYP8TpEnb+P9MJlgu+SCECJxOQGntwi
         TECA==
X-Gm-Message-State: AO0yUKWUO/abJFif+A6cTzr3VOR7/mZBK9L0pdjKhlefyTPn2Bhg8c7R
        R5vQOJbNHuWjzKww66GokAupdHGfCFhQ7n+MRhrMUKb5KD3iN5y+EPhNUA8fE4gBaGXKWXCnFSA
        piyr3WJxE0KdNJ1Umw6ufxz4E/9PJ2Z7Bd+jl3oEIpDNIMfF5nEOEJP+Qw5eA9UZgDB7s
X-Google-Smtp-Source: AK7set8hyMqQkhkZ/tlRpbYjzSy6F4UE/hZMbvrDqKbGAIpNnD0MgRIHZ+8j9Z4X10DkMYaxC0dEC2K57Yn5QBmC
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:c7d6:b0:233:d64d:4c29 with SMTP
 id gf22-20020a17090ac7d600b00233d64d4c29mr2285961pjb.4.1677278230270; Fri, 24
 Feb 2023 14:37:10 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:05 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-7-aaronlewis@google.com>
Subject: [PATCH v3 6/8] KVM: selftests: Hoist XGETBV and XSETBV to make them
 more accessible
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
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

The instructions XGETBV and XSETBV are useful to other tests.  Move
them to processor.h to make them more broadly available.

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 18 ++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 24 +++----------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 53ffa43c90db..62dc54c8e0c4 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -496,6 +496,24 @@ static inline void set_cr4(uint64_t val)
 	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
 }
 
+static inline u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	__asm__ __volatile__("xgetbv;"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax | ((u64)edx << 32);
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	__asm__ __volatile__("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
+}
+
 static inline struct desc_ptr get_gdt(void)
 {
 	struct desc_ptr gdt;
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b67..4b733ad21831 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -68,24 +68,6 @@ struct xtile_info {
 
 static struct xtile_info xtile;
 
-static inline u64 __xgetbv(u32 index)
-{
-	u32 eax, edx;
-
-	asm volatile("xgetbv;"
-		     : "=a" (eax), "=d" (edx)
-		     : "c" (index));
-	return eax + ((u64)edx << 32);
-}
-
-static inline void __xsetbv(u32 index, u64 value)
-{
-	u32 eax = value;
-	u32 edx = value >> 32;
-
-	asm volatile("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
-}
-
 static inline void __ldtilecfg(void *cfg)
 {
 	asm volatile(".byte 0xc4,0xe2,0x78,0x49,0x00"
@@ -121,7 +103,7 @@ static inline void check_cpuid_xsave(void)
 
 static bool check_xsave_supports_xtile(void)
 {
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
+	return xgetbv(0) & XFEATURE_MASK_XTILE;
 }
 
 static void check_xtile_info(void)
@@ -177,9 +159,9 @@ static void init_regs(void)
 	cr4 |= X86_CR4_OSXSAVE;
 	set_cr4(cr4);
 
-	xcr0 = __xgetbv(0);
+	xcr0 = xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
-	__xsetbv(0x0, xcr0);
+	xsetbv(0x0, xcr0);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
-- 
2.39.2.637.g21b0678d19-goog

