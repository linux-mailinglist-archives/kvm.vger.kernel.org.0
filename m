Return-Path: <kvm+bounces-1405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 624217E7602
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 176B72817EF
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DD21848;
	Fri, 10 Nov 2023 00:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mq2dpTQ4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE9315B9
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:37:58 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6C8D5B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:37:58 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a90d6ab944so21249477b3.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699576677; x=1700181477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m8t7JaT+EHjEz67QkClUIxoFACS0/wE9JYyfGiAdQRk=;
        b=Mq2dpTQ4YLI8zlmWEAloRd02/bWou9wFC9nVHAFZii8PMbZo1M8r+PZOu11Rc/UMMt
         aE+EZNOUe02DWdkO8h4tlT3YGIYTq6wh84/F/DhY84ll3oNxMLe21y6iGNcUtrYmeQE3
         RXjD6HaGN0ILnguhuDBvoiEc6gjwFqiA3Wgoe0vyWWIiCXTTX/JZfJpZKr/3RN4SnXnc
         LzLAYNpM1aPLKmgQNxWrBV5mnKxZb9jBAlDgBgOVn+gD5EoTulUwpaDFYMbM0Io0njcV
         F5/CHD1KQRcyOauhKeKrgZCFmkXOrQNgoCTH6uSQia8LhL3wUGc8EyYSbNmnJcNGWh5F
         ABYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699576677; x=1700181477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m8t7JaT+EHjEz67QkClUIxoFACS0/wE9JYyfGiAdQRk=;
        b=MPHopnA6aWQrrM/9f6Ads1BieNHwd9KvPUybLyrCtGbHMKzJbRvm/yyY4CurAXqsiy
         oTJYZxMZ5XkzIhPqNUM6IvThEiTMpCK+7PmhjmsYZnQw/q2TwQ1rKFwLU5QB+XT9RcV/
         qonGpbFiK2tyAsDfQVOCBj/yXDz0VE5ujqfAeOLD+iTDGZdSQ3xEDj0J26YjbIq81XCX
         64rCtDTPKWOCdAZKwmgc91VkEAd6IhJUYxC5srS5dhfQOXtJuRpegrP0yGiRCH0zQuh2
         eP2W45iyNJTH5s+r7c4t2BX6gjqwyybn8MQR2djDSOaKmfjsybtkHOhUl3RIHS/3AUZF
         BBxQ==
X-Gm-Message-State: AOJu0Yze2r8vZ+qBVDcQWJ/zT7nKyRvK7GkgAkS+5/Tf57TGO9TVZuBK
	zBFIr9TidpanhKBGhzPP9j5Of4swdxs=
X-Google-Smtp-Source: AGHT+IGVKbpuOlUoQ9dZMaDseZfMIgardsDChQtM2ediK8f1rerrwZdKJ8lt7UhcUI+Dzr3X3ebBc7GqV7hM
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a05:690c:4712:b0:5be:a336:4a6 with SMTP id
 gz18-20020a05690c471200b005bea33604a6mr146845ywb.3.1699576677294; Thu, 09 Nov
 2023 16:37:57 -0800 (PST)
Date: Fri, 10 Nov 2023 00:37:34 +0000
In-Reply-To: <20231110003734.1014084-1-jackyli@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231110003734.1014084-5-jackyli@google.com>
Subject: [RFC PATCH 4/4] KVM: SEV: Use a bitmap module param to decide whether
 a cache flush is needed during the guest memory reclaim
From: Jacky Li <jackyli@google.com>
To: Sean Christpherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ovidiu Panait <ovidiu.panait@windriver.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, 
	Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a bitmap to provide the flexibility on deciding whether the flush is
needed for a specific mmu notifier event. The cache flush during memory
reclamation was originally introduced to address the cache incoherency
issues in some SME_COHERENT platforms. User may configure the bitmap
depending on the hardware (e.g. No flush needed when SME_COHERENT can
extend to DMA devices) or userspace VMM (e.g. No flush needed when VMM
ensures guest memory is properly unpinned).

The bitmap also decouples itself from the mmu_notifier_event type to
provide a consistent interface. The parameter remains same behavior
regardless of the changes to mmu notifier event in future kernel
versions. When a new mmu notifier event is added, the new event will be
defaulted to BIT(0) so that no additional cache flush will be
accidentally introduced.

