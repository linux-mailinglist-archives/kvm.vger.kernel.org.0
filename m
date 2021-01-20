Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989FF2FD0B4
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbhATMtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:49:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388422AbhATLoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:44:19 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KBW7nY090362;
        Wed, 20 Jan 2021 06:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+FfkXdWYebos2clkzLVyEgWeTbvO+szMa/ukzMxeJyE=;
 b=gsLrV7qVMMVRTOQ0+nxQ6ImxwRbbfw+wF2luEvV64wGu1Acy5HrlKw9bUimgHbAFVMxQ
 IcGbc9OWbvBOiBMbDeT4X8DrN+HN3SEBRlJT9XixeJTqn+oTr4z/9iME8sBXnWIzd4HF
 c6kFvv6Y6gXDbEvZaSkzywMzbJfixy28Kpfa6hvQJEoYCdK7uFuzFZtCM72wDh/du4gd
 ePbXl88xmhRQE2+xDCoSJZaUbbTOn73UtnXFaZi09z3SVRx71/UU/nVsydEhuhUTcplf
 CNN9/y1675BC7bZ3P3k5zTbnIqlmZBklN8l7wB+66zpP8yMFX3TpPZW7ADlCW1j5XL4o 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366kqv0b6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:37 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KBXMKZ094385;
        Wed, 20 Jan 2021 06:43:37 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366kqv0b5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:37 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KBhGuf008412;
        Wed, 20 Jan 2021 11:43:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3668p7894s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:43:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KBhWvS44106078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 11:43:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1E01AE051;
        Wed, 20 Jan 2021 11:43:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 273B8AE04D;
        Wed, 20 Jan 2021 11:43:31 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 11:43:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 04/11] s390x: Consolidate sclp read info
Date:   Wed, 20 Jan 2021 06:41:51 -0500
Message-Id: <20210120114158.104559-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120114158.104559-1-frankja@linux.ibm.com>
References: <20210120114158.104559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only read the information once and pass a pointer to it instead
of calling sclp multiple times.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/io.c   |  1 +
 lib/s390x/sclp.c | 31 +++++++++++++++++++++++++------
 lib/s390x/sclp.h |  3 +++
 lib/s390x/smp.c  | 27 +++++++++++----------------
 4 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index 1ff0589..6a1da63 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -34,6 +34,7 @@ void setup(void)
 {
 	setup_args_progname(ipl_args);
 	setup_facilities();
+	sclp_read_info();
 	sclp_console_setup();
 	sclp_memory_setup();
 	smp_setup();
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 08a4813..12916f5 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -23,6 +23,8 @@ extern unsigned long stacktop;
 static uint64_t storage_increment_size;
 static uint64_t max_ram_size;
 static uint64_t ram_size;
+char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+static ReadInfo *read_info;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static volatile bool sclp_busy;
@@ -108,6 +110,24 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
 	report_abort("READ_SCP_INFO failed");
 }
 
+void sclp_read_info(void)
+{
+	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
+	read_info = (ReadInfo *)_read_info;
+}
+
+int sclp_get_cpu_num(void)
+{
+	assert(read_info);
+	return read_info->entries_cpu;
+}
+
+CPUEntry *sclp_get_cpu_entries(void)
+{
+	assert(read_info);
+	return (CPUEntry *)(_read_info + read_info->offset_cpu);
+}
+
 /* Perform service call. Return 0 on success, non-zero otherwise. */
 int sclp_service_call(unsigned int command, void *sccb)
 {
@@ -125,23 +145,22 @@ int sclp_service_call(unsigned int command, void *sccb)
 
 void sclp_memory_setup(void)
 {
-	ReadInfo *ri = (void *)_sccb;
 	uint64_t rnmax, rnsize;
 	int cc;
 
-	sclp_read_scp_info(ri, SCCB_SIZE);
+	assert(read_info);
 
 	/* calculate the storage increment size */
-	rnsize = ri->rnsize;
+	rnsize = read_info->rnsize;
 	if (!rnsize) {
-		rnsize = ri->rnsize2;
+		rnsize = read_info->rnsize2;
 	}
 	storage_increment_size = rnsize << 20;
 
 	/* calculate the maximum memory size */
-	rnmax = ri->rnmax;
+	rnmax = read_info->rnmax;
 	if (!rnmax) {
-		rnmax = ri->rnmax2;
+		rnmax = read_info->rnmax2;
 	}
 	max_ram_size = rnmax * storage_increment_size;
 
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index a8f58f5..f005bd0 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -268,6 +268,9 @@ void sclp_wait_busy(void);
 void sclp_mark_busy(void);
 void sclp_console_setup(void);
 void sclp_print(const char *str);
+void sclp_read_info(void);
+int sclp_get_cpu_num(void);
+CPUEntry *sclp_get_cpu_entries(void);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 423970b..ee68d67 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -23,7 +23,6 @@
 #include "smp.h"
 #include "sclp.h"
 
-static char cpu_info_buffer[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static struct cpu *cpus;
 static struct cpu *cpu0;
 static struct spinlock lock;
@@ -32,8 +31,7 @@ extern void smp_cpu_setup_state(void);
 
 int smp_query_num_cpus(void)
 {
-	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
-	return info->nr_configured;
+	return sclp_get_cpu_num();
 }
 
 struct cpu *smp_cpu_from_addr(uint16_t addr)
@@ -226,10 +224,10 @@ void smp_teardown(void)
 {
 	int i = 0;
 	uint16_t this_cpu = stap();
-	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
+	int num = smp_query_num_cpus();
 
 	spin_lock(&lock);
-	for (; i < info->nr_configured; i++) {
+	for (; i < num; i++) {
 		if (cpus[i].active &&
 		    cpus[i].addr != this_cpu) {
 			sigp_retry(cpus[i].addr, SIGP_STOP, 0, NULL);
@@ -243,22 +241,19 @@ extern uint64_t *stackptr;
 void smp_setup(void)
 {
 	int i = 0;
+	int num = smp_query_num_cpus();
 	unsigned short cpu0_addr = stap();
-	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
+	struct CPUEntry *entry = sclp_get_cpu_entries();
 
 	spin_lock(&lock);
-	sclp_mark_busy();
-	info->h.length = PAGE_SIZE;
-	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
+	if (num > 1)
+		printf("SMP: Initializing, found %d cpus\n", num);
 
-	if (smp_query_num_cpus() > 1)
-		printf("SMP: Initializing, found %d cpus\n", info->nr_configured);
-
-	cpus = calloc(info->nr_configured, sizeof(cpus));
-	for (i = 0; i < info->nr_configured; i++) {
-		cpus[i].addr = info->entries[i].address;
+	cpus = calloc(num, sizeof(cpus));
+	for (i = 0; i < num; i++) {
+		cpus[i].addr = entry[i].address;
 		cpus[i].active = false;
-		if (info->entries[i].address == cpu0_addr) {
+		if (entry[i].address == cpu0_addr) {
 			cpu0 = &cpus[i];
 			cpu0->stack = stackptr;
 			cpu0->lowcore = (void *)0;
-- 
2.25.1

