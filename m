Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA226566BB
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 03:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiL0CZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 21:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiL0CZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 21:25:43 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9571A1FE
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 18:25:41 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id t2so12052725ply.2
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 18:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5haqsSicJ1y5JAf4DzHeYZjjvPaH/eOCnQ95phXljnc=;
        b=2CQrI3y9LCx/RRrNUdJU8EApVGWI0esJTePaxBlTM7cbLOWb64WOVFKVPTPXKnkbI9
         6xp4P8D5Hmjz6+nF3q95kJgycSRDDHByKChF8H2CrtipRLijEJRFOOLGgiox9RiH2k2S
         IDCeNI5PeeHoO4vP6MQEI+23PmkpRM7EvKVR2QqxImQWYiUjUZNtDAVjAYoxVE/OF4F8
         Ba540u1tNN5l1PSh1DgEfxTEH4lyB+l6Iw2zt149mKjROirMIT+ISOI2OhiZxtJe+wBL
         Y2UwBV0d09p907V7RMOTsUvlggvnaq/Mh/8o99XjnJdZSXnlAurRXwXY187X1DsQvQAQ
         VqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5haqsSicJ1y5JAf4DzHeYZjjvPaH/eOCnQ95phXljnc=;
        b=IhNJ4eVqZpqfwBVIKgyPv+d4GRNn5h34fxvt0d2tbGRYeGRsdVDoeVVvhwVuNyZ8kb
         x/3ENvxVsjeqIUYhMIYjoa8S8zMvthveNRwYiN9Mhz9O4+kNeFObzi0xlgMAsMBZCIwm
         xoBE6F18ptUmxqSipCke0j+POz1SRDJ0uAGgcRfp2BwjoHjfLQelbRCyvgUXDKLeitNN
         pte6lO/ltiGf0WPDzz3mxRqG9f1L3Gc6JSJdxx5eupK+clsfom/uokR/UX/wzqD4Thjy
         SaMZj/5lF7nnmRS9vySKFJHsuxNWWai0CAtoZaVt5KUljK1+WqmE8Q9XLGoQOUonB1yg
         W/+g==
X-Gm-Message-State: AFqh2kq7KLP1wUH2zzKSmBSh7+y+Q2ImG9IdT47owt1vLcaXwyCziIYI
        wb0vlbaojj/7cyXFkYQgC35Zq9srGvRlB+SYjUQ=
X-Google-Smtp-Source: AMrXdXuBf0YmaVtc2Str53QshIsQ5jNRTxQJluF/BUCseYuqpswPq5ANFNlIIq9O+nFVAMm0wV7D1g==
X-Received: by 2002:a17:902:da86:b0:191:1987:9f69 with SMTP id j6-20020a170902da8600b0019119879f69mr31083660plx.35.1672107941111;
        Mon, 26 Dec 2022 18:25:41 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b001870dc3b4c0sm2465014plk.74.2022.12.26.18.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 18:25:40 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to vringh_kiov
Date:   Tue, 27 Dec 2022 11:25:24 +0900
Message-Id: <20221227022528.609839-3-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221227022528.609839-1-mie@igel.co.jp>
References: <20221227022528.609839-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct vringh_iov is defined to hold userland addresses. However, to use
common function, __vring_iov, finally the vringh_iov converts to the
vringh_kiov with simple cast. It includes compile time check code to make
sure it can be cast correctly.

To simplify the code, this patch removes the struct vringh_iov and unifies
APIs to struct vringh_kiov.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 drivers/vhost/vringh.c | 32 ++++++------------------------
 include/linux/vringh.h | 45 ++++--------------------------------------
 2 files changed, 10 insertions(+), 67 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 828c29306565..aa3cd27d2384 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -691,8 +691,8 @@ EXPORT_SYMBOL(vringh_init_user);
  * calling vringh_iov_cleanup() to release the memory, even on error!
  */
 int vringh_getdesc_user(struct vringh *vrh,
-			struct vringh_iov *riov,
-			struct vringh_iov *wiov,
+			struct vringh_kiov *riov,
+			struct vringh_kiov *wiov,
 			bool (*getrange)(struct vringh *vrh,
 					 u64 addr, struct vringh_range *r),
 			u16 *head)
