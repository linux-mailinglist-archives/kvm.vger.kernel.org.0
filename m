Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE28366CDE
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242368AbhDUNaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 09:30:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59340 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242362AbhDUNa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 09:30:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LDTq8A191778;
        Wed, 21 Apr 2021 13:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=x7XxM5gBTlzGvvXoEooc9Z5gsaqRPidEWmbGH2Zkug0=;
 b=Qf/NqzXiIuq8Cgc55/wweNC6nr0fA3E+cyHis08qGcmUdBZtcLJOsZ1vibR9fMIIokBX
 ViVwuVPwzmZG+ywc4FeUux36IZMAEQFxiSgzqViewm2HhDxWXbV7k1KT1Wbu6oh1Lr/g
 Cp+ZLpepWflQvOm5gsrnWi5wzii8MA0gLWZCADq/PBWnd7uUg/gNiEXls4cFHu6BvNxm
 7PuLwZ7XDBTBvgJpvCxOlfcaqXW6VccoAESO2cExhvQerBAKT1gdqA/afKrS4pvbLOIk
 KNYzMoJ160aq+MHKuE1s+nAhSrtvouan4t2ImmSgCjqbLXw6fevHaY0Y4uGoya84wgDA jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37yn6cabug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 13:29:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LDJwD0177263;
        Wed, 21 Apr 2021 13:29:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3809eu97n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 13:29:44 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13LDTiq0012637;
        Wed, 21 Apr 2021 13:29:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3809eu97m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 13:29:44 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13LDTgWN000330;
        Wed, 21 Apr 2021 13:29:42 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Apr 2021 06:29:41 -0700
Date:   Wed, 21 Apr 2021 16:29:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] vfio/mdev: remove unnecessary NULL check in mbochs_create()
Message-ID: <YIAowNYCOCNu+xhm@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: G56WWe1uv1YPfgNyI46pq8Gn3Pq884By
X-Proofpoint-ORIG-GUID: G56WWe1uv1YPfgNyI46pq8Gn3Pq884By
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This NULL check is no longer required because "type" now points to
an element in a non-NULL array.

Fixes: 3d3a360e570616 ("vfio/mbochs: Use mdev_get_type_group_id()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 samples/vfio-mdev/mbochs.c | 2 --
 samples/vfio-mdev/mdpy.c | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 861c76914e76..881ef9a7296f 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -513,8 +513,6 @@ static int mbochs_create(struct mdev_device *mdev)
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 
-	if (!type)
-		type = &mbochs_types[0];
 	if (type->mbytes + mbochs_used_mbytes > max_mbytes)
 		return -ENOMEM;
 
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index f0c0e7209719..e889c1cf8fd1 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -667,8 +667,7 @@ static ssize_t description_show(struct mdev_type *mtype,
 		&mdpy_types[mtype_get_type_group_id(mtype)];
 
 	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
-		       type ? type->width  : 0,
-		       type ? type->height : 0);
+		       type->width, type->height);
 }
 static MDEV_TYPE_ATTR_RO(description);
 
-- 
2.30.2
