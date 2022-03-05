Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D2D4CE713
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiCEU4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbiCEU4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:56:38 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D476210F;
        Sat,  5 Mar 2022 12:55:47 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id f21so9057868qke.13;
        Sat, 05 Mar 2022 12:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R8MoG4V6/qvajTZezIe9y4jfAXlOuicKSXlBnDiaTLs=;
        b=ikeRqzIDcQ5A6KXHh00Hrqd9XQYEiZZTg+px37l4jUHXaZfQGVxdPw+neR8LpjR1hd
         A4t4C5iVorYzo90KgMEjSaZPpmFkCS8cQsojrGOw9k8F2vuEyXw1P9HbkONLEvj5GVk5
         hoUeeh7PjwKU1Uh8YE3BHpJ9xJXqftnQ/P1UymWA9Ou6Og20IjJ0MlqMdKEBjuRsud8X
         sury6vZOX5zHMMAn3hGi0qwFlgVMrtAbql4Ms/PP7Z+6hTysnV3edj063nnRh6WkR1JK
         IAlHXw5W3XG0h9gxi0y1H098IVMIC1//7TsKA5UFYVB4E5+hEbu3D83vgMcBCVLWDlYO
         VUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8MoG4V6/qvajTZezIe9y4jfAXlOuicKSXlBnDiaTLs=;
        b=EOWSUcalQQAcNtuRvS+xZWt5H0rstlPjLUW65OVa/xczwmauYloMTwQ/UXQcxm4LPw
         aXsI4DR1P8P9gAYjggOHjf1i//QxYw+ihXVKwSu6ws1XSI380pepqVqzEwMT0xqh4z3Q
         Z8xPa5xgV67zroFHsNcj8F2ofgKWpN0D+oBagMeLxlKaZvI32Nbr7jb4GZAHMC9R9fmY
         Dsc0SSDhFAU3uTpuXXWYHWGtrZH0lPysYKndnrrKGmwRkDNtlp68b9cWaKlEfSRTUjk2
         X0pcyJKH4jlDNb/O38uERZwC9CjDdv4vVKDBNW+eFp5n5YgZm0+/Q+gKZnper4Ok5Tg3
         n9qg==
X-Gm-Message-State: AOAM533X8TS11ivICVUxtE7X8UQdrfedxqMYTCeScxyoyu3zjf3xDYaS
        XBoHjK6PfGg3Fl0xZl8tGgo=
X-Google-Smtp-Source: ABdhPJxJFvKgeSdZT78GejgzfYS4YE3MXAzM16FaBJ2HYPUuiBzA09NdX8VtM0aWaxutZ145CA3P/Q==
X-Received: by 2002:a37:414c:0:b0:662:cd75:5475 with SMTP id o73-20020a37414c000000b00662cd755475mr2781293qka.271.1646513747096;
        Sat, 05 Mar 2022 12:55:47 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm5877525qtk.8.2022.03.05.12.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:55:46 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] KVM: Add blank lines after some declarations
Date:   Sat,  5 Mar 2022 15:55:26 -0500
Message-Id: <20220305205528.463894-5-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305205528.463894-1-henryksloan@gmail.com>
References: <20220305205528.463894-1-henryksloan@gmail.com>
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

