Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6922635CAC1
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbhDLQGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15660 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241344AbhDLQGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:12 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG5LqL018633;
        Mon, 12 Apr 2021 12:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=zetLCw32oob2Q6AX76uN+QiVRJ77a/6XsUYrC1/Aw/Y=;
 b=IFbno07Wu8lJjqczwYhguEzuuqALogIa049QrozCahPKO5LmBw/sVEm3cbRxmvACdL7U
 f3Q2RjXiVRqKvkzZ9j5Ux2SB8ug+jX/w8ExQd6mPxdsnDVGqPm8EF0sukAZjD5a4JRQ+
 vjewMiw/kBLnxTn2TAHcOpDRxzuWUOoVR97ghpikepNlfNaRnSSzJngYT5Rqc2qUKVFp
 WYWj7a03g+NriKYpCkS801Hzz0cBFUgGwrxtsUeaP0/38TcVIzSJe5zWaL1WCtjihk7D
 3dkaP4pRTHD5nt/QNjFN4MWcKM+KtW2/WbF+BrcCfce+LWhMhVrNnKjCecOjcUdBNGbQ Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkdjxme5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:53 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG5YrU019896;
        Mon, 12 Apr 2021 12:05:52 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkdjxmcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:52 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFrIEg009950;
        Mon, 12 Apr 2021 16:05:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 37u3n891ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5lt516974232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FE4AA4060;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A446A405B;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 15AF5E02A6; Mon, 12 Apr 2021 18:05:47 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [GIT PULL 3/7] KVM: s390: split kvm_s390_logical_to_effective
Date:   Mon, 12 Apr 2021 18:05:41 +0200
Message-Id: <20210412160545.231194-4-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _FrUTYHDLzb5Z8JsU-CJDI1fvNXmFNYG
X-Proofpoint-GUID: AHcOAmIRLspyemkHyjE_O5lg_Ed1Q4L_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=907 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Split kvm_s390_logical_to_effective to a generic function called
_kvm_s390_logical_to_effective. The new function takes a PSW and an address
and returns the address with the appropriate bits masked off. The old
function now calls the new function with the appropriate PSW from the vCPU.

This is needed to avoid code duplication for vSIE.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: stable@vger.kernel.org # for VSIE: correctly handle MVPG when in VSIE
Link: https://lore.kernel.org/r/20210302174443.514363-2-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/gaccess.h | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index f4c51756c462..2d8631a1f23e 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -36,6 +36,29 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 	return gra;
 }
 
+/**
+ * _kvm_s390_logical_to_effective - convert guest logical to effective address
+ * @psw: psw of the guest
+ * @ga: guest logical address
+ *
+ * Convert a guest logical address to an effective address by applying the
+ * rules of the addressing mode defined by bits 31 and 32 of the given PSW
+ * (extendended/basic addressing mode).
+ *
+ * Depending on the addressing mode, the upper 40 bits (24 bit addressing
+ * mode), 33 bits (31 bit addressing mode) or no bits (64 bit addressing
+ * mode) of @ga will be zeroed and the remaining bits will be returned.
+ */
+static inline unsigned long _kvm_s390_logical_to_effective(psw_t *psw,
+							   unsigned long ga)
+{
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
+		return ga;
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
+		return ga & ((1UL << 31) - 1);
+	return ga & ((1UL << 24) - 1);
+}
+
 /**
  * kvm_s390_logical_to_effective - convert guest logical to effective address
  * @vcpu: guest virtual cpu
@@ -52,13 +75,7 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 static inline unsigned long kvm_s390_logical_to_effective(struct kvm_vcpu *vcpu,
 							  unsigned long ga)
 {
-	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
-		return ga;
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
-		return ga & ((1UL << 31) - 1);
-	return ga & ((1UL << 24) - 1);
+	return _kvm_s390_logical_to_effective(&vcpu->arch.sie_block->gpsw, ga);
 }
 
 /*
-- 
2.30.2

