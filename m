Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93736D21DB
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjCaN5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjCaN5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:57:31 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C246DBCB
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x3so89861001edb.10
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680271047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/W/3TX1trWbw7cm7tHRSUUT7TeiRpxFpONHIB9AwQIA=;
        b=NeP+fza4Hflo5YJNfbIjHIZXleW1lKi7+vRLnOTckZVIr/e+EFxMgj1xgslsMRvJZf
         4L9qciexH44vu23fMpPIAHPZVU/nw4IjLhoN2vSbMzqhyJNR0lBq2pNaoVmGhLIdys+R
         UtBsXdDCyQZnGCGrklIXibjlZBQMP6jYQL6KksMt2QFeU6bRxSLvfhG5S0MBOjPY6CUL
         AHIHKZqUF/JQNVbTpaPk57jTxNs/0fV1jRzHmWiwkXVsJms6BCs3tpxozUvVpEFaPJ3w
         3R6RlDi+6/TH+GJcWGP2WrqLK2gud10p26mZVmVtAsH8drXZ4dI/tRTKVNsDFk4Slttl
         mumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680271047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/W/3TX1trWbw7cm7tHRSUUT7TeiRpxFpONHIB9AwQIA=;
        b=D9E1lJQnu8vplTI81U17Fx/MU2FBL5AAWuvd8YnzbV7G70ttPyR+T3Bb41MUVxEWz7
         H8NYY/9vBaN8Q5ySAUsZg1VmL1azezoeR9mzW6p0TqfFyyVzvCUIPGlsX5RqNTvBYVzp
         9X+NgIH+pxJBAjMg/yKXHZWbiDVZDm50IzhDKeJzuQ6+MDHfXE5LyiMG+R6DuDLgUoSA
         emtjVN34avsVN1YwCYcFVCQWdTbV96SlofytP763o76lOjhEwIzYJsJKmY3YdR8qu12X
         pWHB3T3Up1P8tHOq68lEPvt/VnjSTzf3UJLdHveBf9xSNKew3g1HuPPvBqF2dkXw+TJX
         ZxRA==
X-Gm-Message-State: AAQBX9elL1HomYldE/r+kySRnvH7wCAZB8LqBYCzQrzLfUWn/eIyPRBJ
        lptzHVFURj6Qm3/kqNiZflbFmNIW9Hj1ZJZXLkRSfQ==
X-Google-Smtp-Source: AKy350ZCN1rEifz1w1qTC4AqvYeihja0MNDXlHd35XYs1FVg+HYIWBoISzK3hR/3plBa9v0pl6VeGw==
X-Received: by 2002:a17:907:6d27:b0:932:cfbc:7613 with SMTP id sa39-20020a1709076d2700b00932cfbc7613mr31422121ejc.24.1680271046844;
        Fri, 31 Mar 2023 06:57:26 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af1a510052e55a748e5a73cd.dip0.t-ipconnect.de. [2003:f6:af1a:5100:52e5:5a74:8e5a:73cd])
        by smtp.gmail.com with ESMTPSA id ay20-20020a170906d29400b00928de86245fsm996888ejb.135.2023.03.31.06.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:57:26 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 3/4] x86/access: Forced emulation support
Date:   Fri, 31 Mar 2023 15:57:08 +0200
Message-Id: <20230331135709.132713-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331135709.132713-1-minipli@grsecurity.net>
References: <20230331135709.132713-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to enforce access tests to be handled by the emulator, if
supported by KVM. Exclude it from the ac_test_exec() test, though, to
not slow it down too much.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/access.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index d1ec99b4fa73..ae5e7d8e8892 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -82,6 +82,13 @@ enum {
 	AC_CPU_CR4_SMEP_BIT,
 	AC_CPU_CR4_PKE_BIT,
 
+	NR_AC_TEST_FLAGS,
+
+	/*
+	 *  synthetic flags follow, won't be exercised by ac_test_exec().
+	 */
+	AC_FEP_BIT,
+
 	NR_AC_FLAGS
 };
 
