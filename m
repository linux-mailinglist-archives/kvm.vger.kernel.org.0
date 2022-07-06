Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E96567EC7
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiGFGlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiGFGla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:41:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B881AF21;
        Tue,  5 Jul 2022 23:41:28 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26668YAC020180;
        Wed, 6 Jul 2022 06:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sJ8c7QsiJVv836WVdjCfNVPrSrDwe80wQMSrBDLxJ8U=;
 b=Vw1Cu0DbNRJ6aIpcAThjFRxN4HprFkF+pciSjpNmNhw6VTHyaJykF15p1Mk7I1c77yVb
 aA3BdEtegLoXnz3QDDHKjdG7J9PU0/BDABNU02XCMKN2RfrAi93pCXVa8h3wUjGrg85n
 CWbygsnmw69c7LGYXx37nFCjtP/DJVeGoUU9etpEa2EjiHcc/z9JZMitCylecSqq1KUB
 OA3hj/UvPYDGJdIpZphyTIHeOF098wf54GRaOFyGcVWB4IGi5DTSWEGPBHSp62xuoy6L
 nIdaUeCnb56NAhfuYwkGmFEtwkbHTgNRvY65SslZmlH3AgZDq1aUxpexWtbcTMUGoF4L Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h543u9ke5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:27 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2666f8ac021074;
        Wed, 6 Jul 2022 06:41:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h543u9kbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2666L1pk014385;
        Wed, 6 Jul 2022 06:41:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3h4uwp0db4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2666fGtk25559454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 06:41:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BFE94C044;
        Wed,  6 Jul 2022 06:41:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 988844C040;
        Wed,  6 Jul 2022 06:41:15 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 06:41:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/8] s390x: uv-host: Add a set secure config parameters test function
Date:   Wed,  6 Jul 2022 06:40:21 +0000
Message-Id: <20220706064024.16573-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706064024.16573-1-frankja@linux.ibm.com>
References: <20220706064024.16573-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: s2PRD3LAtAqrhOIMpGtB1fpXUkgFrPbq
X-Proofpoint-ORIG-GUID: 7S0Rz-xminQ2m3eflxCUghBZDy7VQIfJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_03,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060022
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time for more tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a626a651..0044e8b9 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -248,6 +248,53 @@ static void test_cpu_destroy(void)
 	report_prefix_pop();
 }
 
+static void test_set_se_header(void)
+{
+	struct uv_cb_ssc uvcb = {
+		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
+		.header.len = sizeof(uvcb),
+		.guest_handle = uvcb_cgc.guest_handle,
+		.sec_header_origin = 0,
+		.sec_header_len = 0x1000,
+	};
+	void *pages =  alloc_pages(1);
+	void *inv;
+	int rc;
+
+	report_prefix_push("sscp");
+
+	uvcb.header.len -= 8;
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_LEN,
+	       "hdr invalid length");
+	uvcb.header.len += 8;
+
+	uvcb.guest_handle += 1;
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_GHANDLE, "invalid handle");
+	uvcb.guest_handle -= 1;
+
+	inv = pages + PAGE_SIZE;
+	uvcb.sec_header_origin = (uint64_t)inv;
+	protect_page(inv, PAGE_ENTRY_I);
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == 0x103,
+	       "se hdr access exception");
+
+	/*
+	 * Shift the ptr so the first few DWORDs are accessible but
+	 * the following are on an invalid page.
+	 */
+	uvcb.sec_header_origin -= 0x20;
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == 0x103,
+	       "se hdr access exception crossing");
+	unprotect_page(inv, PAGE_ENTRY_I);
+
+	free_pages(pages);
+	report_prefix_pop();
+}
+
 static void test_cpu_create(void)
 {
 	int rc;
@@ -661,6 +708,7 @@ int main(void)
 
 	test_config_create();
 	test_cpu_create();
+	test_set_se_header();
 	test_cpu_destroy();
 	test_config_destroy();
 	test_clear();
-- 
2.34.1

