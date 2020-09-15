Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6126AD85
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgIOT0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:26:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727987AbgIOTPO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 15:15:14 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FJ3sXg020021;
        Tue, 15 Sep 2020 15:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=TRMSjIEPimcCRJtq8iscjWI+bZUem/C2Up3K9tOIwoc=;
 b=NoqdZB+MUfu06qlfiO+9JORxYKw63JfGpTNfE/n+MIXz10UBUGoHsn6Uu3IqKn9SDTxH
 tFiAzOYARIyK/rZVbEot+7kv/8Vf43oQAXCH5VHrdM9L1PnZhkEwH3ms36asp550moLo
 MkO3rZEfX98/1RzMxvt5P+IsgTzGsvXNz6KYgnTR5KX+9f2XG70s+OzQ4x6FlkpvKDzi
 2Ji4PHUwioM+5a0U7vH1YuBggad9p01JMv10Lrdv8TGHq/8d6Hr3e8XyrQWkvTfm9jj8
 bnbAgmqDqu758M59RpKSJKJunCbGud5En1MelAfLiSO8LSAaByfj1txWBX7v6C3bRgsQ Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k3bkgcsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:15:02 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08FJ3ruJ019990;
        Tue, 15 Sep 2020 15:15:02 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k3bkgcs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:15:02 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FJ8YL5024823;
        Tue, 15 Sep 2020 19:15:00 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 33gny984jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 19:15:00 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FJF0Y756623468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 19:15:00 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05722112062;
        Tue, 15 Sep 2020 19:15:00 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE661112061;
        Tue, 15 Sep 2020 19:14:57 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 19:14:57 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, thuth@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v3 3/5] vfio: Find DMA available capability
Date:   Tue, 15 Sep 2020 15:14:41 -0400
Message-Id: <1600197283-25274-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_13:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 mlxlogscore=836 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The underlying host may be limiting the number of outstanding DMA
requests for type 1 IOMMU.  Add helper functions to check for the
DMA available capability and retrieve the current number of DMA
mappings allowed.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/vfio/common.c              | 31 +++++++++++++++++++++++++++++++
 include/hw/vfio/vfio-common.h |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index eba7b55..50779f9 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -849,6 +849,37 @@ vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
     return vfio_get_cap((void *)info, info->cap_offset, id);
 }
 
+static struct vfio_info_cap_header *
+vfio_get_iommu_type1_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
+{
+    if (!(info->flags & VFIO_IOMMU_INFO_CAPS)) {
+        return NULL;
+    }
+
+    return vfio_get_cap((void *)info, info->cap_offset, id);
+}
+
+bool vfio_get_info_dma_avail(struct vfio_iommu_type1_info *info,
+                             unsigned int *avail)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_iommu_type1_info_dma_avail *cap;
+
+    /* If the capability cannot be found, assume no DMA limiting */
+    hdr = vfio_get_iommu_type1_info_cap(info,
+                                        VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL);
+    if (hdr == NULL) {
+        return false;
+    }
+
+    if (avail != NULL) {
+        cap = (void *) hdr;
+        *avail = cap->avail;
+    }
+
+    return true;
+}
+
 static int vfio_setup_region_sparse_mmaps(VFIORegion *region,
                                           struct vfio_region_info *info)
 {
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index c78f3ff..661a380 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -178,6 +178,8 @@ VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp);
 void vfio_put_group(VFIOGroup *group);
 int vfio_get_device(VFIOGroup *group, const char *name,
                     VFIODevice *vbasedev, Error **errp);
+bool vfio_get_info_dma_avail(struct vfio_iommu_type1_info *info,
+                             unsigned int *avail);
 
 extern const MemoryRegionOps vfio_region_ops;
 typedef QLIST_HEAD(VFIOGroupList, VFIOGroup) VFIOGroupList;
-- 
1.8.3.1

