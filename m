Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E023357E846
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 22:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiGVUXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 16:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiGVUXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 16:23:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2091FAF943
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:18 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id b10-20020a17090a6e0a00b001f221432098so2614317pjk.0
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NINnO0u+rS1nQj0nYR1Q0tDMfqB2BixwK3awIOe4L84=;
        b=jhB4fK1qnN2kN7C1Uz7Qljzpv/g1v4QhesHdUWd2nLP/FK6P9Z4qNM/1jNFUStcPL1
         WAx8FMgyVFIs0zs99WPt28HT+YnU6/KGiOE6S73aNC7I7iqvtrmWmMEXmk9kHMEghZ4y
         K/J8KrkDVDNcowsJ3VL2Pfv8/PHeml6e1j+vyfr3+0Yuu2nsr0IsdR+Cqi8GK1tu2P/d
         h6Pq4Kvsg2lenb0qwx11oKAWtFkSjndnJ+CZRwIHnokRLUUg2Y5jLGW7VXnT9n239UbG
         Aluz2KQv0yTvLy6QVhz992M0TQI3d+8L+J8fWJUXDU4aSvkpfX/BdZ0+kmEWadklGBKw
         LIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NINnO0u+rS1nQj0nYR1Q0tDMfqB2BixwK3awIOe4L84=;
        b=OY+4+/r0YreqlVX5GHRIpL9ZshtinkJsv4rf4xsqsSWrAKAr2T5oLf/FTr0LZwX/+0
         j1shK29IUAZaebLMBHmebI9Z6VdhIydG7xiRgEsj8XJA1QMNjIGRRnLtjPdM1QYC4NQK
         gUD5oBEUTYoF3SEZROJekYPj2EfbIstwMb5LpaE0yUc0Ugy5gmsBkg1EXo2xj6r/b0e7
         0Nk0rMFaxjo0VUUTrbDm8faaqgoCrOf9E05kxuAykmlmirXAq3oS/3Yn2zv0TyRB/QhC
         y6FgKzkR9r5pf24O/JHT1HR0RB87OmQv72KR5nmYemeNV8ZK7jnvF1jj8li/Cd0yzmJc
         fgUg==
X-Gm-Message-State: AJIora/0fQNBiut+RC4Ql6wuePERybj/VCryaTzcE7K9D/IPyEJK09C1
        qeugxzkInyEcsV5t5bkcvRQLG9z3w05WQpZ1Ouf9BnQxIIisJUL9PjYlz7psS4ZutlpYnXkIlcJ
        rS01JuFjna4yGgtG2FKMfatMohq8uNOTH6c1i8QwPCY4Hre5/f4+aScbaM+1CxeTg62b1
X-Google-Smtp-Source: AGRyM1s4ND3jUItqv+7xvgSl5rR1i8VY6viX/x2zkOqnM2sdls84/Oz5D7C3bGY/Lz24ry9KAyFCFGtG0ZkIto82
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:cf0c:b0:16c:8a4e:746b with SMTP
 id i12-20020a170902cf0c00b0016c8a4e746bmr1226090plg.37.1658521397505; Fri, 22
 Jul 2022 13:23:17 -0700 (PDT)
Date:   Fri, 22 Jul 2022 20:23:02 +0000
In-Reply-To: <20220722202303.391709-1-aaronlewis@google.com>
Message-Id: <20220722202303.391709-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220722202303.391709-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v3 3/4] KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
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

Add the mask KVM_MSR_FILTER_RANGE_VALID_MASK for the flags in the
struct kvm_msr_filter_range.  This simplifies checks that validate
these flags, and makes it easier to introduce new flags in the future.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 2 ++
 arch/x86/kvm/x86.c              | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 404b031f78ae..fcf300158c9a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -214,6 +214,8 @@ struct kvm_msr_list {
 struct kvm_msr_filter_range {
 #define KVM_MSR_FILTER_READ  (1 << 0)
 #define KVM_MSR_FILTER_WRITE (1 << 1)
+#define KVM_MSR_FILTER_RANGE_VALID_MASK (KVM_MSR_FILTER_READ | \
+					 KVM_MSR_FILTER_WRITE)
 	__u32 flags;
 	__u32 nmsrs; /* number of msrs in bitmap */
 	__u32 base;  /* MSR index the bitmap starts at */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index adaec8d07a25..6c1a531e3b88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6349,7 +6349,7 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	if (!user_range->nmsrs)
 		return 0;
 
-	if (user_range->flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE))
+	if (user_range->flags & ~KVM_MSR_FILTER_RANGE_VALID_MASK)
 		return -EINVAL;
 
 	if (!user_range->flags)
-- 
2.37.1.359.gd136c6c3e2-goog

