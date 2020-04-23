Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0BF1B57D6
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgDWJKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:10:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726690AbgDWJKb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 05:10:31 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03N936VM114920
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 05:10:31 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghu8uyrv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 05:10:30 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 23 Apr 2020 10:09:41 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Apr 2020 10:09:39 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03N9AOjj61276282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 09:10:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE9104C046;
        Thu, 23 Apr 2020 09:10:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E394C040;
        Thu, 23 Apr 2020 09:10:24 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 09:10:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v2 06/10] s390x: smp: Remove unneeded cpu loops
Date:   Thu, 23 Apr 2020 05:10:09 -0400
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423091013.11587-1-frankja@linux.ibm.com>
References: <20200423091013.11587-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042309-4275-0000-0000-000003C51E01
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042309-4276-0000-0000-000038DAA823
Message-Id: <20200423091013.11587-7-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_06:2020-04-22,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=807
 suspectscore=1 bulkscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a loop which is executed after we return from the
main function of a secondary cpu, we can remove the surplus loops.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 s390x/smp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index a8e3dd7..7462211 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -35,15 +35,9 @@ static void set_flag(int val)
 	mb();
 }
 
-static void cpu_loop(void)
-{
-	for (;;) {}
-}
-
 static void test_func(void)
 {
 	set_flag(1);
-	cpu_loop();
 }
 
 static void test_start(void)
@@ -292,7 +286,7 @@ int main(void)
 
 	/* Setting up the cpu to give it a stack and lowcore */
 	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)cpu_loop;
+	psw.addr = (unsigned long)test_func;
 	smp_cpu_setup(1, psw);
 	smp_cpu_stop(1);
 
-- 
2.25.1

