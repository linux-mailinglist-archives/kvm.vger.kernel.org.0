Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000D5257621
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 11:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgHaJKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 05:10:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728184AbgHaJKG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 05:10:06 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07V92ZlD084013;
        Mon, 31 Aug 2020 05:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=wBf/tROChMDuYAXkup8kbfwmTRrmdskmvoEJM16OTSE=;
 b=SwTH0qPNYMUaqOL1A6WqlJGQ1JwVnQkzNxAYYU0GfakZnMCH6kUM0j7PMXjaH+4pDr/E
 asXp5aqFeKGIMQ5GETvibGxTriiSjaOQB9/feRJB0VqQgo+zBxnycYRdMRy2SiXo0QLT
 yUWavtco6MkItv3NlpDlQ1Y+F2iz7bPg2VMDORsFSzcJfAhK2QXReAK7HWmivfaRiTBB
 esVm9EWP1xln+UKMe/7idJ9QrppGytQZOEwN3qH8FKXIUz0zvxhrOtRv/T7K6JZEvsQm
 pEOnt0+ObuhwfQQsLIDFqbZFO8Xf5PtSgdKe7P6pvCQp5zKilfclnENlajKiwm9i8xsL Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 338wgj1akm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 05:09:54 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07V92pkN085113;
        Mon, 31 Aug 2020 05:09:53 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 338wgj1ak3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 05:09:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07V8TI6l007338;
        Mon, 31 Aug 2020 09:09:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 337e9gt05a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 09:09:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07V99nfL28115204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 09:09:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E42F5AE055;
        Mon, 31 Aug 2020 09:09:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36C47AE045;
        Mon, 31 Aug 2020 09:09:48 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.40.55])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 09:09:48 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v10 1/2] virtio: let arch advertise guest's memory access restrictions
Date:   Mon, 31 Aug 2020 11:09:45 +0200
Message-Id: <1598864986-13875-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598864986-13875-1-git-send-email-pmorel@linux.ibm.com>
References: <1598864986-13875-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_01:2020-08-28,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 spamscore=0 clxscore=1015 mlxscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310051
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An architecture may restrict host access to guest memory,
e.g. IBM s390 Secure Execution or AMD SEV.

Provide a new Kconfig entry the architecture can select,
CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS, when it provides
the arch_has_restricted_virtio_memory_access callback to advertise
to VIRTIO common code when the architecture restricts memory access
from the host.

The common code can then fail the probe for any device where
VIRTIO_F_IOMMU_PLATFORM is required, but not set.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/virtio/Kconfig        |  6 ++++++
 drivers/virtio/virtio.c       | 15 +++++++++++++++
 include/linux/virtio_config.h |  9 +++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 5809e5f5b157..9cd1c267c143 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -6,6 +6,12 @@ config VIRTIO
 	  bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_RPMSG
 	  or CONFIG_S390_GUEST.
 
+config ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS
+	bool
+	help
+	  This option is selected if the architecture may need to enforce
+	  VIRTIO_F_IOMMU_PLATFORM.
+
 menuconfig VIRTIO_MENU
 	bool "Virtio drivers"
 	default y
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index a977e32a88f2..57ca41d77b09 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -176,6 +176,21 @@ int virtio_finalize_features(struct virtio_device *dev)
 	if (ret)
 		return ret;
 
+	ret = arch_has_restricted_virtio_memory_access();
+	if (ret) {
+		if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
+			dev_warn(&dev->dev,
+				 "device must provide VIRTIO_F_VERSION_1\n");
+			return -ENODEV;
+		}
+
+		if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
+			dev_warn(&dev->dev,
+				 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
+			return -ENODEV;
+		}
+	}
+
 	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
 		return 0;
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bb4cc4910750..e380664642b4 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -459,4 +459,13 @@ static inline void virtio_cwrite64(struct virtio_device *vdev,
 		_r;							\
 	})
 
+#ifdef CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS
+int arch_has_restricted_virtio_memory_access(void);
+#else
+static inline int arch_has_restricted_virtio_memory_access(void)
+{
+	return 0;
+}
+#endif /* CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS */
+
 #endif /* _LINUX_VIRTIO_CONFIG_H */
-- 
2.25.1

