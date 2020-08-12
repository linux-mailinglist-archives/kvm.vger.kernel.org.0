Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407BF24278E
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 11:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgHLJ1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 05:27:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727896AbgHLJ1V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 05:27:21 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07C94x7d083146;
        Wed, 12 Aug 2020 05:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H3G210iWNUd5kagW5EmFZwKPo0CsJkHIviE8UvjD2RE=;
 b=ZDDANpTPvKfal4HShRwIe5lE6b9nphHBQhcdqgvKYHxBeMyZiupgAa/e5GRECYIYdjDC
 ZIruog1PHejtIrtBRsRfrZ6ObSh3iy6vEjjWEpbzh6o2MIjex3lughA8NNShRKptMp8A
 Yf0qy51KYLHjpYQ4gVwkoL5e2nJHm98hif1cOC7A0g8PU5wCQc37icompUVs7Ev8IKMm
 ADLXoMEYHeXkaRdy4l8UQdJlmQ1sDqFdiuL43IbGTOgI4s0rD1tlHauvwKNKuu/1GofM
 ZhFXcZVOxYwnciyBHdDQ6RW5zO4E43/fxt2iwNNkGe9zMkkVUeDLP5A7jriv1rwswbhJ 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vakp5euh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07C951nL083367;
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vakp5eu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07C9M2TE023076;
        Wed, 12 Aug 2020 09:27:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 32skp82m0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 09:27:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07C9REbL24904036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 09:27:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0A5452051;
        Wed, 12 Aug 2020 09:27:14 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.75.196])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 36DA452050;
        Wed, 12 Aug 2020 09:27:14 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC v2 2/4] scripts: add support for architecture dependent functions
Date:   Wed, 12 Aug 2020 11:27:03 +0200
Message-Id: <20200812092705.17774-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200812092705.17774-1-mhartmay@linux.ibm.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_02:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=1 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120064
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is necessary to keep architecture dependent code separate from
common code.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 README.md           | 3 ++-
 scripts/common.bash | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

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
index 96655c9ffd1f..f9c15fd304bd 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -52,3 +52,8 @@ function for_each_unittest()
 	fi
 	exec {fd}<&-
 }
+
+ARCH_FUNC=scripts/${ARCH}/func.bash
+if [ -f "${ARCH_FUNC}" ]; then
+	source "${ARCH_FUNC}"
+fi
-- 
2.25.4

