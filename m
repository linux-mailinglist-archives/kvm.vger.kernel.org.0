Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347A87193D4
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 09:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjFAHCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 03:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbjFAHCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 03:02:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7699D194;
        Thu,  1 Jun 2023 00:02:10 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3516sEix016876;
        Thu, 1 Jun 2023 07:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+LWx4/vB3TO3YjKJhbKvMeFh1IKZfvqRe179MextoQU=;
 b=X0bc+DiWNxmUQlea3zDBeS7R0BzdXvs0U+IGqLNjGaAe+17XHSubxLDvrPoTxr4fWZ6Z
 4AehTYeIlAFG76XHPuzl+tO94LGYw9x+aylEzROVN0riqnKtWN+SbJ5kCaPrmPqJqFw8
 YfNYCfuzRUihlUGZs09Y7mTRMcbbPblq9hBk67EtpTtwSIDCqFwj2oy/pBW1O5WzW9aA
 KEnZO8RxVKRkozEKIcCaCFEURV974iflyMBLDfttRqDQPfrBuOnAlctAFsyEXsUzAE8y
 jznw2HgoRBRb81Mvr8YPIUA9nNbMnzIAAyDNSRFd0y9w9jA8zGa+J5+8z8eQZ7g+5aYl pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpfgr6bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:09 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3516u6hS022111;
        Thu, 1 Jun 2023 07:02:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpfgr6at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34VNQEBG018589;
        Thu, 1 Jun 2023 07:02:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5acb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3517236m11403938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 07:02:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFBE22004B;
        Thu,  1 Jun 2023 07:02:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E4A92005A;
        Thu,  1 Jun 2023 07:02:03 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 07:02:03 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 4/6] s390x: lib: don't forward PSW when handling exception in SIE
Date:   Thu,  1 Jun 2023 09:02:00 +0200
Message-Id: <20230601070202.152094-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230601070202.152094-1-nrb@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: He5D7ezeIVh0WLSN6hQmapdTpONXofsa
X-Proofpoint-GUID: ztjUP30ta_7EB59NAbZpsZF58_ucfIh1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_04,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we're handling a pgm int in SIE, we want to return to the SIE
cleanup after handling the exception. That's why we set pgm_old_psw to
the sie_exit label in fixup_pgm_int.

On nullifing pgm ints, fixup_pgm_int will also forward the old PSW such
that we don't cause an pgm int again.

However, when we want to return to the sie_exit label, this is not
needed (since we've manually set pgm_old_psw). Instead, forwarding the
PSW might cause us to skip an instruction or end up in the middle of an
instruction.

So, let's just skip the rest of the fixup in case we're inside SIE.

Note that we're intentionally not fixing up the PSW in the guest; that's
best left to the test at hand by registering their own psw fixup.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/interrupt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index d97b5a3a7e97..3f07068877ee 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -145,6 +145,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
 	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
 		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
+		return;
 	}
 
 	switch (lowcore.pgm_int_code) {
-- 
2.39.1

