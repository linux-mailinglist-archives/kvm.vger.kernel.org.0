Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73AC1B7260
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 12:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgDXKqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 06:46:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgDXKqE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 06:46:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OAWEIs097169;
        Fri, 24 Apr 2020 06:46:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrc6us8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 06:46:03 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03OAWFoT097271;
        Fri, 24 Apr 2020 06:46:03 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrc6us7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 06:46:03 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03OAjWGx007923;
        Fri, 24 Apr 2020 10:46:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 30fs658x5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 10:46:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OAjwn540304800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 10:45:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CBA0A406F;
        Fri, 24 Apr 2020 10:45:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C857A4040;
        Fri, 24 Apr 2020 10:45:58 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.79.138])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 10:45:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v6 10/10] s390x: css: ping pong
Date:   Fri, 24 Apr 2020 12:45:52 +0200
Message-Id: <1587725152-25569-11-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_04:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 phishscore=0 mlxscore=0 suspectscore=1
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To test a write command with the SSCH instruction we need a QEMU device,
with control unit type 0xC0CA. The PONG device is such a device.

This type of device responds to PONG_WRITE requests by incrementing an
integer, stored as a string at offset 0 of the CCW data.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index b9dbf01..7cd8731 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -23,6 +23,12 @@
 #define PSW_PRG_MASK (PSW_MASK_EA | PSW_MASK_BA)
 
 #define PONG_CU_TYPE		0xc0ca
+/* Channel Commands for PONG device */
+#define PONG_WRITE	0x21 /* Write */
+#define PONG_READ	0x22 /* Read buffer */
+
+#define BUFSZ	9
+static char buffer[BUFSZ];
 
 struct lowcore *lowcore = (void *)0x0;
 
@@ -262,6 +268,53 @@ unreg_cb:
 	unregister_io_int_func(irq_io);
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
+	result = register_io_int_func(irq_io);
+	if (result) {
+		report(0, "Could not register IRQ handler");
+		return;
+	}
+
+	while (cnt++ < max) {
+		snprintf(buffer, BUFSZ, "%08x\n", cnt);
+		success = start_subchannel(PONG_WRITE, buffer, BUFSZ);
+		if (!success) {
+			report(0, "start_subchannel failed");
+			goto unreg_cb;
+		}
+
+		wfi(PSW_MASK_IO);
+
+		success = start_subchannel(PONG_READ, buffer, BUFSZ);
+		if (!success) {
+			report(0, "start_subchannel failed");
+			goto unreg_cb;
+		}
+
+		wfi(PSW_MASK_IO);
+
+		result = atol(buffer);
+		if (result != (cnt + 1)) {
+			report(0, "Bad answer from pong: %08x - %08x",
+			       cnt, result);
+			goto unreg_cb;
+		}
+	}
+	report(1, "ping-pong count 0x%08x", cnt);
+
+unreg_cb:
+	unregister_io_int_func(irq_io);
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -269,6 +322,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "ping-pong (ssch/tsch)", test_ping },
 	{ NULL, NULL }
 };
 
-- 
2.25.1

