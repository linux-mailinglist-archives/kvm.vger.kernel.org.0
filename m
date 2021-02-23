Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE67D322C31
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhBWOZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:25:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233017AbhBWOZR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:25:17 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NE46Bl036766
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:24:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ihKgsX+Xvj1b+4CYCRnNF8GkOKWoFKmipY+GeYpJLS4=;
 b=G6Ml0enUTRuBpd5ZgDKlbcVOoh1rzWHpaL9O3rYxCY4K+uEvCgmz1Fk1amQk5SCrNnOw
 I68Q4+PemkW1wnY1c/xPupTc2SWv7WCb6JuFIZktmjlV10vZnCLx/F24e1Ri7dItlXMj
 401MYUTytBVfJhHlsdpVHkt9GdHVn1tjed+fhSOoF8OjlZgGnOTixgppMGyuf+v3B3Qq
 8yfNJrD1aPy2V8XHAEJXvX3B3nN4t/S5mAufrRpMFqX5c46G1dFmVHj1/fUinfaeMoF+
 LiXpXVBwwNCbwZbck+XayqqNdCpoQN7sZQs2A84fSCBVzTm44bfuNPIPCzj71OUwaEvu NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfuasa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:24:37 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NEI2Vt083290
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:24:36 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfuas9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:24:36 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NEMvC7014528;
        Tue, 23 Feb 2021 14:24:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 36tt289dcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:24:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NEOVGT37487058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:24:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FC54A404D;
        Tue, 23 Feb 2021 14:24:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B73A4A4053;
        Tue, 23 Feb 2021 14:24:30 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.213])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:24:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/2] s390x: introduce leave_pstate to leave userspace
Date:   Tue, 23 Feb 2021 15:24:28 +0100
Message-Id: <20210223142429.256420-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210223142429.256420-1-imbrenda@linux.ibm.com>
References: <20210223142429.256420-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_07:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230119
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

