Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811BF242F14
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 21:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHLTVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 15:21:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgHLTVY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 15:21:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CJ7cf1102659;
        Wed, 12 Aug 2020 15:21:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=enACx+8V/NyPPGSVz771wzSV3YvsTDMU6YtG7K9pLkY=;
 b=Umr09MISMUYe4OKfL+/Z4+rzGP/2acwSoJ9/hDxEPXevBB4FW3+BrpFCXwglnqzJ+6vC
 VrXS2HxkH2Uec/lL48F3xm32XzlCxQ1ILczUYpJuMsM6foLCYdmJmrw8d4dH7fuh931Y
 2ptkTUyHAjHkTiOskxzs86ZAjG2aybWqH/XjHvM2Mu7r1j0Dv8MBKk9BlloDRLQcTObU
 MXR3BlXewuw5C0JvtOEy79+YIjho8sMieqAatPgP+W65HOOtXhqZHJGQX4tT/twqAlu/
 rk9/1chhjDGIHdQScl7fesnw/AthUW2QwAv4amhyqvSHzttGnvs6KO8OHqA8fdJTQ9Pz OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7v0fmq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 15:21:19 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07CJAC4P111835;
        Wed, 12 Aug 2020 15:21:18 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7v0fmpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 15:21:18 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07CJ5xH6029333;
        Wed, 12 Aug 2020 19:21:18 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 32skp9by9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 19:21:17 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07CJLEur29098742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:21:14 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 925206A04D;
        Wed, 12 Aug 2020 19:21:16 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7950E6A047;
        Wed, 12 Aug 2020 19:21:15 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 12 Aug 2020 19:21:15 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2] PCI: Introduce flag for detached virtual functions
Date:   Wed, 12 Aug 2020 15:21:11 -0400
Message-Id: <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_15:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390x has the notion of providing VFs to the kernel in a manner
where the associated PF is inaccessible other than via firmware.
These are not treated as typical VFs and access to them is emulated
by underlying firmware which can still access the PF.  After
abafbc55 however these detached VFs were no longer able to work
with vfio-pci as the firmware does not provide emulation of the
PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
these detached VFs so that vfio-pci can allow memory access to
them again.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/pci/pci.c                |  8 ++++++++
 drivers/vfio/pci/vfio_pci_config.c | 11 +++++++----
 include/linux/pci.h                |  1 +
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 3902c9f..04ac76d 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
 
+	/*
+	 * If we have a VF on a non-multifunction bus, it must be a VF that is
+	 * detached from its parent PF.  We rely on firmware emulation to
+	 * provide underlying PF details.
+	 */
+	if (zdev->vfn && !zdev->zbus->multifunction)
+		pdev->detached_vf = 1;
+
 	zpci_debug_init_device(zdev, dev_name(&pdev->dev));
 	zpci_fmb_enable_device(zdev);
 
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d98843f..ee45216 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -406,7 +406,8 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
+	return pdev->is_virtfn || pdev->detached_vf ||
+	       (cmd & PCI_COMMAND_MEMORY);
 }
 
 /*
@@ -420,7 +421,7 @@ static void vfio_bar_restore(struct vfio_pci_device *vdev)
 	u16 cmd;
 	int i;
 
-	if (pdev->is_virtfn)
+	if (pdev->is_virtfn || pdev->detached_vf)
 		return;
 
 	pci_info(pdev, "%s: reset recovery - restoring BARs\n", __func__);
@@ -521,7 +522,8 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
 
 	/* Mask in virtual memory enable for SR-IOV devices */
-	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
+	if ((offset == PCI_COMMAND) &&
+	    (vdev->pdev->is_virtfn || vdev->pdev->detached_vf)) {
 		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 		u32 tmp_val = le32_to_cpu(*val);
 
@@ -1734,7 +1736,8 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 				 vconfig[PCI_INTERRUPT_PIN]);
 
 		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
-
+	}
+	if (pdev->is_virtfn || pdev->detached_vf) {
 		/*
 		 * VFs do no implement the memory enable bit of the COMMAND
 		 * register therefore we'll not have it set in our initial
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8355306..23a6972 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -445,6 +445,7 @@ struct pci_dev {
 	unsigned int	is_probed:1;		/* Device probing in progress */
 	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
 	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
+	unsigned int	detached_vf:1;		/* VF without local PF access */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
-- 
1.8.3.1

