Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00005275913
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgIWNsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:48:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16136 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgIWNsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 09:48:15 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NDXKxt028847;
        Wed, 23 Sep 2020 09:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6VjfSkbUVoJ/rM/fk2QBzWFUj0lfs/Hw9kAtyQ/FnWI=;
 b=sBmB53eAoNlxYgsZtRv6e5Q5LJVwJOO6O7aJTLno5htczW7644ciV8vlFZSjGvdF6KHO
 tLrnHHqewSUK+NYwWf9PoJUd7uoU3CHUHS/EED4M2tpFn10mqalvg5rbJeYm9/DaLHeI
 ursdY51b+9PytbSVw8jg9fgNokuJ467J/qQcmR5bDJSKFctuKfJ/wTf7dc6Vf5bCo5/5
 W1ekH73kDhJoS9SCD0nfuC/hPtOZnOwe78AIVQphmxDbVqlT5Z6aEGQ9HVzfXP/MnCIj
 soRzEv5OuF+OwG0OkrJYwoYrFdauqO5jVQ5mp1iNo9rm/WEX0joXrV91d1dsBy/LcOhJ Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r5wf3r2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08NDYgpi034411;
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r5wf3r1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:13 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NDlnPG029282;
        Wed, 23 Sep 2020 13:48:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 33n9m7t6c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 13:48:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NDm8U825756016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 13:48:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDE774C059;
        Wed, 23 Sep 2020 13:48:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BE564C044;
        Wed, 23 Sep 2020 13:48:08 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.64.218])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 13:48:08 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH kvm-unit-tests v2 2/4] scripts: add support for architecture dependent functions
Date:   Wed, 23 Sep 2020 15:47:56 +0200
Message-Id: <20200923134758.19354-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923134758.19354-1-mhartmay@linux.ibm.com>
References: <20200923134758.19354-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_09:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=15
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is necessary to keep architecture dependent code separate from
common code.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 README.md           | 3 ++-
 scripts/common.bash | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 48be206c6db1..24d4bdaaee0d 100644
--- a/README.md
+++ b/README.md
@@ -134,7 +134,8 @@ all unit tests.
 ## Directory structure
 
     .:                  configure script, top-level Makefile, and run_tests.sh
-    ./scripts:          helper scripts for building and running tests
+    ./scripts:          general architecture neutral helper scripts for building and running tests
+    ./scripts/<ARCH>:   architecture dependent helper scripts for building and running tests
     ./lib:              general architecture neutral services for the tests
     ./lib/<ARCH>:       architecture dependent services for the tests
     ./<ARCH>:           the sources of the tests and the created objects/images
diff --git a/scripts/common.bash b/scripts/common.bash
index 96655c9ffd1f..c7acdf14a835 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -1,3 +1,4 @@
+source config.mak
 
 function for_each_unittest()
 {
@@ -52,3 +53,10 @@ function for_each_unittest()
 	fi
 	exec {fd}<&-
 }
+
+# The current file has to be the only file sourcing the arch helper
+# file
+ARCH_FUNC=scripts/${ARCH}/func.bash
+if [ -f "${ARCH_FUNC}" ]; then
+	source "${ARCH_FUNC}"
+fi
-- 
2.25.4

