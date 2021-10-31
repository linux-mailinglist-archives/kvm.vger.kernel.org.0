Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C43A440E27
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhJaMN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhJaMNr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VBGYKs024050;
        Sun, 31 Oct 2021 12:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=vADK3IR8Do69WgnSFcZHsSy0UXX1koSImY3K85294n0=;
 b=ad/NQuhfsYDLUpaDSoMyCVCynclEZf8BvqxR7IJrRgRNW5CceP+cgqo2MRgXn76SuzE0
 g0tbEXhHlF7HW9moYyoNGQMOkICass25UfrNEbWdyppwsulCRjNkBTQXCS2o9t/ZG9VL
 qKZdQ3j5b+cl8lV2xWVlVYxKUUnCzhwxGR9wkbbjgZIEmanBcBiRwkJpw12BSxCwkyzF
 T1FZsXaUnHsn8d3Zrs6ggcH6r/Xq39qe4Xzd+0GK5phwL8YWVAEjIc2kQw2d/w8swQEa
 p9rrDwPLhrfdeWujxNoD3FODA01vu2IfPgwsVnsX3mTTr+Qi+jFg6CPHCBSd65zSIXyM xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1t4k8m8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VC2Mip012457;
        Sun, 31 Oct 2021 12:11:15 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1t4k8m8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC8sFH008835;
        Sun, 31 Oct 2021 12:11:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3c0wpa57qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB9fj39846318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D7CE5204E;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 5C3EC52051;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 196E7E06C2; Sun, 31 Oct 2021 13:11:09 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 13/17] KVM: s390: Simplify SIGP Set Arch handling
Date:   Sun, 31 Oct 2021 13:11:00 +0100
Message-Id: <20211031121104.14764-14-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LIkTLyXCI6YKLBBhVA4xZiP2PKAYe49N
X-Proofpoint-ORIG-GUID: yGhxcLK1HUnN8w5FW_frEIjZT3hSPjLl
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

The Principles of Operations describe the various reasons that
each individual SIGP orders might be rejected, and the status
bit that are set for each condition.

For example, for the Set Architecture order, it states:

  "If it is not true that all other CPUs in the configu-
   ration are in the stopped or check-stop state, ...
   bit 54 (incorrect state) ... is set to one."

However, it also states:

  "... if the CZAM facility is installed, ...
   bit 55 (invalid parameter) ... is set to one."

Since the Configuration-z/Architecture-Architectural Mode (CZAM)
facility is unconditionally presented, there is no need to examine
each VCPU to determine if it is started/stopped. It can simply be
rejected outright with the Invalid Parameter bit.

Fixes: b697e435aeee ("KVM: s390: Support Configuration z/Architecture Mode")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20211008203112.1979843-2-farman@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/sigp.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 683036c1c92a..cf4de80bd541 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -151,22 +151,10 @@ static int __sigp_stop_and_store_status(struct kvm_vcpu *vcpu,
 static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter,
 			   u64 *status_reg)
 {
-	unsigned int i;
-	struct kvm_vcpu *v;
-	bool all_stopped = true;
-
-	kvm_for_each_vcpu(i, v, vcpu->kvm) {
-		if (v == vcpu)
-			continue;
-		if (!is_vcpu_stopped(v))
-			all_stopped = false;
-	}
-
 	*status_reg &= 0xffffffff00000000UL;
 
 	/* Reject set arch order, with czam we're always in z/Arch mode. */
-	*status_reg |= (all_stopped ? SIGP_STATUS_INVALID_PARAMETER :
-					SIGP_STATUS_INCORRECT_STATE);
+	*status_reg |= SIGP_STATUS_INVALID_PARAMETER;
 	return SIGP_CC_STATUS_STORED;
 }
 
-- 
2.31.1

