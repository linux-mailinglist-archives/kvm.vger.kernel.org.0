Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB2A4CE714
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiCEU4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiCEU4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:56:36 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DA260DAD;
        Sat,  5 Mar 2022 12:55:45 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id z66so9058354qke.10;
        Sat, 05 Mar 2022 12:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jtIXuKCcBJI/lwMJfayWLSewoOe6VlcxvOBTKyy+vtU=;
        b=JNKyST3NjchNUczfg5MXqP7e7f8kswX9Lqp1eXSlsEEBMyaHrYp8OaUEbBovSvo3Qy
         crVd9LJ9FVvnXYJvxNQ9sFRZC0o5n8G9vWR/qkQnDKIhyfnxPqC2ugnakU/1TeJuFE7B
         dP3QoyMAtIbFtsJas1eWW3dVJqAYod2jhuYQhT4WQbTX+hhOliGbq/OfhYHsTZTOxVU8
         EJXs3NHjoFH1DJ77FHfH23mxb9YcjepG03C6Ad1Lum53A/4gOdKbZY/2W0vObFVmH0c7
         ppphm3YR2QSYAsCEbZMozboB5BonFR5whQDX4tdEHbwHzZSWphXJKCYyNW436RX16kWf
         jY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jtIXuKCcBJI/lwMJfayWLSewoOe6VlcxvOBTKyy+vtU=;
        b=BppFjwVRFdWJAG5fgFfTWh3eqZIP9KV1OwApzY5ERMseGzDAdIS1wTzQzlNvcLuZA4
         SSoKcWf6YWHXErhTzYp3o5JvlHWbUcjHnRMA0dcrThZug8PNXYz7BqDesLM9uSb0mThp
         DcIREQ71KLHPSfIaki3Ms3A504ck6w3T+6GmoswPmQXTBeOQUtVZA3Fp8zK5zwPzKDyK
         qUMIQJW5uyK6QI1eCNtZoq+Zu+WwlguMmuZcLZU0zeIT7EfBSACf+th1l8GXJNzwz9L6
         tUy48IFwn4MPDDPwVBHWTKJBfq0YaZqVjOZMSwhLGciRgpzmX6t8CDBwLiZbGTDyYoh7
         dm5A==
X-Gm-Message-State: AOAM532u01aY7wCMa1nmCWz0D2s//ASEZhH5PViTjn7GvAAoSyNw5dBV
        46bUuy0fnN0sRyEn0rupXyY=
X-Google-Smtp-Source: ABdhPJyb6KR1hNEjwX2eRAV2NEOp7e/mgTxRVEUmNUfIwBDCNpluaCz5dZU9/Wdo2+lMxtz+GrbQTA==
X-Received: by 2002:a05:620a:2855:b0:662:f88d:d77 with SMTP id h21-20020a05620a285500b00662f88d0d77mr2816484qkp.241.1646513744979;
        Sat, 05 Mar 2022 12:55:44 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm5877525qtk.8.2022.03.05.12.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:55:44 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] KVM: Replace bare 'unsigned' with 'unsigned int'
Date:   Sat,  5 Mar 2022 15:55:24 -0500
Message-Id: <20220305205528.463894-3-henryksloan@gmail.com>
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
 virt/kvm/coalesced_mmio.c |  2 +-
 virt/kvm/eventfd.c        |  8 ++++----
 virt/kvm/irqchip.c        |  6 +++---
 virt/kvm/kvm_main.c       | 16 ++++++++--------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f..1ff2bca6489c 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -43,7 +43,7 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
-	unsigned avail;
+	unsigned int avail;
 
 	/* Are we able to batch it ? */
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 59b1dd4a549e..1054ddb915b0 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -182,14 +182,14 @@ int __attribute__((weak)) kvm_arch_set_irq_inatomic(
  * Called with wqh->lock held and interrupts disabled
  */
 static int
-irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
+irqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode, int sync, void *key)
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(wait, struct kvm_kernel_irqfd, wait);
 	__poll_t flags = key_to_poll(key);
 	struct kvm_kernel_irq_routing_entry irq;
 	struct kvm *kvm = irqfd->kvm;
-	unsigned seq;
+	unsigned int seq;
 	int idx;
 	int ret = 0;
 
@@ -455,7 +455,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	return ret;
 }
 
-bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
+bool kvm_irq_has_notifier(struct kvm *kvm, unsigned int irqchip, unsigned int pin)
 {
 	struct kvm_irq_ack_notifier *kian;
 	int gsi, idx;
@@ -486,7 +486,7 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 			kian->irq_acked(kian);
 }
 
-void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
+void kvm_notify_acked_irq(struct kvm *kvm, unsigned int irqchip, unsigned int pin)
 {
 	int gsi, idx;
 
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 58e4f88b2b9f..dcd51e6efb8a 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -38,7 +38,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
 	return n;
 }
 
-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip, unsigned int pin)
 {
 	struct kvm_irq_routing_table *irq_rt;
 
@@ -168,8 +168,8 @@ bool __weak kvm_arch_can_set_irq_routing(struct kvm *kvm)
 
 int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *ue,
-			unsigned nr,
-			unsigned flags)
+			unsigned int nr,
+			unsigned int flags)
 {
 	struct kvm_irq_routing_table *new, *old;
 	struct kvm_kernel_irq_routing_entry *e;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0afc016cc54d..c5fb79e64e75 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -216,7 +216,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(vcpu_put);
 
 /* TODO: merge with kvm_arch_vcpu_should_kick */
-static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
+static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned int req)
 {
 	int mode = kvm_vcpu_exiting_guest_mode(vcpu);
 
@@ -415,7 +415,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 }
 #endif
 
-static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned int id)
 {
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
@@ -3454,7 +3454,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
-		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
+		if (cpu != me && (unsigned int)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
 out:
@@ -5366,7 +5366,7 @@ static const struct file_operations stat_fops_per_vm = {
 
 static int vm_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
 
@@ -5382,7 +5382,7 @@ static int vm_stat_get(void *_offset, u64 *val)
 
 static int vm_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 
 	if (val)
@@ -5402,7 +5402,7 @@ DEFINE_SIMPLE_ATTRIBUTE(vm_stat_readonly_fops, vm_stat_get, NULL, "%llu\n");
 
 static int vcpu_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
 
@@ -5418,7 +5418,7 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 
 static int vcpu_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 
 	if (val)
@@ -5654,7 +5654,7 @@ static void check_processor_compat(void *data)
 	*c->ret = kvm_arch_check_processor_compat(c->opaque);
 }
 
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+int kvm_init(void *opaque, unsigned int vcpu_size, unsigned int vcpu_align,
 		  struct module *module)
 {
 	struct kvm_cpu_compat_check c;
-- 
2.35.1

