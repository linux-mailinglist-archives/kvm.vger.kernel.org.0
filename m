Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE6869991A
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjBPPlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBPPlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:41:09 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84914DBFB;
        Thu, 16 Feb 2023 07:40:43 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b5so2414900plz.5;
        Thu, 16 Feb 2023 07:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfm6hlQeXTISOsTgRA62CTDZya7dFcn3HbUxfY7737E=;
        b=URfWnp43tufTZid8AK6qghhMiaZIQ9YrupQ6tltWOeeO8DhfMUwq7COxrpjZ/ChevL
         49gTFTfy/eFi53m9Tv3KeUYIEOy3/8o5enXBzSz1imE3siFoUfZ4Psw0RVLVNpxM2405
         FTsQaVruQf2vDlbqJuCDKxBawFRWsZeeEJdD1svcv23PbyYCigqJ/txLS0QXHM37XNhm
         gBBTn3y4NLhZNhB49XiYfYaN2AaH/O2Wt+9pgl7nKG3pH/Ey9BqLUuFJy0p56knyYOtQ
         13ufmZVOShbQll3rKybrXII92sV+X4wQHDFBabCId5pq7HemqDdB/b4DnyeKh5h3xzwW
         2NFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfm6hlQeXTISOsTgRA62CTDZya7dFcn3HbUxfY7737E=;
        b=J/1EGm6h+2tnalIORx5WYlUUgagEuSW5e3Oouh3HOJSwtfDR8X7y3XTOiosaHROKA4
         6UnavlUovL4b7mXIoZ+Nc0VY0dRqMxeBrKmoCkAlM3VmjsVpfp82QeloboFzX4e7fbzx
         bi9nO25NQEYzc2adp4iqjteaR+tdNNGe68/Ysr24Lk3gxgZj/niMZDj9ovo2NXlzRjMH
         hirdyE4VPZHXJlTE1444K54OSVwzcxpBpsappmDP7bPSNzcSS9JpsT5UBrbTBVU715K4
         cUCmyMbsKX3G8BcXLgnNevjSa7e1irz/YOs7n2pHyHqiGfTj3NkdR2KzPNh+VuwEM+Og
         yDlw==
X-Gm-Message-State: AO0yUKW8yAhUgZYEhmdhArz4UPoLBfxBYQZ0EZlLK/fsFRZqY5gFdFXN
        4MZ92C4O59GQR6NaAnlONN8DPyfu/kU=
X-Google-Smtp-Source: AK7set9c+LdcGEg6giWBijxKT/G23TUV9do0CD/LSQNby01nfWF3W+Bax9wh+vmFN0VPk8VIObGLrQ==
X-Received: by 2002:a05:6a20:9424:b0:c0:cee4:f77b with SMTP id hl36-20020a056a20942400b000c0cee4f77bmr4578117pzb.18.1676562043051;
        Thu, 16 Feb 2023 07:40:43 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id e24-20020aa78c58000000b00581c741f95csm1458763pfd.46.2023.02.16.07.40.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:42 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 07/14] KVM: x86/mmu: Sanity check input to kvm_mmu_free_roots()
Date:   Thu, 16 Feb 2023 23:41:13 +0800
Message-Id: <20230216154115.710033-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Tweak KVM_MMU_ROOTS_ALL to precisely cover all current+previous root
flags, and add a sanity in kvm_mmu_free_roots() to verify that the set
of roots to free doesn't stray outside KVM_MMU_ROOTS_ALL.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 arch/x86/kvm/mmu/mmu.c          | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b71b52fdb5ee..5bd91c49c8b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -422,6 +422,10 @@ struct kvm_mmu_root_info {
 
 #define KVM_MMU_NUM_PREV_ROOTS 3
 
+#define KVM_MMU_ROOT_CURRENT		BIT(0)
+#define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
+#define KVM_MMU_ROOTS_ALL		(BIT(1 + KVM_MMU_NUM_PREV_ROOTS) - 1)
+
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
@@ -1978,10 +1982,6 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 	return !!(*irq_state);
 }
 
-#define KVM_MMU_ROOT_CURRENT		BIT(0)
-#define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
-#define KVM_MMU_ROOTS_ALL		(~0UL)
-
 int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8231b73ad4d..a4793cb8d64a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3568,6 +3568,8 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 	LIST_HEAD(invalid_list);
 	bool free_active_root;
 
+	WARN_ON_ONCE(roots_to_free & ~KVM_MMU_ROOTS_ALL);
+
 	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
 
 	/* Before acquiring the MMU lock, see if we need to do any real work. */
-- 
2.19.1.6.gb485710b

