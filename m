Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B64431959
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhJRMkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231466AbhJRMkT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICUt6v020014;
        Mon, 18 Oct 2021 08:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ciRYMMAs4JIYwfPi9TRGmrGoNbz+hZRa8eXWDsQgHXc=;
 b=StM0KGE9qyX5uXcI4+0bfQTYSOHfhEz8BYHpc+ZqpJlT8nFxzdJEeawAPWQB9B21gprX
 r6RyUoJSaY2KLgsZh5C+7SADopYN10WKGP7LU/E54kIRDsVpcA9QTxA+4OD4TgNdINx9
 iin1cMbNXn3aIOapPD5/W2Zct7nob6ch6SZM/JbkdoE42cIDkRaAZuGsaC+c0JeLAcN8
 iKMbmWJ9j3R9q5zRF/sD7HjDXN5Jgd67R21OIrN6uTD+YPBdujECBjfBIgp2bFvTynF9
 SU/yHgDD9kwxjyqLRG9Aw33AxG3znVKGbWDjemTqJEfVvNBL/+8ZNlFt4CQw1hOXZ1dG qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs1cw9xuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:08 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19IBSdGU004575;
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs1cw9xth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbKmq031339;
        Mon, 18 Oct 2021 12:38:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9505n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc1C761080008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 930C85204F;
        Mon, 18 Oct 2021 12:38:01 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2352352054;
        Mon, 18 Oct 2021 12:38:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 07/17] s390x: uv-host: Fence a destroy cpu test on z15
Date:   Mon, 18 Oct 2021 14:26:25 +0200
Message-Id: <20211018122635.53614-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0MOjy9C9MZACiG5K8u83dfBPzAaAK9c0
X-Proofpoint-ORIG-GUID: -OGSd03BIO5Yl696CkjOReje0hkBmnii
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Firmware will not give us the expected return code on z15 so let's
fence it for the z15 machine generation.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 14 ++++++++++++++
 s390x/uv-host.c          | 11 +++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index aa80d840..c8d2722a 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -219,6 +219,20 @@ static inline unsigned short stap(void)
 	return cpu_address;
 }
 
+#define MACHINE_Z15A	0x8561
+#define MACHINE_Z15B	0x8562
+
+static inline uint16_t get_machine_id(void)
+{
+	uint64_t cpuid;
+
+	asm volatile("stidp %0" : "=Q" (cpuid));
+	cpuid = cpuid >> 16;
+	cpuid &= 0xffff;
+
+	return cpuid;
+}
+
 static inline int tprot(unsigned long addr)
 {
 	int cc;
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 4b72c24d..92a41069 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -111,6 +111,7 @@ static void test_config_destroy(void)
 static void test_cpu_destroy(void)
 {
 	int rc;
+	uint16_t machineid = get_machine_id();
 	struct uv_cb_nodata uvcb = {
 		.header.len = sizeof(uvcb),
 		.header.cmd = UVC_CMD_DESTROY_SEC_CPU,
@@ -125,10 +126,12 @@ static void test_cpu_destroy(void)
 	       "hdr invalid length");
 	uvcb.header.len += 8;
 
-	uvcb.handle += 1;
-	rc = uv_call(0, (uint64_t)&uvcb);
-	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
-	uvcb.handle -= 1;
+	if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
+		uvcb.handle += 1;
+		rc = uv_call(0, (uint64_t)&uvcb);
+		report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
+		uvcb.handle -= 1;
+	}
 
 	rc = uv_call(0, (uint64_t)&uvcb);
 	report(rc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "success");
-- 
2.31.1

