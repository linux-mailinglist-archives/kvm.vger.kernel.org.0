Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219D24CE711
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiCEU4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiCEU4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:56:39 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBB260DB8;
        Sat,  5 Mar 2022 12:55:48 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id g24so9097453qkl.3;
        Sat, 05 Mar 2022 12:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2OHv3SctzLs4vayu1DatcqlqlSwr80Sqxye5OO5KQt8=;
        b=CyRQiyIUN1u5RNeRbe/4s9VvLE68e4LWrZI1eCVkI0NM/gq1kzyIyx05Gtg2r02Ssi
         v6M7vX+kMNzDwDRnSXHPNZxGwlOsvpY+t3/S6eonRIwRHV47dbBKSsIEIxRScuzuPDQp
         Y45DMZTFg2K8vjkHO/Jl1qIPkQ468U3WX1NS6FXZCBhMcxT0HVP881Tccyk85UHGCU1v
         NeKlONIAoQEw9U8qtqhc+v0dVaBkayB3fK4DMCEAqFuCt8vq/q+4uqrnHk6qUTrrpVNI
         y2hJwROWjC8njIs9yN0aDULswUk5y7WIF4laE3DLBEZ3YK51B/eOfgkKtsQHLOEmZ/t0
         xzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2OHv3SctzLs4vayu1DatcqlqlSwr80Sqxye5OO5KQt8=;
        b=2VqNAnwa/5psAQOXuf9zudHUY+6BHKRiJ/DDBhLOkEt12LS43IjwzTW7QbGdId5Tz9
         LjwqU51GTgFMnFF6grcOhCauPq4Nb4MzYB7FKn5J49PnZCvT8hifHAOF28HXjhGYF7Ff
         yyhOfEn7w0qHaJYlSW8HqQ/9bWsrgijV4eUOma1Rc1aubzmYjOvIl4bnl3mCKhplP0ew
         YpIUdzIQTKq/gmJIMsjmFLFdi7kplN05S+HaYp68+nrZJ2VbP0jZoQZlOwcKN1fnuAWZ
         x4GaQPssl/6IpaccLE9CKX3V80qFQBm8BfplzPQ+W5OUkCbUvDNHsM8I38Mi4Pwdaxm8
         im3w==
X-Gm-Message-State: AOAM530yiURELHyxqu2SRwDVGTeUaHg6sUV2Wm/eI9T4aau4vNLmRAFV
        YCkSOpejZDU4EiC/A7H2eVc=
X-Google-Smtp-Source: ABdhPJxKOq6CooTF4kxHWFhS9aJ+8pxxr5qF18AG0ka/8SduH8q9Mx8Y1FLHAuyIUC9Tnrr2hQXcZQ==
X-Received: by 2002:a37:e303:0:b0:47b:b0e1:fc3f with SMTP id y3-20020a37e303000000b0047bb0e1fc3fmr2867436qki.108.1646513748131;
        Sat, 05 Mar 2022 12:55:48 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm5877525qtk.8.2022.03.05.12.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:55:47 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] KVM: Use typical style for block comments
Date:   Sat,  5 Mar 2022 15:55:27 -0500
Message-Id: <20220305205528.463894-6-henryksloan@gmail.com>
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
 virt/kvm/irqchip.c  | 6 ++++--
 virt/kvm/kvm_main.c | 6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 69a327c043d7..80708f6ec9d9 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -120,8 +120,10 @@ static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
 
 void kvm_free_irq_routing(struct kvm *kvm)
 {
-	/* Called only during vm destruction. Nobody can use the pointer
-	   at this stage */
+	/*
+	 * Called only during vm destruction. Nobody can use the pointer
+	 * at this stage
+	 */
 	struct kvm_irq_routing_table *rt = rcu_access_pointer(kvm->irq_routing);
 
 	free_irq_routing_table(rt);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1988dd081606..1a9f20e3fa2d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2182,7 +2182,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		 * never includes any bits beyond the length of the memslot (if
 		 * the length is not aligned to 64 pages), therefore it is not
 		 * a problem if userspace sets them in log->dirty_bitmap.
-		*/
+		 */
 		if (mask) {
 			flush = true;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
@@ -5245,8 +5245,8 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 
 	/*
 	 * The debugfs files are a reference to the kvm struct which
-        * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
-        * avoids the race between open and the removal of the debugfs directory.
+	 * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
+	 * avoids the race between open and the removal of the debugfs directory.
 	 */
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
-- 
2.35.1

