Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE0E699AE1
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBPRNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjBPRNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:13:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D82E4E5CB
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:13:02 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GG0vQ5023047
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=VgEA9dGL7D0WG4z8GE/Svbcfd8eeeWIXv8ToWW8F6mc=;
 b=suHXYhu1qwUziFqNCBvmSw87MDQNQrEunm3RPGU7fEPyrCqMTA1DGXfYYbmegosOUQGj
 VFMwoibq/wFjawhFrkZbwygDLagwoI5bIXHRFY1bzNbhHGM1lmNixEq80mSjqmoLc1u1
 mPhc3O2dxAtzjDZ3Njo6fm7zT+QKlhSdad8C0GYLV8wipXDc+98QdNaqDEEQ+epJ/Qcy
 RQJwarys4Id6ua135JN4vaHMmTkA6CdLupghzaiwSrMeNDHWrbFl1iufjW9FhvfBQNRq
 soT1yUJ34zlxE3tKbIve+P2/ST7opM42RC5ldK4iV7kYskMfWkWSorqCYrGa9CB5V0Ti Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsnmf5mba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:01 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GGdD4P034025
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsnmf5maj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:13:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G5KK27010698;
        Thu, 16 Feb 2023 17:12:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6xyn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:12:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GHCu7x47186176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 17:12:56 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE35820063;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DE282004F;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 04/10] s390x: Cleanup flat.lds
Date:   Thu, 16 Feb 2023 18:12:49 +0100
Message-Id: <20230216171255.48799-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216171255.48799-1-imbrenda@linux.ibm.com>
References: <20230216171255.48799-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: arFJiKNeDo2jjnPacXssYKXdaF5zyl7F
X-Proofpoint-ORIG-GUID: wTaQsJJ1RId_HXDgXqVqn3VeYS56_h5e
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_12,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

It seems like the loader file was copied over from another
architecture which has a different page size (64K) than s390 (4K).

Let's use a 4k alignment instead of the 64k one and remove unneeded
entries.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230112154548.163021-2-frankja@linux.ibm.com
Message-Id: <20230112154548.163021-2-frankja@linux.ibm.com>
---
 s390x/flat.lds | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/s390x/flat.lds b/s390x/flat.lds
index de9da1a8..952f6cd4 100644
--- a/s390x/flat.lds
+++ b/s390x/flat.lds
@@ -24,20 +24,8 @@ SECTIONS
 		*(.text)
 		*(.text.*)
 	}
-	. = ALIGN(64K);
+	. = ALIGN(4K);
 	etext = .;
-	.opd : { *(.opd) }
-	. = ALIGN(16);
-	.dynamic : {
-		dynamic_start = .;
-		*(.dynamic)
-	}
-	.dynsym : {
-		dynsym_start = .;
-		*(.dynsym)
-	}
-	.rela.dyn : { *(.rela*) }
-	. = ALIGN(16);
 	.data : {
 		*(.data)
 		*(.data.rel*)
@@ -48,10 +36,11 @@ SECTIONS
 	__bss_start = .;
 	.bss : { *(.bss) }
 	__bss_end = .;
-	. = ALIGN(64K);
+	. = ALIGN(4K);
 	edata = .;
+	/* Reserve 64K for the stack */
 	. += 64K;
-	. = ALIGN(64K);
+	. = ALIGN(4K);
 	/*
 	 * stackptr set with initial stack frame preallocated
 	 */
-- 
2.39.1

