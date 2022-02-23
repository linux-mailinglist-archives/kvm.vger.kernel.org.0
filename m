Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C164F4C0F07
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbiBWJU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239247AbiBWJU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:20:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E8B8303C;
        Wed, 23 Feb 2022 01:20:26 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N9GlOp022869;
        Wed, 23 Feb 2022 09:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V2wDBsNkQiBASmPIs7QsWPfp1olr14l8FJloay0DUlE=;
 b=MAASlXFxpcZUq39O+E3byL3GFF2c2olC5ARp6Zf0F1hyAQCQgETQ1zmyPsP/v9WXJO8Q
 FCVx6CZGbk3iV0N/C5sfAwyackNBPf3uy6ehBXp/9YHyfAlJqeXfdZwJT+yROnl6Sfa7
 QGdVd0m4eY6biFDgwovy7m/xRzKeMRfnX6nSBZhZWquDQCDDwWgKK6Ph6RQl+f3ofV3F
 Wr2KPfdIyoXs2mqBDmG95MQYE5nYpspS+ArcVG1K5+Fxmvj6U715BoMu5vrUvya5Xzd2
 fBPKJ7wLNQEZtswHeVJZb2mFXP4jQQ2Fs8AXHPxxG7Y+0Gb+9RCxtFrf/7nLcd8Wrjr3 QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edj5dg2f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:26 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N9JBT0000389;
        Wed, 23 Feb 2022 09:20:25 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edj5dg2e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:25 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9CPHx022147;
        Wed, 23 Feb 2022 09:20:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ear6974ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N9KJPe56820098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:20:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51FC611C04A;
        Wed, 23 Feb 2022 09:20:19 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5B2611C05C;
        Wed, 23 Feb 2022 09:20:18 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:20:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH 2/9] s390: uv: Add dump fields to query
Date:   Wed, 23 Feb 2022 09:20:00 +0000
Message-Id: <20220223092007.3163-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223092007.3163-1-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rXzMirVhJEd-AnkZA8eL2gTRLHtwtgKC
X-Proofpoint-GUID: NW6ki8dhb9w1SAZfeuRn678g9BTOF5iQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new dump feature requires us to know how much memory is needed for
the "dump storage state" and "dump finalize" ultravisor call. These
values are reported via the UV query call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
index 7d6c78b61bf2..b79e516d4424 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -111,6 +111,9 @@ struct uv_cb_qui {
 	u64 supp_se_hdr_versions;		/* 0x00b0 */
 	u64 supp_se_hdr_pcf;			/* 0x00b8 */
 	u64 reservedc0;				/* 0x00c0 */
+	u64 conf_dump_storage_state_len;	/* 0x00c8 */
+	u64 conf_dump_finalize_len;		/* 0x00d0 */
+	u8  reservedd8[256 - 216];		/* 0x00d8 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -290,6 +293,8 @@ struct uv_info {
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
2.32.0

