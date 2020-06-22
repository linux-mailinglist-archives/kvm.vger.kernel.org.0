Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7680B203C6A
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgFVQVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:21:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729358AbgFVQVt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:21:49 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG0fKg017060
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:49 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysprtxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:48 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MG0nOa018016
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:47 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysprtw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:21:47 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MG124A013911;
        Mon, 22 Jun 2020 16:21:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 31sa381ejt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:21:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGLhb647644920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:21:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 302425204E;
        Mon, 22 Jun 2020 16:21:43 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DA7F752063;
        Mon, 22 Jun 2020 16:21:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 4/8] lib/alloc.c: add overflow check for calloc
Date:   Mon, 22 Jun 2020 18:21:37 +0200
Message-Id: <20200622162141.279716-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622162141.279716-1-imbrenda@linux.ibm.com>
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxlogscore=955 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 clxscore=1015 cotscore=-2147483648 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an overflow check for calloc to prevent potential multiplication overflow.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/lib/alloc.c b/lib/alloc.c
index ed8f5f9..f4aa87a 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -6,9 +6,43 @@ void *malloc(size_t size)
 	return memalign(sizeof(long), size);
 }
 
+static bool mult_overflow(size_t a, size_t b)
+{
+#if BITS_PER_LONG == 32
+	/* 32 bit system, easy case: just use u64 */
+	return (u64)a * (u64)b >= (1ULL << 32);
+#else
+#ifdef __SIZEOF_INT128__
+	/* if __int128 is available use it (like the u64 case above) */
+	unsigned __int128 res = a;
+	res *= b;
+	res >>= 64;
+	return res != 0;
+#else
+	u64 tmp;
+
+	if ((a >> 32) && (b >> 32))
+		return true;
+	if (!(a >> 32) && !(b >> 32))
+		return false;
+	tmp = (u32)a;
+	tmp *= (u32)b;
+	tmp >>= 32;
+	if (a < b)
+		tmp += a * (b >> 32);
+	else
+		tmp += b * (a >> 32);
+	return tmp >> 32;
+#endif /* __SIZEOF_INT128__ */
+#endif /* BITS_PER_LONG == 32 */
+}
+
 void *calloc(size_t nmemb, size_t size)
 {
-	void *ptr = malloc(nmemb * size);
+	void *ptr;
+
+	assert(!mult_overflow(nmemb, size));
+	ptr = malloc(nmemb * size);
 	if (ptr)
 		memset(ptr, 0, nmemb * size);
 	return ptr;
-- 
2.26.2

