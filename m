Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1121146C04C
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbhLGQJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:09:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233074AbhLGQJQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:09:16 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7EN04u013225;
        Tue, 7 Dec 2021 16:05:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dNa4cmQJdFIYFVoH7vH/hnRiHRI2W1Gnz3wVRj+Ghf8=;
 b=lAL/dO7IAgIqFH4LTSQ46TRm5TNPUh+0yYnwLeReckIKtzFAuPTI/QkdB6rx6UfWXa3b
 d27RQWpwazuapyvnAscyKUm8cmqReO14xE30TvEY+HAeCuYjqzW80yJbECH9fu8+pamY
 w1bRGUm3HzCSmIMskXtdkvwIMIv45OS1Fh3qt36qj9mWrBmt3hriUvGHyZ94peqyqQNF
 u4N80RsOn1Ai63TX1Jp6y1eJT3FqRRLrwYgPSwTQlLMHmDFlVeEBAaXfCMCbsy9JMgKd
 mP8ZdT5ZQomxnMvf4/OBq1vKyDiVRsijV/b0z3sSljufUUp70HH0S3M9jEI9l/EXyNib Xg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct9b0ja9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:05:45 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7G3k4V023214;
        Tue, 7 Dec 2021 16:05:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3cqykfq4rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:05:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7G5eCP24379726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 16:05:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32D6342042;
        Tue,  7 Dec 2021 16:05:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CF3C42041;
        Tue,  7 Dec 2021 16:05:39 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:05:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [PATCH] s390: uv: Add offset comments to UV query struct
Date:   Tue,  7 Dec 2021 16:05:10 +0000
Message-Id: <20211207160510.1818-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 630cH48Qx-D7zg4CRrr9VaV6nrG2fWs2
X-Proofpoint-ORIG-GUID: 630cH48Qx-D7zg4CRrr9VaV6nrG2fWs2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes to the struct are easier to manage with offset comments so
let's add some.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 72d3e49c2860..235bd5cc8289 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -91,23 +91,23 @@ struct uv_cb_header {
 
 /* Query Ultravisor Information */
 struct uv_cb_qui {
-	struct uv_cb_header header;
-	u64 reserved08;
-	u64 inst_calls_list[4];
-	u64 reserved30[2];
-	u64 uv_base_stor_len;
-	u64 reserved48;
-	u64 conf_base_phys_stor_len;
-	u64 conf_base_virt_stor_len;
-	u64 conf_virt_var_stor_len;
-	u64 cpu_stor_len;
-	u32 reserved70[3];
-	u32 max_num_sec_conf;
-	u64 max_guest_stor_addr;
-	u8  reserved88[158 - 136];
-	u16 max_guest_cpu_id;
-	u64 uv_feature_indications;
-	u8  reserveda0[200 - 168];
+	struct uv_cb_header header;		/* 0x0000 */
+	u64 reserved08;				/* 0x0008 */
+	u64 inst_calls_list[4];			/* 0x0010 */
+	u64 reserved30[2];			/* 0x0030 */
+	u64 uv_base_stor_len;			/* 0x0040 */
+	u64 reserved48;				/* 0x0048 */
+	u64 conf_base_phys_stor_len;		/* 0x0050 */
+	u64 conf_base_virt_stor_len;		/* 0x0058 */
+	u64 conf_virt_var_stor_len;		/* 0x0060 */
+	u64 cpu_stor_len;			/* 0x0068 */
+	u32 reserved70[3];			/* 0x0070 */
+	u32 max_num_sec_conf;			/* 0x007c */
+	u64 max_guest_stor_addr;		/* 0x0080 */
+	u8  reserved88[158 - 136];		/* 0x0088 */
+	u16 max_guest_cpu_id;			/* 0x009e */
+	u64 uv_feature_indications;		/* 0x00a0 */
+	u8  reserveda0[200 - 168];		/* 0x00a8 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
-- 
2.32.0

