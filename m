Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E9652F63C
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351257AbiETXdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354122AbiETXdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803E71A7D1B
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w12-20020a170902e88c00b00161f70f090eso1250388plg.11
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+O7sOCqFij4Cg9LTfpyCAY9gXqKy94OnTf8FSIBC0lo=;
        b=KRxARGEGLtZcSh9RlvhfAxNRi/v2I1ypEBjKXthu7qovhojcytukPPz6d/CIEr5+UE
         6ArivDKm6N41zBjZEhkJrvU1BKyw/0wkWwdn8Cf7GvFxMxNqpr8b3dd5jRVzsd7r/Lpf
         bo+04tinYDngLertfMgdZJu8mD/TVY8dtt/6ngs9GjLDhdvzxPnpEE5QiOtNMqj8HVuJ
         /IQ08fseLBdbh/ixfrW+vO6fQfFcbYtQ9XLmbL4xfa6b2Y9oFFsiaDt7wBE6PgRgjXfk
         BKmSxWOJLJqnPR8aefXHTphN0ZrWA2A1PPi4BOjlFnB53ZMhLyuoBtCa5MbDADpEAaNx
         iOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+O7sOCqFij4Cg9LTfpyCAY9gXqKy94OnTf8FSIBC0lo=;
        b=1UzL6CMj1LgiodE1OLXyhYZL2WfG8NYfdiFUyhT1OEo3BsEk6HmRhAV0tjTvi6K+Z6
         Ps/yKIBAVvXZpwDRSDoDKu3wG+kuj8l365nLlGE2wK17a41+s9x3Ft6C8F/YI0+jioYS
         ZioAVhqmHc7Ah72OScl4sxdp/OYWa4fggWO4bhzC7toPLL4p0eBKSaf1YANGuXrm+3ae
         twldomuNjjFSjdb1nrs5e7lsN3MUYo9v8mx8jBN7LRZX0FgfXoFe15ApTAgch+L+kZyb
         FGtPtLet1OofTiMenO4VEXzGU+VUtd/QUufTfPfPIDLDvkJ+UujpbWQopx5nnp+VpCk3
         XqiQ==
X-Gm-Message-State: AOAM533zBev8cMnddNxHPu7T290F/SH7yLGGxRxlyYAxDPcTDaioYLyV
        Gunupldc7WXI0Am7YMNd9Rzw1HX18oUHDQ==
X-Google-Smtp-Source: ABdhPJyiFbp4MV+j6mWFwm4EEwIoYtKq737jRlE26jFb62bAEldjFQXxgt2taNuoLX80ihRfvfPqtycugrDHaQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP
 id d3-20020a17090a8d8300b001dd258c7c55mr490709pjo.1.1653089585563; Fri, 20
 May 2022 16:33:05 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:45 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 07/11] KVM: selftests: Drop unnecessary rule for STATIC_LIBS
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

