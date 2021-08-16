Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510EC3ED6C2
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhHPNX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:23:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56136 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239401AbhHPNVv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:51 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD2TMT097823;
        Mon, 16 Aug 2021 09:21:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=3Y19CXmm/JaRXc9yYEu70lMSNwyw0BVxcsIC/icP+wI=;
 b=BSNlmBeQ1tpSdUY/yzAnfeKcGhguX+vHbHnWouZmVqCQ1e6tMp11rEFuNbU358593QOy
 qJqx97ejiwvhPhRrbQzckP8WzoXzH5YHna8zmMKNaF47LRigpNdFB/HITKQxwZ8RfrL2
 1gxZXcl4fsmLsGBzLbyl8/M+b5SUuoAqUGfS40sTGs0eydi7kvdufbrJGvUTtwTARoiQ
 Gdhitpj2Hawfru9KPgIkL5oNktfIeeqPVl/5OMd/aL/VTsDWx61ZIGLIrkgJ+zcmBo2d
 3rDTTGIs+aezVuwVjtbSDVtuMtpMuInc2qXhHwqspVkTmJXOJ+1+dM5HHINhOQBdnWhx fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeu4c7u0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:19 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD2lCo099624;
        Mon, 16 Aug 2021 09:21:19 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeu4c7u01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:19 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDD1Ix020421;
        Mon, 16 Aug 2021 13:21:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8ba01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDHmYa55312798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:17:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2694511C04A;
        Mon, 16 Aug 2021 13:21:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92C7711C04C;
        Mon, 16 Aug 2021 13:21:13 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 08/11] s390x: lib: Simplify stsi_get_fc and move it to library
Date:   Mon, 16 Aug 2021 15:20:51 +0200
Message-Id: <20210816132054.60078-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZG7k9r_sVTWsbUBFlq0waE3OSk85TqTm
X-Proofpoint-GUID: eAT27FgL_KuA9WMhayd4CpLK96IaX42U
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

stsi_get_fc is now needed in multiple tests.

As it does not need to store information but only returns
the machine level, suppress the address parameter.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/kvm/1628612544-25130-3-git-send-email-pmorel@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
 s390x/stsi.c             | 20 ++------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 15cf7d48..2f70d840 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -328,6 +328,22 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
 	return cc;
 }
 
+static inline unsigned long stsi_get_fc(void)
+{
+	register unsigned long r0 asm("0") = 0;
+	register unsigned long r1 asm("1") = 0;
+	int cc;
+
+	asm volatile("stsi	0\n"
+		     "ipm	%[cc]\n"
+		     "srl	%[cc],28\n"
+		     : "+d" (r0), [cc] "=d" (cc)
+		     : "d" (r1)
+		     : "cc", "memory");
+	assert(!cc);
+	return r0 >> 28;
+}
+
 static inline int servc(uint32_t command, unsigned long sccb)
 {
 	int cc;
diff --git a/s390x/stsi.c b/s390x/stsi.c
index 87d48047..391f8849 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -71,28 +71,12 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
-static inline unsigned long stsi_get_fc(void *addr)
-{
-	register unsigned long r0 asm("0") = 0;
-	register unsigned long r1 asm("1") = 0;
-	int cc;
-
-	asm volatile("stsi	0(%[addr])\n"
-		     "ipm	%[cc]\n"
-		     "srl	%[cc],28\n"
-		     : "+d" (r0), [cc] "=d" (cc)
-		     : "d" (r1), [addr] "a" (addr)
-		     : "cc", "memory");
-	assert(!cc);
-	return r0 >> 28;
-}
-
 static void test_fc(void)
 {
 	report(stsi(pagebuf, 7, 0, 0) == 3, "invalid fc");
 	report(stsi(pagebuf, 1, 0, 1) == 3, "invalid selector 1");
 	report(stsi(pagebuf, 1, 1, 0) == 3, "invalid selector 2");
-	report(stsi_get_fc(pagebuf) >= 2, "query fc >= 2");
+	report(stsi_get_fc() >= 2, "query fc >= 2");
 }
 
 static void test_3_2_2(void)
@@ -112,7 +96,7 @@ static void test_3_2_2(void)
 	report_prefix_push("3.2.2");
 
 	/* Is the function code available at all? */
-	if (stsi_get_fc(pagebuf) < 3) {
+	if (stsi_get_fc() < 3) {
 		report_skip("Running under lpar, no level 3 to test.");
 		goto out;
 	}
-- 
2.31.1

