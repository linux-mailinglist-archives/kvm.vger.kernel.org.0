Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4C1740E8
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 23:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbfGXVfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 17:35:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387795AbfGXVfy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jul 2019 17:35:54 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OLWsFB053214
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 17:35:53 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2txx4w2qn3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 17:35:53 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Wed, 24 Jul 2019 22:35:52 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e32.co.us.ibm.com (192.168.1.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Jul 2019 22:35:49 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6OLZm3o51249468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 21:35:48 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E834C6062;
        Wed, 24 Jul 2019 21:35:48 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80574C6059;
        Wed, 24 Jul 2019 21:35:47 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.37])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 24 Jul 2019 21:35:47 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [PATCH 1/1] MAINTAINERS: vfio-ccw: Remove myself as the maintainer
Date:   Wed, 24 Jul 2019 17:35:46 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1564003698.git.alifm@linux.ibm.com>
References: <cover.1564003698.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19072421-0004-0000-0000-0000152E4589
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011489; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01236936; UDB=6.00651981; IPR=6.01018303;
 MB=3.00027877; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-24 21:35:51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072421-0005-0000-0000-00008C98A9D2
Message-Id: <355a4ac2923ff3dcf2171cb23d477440bd010b34.1564003698.git.alifm@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=668 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240229
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I will not be able to continue with my maintainership responsibilities
going forward, so remove myself as the maintainer.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index acbad13..fe2797a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1452,7 +1452,6 @@ F: include/hw/vfio/
 vfio-ccw
 M: Cornelia Huck <cohuck@redhat.com>
 M: Eric Farman <farman@linux.ibm.com>
-M: Farhan Ali <alifm@linux.ibm.com>
 S: Supported
 F: hw/vfio/ccw.c
 F: hw/s390x/s390-ccw.c
-- 
2.7.4

