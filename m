Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B0853AA30
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355686AbiFAPhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355606AbiFAPg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:36:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C014AB48A;
        Wed,  1 Jun 2022 08:36:54 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251EuSis029952;
        Wed, 1 Jun 2022 15:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=oD6Wy4Lb8EIlk3SrBikJwuxgaHdxjZ8s3bhucZM/sck=;
 b=pqwuNSrvKZmVgDg0tRwI7xtcEsM3QvIuKxm1mediEb1/1lPST7Ryf4ZzDGvKhbuZOCod
 L9dBMrAdsFfi2j/OD3QY3V+LUC3muHytgdcf7SclLzgFfeztQGOnrzVkskX5imncPEcC
 PzkNvazZvFgKZbtz16L08rwr/ZoZ+1udoCojdH0vH2IG8VTJHxbzLVDVByOl5nC+CxGC
 hz/EE/uXwznjlccxiDIDVlMYotp7DHFoPen1IwqgKO9rAGkkQNJ7qHKu8mzlm3vp5men
 bAxD2am0SiKFDvI1XE0wZpsnqC1+NH69F9KZVUXyGMf5zojSeteWeZXclDlNezqtw8g/ 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geaap8xed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:53 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251FaTnp001186;
        Wed, 1 Jun 2022 15:36:53 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geaap8xdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FKruS023643;
        Wed, 1 Jun 2022 15:36:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h5uee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251Falmc28180916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7C8CA4040;
        Wed,  1 Jun 2022 15:36:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4DFBA4051;
        Wed,  1 Jun 2022 15:36:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:47 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 882E3E028C; Wed,  1 Jun 2022 17:36:47 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 02/15] s390/uv: Add dump fields to query
Date:   Wed,  1 Jun 2022 17:36:33 +0200
Message-Id: <20220601153646.6791-3-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TPuFDKwGQ_a_XgUurtRbCOcfpGR_VNZj
X-Proofpoint-GUID: 6mDRT-boicqY7gxwff-1KUSSveAFlZ2A
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The new dump feature requires us to know how much memory is needed for
the "dump storage state" and "dump finalize" ultravisor call. These
values are reported via the UV query call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Link: https://lore.kernel.org/r/20220517163629.3443-3-frankja@linux.ibm.com
Message-Id: <20220517163629.3443-3-frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
2.35.1

