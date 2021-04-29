Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5BE36E83C
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 11:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbhD2Jy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 05:54:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45636 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhD2JyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 05:54:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T9XrGH131973;
        Thu, 29 Apr 2021 09:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=zMqah14+OFnOSJ6UHqaQtZjQ2w6PI4tm2fnCNKK/fi0=;
 b=L5aJa2VqnQdAXIeIR4rtKZyFAcYavk8z8YWn2ggFvCR1cLxXOVyHE6cWJ/K2G64KBRBD
 tcVlDcrAZBV5ewDDRak5TaBGM4NCnlDacWGHTCL/xia6vgNKOOjbH9pWqDudRfUK/rSK
 2d5xef05cNs09OHeKIoiAaUA4zsjdqC27m+v7ANII/MAR2l08CVXV76RifYdrOmUBmmo
 ZFt34YoPA+B7bCtSFUk0ETxkuU0w2OizjNi3n9yG28sffJUC9S+9VYzfp8jHWQ6MTVHS
 tv7DPLFmQyOc9Qx+MpLG2eeJBdm7a+L+vpc6R37WLaqBV81RoyRo2J/65mwZRSv/0ofy 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aeq3spg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 09:53:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T9UsFm180136;
        Thu, 29 Apr 2021 09:53:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3848f0u8ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 09:53:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 13T9rXB0004611;
        Thu, 29 Apr 2021 09:53:33 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Apr 2021 09:53:33 +0000
Date:   Thu, 29 Apr 2021 12:53:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] vfio/mdev: remove unnecessary NULL check in
 mbochs_create()
Message-ID: <20210429095327.GY1981@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290067
X-Proofpoint-ORIG-GUID: cJHDy9ASvbS2L6ec5T_3l35qXnZXxmI1
X-Proofpoint-GUID: cJHDy9ASvbS2L6ec5T_3l35qXnZXxmI1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originally "type" could be NULL and these checks were required, but we
recently changed how "type" is assigned and that's no longer the case.
Now "type" points to an element in the middle of a non-NULL array.

Removing the checks does not affect runtime at all, but it makes the
code a little bit simpler to read.

Fixes: 3d3a360e570616 ("vfio/mbochs: Use mdev_get_type_group_id()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Update the commit message

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
