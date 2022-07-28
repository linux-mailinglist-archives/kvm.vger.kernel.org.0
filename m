Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AD5584751
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiG1U5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiG1U5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:57:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CA97756F;
        Thu, 28 Jul 2022 13:57:13 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SKqbjj006040;
        Thu, 28 Jul 2022 20:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Q49pvwiDXgpTDTiMjf8wWGVUqEkfx7B/uYUDJknVWnc=;
 b=Hv1/PHN8nvclFg3nZSgj8er32hlZIiPqpRK7HBDxdAwhW1TTLHv+mt0IFdfZ2tv5w594
 q2LEuVjdROHRr1sQLarOAJXTSJWzaQizfVF8i6621Nt6rOalh8NkE/uIPQdkWxhNADXw
 SzEqldlIzH/doCaDUTG3p4CU0ikJMJiczOUFvJ4x6GWPg065ZZH35pLhkFOH4om/Cb25
 KeGxsr7Z20y6t+GkJpluL+vu+fLx/Jchqh0f3akIMbETn0a1sd5WIiGzTj3MM1nhXNa0
 SB6LYNvpP/EgOLHlvT3UL6pUk7Z3a2RvgzB8aHJnHm+wIno2h8XrszO0YMe6gUGwHiqD Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1vm824u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:11 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SKsQin016132;
        Thu, 28 Jul 2022 20:57:10 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1vm823v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:10 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SKp8Fr011884;
        Thu, 28 Jul 2022 20:57:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3hg94ed4uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SKv43E20906368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 20:57:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B61642045;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 899FA4203F;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 0ED02E098F; Thu, 28 Jul 2022 22:49:16 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 3/3] vfio/ccw: Check return code from subchannel quiesce
Date:   Thu, 28 Jul 2022 22:49:14 +0200
Message-Id: <20220728204914.2420989-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728204914.2420989-1-farman@linux.ibm.com>
References: <20220728204914.2420989-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vZLvIXTDWhEEBmKUbwULLz5ZstYYnU3u
X-Proofpoint-ORIG-GUID: XOxeq4WSRJD4xaEniFqSduV4cAb28FeP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a subchannel is busy when a close is performed, the subchannel
needs to be quiesced and left nice and tidy, so nothing unexpected
(like a solicited interrupt) shows up while in the closed state.
Unfortunately, the return code from this call isn't checked,
so any busy subchannel is treated as a failing one.

Fix that, so that the close on a busy subchannel happens normally.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 4b8b623df24f..a59c758869f8 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -407,7 +407,7 @@ static void fsm_close(struct vfio_ccw_private *private,
 
 	ret = cio_disable_subchannel(sch);
 	if (ret == -EBUSY)
-		vfio_ccw_sch_quiesce(sch);
+		ret = vfio_ccw_sch_quiesce(sch);
 	if (ret)
 		goto err_unlock;
 
-- 
2.34.1

