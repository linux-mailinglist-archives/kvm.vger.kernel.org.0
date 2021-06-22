Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A05F3AFF2A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFVIYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:24:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230463AbhFVIX6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:58 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M8GK5t149605;
        Tue, 22 Jun 2021 04:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BbI/Rv0rcuu/SGurOdnX50suG9KrngbmPn/m0bNMIxE=;
 b=g7TNfWg6dTc1e2+4uA0uE8SdpF+LzupXMz5JkYK+LLMMC3KzvBTTPneQ5Rh4AENOorWL
 1lem2kYm81HAwqiNefP5tVBV37L7WcRQpmaO4BpBmB676bzir2NJwNixtItTeAp6lQoz
 msxM15gcMPbjvaUtewVcoYFFgzKE1kPgU1dYg6/CGdfF2aUVe0ZVejsPFB6lo2Lxox6R
 IcWTs9n5iU3Jovy3FqaZLM3P/ui2nFxUP/KPw8IdsqNq/bhz1yRZzXvWCsygsK6uxVuT
 SN7FGLGY9L1s8Ox7SRLx8L+CladFumhDaQYHAqE5Arc0Qx/E8BfmvPv9pOE/d3RveBjO DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bc73r2m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:42 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M8LfPe168633;
        Tue, 22 Jun 2021 04:21:41 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bc73r2kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:41 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8DDnd002855;
        Tue, 22 Jun 2021 08:21:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3998789a7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8Lbdv31654282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3345AE051;
        Tue, 22 Jun 2021 08:21:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EC39AE04D;
        Tue, 22 Jun 2021 08:21:36 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 10/12] s390x: lib: add teid union and clear teid from lowcore
Date:   Tue, 22 Jun 2021 10:20:40 +0200
Message-Id: <20210622082042.13831-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fXwCdxWEhly9pe09NLJd2Cv26OS7z4Z-
X-Proofpoint-GUID: CzDE4b4nxqjFrFV5BSt86zqjhwLNobBZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Add a union to represent Translation-Exception Identification (TEID).

Clear the TEID in expect_pgm_int clear_pgm_int.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210611140705.553307-6-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 24 ++++++++++++++++++++++++
 lib/s390x/interrupt.c     |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index bf0eb40d..d9ab0bd7 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -13,6 +13,30 @@
 #define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
+#define TEID_ASCE_PRIMARY	0
+#define TEID_ASCE_AR		1
+#define TEID_ASCE_SECONDARY	2
+#define TEID_ASCE_HOME		3
+
+union teid {
+	unsigned long val;
+	struct {
+		unsigned long addr:52;
+		unsigned long fetch:1;
+		unsigned long store:1;
+		unsigned long reserved:6;
+		unsigned long acc_list_prot:1;
+		/*
+		 * depending on the exception and the installed facilities,
+		 * the m field can indicate several different things,
+		 * including whether the exception was triggered by a MVPG
+		 * instruction, or whether the addr field is meaningful
+		 */
+		unsigned long m:1;
+		unsigned long asce_id:2;
+	};
+};
+
 void register_pgm_cleanup_func(void (*f)(void));
 void handle_pgm_int(struct stack_frame_int *stack);
 void handle_ext_int(struct stack_frame_int *stack);
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index ce0003de..b627942f 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -22,6 +22,7 @@ void expect_pgm_int(void)
 {
 	pgm_int_expected = true;
 	lc->pgm_int_code = 0;
+	lc->trans_exc_id = 0;
 	mb();
 }
 
@@ -39,6 +40,7 @@ uint16_t clear_pgm_int(void)
 	mb();
 	code = lc->pgm_int_code;
 	lc->pgm_int_code = 0;
+	lc->trans_exc_id = 0;
 	pgm_int_expected = false;
 	return code;
 }
-- 
2.31.1

