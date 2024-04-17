Return-Path: <kvm+bounces-15007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F788A8CC8
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9012C282B7E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAD73D576;
	Wed, 17 Apr 2024 20:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g8yDdBT3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7945D24B2F;
	Wed, 17 Apr 2024 20:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713384541; cv=none; b=M/QafMMV2RGAMyfnhM6+RrO0LEjfZhKf54QlHEetoCa/vNWo3OMixmHecTJFUvQJEeyjC8I9kALW3h28pnnDtFBEcpjOfU9skuM4z+RiZZzQhBgtEkY6vsluI/EziHCQ/304gM1idn62W54Akmh7fERnM1bxabrivvAnK2FEJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713384541; c=relaxed/simple;
	bh=CfhsYWVNZYAdeAgcwgTbti0FwjjHvAPhlWACjgNMIU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XRK+eTgK1qmpoPHmP8OyY+Sox9c5VjaybbMXr21SVOmPM/887oRRZ29z+53s6Pp088g4loZxaCfcdCp2U8NyTJenVtb3PM66CfSVjEjkvZo0eQTWk4GhqNrmt+qY0TgOSNdO8qD42EuGbw8IwrHvGF71pSPJzzw0CoUZNTSLB1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g8yDdBT3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HHiVwe011079;
	Wed, 17 Apr 2024 20:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=GKKDoYC8r86r2CgUOwUxPTRe7SRohot7DT/rvFt6X4E=;
 b=g8yDdBT3wW+AvDwZIfURrcdBwUDbVmdm9NLrYeKK4ifjBhXZd5hrKZG1meBm951g99lk
 X3WuC1zGKoKBu01T/rYzJ3B2uysC07Gr2DsZ3b1qqmkgWBWFxJhwDkTXQxwi3uJPd9tv
 seQldds/mBDwOqnVLIl3OpdVJWbSVX36BJA8wJgDVdEdcoZ8wBd9Vk0DN6kIRKfk2jGF
 spD0oK4VFii2H1Ejx94CVllgESngladrmJwq4pVjFJE8xLkiUp3QAxmDzWcBkjTVfD6S
 v5LutP8aIlH/HIbsfypCK7RN4mHmevtQvZ4X+lFLNofy223vSb82ISUIqDAf5OgDBT/e Ng== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgycru9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 20:08:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43HJ7SRb021661;
	Wed, 17 Apr 2024 20:08:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggfny8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 20:08:51 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43HK8oFP023405;
	Wed, 17 Apr 2024 20:08:51 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xfggfny84-2;
	Wed, 17 Apr 2024 20:08:51 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH 1/2] KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if APICv is enabled
Date: Wed, 17 Apr 2024 20:08:48 +0000
Message-Id: <20240417200849.971433-2-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240417200849.971433-1-alejandro.j.jimenez@oracle.com>
References: <20240417200849.971433-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-17_17,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404170141
X-Proofpoint-ORIG-GUID: XHRQMvcBTBOdGB8dk9KfEoSb_2IybWlv
X-Proofpoint-GUID: XHRQMvcBTBOdGB8dk9KfEoSb_2IybWlv

Use the APICv enablement status to determine if APICV_INHIBIT_REASON_ABSENT
needs to be set, instead of unconditionally setting the reason during
initialization.

Specifically, in cases where AVIC is disabled via module parameter or lack
of hardware support, unconditionally setting an inhibit reason due to the
absence of an in-kernel local APIC can lead to a scenario where the reason
incorrectly remains set after a local APIC has been created by either
KVM_CREATE_IRQCHIP or the enabling of KVM_CAP_IRQCHIP_SPLIT. This is
because the helpers in charge of removing the inhibit return early if
enable_apicv is not true, and therefore the bit remains set.

This leads to confusion as to the cause why APICv is not active, since an
incorrect reason will be reported by tracepoints and/or a debugging tool
that examines the currently set inhibit reasons.

Fixes: ef8b4b720368 ("KVM: ensure APICv is considered inactive if there is no APIC")
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26288ca05364..eadd88fabadc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9999,7 +9999,20 @@ static void kvm_apicv_init(struct kvm *kvm)
 
 	init_rwsem(&kvm->arch.apicv_update_lock);
 
-	set_or_clear_apicv_inhibit(inhibits, APICV_INHIBIT_REASON_ABSENT, true);
+	/*
+	 * Unconditionally inhibiting APICv due to the absence of in-kernel
+	 * local APIC can lead to a scenario where APICV_INHIBIT_REASON_ABSENT
+	 * remains set in the apicv_inhibit_reasons after a local APIC has been
+	 * created by either KVM_CREATE_IRQCHIP or the enabling of
+	 * KVM_CAP_IRQCHIP_SPLIT.
+	 * Hardware support and module parameters governing APICv enablement
+	 * have already been evaluated and the initial status is available in
+	 * enable_apicv, so it can be used here to determine if an inhibit needs
+	 * to be set.
+	 */
+	if (enable_apicv)
+		set_or_clear_apicv_inhibit(inhibits,
+					   APICV_INHIBIT_REASON_ABSENT, true);
 
 	if (!enable_apicv)
 		set_or_clear_apicv_inhibit(inhibits,
-- 
2.39.3


