Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178C8431961
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhJRMk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231749AbhJRMkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:22 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICAUco020629;
        Mon, 18 Oct 2021 08:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rzmIAsRGWANLESeNOuqGr3vOeFcYlHGEruLEF2uciFM=;
 b=RVO5d29v2KHA7vcP35sZFrcVgrF95eZ9++tMzh5mIlTRevoUTPkZCheuK/QmbUkdkCcz
 bopQd1N0KG2X53KQ89HrturMWjfRSVuoonE34k1LP+d8W/VwXK7p3WZAgngbOrmcSHnM
 NhTeFGqPvkKB68bnblzG4HvCj7Tt3HbEdlj8SPAVbN5yk91BDVQq9wcYHn+KPoiARKza
 q2bn1cW5+fgvhMNY5a0LQuF4zY//6spucCbe4g4yu0g6ZH97QWEtbuBXa8Q7cOw1gYHE
 gIFG+k2VxoHo3sy6xG0YCNswECgTR811Xcqe1WGwgTbNFraupGk3Y72uoNm+kEaCpJsP wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs419f0hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:10 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19IBiwnj024234;
        Mon, 18 Oct 2021 08:38:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs419f0hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICc3NQ000901;
        Mon, 18 Oct 2021 12:38:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpca670m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICWHp952756808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:32:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35F5E52054;
        Mon, 18 Oct 2021 12:38:04 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BA4455204E;
        Mon, 18 Oct 2021 12:38:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 12/17] s390x: Add sthyi cc==0 r2+1 verification
Date:   Mon, 18 Oct 2021 14:26:30 +0200
Message-Id: <20211018122635.53614-13-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f9qORYkQfa9-X9M94t_keyeqhr5xS0Zm
X-Proofpoint-ORIG-GUID: oxLltkpn1WHIWZyUvfgR5h5qzcZNQ9Y5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On success r2 + 1 should be 0, let's also check for that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/sthyi.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/s390x/sthyi.c b/s390x/sthyi.c
index db90b56f..11487a0e 100644
--- a/s390x/sthyi.c
+++ b/s390x/sthyi.c
@@ -24,16 +24,16 @@ static inline int sthyi(uint64_t vaddr, uint64_t fcode, uint64_t *rc,
 {
 	register uint64_t code asm("0") = fcode;
 	register uint64_t addr asm("2") = vaddr;
-	register uint64_t rc3 asm("3") = 0;
+	register uint64_t rc3 asm("3") = 42;
 	int cc = 0;
 
-	asm volatile(".insn rre,0xB2560000,%[r1],%[r2]\n"
-		     "ipm	 %[cc]\n"
-		     "srl	 %[cc],28\n"
-		     : [cc] "=d" (cc)
-		     : [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1),
-		       [r2] "i" (r2)
-		     : "memory", "cc", "r3");
+	asm volatile(
+		".insn   rre,0xB2560000,%[r1],%[r2]\n"
+		"ipm     %[cc]\n"
+		"srl     %[cc],28\n"
+		: [cc] "=d" (cc), "+d" (rc3)
+		: [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1), [r2] "i" (r2)
+		: "memory", "cc");
 	if (rc)
 		*rc = rc3;
 	return cc;
@@ -139,16 +139,19 @@ static void test_fcode0(void)
 	struct sthyi_hdr_sctn *hdr;
 	struct sthyi_mach_sctn *mach;
 	struct sthyi_par_sctn *par;
+	uint64_t rc = 42;
+	int cc;
 
 	/* Zero destination memory. */
 	memset(pagebuf, 0, PAGE_SIZE);
 
 	report_prefix_push("fcode 0");
-	sthyi((uint64_t)pagebuf, 0, NULL, 0, 2);
+	cc = sthyi((uint64_t)pagebuf, 0, &rc, 0, 2);
 	hdr = (void *)pagebuf;
 	mach = (void *)pagebuf + hdr->INFMOFF;
 	par = (void *)pagebuf + hdr->INFPOFF;
 
+	report(cc == 0 && rc == CODE_SUCCES, "r2 + 1 == 0");
 	test_fcode0_hdr(hdr);
 	test_fcode0_mach(mach);
 	test_fcode0_par(par);
-- 
2.31.1

