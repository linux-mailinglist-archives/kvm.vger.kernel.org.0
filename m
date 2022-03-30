Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4731A4EC42D
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345160AbiC3Mfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiC3MfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:35:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F31D7DE1F;
        Wed, 30 Mar 2022 05:21:00 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBdJA2029467;
        Wed, 30 Mar 2022 12:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G4JJEkEXgCS84cJnnMdNlbONEFtckn1aJdxN0UYJXGY=;
 b=CbJuKrZuCpCyATlMB2F1t+kJhePP/1VOTWNwars5Kz0cvalWqj4rPTx/uhnreyEbLOtx
 9pE22EJP0TbYyP4HmYjZnfcUtw5U7lax3roFPYrFzNe1WQT/vP9nuCBIL2TowNvnjlqh
 46EQUk+2ST+D5UuwcQo0oZqSFo0EktMHEWsphYMLhripjHq9xqcAnPvuSav3vOvV8jS5
 wYvXydrMIATB0nIQZuTcNBXuGvyZTJ4dRH/XvnOcZFx4OVGRNYkAJTiNCTuGS+OEtvh2
 4ErrgjuWuhZnY45jRrRe6syN+k8rifp00gok5B3L3r2NFwe8mDBKzQVlinZdyPHtj+mT Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3y91njbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:39 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UCJYvx004178;
        Wed, 30 Mar 2022 12:20:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3y91njah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBwnxX020628;
        Wed, 30 Mar 2022 12:20:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8q96c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCKYcV14942592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:20:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 897674203F;
        Wed, 30 Mar 2022 12:20:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE10842045;
        Wed, 30 Mar 2022 12:20:33 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:20:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v3 5/9] KVM: s390: pv: Add query dump information
Date:   Wed, 30 Mar 2022 12:19:48 +0000
Message-Id: <20220330121952.105725-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330121952.105725-1-frankja@linux.ibm.com>
References: <20220330121952.105725-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lYzf8hh-kl4SBHTpokE5A5FVSpMSCk4Q
X-Proofpoint-GUID: aA3t4VUQEL0SPgMhTIpYyOATDtTQ0hRt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_03,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 mlxlogscore=883 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The dump API requires userspace to provide buffers into which we will
store data. The dump information added in this patch tells userspace
how big those buffers need to be.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 11 +++++++++++
 include/uapi/linux/kvm.h | 12 +++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 26307adf6a1c..c6ad3b2e32f9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2257,6 +2257,17 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
 
 		return len_min;
 	}
+	case KVM_PV_INFO_DUMP: {
+		len_min =  sizeof(info->header) + sizeof(info->dump);
+
+		if (info->header.len_max < len_min)
+			return -EINVAL;
+
+		info->dump.dump_cpu_buffer_len = uv_info.guest_cpu_stor_len;
+		info->dump.dump_config_mem_buffer_per_1m = uv_info.conf_dump_storage_state_len;
+		info->dump.dump_config_finalize_len = uv_info.conf_dump_finalize_len;
+		return len_min;
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 21f19863c417..eed2ae8397ae 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1645,6 +1645,13 @@ struct kvm_s390_pv_unp {
 
 enum pv_cmd_info_id {
 	KVM_PV_INFO_VM,
+	KVM_PV_INFO_DUMP,
+};
+
+struct kvm_s390_pv_info_dump {
+	__u64 dump_cpu_buffer_len;
+	__u64 dump_config_mem_buffer_per_1m;
+	__u64 dump_config_finalize_len;
 };
 
 struct kvm_s390_pv_info_vm {
@@ -1664,7 +1671,10 @@ struct kvm_s390_pv_info_header {
 
 struct kvm_s390_pv_info {
 	struct kvm_s390_pv_info_header header;
-	struct kvm_s390_pv_info_vm vm;
+	union {
+		struct kvm_s390_pv_info_dump dump;
+		struct kvm_s390_pv_info_vm vm;
+	};
 };
 
 enum pv_cmd_id {
-- 
2.32.0

