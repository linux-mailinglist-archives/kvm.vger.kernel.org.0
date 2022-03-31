Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABFA4ED9F3
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 14:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbiCaM6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 08:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiCaM6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 08:58:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE7C2128D7;
        Thu, 31 Mar 2022 05:56:20 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VBk4UC029391;
        Thu, 31 Mar 2022 12:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/TuCFDFDSXnAd+7o8XDVhmIm4tFAtZb2hubiIEEXtsg=;
 b=Dtjoho+OFN9o0NdZAuqFbf9VsLg5r6dBYxfLGJkfKu6jxja/XBEs38pBANf926M5GPob
 AfGS/95/NrjNLjdPzpHBtIOb9bf9SJluVDUqNZd9vkxHgRxmV92IJ39i0SAXdsaS72q0
 ysAFQHa5V8g6R3Gy2RiS8YGK3jbFdZFuicfs1tZbxHTdTJqlKQULov+JWckq8fndbOAB
 Xv9NHiQw9l8PyPSLyTbRKoQjbu/zSKfzEQP9/D6tGIzQ1zgioyys62/XOkvs8Yqm/X5x
 yYqHCeHgWtuEv8fHbCCLCdngyamQz2ZwFXbF0b8Jr6PRdyCJDS3pnliVYKiWzbI7DVel 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f51hvnha8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 12:56:19 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VCtRP6017937;
        Thu, 31 Mar 2022 12:56:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f51hvnh9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 12:56:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VCiZWU022837;
        Thu, 31 Mar 2022 12:56:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf92tbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 12:56:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VCuEQN39125448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 12:56:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAF9442041;
        Thu, 31 Mar 2022 12:56:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 100F64203F;
        Thu, 31 Mar 2022 12:56:14 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 12:56:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: snippets: c: Load initial cr0
Date:   Thu, 31 Mar 2022 12:55:15 +0000
Message-Id: <20220331125515.1941-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fHjgw0L6vVodvy1uCDOHj8wlcRMWleih
X-Proofpoint-ORIG-GUID: QQ5Dqfylb5Z0F5n-nPazWdQ7XnSRuoJ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=781 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As soon as we use C we need to set the AFP bit in cr0 so we can use
all fprs.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/snippets/c/cstart.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index aaa5380c..a7d4cd42 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -12,6 +12,8 @@
 .section .init
 	.globl start
 start:
+	larl	%r1, initial_cr0
+	lctlg	%c0, %c0, 0(%r1)
 	/* XOR all registers with themselves to clear them fully. */
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 	xgr \i,\i
@@ -34,3 +36,7 @@ exit:
 	/* For now let's only use cpu 0 in snippets so this will always work. */
 	xgr	%r0, %r0
 	sigp    %r2, %r0, SIGP_STOP
+
+initial_cr0:
+	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
+	.quad	0x0000000000040000
-- 
2.32.0

