Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8240569B527
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjBQWAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBQWAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:00:16 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A36559726
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:12 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5365780ce32so20789247b3.23
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4OP9lL5HFo/s6obKjyt5S7A/ZCzo8E75OA2vEjP+a6c=;
        b=mGkpZRo12t+BW97KkeX/KWi+6jN48HqA2C9HRu/r+amVkR01zl/dVHajZXCKugk2yD
         Gr9Mx4gSgtB2tRtmlb8gEYNKfps0vdbYg0hVjto7P4EHKQ2rbcPtC5JjcF3FsL5kkFJK
         ivRGXYz2TBX7gf+dnveX4+wN8iEYYQUCpmvGnrAwhoJWyB+FRngAjwK5RnR8QtiKfGCI
         PtpRiBlfn9U+vVtNbrkuEs8qc/Ok8kUnALz7pOg1giGFfjYxvFBrOv+biWbsmfzcGgx2
         dEsGyuNU3/q+3chHLOy1OyLef0O7cC9oEIAszRJGJqt9K+Q3GHvCn90FSiu9s/wzIfnj
         dDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OP9lL5HFo/s6obKjyt5S7A/ZCzo8E75OA2vEjP+a6c=;
        b=5bXAUzE18nyEMPFyvUwPJ+fiAXiFxStLVJNtGdG3RUQupQOunP5NwztBaYVms46rHD
         RUgt9LNRJLvslzempL1nD5OGVPl9QHUbcQCh+TM30QOk+Cvz/5LePt5y0YX/BavspWxB
         PiAJLQ78fBrr/Ot5Adhbbu99HMo2pR+zVU4J+m99VZpR8HaF77ZK24JVlaJ8Z2emGZ+M
         iRn7EzG3dtalsCe/bHyqcxPehs4MsPY8B721MOItoIZUYJm2IhCWA0zyVSmw10g8Mfni
         dvTphTLF5j9+vYTZfFDJSYzO3Ls00AQlXjh73jmE3XBVdsv0DjjMwQt2ViHJGgMXb72T
         0C3A==
X-Gm-Message-State: AO0yUKWHlDiC7/2KmlRDGg3Qai3bZvXYImO5EkJbwqcMckoPnOWuESql
        q5sEpzY4uTPRNCnzXsITu+QLIqwrv58qat+HoNJwSGJx+4O2B/zY0gGbudjt90pFEy/dUtU/8ow
        J6SZOMaKGOqJldzxJW7kINt0JiIx3Fz/7LBE8QPm3hq3R90YV0UiByg352d3085+O5ypU
X-Google-Smtp-Source: AK7set94FbZvnoiYBE2Pg2P3PTOo96M4b4j/Zvrb+xLnXVvu/Np5zUDtYIb/awWKZ0+2mDqN+FjsWAvlaLMjznl0
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a0d:d449:0:b0:527:9d77:e4f6 with SMTP
 id w70-20020a0dd449000000b005279d77e4f6mr1466405ywd.488.1676671211729; Fri,
 17 Feb 2023 14:00:11 -0800 (PST)
Date:   Fri, 17 Feb 2023 21:59:55 +0000
In-Reply-To: <20230217215959.1569092-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230217215959.1569092-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217215959.1569092-2-aaronlewis@google.com>
Subject: [PATCH 1/5] KVM: selftests: Assert that XTILE is XSAVE-enabled
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The check in amx_test that ensures that XTILE is XSAVE-enabled, doesn't
actually check anything.  It simply returns a bool which the test does
nothing with.  Add the intended assert.

Opportunistically, move the assert to a more appropriate location;
immediately after XSETBV.

Fixes: 5dc19f1c7dd3 ("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b670..7ee8b68064000 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -119,11 +119,6 @@ static inline void check_cpuid_xsave(void)
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
 }
 
-static bool check_xsave_supports_xtile(void)
-{
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
-}
-
 static void check_xtile_info(void)
 {
 	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_XSTATE_MAX_SIZE_XCR0));
@@ -180,6 +175,7 @@ static void init_regs(void)
 	xcr0 = __xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
 	__xsetbv(0x0, xcr0);
+	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
@@ -188,7 +184,6 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 {
 	init_regs();
 	check_cpuid_xsave();
-	check_xsave_supports_xtile();
 	check_xtile_info();
 	GUEST_SYNC(1);
 
-- 
2.39.2.637.g21b0678d19-goog

