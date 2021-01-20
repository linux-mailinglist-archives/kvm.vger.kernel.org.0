Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3B92FD0B6
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbhATMuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:50:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388425AbhATLoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:44:19 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KBaQog016323;
        Wed, 20 Jan 2021 06:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OTxuapObkgYJhH7395HBymmc6MIVyilpjcH6ArVQ1Yo=;
 b=GDHIujsCZ4xxAJwNWQEl5unkkzw4iHDEICyqJS2SQvA8rQnySK5qJ8jCMVnaix+lGWgx
 tBClcbZs2dAbEk/ETa7mRHm4WZqEfdXGTDf28Ppd24NRElxEBxRMYF9zunG+7K59XaLv
 oiwSOTp2dGQRUTFEDZqZwYJp+MscnIzVFKXj5O959aB3pz/b8CBok+CuLOz/FsXhtYHd
 Azok1ngFc0f90FHi6RND99+M29zz7LdHMtRFyJNTeY6lxkOByN0Qtr6uIlOtkpO2jcGv
 6x8Ci91w42W+nxVXY3iCmN+U6MEUoHVBfIAya53hZdZv8l/iuXBDND+xS+jXCHLKlHVJ gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366k7t11db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:37 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KBaaX9017117;
        Wed, 20 Jan 2021 06:43:37 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366k7t11cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:37 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KBfVK4013646;
        Wed, 20 Jan 2021 11:43:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3668parhch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:43:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KBhXc27668092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 11:43:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0571AE057;
        Wed, 20 Jan 2021 11:43:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24573AE04D;
        Wed, 20 Jan 2021 11:43:32 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 11:43:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 05/11] s390x: SCLP feature checking
Date:   Wed, 20 Jan 2021 06:41:52 -0500
Message-Id: <20210120114158.104559-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120114158.104559-1-frankja@linux.ibm.com>
References: <20210120114158.104559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 mlxscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Availability of SIE is announced via a feature bit in a SCLP info CPU
entry. Let's add a framework that allows us to easily check for such
facilities.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/io.c   |  1 +
 lib/s390x/sclp.c | 25 +++++++++++++++++++++++++
 lib/s390x/sclp.h | 13 ++++++++++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index 6a1da63..ef9f59e 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -35,6 +35,7 @@ void setup(void)
 	setup_args_progname(ipl_args);
 	setup_facilities();
 	sclp_read_info();
+	sclp_facilities_setup();
 	sclp_console_setup();
 	sclp_memory_setup();
 	smp_setup();
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 12916f5..06819a6 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -25,6 +25,7 @@ static uint64_t max_ram_size;
 static uint64_t ram_size;
 char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 static ReadInfo *read_info;
+struct sclp_facilities sclp_facilities;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static volatile bool sclp_busy;
@@ -128,6 +129,30 @@ CPUEntry *sclp_get_cpu_entries(void)
 	return (CPUEntry *)(_read_info + read_info->offset_cpu);
 }
 
+void sclp_facilities_setup(void)
+{
+	unsigned short cpu0_addr = stap();
+	CPUEntry *cpu;
+	int i;
+
+	assert(read_info);
+
+	cpu = sclp_get_cpu_entries();
+	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
+		/*
+		 * The logic for only reading the facilities from the
+		 * boot cpu comes from the kernel. I haven't yet found
+		 * documentation that explains why this is necessary
+		 * but I figure there's a reason behind doing it this
+		 * way.
+		 */
+		if (cpu->address == cpu0_addr) {
+			sclp_facilities.has_sief2 = cpu->feat_sief2;
+			break;
+		}
+	}
+}
+
 /* Perform service call. Return 0 on success, non-zero otherwise. */
 int sclp_service_call(unsigned int command, void *sccb)
 {
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index f005bd0..c3128b9 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -92,12 +92,22 @@ typedef struct SCCBHeader {
 typedef struct CPUEntry {
     uint8_t address;
     uint8_t reserved0;
-    uint8_t features[SCCB_CPU_FEATURE_LEN];
+    uint8_t : 4;
+    uint8_t feat_sief2 : 1;
+    uint8_t : 3;
+    uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
     uint8_t reserved2[6];
     uint8_t type;
     uint8_t reserved1;
 } __attribute__((packed)) CPUEntry;
 
+extern struct sclp_facilities sclp_facilities;
+
+struct sclp_facilities {
+	uint64_t has_sief2 : 1;
+	uint64_t : 63;
+};
+
 typedef struct ReadInfo {
     SCCBHeader h;
     uint16_t rnmax;
@@ -271,6 +281,7 @@ void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
 CPUEntry *sclp_get_cpu_entries(void);
+void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
-- 
2.25.1

