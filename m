Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C375A53BD3D
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiFBRUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbiFBRUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9929020E53C;
        Thu,  2 Jun 2022 10:19:59 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252HF9d5020405;
        Thu, 2 Jun 2022 17:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eW4behg5yMBx/dA8vpQszAf3fakidiDQS1Cjf/e64KY=;
 b=T8DkcOLZg8RWMvmcCCmCU0NRvpsmVnPCglAB7NCAWgEFW+Rg5/uwAHdsko31HsLWHzgq
 WeEY7MS2FDKS+b4BiVv4yGWx/ni3u9HD1eevlFfeIvDBTLFtoQFE57J5g3sYbumyBseD
 3XgTb9isi6+HWIdxOtARP8HpYt/z1+/Ay0b1/2AhHhmWA65yQcXKpPnJsdPQrjNvMQcX
 5GdRmKlFnpiK/CenpmO1y4rLjUUCSXBcK+ybMzsMEquHsRvlz5FSuvCPNSrudzHtb/Ze
 OUJZjt+GcIJc4G9tGFJoDbvOoglHM/sBpE598lHHKbwllPJjhjE/J8bD8kcdTXoYrOh1 CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gew2c5tr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:57 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252GeRaA018230;
        Thu, 2 Jun 2022 17:19:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gew2c5tqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H73eV017409;
        Thu, 2 Jun 2022 17:19:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3gbcc6dkej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJpYL45744532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 069E911C052;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E850611C04C;
        Thu,  2 Jun 2022 17:19:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jun 2022 17:19:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id AE9B1E08C0; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 02/18] vfio/ccw: Fix FSM state if mdev probe fails
Date:   Thu,  2 Jun 2022 19:19:32 +0200
Message-Id: <20220602171948.2790690-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ALhypan1d4t2tzBLUMaVX1Za9ie_p2Gf
X-Proofpoint-ORIG-GUID: X5qMBHdo6p25Dp9K24IAI0PsYneMbike
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=841 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The FSM is in STANDBY state when arriving in vfio_ccw_mdev_probe(),
and this routine converts it to IDLE as part of its processing.
The error exit sets it to IDLE (again) but clears the private->mdev
pointer.

The FSM should of course be managing the state itself, but the
correct thing for vfio_ccw_mdev_probe() to do would be to put
the state back the way it found it.

The corresponding check of private->mdev in vfio_ccw_sch_io_todo()
can be removed, since the distinction is unnecessary at this point.

Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 drivers/s390/cio/vfio_ccw_ops.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 35055eb94115..b18b4582bc8b 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -108,7 +108,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	 * has finished. Do not overwrite a possible processing
 	 * state if the final interrupt was for HSCH or CSCH.
 	 */
-	if (private->mdev && cp_is_finished)
+	if (cp_is_finished)
 		private->state = VFIO_CCW_STATE_IDLE;
 
 	if (private->io_trigger)
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index bebae21228aa..a403d059a4e6 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -146,7 +146,7 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	vfio_uninit_group_dev(&private->vdev);
 	atomic_inc(&private->avail);
 	private->mdev = NULL;
-	private->state = VFIO_CCW_STATE_IDLE;
+	private->state = VFIO_CCW_STATE_STANDBY;
 	return ret;
 }
 
-- 
2.32.0

