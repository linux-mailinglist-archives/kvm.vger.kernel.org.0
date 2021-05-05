Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F6E373685
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhEEIoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232186AbhEEIof (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:35 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458XZn3085905;
        Wed, 5 May 2021 04:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=n4y0JBR5dkYGehv58NVWc1GLx0lZdEKuACSBeg/Iu5Y=;
 b=gIro+VOMDGwITuzWe3fItSOTKBg6wAr0tnoNES86G4/12utXNiuLKpoAQQl0sQz+PaeY
 pT+Ws21es8aporNj/+Sxq35OTS+PlpJCuCwrRs5uOl4mXeL4dUqQaf6L9ul+yTInkGhK
 zQh0LU4mYj1xB1prb1mH0JKL7uO58FfAVxXsA+SKcg3f5bwHoECGFBLPYQaAS1W4bywc
 T22iaP2y+xQT726YR5jKmlacy7e1XlrdOdnsZ2RvVpCn1IEsXSAiDpctPIeC8hpSlQ/I
 9BheKFWy9goIvm6vV0eByGyw/XLo6IYwGchmagwzgxFfb7sGbZWnhoY3GnlNTWmS8okg NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bn4dmm3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:39 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458Y8Zf092133;
        Wed, 5 May 2021 04:43:38 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bn4dmm1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:38 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458hGRH022563;
        Wed, 5 May 2021 08:43:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 38beeeg6d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458hX8v32702910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F5A5A4060;
        Wed,  5 May 2021 08:43:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1608A405B;
        Wed,  5 May 2021 08:43:32 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 9/9] s390x: Fix vector stfle checks
Date:   Wed,  5 May 2021 10:43:01 +0200
Message-Id: <20210505084301.17395-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fgJwIVgq_I3TfvP2cH6VN5iGsXnsb5rr
X-Proofpoint-ORIG-GUID: 48rPAs1nla-TbyMSVAE5FMf73-XaUhrh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_03:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

134 is for bcd
135 is for the vector enhancements

Not the other way around...

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
---
 s390x/vector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/vector.c b/s390x/vector.c
index d1b6a571..b052de55 100644
--- a/s390x/vector.c
+++ b/s390x/vector.c
@@ -53,7 +53,7 @@ static void test_add(void)
 /* z14 vector extension test */
 static void test_ext1_nand(void)
 {
-	bool has_vext = test_facility(134);
+	bool has_vext = test_facility(135);
 	static struct prm {
 		__uint128_t a,b,c;
 	} prm __attribute__((aligned(16)));
@@ -79,7 +79,7 @@ static void test_ext1_nand(void)
 /* z14 bcd extension test */
 static void test_bcd_add(void)
 {
-	bool has_bcd = test_facility(135);
+	bool has_bcd = test_facility(134);
 	static struct prm {
 		__uint128_t a,b,c;
 	} prm __attribute__((aligned(16)));
-- 
2.30.2

