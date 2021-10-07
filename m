Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8BB424F8B
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240316AbhJGIyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:54:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240543AbhJGIyO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:54:14 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1978qHWc029801;
        Thu, 7 Oct 2021 04:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7C4J2tmanKTNq56mBTTBCOwTprd12f3qn3jOLHA3gts=;
 b=SzwNM+2ByKpevNM1PAKp5pcKHqjYmJJSWePsDGJWV4U4Nf3Cq3v3QUnc0KaaGNmExBP+
 cMAF1mE4I6cMxf6Gtlv4VOXv8v0R9kseG6J+ZOYGDTSLvaX8S3YjzpRRxcpSEzwrQTnf
 SMx8useQ506UJJ+41/1ozOwz+As6SeyeNc143zBiz71Uh47iy7ICqQAd2fI1UBEFsJqI
 JrQuLu3FwTDIhiMjAoLmUQ4aFcekoQK3/cogEcTzxqFknU1PJxPCyXEwxmLj7iNgjtYD
 JXiEq5KGKvyqGKgX9xVHHjU9FSVy7/GFKWmkc0h9LRvC+zNc2I1eojAqgqS2/PdkTydc 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh8caxua5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:20 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1978FZKf008646;
        Thu, 7 Oct 2021 04:52:19 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh8caxu7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:19 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978ptd7015616;
        Thu, 7 Oct 2021 08:52:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bhepcxu26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:52:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978q9rU36831582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:52:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78560AE07F;
        Thu,  7 Oct 2021 08:52:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 489F4AE073;
        Thu,  7 Oct 2021 08:52:07 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:52:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 9/9] s390x: snippets: Define all things that are needed to link the lib
Date:   Thu,  7 Oct 2021 08:50:27 +0000
Message-Id: <20211007085027.13050-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nAfcF6KG2weMbLnERKUu9dh3bTM6xAnL
X-Proofpoint-ORIG-GUID: BTUEeWi-7dZNnW2L7wp1CdLRyslLbQoE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=876 priorityscore=1501
 mlxscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's just define all of the needed things so we can link libcflat.

A significant portion of the lib won't work, like printing and
allocation but we can still use things like memset() which already
improves our lives significantly.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/snippets/c/cstart.S | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index 031a6b83..2d397669 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -20,6 +20,20 @@ start:
 	lghi	%r15, stackptr
 	sam64
 	brasl	%r14, main
+/*
+ * Defining things that the linker needs to link in libcflat and make
+ * them result in sigp stop if called.
+ */
+.globl sie_exit
+.globl sie_entry
+.globl smp_cpu_setup_state
+.globl ipl_args
+.globl auxinfo
+sie_exit:
+sie_entry:
+smp_cpu_setup_state:
+ipl_args:
+auxinfo:
 	/* For now let's only use cpu 0 in snippets so this will always work. */
 	xgr	%r0, %r0
 	sigp    %r2, %r0, SIGP_STOP
-- 
2.30.2

