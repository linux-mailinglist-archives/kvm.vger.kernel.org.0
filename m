Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AC42867D9
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgJGS4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:56:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40898 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728336AbgJGS4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 14:56:42 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097IY4Ni003339;
        Wed, 7 Oct 2020 14:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6bue6gCnLABqCjxx30Stygv432t7bosA5Uvr4BsgLJo=;
 b=VFYJMtl8nxY8D14xjelRZKFXPheaqZcmUoIkGBQeH7vo+1BvaSPEFMdeh9NK26kk5Gax
 EYF9m9B/NMY95RZtBUPsCcth411ghKJWozu6wjlRnwKgpJ1IgY/sMbAUFHx8n44r458v
 LDOk5RuWfPDBpZJ4SM/HV3e/dvME9DlQc+ILkK6QAZ7EygwQJ23WK1lXFMOmDnahqAKf
 8D0w+ejR0fzk5JeSe8wnfjoXRGImXMRm23iSk4i+VwRF8du1JyVpNIygOhzh8kFJNDQ3
 CdGzKLMLRgf/ZRDJhHjoBHlvMZD5aYefSnWEZpJOerbH1ppHO+uO5jCb7aGTkHRkxrtf 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341hb2uw9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:40 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097IYDmQ004112;
        Wed, 7 Oct 2020 14:56:40 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341hb2uw9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:40 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097IlajX010740;
        Wed, 7 Oct 2020 18:56:39 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 33xgx9sjuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 18:56:39 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097IuauF28049910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 18:56:36 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 699147805F;
        Wed,  7 Oct 2020 18:56:36 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15F107805C;
        Wed,  7 Oct 2020 18:56:35 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 18:56:34 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] MAINTAINERS: Add entry for s390 vfio-pci
Date:   Wed,  7 Oct 2020 14:56:24 -0400
Message-Id: <1602096984-13703-6-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=971 malwarescore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add myself to cover s390-specific items related to vfio-pci.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a54806..a0e8d14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15170,6 +15170,14 @@ F:	Documentation/s390/vfio-ccw.rst
 F:	drivers/s390/cio/vfio_ccw*
 F:	include/uapi/linux/vfio_ccw.h
 
+S390 VFIO-PCI DRIVER
+M:	Matthew Rosato <mjrosato@linux.ibm.com>
+L:	linux-s390@vger.kernel.org
+L:	kvm@vger.kernel.org
+S:	Supported
+F:	drivers/vfio/pci/vfio_pci_zdev.c
+F:	include/uapi/linux/vfio_zdev.h
+
 S390 ZCRYPT DRIVER
 M:	Harald Freudenberger <freude@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
-- 
1.8.3.1

