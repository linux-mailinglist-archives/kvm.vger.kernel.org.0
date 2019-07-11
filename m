Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636FA658DF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbfGKO3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:29:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728713AbfGKO3C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 10:29:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BESuDB081826
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:29:01 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp5w9txub-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:29:01 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Thu, 11 Jul 2019 15:28:59 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 15:28:57 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BESvln54198782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:28:57 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB5BBAC05B;
        Thu, 11 Jul 2019 14:28:56 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2D6FAC05F;
        Thu, 11 Jul 2019 14:28:56 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.ibm.com (unknown [9.85.180.152])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu, 11 Jul 2019 14:28:56 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [PATCH v3 5/5] vfio-ccw: Update documentation for csch/hsch
Date:   Thu, 11 Jul 2019 10:28:55 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1562854091.git.alifm@linux.ibm.com>
References: <cover.1562854091.git.alifm@linux.ibm.com>
In-Reply-To: <cover.1562854091.git.alifm@linux.ibm.com>
References: <cover.1562854091.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19071114-0072-0000-0000-000004479796
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011408; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01230659; UDB=6.00648232; IPR=6.01011935;
 MB=3.00027679; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-11 14:28:58
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071114-0073-0000-0000-00004CB7DC1B
Message-Id: <7d977612c3f3152ffb950d77ae11b4b25c1e20c4.1562854091.git.alifm@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=976 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We now support CLEAR SUBCHANNEL and HALT SUBCHANNEL
via ccw_cmd_region.

Fixes: d5afd5d135c8 ("vfio-ccw: add handling for async channel instructions")
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 Documentation/s390/vfio-ccw.rst | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index 1f6d0b5..be2af10 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -180,6 +180,13 @@ The process of how these work together.
    add it to an iommu_group and a vfio_group. Then we could pass through
    the mdev to a guest.
 
+
+VFIO-CCW Regions
+----------------
+
+The vfio-ccw driver exposes MMIO regions to accept requests from and return
+results to userspace.
+
 vfio-ccw I/O region
 -------------------
 
@@ -205,6 +212,25 @@ irb_area stores the I/O result.
 
 ret_code stores a return code for each access of the region.
 
+This region is always available.
+
+vfio-ccw cmd region
+-------------------
+
+The vfio-ccw cmd region is used to accept asynchronous instructions
+from userspace.
+
+#define VFIO_CCW_ASYNC_CMD_HSCH (1 << 0)
+#define VFIO_CCW_ASYNC_CMD_CSCH (1 << 1)
+struct ccw_cmd_region {
+       __u32 command;
+       __u32 ret_code;
+} __packed;
+
+This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
+
+Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
+
 vfio-ccw operation details
 --------------------------
 
@@ -306,9 +332,8 @@ Together with the corresponding work in QEMU, we can bring the passed
 through DASD/ECKD device online in a guest now and use it as a block
 device.
 
-While the current code allows the guest to start channel programs via
-START SUBCHANNEL, support for HALT SUBCHANNEL or CLEAR SUBCHANNEL is
-not yet implemented.
+The current code allows the guest to start channel programs via
+START SUBCHANNEL, and to issue HALT SUBCHANNEL and CLEAR SUBCHANNEL.
 
 vfio-ccw supports classic (command mode) channel I/O only. Transport
 mode (HPF) is not supported.
-- 
2.7.4

