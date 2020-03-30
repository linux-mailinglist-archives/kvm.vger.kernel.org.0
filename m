Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F181976F9
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 10:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgC3ItZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 04:49:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729674AbgC3ItY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 04:49:24 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U8YIbK040325;
        Mon, 30 Mar 2020 04:49:23 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfedydx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 04:49:23 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02U8YaGZ041517;
        Mon, 30 Mar 2020 04:49:23 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfedydp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 04:49:23 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02U8kvJK028660;
        Mon, 30 Mar 2020 08:49:21 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 301x76fca0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 08:49:21 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02U8nKJX23462156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 08:49:20 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6DC17805E;
        Mon, 30 Mar 2020 08:49:20 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D5D178060;
        Mon, 30 Mar 2020 08:49:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 08:49:20 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests 2/2] s390x/smp: add minimal test for sigp sense running status
Date:   Mon, 30 Mar 2020 04:49:11 -0400
Message-Id: <20200330084911.34248-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330084911.34248-1-borntraeger@de.ibm.com>
References: <20200330084911.34248-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

make sure that sigp sense running status returns a sane value for
stopped CPUs.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/s390x/smp.c |  2 +-
 lib/s390x/smp.h |  2 +-
 s390x/smp.c     | 11 +++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 5ed8b7b..492cb05 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
 	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
 }
 
-bool smp_cpu_running(uint16_t addr)
+bool smp_sense_running_status(uint16_t addr)
 {
 	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
 		return true;
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index a8b98c0..639ec92 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -40,7 +40,7 @@ struct cpu_status {
 int smp_query_num_cpus(void);
 struct cpu *smp_cpu_from_addr(uint16_t addr);
 bool smp_cpu_stopped(uint16_t addr);
-bool smp_cpu_running(uint16_t addr);
+bool smp_sense_running_status(uint16_t addr);
 int smp_cpu_restart(uint16_t addr);
 int smp_cpu_start(uint16_t addr, struct psw psw);
 int smp_cpu_stop(uint16_t addr);
diff --git a/s390x/smp.c b/s390x/smp.c
index 79cdc1f..f9f143d 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -210,6 +210,16 @@ static void test_emcall(void)
 	report_prefix_pop();
 }
 
+static void test_sense_running(void)
+{
+	report_prefix_push("sense_running");
+	/* make sure CPU is stopped */
+	smp_cpu_stop(1);
+	report(!smp_sense_running_status(1), "CPU1 sense claims not running");
+	report_prefix_pop();
+}
+
+
 /* Used to dirty registers of cpu #1 before it is reset */
 static void test_func_initial(void)
 {
@@ -319,6 +329,7 @@ int main(void)
 	test_store_status();
 	test_ecall();
 	test_emcall();
+	test_sense_running();
 	test_reset();
 	test_reset_initial();
 	smp_cpu_destroy(1);
-- 
2.25.1

