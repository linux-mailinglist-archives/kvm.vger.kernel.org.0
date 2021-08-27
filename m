Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7E53F9804
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244933AbhH0KSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244917AbhH0KSS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA7Fhc017884
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=kSxvO69xU+QDVwvkIDlImVnpXpypanDLMyb1xgPYYR4=;
 b=KXlBxOTURfXMlDxAgcwfhliCt4ehIFM9/X4ksGJPLMkfL7Ddpl/CnRNcD+zyoiYBG7Er
 mhcuxt5qwZhN+MHx6kYBaL/MjLGpq7ZCCiLtKfedR4ehYToxONoDrvKeJfFyfFK78pnL
 OLkC7YoTa9Dl++nag3yiv8Rcs9g5oLAqWZ0V/XXUsOoH3K4lZR1ElcuFwrUWLJYqznfW
 yGDjBYaqzpvutRhwns9eHlZjuNFfjTvUhixl6ku6B9FYkQx2RJ7meThgp6szqFxklq0H
 QyJWej7285CZoCd0WXpL02BocPpWARRb4mTNZykMp6063VPfaRWy2FtfIQyXt0yZ+k3a /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apver2es5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RAHTQa063378
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apver2erb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:29 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAD3V8017053;
        Fri, 27 Aug 2021 10:17:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3ajs48seyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHNJp30212416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16F054C05E;
        Fri, 27 Aug 2021 10:17:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9A2F4C04A;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 5/7] virtio: implement the virtio_add_inbuf routine
Date:   Fri, 27 Aug 2021 12:17:18 +0200
Message-Id: <1630059440-15586-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H7JWrOBiZolIo8ajoalkY-JIGnajfxaX
X-Proofpoint-GUID: 6D_txT4PadQPObuBgWj0xZO5ElWJrmaj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To communicate in both directions with a VIRTIO device we need
to add the incoming communication to the VIRTIO level.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/virtio.c | 32 ++++++++++++++++++++++++++++++++
 lib/virtio.h |  2 ++
 2 files changed, 34 insertions(+)

diff --git a/lib/virtio.c b/lib/virtio.c
index e10153b9..b84bc680 100644
--- a/lib/virtio.c
+++ b/lib/virtio.c
@@ -47,6 +47,38 @@ void vring_init_virtqueue(struct vring_virtqueue *vq, unsigned index,
 	vq->data[i] = NULL;
 }
 
+int virtqueue_add_inbuf(struct virtqueue *_vq, char *buf, unsigned int len)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	unsigned int avail;
+	int head;
+
+	assert(buf);
+	assert(len);
+
+	if (!vq->vq.num_free)
+		return -1;
+
+	--vq->vq.num_free;
+
+	head = vq->free_head;
+
+	vq->vring.desc[head].flags = 0;
+	vq->vring.desc[head].addr = virt_to_phys(buf);
+	vq->vring.desc[head].len = len;
+
+	vq->free_head = vq->vring.desc[head].next;
+
+	vq->data[head] = buf;
+
+	avail = (vq->vring.avail->idx & (vq->vring.num - 1));
+	vq->vring.avail->ring[avail] = head;
+	wmb();	/* be sure to update the ring before updating the idx */
+	vq->vring.avail->idx++;
+	vq->num_added++;
+
+	return 0;
+}
 int virtqueue_add_outbuf(struct virtqueue *_vq, char *buf, unsigned int len)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
diff --git a/lib/virtio.h b/lib/virtio.h
index 2c31fdc7..44b727f8 100644
--- a/lib/virtio.h
+++ b/lib/virtio.h
@@ -141,6 +141,8 @@ extern void vring_init_virtqueue(struct vring_virtqueue *vq, unsigned index,
 				 const char *name);
 extern int virtqueue_add_outbuf(struct virtqueue *vq, char *buf,
 				unsigned int len);
+extern int virtqueue_add_inbuf(struct virtqueue *vq, char *buf,
+			       unsigned int len);
 extern bool virtqueue_kick(struct virtqueue *vq);
 extern void detach_buf(struct vring_virtqueue *vq, unsigned head);
 extern void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len);
-- 
2.25.1

