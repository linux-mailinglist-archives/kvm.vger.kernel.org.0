Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA88431944
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJRMkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15112 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhJRMkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:17 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICHdKH020112;
        Mon, 18 Oct 2021 08:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=9BVO1I602GuYBILh8b4kBSQDuvSlQUnWFliZ7VnvJYk=;
 b=I4p5wGvQyh87E5pv7PrONmnCoL7ZSiHsG3OwEQreoifaQ5fuojpFSH3qzZOslVmrXv33
 hpETzS4y8azShKIWcGWXoGUuktrW8k9YEXgGzGyDTQtP7K9x+KyS/rntL6XCTb2lA2NE
 b3ADy+x0rQoTvqGqRZ78BDZCrRX0ZFPHvtmzVgNAlrn8A6TlQygRiGM6etnYjhqj+Bfu
 6nu9p14t0TWw7xKLgkAS03q4RpbAY8ZKsZ0sosMD0t3TCDW9dExTFSNAf5v3sv/ptZP7
 InFR+ZtEGC9c2wNRk1CGEiz/8+rSgsHAR/kMQ9ZYRoszAki6E9hHevL83vOJivDEsYTN gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs8t88cnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICIoIb022667;
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs8t88cn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbUOm021894;
        Mon, 18 Oct 2021 12:38:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0je836-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc08v54853948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 034F452050;
        Mon, 18 Oct 2021 12:38:00 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8DBFC52067;
        Mon, 18 Oct 2021 12:37:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 04/17] s390x: skey: Test for ADDRESSING exceptions
Date:   Mon, 18 Oct 2021 14:26:22 +0200
Message-Id: <20211018122635.53614-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X-BN1cRx4kP1QBefXupSAN9G8IGSrCt9
X-Proofpoint-GUID: 2nfq5lbTfjhHyn5FDt05CUNdS4WXt50I
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

... used to be broken in TCG, so let's add a very simple test for SSKE
and ISKE. In order to test RRBE as well, introduce a helper to call the
machine instruction.

Signed-off-by: David Hildenbrand <david@redhat.com>
Message-Id: <20210903162537.57178-1-david@redhat.com>
Link: https://lore.kernel.org/kvm/20210903162537.57178-1-david@redhat.com/
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/mem.h | 12 ++++++++++++
 s390x/skey.c        | 28 ++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 40b22b63..845c00cc 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -50,6 +50,18 @@ static inline unsigned char get_storage_key(void *addr)
 	return skey;
 }
 
+static inline unsigned char reset_reference_bit(void *addr)
+{
+	int cc;
+
+	asm volatile(
+		"rrbe	0,%1\n"
+		"ipm	%0\n"
+		"srl	%0,28\n"
+		: "=d" (cc) : "a" (addr) : "cc");
+	return cc;
+}
+
 #define PFMF_FSC_4K 0
 #define PFMF_FSC_1M 1
 #define PFMF_FSC_2G 2
diff --git a/s390x/skey.c b/s390x/skey.c
index 25399443..58a55436 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -120,6 +120,33 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_invalid_address(void)
+{
+	void *inv_addr = (void *)-1ull;
+
+	report_prefix_push("invalid address");
+
+	report_prefix_push("sske");
+	expect_pgm_int();
+	set_storage_key(inv_addr, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	report_prefix_push("iske");
+	expect_pgm_int();
+	get_storage_key(inv_addr);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	report_prefix_push("rrbe");
+	expect_pgm_int();
+	reset_reference_bit(inv_addr);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("skey");
@@ -128,6 +155,7 @@ int main(void)
 		goto done;
 	}
 	test_priv();
+	test_invalid_address();
 	test_set();
 	test_set_mb();
 	test_chg();
-- 
2.31.1

