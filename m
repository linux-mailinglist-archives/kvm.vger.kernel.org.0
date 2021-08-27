Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDFD3F9802
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244927AbhH0KSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64010 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244901AbhH0KSR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:17 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA6hSF157080
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=vOrQR7P0Ey6hNtW42UKrXv8D6ot43gvqIjGjvdzk+yQ=;
 b=btAbuwwNh3WZIpDn1lcdFIO5me0fFLMg2V6RtHClgt9v0nQjhkYhjzNW9wlq09GZdUVY
 4zlpDZrQH3WXK5c835/14wjvvzSFDkhiTPl7QT2sEjPkMkCsHblC8wE16+DRtLAQtDLT
 6OEKiwkq5ZZt4oJAZlr/SM/4QkQMDPnuxvZFq5CC90Q0vDjzS3HFJzqWly1WdCyKiiHl
 KFf4T0nhESG0gJJcCYYEd+UtlYaP0CDyzckQ0YOA1HfxoywEVUYPOGh39QP1xDkcyAx8
 PzPBfiJPZKBwG1VohqnooFOh8L3M+ykGRwG5aPp30quy4BenbaKLTXFFaUD3xbIIj0AQ Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwfm137m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:28 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RA74Ym158995
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwfm1374-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:27 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAD6j1013194;
        Fri, 27 Aug 2021 10:17:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ajrrhkbbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHMvZ49349094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6334B4C044;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13FAD4C040;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 3/7] s390x: virtio: CCW transport implementation
Date:   Fri, 27 Aug 2021 12:17:16 +0200
Message-Id: <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: It4zXu5jV9dZc-CI6eQGfXuT7H6QSRf4
X-Proofpoint-ORIG-GUID: 4zY6hS1JZbPoirwHnf180jghKiMLxf0E
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the implementation of the virtio-ccw transport level.

We only support VIRTIO revision 0.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/virtio-ccw.c | 374 +++++++++++++++++++++++++++++++++++++++++
 lib/s390x/virtio-ccw.h | 111 ++++++++++++
 lib/virtio-config.h    |  30 ++++
 s390x/Makefile         |   2 +
 4 files changed, 517 insertions(+)
 create mode 100644 lib/s390x/virtio-ccw.c
 create mode 100644 lib/s390x/virtio-ccw.h
 create mode 100644 lib/virtio-config.h

