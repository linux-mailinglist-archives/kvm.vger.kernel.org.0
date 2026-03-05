Return-Path: <kvm+bounces-72815-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHuHKvF1qWl77wAAu9opvQ
	(envelope-from <kvm+bounces-72815-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:24:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C043021190B
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54653315D12D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 12:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC67939E196;
	Thu,  5 Mar 2026 12:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jdM/R0ec"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F93039B964;
	Thu,  5 Mar 2026 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713236; cv=none; b=iVtIgKEVrg+h/Rk08Re5cDBASpENUItFNcsolTsGg9kbvkXyPBUPjIG6mQ192g71MDu7fLw/SwdhVzb2BR6iM14q3bDl5lKlXvuQZmkWRk/O6TGzijDqiswyFT5sUaorubCNa+eURaOEZ2U579mo4xbuUj4R4Aw+dtc+Q28RuLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713236; c=relaxed/simple;
	bh=XFrlnu2RmJSvrucifwgNNILqQ0TiUwZy30HT5cqci4g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s23rUH1WBGP+jn75h6sRqZw6HAak2Y5TWijSKBWbz/yadNUm7aVj97I//Z45tvEAkq/fsMuzaU7L5e6KXjyPYXPK0ehEfzs/D4GJn9qNCACJj4eEa2AU1wcm28DVMTURJcwvTrTiyd2uqolnfKb6n/+9ZQysmvwDj4E1SbH3ELY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jdM/R0ec; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6252bYAo1943382;
	Thu, 5 Mar 2026 12:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IDfS3o
	pUnbwKKUCTALbPCselFPYMIhdkXVl+r0d7A4U=; b=jdM/R0ecsqmaFPtQG/E5d7
	j2lzLvj9qcmQz+MNxCRs8S80lrcIIfPBOjrBsxAX7m17Zggx+HuJA1oJ33/OWo5q
	mCgw3T8Fp43bSEdeZui9nxk0SDlDOl8u4huJOlGv9wGcCUFGrgSOAlApkM2CWzYz
	LBgcPshhFl8KggmGxc6SgfVzRnBloSHXa3flNoQzpDFBL3c/nL0flI/Em0xgxmag
	nYjkNCjG+F+pt3gNToLelL813FjSWqOd09rNclUa8EqHSJa9rpF/J5F+xGUqsssq
	j8NWuQca8ClFVCBgnGgQsWq3Rz0JtzTdqoa7CPXe91ipsixnXl7wd9eMuqTmYnmA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskd3k4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 12:20:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6259XiCQ003243;
	Thu, 5 Mar 2026 12:20:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2ybapc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 12:20:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 625CKNnO51642736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 12:20:23 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22DFE20040;
	Thu,  5 Mar 2026 12:20:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1AA320043;
	Thu,  5 Mar 2026 12:20:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 12:20:22 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Date: Thu, 05 Mar 2026 13:20:14 +0100
Subject: [PATCH v3 2/3] vfio/ism: Implement vfio_pci driver for ISM devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-vfio_pci_ism-v3-2-1217076c81d9@linux.ibm.com>
References: <20260305-vfio_pci_ism-v3-0-1217076c81d9@linux.ibm.com>
In-Reply-To: <20260305-vfio_pci_ism-v3-0-1217076c81d9@linux.ibm.com>
To: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
        oberpar@linux.ibm.com, gbayer@linux.ibm.com,
        Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        julianr@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bkIJfC1Sf5VVt7CHIzADAvRLzkiSwuIF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA5OSBTYWx0ZWRfX7SrKlE+WLYD+
 aZX33Jft9bXOyj2EVGxe83dnzKHpN81SqE/3yGaonrg7Q0TNpCI5Ms66ux/XR0y1Be6Znc/HXfG
 XRDRfblOq61r3PTJP0sFFuPxOvB12rWWrI16tl2dR2maHX8oVwxJzwOTkNSKkOLMUzxDJdPIiXb
 OnNCWEpqFEV67/YWWq7tDyhnSclu0qaxO2b1tIXg3WopRQyF92QjIS+/Ptz53KHhY97I0LaLs+3
 glr3EJvarP/vpL0IMV+cIxIvpUfinyvuAdpSkcFruCCOwc1rBrnt32PbuMgwMjePD0TM+N4t7j3
 VEUqjHCgEds2KifWah8qnPst7rqLTbK/FToFJmw0HivjYUzafxgg3N4jZ4nEdnHRG941AsMFtr1
 3gWQQHvDaBaexyKCvV1c4MNlugIa7XbEiUJUh9N7rexvKxFtF5c6NDpjVQEn9ofmrLkTDoGFvkK
 SJC/2Q9Qtol8O3IARHg==
X-Authority-Analysis: v=2.4 cv=H7DWAuYi c=1 sm=1 tr=0 ts=69a9750c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=Cakb2dha6NNJ7eZIcBAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: bkIJfC1Sf5VVt7CHIzADAvRLzkiSwuIF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050099
X-Rspamd-Queue-Id: C043021190B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-72815-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Add a vfio_pci variant driver for the s390-specific Internal Shared
Memory (ISM) devices used for inter-VM communication.

This enables the development of vfio-pci-based user space drivers for
ISM devices.

On s390, kernel primitives such as ioread() and iowrite() are switched
over from function handle based PCI load/stores instructions to PCI
memory-I/O (MIO) loads/stores when these are available and not
explicitly disabled. Since these instructions cannot be used with ISM
devices, ensure that classic function handle-based PCI instructions are
used instead.

The driver is still required even when MIO instructions are disabled, as
the ISM device relies on the PCI store block (PCISTB) instruction to
perform write operations.

Stores are not fragmented, therefore one ioctl corresponds to exactly
one PCISTB instruction. User space must ensure to not write more than
4096 bytes at once to an ISM BAR which is the maximum payload of the
PCISTB instruction.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig      |   2 +
 drivers/vfio/pci/Makefile     |   2 +
 drivers/vfio/pci/ism/Kconfig  |  10 ++
 drivers/vfio/pci/ism/Makefile |   3 +
 drivers/vfio/pci/ism/main.c   | 343 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 360 insertions(+)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 1e82b44bda1a0a544e1add7f4b06edecf35aaf81..296bf01e185ecacc388ebc69e92706c99e47c814 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -60,6 +60,8 @@ config VFIO_PCI_DMABUF
 
 source "drivers/vfio/pci/mlx5/Kconfig"
 
+source "drivers/vfio/pci/ism/Kconfig"
+
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
 source "drivers/vfio/pci/pds/Kconfig"
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index e0a0757dd1d2b0bc69b7e4d79441d5cacf4e1cd8..6138f1bf241df04e7419f196b404abdf9b194050 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
+obj-$(CONFIG_ISM_VFIO_PCI)           += ism/
+
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
 
 obj-$(CONFIG_PDS_VFIO_PCI) += pds/
diff --git a/drivers/vfio/pci/ism/Kconfig b/drivers/vfio/pci/ism/Kconfig
new file mode 100644
index 0000000000000000000000000000000000000000..02f47d25fed2d34c732b67b3a3655b64a7625467
--- /dev/null
+++ b/drivers/vfio/pci/ism/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+config ISM_VFIO_PCI
+	tristate "VFIO support for ISM devices"
+	depends on S390
+	select VFIO_PCI_CORE
+	help
+	  This provides user space support for IBM Internal Shared Memory (ISM)
+	  Adapter devices using the VFIO framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/ism/Makefile b/drivers/vfio/pci/ism/Makefile
new file mode 100644
index 0000000000000000000000000000000000000000..32cc3c66dd11395da85a2b6f05b3d97036ed8a35
--- /dev/null
+++ b/drivers/vfio/pci/ism/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_ISM_VFIO_PCI) += ism-vfio-pci.o
+ism-vfio-pci-y := main.o
diff --git a/drivers/vfio/pci/ism/main.c b/drivers/vfio/pci/ism/main.c
new file mode 100644
index 0000000000000000000000000000000000000000..54a378140aa3300bd1ff9f6d9c626ef56f6be067
--- /dev/null
+++ b/drivers/vfio/pci/ism/main.c
@@ -0,0 +1,343 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * vfio-ISM driver for s390
+ *
+ * Copyright IBM Corp.
+ */
+
+#include "../vfio_pci_priv.h"
+#include "linux/slab.h"
+
+#define ISM_VFIO_PCI_OFFSET_SHIFT   48
+#define ISM_VFIO_PCI_OFFSET_TO_INDEX(off) (off >> ISM_VFIO_PCI_OFFSET_SHIFT)
+#define ISM_VFIO_PCI_INDEX_TO_OFFSET(index) ((u64)(index) << ISM_VFIO_PCI_OFFSET_SHIFT)
+#define ISM_VFIO_PCI_OFFSET_MASK (((u64)(1) << ISM_VFIO_PCI_OFFSET_SHIFT) - 1)
+
+struct kmem_cache *store_block_cache;
+
+struct ism_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+};
+
+static int ism_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct ism_vfio_pci_core_device *ivdev;
+	struct vfio_pci_core_device *vdev;
+	int ret;
+
+	ivdev = container_of(core_vdev, struct ism_vfio_pci_core_device,
+			     core_device.vdev);
+	vdev = &ivdev->core_device;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+	return 0;
+}
+
+/*
+ * ism_vfio_pci_do_io_r()
+ *
+ * On s390, kernel primitives such as ioread() and iowrite() are switched over
+ * from function handle based PCI load/stores instructions to PCI memory-I/O (MIO)
+ * loads/stores when these are available and not explicitly disabled. Since these
+ * instructions cannot be used with ISM devices, ensure that classic function
+ * handle-based PCI instructions are used instead.
+ */
+static ssize_t ism_vfio_pci_do_io_r(struct vfio_pci_core_device *vdev,
+				    char __user *buf, loff_t off, size_t count,
+				    int bar)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	ssize_t ret, done = 0;
+	u64 req, length, tmp;
+
+	while (count) {
+		if (count >= 8 && IS_ALIGNED(off, 8))
+			length = 8;
+		else if (count >= 4 && IS_ALIGNED(off, 4))
+			length = 4;
+		else if (count >= 2 && IS_ALIGNED(off, 2))
+			length = 2;
+		else
+			length = 1;
+		req = ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, length);
+		/*
+		 * Use __zpci_load() to bypass automatic use of PCI MIO instructions
+		 * which are not supported on ISM devices
+		 */
+		ret = __zpci_load(&tmp, req, off);
+		if (ret)
+			return ret;
+		if (copy_to_user(buf, &tmp, length))
+			return -EFAULT;
+		count -= length;
+		done += length;
+		off += length;
+		buf += length;
+	}
+	return done;
+}
+
+/*
+ * ism_vfio_pci_do_io_w()
+ *
+ * Ensure that the PCI store block (PCISTB) instruction is used as required by the
+ * ISM device. The ISM device also uses a 256 TiB BAR 0 for write operations,
+ * which requires a 48bit region address space (ISM_VFIO_PCI_OFFSET_SHIFT).
+ */
+static ssize_t ism_vfio_pci_do_io_w(struct vfio_pci_core_device *vdev,
+				    char __user *buf, loff_t off, size_t count,
+				    int bar)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	ssize_t ret;
+	void *data;
+	u64 req;
+
+	if (count > zdev->maxstbl)
+		return -EINVAL;
+	if (((off % PAGE_SIZE) + count) > PAGE_SIZE)
+		return -EINVAL;
+
+	data = kmem_cache_zalloc(store_block_cache, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	req = ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, count);
+	ret = __zpci_store_block(data, req, off);
+	if (ret)
+		goto out_free;
+
+	ret = count;
+
+out_free:
+	kmem_cache_free(store_block_cache, data);
+	return ret;
+}
+
+static ssize_t ism_vfio_pci_bar_rw(struct vfio_pci_core_device *vdev,
+				   char __user *buf, size_t count, loff_t *ppos,
+				   bool iswrite)
+{
+	int bar = ISM_VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & ISM_VFIO_PCI_OFFSET_MASK;
+	resource_size_t end;
+	ssize_t done = 0;
+
+	if (pci_resource_start(vdev->pdev, bar))
+		end = pci_resource_len(vdev->pdev, bar);
+	else
+		return -EINVAL;
+
+	if (pos >= end)
+		return -EINVAL;
+
+	count = min(count, (size_t)(end - pos));
+
+	if (iswrite)
+		done = ism_vfio_pci_do_io_w(vdev, buf, pos, count, bar);
+	else
+		done = ism_vfio_pci_do_io_r(vdev, buf, pos, count, bar);
+
+	if (done >= 0)
+		*ppos += done;
+
+	return done;
+}
+
+static ssize_t ism_vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite)
+{
+	loff_t pos = *ppos;
+	size_t done = 0;
+	int ret = 0;
+
+	pos &= ISM_VFIO_PCI_OFFSET_MASK;
+
+	while (count) {
+		/*
+		 * zPCI must not use MIO instructions for config space access,
+		 * so we can use common code path here.
+		 */
+		ret = vfio_pci_config_rw_single(vdev, buf, count, &pos, iswrite);
+		if (ret < 0)
+			return ret;
+
+		count -= ret;
+		done += ret;
+		buf += ret;
+		pos += ret;
+	}
+
+	*ppos += done;
+
+	return done;
+}
+
+static ssize_t ism_vfio_pci_rw(struct vfio_device *core_vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int index = ISM_VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct vfio_pci_core_device *vdev;
+	int ret;
+
+	vdev = container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	if (!count)
+		return 0;
+
+	switch (index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		ret = ism_vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
+		break;
+
+	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+		ret = ism_vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static ssize_t ism_vfio_pci_read(struct vfio_device *core_vdev,
+				 char __user *buf, size_t count, loff_t *ppos)
+{
+	return ism_vfio_pci_rw(core_vdev, buf, count, ppos, false);
+}
+
+static ssize_t ism_vfio_pci_write(struct vfio_device *core_vdev,
+				  const char __user *buf, size_t count,
+				  loff_t *ppos)
+{
+	return ism_vfio_pci_rw(core_vdev, (char __user *)buf, count, ppos,
+			       true);
+}
+
+static int ism_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
+					      struct vfio_region_info *info,
+					      struct vfio_info_cap *caps)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+
+	switch (info->index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		info->offset = ISM_VFIO_PCI_INDEX_TO_OFFSET(info->index);
+		info->size = pdev->cfg_size;
+		info->flags = VFIO_REGION_INFO_FLAG_READ |
+			      VFIO_REGION_INFO_FLAG_WRITE;
+		break;
+	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+		info->offset = ISM_VFIO_PCI_INDEX_TO_OFFSET(info->index);
+		info->size = pci_resource_len(pdev, info->index);
+		if (!info->size) {
+			info->flags = 0;
+			break;
+		}
+		info->flags = VFIO_REGION_INFO_FLAG_READ |
+			      VFIO_REGION_INFO_FLAG_WRITE;
+		break;
+	default:
+		info->offset = 0;
+		info->size = 0;
+		info->flags = 0;
+	}
+	return 0;
+}
+
+static const struct vfio_device_ops ism_pci_ops = {
+	.name = "ism-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = ism_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.get_region_info_caps = ism_vfio_pci_ioctl_get_region_info,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = ism_vfio_pci_read,
+	.write = ism_vfio_pci_write,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
+};
+
+static int ism_vfio_pci_probe(struct pci_dev *pdev,
+			      const struct pci_device_id *id)
+{
+	struct ism_vfio_pci_core_device *ivpcd;
+	struct zpci_dev *zdev = to_zpci(pdev);
+	int ret;
+
+	ivpcd = vfio_alloc_device(ism_vfio_pci_core_device, core_device.vdev,
+				  &pdev->dev, &ism_pci_ops);
+	if (IS_ERR(ivpcd))
+		return PTR_ERR(ivpcd);
+
+	store_block_cache = kmem_cache_create("store_block_cache",
+					      zdev->maxstbl, 0, 0, NULL);
+	if (!store_block_cache)
+		return -ENOMEM;
+
+	dev_set_drvdata(&pdev->dev, &ivpcd->core_device);
+	ret = vfio_pci_core_register_device(&ivpcd->core_device);
+	if (ret) {
+		kmem_cache_destroy(store_block_cache);
+		vfio_put_device(&ivpcd->core_device.vdev);
+	}
+
+	return ret;
+}
+
+static void ism_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device;
+	struct ism_vfio_pci_core_device *ivpcd;
+
+	core_device = dev_get_drvdata(&pdev->dev);
+	ivpcd = container_of(core_device, struct ism_vfio_pci_core_device,
+			     core_device);
+
+	vfio_pci_core_unregister_device(&ivpcd->core_device);
+	vfio_put_device(&ivpcd->core_device.vdev);
+
+	kmem_cache_destroy(store_block_cache);
+}
+
+static const struct pci_device_id ism_device_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_IBM,
+					  PCI_DEVICE_ID_IBM_ISM) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, ism_device_table);
+
+static struct pci_driver ism_vfio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = ism_device_table,
+	.probe = ism_vfio_pci_probe,
+	.remove = ism_vfio_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(ism_vfio_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("vfio-pci variant driver for the IBM Internal Shared Memory (ISM) device");
+MODULE_AUTHOR("IBM Corporation");

-- 
2.51.0


