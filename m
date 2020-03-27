Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317FB195602
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 12:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgC0LIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 07:08:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:27809 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbgC0LIi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 07:08:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585307315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fH4qLur4ON8NrF1LbJv92KKQt8OnmUmCge5BUQOrlww=;
        b=B5Zau70dS0vDMSirYNrba0dxfR/bbeByY9tmyK5bQVzJgF60JN2ADA9dh5AsF+l3UcgCSJ
        Tzie7EvpBAd4gc2AlDAZcL9om3+ZcG58XCfpsHPTgsJ4KfB9O94+vTscQpIA61yjyEuKO7
        LDGUoYkP8ItrVcbEGdcrpE5o84x2Jus=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-6O2VgYjfOa2tHHkXPVZoVA-1; Fri, 27 Mar 2020 07:08:33 -0400
X-MC-Unique: 6O2VgYjfOa2tHHkXPVZoVA-1
Received: by mail-wm1-f72.google.com with SMTP id n188so4222264wmf.0
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 04:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fH4qLur4ON8NrF1LbJv92KKQt8OnmUmCge5BUQOrlww=;
        b=iMA3wzA3gE2qaDyBDAtlEVvZu5ugfxPR4r0+9hBLpRXvyFtR76gghbWAo3cDGW9Fyz
         taF7q6pnloJw3Z4lG8eZOkz+7r/dkP+IzbckxxId0At+n2qc9n3SAh0uhtBqxIy7K7mg
         SZcybNqbUB+i+uqPA+85Dlj8UGfD8QQKivgUBf7k+cmb0BLETJtZpdMmElctM+lXTBqF
         LU9m9c5JI+vDrp2JI6T5n7TbwlWUgK0oNFl693VYKsBjsGRrvfTKIfjWe0vErhrX9vfX
         /2kypb+m3MO/LQcRccQ1xAITOZ3ZU7b08HJ3B4+7+Xctwg95Zg7aCh3qsL+rNat33e0P
         70Fw==
X-Gm-Message-State: ANhLgQ0pQnW6TSmfcGhj8X0Tv/JLHKbzrfWWEcUZWpWTPqUpYbgbOCu+
        bXMcIpN+/U0iBUS1MTIfzo/QPLOx78wOSfLRCQ2YepHJNXfd20qUKnKnQ5P5yqpCgLGbd9m3dJd
        5SU48fBSZj/Yv
X-Received: by 2002:a1c:1dcf:: with SMTP id d198mr4799008wmd.121.1585307312615;
        Fri, 27 Mar 2020 04:08:32 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuEzqlTQiXs79xG0qkAVhK3xd73wNi/LIsyb+cuWBmIMTWVMduaiA44lR9eb/fWOVKNj2sAcw==
X-Received: by 2002:a1c:1dcf:: with SMTP id d198mr4798979wmd.121.1585307312252;
        Fri, 27 Mar 2020 04:08:32 -0700 (PDT)
Received: from eperezma.remote.csb (37.143.78.188.dynamic.jazztel.es. [188.78.143.37])
        by smtp.gmail.com with ESMTPSA id d206sm7729385wmf.29.2020.03.27.04.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 04:08:31 -0700 (PDT)
Message-ID: <d093c51e5af2e86c1c7af0b2ee469157e92d8366.camel@redhat.com>
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
Date:   Fri, 27 Mar 2020 12:08:29 +0100
In-Reply-To: <1ee3a272-e391-e2e8-9cbb-5d3e2d40bec2@de.ibm.com>
References: <20200107042401-mutt-send-email-mst@kernel.org>
         <43a5dbaa-9129-e220-8483-45c60a82c945@de.ibm.com>
         <e299afca8e22044916abbf9fbbd0bff6b0ee9e13.camel@redhat.com>
         <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com>
         <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
         <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com>
         <2364d0728c3bb4bcc0c13b591f774109a9274a30.camel@redhat.com>
         <bb9fb726-306c-5330-05aa-a86bd1b18097@de.ibm.com>
         <468983fad50a5e74a739f71487f0ea11e8d4dfd1.camel@redhat.com>
         <2dc1df65-1431-3917-40e5-c2b12096e2a7@de.ibm.com>
         <bd9c9b4d99abd20d5420583af5a4954ea1cf4618.camel@redhat.com>
         <e11ba53c-a5fa-0518-2e06-9296897ed529@de.ibm.com>
         <CAJaqyWfJFArAdpOwehTn5ci-frqai+pazGgcn2VvQSebqGRVtg@mail.gmail.com>
         <80520391-d90d-e10d-a107-7a18f2810900@de.ibm.com>
         <dabe59fe-e068-5935-f49e-bc1da3d8471a@de.ibm.com>
         <35dca16b9a85eb203f35d3e55dcaa9d0dae5a922.camel@redhat.com>
         <3144806d-436e-86a1-2e29-74f7027f7f0b@de.ibm.com>
         <8e226821a8878f53585d967b8af547526d84c73e.camel@redhat.com>
         <1ee3a272-e391-e2e8-9cbb-5d3e2d40bec2@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christian.

