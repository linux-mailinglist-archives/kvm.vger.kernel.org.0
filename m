Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8B4281C8D
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJBUGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:06:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJBUGt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:06:49 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092K51PT089210;
        Fri, 2 Oct 2020 16:06:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=WK8gF4N9HS62KlaG4AFwexv7peq6mKBPRGLNCAZO4F8=;
 b=A6pu9qlzV49WKg//Bai6rwBs6kP78l168GIhLq1ifH/KHHckrF8Y7Udz2pG1UoHimjU+
 jEjMe6zDYMqMTKGMDAu5nn0D5j95084HYK9Er5fiYHfOUzCeFTYcJiR4rh23ASSoPsCy
 liZ1okr/+RjMcOw2N7wuRNNviofTTAYIfccR1cGnlNp+99199hp5bjVhSGSmyM6kynT/
 OI5Bppq+SCagSEn3D/lYJurre2y+OqlfAAqkeGivAeQbIUH7xeyAWh+iEes9KbjLgAT4
 SFcFq0KIQ1TY5eWRfp7miTdGbhlE92kqjWcUWVnw0li8MULWO1KGXKerwYj7zjsILmLp Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xa63gwv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:43 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K5AG3090616;
        Fri, 2 Oct 2020 16:06:42 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xa63gwuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:42 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JmGPb007960;
        Fri, 2 Oct 2020 20:06:41 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 33sw9a099g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:06:41 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K6dFl43188538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:06:39 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6E48BE051;
        Fri,  2 Oct 2020 20:06:39 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 734B9BE04F;
        Fri,  2 Oct 2020 20:06:38 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:06:38 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 3/9] update-linux-headers: Add vfio_zdev.h
Date:   Fri,  2 Oct 2020 16:06:25 -0400
Message-Id: <1601669191-6731-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020145
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_zdev.h is used by s390x zPCI support to pass device-specific
CLP information between host and userspace.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 scripts/update-linux-headers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index 29c27f4..9efbaf2 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -141,7 +141,7 @@ done
 
 rm -rf "$output/linux-headers/linux"
 mkdir -p "$output/linux-headers/linux"
-for header in kvm.h vfio.h vfio_ccw.h vhost.h \
+for header in kvm.h vfio.h vfio_ccw.h vfio_zdev.h vhost.h \
               psci.h psp-sev.h userfaultfd.h mman.h; do
     cp "$tmpdir/include/linux/$header" "$output/linux-headers/linux"
 done
-- 
1.8.3.1

