Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637263310E3
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhCHOd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:33:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229813AbhCHOdu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:50 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EWlvH160899;
        Mon, 8 Mar 2021 09:33:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bwHWb20cPXv+r++yVhGSdLgL6ecc18I1ozAf+D+1u4Y=;
 b=OyALLQoVtxLdhv2TrRlRDaskPANncZlGcXUEuUWhXZqXre6ZaDMgcApzRfKrESBgiiRC
 2xm/NiXkhDYJH7oAhqI98cvYtS8bfA01aajs5Qza3NdcvdgfAcylSFuyQ97JflzFjaFj
 pU07BBFSwM8paIIVXFjNu9UgGdWf+QkzXadVqiQxkdkws+hdbGIzwaUsLhpt5hxjLAMx
 h2aIJT33Xz5rOM/qQiq8RyDtdZkCGN8zzB4DxDgyggMaeTpnPPbdFWyw1RHxv5ndPiI+
 PHzX8izKZvprWmN+7Y5lovdqBpE7A+YDMtbicz79U8ckYg+H6sdOIYKC1itmJWzmbbyf ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375nsk80ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:49 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXWYf166833;
        Mon, 8 Mar 2021 09:33:49 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375nsk80tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:49 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EWLpc010718;
        Mon, 8 Mar 2021 14:33:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3741c89020-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXiC541812378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54B59A4051;
        Mon,  8 Mar 2021 14:33:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD89BA404D;
        Mon,  8 Mar 2021 14:33:43 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:43 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 14/16] s390x: introduce leave_pstate to leave userspace
Date:   Mon,  8 Mar 2021 15:31:45 +0100
Message-Id: <20210308143147.64755-15-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

In most testcases, we enter problem state (userspace) just to test if a
privileged instruction causes a fault. In some cases, though, we need
to test if an instruction works properly in userspace. This means that
we do not expect a fault, and we need an orderly way to leave problem
state afterwards.

This patch introduces a simple system based on the SVC instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/kvm/20210302114107.501837-2-imbrenda@linux.ibm.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  7 +++++++
 lib/s390x/interrupt.c    | 12 ++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 76cb7b33..7e2c5e62 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -190,6 +190,8 @@ struct cpuid {
 	uint64_t reserved : 15;
 };
 
+#define SVC_LEAVE_PSTATE 1
+
 static inline unsigned short stap(void)
 {
 	unsigned short cpu_address;
@@ -293,6 +295,11 @@ static inline void enter_pstate(void)
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
index d9832bc0..ce0003de 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -223,6 +223,14 @@ int unregister_io_int_func(void (*f)(void))
 
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
2.29.2

