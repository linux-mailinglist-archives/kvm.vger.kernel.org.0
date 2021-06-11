Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B703A43C8
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhFKOJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:09:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231700AbhFKOJJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 10:09:09 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BE5KIC000968;
        Fri, 11 Jun 2021 10:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+1cHhAcES7Soln4+1ziF00JBSR99TmnWY7SBlcglCV4=;
 b=GQ0t0GS6GIAgTme9+7M5/C/FQgAIKpxkatz2XkFgSzDnAzVSnA50+3vauRdSv2O0UBqZ
 wbpbHFugp9IFe1rk/Z0P579g4cBaqBbvHiW40oLisMF6lBFfFeBfRWxVaHWxuQCdLTpL
 B3+cVf7yBxforpM3aDT52BWy3b/SqitWKnneG5IqgWUH0GKs4o+8J020IKfXhBq9Vrju
 +ddxeP1wkxgs917e0oR8Tr+ctEL+PLPaG866HwictmyShT87ER2ioxVOucj0fbbrYV1W
 wgNDZ8GkT9uQA3a4xkA+8fMO1r/2+TaRQf4aaLdt/WqMnZyMelGwAh5CRTBQRuDUa2Qe tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3948ykrqnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:11 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BE5R9i001609;
        Fri, 11 Jun 2021 10:07:11 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3948ykrqn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:11 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15BDwhBZ010334;
        Fri, 11 Jun 2021 14:07:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3900w8bfyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 14:07:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15BE77PL19726846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 14:07:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF8805205A;
        Fri, 11 Jun 2021 14:07:06 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8AD0D52067;
        Fri, 11 Jun 2021 14:07:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 2/7] libcflat: add SZ_1M and SZ_2G
Date:   Fri, 11 Jun 2021 16:07:00 +0200
Message-Id: <20210611140705.553307-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611140705.553307-1-imbrenda@linux.ibm.com>
References: <20210611140705.553307-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SAOZub2wmm0cQnpzq3VJyHJmBPPFNvyW
X-Proofpoint-GUID: pJ3AV3AIY9a5p_pag9m7-pWc1Qgz3hJW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_05:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add SZ_1M and SZ_2G to libcflat.h

s390x needs those for large/huge pages

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/libcflat.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index f40b431d..97db9e38 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -157,7 +157,9 @@ extern void setup_vm(void);
 #define SZ_8K			(1 << 13)
 #define SZ_16K			(1 << 14)
 #define SZ_64K			(1 << 16)
+#define SZ_1M			(1 << 20)
 #define SZ_2M			(1 << 21)
 #define SZ_1G			(1 << 30)
+#define SZ_2G			(1ul << 31)
 
 #endif
-- 
2.31.1

