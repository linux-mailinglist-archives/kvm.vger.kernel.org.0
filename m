Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5678332A717
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449041AbhCBQDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:03:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1383647AbhCBL5X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 06:57:23 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122BXLdI036558
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eGLBu8j2kuIQ2X8fG8kpVJ2IHvGVtRqXnrjQara9TlM=;
 b=Gak77mjMFF0xSdt392nYQY+yQrti3UwioTAnuWyqdgGbJ6lDTuDweztVtP3MPthNF9ov
 ieALwo67N0Qe107hXD1SVLP9E4O/DSIo0HZtTp/mjlEJuQbfgQ/D/Z/30nK2PYz/BS83
 9JbbGM23pSJE+SnyuA1l0Hw18bHAD2tphmZMzcWUPJwB5h7uBQ4yFuQfqTpfeur+1gPT
 zROJmto/2VZWc4RDDsfJAhMq9lX0yMuv+HIP9bNmVGpPiElMP5P7gjQO/vAMYnlT/oSM
 Ks6t27J4jpVllmpPJJnL3qzCEPU7s+acy9ZdoY/YSs5+EAPVpSMpB4j4uOfLU/4uu0Ln dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371mjp88fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 06:41:14 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122BXRKI037216
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:14 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371mjp88et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 06:41:14 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122BcBEt010850;
        Tue, 2 Mar 2021 11:41:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3712v50du2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 11:41:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122Bf8OC49086884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 11:41:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E6ADAE056;
        Tue,  2 Mar 2021 11:41:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38DA2AE053;
        Tue,  2 Mar 2021 11:41:08 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 11:41:08 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v4 1/3] s390x: introduce leave_pstate to leave userspace
Date:   Tue,  2 Mar 2021 12:41:05 +0100
Message-Id: <20210302114107.501837-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302114107.501837-1-imbrenda@linux.ibm.com>
References: <20210302114107.501837-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_03:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In most testcases, we enter problem state (userspace) just to test if a
privileged instruction causes a fault. In some cases, though, we need
to test if an instruction works properly in userspace. This means that
we do not expect a fault, and we need an orderly way to leave problem
state afterwards.

This patch introduces a simple system based on the SVC instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h |  7 +++++++
 lib/s390x/interrupt.c    | 12 ++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 9c4e330a..4cf8eb11 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -173,6 +173,8 @@ struct cpuid {
 	uint64_t reserved : 15;
 };
 
+#define SVC_LEAVE_PSTATE 1
+
 static inline unsigned short stap(void)
 {
 	unsigned short cpu_address;
@@ -276,6 +278,11 @@ static inline void enter_pstate(void)
 	load_psw_mask(mask);
 }
 
+static inline void leave_pstate(void)
+{
+	asm volatile("	svc %0\n" : : "i" (SVC_LEAVE_PSTATE));
+}
+
 static inline int stsi(void *addr, int fc, int sel1, int sel2)
 {
 	register int r0 asm("0") = (fc << 28) | sel1;
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 1ce36073..d0567845 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -188,6 +188,14 @@ int unregister_io_int_func(void (*f)(void))
 
 void handle_svc_int(void)
 {
-	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
-		     stap(), lc->svc_old_psw.addr);
+	uint16_t code = lc->svc_int_code;
+
+	switch (code) {
+	case SVC_LEAVE_PSTATE:
+		lc->svc_old_psw.mask &= ~PSW_MASK_PSTATE;
+		break;
+	default:
+		report_abort("Unexpected supervisor call interrupt: code %#x on cpu %d at %#lx",
+			      code, stap(), lc->svc_old_psw.addr);
+	}
 }
-- 
2.26.2