@@ -708,26 +708,6 @@ int vringh_getdesc_user(struct vringh *vrh,
 	if (err == vrh->vring.num)
 		return 0;
 
-	/* We need the layouts to be the identical for this to work */
-	BUILD_BUG_ON(sizeof(struct vringh_kiov) != sizeof(struct vringh_iov));
-	BUILD_BUG_ON(offsetof(struct vringh_kiov, iov) !=
-		     offsetof(struct vringh_iov, iov));
-	BUILD_BUG_ON(offsetof(struct vringh_kiov, i) !=
-		     offsetof(struct vringh_iov, i));
-	BUILD_BUG_ON(offsetof(struct vringh_kiov, used) !=
-		     offsetof(struct vringh_iov, used));
-	BUILD_BUG_ON(offsetof(struct vringh_kiov, max_num) !=
-		     offsetof(struct vringh_iov, max_num));
-	BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
-	BUILD_BUG_ON(offsetof(struct iovec, iov_base) !=
-		     offsetof(struct kvec, iov_base));
-	BUILD_BUG_ON(offsetof(struct iovec, iov_len) !=
-		     offsetof(struct kvec, iov_len));
-	BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_base)
-		     != sizeof(((struct kvec *)NULL)->iov_base));
-	BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_len)
-		     != sizeof(((struct kvec *)NULL)->iov_len));
-
 	*head = err;
 	err = __vringh_iov(vrh, *head, (struct vringh_kiov *)riov,
 			   (struct vringh_kiov *)wiov,
@@ -740,14 +720,14 @@ int vringh_getdesc_user(struct vringh *vrh,
 EXPORT_SYMBOL(vringh_getdesc_user);
 
 /**
- * vringh_iov_pull_user - copy bytes from vring_iov.
+ * vringh_iov_pull_user - copy bytes from vring_kiov.
  * @riov: the riov as passed to vringh_getdesc_user() (updated as we consume)
  * @dst: the place to copy.
  * @len: the maximum length to copy.
  *
  * Returns the bytes copied <= len or a negative errno.
  */
-ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
+ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len)
 {
 	return vringh_iov_xfer(NULL, (struct vringh_kiov *)riov,
 			       dst, len, xfer_from_user);
@@ -755,14 +735,14 @@ ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
 EXPORT_SYMBOL(vringh_iov_pull_user);
 
 /**
- * vringh_iov_push_user - copy bytes into vring_iov.
+ * vringh_iov_push_user - copy bytes into vring_kiov.
  * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we consume)
  * @src: the place to copy from.
  * @len: the maximum length to copy.
  *
  * Returns the bytes copied <= len or a negative errno.
  */
-ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
+ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
 			     const void *src, size_t len)
 {
 	return vringh_iov_xfer(NULL, (struct vringh_kiov *)wiov,
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 1991a02c6431..733d948e8123 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -79,18 +79,6 @@ struct vringh_range {
 	u64 offset;
 };
 
-/**
- * struct vringh_iov - iovec mangler.
- *
- * Mangles iovec in place, and restores it.
- * Remaining data is iov + i, of used - i elements.
- */
-struct vringh_iov {
-	struct iovec *iov;
-	size_t consumed; /* Within iov[i] */
-	unsigned i, used, max_num;
-};
-
 /**
  * struct vringh_kiov - kvec mangler.
  *
@@ -113,44 +101,19 @@ int vringh_init_user(struct vringh *vrh, u64 features,
 		     vring_avail_t __user *avail,
 		     vring_used_t __user *used);
 
-static inline void vringh_iov_init(struct vringh_iov *iov,
-				   struct iovec *iovec, unsigned num)
-{
-	iov->used = iov->i = 0;
-	iov->consumed = 0;
-	iov->max_num = num;
-	iov->iov = iovec;
-}
-
-static inline void vringh_iov_reset(struct vringh_iov *iov)
-{
-	iov->iov[iov->i].iov_len += iov->consumed;
-	iov->iov[iov->i].iov_base -= iov->consumed;
-	iov->consumed = 0;
-	iov->i = 0;
-}
-
-static inline void vringh_iov_cleanup(struct vringh_iov *iov)
-{
-	if (iov->max_num & VRINGH_IOV_ALLOCATED)
-		kfree(iov->iov);
-	iov->max_num = iov->used = iov->i = iov->consumed = 0;
-	iov->iov = NULL;
-}
-
 /* Convert a descriptor into iovecs. */
 int vringh_getdesc_user(struct vringh *vrh,
-			struct vringh_iov *riov,
-			struct vringh_iov *wiov,
+			struct vringh_kiov *riov,
+			struct vringh_kiov *wiov,
 			bool (*getrange)(struct vringh *vrh,
 					 u64 addr, struct vringh_range *r),
 			u16 *head);
 
 /* Copy bytes from readable vsg, consuming it (and incrementing wiov->i). */
-ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len);
+ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len);
 
 /* Copy bytes into writable vsg, consuming it (and incrementing wiov->i). */
-ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
+ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
 			     const void *src, size_t len);
 
 /* Mark a descriptor as used. */
-- 
2.25.1

