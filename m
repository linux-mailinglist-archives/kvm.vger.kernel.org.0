Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7F4C0F03
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbiBWJUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239225AbiBWJUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:20:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FE88302D;
        Wed, 23 Feb 2022 01:20:24 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N8lYwE011701;
        Wed, 23 Feb 2022 09:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=q2IQVErTYuQFsTR4DO0mzkI3oLuwUYj9/dY9rF8z/CU=;
 b=qeGbSX5TKHdug2pUM9IzTezqFuoTvFVKZGSZjpfkkXj9HX7KlOeiYb3MtvrNJK3889ao
 zVq1FTlFgIqGVeWSgWbFgi5epm7dUtoONCFoHGvjGxXTBfjyrcINoQXoYbElO39rxZbp
 3rDTZfErUD2WRFqv0NP1cUgU/zLuy2JEyhck9D3F+MJX9xYXExPproah/5Y+MjSTTeza
 eoYuOVesaPv5UOGUMYvtQDs3nM/KdG4ywZEJGvdrNP4QSwr86hBPy5AN5Dd1irKsFIJv
 bKvJgoyeowjFQCU8ib/9Lq3aJ0JT3abjugeVUblS519Dv8RyjUK03lhMoaAmK3Vxqhny cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edhqs8j99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:23 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N8mBOF012604;
        Wed, 23 Feb 2022 09:20:23 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edhqs8j8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:23 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9D4ND030241;
        Wed, 23 Feb 2022 09:20:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ear6973t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N9KINn56951160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:20:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F30611C05B;
        Wed, 23 Feb 2022 09:20:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F30FC11C054;
        Wed, 23 Feb 2022 09:20:17 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:20:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH 1/9] s390x: Add SE hdr query information
Date:   Wed, 23 Feb 2022 09:19:59 +0000
Message-Id: <20220223092007.3163-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223092007.3163-1-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -zxHqN2ja22kASql2EuWZxUN_F5tMaYM
X-Proofpoint-ORIG-GUID: B5BtycpZuwaLMts-jbN1TN_mTJPM-T1_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
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

We have information about the supported se header version and pcf bits
so let's expose it via the sysfs files.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/boot/uv.c        |  2 ++
 arch/s390/include/asm/uv.h |  7 ++++++-
 arch/s390/kernel/uv.c      | 20 ++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index e6be155ab2e5..b100b57cf15d 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -41,6 +41,8 @@ void uv_query_info(void)
 		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
 		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_id;
 		uv_info.uv_feature_indications = uvcb.uv_feature_indications;
+		uv_info.supp_se_hdr_ver = uvcb.supp_se_hdr_versions;
+		uv_info.supp_se_hdr_pcf = uvcb.supp_se_hdr_pcf;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 86218382d29c..7d6c78b61bf2 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -107,7 +107,10 @@ struct uv_cb_qui {
 	u8  reserved88[158 - 136];		/* 0x0088 */
 	u16 max_guest_cpu_id;			/* 0x009e */
 	u64 uv_feature_indications;		/* 0x00a0 */
-	u8  reserveda8[200 - 168];		/* 0x00a8 */
+	u64 reserveda8;				/* 0x00a8 */
+	u64 supp_se_hdr_versions;		/* 0x00b0 */
+	u64 supp_se_hdr_pcf;			/* 0x00b8 */
+	u64 reservedc0;				/* 0x00c0 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -285,6 +288,8 @@ struct uv_info {
 	unsigned int max_num_sec_conf;
 	unsigned short max_guest_cpu_id;
 	unsigned long uv_feature_indications;
+	unsigned long supp_se_hdr_ver;
+	unsigned long supp_se_hdr_pcf;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index a5425075dd25..852840384e75 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -392,6 +392,24 @@ static ssize_t uv_query_facilities(struct kobject *kobj,
 static struct kobj_attribute uv_query_facilities_attr =
 	__ATTR(facilities, 0444, uv_query_facilities, NULL);
 
+static ssize_t uv_query_supp_se_hdr_ver(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_se_hdr_ver);
+}
+
+static struct kobj_attribute uv_query_supp_se_hdr_ver_attr =
+	__ATTR(supp_se_hdr_ver, 0444, uv_query_supp_se_hdr_ver, NULL);
+
+static ssize_t uv_query_supp_se_hdr_pcf(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_se_hdr_pcf);
+}
+
+static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
+	__ATTR(supp_se_hdr_pcf, 0444, uv_query_supp_se_hdr_pcf, NULL);
+
 static ssize_t uv_query_feature_indications(struct kobject *kobj,
 					    struct kobj_attribute *attr, char *buf)
 {
@@ -437,6 +455,8 @@ static struct attribute *uv_query_attrs[] = {
 	&uv_query_max_guest_cpus_attr.attr,
 	&uv_query_max_guest_vms_attr.attr,
 	&uv_query_max_guest_addr_attr.attr,
+	&uv_query_supp_se_hdr_ver_attr.attr,
+	&uv_query_supp_se_hdr_pcf_attr.attr,
 	NULL,
 };
 
-- 
2.32.0

