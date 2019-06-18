Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E0F4AB9B
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 22:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbfFRUYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 16:24:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730358AbfFRUYB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jun 2019 16:24:01 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IKHA3D133900
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:00 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t75q4uk2y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:00 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Tue, 18 Jun 2019 21:23:58 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 21:23:56 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IKNkNq30081282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:23:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DF3542047;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 947CD42054;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id D4018E02C3; Tue, 18 Jun 2019 22:23:53 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 5/5] vfio-ccw: Remove copy_ccw_from_iova()
Date:   Tue, 18 Jun 2019 22:23:52 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618202352.39702-1-farman@linux.ibm.com>
References: <20190618202352.39702-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061820-0012-0000-0000-0000032A41C1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061820-0013-0000-0000-00002163603E
Message-Id: <20190618202352.39702-6-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=977 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just to keep things tidy.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 9a8bf06281e0..9cddc1288059 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -228,17 +228,6 @@ static long copy_from_iova(struct device *mdev,
 	return l;
 }
 
-static long copy_ccw_from_iova(struct channel_program *cp,
-			       struct ccw1 *to, u64 iova,
-			       unsigned long len)
-{
-	int ret;
-
-	ret = copy_from_iova(cp->mdev, to, iova, len * sizeof(struct ccw1));
-
-	return ret;
-}
-
 /*
  * Helpers to operate ccwchain.
  */
@@ -435,7 +424,8 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	int len;
 
 	/* Copy 2K (the most we support today) of possible CCWs */
-	len = copy_ccw_from_iova(cp, cp->guest_cp, cda, CCWCHAIN_LEN_MAX);
+	len = copy_from_iova(cp->mdev, cp->guest_cp, cda,
+			     CCWCHAIN_LEN_MAX * sizeof(struct ccw1));
 	if (len)
 		return len;
 
-- 
2.17.1

