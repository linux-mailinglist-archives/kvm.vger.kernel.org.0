Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA326517292
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385776AbiEBPej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385775AbiEBPeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:34:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01506101D4;
        Mon,  2 May 2022 08:31:01 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242EoOHk026423;
        Mon, 2 May 2022 15:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=VweGRJga5lJ+7d9nSzCV68L/gXM8BKVY0knL58Lll8o=;
 b=qw/kn9srPV8D8kxWPm/Zmsl22+0gcHqXLfwTgNWLci1EwhDXgPBlzC99Bl9q7hbfPiK4
 DLZfb5Ucg3zTJZqCxjTo9P+H/CbrBketc96zB8x18TWSo9C1xpTM5YW3mdToB7gDaBNm
 62rF4LOomJ7N18LU/b7jyBqtGtR5CUIFs2FnzMdtGrqplO9ovRN0WVeooIuQq0KsXCCW
 T2iAHnZZhnYNSgJMFd9Cdn6b8FgRBbqsjbuxdKrkw8teMye2Pyk6DqztMevSFgFV/U5G
 /o2iZ7Q39B9I8vZIpoySAw8WOYt7FTl8wjncuVDpzKgOtxM4uRWbT9qF+STXqHzDMtt1 XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fth1jsh7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:31:00 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242FV0qq032167;
        Mon, 2 May 2022 15:31:00 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fth1jsh6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:31:00 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242FSEQq012022;
        Mon, 2 May 2022 15:30:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3frvr8tbpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:30:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242FUsBl58327384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 15:30:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5AFF11C052;
        Mon,  2 May 2022 15:30:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3E4F11C050;
        Mon,  2 May 2022 15:30:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  2 May 2022 15:30:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 77F79E02C7; Mon,  2 May 2022 17:30:54 +0200 (CEST)
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
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 1/1] KVM: s390: Fix lockdep issue in vm memop
Date:   Mon,  2 May 2022 17:30:53 +0200
Message-Id: <20220502153053.6460-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502153053.6460-1-borntraeger@linux.ibm.com>
References: <20220502153053.6460-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R5LWn7ohBGxFQFkQwkXAa7JWDRfqWGGG
X-Proofpoint-GUID: bHv7H47JsW119N-XIPyuIdMhjnK3jL9H
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Issuing a vm memop on a protected vm does not make sense,
neither is the memory readable/writable, nor does it make sense to check
storage keys. This is why the ioctl will return -EINVAL when it detects
the vm to be protected. However, in order to ensure that the vm cannot
become protected during the memop, the kvm->lock would need to be taken
for the duration of the ioctl. This is also required because
kvm_s390_pv_is_protected asserts that the lock must be held.
Instead, don't try to prevent this. If user space enables secure
execution concurrently with a memop it must accecpt the possibility of
the memop failing.
Still check if the vm is currently protected, but without locking and
consider it a heuristic.

Fixes: ef11c9463ae0 ("KVM: s390: Add vm IOCTL for key checked guest absolute memory access")
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220322153204.2637400-1-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b53ff693b66e..7240a781ea82 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2385,7 +2385,16 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 		return -EINVAL;
 	if (mop->size > MEM_OP_MAX_SIZE)
 		return -E2BIG;
-	if (kvm_s390_pv_is_protected(kvm))
+	/*
+	 * This is technically a heuristic only, if the kvm->lock is not
+	 * taken, it is not guaranteed that the vm is/remains non-protected.
+	 * This is ok from a kernel perspective, wrongdoing is detected
+	 * on the access, -EFAULT is returned and the vm may crash the
+	 * next time it accesses the memory in question.
+	 * There is no sane usecase to do switching and a memop on two
+	 * different CPUs at the same time.
+	 */
+	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
 	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
 		if (access_key_invalid(mop->key))
-- 
2.35.1

