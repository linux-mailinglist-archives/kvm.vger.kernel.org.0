Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C8140848
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgAQKrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:47:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728775AbgAQKrG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jan 2020 05:47:06 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00HAbvjC001004
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 05:47:05 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xk0qrrhcs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 05:47:04 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 17 Jan 2020 10:47:03 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Jan 2020 10:47:01 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00HAl00D39911634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 10:47:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5324CAE045;
        Fri, 17 Jan 2020 10:47:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC0D3AE055;
        Fri, 17 Jan 2020 10:46:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.184.110])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jan 2020 10:46:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v3 7/9] s390x: smp: Remove unneeded cpu loops
Date:   Fri, 17 Jan 2020 05:46:38 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200117104640.1983-1-frankja@linux.ibm.com>
References: <20200117104640.1983-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011710-0012-0000-0000-0000037E39E2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011710-0013-0000-0000-000021BA7060
Message-Id: <20200117104640.1983-8-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_02:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 mlxlogscore=877
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a loop which is executed after we return from the
main function of a secondary cpu, we can remove the surplus loops.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 555ed72..c12a3db 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -29,15 +29,9 @@ static void wait_for_flag(void)
 	}
 }
 
-static void cpu_loop(void)
-{
-	for (;;) {}
-}
-
 static void test_func(void)
 {
 	testflag = 1;
-	cpu_loop();
 }
 
 static void test_start(void)
@@ -234,7 +228,7 @@ int main(void)
 
 	/* Setting up the cpu to give it a stack and lowcore */
 	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)cpu_loop;
+	psw.addr = (unsigned long)test_func;
 	smp_cpu_setup(1, psw);
 	smp_cpu_stop(1);
 
-- 
2.20.1

