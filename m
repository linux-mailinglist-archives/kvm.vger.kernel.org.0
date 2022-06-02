Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B185353BD40
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiFBRUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiFBRUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A54120E539;
        Thu,  2 Jun 2022 10:19:59 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252HFdlH014196;
        Thu, 2 Jun 2022 17:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fyNrlsYBumoxIoVV778W0Xfzz+RJvpgezKIh2+TYMkw=;
 b=C/40PPqZo90+sEkrM2bozOrsTjhqZA8r2vgrGs80QArIuzLiJ3aTscpsP0IysFpIlPK5
 xshObD8R7hIJ3X8jdqn1k8gUY90hhIWMALM5vzvpafua3daH/cTR7iFAFI5KOuPMgQwd
 VTdzZiuj3VTpRQjh4PD5xdRcyLQ9VkWN1GbIrZF1PidbB8Hp+Kh6FlQLzbAXi+VxJ4+H
 3oj27gg/W3S7tTebuGNB1yzEYh8+IAY+asCHfaBtCm4zoswAVW/+ebB1B8pXOyOjIhDm
 LNSdW8l2MFodqFK9+NeuFDR6ohkgLjMSLl0sTBKQBbZiePyMSX5kF5wkLD1xyqxKiBXf fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevb9xqma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:57 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252HJvwi022565;
        Thu, 2 Jun 2022 17:19:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevb9xqks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H5TKh020814;
        Thu, 2 Jun 2022 17:19:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3gbcae7bct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJpgI44630368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92BF3AE04D;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80C2DAE045;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id D9715E136E; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 18/18] vfio/ccw: Manage ccw/mdev reference counts
Date:   Thu,  2 Jun 2022 19:19:48 +0200
Message-Id: <20220602171948.2790690-19-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pmi_b55aTBAXet2YvKnz4aEZQQcttR5V
X-Proofpoint-ORIG-GUID: EsRCIOxVOi4J5PQ2Q9oGFiD3fWQD3Pq3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=862 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take a reference to the vfio device when looking at the
corresponding vfio_ccw_private struct, and put it back
once we are finished.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 9 ++++++++-
 drivers/s390/cio/vfio_ccw_private.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index c8cbbad6e1c5..2e55fa45f76c 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -71,6 +71,7 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 		ret = cio_disable_subchannel(sch);
 	} while (ret == -EBUSY);
 
+	vfio_device_put(&private->vdev);
 	return ret;
 }
 
@@ -131,6 +132,7 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 
 	inc_irq_stat(IRQIO_CIO);
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
+	vfio_device_put(&private->vdev);
 }
 
 struct vfio_ccw_private *vfio_ccw_alloc_private(struct mdev_device *mdev,
@@ -252,6 +254,7 @@ static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
+	vfio_device_put(&private->vdev);
 }
 
 /**
@@ -287,6 +290,7 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 
 out_unlock:
 	spin_unlock_irqrestore(sch->lock, flags);
+	vfio_device_put(&private->vdev);
 
 	return rc;
 }
@@ -334,8 +338,10 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 			   sch->schid.ssid, sch->schid.sch_no,
 			   mask, event);
 
-	if (cio_update_schib(sch))
+	if (cio_update_schib(sch)) {
+		vfio_device_put(&private->vdev);
 		return -ENODEV;
+	}
 
 	switch (event) {
 	case CHP_VARY_OFF:
@@ -365,6 +371,7 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 		break;
 	}
 
+	vfio_device_put(&private->vdev);
 	return 0;
 }
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 3833204bd388..be238cf277ff 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -135,6 +135,8 @@ static inline struct vfio_ccw_private *vfio_ccw_get_private(struct subchannel *s
 		return NULL;
 
 	private = dev_get_drvdata(&sch->dev);
+	if (private && !vfio_device_try_get(&private->vdev))
+		private = NULL;
 
 	return private;
 }
-- 
2.32.0

