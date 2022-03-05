Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC934CE6F3
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiCEU2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiCEU2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:28:01 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6411C5F77;
        Sat,  5 Mar 2022 12:27:11 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id iv12so7757186qvb.6;
        Sat, 05 Mar 2022 12:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=krxKGTF4mdImfDPEVRingmxJzSr326pOxtnSE8j94mg=;
        b=MooaztqdQG3dNtCHW817gv9mS3CmYtIXPF8MgcWDiC/WOFqDHuaDtd16MRdvUibvxl
         eusgCeteySJ+Yz8Q5yXfF1VzZ4mwSzcN6oqkMpLv2UmIn19yMxSOGAtgaU4N8jz22K9f
         6QeNulw+wJsrFLuGanXnkg+egMI3bQzwSTgppyaQFfK+vgsIf4p98R7pzqMYYLbU6DSS
         CwuPXdGSoUKOLah76R02RskWOpDa0rk6PulnVjisTHLdhoT9hteACXhM49g61jZ0H9Kf
         FDdWrQJHmI8PIXjgNWJGI5v6pK+q/RIaxJ3OGHtYWbcBhcfi9Ozc61tbFlPVtPIiO9hk
         mhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=krxKGTF4mdImfDPEVRingmxJzSr326pOxtnSE8j94mg=;
        b=4+oNPOt8Tl2HaqvZByT26fM3i4/MLl0Fvo3r0EKNnt9gj5S1zlPSo++0DaUM8CwwJk
         sLyS1MfzIvfAobI7DOW8SXatZ/UAeC+WNHV5jXTLT24ZsB4l0Z1MKYcNxO3HvN4Y6mfp
         cES1I5+PysQ7T/D8ruQCFoFbuw0YdEzkhsoRtNew4qGcGWjVpSktSt78davKCiH3YAVG
         xL9ISQafV4vNz/c7IBwSWIZ2t07VunDS5RyGeo7D0xX7A0c8stagn/lO2kVNcX1rG89h
         xi6EeVX2iqEgyS+zZKYg/fe7CvApT96mvMHnnlSFn31c3PEZWdCtlVUFfuehorOlRmIB
         zLIw==
X-Gm-Message-State: AOAM533INjPHNgAXQ38eyKRk8JhO+RQQow16llzl78abiiGbDBWyi5b4
        7m1MoEXa6wo67mlzwJBb1mUBEmovg51JWQ==
X-Google-Smtp-Source: ABdhPJw5fdA/yYhEKEiRmd2QnP/yXk+fu+vZzYVNs7ud16LzFAVKr8Z0APZefODdIK7988IhbYMk+A==
X-Received: by 2002:a05:6214:29cf:b0:435:76ee:c133 with SMTP id gh15-20020a05621429cf00b0043576eec133mr1425517qvb.82.1646512030612;
        Sat, 05 Mar 2022 12:27:10 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id e9-20020ac85989000000b002de2bfc8f94sm5654208qte.88.2022.03.05.12.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:27:10 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] KVM: fix checkpatch warnings
Date:   Sat,  5 Mar 2022 15:26:34 -0500
Message-Id: <20220305202637.457103-3-henryksloan@gmail.com>
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

Fix "__attribute__((weak))" warnings

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

