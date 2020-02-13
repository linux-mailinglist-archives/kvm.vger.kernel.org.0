Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93915C83A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 17:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgBMQ3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 11:29:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26730 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727753AbgBMQ3p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 11:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581611383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GnSPi3NNMALEd7N/T77OhfN8sxR6BWu44cWI4u/jVdY=;
        b=QUkdf2ApkO8GD87TuscsjcwUKKIipvDJP1GstBOeRKaiD502SJ1f7YuQGKko5sns+NtQJN
        4S3zS4f+kKsOgla/Sc42PsPK8Gha2f/UaZ85TXhlFLdnLbZ1+z/QTxo8XlaxBU/M8rrAlZ
        3YATvXa8cO/k5QYeUwj2R/8MeqJAWdQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-_HYzn0z7PQavpa_RvsOvwA-1; Thu, 13 Feb 2020 11:29:42 -0500
X-MC-Unique: _HYzn0z7PQavpa_RvsOvwA-1
Received: by mail-wr1-f71.google.com with SMTP id u18so2539361wrn.11
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 08:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GnSPi3NNMALEd7N/T77OhfN8sxR6BWu44cWI4u/jVdY=;
        b=LRgLpBnHLJFpyQAtdVDRC4H70LW2hRuBxUfDnC+vgrGGsflnlj2YB0587Aamyy3Cz0
         wEhkwuLMfrMWZlB9QPuK8k6DGpdqR/YZCmXu//e78qt5W3bSrX6jCirWrYF+wtVyZErj
         /3K5AzMszkyakjayEdGmDDtzgTxlGQ2FQbJmRRj9aVgJFBAsXYX70F8k1mxjeyqpUFvG
         yXuHyu8C9orPG9lOyp/MD70ZMNBs+gjeiv/T01Hzuy5mF7IUFacqUCJ44c7IZJUrOto7
         LAtD8hqnkRRWsVuGjC6D42AH0SqKmy6mxaBHd4owjkKHE5lg0Zo8gUXdYzfQ+/lQtpTN
         gkoA==
X-Gm-Message-State: APjAAAU6TMLqZOw4O4M4CXeTP+K/jQx2aw8mIPSeS6nZrTvdli7opWMR
        GVVBmdcuKfNowy03mIbYB+lr8Um12EglH9S5a3CSBIvyr3ScowFBYAo4BrAylf6gIw6N7PeX7ku
        jvtCfjuz/nQ6r
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr21092540wru.99.1581611380881;
        Thu, 13 Feb 2020 08:29:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6WVNBdlYmm/Zwp3A4QeiUojNwbduC/FyeHIAv0RcWb060M5fMV8sHenSo47J/+jkAFSytdA==
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr21092519wru.99.1581611380673;
        Thu, 13 Feb 2020 08:29:40 -0800 (PST)
Received: from eperezma.remote.csb (246.141.221.87.dynamic.jazztel.es. [87.221.141.246])
        by smtp.gmail.com with ESMTPSA id j5sm3490722wrb.33.2020.02.13.08.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 08:29:39 -0800 (PST)
Message-ID: <468983fad50a5e74a739f71487f0ea11e8d4dfd1.camel@redhat.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger
 random crashes in KVM guests after reboot
From:   Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Date:   Thu, 13 Feb 2020 17:29:38 +0100
In-Reply-To: <bb9fb726-306c-5330-05aa-a86bd1b18097@de.ibm.com>
References: <20200107042401-mutt-send-email-mst@kernel.org>
         <20200107065434-mutt-send-email-mst@kernel.org>
         <fe6e7e90-3004-eb7a-9ed8-b53a7667959f@de.ibm.com>
         <20200120012724-mutt-send-email-mst@kernel.org>
         <2a63b15f-8cf5-5868-550c-42e2cfd92c60@de.ibm.com>
         <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
         <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com>
         <20200206171349-mutt-send-email-mst@kernel.org>
         <5c860fa1-cef5-b389-4ebf-99a62afa0fe8@de.ibm.com>
         <20200207025806-mutt-send-email-mst@kernel.org>
         <97c93d38-ef07-e321-d133-18483d54c0c0@de.ibm.com>
         <CAJaqyWfngzP4d01B6+Sqt8FXN6jX7kGegjx8ie4no_1Er3igQA@mail.gmail.com>
         <43a5dbaa-9129-e220-8483-45c60a82c945@de.ibm.com>
         <e299afca8e22044916abbf9fbbd0bff6b0ee9e13.camel@redhat.com>
         <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com>
         <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
         <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com>
         <2364d0728c3bb4bcc0c13b591f774109a9274a30.camel@redhat.com>
         <bb9fb726-306c-5330-05aa-a86bd1b18097@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Can we try with this traces?

