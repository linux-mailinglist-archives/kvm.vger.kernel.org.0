Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C986553BD27
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiFBRUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbiFBRUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A1620E6EF;
        Thu,  2 Jun 2022 10:20:00 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252F2Rtm013459;
        Thu, 2 Jun 2022 17:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tZRmzSEh/HH8qm23fRp/eHQUlKrHM2b+ReH5/aACu5Y=;
 b=aB6vgKxtzxhURbJqKBdFQwJA46/3xB0LTagIKzpnWj4BgZWKAyzC8qpO+TTTbnVQ4nvC
 awYecTD4+H2SIKRFGAiPZDATteXbW1Ne7OR/UiAorOuW5zoPiQw8s6wMNpKPGapWLBym
 OOhR2sulSpi07Z1zVmjhCMIOrPexa5MFlv13kFhqoo+9zn7QxMcCV/z2GQHa8fZBZntp
 QDvQiHL7MYDbfH1KY1cXL304Rd14RfIPh3USoqtILVlt3iUmNB/nnJRuV337zvoeOanB
 IqQAYNeDgg+8m5dbsdMy3QrQZqkJyz1XuVEbNOOaHbyMYqRhLe0edBRjy2wjnHpj42h8 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geyg6tg8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:57 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252H3500001435;
        Thu, 2 Jun 2022 17:19:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geyg6tg8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H56XH023479;
        Thu, 2 Jun 2022 17:19:54 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h7bxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJktJ23396652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D81D42049;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7F242042;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id BDA8AE09F8; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 08/18] vfio/ccw: Check that private pointer is not NULL
Date:   Thu,  2 Jun 2022 19:19:38 +0200
Message-Id: <20220602171948.2790690-9-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aAu-3V52I8FbOWPh-s8TLsGbNSF9noAu
X-Proofpoint-ORIG-GUID: JtocuSbCJA0cvhfqgeu0s64ca1nVycPL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxlogscore=740 bulkscore=0 clxscore=1015
 phishscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subchannel->dev->drvdata pointer is set in vfio_ccw_sch_probe()
and cleared in vfio_ccw_sch_remove(). In a purely defensive move,
let's check that the resultant pointer exists before operating on it
any way, since some lifecycle changes are forthcoming.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 3784eb4cda85..f8226db26e54 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -41,6 +41,9 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	int iretry, ret = 0;
 
+	if (!private)
+		return 0;
+
 	spin_lock_irq(sch->lock);
 	if (!sch->schib.pmcw.ena)
 		goto out_unlock;
@@ -132,6 +135,9 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
+	if (WARN_ON(!private))
+		return;
+
 	inc_irq_stat(IRQIO_CIO);
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
 }
@@ -260,6 +266,9 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
+	if (!private)
+		return;
+
 	vfio_ccw_sch_quiesce(sch);
 	mdev_unregister_device(&sch->dev);
 
@@ -293,6 +302,9 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	unsigned long flags;
 	int rc = -EAGAIN;
 
+	if (!private)
+		return 0;
+
 	spin_lock_irqsave(sch->lock, flags);
 	if (!device_is_registered(&sch->dev))
 		goto out_unlock;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 497e1b7ffd61..9e5c184eab89 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -152,6 +152,9 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
 
+	if (!private)
+		return;
+
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
 			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
-- 
2.32.0

