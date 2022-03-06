Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561084CE868
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 04:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiCFDUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 22:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiCFDUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 22:20:08 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6C2B877;
        Sat,  5 Mar 2022 19:19:16 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id 11so10651293qtt.9;
        Sat, 05 Mar 2022 19:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bXmranGPLHTOH6hVyVVXhTm11KHwG3igIGZ59Jq8giI=;
        b=iQvtdNu3Xrg9iiKCzrQxuvOjo+EMf4+sGG9v8IqDSZkC6Ca4qGgI2V/erJHN99+OX9
         84WXNGyWDRysTMPzHzZZ5aButE1f9p7VENYjHShsTskD7MeNj7OWP7dDKXG/zBcaHTEI
         N3jq54GnofKh36+kj8mpbDL15Qe1+U+BeWwuyRXIrzpHQf0EnZDL2telwBdWOVrw1vSZ
         61DY1PYGd21fGavNJHJLFTiAd0LA9REnm6nghr1J42/ytvBClt4KB/r4XX+3a4gKZf2T
         p3AtgiIs1lDDP0JKjbtRZNmrRlF5xuj14RO8G//4JVXBV5AUbNKb8+YHFzx4JlZbvtIy
         W+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bXmranGPLHTOH6hVyVVXhTm11KHwG3igIGZ59Jq8giI=;
        b=Nqb0pPEuSpHcRSziaqUYDgNAEMOWmX6y5o0QtbcGyK78nfxtIrNClOG5VpnwtlCsHM
         lxlX8BoroFJk0z9oK0cWLRxcFDu1opMrntnYiKp5KJfSd7wRsRBww8dJdbyA00N2q/nX
         IvAXuNXVCCWixzPPDOv1RX1+B7BZ35FfDfV8ccdUdbVNxBKXGGYMdPcG6/Gvcff2otou
         dfzmKHTfpHJFy2T8upLJV2096vHjBRkI2nA5VuC4MYDMAHDjNHpKPcN5X+ZFpGd4IRxF
         7jcI9ePr+K6tAk74KQOdbFnjqaxlyppHWjDEzDXAmvzdIk3s04A/Sa3I3HIz51E1igWk
         eH8g==
X-Gm-Message-State: AOAM531CvgfmmjZcwFNkMZWShNkEY8ZNuPUMI4eqnnDktYYR+16GqO8N
        XDkBp18/YAUZn93SWoKt/0TQKDFo/9EUjOZg
X-Google-Smtp-Source: ABdhPJzbzH0eKiXV30l0rqNdp38vMZ2Hi/Gu5nSxGbG7IvEtIjapK9zr1QdrSNIbTX+pxwP2PU3ASQ==
X-Received: by 2002:a05:622a:110d:b0:2d4:e4c4:6b with SMTP id e13-20020a05622a110d00b002d4e4c4006bmr4744037qty.425.1646536755580;
        Sat, 05 Mar 2022 19:19:15 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id f1-20020a37ad01000000b0064919f4b37csm4463183qkm.75.2022.03.05.19.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 19:19:15 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: Fix minor indentation and brace style issues
Date:   Sat,  5 Mar 2022 22:19:00 -0500
Message-Id: <20220306031907.210499-2-henryksloan@gmail.com>
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

Signed-off-by: Henry Sloan <henryksloan@gmail.com>
---
 virt/kvm/kvm_main.c | 25 ++++++++++++++-----------
 virt/kvm/pfncache.c |  2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1a9f20e3fa2d..eea5b18b8efe 100644
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
@@ -2155,8 +2158,9 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 
 	if (log->first_page > memslot->npages ||
 	    log->num_pages > memslot->npages - log->first_page ||
-	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
-	    return -EINVAL;
+	    (log->num_pages < memslot->npages - log->first_page &&
+	    (log->num_pages & 63)))
+		return -EINVAL;
 
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
@@ -2517,7 +2521,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * tail pages of non-compound higher order allocations, which
 	 * would then underflow the refcount when the caller does the
 	 * required put_page. Don't allow those pages here.
-	 */ 
+	 */
 	if (!kvm_try_get_pfn(pfn))
 		r = -EFAULT;
 
@@ -2906,7 +2910,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+				   void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -2935,7 +2939,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -2990,7 +2994,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
-		         unsigned long len)
+			 unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
@@ -3157,7 +3161,7 @@ EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
-		 	     gfn_t gfn)
+			     gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
@@ -5176,9 +5180,8 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		return 0;
 
 	for (i = 0; i < bus->dev_count; i++) {
-		if (bus->range[i].dev == dev) {
+		if (bus->range[i].dev == dev)
 			break;
-		}
 	}
 
 	if (i == bus->dev_count)
@@ -5599,7 +5602,7 @@ EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
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

