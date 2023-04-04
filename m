Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAFB6D6987
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbjDDQyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbjDDQyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:07 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6980459EC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:50 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y15-20020a62f24f000000b00627dd180a30so14940886pfl.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SP7ts4lbgLDJFKSoH0ocO/p/eb09OlVnv/fxz7eI8Yw=;
        b=TYYTYT6GmQ/U8QtL914/0AmGSP/421I2wFF2s30gBfk/0jANOwDy9vsscuFqKCq+LI
         wuflYS5v5D5V84v3IowVP3UQ/8Z7SxCn/W94hLKT0egDi9rOZhlvNbvKjvz+NSlRtAbo
         LnpGzTZ4st987SWrwBDhTq2Ey4JNknsUBqEbNk2DmB7znzHJ160sehXHZGgzGA+F68dQ
         5OaQtSCiYzajhi8DXj7FYfApgA/CFR+X62pmesLu8vK0NnZAjfLcDoBaeA2baynO8yoy
         HjG4r0MCSF7D92fukY81bc2d0K9OPFRTtHg1tjxeHtaqQzQ/3BQiWyxIvivTeUF1qKsN
         G7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SP7ts4lbgLDJFKSoH0ocO/p/eb09OlVnv/fxz7eI8Yw=;
        b=LtWVJenZUCu8ECkOAmMPGRdHODbBeDB+Q1q+rn0/s5K18efMnWCxnTIjD7PzkwFibY
         rya5D7QgOzfE0GeNliqHdTQtPp9jaC//DfRbgJwnwAZ1zuOnugP0Sbu3mFLHbcRIERdJ
         HHwmkynZB9B4l605oogzByhIHUzBCOC3u96o7Ht1uYGiw+SnffQjm26X0jkdGAEu/tjp
         qIwMvlSW1XvoIiH1MdNydiUvG1S2bIeyyOq5uUdg5BPYcJ8FAHAnyOocXV3jWhpFv9/k
         ewMpjuwjqb9phjM4BVclGSVgs73m+UBrT9ZMALSZMx61POcSqvZpp/xLsLwBSPzQ65PZ
         g3aA==
X-Gm-Message-State: AAQBX9dxcDSUIYGaFxoTgWj+oriZhNkSEjVfUaae7sEaM0nwT0YdMwOl
        4TdZBtkrWDr47W//JYp1S6NJrCnHiOo=
X-Google-Smtp-Source: AKy350bJbxWfc6HnLdBwZKllC1IvZnAIRebtVAxIzw3/uR8dQC8f4TnCILP+Y7bGDaH8sgVIEa6QVBc0+vQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:18a9:b0:625:659e:65c with SMTP id
 x41-20020a056a0018a900b00625659e065cmr1669343pfh.1.1680627229798; Tue, 04 Apr
 2023 09:53:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:34 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 3/9] x86/access: Replace spaces with tabs in access_test.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace spaces with tabs in the access test wrapper to adhere to the
preferred style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access_test.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/x86/access_test.c b/x86/access_test.c
index 67e9a080..74360698 100644
--- a/x86/access_test.c
+++ b/x86/access_test.c
@@ -5,22 +5,22 @@
 
 int main(void)
 {
-    int r;
+	int r;
 
-    printf("starting test\n\n");
-    r = ac_test_run(PT_LEVEL_PML4);
+	printf("starting test\n\n");
+	r = ac_test_run(PT_LEVEL_PML4);
 
 #ifndef CONFIG_EFI
-    /*
-     * Not supported yet for UEFI, because setting up 5
-     * level page table requires entering real mode.
-     */
-    if (this_cpu_has(X86_FEATURE_LA57)) {
-        printf("starting 5-level paging test.\n\n");
-        setup_5level_page_table();
-        r = ac_test_run(PT_LEVEL_PML5);
-    }
+	/*
+	* Not supported yet for UEFI, because setting up 5
+	* level page table requires entering real mode.
+	*/
+	if (this_cpu_has(X86_FEATURE_LA57)) {
+		printf("starting 5-level paging test.\n\n");
+		setup_5level_page_table();
+		r = ac_test_run(PT_LEVEL_PML5);
+	}
 #endif
 
-    return r ? 0 : 1;
+	return r ? 0 : 1;
 }
-- 
2.40.0.348.gf938b09366-goog

