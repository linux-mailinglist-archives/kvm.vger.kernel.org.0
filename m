Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F29A5C00E3
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiIUPPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiIUPPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:15:41 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B592895C1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:37 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id np18-20020a17090b4c5200b00202c7bf5849so2628233pjb.0
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=mDXx+o0SMLsD3PVy06z1zwjNDFp6zm0JfAMB6r9sun4=;
        b=H39EC1Dy73yp1U2mtg5STumZ9Ger+iASXr87KEagDsUZgz87eSINNk3ZXU17LMJd3o
         4i2F8zshKUo/OxbzS5W8vbnDG/RnYYVZIgAinQi86t8dWuBDd5FVw236mZJ48wj/si4E
         lcvAGoOA1WiKKg3GBN62uQPmgGu6qxnEXiZsmJcXpcbLyygj3Jwz3yy47mEygL1D6ixY
         xNyhsRzQjT3ajRW/xQT6KuuvUUSkjuMXzbkkDhHaMZf5XFyfdnYHiIBhL1y98+7v90la
         EfR+E2yDHAYIjLfkYKMoBPTddEwEcPdRCEjR5bNdiJhlgW2f+mdmbMHwybBiTpD91owj
         3sLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=mDXx+o0SMLsD3PVy06z1zwjNDFp6zm0JfAMB6r9sun4=;
        b=lrNT55besrDWyrf4rTdbhQBV0dyUPpgdZJ6jQy7p8J8HV6suZh0lJr6d5AzKwabbxr
         GiWFd9iqHoYS7aIC4Y9GrKHkfU/qBY6Zc48xwr9zocDYz8YpoBuJNLK0Oiu3B/PtmFaP
         gzIwYmxFEWHivUqyBdChyhg1vz0W+2pq3UzBs7Zn3ITrp58SQfFEW0cvznS55Qk+9d8X
         x2BLFU/cFe9JLgDLBoamrnH6i6s6BG5ke4MG7X1tlPR5u6+dotGv3PyUY2vXjt3LhoL7
         5fPi5EajoBmd/QHWZFbpzB8AzkTpjcrrop0rIPvQ46klUxyPNmBFFSP3c5YKAHHyACk/
         wt8w==
X-Gm-Message-State: ACrzQf1Ymxqmh5OywF7VMPwpQuIGxloZ5AdQteYidiALQ7zhAWzmqZYB
        htWBmN43NehhojS1nS4p947C8Kv5o0dLPktELpm8jrT2DK4CcjOF/KU2r7V4B/WTi4+OnMpRxub
        YavdR/5MUQ2wc41wH9TURBtvWTdvV7D2ID/t0bhoUvq3ahSf+QgQ0h8ui+bVmQqKhUYD8
X-Google-Smtp-Source: AMsMyM7u/oPsr56Q5teFGbiM+yQwYa55dO8iXkZD4vgEEHN+d89/AhCWEjerSASO4ljCHkjbDWliYo1POsvUBMtK
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP
 id p10-20020a17090b010a00b002002849235fmr771316pjz.1.1663773336391; Wed, 21
 Sep 2022 08:15:36 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:15:24 +0000
In-Reply-To: <20220921151525.904162-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220921151525.904162-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921151525.904162-5-aaronlewis@google.com>
Subject: [PATCH v4 4/5] KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
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
index ae4324674c49..c6df6b16a088 100644
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
index 670ae38f8f3e..48fe6a5e625a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6359,7 +6359,7 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	if (!user_range->nmsrs)
 		return 0;
 
-	if (user_range->flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE))
+	if (user_range->flags & ~KVM_MSR_FILTER_RANGE_VALID_MASK)
 		return -EINVAL;
 
 	if (!user_range->flags)
-- 
2.37.3.968.ga6b4b080e4-goog

