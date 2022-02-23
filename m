Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AF4C0F0A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239264AbiBWJVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbiBWJU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:20:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA548303E;
        Wed, 23 Feb 2022 01:20:27 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N8alrP031228;
        Wed, 23 Feb 2022 09:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UIWnVQBZ2zpz8KpKSfmcU+hYWjmE4n1Sy0WTE7ASNdg=;
 b=NBDZwcjiSB6j7+TY0kNmVsGbaBzHtTHNZaFaJKsk8FHSyGtYVzS+pJ7CPSjF3lzCa3P7
 NyTaARhYXxH6O2LI+nYbB6+nmaK14ur+wyM6qweBV+ySDSL+70zHLZp6i8kmp2+gnPF+
 RQI9v/ML9fr609hNafBiwFfY79kYPHSer/Dqz2Sk0cCvB8qpZ0EV6R9U8EDOmUaK16Yw
 I9f/eDUVC0TOZgFRbe6ob6dQS+bvNySX0J4shsVbGPWUePDe/N0w5BMDfbWzqglMSShL
 O288DXkLH7+APXj3IJxCYTckPzo42V1VbgLcqKkXbgkZ2FuozSkAe7iXCVDjawe4TLJU XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ede6smh36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:26 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N9IPwL011176;
        Wed, 23 Feb 2022 09:20:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ede6smh27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9CNCI017242;
        Wed, 23 Feb 2022 09:20:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqtj8nds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N9KK9w55771456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:20:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB52F11C054;
        Wed, 23 Feb 2022 09:20:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B1C811C05E;
        Wed, 23 Feb 2022 09:20:20 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:20:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH 4/9] KVM: s390: pv: Add dump support definitions
Date:   Wed, 23 Feb 2022 09:20:02 +0000
Message-Id: <20220223092007.3163-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223092007.3163-1-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vXEbWtXciFLIrEXGdQiCDMXqxk1T-URL
X-Proofpoint-ORIG-GUID: It0ztphCNM-QmWau8eKJzaWH41YLyaOT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=940
 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lets add the constants and structure definitions needed for the dump
support.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index b79e516d4424..b593fbcfd448 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -50,6 +50,10 @@
 #define UVC_CMD_SET_UNSHARE_ALL		0x0340
 #define UVC_CMD_PIN_PAGE_SHARED		0x0341
 #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
+#define UVC_CMD_DUMP_INIT		0x0400
+#define UVC_CMD_DUMP_CONF_STOR_STATE	0x0401
+#define UVC_CMD_DUMP_CPU		0x0402
+#define UVC_CMD_DUMP_COMPLETE		0x0403
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
@@ -76,6 +80,10 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
+	BIT_UVC_CMD_DUMP_INIT = 24,
+	BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE = 25,
+	BIT_UVC_CMD_DUMP_CPU = 26,
+	BIT_UVC_CMD_DUMP_COMPLETE = 27,
 };
 
 enum uv_feat_ind {
@@ -224,6 +232,31 @@ struct uv_cb_share {
 	u64 reserved28;
 } __packed __aligned(8);
 
+struct uv_cb_dump_cpu {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u64 dump_area_origin;
+	u64 reserved28[5];
+} __packed __aligned(8);
+
+struct uv_cb_dump_stor_state {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 config_handle;
+	u64 dump_area_origin;
+	u64 gaddr;
+	u64 reserved28[4];
+} __packed __aligned(8);
+
+struct uv_cb_dump_complete {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 config_handle;
+	u64 dump_area_origin;
+	u64 reserved30[5];
+} __packed __aligned(8);
+
 static inline int __uv_call(unsigned long r1, unsigned long r2)
 {
 	int cc;
-- 
2.32.0

