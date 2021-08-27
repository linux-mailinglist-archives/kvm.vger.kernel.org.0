Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D098B3F9806
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244944AbhH0KSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9282 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244893AbhH0KSS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA3k79015398
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=e/TFctog32ZuAw/9ZFT3YqSS8y99KOD43Gkj0ce7l2U=;
 b=r6L9wwG8SM+LHaN6uhBFRnrJuhpoLhiU1SFhSlX2ke0zzHCr2lSe8i0U5PtwJ611kEVD
 KQEFW1kPIsdDYG9jeGIPYCB8LMqkZe2P7i3kE7q/c3uarwaNtanQnOeq2s72IXb0Yq7D
 jawsSLO4NZcmUpEJi5xuqxLeiHOROvSyKAiGj/XsDstx1HUDeu8jPdyF1Df3gzPbxxcT
 arvTY8cubkKZzMVg5+LF7RRx5YqElN1aOyiblVNxM0942oqaLHoX/T2WckmXXWDJj4kD
 aD39+V6z8N16hzwpXaL4P/RVhOTMsu8AsKVZkOq7Ab8LJzgk5PWDSvorr8DtkoNt1adW dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apws50n2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RABFC4057206
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apws50n1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:29 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAD1Kg001860;
        Fri, 27 Aug 2021 10:17:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3ajs48henc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHNxs30212426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE60C4C04A;
        Fri, 27 Aug 2021 10:17:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88AAE4C046;
        Fri, 27 Aug 2021 10:17:23 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:23 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 7/7] s390x: virtio data transfer
Date:   Fri, 27 Aug 2021 12:17:20 +0200
Message-Id: <1630059440-15586-8-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QjccHXVGbIsylpDzqPCkfZgi9pzfRdkp
X-Proofpoint-ORIG-GUID: EqEsT62DNVjMT4-FaXq8A2Y9MJrDnLz6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We use a test device, "PONG" to transfer chunks of data of different
size and alignment and compare a checksum calculated before the sending
with the VIRTIO device checksum response.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/virtio_pong.c | 107 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/s390x/virtio_pong.c b/s390x/virtio_pong.c
index 1e050a4d..94d6acdc 100644
--- a/s390x/virtio_pong.c
+++ b/s390x/virtio_pong.c
@@ -39,6 +39,112 @@ static struct virtio_ccw_device *vcdev;
 static struct virtqueue *out_vq;
 static struct virtqueue *in_vq;
 
+static bool virtio_read(struct virtqueue *q, char **buf, unsigned int *len)
+{
+	int ret;
+	char *p;
+
+	ret = virtqueue_add_inbuf(q, *buf, *len);
+	if (ret < 0)
+		return false;
+
+	disable_io_irq();
+	virtqueue_kick(q);
+	wait_for_interrupt(PSW_MASK_IO);
+
+	do {
+		p = virtqueue_get_buf(q, len);
+	} while (!p);
+
+	*buf = (void *)p;
+
+	return true;
+}
+
+static bool virtio_write(struct virtqueue *q, char *buf, unsigned int len)
+{
+	int ret;
+
+	ret = virtqueue_add_outbuf(q, buf, len);
+	if (ret < 0)
+		return false;
+
+	virtqueue_kick(q);
+	while (!virtqueue_get_buf(q, &len))
+		;
+
+	return true;
+}
+
+static unsigned int simple_checksum(char *buf, unsigned int len)
+{
+	unsigned int sum = 0;
+
+	while (len--) {
+		sum += *buf * *buf + 7 * *buf + 3;
+		buf++;
+	}
+
+	return sum;
+}
+
+static void pong_write(char *buf, unsigned int len)
+{
+	unsigned int cksum;
+	unsigned int cksum_ret;
+	char *ret_ptr = (char *)&cksum_ret;
+
+	cksum = simple_checksum(buf, len);
+	report(virtio_write(out_vq, buf, len), "Sending data: %08x", cksum);
+
+	len = sizeof(cksum_ret);
+	report(virtio_read(in_vq, &ret_ptr, &len),
+	       "Receiving checksum: %08x", cksum_ret);
+
+	report(cksum == cksum_ret, "Verifying checksum");
+}
+
+static struct {
+	const char *name;
+	int size;
+	int offset;
+} chunks[] = {
+	{ "Small buffer", 3, 0 },
+	{ "Page aligned", 4096, 0 },
+	{ "Large page aligned", 0x00100000, 0 },
+	{ "Page unaligned", 4096, 0x107 },
+	{ "Random data", 5119, 0x107 },
+	{ NULL, 0, 0 }
+};
+
+static void test_pong_data(void)
+{
+	char *buf;
+	char *p;
+	int len;
+	int i;
+
+	if (vcdev->state != VCDEV_INIT) {
+		report_skip("Device non initialized");
+		return;
+	}
+
+	for (i = 0; chunks[i].name; i++) {
+		report_prefix_push(chunks[i].name);
+
+		len = chunks[i].size + chunks[i].offset;
+		buf = alloc_io_mem(len, 0);
+
+		p = buf + chunks[i].offset;
+		memset(p, 0xA5, chunks[i].size);
+		pong_write(p, chunks[i].size);
+
+		free_io_mem(buf, len);
+
+		report_prefix_pop();
+	}
+}
+
 static void test_find_vqs(void)
 {
 	struct virtio_device *vdev = &vcdev->vdev;
@@ -186,6 +292,7 @@ static struct {
 	{ "CCW Bus", test_virtio_ccw_bus },
 	{ "CCW Device", test_virtio_device_init },
 	{ "Queues setup", test_find_vqs },
+	{ "Data transfer", test_pong_data },
 	{ NULL, NULL }
 };
 
-- 
2.25.1

