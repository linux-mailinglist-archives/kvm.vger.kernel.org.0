Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2AA4CE6F1
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiCEU2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiCEU2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:28:03 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7A55F77;
        Sat,  5 Mar 2022 12:27:12 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id f21so9027715qke.13;
        Sat, 05 Mar 2022 12:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=78JXHf8AeJE2E5nu1qxO5NCf59nW451KVhH6hOq/Ffk=;
        b=XTttFGymcCjQoMcknHu2Dxm+PuwiIIk6eFJ6R7wZC9GMyWC7XXwnDQ5IMD1S2ZTEZ4
         7bfi0NQx9UzsJ4bGU2NaBIfVmEjOx9PPFNSrxyPP0xRGYSeUEgXlkp1hK14qcstBPjs+
         cL4hCoyNbWTGe2bZF5rQZwvKNa2lM3wUmZtCDddU3oFbOW9RoFdJXEQxJE735gRDE4t9
         uiAst4iOJ2/zvMd3bG6+T3MEmrklFo8Si6HLXCX5czWgaIEVFTFj2EELV9Kf/BJ3G1PP
         H3BT1Lw9Onapc+sq3awn/nUTReoiqhYjniRUyE+O1pjzb/IOoT00ibgFX0Cx1He2DV9z
         qXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=78JXHf8AeJE2E5nu1qxO5NCf59nW451KVhH6hOq/Ffk=;
        b=O3hUns4jL9P53WSUGJjwW8TwMDdSEPuFnSR19/oNzQTtgeiurYFnl1+ErZPN6Suy37
         q0AU3ZKEi1szooAMAZd6mQgPUPovEj4N2j1KgijDDUr9e3Jd2ZAx9y1mTMzlYxVE3QP0
         T0BM2pUpfq2y6ohh7jGWC1YhIM0T96PXkeowRNALNevM7YpaGfOm4x8czY1GILqfgI/Y
         372qCxEXGQMgj7PFh4zz3wL/iuaI2eRwkh96iPwxQDfGaCJUCzj9H9qGviwi/mRV4TFu
         i01mMRBfqRAT1nOdIrp24bhWRqslDmTrt2305Wcvrx06yQaTJ7jf4XlFnXvZLNSc/srt
         C0Pw==
X-Gm-Message-State: AOAM532ubnAd4gDS/1ClTjoYHYw3gH43GCMZ0AYY9gVoimNaOq+69Asm
        oKvO6qAvER6ZfO1WOyZho/A=
X-Google-Smtp-Source: ABdhPJxcOtSzih55NyW8Fyp3NqRhmU1TyxYJlThagoz4x726ek4R7qmDu+wtoEMlHypUWFV6A8ZYCQ==
X-Received: by 2002:a37:9744:0:b0:508:48cd:5f91 with SMTP id z65-20020a379744000000b0050848cd5f91mr2717847qkd.127.1646512031646;
        Sat, 05 Mar 2022 12:27:11 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id e9-20020ac85989000000b002de2bfc8f94sm5654208qte.88.2022.03.05.12.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:27:11 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] KVM: fix checkpatch warnings
Date:   Sat,  5 Mar 2022 15:26:35 -0500
Message-Id: <20220305202637.457103-4-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305202637.457103-1-henryksloan@gmail.com>
References: <20220305202637.457103-1-henryksloan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix "Missing a blank line after declarations" warnings

Signed-off-by: Henry Sloan <henryksloan@gmail.com>
---
 virt/kvm/eventfd.c  | 1 +
 virt/kvm/irqchip.c  | 2 ++
 virt/kvm/kvm_main.c | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 14aef85829ed..2e47bd13413e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -195,6 +195,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode, int sync, void *key)
 
 	if (flags & EPOLLIN) {
 		u64 cnt;
+
 		eventfd_ctx_do_read(irqfd->eventfd, &cnt);
 
 		idx = srcu_read_lock(&kvm->irq_srcu);
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index baa551aec010..69a327c043d7 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -86,6 +86,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
 
 	while (i--) {
 		int r;
+
 		r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level,
 				   line_status);
 		if (r < 0)
@@ -122,6 +123,7 @@ void kvm_free_irq_routing(struct kvm *kvm)
 	/* Called only during vm destruction. Nobody can use the pointer
 	   at this stage */
 	struct kvm_irq_routing_table *rt = rcu_access_pointer(kvm->irq_routing);
+
 	free_irq_routing_table(rt);
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index af74cf3b6446..1988dd081606 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2171,6 +2171,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	     i++, offset += BITS_PER_LONG) {
 		unsigned long mask = *dirty_bitmap_buffer++;
 		atomic_long_t *p = (atomic_long_t *) &dirty_bitmap[i];
+
 		if (!mask)
 			continue;
 
@@ -2477,6 +2478,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		 * not call the fault handler, so do it here.
 		 */
 		bool unlocked = false;
+
 		r = fixup_user_fault(current->mm, addr,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
@@ -3053,6 +3055,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
+
 	return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
@@ -3887,6 +3890,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	switch (ioctl) {
 	case KVM_RUN: {
 		struct pid *oldpid;
+
 		r = -EINVAL;
 		if (arg)
 			goto out;
-- 
2.35.1

