Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC39248891
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgHRPBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:01:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727785AbgHRPB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 11:01:28 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IExsJD182519;
        Tue, 18 Aug 2020 11:01:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jAGAWAiA+qX2oUU185JNI/grfCFzmYtLys7ctYgoqNs=;
 b=AyuxvaH6OxcDtqlBtc6b1xCIbb+4/VwXoPWWxiaMqIzctdAg5Vairb2td0PJdUE617c/
 CuYIY+U9GzxjtrQd++H4wjO0kOxntwa9N9Lvzre9mnBt9DiKNcxFYWNflu8S2J/Zu7cJ
 CKLQ7qsaj4lcjdyfjSY8JiwxI6z+c7YnhZ7DxbL26hONo5yolI8zmrJLRCePBtQkaSlv
 0eJHM35U3Hk50cgyJDLW+gJS3qMYn2ZPXPMgZyXuBKol2cb2PlN6ASkzJLgmnYemmcRb
 wMCxWxybLbqG2r8zQW4LvO0mkyKkurzCvQW1TjK6Y0SfCY1fkj5iH+dKcRtfQ+yaTQfK jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304rtb0t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 11:00:52 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07IF09k3183085;
        Tue, 18 Aug 2020 11:00:39 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304rtayv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 11:00:37 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07IEqHR1004913;
        Tue, 18 Aug 2020 14:58:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3304bt0sp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 14:58:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07IEwYxH22610236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 14:58:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 099CD4203F;
        Tue, 18 Aug 2020 14:58:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AA5D42042;
        Tue, 18 Aug 2020 14:58:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.154])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 14:58:33 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v8 1/2] virtio: let arch validate VIRTIO features
Date:   Tue, 18 Aug 2020 16:58:30 +0200
Message-Id: <1597762711-3550-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1597762711-3550-1-git-send-email-pmorel@linux.ibm.com>
References: <1597762711-3550-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_10:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=1 phishscore=0 spamscore=0
 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An architecture may need to validate the VIRTIO devices features
based on architecture specifics.

Provide a new Kconfig entry, CONFIG_ARCH_HAS_RESTRICTED_MEMORY_ACCESS,
the architecture can select when it provides a callback named
arch_has_restricted_memory_access to validate the virtio device
features.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/virtio/Kconfig        | 6 ++++++
 drivers/virtio/virtio.c       | 4 ++++
 include/linux/virtio_config.h | 9 +++++++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 5809e5f5b157..eef09e3c92f9 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -6,6 +6,12 @@ config VIRTIO
 	  bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_RPMSG
 	  or CONFIG_S390_GUEST.
 
+config ARCH_HAS_RESTRICTED_MEMORY_ACCESS
+	bool
+	help
+	  This option is selected by any architecture enforcing
+	  VIRTIO_F_IOMMU_PLATFORM
+
 menuconfig VIRTIO_MENU
 	bool "Virtio drivers"
 	default y
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index a977e32a88f2..1471db7d6510 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -176,6 +176,10 @@ int virtio_finalize_features(struct virtio_device *dev)
 	if (ret)
 		return ret;
 
+	ret = arch_has_restricted_memory_access(dev);
+	if (ret)
+		return ret;
+
 	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
 		return 0;
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bb4cc4910750..f6b82541c497 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -459,4 +459,13 @@ static inline void virtio_cwrite64(struct virtio_device *vdev,
 		_r;							\
 	})
 
+#ifdef CONFIG_ARCH_HAS_RESTRICTED_MEMORY_ACCESS
+int arch_has_restricted_memory_access(struct virtio_device *dev);
+#else
+static inline int arch_has_restricted_memory_access(struct virtio_device *dev)
+{
+	return 0;
+}
+#endif /* CONFIG_ARCH_HAS_RESTRICTED_MEMORY_ACCESS */
+
 #endif /* _LINUX_VIRTIO_CONFIG_H */
-- 
2.25.1

