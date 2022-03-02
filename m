Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A94B4CAD34
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244623AbiCBSM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbiCBSMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:12:41 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45794D1994;
        Wed,  2 Mar 2022 10:11:57 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222HpIWX036439;
        Wed, 2 Mar 2022 18:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GNm57nIHmvnIF4jojN/Gffaspu3Os3PHR9VM1RclCtM=;
 b=CzuHNVYANxljRQsmHZJvMfodOlZeY6jf/QZhdwMApKm30T+CwiH/osCW1FNJvctANC7y
 6wtxO6eJ2huBvSq9dZklcPzyIyXYKLOZuOjQFt84eZKcMhi5QhtHth25FNSy7r/m94R7
 YPqw5RsgPilVHy9bdH6lUj8aFAe80Z6En99Zf/+BnweKSvC4W0MT3Qt+1ddcVZ+7E8X2
 M/6ytuhavG5lkvmjJVn8fFxvkIceOn2nD8zTc+B1zNX1Ad3Hv1VFhM3sOQ5nIHg6P9w8
 BSKzhgJGEaP3IxLtVxXaCMkFjy65IPf5UhgPdtk+gDdiCo9F0yLfdj/vQ2S5FLrYh40k Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbj4u0ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222HZkC7040164;
        Wed, 2 Mar 2022 18:11:55 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbj4u0c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222I91t3022208;
        Wed, 2 Mar 2022 18:11:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3efbfjqm2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222IBpCO34275766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 18:11:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DAE652052;
        Wed,  2 Mar 2022 18:11:51 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A12E952050;
        Wed,  2 Mar 2022 18:11:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 12/17] KVM: s390: pv: refactoring of kvm_s390_pv_deinit_vm
Date:   Wed,  2 Mar 2022 19:11:38 +0100
Message-Id: <20220302181143.188283-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302181143.188283-1-imbrenda@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JFvPfQzSJuWZb19wDaMToE77lGXO_8-Y
X-Proofpoint-GUID: fHo5GwLuwEt-SmAW0QZkNq9CgSLR4-C1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 clxscore=1015 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=972 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2203020078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_s390_pv_deinit_vm to improve readability and simplify the
improvements that are coming in subsequent patches.

No functional change intended.

[note: this can potentially be squashed into the next patch, I factored
it out to simplify the review process]

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 788b96b36931..be3b467f8feb 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -180,17 +180,17 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
-	if (!cc)
-		atomic_dec(&kvm->mm->context.protected_count);
-	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
-	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Intended memory leak on "impossible" error */
 	if (!cc) {
+		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
-		return 0;
+	} else {
+		/* Intended memory leak on "impossible" error */
+		s390_replace_asce(kvm->arch.gmap);
 	}
-	s390_replace_asce(kvm->arch.gmap);
-	return -EIO;
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
+
+	return cc ? -EIO : 0;
 }
 
 static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
-- 
2.34.1

