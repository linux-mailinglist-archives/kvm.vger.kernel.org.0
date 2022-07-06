Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE24567ED3
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiGFGlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiGFGlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:41:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6B7186F8;
        Tue,  5 Jul 2022 23:41:20 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2664jNV1017405;
        Wed, 6 Jul 2022 06:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fcXQ6HDfEtrLR3LWcOHrw9qvcrnXXShEZTIOnUVf6dU=;
 b=D3FfbDrI45dKCTlJIj4VSVf+lG671IDdVQ6xdmka5nz+BEdLNDkWtTN6z2dln+QMtPC4
 3+J4MW+yHhaKYFFwa/3h18UG9Wo5yF6p90G81q88+XQU3JOMvXqSaTgT34TcFV615x6Q
 b4ZCpBxjICdCx5G863BYi0Xez/AOM7zKqh5OdSACNQ2Hi33mDCGkkfBTfzGz89ZSJLO2
 UP2vgxnJGrpDvrgLXc7hivngMdsohBlQ1LBADo8keSZ7R34CafuHEFIJWSHkILBROMFb
 KKYB489zm6RZu5Y/99tbGCvFBJGT6aOd4tNWco19zao2SzFF2aDucNoW3SsJNSiFphYb uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h53n8aaep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:20 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2666boeX023185;
        Wed, 6 Jul 2022 06:41:19 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h53n8aae6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2666LWrM004541;
        Wed, 6 Jul 2022 06:41:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3h4ucy8dtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2666fEmh17105388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 06:41:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62FD74C046;
        Wed,  6 Jul 2022 06:41:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7677C4C040;
        Wed,  6 Jul 2022 06:41:13 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 06:41:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/8] s390x: uv-host: Test uv immediate parameter
Date:   Wed,  6 Jul 2022 06:40:19 +0000
Message-Id: <20220706064024.16573-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706064024.16573-1-frankja@linux.ibm.com>
References: <20220706064024.16573-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aIPDfQoRVxDivOdzhh-_CGlPFIjsV0xe
X-Proofpoint-GUID: gUVMaqxpDkHDG5xAEv-L3r1pelz0ANRN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_03,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=974 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060022
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if we get a specification PGM exception if we set a
non-zero i3 when doing a UV call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 5aeacb42..0762e690 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -82,6 +82,28 @@ static struct cmd_list cmds[] = {
 	{ NULL, 0, 0 },
 };
 
+static void test_i3(void)
+{
+	struct uv_cb_header uvcb = {
+		.cmd = UVC_CMD_INIT_UV,
+		.len = sizeof(struct uv_cb_init),
+	};
+	unsigned long r1 = 0;
+	int cc;
+
+	report_prefix_push("i3");
+	expect_pgm_int();
+	asm volatile(
+		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],4,2\n"
+		"		ipm	%[cc]\n"
+		"		srl	%[cc],28\n"
+		: [cc] "=d" (cc)
+		: [r1] "a" (r1), [r2] "a" (&uvcb)
+		: "memory", "cc");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+}
+
 static void test_priv(void)
 {
 	struct uv_cb_header uvcb = {};
@@ -577,6 +599,7 @@ int main(void)
 		goto done;
 	}
 
+	test_i3();
 	test_priv();
 	test_invalid();
 	test_uv_uninitialized();
-- 
2.34.1

