Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEA010C8DC
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 13:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfK1MqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 07:46:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726653AbfK1MqU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 07:46:20 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASCh2sg146458
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:18 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wjace0nqx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:18 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 28 Nov 2019 12:46:16 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 28 Nov 2019 12:46:14 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASCkDcW41549914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 12:46:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCF6EAE057;
        Thu, 28 Nov 2019 12:46:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56F77AE045;
        Thu, 28 Nov 2019 12:46:13 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.185.119])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Nov 2019 12:46:13 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 9/9] s390x: css: ping pong
Date:   Thu, 28 Nov 2019 13:46:07 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19112812-4275-0000-0000-000003877F4E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112812-4276-0000-0000-0000389B1128
Message-Id: <1574945167-29677-10-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_03:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=1 adultscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To test a write command with the SSCH instruction we need a QEMU device,
with control unit type 0xC0CA. The PONG device is such a device.

This type of device respond to PONG_WRITE requests by incrementing an
integer, stored as a string at offset 0 of the CCW data.

This is only a success test, no error expected.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/s390x/css.c b/s390x/css.c
index 534864f..0761e70 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -23,6 +23,10 @@
 #define SID_ONE		0x00010000
 #define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
 
+/* Local Channel Commands */
+#define PONG_WRITE	0x21 /* Write */
+#define PONG_READ	0x22 /* Read buffer */
+
 struct lowcore *lowcore = (void *)0x0;
 
 static struct schib schib;
@@ -31,7 +35,8 @@ static struct ccw ccw[NB_CCW];
 #define NB_ORB  100
 static struct orb orb[NB_ORB];
 static struct irb irb;
-static char buffer[0x1000] __attribute__ ((aligned(8)));
+#define BUF_SZ	0x1000
+static char buffer[BUF_SZ] __attribute__ ((aligned(8)));
 static struct senseid senseid;
 
 static const char *Channel_type[3] = {
@@ -224,6 +229,44 @@ static void test_sense(void)
 		report("cu_type: expect c0ca, got %04x", 0, senseid.cu_type);
 }
 
+static void test_ping(void)
+{
+	int success, result;
+	int cnt = 0, max = 4;
+
+	if (senseid.cu_type != PONG_CU) {
+		report_skip("No PONG, no ping-pong");
+		return;
+	}
+
+	enable_io_irq();
+
+	while (cnt++ < max) {
+report_info("cnt..: %08x", cnt);
+		snprintf(buffer, BUF_SZ, "%08x\n", cnt);
+		success = start_subchannel(PONG_WRITE, buffer, 8);
+		if (!success) {
+			report("start_subchannel failed", 0);
+			return;
+		}
+		delay(100);
+		success = start_subchannel(PONG_READ, buffer, 8);
+		if (!success) {
+			report("start_subchannel failed", 0);
+			return;
+		}
+		result = atol(buffer);
+		if (result != (cnt + 1)) {
+			report("Bad answer from pong: %08x - %08x", 0, cnt, result);
+			return;
+		} else 
+			report_info("%08x - %08x", cnt, result);
+
+		delay(100);
+	}
+	report("ping-pong count 0x%08x", 1, cnt);
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -231,6 +274,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "ping-pong (ssch/tsch)", test_ping },
 	{ NULL, NULL }
 };
 
-- 
2.17.0

