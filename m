Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8C740DC
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfGXVcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 17:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfGXVcI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jul 2019 17:32:08 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OLSFgj053934;
        Wed, 24 Jul 2019 17:32:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2txwrpunjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 17:32:07 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6OLTDQF062752;
        Wed, 24 Jul 2019 17:32:07 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2txwrpunj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 17:32:07 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6OLTrdV019840;
        Wed, 24 Jul 2019 21:32:06 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 2tx61n9jcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 21:32:06 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6OLW43I57672018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 21:32:04 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B247136055;
        Wed, 24 Jul 2019 21:32:04 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFE1613604F;
        Wed, 24 Jul 2019 21:32:03 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.37])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 24 Jul 2019 21:32:03 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [PATCH 1/1] MAINTAINERS: vfio-ccw: Remove myself as the maintainer
Date:   Wed, 24 Jul 2019 17:32:03 -0400
Message-Id: <19aee1ab0e5bcc01053b515117a66426a9332086.1564003585.git.alifm@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1564003585.git.alifm@linux.ibm.com>
References: <cover.1564003585.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=794 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240228
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
index 0e90487..dd07a23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13696,7 +13696,6 @@ F:	drivers/pci/hotplug/s390_pci_hpc.c
 
 S390 VFIO-CCW DRIVER
 M:	Cornelia Huck <cohuck@redhat.com>
-M:	Farhan Ali <alifm@linux.ibm.com>
 M:	Eric Farman <farman@linux.ibm.com>
 R:	Halil Pasic <pasic@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
-- 
2.7.4