From b793b4106085ab1970bdedb340e49f37843ed585 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Date: Thu, 13 Feb 2020 17:27:05 +0100
Subject: [PATCH] vhost: Add debug in ioctl calls

---
 drivers/vhost/net.c   | 20 +++++++++++++++++---
 drivers/vhost/vhost.c | 16 ++++++++++++++--
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e158159671fa..e4d5f843f9c0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1505,10 +1505,13 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 
 	mutex_lock(&n->dev.mutex);
 	r = vhost_dev_check_owner(&n->dev);
-	if (r)
+	if (r) {
+		pr_debug("vhost_dev_check_owner index=%u fd=%d rc r=%d", index, fd, r);
 		goto err;
+	}
 
 	if (index >= VHOST_NET_VQ_MAX) {
+		pr_debug("vhost_dev_check_owner index=%u fd=%d MAX=%d", index, fd, VHOST_NET_VQ_MAX);
 		r = -ENOBUFS;
 		goto err;
 	}
@@ -1518,22 +1521,26 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 
 	/* Verify that ring has been setup correctly. */
 	if (!vhost_vq_access_ok(vq)) {
+		pr_debug("vhost_net_set_backend index=%u fd=%d !vhost_vq_access_ok", index, fd);
 		r = -EFAULT;
 		goto err_vq;
 	}
 	sock = get_socket(fd);
 	if (IS_ERR(sock)) {
 		r = PTR_ERR(sock);
+		pr_debug("vhost_net_set_backend index=%u fd=%d get_socket err r=%d", index, fd, r);
 		goto err_vq;
 	}
 
 	/* start polling new socket */
 	oldsock = vq->private_data;
 	if (sock != oldsock) {
+		pr_debug("sock=%p != oldsock=%p index=%u fd=%d vq=%p", sock, oldsock, index, fd, vq);
 		ubufs = vhost_net_ubuf_alloc(vq,
 					     sock && vhost_sock_zcopy(sock));
 		if (IS_ERR(ubufs)) {
 			r = PTR_ERR(ubufs);
+			pr_debug("ubufs index=%u fd=%d err r=%d vq=%p", index, fd, r, vq);
 			goto err_ubufs;
 		}
 
@@ -1541,11 +1548,15 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		vq->private_data = sock;
 		vhost_net_buf_unproduce(nvq);
 		r = vhost_vq_init_access(vq);
-		if (r)
+		if (r) {
+			pr_debug("init_access index=%u fd=%d r=%d vq=%p", index, fd, r, vq);
 			goto err_used;
+		}
 		r = vhost_net_enable_vq(n, vq);
-		if (r)
+		if (r) {
+			pr_debug("enable_vq index=%u fd=%d r=%d vq=%p", index, fd, r, vq);
 			goto err_used;
+		}
 		if (index == VHOST_NET_VQ_RX)
 			nvq->rx_ring = get_tap_ptr_ring(fd);
 
@@ -1559,6 +1570,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 
 	mutex_unlock(&vq->mutex);
 
+	pr_debug("sock=%p", sock);
+
 	if (oldubufs) {
 		vhost_net_ubuf_put_wait_and_free(oldubufs);
 		mutex_lock(&vq->mutex);
@@ -1710,6 +1723,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 
 	switch (ioctl) {
 	case VHOST_NET_SET_BACKEND:
+		pr_debug("VHOST_NET_SET_BACKEND");
 		if (copy_from_user(&backend, argp, sizeof backend))
 			return -EFAULT;
 		return vhost_net_set_backend(n, backend.index, backend.fd);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 021d70bed015..7f4848f9cec3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1642,18 +1642,30 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EINVAL;
 			break;
 		}
+
+		if (vq->last_avail_idx || vq->avail_idx) {
+			pr_debug(
+				"strange VHOST_SET_VRING_BASE [vq=%p][s.index=%u][s.num=%u]",
+				vq, s.index, s.num);
+			dump_stack();
+			r = 0;
+			break;
+		}
 		vq->last_avail_idx = s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
 		pr_debug(
-			"VHOST_SET_VRING_BASE [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u]",
-			vq, vq->last_avail_idx, vq->avail_idx);
+			"VHOST_SET_VRING_BASE [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][s.index=%u][s.num=%u]",
+			vq, vq->last_avail_idx, vq->avail_idx, s.index, s.num);
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
 		s.num = vq->last_avail_idx;
 		if (copy_to_user(argp, &s, sizeof s))
 			r = -EFAULT;
+		pr_debug(
+			"VHOST_GET_VRING_BASE [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][s.index=%u][s.num=%u]",
+			vq, vq->last_avail_idx, vq->avail_idx, s.index, s.num);
 		break;
 	case VHOST_SET_VRING_KICK:
 		if (copy_from_user(&f, argp, sizeof f)) {
-- 
2.18.1


