Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEA94CE813
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 02:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiCFB3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 20:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiCFB3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 20:29:13 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D4465E9;
        Sat,  5 Mar 2022 17:28:22 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id b12so9555948qvk.1;
        Sat, 05 Mar 2022 17:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qUed4120jDx2UY0O7Y5US190Wq5Hulu3C54Li89uLcI=;
        b=lD5pjdk6alcurCyRkzBTmUam1ncqaaoC9/2yjX+9GNmldE751cGVY+4cLHWf6fY7nq
         eVQMaeuwiMpJs7UGIonYjdcIWLz8Y0M+2rJc7kbWIyj6q3KjC98GbIlAxtwSTH+soYEs
         +x8tQwLtaBQPfUw+vMjtxtDuisAFdNOTCf0yAny93dAt/2i+FYXRFfc6HSfY8MpjzZ2X
         y7qRO3sQAkYTwPkyGfTFS2OIX+/p3jm/4xStqh4sou8n8af4YMoiqdWkHmRWgoJSU2IK
         IUIPJ3/wk7cED7COYEPWRcM0seecd03ydFzrB/Im0lAgDO7tyLHudQ+aWcMW7H66KdeG
         A9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qUed4120jDx2UY0O7Y5US190Wq5Hulu3C54Li89uLcI=;
        b=tC7O6W4AkTvpRYNIec9PaFB8dIvyB7FHvfOUeS3u1M6eOYcS8fh4dGqzPhqEG1DWPs
         DxTDxyz4Rd4hJeTZBQQzUh6hrFMWEBRbGheLQ45qcCFwWnvBW2UznQuOU3AjImAzAvgu
         c28xjcjwvC7zSzi7+RNkCDYfOja16EBpLjnkAOf9mbac4eyyhSVpflNtKY+7BdNPZhhC
         lgEt4A9LxcPvqDXv9/XaL+2+Vx8b3eeh5VtpkL++TmQdgmFYOX5ejIw4W8lvpmzE+PUF
         CNJvPdo5wn/9g7gN1WSkAtkODuGTdMMTomuG0Cof043PR0/FwV+ieKdFovOdMx30bmsk
         11oQ==
X-Gm-Message-State: AOAM532lW9cYpSXyhcU8DMfsHpceG6dZ1H+2IwxhGqdlseUBUZ3a16AG
        n/fO154znsGWzDBvGsSDn/4htC1GOjcONIni
X-Google-Smtp-Source: ABdhPJyat3VMSiplta/RvLwlCf3ig0Kzfej0E8PbjdiQmrXBYoXztH+o56mD62n/J3AEy7TOiJ6O1A==
X-Received: by 2002:ad4:5fce:0:b0:42d:fa10:6451 with SMTP id jq14-20020ad45fce000000b0042dfa106451mr4326090qvb.1.1646530101512;
        Sat, 05 Mar 2022 17:28:21 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id k4-20020a05620a142400b0067b03a73e70sm951068qkj.85.2022.03.05.17.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 17:28:21 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] KVM: Replace bare 'unsigned' with 'unsigned int'
Date:   Sat,  5 Mar 2022 20:28:04 -0500
Message-Id: <20220306012804.117574-1-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305205528.463894-7-henryksloan@gmail.com>
References: <20220305205528.463894-7-henryksloan@gmail.com>
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
 virt/kvm/coalesced_mmio.c | 23 ++++++++---------------
 virt/kvm/eventfd.c        |  8 ++++----
 virt/kvm/irqchip.c        |  6 +++---
 virt/kvm/kvm_main.c       | 16 ++++++++--------
 4 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f..b0501a2538d7 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -22,7 +22,7 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_coalesced_mmio_dev, dev);
 }
 
-static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
+static bool coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 				   gpa_t addr, int len)
 {
 	/* is it in a batchable area ?
@@ -30,20 +30,19 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 	 * (zone->addr, zone->size)
 	 */
 	if (len < 0)
-		return 0;
+		return false;
 	if (addr + len < addr)
-		return 0;
+		return false;
 	if (addr < dev->zone.addr)
-		return 0;
+		return false;
 	if (addr + len > dev->zone.addr + dev->zone.size)
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
+static bool coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
-	unsigned avail;
 
 	/* Are we able to batch it ? */
 
@@ -52,13 +51,7 @@ static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 	 * there is always one unused entry in the buffer
 	 */
 	ring = dev->kvm->coalesced_mmio_ring;
-	avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
-	if (avail == 0) {
-		/* full */
-		return 0;
-	}
-
-	return 1;
+	return (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX != 0;
 }
 
 static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
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

