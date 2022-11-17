Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EE562D65B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbiKQJUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbiKQJUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:20:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F64AF0AA
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:07 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t9-20020a5b03c9000000b006cff5077dc9so1031136ybp.3
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3UZNWoJiM/brdBfnlSQVfGomrP8YUnpl+/J+ZYaMsWg=;
        b=Y7FV1nPzOoJGNKyEGah3rBzXaTAgRbqjNXiA6IMm9OytIJ/ZVdL8nz9t2nXZNr0mb3
         3fgCwAC3wGzqpyxXTb8XCPQg10PwVJPtC1yv7EelWwHB4DNJN+22iMdry8WRQIWcpZoJ
         AtaEH4pXVs6DP43ZH3Y0pOg0v1pWzjctIZM1y04S4G0fo/YHUHOHr8iq6IFrG+IieA6A
         mQMgLUbl4aejQev5s9AdAeh73Ny3m0LXrep27CqBvYRiKi00yEsBXg4oSegGtxEe3uin
         zxU04orTU57spQqZ5PNccg+hpJM6m874gQTkNixGL2UvUTHzR8gOAXK9JD3TnQ08AosX
         beuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3UZNWoJiM/brdBfnlSQVfGomrP8YUnpl+/J+ZYaMsWg=;
        b=MQ12D19rGfGA4DAHkTg2pXibrS58KpOkekjARk+QERkMBwLrOY13PDinykFy/ZOgqK
         QKUdWDEorH9eOAIyNF+IJrqDE4jK96j0KygN7MMWJsSVFiZzeYUoBwv+PYL0yRoq0n5j
         auIupwd6NUulDvU5FuFg94SIrxQk9DOldu8sA7e5+RLa1Iqn2te1O5PWcY2AXi5yxGc1
         JDjDy7mnYIHMt9cggqWY1wA7G5MBtJSG6fy7ylepUDwHSVXjmF9gHfQFk1tV7doVdmI6
         2AuUVi0qiuke7zutMC2iufdM7AnfM/SFL52A2ftzWOIgvhtyoMcJH+mmBqi7ftSJyPZ9
         gBnQ==
X-Gm-Message-State: ANoB5pl0dKQksIedbfp99OGdUxWzVP/diUUSUp8LbCYILzxH2UK24EqQ
        MRWQL5gh06uAFnQ2hBpBqAaX6U6Ds4k8Bw==
X-Google-Smtp-Source: AA0mqf4AQT5Qmc4IPX/RpvDMgv6XG/ZLZL1XrBmItI5NKWJNsIHffBOTuGju3kd9F4Ogyspc3UzyKcOmng3iiw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:189:0:b0:6df:d8f1:7b32 with SMTP id
 131-20020a250189000000b006dfd8f17b32mr1303704ybb.497.1668676806903; Thu, 17
 Nov 2022 01:20:06 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:20 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-3-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 02/34] Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
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

This reverts commit 6f2f28e71e6af993761b7a70bd2402a8d2096acf.

This is commit e9d7144597b10ff13ff2264c059f7d4a7fbc89ac upstream. Reverting this
commit makes the following patches apply cleanly. This patch is then reapplied.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpu_device_id.h | 27 ---------------------------
 arch/x86/kernel/cpu/match.c          |  7 +------
 include/linux/mod_devicetable.h      |  6 ------
 3 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 884466592943..baeba0567126 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -9,33 +9,6 @@
 
 #include <linux/mod_devicetable.h>
 
-#define X86_STEPPINGS(mins, maxs)    GENMASK(maxs, mins)
-
-/**
- * X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE - Base macro for CPU matching
- * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
- *		The name is expanded to X86_VENDOR_@_vendor
- * @_family:	The family number or X86_FAMILY_ANY
- * @_model:	The model number, model constant or X86_MODEL_ANY
- * @_steppings:	Bitmask for steppings, stepping constant or X86_STEPPING_ANY
- * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
- * @_data:	Driver specific data or NULL. The internal storage
- *		format is unsigned long. The supplied value, pointer
- *		etc. is casted to unsigned long internally.
- *
- * Backport version to keep the SRBDS pile consistant. No shorter variants
- * required for this.
- */
-#define X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(_vendor, _family, _model, \
-						    _steppings, _feature, _data) { \
-	.vendor		= X86_VENDOR_##_vendor,				\
-	.family		= _family,					\
-	.model		= _model,					\
-	.steppings	= _steppings,					\
-	.feature	= _feature,					\
-	.driver_data	= (unsigned long) _data				\
-}
-
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 
 #endif
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 751e59057466..3fed38812eea 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -34,18 +34,13 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 	const struct x86_cpu_id *m;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	for (m = match;
-	     m->vendor | m->family | m->model | m->steppings | m->feature;
-	     m++) {
+	for (m = match; m->vendor | m->family | m->model | m->feature; m++) {
 		if (m->vendor != X86_VENDOR_ANY && c->x86_vendor != m->vendor)
 			continue;
 		if (m->family != X86_FAMILY_ANY && c->x86 != m->family)
 			continue;
 		if (m->model != X86_MODEL_ANY && c->x86_model != m->model)
 			continue;
-		if (m->steppings != X86_STEPPING_ANY &&
-		    !(BIT(c->x86_stepping) & m->steppings))
-			continue;
 		if (m->feature != X86_FEATURE_ANY && !cpu_has(c, m->feature))
 			continue;
 		return m;
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 610cdf8082f2..c30839a15f50 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -621,10 +621,6 @@ struct mips_cdmm_device_id {
 /*
  * MODULE_DEVICE_TABLE expects this struct to be called x86cpu_device_id.
  * Although gcc seems to ignore this error, clang fails without this define.
- *
- * Note: The ordering of the struct is different from upstream because the
- * static initializers in kernels < 5.7 still use C89 style while upstream
- * has been converted to proper C99 initializers.
  */
 #define x86cpu_device_id x86_cpu_id
 struct x86_cpu_id {
@@ -633,7 +629,6 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
-	__u16 steppings;
 };
 
 #define X86_FEATURE_MATCH(x) \
@@ -642,7 +637,6 @@ struct x86_cpu_id {
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
-#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
 /*
-- 
2.38.1.431.g37b22c650d-goog

