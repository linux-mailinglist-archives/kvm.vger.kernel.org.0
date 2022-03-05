Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E014CE71A
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiCEU4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbiCEU4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:56:41 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A60F60DB8;
        Sat,  5 Mar 2022 12:55:50 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id n185so9081347qke.5;
        Sat, 05 Mar 2022 12:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=caAOL4DhBXEAlI019vHXou2JkvhGYLGi1f2ZLFmi2YM=;
        b=o/ZtqAjW9TUN/J9zhoYrXEl3pd6wHzuXU5sIv7W0e9lZ+vKirdBLIbt5EXUIB3V94g
         DKCRw0pVYXAsWVJpYS2khd++s7q4he2K5cu0Qwg0tlCouP4LxRyA2nV6URJelPi1SiJN
         f0KaPj55Src/r8mJlcGMCQ32w8rqR1qwRQyZ41YD3prfUIf1i/qGmdQ+Wmas1m5+fxJm
         1uZKv84aVz/q40+48PPs19E8tJHjB+4iqYY0ckHlGUDIDjgQeidK+QNh8Y3h5MxmOt7Y
         9hqlR++0Cvm/aSzqxyfdnKQb7YrDiRIY338fiNAub0oewfcJe8uV5OSq1GvZtgiQpam+
         zR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=caAOL4DhBXEAlI019vHXou2JkvhGYLGi1f2ZLFmi2YM=;
        b=LS2gChAdacllD3eQXihoeL/kCdMXeG3c4GkmTtlyoWAx/P7lQyxMCQZBKoTwFeNiia
         3qFSxjMhnlbpLnlRcRtFDwnvAzVxLRPkwaaVQQQvkn6Mtu6SR4UZ/qIdrloORdJalqjk
         TzaIS/f54a094UJ+dY8xqN2SMBpCAPiWZf2TBi1ne5KLaFStH/hMEbx91hl56fVQJKP1
         lpcfpvuusukCG3EKZYi7tRgHj/HcyO6kkM6swrp0dpxAhF1bSdyN+DJTnMaRqbRnFQ+o
         bNrjd3gjH3IA6Ei/tSxzu3TSnlDi+ZKdTMpH9IOgJfTCc9sUZKtTWUHBclW9tx6s9QzA
         8KiA==
X-Gm-Message-State: AOAM532K8BJ5wu5OIGyhZYMXaiwpUI2JNFW5xgs5CtRDhpeUPsozdMW2
        4kAas63efWs1IqLvFnYY+d0Y1MVMu8KOdvjM
X-Google-Smtp-Source: ABdhPJxVh1Furf+8z0x/WG4SjmXx52XaQjErAse2ogrA433A1nBn3oCIinn2fIB79hSQK4YEZhQ8sw==
X-Received: by 2002:a05:620a:22a3:b0:663:7c52:51c6 with SMTP id p3-20020a05620a22a300b006637c5251c6mr2728556qkh.295.1646513749159;
        Sat, 05 Mar 2022 12:55:49 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm5877525qtk.8.2022.03.05.12.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:55:48 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] KVM: Fix minor indentation and brace style issues
Date:   Sat,  5 Mar 2022 15:55:28 -0500
Message-Id: <20220305205528.463894-7-henryksloan@gmail.com>
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
 virt/kvm/kvm_main.c | 36 +++++++++++++++++++-----------------
 virt/kvm/pfncache.c |  2 +-
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1a9f20e3fa2d..c899da4515c0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -132,7 +132,10 @@ static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
  *   passed to a compat task, let the ioctls fail.
  */
 static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
-				unsigned long arg) { return -EINVAL; }
+				unsigned long arg)
+{
+	return -EINVAL;
+}
 
 static int kvm_no_compat_open(struct inode *inode, struct file *file)
 {
@@ -2154,9 +2157,9 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	n = ALIGN(log->num_pages, BITS_PER_LONG) / 8;
 
 	if (log->first_page > memslot->npages ||
-	    log->num_pages > memslot->npages - log->first_page ||
-	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
-	    return -EINVAL;
+		log->num_pages > memslot->npages - log->first_page ||
+		(log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
+		return -EINVAL;
 
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
@@ -2517,7 +2520,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * tail pages of non-compound higher order allocations, which
 	 * would then underflow the refcount when the caller does the
 	 * required put_page. Don't allow those pages here.
-	 */ 
+	 */
 	if (!kvm_try_get_pfn(pfn))
 		r = -EFAULT;
 
@@ -2906,7 +2909,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+						void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -2923,7 +2926,7 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 }
 
 int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       void *data, unsigned long len)
+						void *data, unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
@@ -2934,8 +2937,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 static int __kvm_write_guest_page(struct kvm *kvm,
-				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+						struct kvm_memory_slot *memslot, gfn_t gfn,
+						const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -2990,7 +2993,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
-		         unsigned long len)
+				unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
@@ -3011,8 +3014,8 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest);
 
 static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
-				       struct gfn_to_hva_cache *ghc,
-				       gpa_t gpa, unsigned long len)
+				struct gfn_to_hva_cache *ghc,
+				gpa_t gpa, unsigned long len)
 {
 	int offset = offset_in_page(gpa);
 	gfn_t start_gfn = gpa >> PAGE_SHIFT;
@@ -3156,8 +3159,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
-			     const struct kvm_memory_slot *memslot,
-		 	     gfn_t gfn)
+				const struct kvm_memory_slot *memslot,
+				gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
@@ -5176,9 +5179,8 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		return 0;
 
 	for (i = 0; i < bus->dev_count; i++) {
-		if (bus->range[i].dev == dev) {
+		if (bus->range[i].dev == dev)
 			break;
-		}
 	}
 
 	if (i == bus->dev_count)
@@ -5599,7 +5601,7 @@ EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
  */
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
 {
-        return &kvm_running_vcpu;
+	return &kvm_running_vcpu;
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index ce878f4be4da..072c9a9e44b1 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -237,7 +237,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 				ret = -EFAULT;
 		}
 
-	map_done:
+ map_done:
 		write_lock_irq(&gpc->lock);
 		if (ret) {
 			gpc->valid = false;
-- 
2.35.1