Signed-off-by: Jacky Li <jackyli@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c       | 47 +++++++++++++++++++++++++++++++++---
 include/linux/mmu_notifier.h |  4 +++
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 477df8a06629..6e7530b4ae5d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -65,6 +65,47 @@ module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 #define sev_es_debug_swap_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+#define MMU_NOTIFY_OTHERS_BIT BIT_ULL(0)
+#define MMU_NOTIFY_UNMAP_BIT BIT_ULL(1)
+#define MMU_NOTIFY_CLEAR_BIT BIT_ULL(2)
+#define MMU_NOTIFY_PROTECTION_VMA_BIT BIT_ULL(3)
+#define MMU_NOTIFY_PROTECTION_PAGE_BIT BIT_ULL(4)
+#define MMU_NOTIFY_SOFT_DIRTY_BIT BIT_ULL(5)
+#define MMU_NOTIFY_RELEASE_BIT BIT_ULL(6)
+#define MMU_NOTIFY_MIGRATE_BIT BIT_ULL(7)
+#define MMU_NOTIFY_EXCLUSIVE_BIT BIT_ULL(8)
+
+/*
+ * Explicitly decouple with the mmu_notifier_event enum, so that the interface
+ * (i.e. bit definitions in the module param bitmp) remains the same when the
+ * original enum get updated.
+ */
+static const int mmu_notifier_event_map[NR_MMU_NOTIFY_EVENTS] = {
+	[MMU_NOTIFY_UNMAP] = MMU_NOTIFY_UNMAP_BIT,
+	[MMU_NOTIFY_CLEAR] = MMU_NOTIFY_CLEAR_BIT,
+	[MMU_NOTIFY_PROTECTION_VMA] = MMU_NOTIFY_PROTECTION_VMA_BIT,
+	[MMU_NOTIFY_PROTECTION_PAGE] = MMU_NOTIFY_PROTECTION_PAGE_BIT,
+	[MMU_NOTIFY_SOFT_DIRTY] = MMU_NOTIFY_SOFT_DIRTY_BIT,
+	[MMU_NOTIFY_RELEASE] = MMU_NOTIFY_RELEASE_BIT,
+	[MMU_NOTIFY_MIGRATE] = MMU_NOTIFY_MIGRATE_BIT,
+	[MMU_NOTIFY_EXCLUSIVE] = MMU_NOTIFY_EXCLUSIVE_BIT
+};
+unsigned long flush_on_mmu_notifier_event_bitmap = MMU_NOTIFY_UNMAP_BIT |
+	MMU_NOTIFY_CLEAR_BIT | MMU_NOTIFY_RELEASE_BIT | MMU_NOTIFY_MIGRATE_BIT;
+EXPORT_SYMBOL_GPL(flush_on_mmu_notifier_event_bitmap);
+module_param(flush_on_mmu_notifier_event_bitmap, ulong, 0644);
+MODULE_PARM_DESC(flush_on_mmu_notifier_event_bitmap,
+"Whether a cache flush is needed when the sev guest memory is reclaimed with a specific mmu notifier event.\n"
+"\tBit 0 (0x01)  left to any event not yet defined in the map\n"
+"\tBit 1 (0x02)  corresponds to MMU_NOTIFY_UNMAP event\n"
+"\tBit 2 (0x04)  corresponds to MMU_NOTIFY_CLEAR event\n"
+"\tBit 3 (0x08)  corresponds to MMU_NOTIFY_PROTECTION_VMA event\n"
+"\tBit 4 (0x10)  corresponds to MMU_NOTIFY_PROTECTION_PAGE event\n"
+"\tBit 5 (0x20)  corresponds to MMU_NOTIFY_SOFT_DIRTY event\n"
+"\tBit 6 (0x80)  corresponds to MMU_NOTIFY_RELEASE event\n"
+"\tBit 7 (0x100) corresponds to MMU_NOTIFY_MIGRATE event\n"
+"\tBit 8 (0x200) corresponds to MMU_NOTIFY_EXCLUSIVE event");
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2335,10 +2376,8 @@ void sev_guest_memory_reclaimed(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return;
 
-	if (mmu_notifier_event == MMU_NOTIFY_UNMAP ||
-	    mmu_notifier_event == MMU_NOTIFY_CLEAR ||
-	    mmu_notifier_event == MMU_NOTIFY_RELEASE ||
-	    mmu_notifier_event == MMU_NOTIFY_MIGRATE)
+	if (mmu_notifier_event_map[mmu_notifier_event] &
+	    flush_on_mmu_notifier_event_bitmap)
 		wbinvd_on_all_cpus();
 }
 
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index f349e08a9dfe..b40db51d76a4 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -47,6 +47,9 @@ struct mmu_interval_notifier;
  * longer have exclusive access to the page. When sent during creation of an
  * exclusive range the owner will be initialised to the value provided by the
  * caller of make_device_exclusive_range(), otherwise the owner will be NULL.
+ *
+ * @NR_MMU_NOTIFY_EVENTS: number of mmu notifier events, should always be at
+ * the end of the enum list.
  */
 enum mmu_notifier_event {
 	MMU_NOTIFY_UNMAP = 0,
@@ -57,6 +60,7 @@ enum mmu_notifier_event {
 	MMU_NOTIFY_RELEASE,
 	MMU_NOTIFY_MIGRATE,
 	MMU_NOTIFY_EXCLUSIVE,
+	NR_MMU_NOTIFY_EVENTS,
 };
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
-- 
2.43.0.rc0.421.g78406f8d94-goog


