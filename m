Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F68F3BE940
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhGGOGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:06:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56707 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231958AbhGGOGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:06:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167E39Wd150715;
        Wed, 7 Jul 2021 10:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ShDXJEr9xIVi77IDAHWPJrKMQFO3KTNM7o1pLQpzS7c=;
 b=Rm95uenZ0ruptdjZILijjtVonUD003yiOpGD/uhjR3H68JairY5SmsrTqwR59VHDzU6a
 As8BWjA0O5W6UWz9+9T4nw90mJZrMBcsOObVyjU90SkqBPxeMm99oQ7rjL8cpCt3q4B4
 8PLHEVm9H1RIu8I1XX2f7PRgmRGfSSiCjX/3Z2CKOyKu93UmWknjJ+scUZxsUFMnXvmX
 CUZBweSE4uWbXj6ifkFsQuLC08JbcPISwRuIbhE+OZseqSRXdu4lsl6voPJGeoSJI1EN
 /CrUvlRwf47lNwXKZ817hYhjWGRXOPBRQN1uMNOludVksKwACR2V6FKZv0bb2D83hMHM xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpvsp7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:35 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167E38jn150664;
        Wed, 7 Jul 2021 10:03:35 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpvsp6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:35 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E3X6W002909;
        Wed, 7 Jul 2021 14:03:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 39jfh8gy4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E3UD735324322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:03:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 995AFA4051;
        Wed,  7 Jul 2021 14:03:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 234D9A404D;
        Wed,  7 Jul 2021 14:03:30 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 6/8] lib: s390x: uv: Add offset comments to uv_query and extend it
Date:   Wed,  7 Jul 2021 16:03:16 +0200
Message-Id: <20210707140318.44255-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707140318.44255-1-frankja@linux.ibm.com>
References: <20210707140318.44255-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 45zCRTTD4bZC2kAAlq8EjXuJx8A4qDwW
X-Proofpoint-GUID: 08AgJf6oT2vATl-l798dmn-58Iic923g
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_08:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The struct is getting longer, let's add offset comments so we know
where we change things when we add struct members.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/asm/uv.h | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index dc3e02de..ec10d1c4 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -84,22 +84,23 @@ struct uv_cb_init {
 } __attribute__((packed))  __attribute__((aligned(8)));
 
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
-	u16 max_guest_cpus;
-	u8  reserveda0[200 - 160];
+	struct uv_cb_header header;	/* 0x0000 */
+	u64 reserved08;			/* 0x0008 */
+	u64 inst_calls_list[4];		/* 0x0010 */
+	u64 reserved30[2];		/* 0x0030 */
+	u64 uv_base_stor_len;		/* 0x0040 */
+	u64 reserved48;			/* 0x0048 */
+	u64 conf_base_phys_stor_len;	/* 0x0050 */
+	u64 conf_base_virt_stor_len;	/* 0x0058 */
+	u64 conf_virt_var_stor_len;	/* 0x0060 */
+	u64 cpu_stor_len;		/* 0x0068 */
+	u32 reserved70[3];		/* 0x0070 */
+	u32 max_num_sec_conf;		/* 0x007c */
+	u64 max_guest_stor_addr;	/* 0x0080 */
+	u8  reserved88[158 - 136];	/* 0x0088 */
+	uint16_t max_guest_cpus;	/* 0x009e */
+	u64 uv_feature_indications;	/* 0x00a0 */
+	u8  reserveda8[200 - 168];	/* 0x00a8 */
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_cgc {
-- 
2.31.1

