Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698CE4E570B
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245631AbiCWRFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245620AbiCWRFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B371E4ECD7;
        Wed, 23 Mar 2022 10:03:33 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NGZwFW000727;
        Wed, 23 Mar 2022 17:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3qw3e7BuEn1pPymt4arsvOWmgm2yE8s6QV6FNjb7NoU=;
 b=S/1E+Y7Ow8KiSK41bBpASz9fFiQqcPTw3yUOICaWo/6BxNiRbmoCU5vRpUwFq+cGLWJ+
 5G+Dpp3yyEZm+dSfHP9y5LuIJfJn+Qq+T72fspBr3vSZS67lv59bfAFLzFt3N/hsXzbP
 V/uBi1pfZx+YYAtxzwxYQWsxasCVk648Vsg4M2tCshM6/fA6grYXaPAeZujhz/luzAvB
 do6jYD489aW0dDQLENyUcFIE752yB1KP0uaz1m73GZVukAPGkg9vAziPKtR/oKi2AE8W
 jGIXZBhmydGAdk+w2ASHutRtaDpB55cXngbElHVmMVuU/NDrzKv1txiap0PPWNnuesB6 qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f000yujt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NFpnqG007943;
        Wed, 23 Mar 2022 17:03:32 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f000yujsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGxtSu022122;
        Wed, 23 Mar 2022 17:03:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3ew6ehyt0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3QVE21430650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7D574C04A;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F99C4C044;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/9] s390x: smp: stop already stopped CPU
Date:   Wed, 23 Mar 2022 18:03:18 +0100
Message-Id: <20220323170325.220848-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R9xtgLKEltXEo7nT0IrYPiBgSmzgIhw5
X-Proofpoint-GUID: -p_EoRNwJRMOW1VywduqzoXq_LJiiQRS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per the PoP, the SIGP STOP order is only effective when the CPU is in
the operating state. Hence, we should have a test which tries to stop an
already stopped CPU.

Even though the SIGP order might be processed asynchronously, we assert
the CPU stays stopped.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 911a26c51b10..e5a16eb5a46a 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -129,6 +129,11 @@ static void test_stop(void)
 	 */
 	while (!smp_cpu_stopped(1)) {}
 	report_pass("stop");
+
+	report_prefix_push("stop stopped CPU");
+	report(!smp_cpu_stop(1), "STOP succeeds");
+	report(smp_cpu_stopped(1), "CPU is stopped");
+	report_prefix_pop();
 }
 
 static void test_stop_store_status(void)
-- 
2.31.1

