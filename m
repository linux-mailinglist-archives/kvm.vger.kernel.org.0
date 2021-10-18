Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B270A431962
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhJRMka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231645AbhJRMkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:22 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICTspu017280;
        Mon, 18 Oct 2021 08:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IiS8SOT8NJ5OMIx6ImTwxwAuxVdhpzVgESECbuVx5K8=;
 b=lOHs+U7zXChPIeilXnzx9nms7iJDVOagNomptJZXVRI1xEckOrEp0alSuxXJUCAWTeoU
 JJo3u8R1An6vd+qJTQebddpaN7urQSKPBSluRryiJd0ly5hM8WVinoIAq9pSpsP2r5Ko
 USHqsMMo6m2ik0NhXWz3xZnWNArF5uGW3rq1G/pxeU0wKTGlvE0oiFwYBL43/+wsCraf
 IIDiRPLboQ5l9UdzxaGLZW4ZhnCJFZSJ2zIguSU6FWs3Q5o7ffni5hrniuGmndeJcK9r
 mhjGV8YkLN4hBy/ZxHzl2Ta11FThpG/1FbgRuu2T7giNss+dWaX97ZJZE2K4JwGcFZe2 iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs6np3buf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:11 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICIXuK012173;
        Mon, 18 Oct 2021 08:38:10 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs6np3btp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:10 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICc0YY024823;
        Mon, 18 Oct 2021 12:38:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3bqpc9cx3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICWIaU59441542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:32:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0B5152052;
        Mon, 18 Oct 2021 12:38:04 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3F9B65205F;
        Mon, 18 Oct 2021 12:38:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 13/17] s390x: snippets: Set stackptr and stacktop in cstart.S
Date:   Mon, 18 Oct 2021 14:26:31 +0200
Message-Id: <20211018122635.53614-14-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CBr2GZ_TwOvd4vpC4WjrsdSn95ftC6BG
X-Proofpoint-ORIG-GUID: YPWlQyNAhWtEJr1YbQqSO1aJ0p_nJOxc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have a stack, so why not define it and be a step closer to include
the lib into the snippets.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/snippets/c/cstart.S | 2 +-
 s390x/snippets/c/flat.lds | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index a1754808..031a6b83 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -17,7 +17,7 @@ start:
 	xgr \i,\i
 	.endr
 	/* 0x3000 is the stack page for now */
-	lghi	%r15, 0x4000 - 160
+	lghi	%r15, stackptr
 	sam64
 	brasl	%r14, main
 	/* For now let's only use cpu 0 in snippets so this will always work. */
diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
index ce3bfd69..59974b38 100644
--- a/s390x/snippets/c/flat.lds
+++ b/s390x/snippets/c/flat.lds
@@ -15,6 +15,8 @@ SECTIONS
 		 QUAD(0x0000000000004000)
 	}
 	. = 0x4000;
+	stackptr = . - 160;
+	stacktop = .;
 	.text : {
 		*(.init)
 		*(.text)
-- 
2.31.1

