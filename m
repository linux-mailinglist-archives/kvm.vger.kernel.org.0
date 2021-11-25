Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5669C45D2B1
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353140AbhKYCBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349895AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0FCC061378
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:14 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso2302867pjf.9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SX2hoET6wj1hixKs3PjsctWsrL8zaeaTJQ+GVDYn4lQ=;
        b=kRHquhvDO5rfBATkQkWDsiLJXKbTi7getkiTkg5YoOx0XCMEOMbSgPvZBKEy2yW7Os
         iy5mWPY8XpSbj8uM35NUVuQir43Ng400TtUjCq5G3ZpxEeQqtpkganSP5t1icQ7LFSwu
         PleRvnrgVDHZV5jhgiL8EUN14v+f9SiiR/XEgA3vZVX5od+eCKsnVaQtO+LPlmml2IuM
         TvGPPUsXc52u1xzviKRBrNJ+r/X9q4E+cRhWyo71zzBXlUcqAINTz3teoUWSjcHo+uDS
         RjzVVeYTIVPm/zN35qLMuqgaCOIXlmCSlnTxoDqRQenGxUZfG3p2IbYiqbBDOz4aVbkU
         iemg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SX2hoET6wj1hixKs3PjsctWsrL8zaeaTJQ+GVDYn4lQ=;
        b=KOzAB8WVZB70yDgkC82h7nAUnMnDWl0lxmLA9VZYUJ6TtPfC1/P7oU2XM2YORcLhcT
         xu18XFmmVvuNBEaBW16vp0qkdYV+txPb7kzlmRIJEvTMMDPhCdFHvUQ1QrCBehfy2mQ3
         gCTxocsUfIR+nGl4SEBtoo2/inIwKZaX++FA0o3e1kYiPfSRFqedLuq+O93JaxSsI83+
         AJNXKRDWcWzY6f8NXuyi69MrEw87aaZI0EzafZB27wIUvTpeVHe3mRSvajzT+2Hl0qJ+
         DQM+o7jSQNB110JxiYGDQGUwKT9dLzJOuJjJzYbs6F5RNyOBL80xoAVAcda2GkN/F0ok
         sCnQ==
X-Gm-Message-State: AOAM531zjLKvYQ4fcoC2DojudWM2lKKOGED32aJM2Y+0Nislnq6u3JkF
        GeSpv3Yrib+T38cb51DVJ4tVK5/b/eg=
X-Google-Smtp-Source: ABdhPJyd/LMTWBqhwGZHW9UYumlOyFz1ufb0EDz+UL7XiSidNJCqEpFr4Swrp6xRctL5EZ/4eLoax8qxjhQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:11c4:b0:143:d220:9161 with SMTP id
 q4-20020a17090311c400b00143d2209161mr26000908plh.2.1637803753586; Wed, 24 Nov
 2021 17:29:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:26 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 08/39] x86/access: Rename variables in page
 table walkers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename variables in the page table walkers to get rid of the awful root
and vroot terminology, which is obsolete/wrong for everything except the
top-level entry.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index f69071b..fb8c194 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -518,7 +518,7 @@ static void ac_set_expected_status(ac_test_t *at)
 static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool reuse,
 				      u64 pd_page, u64 pt_page)
 {
-	unsigned long root = shadow_cr3;
+	unsigned long parent_pte = shadow_cr3;
 	int flags = at->flags;
 	bool skip = true;
 
@@ -527,8 +527,9 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 
 	at->ptep = 0;
 	for (int i = at->pt_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
-		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
+		pt_element_t *parent_pt = va(parent_pte & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
+		pt_element_t *ptep = &parent_pt[index];
 		pt_element_t pte = 0;
 
 		/*
@@ -539,13 +540,13 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 			goto next;
 		}
 		skip = false;
-		if (reuse && vroot[index]) {
+		if (reuse && *ptep) {
 			switch (i) {
 			case 2:
-				at->pdep = &vroot[index];
+				at->pdep = ptep;
 				break;
 			case 1:
-				at->ptep = &vroot[index];
+				at->ptep = ptep;
 				break;
 			}
 			goto next;
@@ -593,7 +594,7 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 				pte |= 1ull << 36;
 			if (F(AC_PDE_BIT13))
 				pte |= 1ull << 13;
-			at->pdep = &vroot[index];
+			at->pdep = ptep;
 			break;
 		case 1:
 			pte = at->phys & PT_BASE_ADDR_MASK;
@@ -615,12 +616,12 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 				pte |= 1ull << 51;
 			if (F(AC_PTE_BIT36))
 				pte |= 1ull << 36;
-			at->ptep = &vroot[index];
+			at->ptep = ptep;
 			break;
 		}
-		vroot[index] = pte;
+		*ptep = pte;
  next:
-		root = vroot[index];
+		parent_pte = *ptep;
 	}
 	ac_set_expected_status(at);
 }
@@ -638,18 +639,18 @@ static void ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env,
 
 static void dump_mapping(ac_test_t *at)
 {
-	unsigned long root = shadow_cr3;
+	unsigned long parent_pte = shadow_cr3;
 	int flags = at->flags;
 	int i;
 
 	printf("Dump mapping: address: %p\n", at->virt);
 	for (i = at->pt_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
-		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
+		pt_element_t *parent_pt = va(parent_pte & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
-		pt_element_t pte = vroot[index];
+		pt_element_t pte = parent_pt[index];
 
 		printf("------L%d: %lx\n", i, pte);
-		root = vroot[index];
+		parent_pte = pte;
 	}
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