@@ -121,6 +128,8 @@ enum {
 #define AC_CPU_CR4_SMEP_MASK  (1 << AC_CPU_CR4_SMEP_BIT)
 #define AC_CPU_CR4_PKE_MASK   (1 << AC_CPU_CR4_PKE_BIT)
 
+#define AC_FEP_MASK           (1 << AC_FEP_BIT)
+
 const char *ac_names[] = {
 	[AC_PTE_PRESENT_BIT] = "pte.p",
 	[AC_PTE_ACCESSED_BIT] = "pte.a",
@@ -152,6 +161,7 @@ const char *ac_names[] = {
 	[AC_CPU_CR0_WP_BIT] = "cr0.wp",
 	[AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
 	[AC_CPU_CR4_PKE_BIT] = "cr4.pke",
+	[AC_FEP_BIT] = "fep",
 };
 
 static inline void *va(pt_element_t phys)
@@ -190,6 +200,7 @@ typedef struct {
 
 static void ac_test_show(ac_test_t *at);
 
+static bool fep_available;
 static unsigned long shadow_cr0;
 static unsigned long shadow_cr3;
 static unsigned long shadow_cr4;
@@ -396,7 +407,7 @@ static void ac_test_init(ac_test_t *at, unsigned long virt, ac_pt_env_t *pt_env)
 static int ac_test_bump_one(ac_test_t *at)
 {
 	at->flags = ((at->flags | invalid_mask) + 1) & ~invalid_mask;
-	return at->flags < (1 << NR_AC_FLAGS);
+	return at->flags < (1 << NR_AC_TEST_FLAGS);
 }
 
 #define F(x)  ((flags & x##_MASK) != 0)
@@ -799,10 +810,13 @@ static int ac_test_do_access(ac_test_t *at)
 
 	if (F(AC_ACCESS_TWICE)) {
 		asm volatile ("mov $fixed2, %%rsi \n\t"
-			      "mov (%[addr]), %[reg] \n\t"
+			      "cmp $0, %[fep] \n\t"
+			      "jz 1f \n\t"
+			      KVM_FEP
+			      "1: mov (%[addr]), %[reg] \n\t"
 			      "fixed2:"
 			      : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
-			      : [addr]"r"(at->virt)
+			      : [addr]"r"(at->virt), [fep]"r"(F(AC_FEP))
 			      : "rsi");
 		fault = 0;
 	}
@@ -823,9 +837,15 @@ static int ac_test_do_access(ac_test_t *at)
 		      "jnz 2f \n\t"
 		      "cmp $0, %[write] \n\t"
 		      "jnz 1f \n\t"
-		      "mov (%[addr]), %[reg] \n\t"
+		      "cmp $0, %[fep] \n\t"
+		      "jz 0f \n\t"
+		      KVM_FEP
+		      "0: mov (%[addr]), %[reg] \n\t"
 		      "jmp done \n\t"
-		      "1: mov %[reg], (%[addr]) \n\t"
+		      "1: cmp $0, %[fep] \n\t"
+		      "jz 0f \n\t"
+		      KVM_FEP
+		      "0: mov %[reg], (%[addr]) \n\t"
 		      "jmp done \n\t"
 		      "2: call *%[addr] \n\t"
 		      "done: \n"
@@ -843,6 +863,7 @@ static int ac_test_do_access(ac_test_t *at)
 			[write]"r"(F(AC_ACCESS_WRITE)),
 			[user]"r"(F(AC_ACCESS_USER)),
 			[fetch]"r"(F(AC_ACCESS_FETCH)),
+			[fep]"r"(F(AC_FEP)),
 			[user_ds]"i"(USER_DS),
 			[user_cs]"i"(USER_CS),
 			[user_stack_top]"r"(user_stack + sizeof user_stack),
@@ -1228,6 +1249,12 @@ int ac_test_run(int pt_levels)
 		invalid_mask |= AC_PTE_BIT36_MASK;
 	}
 
+	fep_available = is_fep_available();
+	if (!fep_available) {
+		printf("FEP not available, skipping emulation tests\n");
+		invalid_mask |= AC_FEP_MASK;
+	}
+
 	ac_env_int(&pt_env, pt_levels);
 	ac_test_init(&at, 0xffff923400000000ul, &pt_env);
 
-- 
2.39.2

