Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F726509B33
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 10:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386941AbiDUIxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 04:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386937AbiDUIxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 04:53:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ED21CB3A;
        Thu, 21 Apr 2022 01:50:28 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L6jIQ7011662;
        Thu, 21 Apr 2022 08:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OCevSBTVZLO9hybnaROiU4MfB5/63o3++UYROEzYc1w=;
 b=DyfHTt2AADNZmnNJNiRb6iVBSDidLzduwpH4dN0Eq2TmXH9YyrWD/G+9Nye0QJlhCQIO
 mvyvfIIJ39vBkWdRmnn80pmupfLAL8a2KHpHP4x7Dr51FlDMDJs3M8Mbv29NRweKI4w2
 Qz8D8gQdJ3rWBiJELINMPnvyRTrFs37OXrFb52epbEjfwXjNRRjvpOhU44skUHRk81Wo
 pt6b1Chtxg9l8pQJvimiwWsR12XlWp2wh80tES7f2/IDO6Y92A2G3gpCPqJkZ8vb5O0F
 qfnoXBbBw7Fq7bTujO5RlENYVEb6ADZQKPnYbIC7f0Lm/s8RA+ASg4kiL1/kkcYFEBdP Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff3gsnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:28 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L8jK3O013336;
        Thu, 21 Apr 2022 08:50:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff3gsmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:27 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L8S6qk015752;
        Thu, 21 Apr 2022 08:50:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3ffvt9dk4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L8bWB144761464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 08:37:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B364A4051;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32476A4053;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/3] s390x: epsw: fix report_pop_prefix() when running under non-QEMU
Date:   Thu, 21 Apr 2022 10:50:19 +0200
Message-Id: <20220421085021.1651688-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220421085021.1651688-1-nrb@linux.ibm.com>
References: <20220421085021.1651688-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5zB65PVo_uPKjA00f_Oisnuxz_kEQ5Eq
X-Proofpoint-ORIG-GUID: _9dj-qu410BpOJI8My6ABoe7JhpufF6g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we don't run in QEMU, we didn't push a prefix, hence pop won't work. Fix
this by pushing the prefix before the QEMU check.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
---
 s390x/epsw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/epsw.c b/s390x/epsw.c
index 5b73f4b3db6c..d8090d95a486 100644
--- a/s390x/epsw.c
+++ b/s390x/epsw.c
@@ -97,13 +97,13 @@ static void test_epsw(void)
 
 int main(int argc, char **argv)
 {
+	report_prefix_push("epsw");
+
 	if (!host_is_kvm() && !host_is_tcg()) {
 		report_skip("Not running under QEMU");
 		goto done;
 	}
 
-	report_prefix_push("epsw");
-
 	test_epsw();
 
 done:
-- 
2.31.1

