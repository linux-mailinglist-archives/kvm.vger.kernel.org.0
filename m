Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16274E571B
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbiCWRFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245629AbiCWRFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8C94F461;
        Wed, 23 Mar 2022 10:03:36 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NFvXJF027089;
        Wed, 23 Mar 2022 17:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sQJPx3eAAAOZrJyXdl+XpTtZS2dsJVaRUcMinyI9BJM=;
 b=ZIiitlZM2+D7a2yweOryVbsJU3Jjv/QLEYY6ygw0sa1MZAsfkWhXN+eTnPDCFY4O76z6
 ZDDPhVH5bUXj2diXeJcM01nruw1VT9po7RdkraZoaPNRmvF4oyeWuu14axHs7vjJacrK
 LvCZDAF2mFqAtjiK93vZaXLEV5A7PWCgWJ508VtgsyDQAJqGmvs7wuRHX6roQOBKBHmP
 kx22mIIBFi5L+tlavPWEgcwOjRG0hv02jTc8Oy1lRd/o2exTJwNJn6gXsizx/DCmGId2
 8m8/W+eFd4wEyEN/lsTd1kUIgxMIQn+ULT8blsGzlFmzObVLRZRmttDCcAjoyxdvZrcZ QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f06nasftp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:35 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGuJ1u019875;
        Wed, 23 Mar 2022 17:03:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f06nasfs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGx8Ob026048;
        Wed, 23 Mar 2022 17:03:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t911s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3ShX15991292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E63604C058;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EAEC4C04A;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 6/9] s390x: smp: add test for EMERGENCY_SIGNAL with invalid CPU address
Date:   Wed, 23 Mar 2022 18:03:22 +0100
Message-Id: <20220323170325.220848-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S6kCRmicT5pib4978GcHEIDmqp8cg8iM
X-Proofpoint-GUID: STr0BnP-vtwCHBODaO_jlfs1wF5vevRP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In this case, we expect the order to be rejected.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 36014e809f2e..6e67bea72b75 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -662,6 +662,7 @@ static void emcall(void)
 static void test_emcall(void)
 {
 	struct psw psw;
+	int cc;
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)emcall;
 
@@ -674,6 +675,14 @@ static void test_emcall(void)
 	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
 	wait_for_flag();
 	smp_cpu_stop(1);
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	report(cc == 3, "CC = 3");
+
+	report_prefix_pop();
+
 	report_prefix_pop();
 }
 
-- 
2.31.1

