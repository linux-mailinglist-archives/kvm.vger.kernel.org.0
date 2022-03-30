Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B5C4EC42E
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344674AbiC3Mfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343702AbiC3MfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:35:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F4C7DE3C;
        Wed, 30 Mar 2022 05:21:04 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBb6wT000940;
        Wed, 30 Mar 2022 12:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2O6qVJSbMrzGCBDXvL0U00MpQL1U8DTkrvMgySHvL/U=;
 b=XNRN6AWxK0faxe709hdtmhLOrezYCJb3catH2EIdJx0wamp2qJwaTja47iQQ7nUPCKaH
 8L0J/qmNrqnhN9oyy6ejRx5bPV+VJoybsvGkwXFHtSnduGDYC0hEZZIkdgieWitsLVL8
 tCs2pMzaHkF0ic8xPe1/zjILWFd+G+WQlgMjYHb0p/MpAqZwjJiKoRTl02D3J2wFoHFD
 rGwW6Af8L8c8RpWyttnyeTmMoRfo1338enpEWRGJQcwc79Oo0Sa07XJTyJ4G3X64o2q0
 ramq4E8zDnxg/wrGjOzMRU63fYo9Z8726RL6oHpn7onxeX95TibJ+t5REbS0OHtfGEAC cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f40v83091-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:39 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UBkjK5029256;
        Wed, 30 Mar 2022 12:20:38 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f40v8308e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBwnJC020630;
        Wed, 30 Mar 2022 12:20:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8q96b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCKXQ751577294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:20:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C81EF42045;
        Wed, 30 Mar 2022 12:20:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3848A4203F;
        Wed, 30 Mar 2022 12:20:33 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:20:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v3 4/9] KVM: s390: pv: Add dump support definitions
Date:   Wed, 30 Mar 2022 12:19:47 +0000
Message-Id: <20220330121952.105725-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330121952.105725-1-frankja@linux.ibm.com>
References: <20220330121952.105725-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NRXB50scHJiELpo_Cdt2KAuQGC5SlIBl
X-Proofpoint-ORIG-GUID: v181nlRe0R9iAZX2zQ3FUmuHaxyffLVz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 mlxlogscore=977
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add the constants and structure definitions needed for the dump
support.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index e8257a293dd1..3e597bb634bd 100644
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
 #define UVC_CMD_RETR_ATTEST		0x1020
@@ -77,6 +81,10 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
+	BIT_UVC_CMD_DUMP_INIT = 24,
+	BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE = 25,
+	BIT_UVC_CMD_DUMP_CPU = 26,
+	BIT_UVC_CMD_DUMP_COMPLETE = 27,
 	BIT_UVC_CMD_RETR_ATTEST = 28,
 };
 
@@ -246,6 +254,31 @@ struct uv_cb_attest {
 	u64 reserved168[4];		/* 0x0168 */
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

