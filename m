Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3430743195F
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhJRMk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231495AbhJRMkU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:20 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19I9sjFA007914;
        Mon, 18 Oct 2021 08:38:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=x9m69RdPpWPWGJvkAYqD1Y8HmFfHfO8m+SdWOZdaUiQ=;
 b=dlKusC4sdtaNZI2UhMHTsyXqYQhDWCnqoCl0Q75/se6yJhQlA663kJE7Wdwlt6vHYCw1
 lowSJk/oLthhMPJ+mKanqu9HXl/MY3ytFQze0cNn4gCDUX8qRWVacwTedf5r1D1jnJde
 LFbNGpOi/me6Di6cFCJeOq8yvQDhjBQUIkccUaUgqvBLeXF/aZ413QnXg/3tgKHx7e/j
 GRJxanOSNBL8QG4qe5K2/uFZ1aoikap1TuUUpi5d2D0mS4HehTmyvZxq3HkCehDTWsCE
 vTnGxqGhyUssNf35DXiYHN2xVH6l0+axBPngA910Hv4etGLS+6avXoZmZDiMJGsmhhae pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs419f0hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:09 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICJtAY025314;
        Mon, 18 Oct 2021 08:38:08 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs419f0gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:08 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbSvM021858;
        Mon, 18 Oct 2021 12:38:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0je844-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICWEJH34931094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:32:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 260865204E;
        Mon, 18 Oct 2021 12:38:03 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ABE1552063;
        Mon, 18 Oct 2021 12:38:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 10/17] lib: s390x: Add access key argument to tprot
Date:   Mon, 18 Oct 2021 14:26:28 +0200
Message-Id: <20211018122635.53614-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rd2CX5PLFSHRTgxKtEkNHXgE2k8xz9gW
X-Proofpoint-ORIG-GUID: NFLXvBgYdg5SPJB4zLT8yCs4HyjW22eA
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=883
 suspectscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Currently there is only one callee passing a non zero key,
but having the argument will be useful in the future.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/kvm/20211007085027.13050-1-frankja@linux.ibm.com/T/#md3064e13e876e0418a16f0d5a5bd9a6f2adebfd9
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 6 +++---
 lib/s390x/sclp.c         | 2 +-
 s390x/skrf.c             | 3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index c8d2722a..b34aa792 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -233,15 +233,15 @@ static inline uint16_t get_machine_id(void)
 	return cpuid;
 }
 
-static inline int tprot(unsigned long addr)
+static inline int tprot(unsigned long addr, char access_key)
 {
 	int cc;
 
 	asm volatile(
-		"	tprot	0(%1),0\n"
+		"	tprot	0(%1),0(%2)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
-		: "=d" (cc) : "a" (addr) : "cc");
+		: "=d" (cc) : "a" (addr), "a" (access_key << 4) : "cc");
 	return cc;
 }
 
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 9502d161..02722498 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -217,7 +217,7 @@ void sclp_memory_setup(void)
 	/* probe for r/w memory up to max memory size */
 	while (ram_size < max_ram_size) {
 		expect_pgm_int();
-		cc = tprot(ram_size + storage_increment_size - 1);
+		cc = tprot(ram_size + storage_increment_size - 1, 0);
 		/* stop once we receive an exception or have protected memory */
 		if (clear_pgm_int() || cc != 0)
 			break;
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 8ca7588c..ca4efbf1 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -103,8 +103,7 @@ static void test_tprot(void)
 {
 	report_prefix_push("tprot");
 	expect_pgm_int();
-	asm volatile("tprot	%[addr],0xf0(0)\n"
-		     : : [addr] "a" (pagebuf) : );
+	tprot((unsigned long)pagebuf, 0xf);
 	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
 	report_prefix_pop();
 }
-- 
2.31.1

