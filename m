Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A171E092D
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 10:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbgEYIny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 04:43:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388367AbgEYInx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 04:43:53 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04P8Wpus027649;
        Mon, 25 May 2020 04:43:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316yga5ck5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 May 2020 04:43:52 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04P8X3IR028139;
        Mon, 25 May 2020 04:43:52 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316yga5cj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 May 2020 04:43:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04P8bJpC016007;
        Mon, 25 May 2020 08:43:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 316uf8uqtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 May 2020 08:43:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04P8hlkO47644708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 May 2020 08:43:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B79B42042;
        Mon, 25 May 2020 08:43:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D65794203F;
        Mon, 25 May 2020 08:43:46 +0000 (GMT)
Received: from m46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 May 2020 08:43:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, stzi@linux.ibm.com,
        mhartmay@linux.ibm.com, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: stsi: Make output tap13 compatible
Date:   Mon, 25 May 2020 10:43:40 +0200
Message-Id: <20200525084340.1454-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-25_02:2020-05-22,2020-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 cotscore=-2147483648 spamscore=0 lowpriorityscore=0 suspectscore=1
 bulkscore=0 mlxlogscore=911 mlxscore=0 clxscore=1011 malwarescore=0
 adultscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005250068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In tap13 output # is a special character and only "skip" and "todo"
are allowed to come after it. Let's appease our CI environment and
replace # with "count".

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/stsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index 66b4257..b81cea7 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -129,11 +129,11 @@ static void test_3_2_2(void)
 	}
 
 	report(!memcmp(data->vm[0].uuid, uuid, sizeof(uuid)), "uuid");
-	report(data->vm[0].conf_cpus == smp_query_num_cpus(), "cpu # configured");
+	report(data->vm[0].conf_cpus == smp_query_num_cpus(), "cpu count configured");
 	report(data->vm[0].total_cpus ==
 	       data->vm[0].reserved_cpus + data->vm[0].conf_cpus,
-	       "cpu # total == conf + reserved");
-	report(data->vm[0].standby_cpus == 0, "cpu # standby");
+	       "cpu count total == conf + reserved");
+	report(data->vm[0].standby_cpus == 0, "cpu count standby");
 	report(!memcmp(data->vm[0].name, vm_name, sizeof(data->vm[0].name)),
 	       "VM name == kvm-unit-test");
 
-- 
2.25.1

