Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5682552F567
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353799AbiETV5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353800AbiETV5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9081A04BA
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q64-20020a17090a1b4600b001dfc02fe731so4158871pjq.0
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+O7sOCqFij4Cg9LTfpyCAY9gXqKy94OnTf8FSIBC0lo=;
        b=eAiIdTonfqHcoBQFnow40OlKYZnyLqG04Q5S9/X1WFzHqlPN1DKleCLTeD706ZR4CK
         tW4PFm2KPcuDcOGRaYKS5HUQlo/jxR1o3Zj9D4W5l5vkbsda8AhitXkwgnsrXBVl9SMA
         ClImdActs2F+BNKCDGuWfFrAAvBSRM9CPJxjy/+97BNFQ8OG3IHCpzQr6lPLGlJxl7OO
         rF4Fcmq7CvKIKrWdJZ4/jj7vnF2Y6mg+GwB9DNlSWomxC/T6HRBdt3JX2tYYTV5PglZh
         eVUXjInF7JQcBLTBHmJSfNMy0ju4o6M88Q3Hht1W3gZpEDRG2JkS64BhNxmlE9xePUSS
         VvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+O7sOCqFij4Cg9LTfpyCAY9gXqKy94OnTf8FSIBC0lo=;
        b=75zb4YAhjb4uAkaN4opamGxitwW4C65AXQb9kc7ZRsSdx91c2ulG1gig4iq/vzdPTH
         ucNJS8PoIN1RrYie60Jd03Vu2y3Hymte2aw1PFh7Qsh9ewCyN7Bexu8PRH4501/dbwyJ
         o/SIPxgHc+6Iu1XR7fjyJ9R24OhR+B05qdFquafPoRKX+6gEBStfzCzdYra1HCm2VAHL
         AG9yBgsRu9edyC2XhuXFyy8tClBkUgL0nq+5pw65EFV88w0D6VzY3AcbgoOUhYX3WhhF
         sLyKC2MQAM1a6RD3X7L8SJzGqsd2f6MnRR4e37KictJ+Bl+ecWQAjTKa8+8sFTf/SKOh
         uCRw==
X-Gm-Message-State: AOAM5322uHt2aS3KtccqsOyaUVToCg4d+kKConiwW72rYHqyFl1wBFFa
        0Xd1uCRSUk1wqEA83/E5WQrauqW16PsyMQ==
X-Google-Smtp-Source: ABdhPJycDNMXBzHsvuBRbyFuFvEcxIXJntsN9HxI2lZSvck6iqMCOTq+KbSOI47nT6uUlsb15qalh2yeHjEKJA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:6dc3:0:b0:505:895a:d38b with SMTP id
 i186-20020a626dc3000000b00505895ad38bmr12211524pfc.7.1653083858964; Fri, 20
 May 2022 14:57:38 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:20 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 07/10] KVM: selftests: Drop unnecessary rule for STATIC_LIBS
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the "all: $(STATIC_LIBS)" rule. The KVM selftests already depend
on $(STATIC_LIBS), so there is no reason to have an extra "all" rule.

Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 8c3db2f75315..ae49abe682a7 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -192,7 +192,6 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
 	$(AR) crs $@ $^
 
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
-all: $(STATIC_LIBS)
 $(TEST_GEN_PROGS): $(STATIC_LIBS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
-- 
2.36.1.124.g0e6072fb45-goog

