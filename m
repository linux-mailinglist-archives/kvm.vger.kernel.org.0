Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64A926DE93
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 16:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgIQOny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 10:43:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49768 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727393AbgIQOdf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 10:33:35 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HE2ZFU069209;
        Thu, 17 Sep 2020 10:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1gi5s1Tx693BWL7xgcm3etVQVG7BMtLGNWjUnVDwD3o=;
 b=O1HJA8DqrhVIqXDjLtDS1hsaS0WzuyUUUxkxuvMmYmQ+Swrm/4ZNbpNuWLR0STmyiH/8
 vrtBG1pY5dusGnDLZr29vMrYTLuWMBlxGea8R26GelOtj0skMGLNaeEc9V5pXFddMq+G
 YKWIQYuJ3edsE/V4NTKbiq1U+tJRhTsXmWqOvrBLLzj42y/t4NqkUVGP/TSMDt7kZ6iO
 5UOgcmGGYpkm/33zoUSnPZxQqVSfKZEayV/zzEc992jeKcb9+NkHqu1mPp2cU9Sw0OBb
 wqw29C0YqaoSmmvLH3Q9YzUQUthJo9hgY2UCrJNSwe3nq1k8tzC/b0PudoQZkyCNDoNc 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m95arprt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 10:21:03 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HE3N8x074254;
        Thu, 17 Sep 2020 10:21:03 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m95arprg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 10:21:03 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HEILAF017892;
        Thu, 17 Sep 2020 14:21:02 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 33k6591uwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 14:21:02 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HEL1sD46268810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 14:21:01 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AB01AC05E;
        Thu, 17 Sep 2020 14:21:01 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EC7EAC059;
        Thu, 17 Sep 2020 14:20:57 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 14:20:57 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, thuth@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 2/5] vfio: Create shared routine for scanning info capabilities
Date:   Thu, 17 Sep 2020 10:20:42 -0400
Message-Id: <1600352445-21110-3-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_09:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than duplicating the same loop in multiple locations,
create a static function to do the work.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/vfio/common.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 13471ae..e47a4d7 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -825,17 +825,12 @@ static void vfio_listener_release(VFIOContainer *container)
     }
 }
 
-struct vfio_info_cap_header *
-vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
+static struct vfio_info_cap_header *
+vfio_get_cap(void *ptr, uint32_t cap_offset, uint16_t id)
 {
     struct vfio_info_cap_header *hdr;
-    void *ptr = info;
-
-    if (!(info->flags & VFIO_REGION_INFO_FLAG_CAPS)) {
-        return NULL;
-    }
 
-    for (hdr = ptr + info->cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
+    for (hdr = ptr + cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
         if (hdr->id == id) {
             return hdr;
         }
@@ -844,6 +839,16 @@ vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
     return NULL;
 }
 
+struct vfio_info_cap_header *
+vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
+{
+    if (!(info->flags & VFIO_REGION_INFO_FLAG_CAPS)) {
+        return NULL;
+    }
+
+    return vfio_get_cap((void *)info, info->cap_offset, id);
+}
+
 static int vfio_setup_region_sparse_mmaps(VFIORegion *region,
                                           struct vfio_region_info *info)
 {
-- 
1.8.3.1

