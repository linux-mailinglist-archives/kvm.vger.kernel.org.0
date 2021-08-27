Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1D53F9803
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244931AbhH0KST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244905AbhH0KSR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:17 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA8cUL121727
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=gH+3Pa1uCvewHefIHc5QiScz4rUaSahk+Qq8/DXcgyE=;
 b=osKQmZjSc4pXTAa0uyo4cXitwv+R5sT4ljrjH+t0/AxeHc3wTYZylWqwvYxv/363Qjs6
 ml86yTjzw5UlLoqXZju3896OwsoQvX1LmbTLaFKW7jK0H8b225VxYuqmpNA/nCCJevz8
 p0dONON59tXkNkmcws6CpULFCd+T+a1UvInGEiaHVUQs2eCU70rtGbWzj+yvJ2VvFvD0
 SuIDRwGXwqGrkYM8wGF1pLQSDYiz3QIRAzzM2dsm3PT9163Wf723eqbGK75JRWNDYoib
 ADeMAN2HCsRLk2sfaf3FvsTY+KoY3dA/ZxcWrsAVDNF65XH/z1WGwdCa5pzZQl0wVn4H JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apv5b38wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:28 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RA8o4v122654
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apv5b38vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RADEu2004885;
        Fri, 27 Aug 2021 10:17:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ajs48ka8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHMei49349096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB6324C046;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70E614C059;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 4/7] s390x: css: registering IRQ
Date:   Fri, 27 Aug 2021 12:17:17 +0200
Message-Id: <1630059440-15586-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cKAXLnKF3Xrp1hxeNpnz9U75Cl3G6qjv
X-Proofpoint-ORIG-GUID: XdQkRijmYBeKZceHuVO3d7t9KBHMkHS6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Registering IRQ for the CSS level.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     | 21 +++++++++++++++++++++
 lib/s390x/css_lib.c | 27 +++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 2005f4d7..0422f2e7 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -402,4 +402,25 @@ struct measurement_block_format1 {
 	uint32_t irq_prio_delay_time;
 };
 
+#include <asm/arch_def.h>
+static inline void disable_io_irq(void)
+{
+	uint64_t mask;
+
+	mask = extract_psw_mask();
+	mask &= ~PSW_MASK_IO;
+	load_psw_mask(mask);
+}
+
+static inline void enable_io_irq(void)
+{
+	uint64_t mask;
+
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_IO;
+	load_psw_mask(mask);
+}
+
+int register_css_irq_func(void (*f)(void));
+int unregister_css_irq_func(void (*f)(void));
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 484f9c41..a89fc93c 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -350,8 +350,29 @@ bool css_disable_mb(int schid)
 	return retry_count > 0;
 }
 
-static struct irb irb;
+static void (*css_irq_func)(void);
+
+int register_css_irq_func(void (*f)(void))
+{
+	if (css_irq_func)
+		return -1;
+	css_irq_func = f;
+	assert(register_io_int_func(css_irq_io) == 0);
+	enable_io_isc(0x80 >> IO_SCH_ISC);
+	return 0;
+}
 
+int unregister_css_irq_func(void (*f)(void))
+{
+	if (css_irq_func != f)
+		return -1;
+	enable_io_isc(0);
+	unregister_io_int_func(css_irq_io);
+	css_irq_func = NULL;
+	return 0;
+}
+
+static struct irb irb;
 void css_irq_io(void)
 {
 	int ret = 0;
@@ -386,7 +407,9 @@ void css_irq_io(void)
 		report(0, "tsch reporting sch %08x as not operational", sid);
 		break;
 	case 0:
-		/* Stay humble on success */
+		/* Call upper level IRQ routine */
+		if (css_irq_func)
+			css_irq_func();
 		break;
 	}
 pop:
-- 
2.25.1

