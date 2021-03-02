Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A66632B5BF
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449311AbhCCHTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1444015AbhCBUtR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 15:49:17 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122Kiva0019704;
        Tue, 2 Mar 2021 15:48:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1FijDBwr/EkYnd5r4iVjvrLE8UHpNR8E6i0Rhewa7Rs=;
 b=nPEV3BLITGntiKJtJIBeLkJBpU2tE/iafk/E6MyGpCdI7/ZEFZOkqO0go1nU7GqhUt6I
 81bl1F/MW47NfaiV2y2IU4d0SvsSnq/a6f0eWkWfofnZmQ6bjh+Xcz2XtLxbYXUkPvqj
 KqURtmjeVM5s51Ar1GXfbXqzRKgWXvSyifYqWAW9Q88hRjk7bMfOYYJaIxiWZrDsSEIg
 fzHvbn9kA3E+3dKJYOa+NjQ5YQusGF9EGxpRJN+ZOCUv2x0pRwoFI00OZzH8HBaKM4GJ
 CSXa1pviayw39AjvvIsbdUhMq124RZmSK/Vdc6OOukag6uK44rqtnFH+GMVXRSIHFZ+i 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371vnsr4mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 15:48:30 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122Kj3aU020951;
        Tue, 2 Mar 2021 15:48:30 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371vnsr4mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 15:48:30 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122KmRQP008408;
        Tue, 2 Mar 2021 20:48:29 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 36ydq988jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 20:48:29 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122KmSdw25755970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 20:48:28 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D4D128064;
        Tue,  2 Mar 2021 20:48:28 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CC6428059;
        Tue,  2 Mar 2021 20:48:28 +0000 (GMT)
Received: from amdrome1.watson.ibm.com (unknown [9.2.130.16])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 20:48:28 +0000 (GMT)
From:   Dov Murik <dovmurik@linux.vnet.ibm.com>
To:     qemu-devel@nongnu.org
Cc:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Jon Grimm <jon.grimm@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [RFC PATCH 01/26] linux-headers: Add definitions of KVM page encryption bitmap ioctls
Date:   Tue,  2 Mar 2021 15:47:57 -0500
Message-Id: <20210302204822.81901-2-dovmurik@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210302204822.81901-1-dovmurik@linux.vnet.ibm.com>
References: <20210302204822.81901-1-dovmurik@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103020156
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for two ioctls KVM_GET_PAGE_ENC_BITMAP and
KVM_SET_PAGE_ENC_BITMAP used to record the encryption state of each
guest page.

This patch will be replaced by a new implementation based on shared
regions list, or by user-space handling of the regions list.  However,
these changes do not affect the use of the page encryption indication in
confidential guest migration flow.

Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
---
 linux-headers/linux/kvm.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 020b62a619..836c3776c0 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -532,6 +532,16 @@ struct kvm_dirty_log {
 	};
 };
 
+/* for KVM_GET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
 /* for KVM_CLEAR_DIRTY_LOG */
 struct kvm_clear_dirty_log {
 	__u32 slot;
@@ -1557,6 +1567,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc7, struct kvm_page_enc_bitmap)
+
 /* Available with KVM_CAP_X86_MSR_FILTER */
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
 
-- 
2.20.1

