Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96A14CE873
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 04:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiCFDUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 22:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiCFDUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 22:20:10 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAADB877;
        Sat,  5 Mar 2022 19:19:20 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id v3so10629887qta.11;
        Sat, 05 Mar 2022 19:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wnenYWFjUgy9d4rc8M0fPy/mWdQxcbS4o+P9BZj32Xo=;
        b=q2VoFdKMsqEOjBqylOYgoVaIfOPEvcrmmzxLpVRl6GimbH+P6Mb68v9lDARZ6qtXNt
         8Cyl4fIm13mO8PvLd1tJdDhC7z9Iriku7qiZzBgjZNvvvOp+VRybUyKZRUGT0JN+dl8O
         dNfAjoLFyUl+EQgteSxzWa18us+6kqyiUspP+6IyajZFTjr4KKM0VJ+3yOOShug5L7mm
         GI3JrtuyP1vTpiBuwhdrvbSxsnucBZw2f5KlRae70feKFp5DOu24DqBqYC+hKm4zlIV2
         e8BKmD8cehZsWpo2QBZ5pR8CACLSf5G3kOSGMD1ssi2HsE4oHhimc3wGXJzC3La7CMSi
         uxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnenYWFjUgy9d4rc8M0fPy/mWdQxcbS4o+P9BZj32Xo=;
        b=D6fGk9NXsAU2+rCmYnZzejOb020qgqsxIy/zvp1rSPLcZjrUonZ3vkEevnt9P0KVwS
         sZ6a78ZXKquIY3tLtJQQT3aWnugQ30SAr7FIXp7JnDkXvZ1x3F/QMacwEmxABnJ2Y6vu
         TuHrsdFuRjYPtqPRcFUnpaaiaOu3pC0KDjZlHl4cafI3qrUOdBopQQ9XpQ1v5/2yYKFu
         7RwxH+VMPYU85/CmwJtoJSiQSnBmoILzMU6msTyeBZCej+82Ylw/zqsLKmT6sErdmUeF
         tDEwwr++mZOFHfhwc9W142WD0+DJDWf9UJW3xPGXi6/+lqurDdQ1atQPr26J3lnDhGcT
         j60w==
X-Gm-Message-State: AOAM532h87DDlyi2yIt387RIa4lVk9Gvn84Lb6Gw7JgGw61o3LYlwM+j
        lGnFX0+vrROmVnkFFl7Vwuhsodjvjnj5GbQA
X-Google-Smtp-Source: ABdhPJxHLALwa0+H7Ihn5mBh1YrdEIAXc3sH8UJIgGuk9zrxhC8Ie3nKkrssOIbdCekBRWbhN65A/g==
X-Received: by 2002:ac8:5b10:0:b0:2e0:5a7d:180d with SMTP id m16-20020ac85b10000000b002e05a7d180dmr3908211qtw.562.1646536759259;
        Sat, 05 Mar 2022 19:19:19 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id f1-20020a37ad01000000b0064919f4b37csm4463183qkm.75.2022.03.05.19.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 19:19:18 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: Replace '__attribute__((weak))' with '__weak'
Date:   Sat,  5 Mar 2022 22:19:03 -0500
Message-Id: <20220306031907.210499-5-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306031907.210499-1-henryksloan@gmail.com>
References: <20220306031907.210499-1-henryksloan@gmail.com>
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

Fixed some checkpatch warnings by replacing '__attribute__((weak))' with
'__weak'.

Signed-off-by: Henry Sloan <henryksloan@gmail.com>
---
 virt/kvm/eventfd.c  | 12 ++++++------
 virt/kvm/irqchip.c  |  2 +-
 virt/kvm/kvm_main.c |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 1054ddb915b0..14aef85829ed 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -32,7 +32,7 @@
 
 static struct workqueue_struct *irqfd_cleanup_wq;
 
-bool __attribute__((weak))
+bool __weak
 kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	return true;
@@ -169,7 +169,7 @@ irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
 	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
 }
 
-int __attribute__((weak)) kvm_arch_set_irq_inatomic(
+int __weak kvm_arch_set_irq_inatomic(
 				struct kvm_kernel_irq_routing_entry *irq,
 				struct kvm *kvm, int irq_source_id,
 				int level,
@@ -265,24 +265,24 @@ static void irqfd_update(struct kvm *kvm, struct kvm_kernel_irqfd *irqfd)
 }
 
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
-void __attribute__((weak)) kvm_arch_irq_bypass_stop(
+void __weak kvm_arch_irq_bypass_stop(
 				struct irq_bypass_consumer *cons)
 {
 }
 
-void __attribute__((weak)) kvm_arch_irq_bypass_start(
+void __weak kvm_arch_irq_bypass_start(
 				struct irq_bypass_consumer *cons)
 {
 }
 
-int  __attribute__((weak)) kvm_arch_update_irqfd_routing(
+int  __weak kvm_arch_update_irqfd_routing(
 				struct kvm *kvm, unsigned int host_irq,
 				uint32_t guest_irq, bool set)
 {
 	return 0;
 }
 
-bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
+bool __weak kvm_arch_irqfd_route_changed(
 				struct kvm_kernel_irq_routing_entry *old,
 				struct kvm_kernel_irq_routing_entry *new)
 {
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index dcd51e6efb8a..baa551aec010 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -157,7 +157,7 @@ static int setup_routing_entry(struct kvm *kvm,
 	return 0;
 }
 
-void __attribute__((weak)) kvm_arch_irq_routing_update(struct kvm *kvm)
+void __weak kvm_arch_irq_routing_update(struct kvm *kvm)
 {
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c5fb79e64e75..af74cf3b6446 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4386,7 +4386,7 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 	return cleared;
 }
 
-int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
+int __weak kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
 	return -EINVAL;
-- 
2.35.1