Sorry for the late response. Could we try this one over eccb852f1fe6bede630e2e4f1a121a81e34354ab, and see if you still
can reproduce the bug?

Apart from that, could you print me the backtrace when qemu calls vhost_kernel_set_vring_base and
vhost_kernel_get_vring_base functions?

Thank you very much!

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e158159671fa..a1a4239512bb 100644
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
@@ -1712,6 +1725,9 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 	case VHOST_NET_SET_BACKEND:
 		if (copy_from_user(&backend, argp, sizeof backend))
 			return -EFAULT;
+		pr_debug("VHOST_NET_SET_BACKEND [b.index=%u][b.fd=%d]",
+			 backend.index, backend.fd);
+		dump_stack();
 		return vhost_net_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
 		features = VHOST_NET_FEATURES;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b5a51b1f2e79..9dd0bcae0b22 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -372,6 +372,11 @@ static int vhost_worker(void *data)
 	return 0;
 }
 
+static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
+{
+	return vq->max_descs - UIO_MAXIOV;
+}
+
 static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 {
 	kfree(vq->descs);
@@ -394,7 +399,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		vq->max_descs = dev->iov_limit;
-		vq->batch_descs = dev->iov_limit - UIO_MAXIOV;
+		if (vhost_vq_num_batch_descs(vq) < 0) {
+			return -EINVAL;
+		}
 		vq->descs = kmalloc_array(vq->max_descs,
 					  sizeof(*vq->descs),
 					  GFP_KERNEL);
@@ -1642,15 +1649,27 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EINVAL;
 			break;
 		}
+
+		pr_debug(
+			"VHOST_SET_VRING_BASE [vq=%p][s.index=%u][s.num=%u][vq->avail_idx=%d][vq->last_avail_idx=%d][vq-
>ndescs=%d][vq->first_desc=%d]",
+			vq, s.index, s.num, vq->avail_idx, vq->last_avail_idx,
+			vq->ndescs, vq->first_desc);
+		dump_stack();
 		vq->last_avail_idx = s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
+		vq->ndescs = vq->first_desc = 0;
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
 		s.num = vq->last_avail_idx;
 		if (copy_to_user(argp, &s, sizeof s))
 			r = -EFAULT;
+		pr_debug(
+			"VHOST_GET_VRING_BASE [vq=%p][s.index=%u][s.num=%u][vq->avail_idx=%d][vq->last_avail_idx=%d][vq-
>ndescs=%d][vq->first_desc=%d]",
+			vq, s.index, s.num, vq->avail_idx, vq->last_avail_idx,
+			vq->ndescs, vq->first_desc);
+		dump_stack();
 		break;
 	case VHOST_SET_VRING_KICK:
 		if (copy_from_user(&f, argp, sizeof f)) {
@@ -2239,8 +2258,8 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
 		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
-			vq_err(vq, "Guest moved used index from %u to %u",
-				last_avail_idx, vq->avail_idx);
+			vq_err(vq, "Guest moved vq %p used index from %u to %u",
+				vq, last_avail_idx, vq->avail_idx);
 			return -EFAULT;
 		}
 
@@ -2316,6 +2335,9 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
 
 	/* On success, increment avail index. */
+	pr_debug(
+		"[vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][vq->ndescs=%d][vq->first_desc=%d]",
+		vq, vq->last_avail_idx, vq->avail_idx, vq->ndescs, vq->first_desc);
 	vq->last_avail_idx++;
 
 	return 0;
@@ -2333,7 +2355,7 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	if (vq->ndescs)
 		return 0;
 
-	while (!ret && vq->ndescs <= vq->batch_descs)
+	while (!ret && vq->ndescs <= vhost_vq_num_batch_descs(vq))
 		ret = fetch_buf(vq);
 
 	return vq->ndescs ? 0 : ret;
@@ -2432,6 +2454,9 @@ EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
+	pr_debug(
+		"DISCARD [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][n=%d]",
+		vq, vq->last_avail_idx, vq->avail_idx, n);
 	vq->last_avail_idx -= n;
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 661088ae6dc7..e648b9b997d4 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -102,7 +102,6 @@ struct vhost_virtqueue {
 	int ndescs;
 	int first_desc;
 	int max_descs;
-	int batch_descs;
 
 	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
 	struct file *kick;

