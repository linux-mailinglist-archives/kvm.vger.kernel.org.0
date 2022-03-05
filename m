Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7651D4CE718
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiCEU4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiCEU4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:56:37 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBB661A35;
        Sat,  5 Mar 2022 12:55:46 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id s16so836000qks.4;
        Sat, 05 Mar 2022 12:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dgtynUkl2NInlVz9c5ix3B45LFvFB0LQ430PaZMW1II=;
        b=poVjJKTCR4/cA/XiB8QNfBT6ZtNw++5QZKbi/6qZPkxUfiFPp0vRMzzAb/5voTaGWN
         Q7OhoAn0v8nvdpxzxe+QTs35O/2C3wZ/Ssa5PpDWx83eRaNpPGdvfU+wElTtbwsjkc8p
         cvcRDlbuHYk7qy/kpLmw1sfYMwpHHJGjNEGCF7ibNfLL0eT/Fyves0agTkvlsD6vi0Ym
         +KSMVR9MO8tIv7YUrudxEN8sIC3qGWD49PR2u7nQ0tpw9T1C9c5yE1fxZfYORPBQVKGU
         /razbVr44Ryo0bOwR89x56bPDjdy2Xxo9lSv3Wea83Sp8DCk1QbsQUeEb6MiF7Q/nz5c
         bpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgtynUkl2NInlVz9c5ix3B45LFvFB0LQ430PaZMW1II=;
        b=DNYJlHWOMG+fAWl5lVGVwPrExfbMFzdwspIyYzYYY1sCMsYAE2KgF09Xc+3EZ8k9df
         M/fWEJKuUdzIGdxNqggSjWCwVaUmPptEQmk1De85SK2jA25ot3INLHVZwNjpydayYhHG
         9Cs8+s1fEcFBVOK6rZKQvJ1nJ1ZKdybFUA8dvsDUCsP/WhGg5NopeY3iLGqSyJyBqW5H
         125H3zz8il5gx0vvRgBrK7p5DBqknrtRAenW6nYVfAqlb0QywChgM7bpysV+9jOOtsR1
         guG2DJTpQZUl2Y82qCNuRCw8DcIXuDlJWiAddMhUuNFSv4tlzQ8sJZ5w9ckMDrTL9f/M
         9vng==
X-Gm-Message-State: AOAM5308+k5nKB2vDr+bhso4JhS7HUzabF4V8KLUwi4oCT5EDffCT5aJ
        YmuTbHKzxEWmYZwYQR3QlhmKuCWfEqaF7lbh
X-Google-Smtp-Source: ABdhPJwIH2hIp5+b55+kWph/10nEL3GMY1jKO4ZKGeXyBVFrGWgyMeNpnv46LvMgTdHyireTEPRWFg==
X-Received: by 2002:a37:af81:0:b0:502:7ea:34e7 with SMTP id y123-20020a37af81000000b0050207ea34e7mr2895675qke.737.1646513745973;
        Sat, 05 Mar 2022 12:55:45 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm5877525qtk.8.2022.03.05.12.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:55:45 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] KVM: Replace '__attribute__((weak))' with '__weak'
Date:   Sat,  5 Mar 2022 15:55:25 -0500
Message-Id: <20220305205528.463894-4-henryksloan@gmail.com>
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

