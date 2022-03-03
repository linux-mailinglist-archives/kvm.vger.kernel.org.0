Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9284CC23F
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiCCQFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiCCQFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:05:34 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5349E1986DB
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 08:04:48 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id c12-20020a170902848c00b0015025f53e9cso3152479plo.7
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 08:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pFhtq4SarysYe9oxC111dJQSetUbDTizJsJuJ+RcfS4=;
        b=KXnIJaKGcgH6Gk30m7FKapDGNiIvPKj5HIXovO2i0ceQJKz8HjFypEtR54muz/WN5e
         r4JtZ55rtLLp557YuM6iXsZjiyAsVjBFq7u9f4VaF60vznYvJ0ugqUpLPUu1BUPkourA
         Utzfj9V4h/LC+sbB7JisYPwz+EyGYe+uQ1/MYA9tex3jO5dONXzVMb3JSgzHSR7DWlrh
         hzZuLrAH8RMrtT71dL+OiZbU4QS/cZVop6PfRv/88THDJF89mE+3SblObmmsS2eWoRhW
         8fHZPdEDR+BCnlpQqmIRmR93Cmiq3HG8wpUDGLvjRB+JonQ28/0psZeI+l58jmVGrp04
         Qfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pFhtq4SarysYe9oxC111dJQSetUbDTizJsJuJ+RcfS4=;
        b=hS6CwAylHV5ZFU3BJevjkMmU7+HHcYvUWScOtbItA+bNTCYXY3PwJnuabNaJiIOLlT
         wGNVNl7P9H13XlN6mVaA8cYyC9XZlHbqCM2zl2L+UaFntlVLqDTbI10Kd9BcSWFuP/AD
         BOBO9DB/RRr+OrB9oNFaleVSWr2A8/EHb/8fcYHmVLluIKjiwqF55AUEDm5Colpt2Q94
         gPN1ybgYHN7r1SS7jIM5ipH/FJfnb6dUkpfpx2eyIkXv+Kad6/t906O1ozINoc/0Z+k+
         AjOegpUFunHzXm52q3dpnJDlUUUk77ux9ii5HT8Dpa6BDSBhg37rZSmwAQW4yoH+9Cfn
         1GHw==
X-Gm-Message-State: AOAM530VFlyG1pliRE/YR7Pz/yl4JCssuqqlaMNOdaSRwAn1ODP9mMfg
        tiT0/53m3bdlKa62JFNX/gEZjNGw8zHiPOxL6NnC28w2FKuPa+3ddvQgc1iX00k4MHxtTkOW5tB
        7izBKP5SpD+CpehXJrIvw7ySvaf3QyHMCL8jLcGT75I/u9i3xGllTXhfqYw==
X-Google-Smtp-Source: ABdhPJynstxJuHD2FDfX+TswrMqE32RgCuGQqLqhvICbCOJSXNyRSOvTUX1x7iBOGh/qlkdzQDs/9y4oeGM=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:9e02:fb61:c5eb:4183])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:240c:b0:4e1:2d98:d2c9 with SMTP id
 z12-20020a056a00240c00b004e12d98d2c9mr39052757pfh.51.1646323487365; Thu, 03
 Mar 2022 08:04:47 -0800 (PST)
Date:   Thu,  3 Mar 2022 08:04:42 -0800
Message-Id: <20220303160442.1815411-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH] KVM: SVM: Fix missing kvm_cache_regs.h include in svm.h
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

Adds include for is_guest_mode() in svm.h.

Just compile tested.

Fixes: 883b0a91f41ab ("KVM: SVM: Move Nested SVM Implementation to nested.c")
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/svm.h | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
2.35.1.574.g5d30c73bfb-goog

