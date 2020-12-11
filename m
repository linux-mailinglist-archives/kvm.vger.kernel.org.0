Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FC92D7346
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 11:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404974AbgLKKDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 05:03:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44660 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404840AbgLKKCW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 05:02:22 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BB9kfSI043659;
        Fri, 11 Dec 2020 05:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sIvnsBOio0/wrQgTgFbG4g4BpUf5ilVZepl08ILplJQ=;
 b=mgZOO2o0KwxiXQ2S4VCmwvPO2tXGqST+JGjruXjbadkDogE8SW8ZsS/sphSDeE+T1ITL
 EG55mCpo7wrZpb+N/D7jEw1emi9Qro9dJUWp7b3BhwaANRc2BVLpLBBbMq2WsciY7B4H
 fvC6i+Z0bZ1ApTpLRMj7Z7RI8qIxLs3FL3o5WYXaQOU8Pniz9c8bHu+O9YFsUPTKH0Ta
 FGyfaNywTOmOC172E93zL5ZBuDHa1Bo8WlCF30sK5/8DFSsANrUkDsSUFK9sQUHddQ6k
 tyDjc5f9OjMhCmB7jJ1ahY62qx/kGPAcR3/wY+n+TNh98ekW3NNkryrT+U3QoepfhyjD 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6efr9nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:38 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BB9kxGw043885;
        Fri, 11 Dec 2020 05:01:37 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6efr9kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:37 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BB9rlKh022870;
        Fri, 11 Dec 2020 10:01:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u86unk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 10:01:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBA1VDb33948088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 10:01:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2094A4051;
        Fri, 11 Dec 2020 10:01:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE000A4059;
        Fri, 11 Dec 2020 10:01:30 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 10:01:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 3/8] s390x: SCLP feature checking
Date:   Fri, 11 Dec 2020 05:00:34 -0500
Message-Id: <20201211100039.63597-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211100039.63597-1-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=1 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Availability of SIE is announced via a feature bit in a SCLP info CPU
entry. Let's add a framework that allows us to easily check for such
facilities.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/io.c   |  1 +
 lib/s390x/sclp.c | 19 +++++++++++++++++++
 lib/s390x/sclp.h | 13 ++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

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
index bf1d9c0..cf6ea7c 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <asm/interrupt.h>
@@ -25,6 +26,7 @@ static uint64_t max_ram_size;
 static uint64_t ram_size;
 char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static ReadInfo *read_info;
+struct sclp_facilities sclp_facilities;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static volatile bool sclp_busy;
@@ -128,6 +130,23 @@ CPUEntry *sclp_get_cpu_entries(void)
 	return (void *)read_info + read_info->offset_cpu;
 }
 
+void sclp_facilities_setup(void)
+{
+	unsigned short cpu0_addr = stap();
+	CPUEntry *cpu;
+	int i;
+
+	assert(read_info);
+
+	cpu = (void *)read_info + read_info->offset_cpu;
+	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
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
index acd86d5..6c86037 100644
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

