Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DE252A827
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351007AbiEQQg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350999AbiEQQg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:36:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84312E08F;
        Tue, 17 May 2022 09:36:53 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGRMtR025955;
        Tue, 17 May 2022 16:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MsLlrimoEstpilCnTJeJaRKbXFq8yLqyEqvxPo0Rxpw=;
 b=l5Oos/3B+JBszrIFGilqVrU0i96hOHU18Qpc0dY4E4UjNUpA8ZDlh3J7h2BfJw7ZnurN
 38+9Q7/eVsUlXTraMldM1Qzv+fJ9wVw3s2wIOIlqzeR0Pepehm17PCwC51kinTeRmau0
 k/txlgTLhLU34tb4hIeGcSmlDqps6opwoCSmEKPm9zO0osxaF3KYKxRtfbqerjdkMzRd
 ygSuJ4W418f95/nuXIMkDGiMke6NyjW5W53nm/yPzp5ma+agMmhgj/35PS5Acma7cIIb
 Isk4kqE/6J26FnkmUaza88pYsG80ZDeXbHspqsimJky7PhVBFvQH1FCy2fhBKroBMCUp 5A== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4f8807kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:52 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGY3Kj001265;
        Tue, 17 May 2022 16:36:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428umdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGam3n29163986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:36:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F23E011C054;
        Tue, 17 May 2022 16:36:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F66D11C05B;
        Tue, 17 May 2022 16:36:47 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:36:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v6 02/11] s390: uv: Add dump fields to query
Date:   Tue, 17 May 2022 16:36:20 +0000
Message-Id: <20220517163629.3443-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163629.3443-1-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZsxVqkj3tCwYt7LMrMPidOy0lxOlsWXL
X-Proofpoint-ORIG-GUID: ZsxVqkj3tCwYt7LMrMPidOy0lxOlsWXL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new dump feature requires us to know how much memory is needed for
the "dump storage state" and "dump finalize" ultravisor call. These
values are reported via the UV query call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/boot/uv.c        |  2 ++
 arch/s390/include/asm/uv.h |  5 +++++
 arch/s390/kernel/uv.c      | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index b100b57cf15d..67c737c1e580 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -43,6 +43,8 @@ void uv_query_info(void)
 		uv_info.uv_feature_indications = uvcb.uv_feature_indications;
 		uv_info.supp_se_hdr_ver = uvcb.supp_se_hdr_versions;
 		uv_info.supp_se_hdr_pcf = uvcb.supp_se_hdr_pcf;
+		uv_info.conf_dump_storage_state_len = uvcb.conf_dump_storage_state_len;
+		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 46498b8c587b..e8257a293dd1 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -114,6 +114,9 @@ struct uv_cb_qui {
 	u64 supp_se_hdr_versions;		/* 0x00b0 */
 	u64 supp_se_hdr_pcf;			/* 0x00b8 */
 	u64 reservedc0;				/* 0x00c0 */
+	u64 conf_dump_storage_state_len;	/* 0x00c8 */
+	u64 conf_dump_finalize_len;		/* 0x00d0 */
+	u8  reservedd8[256 - 216];		/* 0x00d8 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -312,6 +315,8 @@ struct uv_info {
 	unsigned long uv_feature_indications;
 	unsigned long supp_se_hdr_ver;
 	unsigned long supp_se_hdr_pcf;
+	unsigned long conf_dump_storage_state_len;
+	unsigned long conf_dump_finalize_len;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 852840384e75..84fe33b6af4d 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -410,6 +410,36 @@ static ssize_t uv_query_supp_se_hdr_pcf(struct kobject *kobj,
 static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
 	__ATTR(supp_se_hdr_pcf, 0444, uv_query_supp_se_hdr_pcf, NULL);
 
+static ssize_t uv_query_dump_cpu_len(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.guest_cpu_stor_len);
+}
+
+static struct kobj_attribute uv_query_dump_cpu_len_attr =
+	__ATTR(uv_query_dump_cpu_len, 0444, uv_query_dump_cpu_len, NULL);
+
+static ssize_t uv_query_dump_storage_state_len(struct kobject *kobj,
+					       struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.conf_dump_storage_state_len);
+}
+
+static struct kobj_attribute uv_query_dump_storage_state_len_attr =
+	__ATTR(dump_storage_state_len, 0444, uv_query_dump_storage_state_len, NULL);
+
+static ssize_t uv_query_dump_finalize_len(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.conf_dump_finalize_len);
+}
+
+static struct kobj_attribute uv_query_dump_finalize_len_attr =
+	__ATTR(dump_finalize_len, 0444, uv_query_dump_finalize_len, NULL);
+
 static ssize_t uv_query_feature_indications(struct kobject *kobj,
 					    struct kobj_attribute *attr, char *buf)
 {
@@ -457,6 +487,9 @@ static struct attribute *uv_query_attrs[] = {
 	&uv_query_max_guest_addr_attr.attr,
 	&uv_query_supp_se_hdr_ver_attr.attr,
 	&uv_query_supp_se_hdr_pcf_attr.attr,
+	&uv_query_dump_storage_state_len_attr.attr,
+	&uv_query_dump_finalize_len_attr.attr,
+	&uv_query_dump_cpu_len_attr.attr,
 	NULL,
 };
 
-- 
2.34.1