diff --git a/lib/s390x/virtio-ccw.c b/lib/s390x/virtio-ccw.c
new file mode 100644
index 00000000..cf447de6
--- /dev/null
+++ b/lib/s390x/virtio-ccw.c
@@ -0,0 +1,374 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Virtio CCW Library
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ */
+
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/page.h>
+#include <string.h>
+#include <interrupt.h>
+#include <asm/arch_def.h>
+#include <asm/facility.h>
+#include <asm/uv.h>
+
+#include <css.h>
+#include <virtio.h>
+#include <virtio-config.h>
+#include <virtio-ccw.h>
+#include <malloc_io.h>
+
+static struct linked_list vcdev_list = {
+	.prev = &vcdev_list,
+	.next = &vcdev_list
+};
+
+static inline uint32_t swap16(uint32_t b)
+{
+		return (((b & 0xff00U) <<  8) |
+		((b & 0x00ff) >>  8));
+}
+
+static inline uint32_t swap32(uint32_t b)
+{
+	return (((b & 0x000000ffU) << 24) |
+		((b & 0x0000ff00U) <<  8) |
+		((b & 0x00ff0000U) >>  8) |
+		((b & 0xff000000U) >> 24));
+}
+
+static inline uint64_t swap64(uint64_t x)
+{
+	return (((x & 0x00000000000000ffULL) << 56) |
+		((x & 0x000000000000ff00ULL) << 40) |
+		((x & 0x0000000000ff0000ULL) << 24) |
+		((x & 0x00000000ff000000ULL) <<  8) |
+		((x & 0x000000ff00000000ULL) >>  8) |
+		((x & 0x0000ff0000000000ULL) >> 24) |
+		((x & 0x00ff000000000000ULL) >> 40) |
+		((x & 0xff00000000000000ULL) >> 56));
+}
+
+/*
+ * flags: flags for CCW
+ * Returns !0 on failure
+ * Returns 0 on success
+ */
+int ccw_send(struct virtio_ccw_device *vcdev, int code, void *data, int count,
+	     unsigned char flags)
+{
+	struct ccw1 *ccw;
+	int ret = -1;
+
+	ccw = alloc_io_mem(sizeof(*ccw), 0);
+	if (!ccw)
+		return ret;
+
+	/* Build the CCW chain with a single CCW */
+	ccw->code = code;
+	ccw->flags = flags;
+	ccw->count = count;
+	ccw->data_address = (unsigned long)data;
+
+	ret = start_ccw1_chain(vcdev->schid, ccw);
+	if (!ret)
+		ret = wait_and_check_io_completion(vcdev->schid);
+
+	free_io_mem(ccw, sizeof(*ccw));
+	return ret;
+}
+
+int virtio_ccw_set_revision(struct virtio_ccw_device *vcdev)
+{
+	struct virtio_rev_info *rev_info;
+	int ret = -1;
+
+	rev_info = alloc_io_mem(sizeof(*rev_info), 0);
+	if (!rev_info)
+		return ret;
+
+	rev_info->revision = VIRTIO_CCW_REV_MAX;
+	rev_info->revision = 0;
+	do {
+		ret = ccw_send(vcdev, CCW_CMD_SET_VIRTIO_REV, rev_info,
+			       sizeof(*rev_info), 0);
+	} while (ret && rev_info->revision--);
+
+	free_io_mem(rev_info, sizeof(*rev_info));
+
+	return ret ? -1 : rev_info->revision;
+}
+
+int virtio_ccw_reset(struct virtio_ccw_device *vcdev)
+{
+	return ccw_send(vcdev, CCW_CMD_VDEV_RESET, 0, 0, 0);
+}
+
+int virtio_ccw_read_status(struct virtio_ccw_device *vcdev)
+{
+	return ccw_send(vcdev, CCW_CMD_READ_STATUS, &vcdev->status,
+			sizeof(vcdev->status), 0);
+}
+
+int virtio_ccw_write_status(struct virtio_ccw_device *vcdev)
+{
+	return ccw_send(vcdev, CCW_CMD_WRITE_STATUS, &vcdev->status,
+			sizeof(vcdev->status), 0);
+}
+
+int virtio_ccw_read_features(struct virtio_ccw_device *vcdev, uint64_t *features)
+{
+	struct virtio_feature_desc *f_desc = &vcdev->f_desc;
+
+	f_desc->index = 0;
+	if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
+		return -1;
+	*features = swap32(f_desc->features);
+
+	f_desc->index = 1;
+	if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
+		return -1;
+	*features |= (uint64_t)swap32(f_desc->features) << 32;
+
+	return 0;
+}
+
+int virtio_ccw_write_features(struct virtio_ccw_device *vcdev, uint64_t features)
+{
+	struct virtio_feature_desc *f_desc = &vcdev->f_desc;
+
+	f_desc->index = 0;
+	f_desc->features = swap32((uint32_t)features & 0xffffffff);
+	if (ccw_send(vcdev, CCW_CMD_WRITE_FEAT, &f_desc, sizeof(*f_desc), 0))
+		return -1;
+
+	f_desc->index = 1;
+	f_desc->features = swap32((uint32_t)(features >> 32) & 0xffffffff);
+	if (ccw_send(vcdev, CCW_CMD_WRITE_FEAT, &f_desc, sizeof(*f_desc), 0))
+		return -1;
+
+	return 0;
+}
+
+int virtio_ccw_read_config(struct virtio_ccw_device *vcdev)
+{
+	return ccw_send(vcdev, CCW_CMD_READ_CONF, &vcdev->config,
+			sizeof(vcdev->config), 0);
+}
+
+int virtio_ccw_write_config(struct virtio_ccw_device *vcdev)
+{
+	return ccw_send(vcdev, CCW_CMD_WRITE_CONF, &vcdev->config,
+			sizeof(vcdev->config), 0);
+}
+
+int virtio_ccw_setup_indicators(struct virtio_ccw_device *vcdev)
+{
+	vcdev->ind = alloc_io_mem(sizeof(PAGE_SIZE), 0);
+	if (ccw_send(vcdev, CCW_CMD_SET_IND, &vcdev->ind,
+		     sizeof(vcdev->ind), 0))
+		return -1;
+
+	vcdev->conf_ind = alloc_io_mem(PAGE_SIZE, 0);
+	if (ccw_send(vcdev, CCW_CMD_SET_CONF_IND, &vcdev->conf_ind,
+		     sizeof(vcdev->conf_ind), 0))
+		return -1;
+
+	return 0;
+}
+
+static uint64_t virtio_ccw_notify_host(int schid, int queue, uint64_t cookie)
+{
+	register unsigned long nr asm("1") = 0x03;
+	register unsigned long s asm("2") = schid;
+	register unsigned long q asm("3") = queue;
+	register long rc asm("2");
+	register long c asm("4") = cookie;
+
+	asm volatile ("diag 2,4,0x500\n"
+			: "=d" (rc)
+			: "d" (nr), "d" (s), "d" (q), "d"(c)
+			: "memory", "cc");
+	return rc;
+}
+
+static bool virtio_ccw_notify(struct virtqueue *vq)
+{
+	struct virtio_ccw_device *vcdev = to_vc_device(vq->vdev);
+	struct virtio_ccw_vq_info *info = vq->priv;
+
+	info->cookie = virtio_ccw_notify_host(vcdev->schid, vq->index,
+					      info->cookie);
+	if (info->cookie < 0)
+		return false;
+	return true;
+}
+
+/* allocates a vring_virtqueue but returns a pointer to the
+ * virtqueue inside of it or NULL on error.
+ */
+static struct virtqueue *setup_vq(struct virtio_device *vdev, int index,
+				  void (*callback)(struct virtqueue *vq),
+				  const char *name)
+{
+	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	struct virtio_ccw_vq_info *info;
+	struct vring_virtqueue *vq;
+	struct vring *vr;
+	void *queue;
+
+	vq = alloc_io_mem(sizeof(*vq), 0);
+	info = alloc_io_mem(sizeof(*info), 0);
+	queue = alloc_io_mem(4 * PAGE_SIZE, 0);
+	assert(vq && queue && info);
+
+	info->info_block = alloc_io_mem(sizeof(*info->info_block), 0);
+	assert(info->info_block);
+
+	vcdev->vq_conf.index = index;
+	if (ccw_send(vcdev, CCW_CMD_READ_VQ_CONF, &vcdev->vq_conf,
+		     sizeof(vcdev->vq_conf), 0))
+		return NULL;
+
+	vring_init_virtqueue(vq, index, vcdev->vq_conf.max_num, PAGE_SIZE, vdev,
+			     queue, virtio_ccw_notify, callback, name);
+
+	vr = &vq->vring;
+	info->info_block->s.desc = vr->desc;
+	info->info_block->s.index = index;
+	info->info_block->s.num = vr->num;
+	info->info_block->s.avail = vr->avail;
+	info->info_block->s.used = vr->used;
+
+	info->info_block->l.desc = vr->desc;
+	info->info_block->l.index = index;
+	info->info_block->l.num = vr->num;
+	info->info_block->l.align = PAGE_SIZE;
+
+	if (ccw_send(vcdev, CCW_CMD_SET_VQ, info->info_block,
+		     sizeof(info->info_block->l), 0))
+		return NULL;
+
+	info->vq = &vq->vq;
+	vq->vq.priv = info;
+
+	return &vq->vq;
+}
+
+static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
+			       struct virtqueue *vqs[], vq_callback_t *callbacks[],
+			       const char *names[])
+{
+	int i;
+
+	for (i = 0; i < nvqs; ++i) {
+		vqs[i] = setup_vq(vdev, i,
+				  callbacks ? callbacks[i] : NULL,
+				  names ? names[i] : "");
+		if (!vqs[i])
+			return -1;
+	}
+
+	return 0;
+}
+
+static void virtio_ccw_config_get(struct virtio_device *vdev,
+				  unsigned int offset, void *buf,
+				  unsigned int len)
+{
+	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+
+	if (virtio_ccw_read_config(vcdev))
+		return;
+	memcpy(buf, vcdev->config, len);
+}
+
+static void virtio_ccw_config_set(struct virtio_device *vdev,
+				  unsigned int offset, const void *buf,
+				  unsigned int len)
+{
+	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+
+	memcpy(vcdev->config, buf, len);
+	virtio_ccw_write_config(vcdev);
+}
+
+static const struct virtio_config_ops virtio_ccw_ops = {
+	.get = virtio_ccw_config_get,
+	.set = virtio_ccw_config_set,
+	.find_vqs = virtio_ccw_find_vqs,
+};
+
+const struct virtio_config_ops *virtio_ccw_register(void)
+{
+	return &virtio_ccw_ops;
+}
+
+static int sense(struct virtio_ccw_device *vcdev)
+{
+	struct senseid *senseid;
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+
+	assert(!ccw_send(vcdev, CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), 0));
+
+	assert(senseid->reserved == 0xff);
+
+	vcdev->cu_type = senseid->cu_type;
+	vcdev->cu_model = senseid->cu_model;
+	vcdev->dev_type = senseid->dev_type;
+	vcdev->dev_model = senseid->dev_model;
+
+	return 0;
+}
+
+static struct virtio_ccw_device *find_vcdev_by_devid(int devid)
+{
+	struct virtio_ccw_device *dev;
+	struct linked_list *l;
+
+	for (l = vcdev_list.next; l != &vcdev_list; l = l->next) {
+		dev = container_of(l, struct virtio_ccw_device, list);
+		if (dev->cu_model == devid)
+			return dev;
+	}
+	return NULL;
+}
+
+struct virtio_device *virtio_bind(u32 devid)
+{
+	struct virtio_ccw_device *vcdev;
+
+	vcdev = find_vcdev_by_devid(devid);
+
+	return &vcdev->vdev;
+}
+
+static int virtio_enumerate(int schid)
+{
+	struct virtio_ccw_device *vcdev;
+
+	vcdev = alloc_io_mem(sizeof(*vcdev), 0);
+	assert(vcdev);
+	vcdev->schid = schid;
+
+	list_add(&vcdev_list, &vcdev->list);
+
+	assert(css_enable(schid, IO_SCH_ISC) == 0);
+	sense(vcdev);
+
+	return 0;
+}
+
+/* Must get a param */
+bool virtio_ccw_init(void)
+{
+	return css_enumerate(virtio_enumerate) != 0;
+}
diff --git a/lib/s390x/virtio-ccw.h b/lib/s390x/virtio-ccw.h
new file mode 100644
index 00000000..961d8bed
--- /dev/null
+++ b/lib/s390x/virtio-ccw.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * VIRTIO-CCW definitions
+ *
+ * Copyright IBM, Corp. 2020
+ * Author: Pierre Morel <pmorel@linux.ibm.com>
+ *
+ */
+
+#ifndef VIRTIO_CCW_H
+#define VIRTIO_CCW_H
+
+#define CCW_CMD_WRITE_FEAT	0x11
+#define CCW_CMD_READ_FEAT	0x12
+#define CCW_CMD_SET_VQ		0x13
+#define CCW_CMD_WRITE_CONF	0x21
+#define CCW_CMD_READ_CONF	0x22
+#define CCW_CMD_WRITE_STATUS	0x31
+#define CCW_CMD_READ_VQ_CONF	0x32
+#define CCW_CMD_VDEV_RESET	0x33
+#define CCW_CMD_SET_IND		0x43
+#define CCW_CMD_SET_CONF_IND	0x53
+#define CCW_CMD_READ_STATUS	0x72
+#define CCW_CMD_SET_IND_ADAPTER	0x73
+#define CCW_CMD_SET_VIRTIO_REV	0x83
+
+struct virtio_rev_info {
+#define VIRTIO_CCW_REV_MAX 1
+	uint16_t revision;
+	uint16_t length;
+	uint8_t	data[];
+};
+
+struct virtio_feature_desc {
+	uint32_t features;
+	uint8_t index;
+} __attribute__ ((packed));
+
+struct vq_config_block {
+	uint16_t index;
+	uint16_t max_num;
+};
+
+struct vq_info_block_legacy {
+	struct vring_desc *desc;
+	uint32_t align;
+	uint16_t index;
+	uint16_t num;
+} __attribute__ ((packed));
+
+struct vq_info_block {
+	struct vring_desc *desc;
+	uint32_t res0;
+	uint16_t index;
+	uint16_t num;
+	struct vring_avail *avail;
+	struct vring_used *used;
+} __attribute__ ((packed));
+
+#define VIRTIO_CCW_CONFIG_SIZE	0x100
+
+#include <list.h>
+struct virtio_ccw_device {
+	struct virtio_device vdev;
+	uint8_t config[VIRTIO_CCW_CONFIG_SIZE];
+	struct virtio_config_ops *config_ops;
+	struct virtio_feature_desc f_desc;
+	struct vq_config_block vq_conf;
+	struct linked_list list;
+	int schid;
+	uint16_t dev_type;
+	uint8_t dev_model;
+	uint16_t cu_type;
+	uint8_t cu_model;
+	uint8_t status;
+	uint64_t *ind;
+	uint64_t *conf_ind;
+#define VCDEV_INIT	1
+#define VCDEV_ERROR	2
+	int state;
+};
+
+struct virtio_ccw_vq_info {
+	struct virtqueue *vq;
+	int num;
+	union {
+		struct vq_info_block s;
+		struct vq_info_block_legacy l;
+	} *info_block;
+	int bit_nr;
+	long cookie;
+};
+
+#define to_vc_device(vdev_ptr) \
+	container_of(vdev_ptr, struct virtio_ccw_device, vdev)
+
+int ccw_send(struct virtio_ccw_device *vdev, int code, void *data, int count,
+	     unsigned char flags);
+int virtio_ccw_set_revision(struct virtio_ccw_device *vdev);
+int virtio_ccw_reset(struct virtio_ccw_device *vdev);
+int virtio_ccw_read_config(struct virtio_ccw_device *vdev);
+int virtio_ccw_write_config(struct virtio_ccw_device *vdev);
+int virtio_ccw_read_status(struct virtio_ccw_device *vdev);
+int virtio_ccw_write_status(struct virtio_ccw_device *vdev);
+int virtio_ccw_read_features(struct virtio_ccw_device *vdev, uint64_t *f);
+int virtio_ccw_write_features(struct virtio_ccw_device *vdev, uint64_t f);
+int virtio_ccw_setup_indicators(struct virtio_ccw_device *vdev);
+
+bool virtio_ccw_init(void);
+const struct virtio_config_ops *virtio_ccw_register(void);
+#endif
diff --git a/lib/virtio-config.h b/lib/virtio-config.h
new file mode 100644
index 00000000..3507304c
--- /dev/null
+++ b/lib/virtio-config.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _VIRTIO_CONFIG_H_
+#define _VIRTIO_CONFIG_H_
+
+#define VIRTIO_CONFIG_S_ACKNOWLEDGE	0x01
+#define VIRTIO_CONFIG_S_DRIVER		0x02
+#define VIRTIO_CONFIG_S_DRIVER_OK	0x04
+#define VIRTIO_CONFIG_S_FEATURES_OK	0x08
+#define VIRTIO_CONFIG_S_NEEDS_RESET	0x40
+#define VIRTIO_CONFIG_S_FAILED		0x80
+
+/* Generic VIRTIO Features */
+#define VIRTIO_F_NOTIFY_ON_EMPTY	24
+#define VIRTIO_F_ANY_LAYOUT		27
+
+/* Transport specific features */
+#define VIRTIO_TRANSPORT_F_START	28
+#define VIRTIO_F_RING_INDIRECT_DESC	28
+#define VIRTIO_F_RING_EVENT_IDX		29
+#define VIRTIO_TRANSPORT_F_END		38
+
+/* New features starting with version 1 */
+#define VIRTIO_F_VERSION_1		32
+#define VIRTIO_F_IOMMU_PLATFORM		33
+#define VIRTIO_F_RING_PACKED		34
+#define VIRTIO_F_ORDER_PLATFORM		36
+#define VIRTIO_F_SR_IOV			37
+
+#endif /* _VIRTIO_CONFIG_H_ */
diff --git a/s390x/Makefile b/s390x/Makefile
index 6565561b..3f4acc3e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -71,6 +71,8 @@ cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
+cflatobjs += lib/virtio.o
+cflatobjs += lib/s390x/virtio-ccw.o
 
 OBJDIRS += lib/s390x
 
-- 
2.25.1

