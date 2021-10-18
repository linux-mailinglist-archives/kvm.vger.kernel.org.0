Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835DE431966
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhJRMkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231771AbhJRMkZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IBKZ3P029696;
        Mon, 18 Oct 2021 08:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=5w2/1GBoeDZXtFc3D2iqTwBu21W7bbsct6X61+eUiQk=;
 b=MfbJy4ZYUaf644edpeHSfemzz+BXEgyn/KD+iTOq0h8zv7Dw8IA9bWiMAz3g+cIMSkam
 87J5wmSEWP1jEpGnlmFmkz9seihtW14YPtojE2Ck4HgvUEvy3bOl0RBXfrrL/fmA2fof
 vp8GSF7lut5iOjuEmiX8UDNYy6e0UISXPEZvHKhqlZy1wM1+yZKfudOUDV9nDCh8a/TB
 Me9mKa07cWaEIa3jVS+ujwfK2v6gzjw5rEL8ohFUatygybpfrOTHMVZqKprm7i7PLcfc
 ELJljbZIPXAVWXrKSdZqOF57x8Mj/IGOmUwu+SHGH1Y9JYXztHES+qoUfqcHUH+mvReV 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1mbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:14 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICc6vo015870;
        Mon, 18 Oct 2021 08:38:13 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1ma1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:13 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbTIx021866;
        Mon, 18 Oct 2021 12:38:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0je84k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc5kq45482338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BB3F5204E;
        Mon, 18 Oct 2021 12:38:05 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C45B152067;
        Mon, 18 Oct 2021 12:38:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 14/17] s390x: snippets: Define all things that are needed to link the libc
Date:   Mon, 18 Oct 2021 14:26:32 +0200
Message-Id: <20211018122635.53614-15-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -RanaH08MAqePzy9yWbxJiVQq5-e5hy5
X-Proofpoint-GUID: R48UtSlSW4jmcsZ_cP_hy7SV_7BIBAuL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

In the long run, we want to use parts of the libc like memset() etc.,
too. However, to be able to link it correctly, we have to provide
some stub functions like puts() and exit() to avoid that too much
other stuff from the lib folder gets pulled into the binaries, which
we cannot provide in the snippets (like the sclp support).

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20211008092649.959956-1-thuth@redhat.com>
Link: https://lore.kernel.org/kvm/20211008092649.959956-1-thuth@redhat.com/
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile            |  2 +-
 s390x/snippets/c/cstart.S | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 5d1a33a0..d18b08b0 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -81,7 +81,7 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 FLATLIBS = $(libcflat)
 
 SNIPPET_DIR = $(TEST_DIR)/snippets
-snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
+snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o lib/auxinfo.o
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index 031a6b83..aaa5380c 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -20,6 +20,17 @@ start:
 	lghi	%r15, stackptr
 	sam64
 	brasl	%r14, main
+	/*
+	 * If main() returns, we stop the CPU with the code below. We also
+	 * route some functions that are required by the libc (but not usable
+	 * from snippets) to the CPU stop code below, so that snippets can
+	 * still be linked against the libc code (to use non-related functions
+	 * like memset() etc.)
+	 */
+.global puts
+.global exit
+puts:
+exit:
 	/* For now let's only use cpu 0 in snippets so this will always work. */
 	xgr	%r0, %r0
 	sigp    %r2, %r0, SIGP_STOP
-- 
2.31.1

