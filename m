Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CCB2C664E
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 14:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgK0NGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:06:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729991AbgK0NGr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:06:47 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCWUT2077747;
        Fri, 27 Nov 2020 08:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=otOPIVL6wXaFKs7fAhnMzKLeGNNpFhm5Si9btVRI3zI=;
 b=En2zJeHb05lPw0/bJqmGX9F9nPLOwu/v/O9PYtX17e27KL8u1D7fwTj5yF7qhoCWnoDc
 7LW3yi/it9x2nx96aQpGIw26s7VLfmhukOH1YtEvXEFWjdMffbxQPaa5rbvU5BhGy90A
 TIOh4DzfKxHd+v6Nkb2Mg5Efol5DpouvKgqSce2ZVTVtKNfsbzG/2gxBAxwy3Da5zRdz
 CxP8FI+QjgfhaT/rx21RZSVAwYrur1hMQUpvMuC9jA7WhMWwRpO5GhIHwFvYqvKbqY/2
 L+6W7odaAL6PJlXX/Ll2dTmXNJbA6yafcliVVY2Tj9d0apuimcnTTOb1Gc+8xun1Ed0Z lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352y6ud191-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:06:46 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ARCmeg9130634;
        Fri, 27 Nov 2020 08:06:46 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352y6ud17d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:06:46 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCRgAg028933;
        Fri, 27 Nov 2020 13:06:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 352kgk8mq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:06:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARD6cKU63963582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 13:06:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C4AC4C046;
        Fri, 27 Nov 2020 13:06:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93044C063;
        Fri, 27 Nov 2020 13:06:37 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 13:06:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 6/7] s390x: Add diag318 intercept test
Date:   Fri, 27 Nov 2020 08:06:28 -0500
Message-Id: <20201127130629.120469-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201127130629.120469-1-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_06:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not much to test except for the privilege and specification
exceptions.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp.c  |  2 ++
 lib/s390x/sclp.h  |  6 +++++-
 s390x/intercept.c | 19 +++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 68833b5..3966086 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
 
 	assert(read_info);
 
+	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+
 	cpu = (void *)read_info + read_info->offset_cpu;
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		if (cpu->address == cpu0_addr) {
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index e18f7e6..4e564dd 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -108,7 +108,8 @@ extern struct sclp_facilities sclp_facilities;
 
 struct sclp_facilities {
 	uint64_t has_sief2 : 1;
-	uint64_t : 63;
+	uint64_t has_diag318 : 1;
+	uint64_t : 62;
 };
 
 typedef struct ReadInfo {
@@ -133,6 +134,9 @@ typedef struct ReadInfo {
     uint16_t highest_cpu;
     uint8_t  _reserved5[124 - 122];     /* 122-123 */
     uint32_t hmfai;
+    uint8_t reserved7[134 - 128];
+    uint8_t byte_134_diag318 : 1;
+    uint8_t : 7;
     struct CPUEntry entries[0];
 } __attribute__((packed)) ReadInfo;
 
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 2e38257..615f0a0 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -10,6 +10,7 @@
  * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
+#include <sclp.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
@@ -154,6 +155,23 @@ static void test_testblock(void)
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
+static void test_diag318(void)
+{
+	expect_pgm_int();
+	enter_pstate();
+	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+
+	if (!sclp_facilities.has_diag318)
+		expect_pgm_int();
+
+	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
+
+	if (!sclp_facilities.has_diag318)
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+}
+
 struct {
 	const char *name;
 	void (*func)(void);
@@ -164,6 +182,7 @@ struct {
 	{ "stap", test_stap, false },
 	{ "stidp", test_stidp, false },
 	{ "testblock", test_testblock, false },
+	{ "diag318", test_diag318, false },
 	{ NULL, NULL, false }
 };
 
-- 
2.25.1

