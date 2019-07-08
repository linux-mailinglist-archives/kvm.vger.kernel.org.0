Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4B62A28
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 22:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404878AbfGHUKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 16:10:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731876AbfGHUKr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jul 2019 16:10:47 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68K7JGA015730
        for <kvm@vger.kernel.org>; Mon, 8 Jul 2019 16:10:46 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmbcsjh7x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 16:10:46 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Mon, 8 Jul 2019 21:10:45 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Jul 2019 21:10:42 +0100
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68KAeGU56033574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 20:10:41 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB48BE054;
        Mon,  8 Jul 2019 20:10:40 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D56ABE053;
        Mon,  8 Jul 2019 20:10:40 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.103])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon,  8 Jul 2019 20:10:40 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [RFC v2 1/5] vfio-ccw: Fix misleading comment when setting orb.cmd.c64
Date:   Mon,  8 Jul 2019 16:10:34 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
In-Reply-To: <cover.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19070820-0012-0000-0000-0000174D9B1A
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011397; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229353; UDB=6.00647438; IPR=6.01010612;
 MB=3.00027639; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-08 20:10:43
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070820-0013-0000-0000-000057FD2CEB
Message-Id: <25a5bf8ae538a392f8483e6fd4b9b165de40bfce.1562616169.git.alifm@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=835 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080250
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The comment is misleading because it tells us that
we should set orb.cmd.c64 before calling ccwchain_calc_length,
otherwise the function ccwchain_calc_length would return an
error. This is not completely accurate.

We want to allow an orb without cmd.c64, and this is fine
as long as the channel program does not use IDALs. But we do
want to reject any channel program that uses IDALs and does
not set the flag, which what we do in ccwchain_calc_length.

After we have done the ccw processing, it should be safe
to set cmd.c64, since we will convert them into IDALs.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index d6a8dff..7622b72 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -645,8 +645,8 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	if (ret)
 		cp_free(cp);
 
-	/* It is safe to force: if not set but idals used
-	 * ccwchain_calc_length returns an error.
+	/* It is safe to force: if it was not set but idals used
+	 * ccwchain_calc_length would have returned an error.
 	 */
 	cp->orb.cmd.c64 = 1;
 
-- 
2.7.4

