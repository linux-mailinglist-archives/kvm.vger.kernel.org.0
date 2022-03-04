Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A834CD8A1
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 17:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbiCDQL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 11:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiCDQLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 11:11:23 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6591B0C7F
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 08:10:36 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id g31-20020a63521f000000b003783582a261so4757402pgb.5
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 08:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7g/ezXRkUePVHzxAmU7TrSdmaet2aJR4hjHRm264YDA=;
        b=mJQPI1UesYIFKVN6p6er/YNCnb2xSe79Zwvcfc/PHObkfznrFxErekv9iFoCnRdGwp
         r+1riJYsF6PkSj9m6fJmZhfnVXYiebeX3keLZNX+zNJQYlfbJtVqi2JCSUzeVNUaUl1m
         CXymFTXegyXeWTeZYn+pu/Ew9C3z7hYd9mR5piitqdaUJ6FMEFxVrHn9xzwqDjF7UxSs
         pe642OAUGcQoh7hYdrUouCLeY07VZKND/nRWrKSz6qakGmynWsYDPhfbWxhsFxIf3FYu
         AbjtnCKYMfDK7yoA5M/kR3iAeD1+vGBXueStALl+0KC9J/1kpTvaO7OvLSviBlco783r
         yeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7g/ezXRkUePVHzxAmU7TrSdmaet2aJR4hjHRm264YDA=;
        b=5RGqppI7fDH9AieZ7btMCKf0tk4zH7ORPtMxPq52oRE6Mt/VLRhhw4ZokfcZvWDl3N
         NHg3MBzVqjZI4I89rRWBmtOuLz9kaaUsirFAXZiD/fS+GXIsdb13WV1ikr4ZxGW0Emda
         5VXxhgD0Yjzvw22bMSAtNubg8Eck9ovZzepKdxD/7NyB3iUj0RHoB70WPoClCVKPUOKN
         d7Clf6KsX9ZA+UTJs24lwj5KLtSbnvqoyhzA63i4opvU8WDdaStO/VGBCZMXDco0wMO3
         N+E3Cd8rDLxhppYnaWOf82iEbU/386OaLjNlopIlsr8AOMOunIWdvb5344yvzrenpEi7
         WQDA==
X-Gm-Message-State: AOAM5338MG9ntWLZj58p4xA+kC87pG0XeW7Yuei1LRQKis1xh6rRvqMf
        9kLkgkYSWs21wzWZM1PCrQcNtudqp39fDjvqDVDPfZRULUGzx7PDr5Ejj1RQwdI+i412ycuJANf
        XY6A1WF1SJn/g0TZynJwGFHVpjWFnVtJnPzTCU0Cas+ylp47Ftm/MwCF4XA==
X-Google-Smtp-Source: ABdhPJxb81xCCsYdx8G4+8O3wneI79w3fn9sUPWii8tb85zALFJlG7WfTwEihyej9GeXDNGBWeF68KdwK5c=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:9a79:ce7a:f894:68d2])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:1aca:b0:4e1:a2b6:5b9 with SMTP id
 f10-20020a056a001aca00b004e1a2b605b9mr43761413pfv.4.1646410235407; Fri, 04
 Mar 2022 08:10:35 -0800 (PST)
Date:   Fri,  4 Mar 2022 08:10:32 -0800
Message-Id: <20220304161032.2270688-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH V2] KVM: SVM: Fix kvm_cache_regs.h inclusions for is_guest_mode()
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include kvm_cache_regs.h to pick up the definition of is_guest_mode(),
which is referenced by nested_svm_virtualize_tpr() in svm.h. Remove
include from svm_onhpyerv.c which was done only because of lack of
include in svm.h.

Fixes: 883b0a91f41ab ("KVM: SVM: Move Nested SVM Implementation to nested.c")

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Gonda <pgonda@google.com>
---
Just compile tested.
---
 arch/x86/kvm/svm/svm.h          | 2 ++
 arch/x86/kvm/svm/svm_onhyperv.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e45b5645d5e0..396d60e36b82 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -22,6 +22,8 @@
 #include <asm/svm.h>
 #include <asm/sev-common.h>
 
+#include "kvm_cache_regs.h"
+
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 #define	IOPM_SIZE PAGE_SIZE * 3
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 98aa981c04ec..8cdc62c74a96 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include "kvm_cache_regs.h"
 
 #include <asm/mshyperv.h>
 
-- 
2.35.1.574.g5d30c73bfb-goog

