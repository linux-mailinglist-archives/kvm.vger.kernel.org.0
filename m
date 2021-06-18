Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE773AC9EC
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhFRLdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 07:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhFRLdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 07:33:32 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A27C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 04:31:23 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r9so10388178wrz.10
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 04:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PwVNr/+j4L+mUcJvknEGzFrgdJDTH4gF5hiwhU59Sb8=;
        b=Sq90ZoJ84ZPbqjwM5EajkrgHagWkiEmjTdYu90hdzKzgPzNdXB58dj9YIu+oCVFuf3
         ZbF3MC+Yslk3fzrlbavpVtK0/0gHeiWw6nYTuqHJX9bFcXuJ3OKm0fvePctqRxxh+Hog
         nJ3TWgQ6Pkuu7jNcpkg4TUDVST+2nQ7H06wt9nnxi+IqMA+39JZ/WBCxMpQ/xca2c338
         6kfEFUPWmyLmnyOvTtEKkiXAUoPNa2TmCRjpJ/swlVzQw7VYn4GOIl5cbPJxpVVEaik0
         xKQrvMubt2NVddw55y9lghAb30f/MvBNN94Eu+6Dk+LTPU4QhVX6pX2ccSvJYaPJPlTR
         30ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PwVNr/+j4L+mUcJvknEGzFrgdJDTH4gF5hiwhU59Sb8=;
        b=q+5QLXx2W4tUL4TD+s9A6Wf/B7AeU4eyU6ce48N67iEhxQW55WbMREyZCIAoDEzHyE
         U1U3M3oeClPu4cmh20FW1LmUy1sGAP+DNG5VamQtmKQIngHgZNBAxuqCZXJBw7KJ8aGp
         FgzXWdKXtLKiM929hOQbLB7Uj3IVx6Jkr32Qgox8NqMD7FMwxVD+uAfdTEBjK2ajEYHi
         mBW1RqvBoS8mVv/s1wzoJ8TXym03bX/KufuDtpANLT2oPRe/yEcLieB28w2x9zKnNVLW
         GL8iHLIZnyTWGzHi/pkK5emjefHjV4TRcHL6HaHpCHAfZxXBC+OCrrF/TMlwbj0Vy/4G
         b/KQ==
X-Gm-Message-State: AOAM530LDvPPoZej3gGvk7e62bf60E7mTavS05CrvjwcDw21FnqeYsKg
        dUtTm9/5rqWkom2bTN2fWXyODgGRXiGQYA==
X-Google-Smtp-Source: ABdhPJyekAfturmCm6jnxEYsIV4+leEWfyQ88LlGIE65KwUcqvWwM+JzWIf1LqRhHDgQPz5qDvKtvw==
X-Received: by 2002:a5d:6409:: with SMTP id z9mr11540731wru.279.1624015882236;
        Fri, 18 Jun 2021 04:31:22 -0700 (PDT)
Received: from localhost.localdomain ([2a02:168:4614:6:6eb6:af83:5aab:ea79])
        by smtp.gmail.com with ESMTPSA id x18sm8173120wrw.19.2021.06.18.04.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 04:31:21 -0700 (PDT)
From:   Lara Lazier <laramglazier@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Lara Lazier <laramglazier@gmail.com>
Subject: [PATCH kvm-unit-tests] svm: Updated cr4 in test_efer to fix report msg
Date:   Fri, 18 Jun 2021 13:31:18 +0200
Message-Id: <20210618113118.70621-1-laramglazier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated cr4 so that cr4 and vmcb->save.cr4 are the same
and the report statement prints out the correct cr4.
Moved it to the correct test.

Signed-off-by: Lara Lazier <laramglazier@gmail.com>
---
 x86/svm_tests.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8387bea..080a1a8 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2252,7 +2252,6 @@ static void test_efer(void)
 	/*
 	 * EFER.LME and CR0.PG are both set and CR0.PE is zero.
 	 */
-	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
 	cr0 &= ~X86_CR0_PE;
 	vmcb->save.cr0 = cr0;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
@@ -2266,6 +2265,8 @@ static void test_efer(void)
 
 	cr0 |= X86_CR0_PE;
 	vmcb->save.cr0 = cr0;
+    cr4 = cr4_saved | X86_CR4_PAE;
+    vmcb->save.cr4 = cr4;
 	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
 	    SVM_SELECTOR_DB_MASK;
 	vmcb->save.cs.attrib = cs_attrib;
-- 
2.25.1

