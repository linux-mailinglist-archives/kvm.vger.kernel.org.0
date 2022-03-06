Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCBD4CE877
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 04:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiCFDUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 22:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiCFDUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 22:20:12 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F20933353;
        Sat,  5 Mar 2022 19:19:21 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id v189so502635qkd.2;
        Sat, 05 Mar 2022 19:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=10xo+cbxxhlAf0GtSUH3wpAu2PhRbbmwgDpSrBgRfr0=;
        b=jBgUHm8kZNOTt4IF01mwVuZJ13Qt6tfLxU5DSKYZQA4WfivCip0Q+vtCyGvGMZ75XS
         7UinC3PznYMq0X3PUTGky0RmAns2B5UC3jwnn1qnYcMg+ekkRaEnc0dftLlTyCeutJo/
         uLQQj77MAfA7z+DweBaUBXtShb9xVaEvfjezcNzRogUw/4GEKRQp6u2+d7ZypH1yyUxo
         aI7APUBCruoVGPjtF11+6soOAWLL+Y4EvXC0r/+PoGSPhjAdgDX1d7hwm4+Tl2SQbrlA
         vllydT3JMssMq1PaAWywE39A0LvoBf8Dbf84JhrzfmKR2TqeEatawydeRhpwXrwjlf+s
         nBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=10xo+cbxxhlAf0GtSUH3wpAu2PhRbbmwgDpSrBgRfr0=;
        b=gQMCEqLIynU1gX8rd2aaOIjFdjDZ3ckygtIDF993Qy2tNVf4ZN9/X5tRv3HH0C4r+B
         4rE7NyjKKOXM66TYK68VZscdbRZUVwmfD4EKYDPFr44HaE/YaRVxdDc9UXUMC8C8nD2f
         nJWm9GIpnKB9x2DQMc1zZs5Y84nQkZQw791dkG8nZD5I9Fvmzm19FYRI+n4I/uTbPK+K
         3DN95OEKPpsCctHus9IkKKzmPVGNOCD9MYr2wYe0QPaOvo5EGT1gPPsEk2a3GVul1wvp
         2AY4DBI92mtwUhaWx/OzPlZGq4HDMQYbv3JILEa32XKEGOmzDoi1BYn8HBfr/C11P/up
         gwmA==
X-Gm-Message-State: AOAM530gOH8eNOLEyafddWsJegWacZxH1Kf/vUKG2+XrWb0/7ctjHYTR
        XVn8aAhO+3azr4wch07gfS4=
X-Google-Smtp-Source: ABdhPJx9RzYGgsCZM8C+0cSQ8q3sTJkX+KzdD+0yaoZ+/1iKNtAIpOO87XFkJg7asxs3FEM58a21Dg==
X-Received: by 2002:a05:620a:16a3:b0:67b:123f:8d31 with SMTP id s3-20020a05620a16a300b0067b123f8d31mr1047803qkj.672.1646536760443;
        Sat, 05 Mar 2022 19:19:20 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id f1-20020a37ad01000000b0064919f4b37csm4463183qkm.75.2022.03.05.19.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 19:19:20 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] KVM: Add blank lines after some declarations
Date:   Sat,  5 Mar 2022 22:19:04 -0500
Message-Id: <20220306031907.210499-6-henryksloan@gmail.com>
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

Fixed some checkpatch warnings by adding blank lines after declarations.

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

