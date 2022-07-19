Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA6E57AA96
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiGSXuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGSXuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:50:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220F625C57
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so12169750ybu.10
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6tLAZ3S0KEa31uqY5dk3zGsG2eH/h5VqNqxXlgbbTfw=;
        b=HoA5DvFCF5wz3SjlHg1Eys6QJr0RCHOtPB0k9lmEB/Y/51FCC+MalsbSTFOZgJpuJw
         sQBdlRMlTyjYcBaPD9BdJcFTLLrKKIZRVO1E66rFb2Tbpbw1v2UKvsYmCqgidHHKHyNL
         ZDgwsOBxuzk3rB7k1Bz8KXoT6dkB2RUN8HWDG7jQZ6brB8fKvpZm7pssTNZqdC31rLZV
         Mv1Lba8X22ylyQYIqpuWBEPCFgEX8U6Ubw3Nd7YUmVhPcr/Nqdw7ErHCG0m33hWi2Eml
         65DydR60qfnxzwGoVgL30PJlwl2yDbAk0WWPPoLYIOSPX8DIzb4iY4ibzPDibHnoMo40
         1fug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6tLAZ3S0KEa31uqY5dk3zGsG2eH/h5VqNqxXlgbbTfw=;
        b=1nDtvJdTVXRs/rB67gAsR4IDDB3hrzKNXan6LsrmveE7hNpwHUcHVQoU2IG/U9rSJT
         bDIXR7A5vLGUR4M4bddaA3l+NBkvoREqtzqyYq75gE0CYn9r7wPXDq0l/aKwBbIeFCYE
         SGhXMJEHUxOQhC8JuKYsAI7RaPub1NzqNmbAH42IGIHbDCKKO4io/PIue+jcTRNLSFW2
         1AfVFIVURE24i3jqC5aTyowpgPUmUyBgM03yujK9w5yIfx2Ht80YP/1jiZis05sEmNft
         sNJARFBbIGtjYfTmY2+SrnwmzpqZDkqhD4SlBc6mRCaEFAtuZSpHYYCJygQQgBN5qHJm
         svGQ==
X-Gm-Message-State: AJIora/m7ggKvR5qoTN2ztQk8PZ7tv8mzoMGR9iNw4hxRwSLaX1yxg5S
        judt2/RRdRzpSCRbozMERXYbIpZTJtUDfZBDwWrZxoen0dw6CN6xCxUwRv3zJKVwQswpqS35iNF
        +6lSD6/xJQSU0i1yPz2tSEwrMC0dEZDAVjW852YtJQecysTwapyKe5lfUjQv1ws0kQ4VV
X-Google-Smtp-Source: AGRyM1vm2ZV9/5drYhN5ogPd3zThT+X6MZBguPMGLqyFkVV0JJaDM7pj7p4tEp3dBZi+N7mrxiKTLjW0CD0yxFrq
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a81:2405:0:b0:31c:82eb:eef9 with SMTP
 id k5-20020a812405000000b0031c82ebeef9mr38272752ywk.171.1658274620384; Tue,
 19 Jul 2022 16:50:20 -0700 (PDT)
Date:   Tue, 19 Jul 2022 23:49:50 +0000
In-Reply-To: <20220719234950.3612318-1-aaronlewis@google.com>
Message-Id: <20220719234950.3612318-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220719234950.3612318-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 2/3] KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
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
index 63691a4c62d0..a9fecd3eab61 100644
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

