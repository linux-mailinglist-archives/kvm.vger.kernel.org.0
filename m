Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B090A46528C
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 17:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351420AbhLAQNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 11:13:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1351397AbhLAQMq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Dec 2021 11:12:46 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1FBhND002239
        for <kvm@vger.kernel.org>; Wed, 1 Dec 2021 16:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gMXlWQpTv2o3MQmkizQTdhfpg7GduVKpeSUPw/TGKfk=;
 b=gSy1wiiyceGTrNVzu76oYsGdJHB7Ro/H2NzLS+xSDmYaQ+OVk9/YSelbuoE2sLx70TJA
 21jiTRtKDP7+OEtxY7keUebDVelXZcx+lvZTZLW2gfqftt1jbi0HaU1Fc4lSrphEk+KF
 jEoEc1w6rfusm13oJ2cnH4Z984Kxv2E7GozpJ5CSCYF9Gdz+x+PFpvv6HT9CaCrI/MND
 Qt9gqyaLsKcmSe99w0z3msLqAIub8dcx0dRf/9rcWHl/EnaDzXipedsqjlGyc6aoYkZ3
 19YPkEBVqkAZR1VRHgZudTBBlVJMOQjix7Ibfdtebq6C6lYdGjz3XxM6GyuuRCaEpcl7 eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cpb6m219d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 16:09:24 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B1FD395011119
        for <kvm@vger.kernel.org>; Wed, 1 Dec 2021 16:09:24 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cpb6m218m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 16:09:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B1FvNgm017136;
        Wed, 1 Dec 2021 16:09:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ckcaa1u9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 16:09:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B1G1pfT19792304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 16:01:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE4FAE061;
        Wed,  1 Dec 2021 16:09:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF5BCAE059;
        Wed,  1 Dec 2021 16:09:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Dec 2021 16:09:18 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 6559EE1261; Wed,  1 Dec 2021 17:09:18 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] s390x/cpumodel: give each test a unique output line
Date:   Wed,  1 Dec 2021 17:09:17 +0100
Message-Id: <20211201160917.331509-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZWfrhVMqY7aj60eJeUrJa8fT-8uqLpop
X-Proofpoint-GUID: a46uJangq_H7H3ISoqjGjw8iN3YdQX0o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=672 clxscore=1015 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112010089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until now we had multiple tests running under the same prefix. This can
result in multiple identical lines like
SKIP: cpumodel: dependency: facility 5 not present
SKIP: cpumodel: dependency: facility 5 not present

Make this unique by adding a proper prefix.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 s390x/cpumodel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 67bb6543f4a8..12bc82c1d0ec 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -116,14 +116,15 @@ int main(void)
 
 	report_prefix_push("dependency");
 	for (i = 0; i < ARRAY_SIZE(dep); i++) {
+		report_prefix_pushf("%d implies %d", dep[i].facility, dep[i].implied);
 		if (test_facility(dep[i].facility)) {
 			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
 				     test_facility(dep[i].implied),
-				     "%d implies %d",
-				     dep[i].facility, dep[i].implied);
+				     "but not available");
 		} else {
 			report_skip("facility %d not present", dep[i].facility);
 		}
+		report_prefix_pop();
 	}
 	report_prefix_pop();
 
-- 
2.31.1

