Return-Path: <kvm+bounces-73236-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGtVM7fnrGlSvwEAu9opvQ
	(envelope-from <kvm+bounces-73236-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:06:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A0522E639
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77C36305513F
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 03:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC38034B1B4;
	Sun,  8 Mar 2026 03:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sc7CiGPV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8DD2848A7;
	Sun,  8 Mar 2026 03:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772939097; cv=none; b=bq/E7vi+5wo5NeRIBNEWWIFBbqwBmfw4aaxqL6N+7we/Bu9IuxLB7zfEd6vcwzkDQHk4n0A+S0cBOAHUrKyCPiADF273YRboZaMGEwCVQVeibMMeAoiK5sxJrBoo6SwNcIgzQP8qhvZYFRzTiPRMd0aao1KxaqcmvZGcgAuycJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772939097; c=relaxed/simple;
	bh=ietlV3dLD3P+A4vdrvg8twFYI6qeNFV7VDLjQyrugyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGlGQY+MVG/bME88tAIkoXGvhQMCXG8REDcYsDk5IaLWjcmyULvT56fu69/7G2M450aM1reqMnw0jdGkSoAGFO2LCrEXM9Aq0665XYgGtdSJbFYkc7ZmX1ksGlhQp6KlvgXDOW2PVVCCghNncRVWmn66edGCrvuObCcZvghnGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sc7CiGPV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627NFCHY3509138;
	Sun, 8 Mar 2026 03:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=K1GlfDRADkkcx8fni
	eqpL+WVzINyWMatk5dWpZG5MD8=; b=Sc7CiGPV3W9mRnZBTu9A0StJb/vXOfjQA
	3sU4+GqMO7Z5Q7pefCSFHtTwaAXJLRqLLTv2VDje8Lop8vt/9IjHaOTOhPDhikpj
	tZRn73E5x2/6IwS120qv55/PKpFsmp7t3X2khVmW53zkInqTA7aiGv0E4hxzqLxT
	8CRFhRPLIkKtdiI5DGR90U5XQErkjMx7zkf5Kbm/yPViRUX1iq/RngxT8sX/YXF8
	5Q+/TEphdkG6VhakZB62fS45ITONAaj/w5rxDwYE10ffgawImXgz027NnYTTQHNh
	0vZW7P2TxgCOwMdee+mkMYwxKLDnyMC5kjUhtAMqGO/tTHZFeXeDA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvm2kp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 627KNAEo008779;
	Sun, 8 Mar 2026 03:04:46 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmdd1w9v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:46 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62834jgh27198096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 8 Mar 2026 03:04:45 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2128E58058;
	Sun,  8 Mar 2026 03:04:45 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F49C58057;
	Sun,  8 Mar 2026 03:04:44 +0000 (GMT)
Received: from 9.60.13.83 (unknown [9.60.13.83])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  8 Mar 2026 03:04:44 +0000 (GMT)
From: Douglas Freimuth <freimuth@linux.ibm.com>
To: borntraeger@linux.ibm.com, imbrenda@linux.ibm.com, frankja@linux.ibm.com,
        david@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mjrosato@linux.ibm.com, freimuth@linux.ibm.com
Subject: [PATCH v1 3/3] Introducing kvm_arch_set_irq_inatomic fast inject
Date: Sun,  8 Mar 2026 04:04:38 +0100
Message-ID: <20260308030438.88580-4-freimuth@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260308030438.88580-1-freimuth@linux.ibm.com>
References: <20260308030438.88580-1-freimuth@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KFIiBZPp0qBUVdDqDv_-E3n4xR8oV-Jh
X-Proofpoint-ORIG-GUID: KFIiBZPp0qBUVdDqDv_-E3n4xR8oV-Jh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDAyNiBTYWx0ZWRfX/9lP+VcjsGJD
 yCDIggAegBN62H60qdJlz0ismJWbVzP6s8TG+he2Z7ZqCfPY7MxWlowR2eBAPoyGKPnqkh4FjdE
 0YJ782+eYPPRR1M/lCisvCdFL6AmTSVUe2rWbLmfHRXmkIlLCWjhkIHR2HzULn4QEd+PWiCoTRV
 byBfL1V8pgm4by+D7ULZxCV1rP+i8DZXrNU+s+2yMghRxqwlcPeyV8pG5xSuJyIGT/ztkgaiAIj
 jt9+9r3DHwMzHxJ+jZQv39AXL5JRv67HRKoK7w4SV4jI1Xcu+q8cV0cvTyaQMDN4h8GahPMJkXI
 oo6rZi2053wo/d3WzyuWz4zLFRWFzVMAP6SrbC5EwnN/D6yxzRn7iBHawPLbFLWEV7dC81tEcw/
 LUiJz18AM4Qr5X3C0f96ckhQh6u/jB+7B3CB8GAaC8DSkjhRdLifX6iM9Ngcqc/rYmV9O93NcVs
 Yeky69QZmIxpAIN1yiA==
X-Authority-Analysis: v=2.4 cv=B5q0EetM c=1 sm=1 tr=0 ts=69ace74f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=Td7JJUAnW6VTKjkzrnUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_01,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603080026
X-Rspamd-Queue-Id: 44A0522E639
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73236-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[freimuth@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.988];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Patch 3: This patch introduces kvm_arch_set_irq_inatomic, a fast path
for irq injection. Instead of placing all interrupts on the global work
queue as it does today, this patch provides a fast path for irq
injection. Statistical counters have been added to enable analysis of irq injection on
the fast path and slow path including io_390_inatomic,
io_flic_inject_airq, io_set_adapter_int and io_390_inatomic_adapter_masked.

In order to use this kernel series with virtio-pci, a QEMU that includes
the 's390x/pci: set kvm_msi_via_irqfd_allowed' fix is needed.
Additionally, the guest xml needs a thread pool and threads explicitly
assigned per disk device using the common way of defining threads for
disks.


Signed-off-by: Douglas Freimuth <freimuth@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   8 +-
 arch/s390/kvm/interrupt.c        | 169 ++++++++++++++++++++++++++-----
 arch/s390/kvm/kvm-s390.c         |  24 ++++-
 arch/s390/kvm/kvm-s390.h         |   3 +-
 4 files changed, 170 insertions(+), 34 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 616be8ca4614..a194e9808ae3 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -359,7 +359,7 @@ struct kvm_s390_float_interrupt {
 	struct kvm_s390_mchk_info mchk;
 	struct kvm_s390_ext_info srv_signal;
 	int last_sleep_cpu;
-	struct mutex ais_lock;
+	spinlock_t ais_lock;
 	u8 simm;
 	u8 nimm;
 };
@@ -450,6 +450,10 @@ struct kvm_vm_stat {
 	u64 inject_io;
 	u64 io_390_adapter_map;
 	u64 io_390_adapter_unmap;
+	u64 io_390_inatomic;
+	u64 io_flic_inject_airq;
+	u64 io_set_adapter_int;
+	u64 io_390_inatomic_adapter_masked;
 	u64 inject_float_mchk;
 	u64 inject_pfault_done;
 	u64 inject_service_signal;
@@ -481,7 +485,7 @@ struct s390_io_adapter {
 	bool masked;
 	bool swap;
 	bool suppressible;
-	struct rw_semaphore maps_lock;
+	spinlock_t maps_lock;
 	struct list_head maps;
 	unsigned int nr_maps;
 };
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 350106f84763..0429a1bc4b7a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1963,15 +1963,10 @@ static int __inject_vm(struct kvm *kvm, struct kvm_s390_interrupt_info *inti)
 }
 
 int kvm_s390_inject_vm(struct kvm *kvm,
-		       struct kvm_s390_interrupt *s390int)
+		       struct kvm_s390_interrupt *s390int, struct kvm_s390_interrupt_info *inti)
 {
-	struct kvm_s390_interrupt_info *inti;
 	int rc;
 
-	inti = kzalloc_obj(*inti, GFP_KERNEL_ACCOUNT);
-	if (!inti)
-		return -ENOMEM;
-
 	inti->type = s390int->type;
 	switch (inti->type) {
 	case KVM_S390_INT_VIRTIO:
@@ -2284,6 +2279,7 @@ static int flic_ais_mode_get_all(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_float_interrupt *fi = &kvm->arch.float_int;
 	struct kvm_s390_ais_all ais;
+	unsigned long flags;
 
 	if (attr->attr < sizeof(ais))
 		return -EINVAL;
@@ -2291,10 +2287,10 @@ static int flic_ais_mode_get_all(struct kvm *kvm, struct kvm_device_attr *attr)
 	if (!test_kvm_facility(kvm, 72))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&fi->ais_lock);
+	spin_lock_irqsave(&fi->ais_lock, flags);
 	ais.simm = fi->simm;
 	ais.nimm = fi->nimm;
-	mutex_unlock(&fi->ais_lock);
+	spin_unlock_irqrestore(&fi->ais_lock, flags);
 
 	if (copy_to_user((void __user *)attr->addr, &ais, sizeof(ais)))
 		return -EFAULT;
@@ -2427,7 +2423,7 @@ static int register_io_adapter(struct kvm_device *dev,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&adapter->maps);
-	init_rwsem(&adapter->maps_lock);
+	spin_lock_init(&adapter->maps_lock);
 	adapter->nr_maps = 0;
 	adapter->id = adapter_info.id;
 	adapter->isc = adapter_info.isc;
@@ -2494,7 +2490,7 @@ static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
 	INIT_LIST_HEAD(&map->list);
 	map->guest_addr = addr;
 	map->addr = addr;
-	down_write(&adapter->maps_lock);
+	spin_lock_irqsave(&adapter->maps_lock, flags);
 	if (adapter->nr_maps++ < MAX_S390_ADAPTER_MAPS) {
 		list_add_tail(&map->list, &adapter->maps);
 		ret = 0;
@@ -2502,7 +2498,7 @@ static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
 		put_page(map->page);
 		ret = -EINVAL;
 	}
-	up_write(&adapter->maps_lock);
+	spin_unlock_irqrestore(&adapter->maps_lock, flags);
 out:
 	if (ret)
 		kfree(map);
@@ -2514,11 +2510,12 @@ static int kvm_s390_adapter_unmap(struct kvm *kvm, unsigned int id, __u64 addr)
 	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
 	struct s390_map_info *map, *tmp;
 	int found = 0;
+	unsigned long flags;
 
 	if (!adapter || !addr)
 		return -EINVAL;
 
-	down_write(&adapter->maps_lock);
+	spin_lock_irqsave(&adapter->maps_lock, flags);
 	list_for_each_entry_safe(map, tmp, &adapter->maps, list) {
 		if (map->guest_addr == addr) {
 			found = 1;
@@ -2529,7 +2526,7 @@ static int kvm_s390_adapter_unmap(struct kvm *kvm, unsigned int id, __u64 addr)
 			break;
 		}
 	}
-	up_write(&adapter->maps_lock);
+	spin_unlock_irqrestore(&adapter->maps_lock, flags);
 
 	return found ? 0 : -ENOENT;
 }
@@ -2630,6 +2627,7 @@ static int modify_ais_mode(struct kvm *kvm, struct kvm_device_attr *attr)
 	struct kvm_s390_float_interrupt *fi = &kvm->arch.float_int;
 	struct kvm_s390_ais_req req;
 	int ret = 0;
+	unsigned long flags;
 
 	if (!test_kvm_facility(kvm, 72))
 		return -EOPNOTSUPP;
@@ -2646,7 +2644,7 @@ static int modify_ais_mode(struct kvm *kvm, struct kvm_device_attr *attr)
 				       2 : KVM_S390_AIS_MODE_SINGLE :
 				       KVM_S390_AIS_MODE_ALL, req.mode);
 
-	mutex_lock(&fi->ais_lock);
+	spin_lock_irqsave(&fi->ais_lock, flags);
 	switch (req.mode) {
 	case KVM_S390_AIS_MODE_ALL:
 		fi->simm &= ~AIS_MODE_MASK(req.isc);
@@ -2659,7 +2657,7 @@ static int modify_ais_mode(struct kvm *kvm, struct kvm_device_attr *attr)
 	default:
 		ret = -EINVAL;
 	}
-	mutex_unlock(&fi->ais_lock);
+	spin_unlock_irqrestore(&fi->ais_lock, flags);
 
 	return ret;
 }
@@ -2673,25 +2671,33 @@ static int kvm_s390_inject_airq(struct kvm *kvm,
 		.parm = 0,
 		.parm64 = isc_to_int_word(adapter->isc),
 	};
+	struct kvm_s390_interrupt_info *inti;
+	unsigned long flags;
+
 	int ret = 0;
 
+	inti = kzalloc_obj(*inti, GFP_KERNEL_ACCOUNT);
+	if (!inti)
+		return -ENOMEM;
+
 	if (!test_kvm_facility(kvm, 72) || !adapter->suppressible)
-		return kvm_s390_inject_vm(kvm, &s390int);
+		return kvm_s390_inject_vm(kvm, &s390int, inti);
 
-	mutex_lock(&fi->ais_lock);
+	spin_lock_irqsave(&fi->ais_lock, flags);
 	if (fi->nimm & AIS_MODE_MASK(adapter->isc)) {
 		trace_kvm_s390_airq_suppressed(adapter->id, adapter->isc);
+		kfree(inti);
 		goto out;
 	}
 
-	ret = kvm_s390_inject_vm(kvm, &s390int);
+	ret = kvm_s390_inject_vm(kvm, &s390int, inti);
 	if (!ret && (fi->simm & AIS_MODE_MASK(adapter->isc))) {
 		fi->nimm |= AIS_MODE_MASK(adapter->isc);
 		trace_kvm_s390_modify_ais_mode(adapter->isc,
 					       KVM_S390_AIS_MODE_SINGLE, 2);
 	}
 out:
-	mutex_unlock(&fi->ais_lock);
+	spin_unlock_irqrestore(&fi->ais_lock, flags);
 	return ret;
 }
 
@@ -2700,6 +2706,8 @@ static int flic_inject_airq(struct kvm *kvm, struct kvm_device_attr *attr)
 	unsigned int id = attr->attr;
 	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
 
+	kvm->stat.io_flic_inject_airq++;
+
 	if (!adapter)
 		return -EINVAL;
 
@@ -2710,6 +2718,7 @@ static int flic_ais_mode_set_all(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_float_interrupt *fi = &kvm->arch.float_int;
 	struct kvm_s390_ais_all ais;
+	unsigned long flags;
 
 	if (!test_kvm_facility(kvm, 72))
 		return -EOPNOTSUPP;
@@ -2717,10 +2726,10 @@ static int flic_ais_mode_set_all(struct kvm *kvm, struct kvm_device_attr *attr)
 	if (copy_from_user(&ais, (void __user *)attr->addr, sizeof(ais)))
 		return -EFAULT;
 
-	mutex_lock(&fi->ais_lock);
+	spin_lock_irqsave(&fi->ais_lock, flags);
 	fi->simm = ais.simm;
 	fi->nimm = ais.nimm;
-	mutex_unlock(&fi->ais_lock);
+	spin_unlock_irqrestore(&fi->ais_lock, flags);
 
 	return 0;
 }
@@ -2852,17 +2861,20 @@ static struct s390_map_info *get_map_info(struct s390_io_adapter *adapter,
 }
 
 static int adapter_indicators_set(struct kvm *kvm,
-				struct s390_io_adapter *adapter,
-				struct kvm_s390_adapter_int *adapter_int)
+				  struct s390_io_adapter *adapter,
+				  struct kvm_s390_adapter_int *adapter_int)
 {
 	unsigned long bit;
 	int summary_set, idx;
 	struct s390_map_info *ind_info, *summary_info;
 	void *map;
 	struct page *ind_page, *summary_page;
+	unsigned long flags;
 
+	spin_lock_irqsave(&adapter->maps_lock, flags);
 	ind_info = get_map_info(adapter, adapter_int->ind_addr);
 	if (!ind_info) {
+		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 		ind_page = get_map_page(kvm, adapter_int->ind_addr);
 		if (!ind_page)
 			return -1;
@@ -2878,8 +2890,13 @@ static int adapter_indicators_set(struct kvm *kvm,
 		map = page_address(ind_info->page);
 		bit = get_ind_bit(ind_info->addr, adapter_int->ind_offset, adapter->swap);
 		set_bit(bit, map);
+		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 	}
 
+	spin_lock_irqsave(&adapter->maps_lock, flags);
+	summary_info = get_map_info(adapter, adapter_int->summary_addr);
+	if (!summary_info) {
+		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 		summary_page = get_map_page(kvm, adapter_int->summary_addr);
 		if (!summary_page) {
 			put_page(ind_page);
@@ -2898,6 +2915,7 @@ static int adapter_indicators_set(struct kvm *kvm,
 		bit = get_ind_bit(summary_info->addr, adapter_int->summary_offset,
 				  adapter->swap);
 		summary_set = test_and_set_bit(bit, map);
+		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 }
 
 	if (!ind_info)
@@ -2907,6 +2925,37 @@ static int adapter_indicators_set(struct kvm *kvm,
 	return summary_set ? 0 : 1;
 }
 
+static int adapter_indicators_set_fast(struct kvm *kvm,
+				       struct s390_io_adapter *adapter,
+				       struct kvm_s390_adapter_int *adapter_int)
+{
+	unsigned long bit;
+	int summary_set;
+	struct s390_map_info *ind_info, *summary_info;
+	void *map;
+
+	spin_lock(&adapter->maps_lock);
+	ind_info = get_map_info(adapter, adapter_int->ind_addr);
+	if (!ind_info) {
+		spin_unlock(&adapter->maps_lock);
+		return -EWOULDBLOCK;
+	}
+	map = page_address(ind_info->page);
+	bit = get_ind_bit(ind_info->addr, adapter_int->ind_offset, adapter->swap);
+	set_bit(bit, map);
+	summary_info = get_map_info(adapter, adapter_int->summary_addr);
+	if (!summary_info) {
+		spin_unlock(&adapter->maps_lock);
+		return -EWOULDBLOCK;
+	}
+	map = page_address(summary_info->page);
+	bit = get_ind_bit(summary_info->addr, adapter_int->summary_offset,
+			  adapter->swap);
+	summary_set = test_and_set_bit(bit, map);
+	spin_unlock(&adapter->maps_lock);
+	return summary_set ? 0 : 1;
+}
+
 /*
  * < 0 - not injected due to error
  * = 0 - coalesced, summary indicator already active
@@ -2919,15 +2968,15 @@ static int set_adapter_int(struct kvm_kernel_irq_routing_entry *e,
 	int ret;
 	struct s390_io_adapter *adapter;
 
+	kvm->stat.io_set_adapter_int++;
+
 	/* We're only interested in the 0->1 transition. */
 	if (!level)
 		return 0;
 	adapter = get_io_adapter(kvm, e->adapter.adapter_id);
 	if (!adapter)
 		return -1;
-	down_read(&adapter->maps_lock);
 	ret = adapter_indicators_set(kvm, adapter, &e->adapter);
-	up_read(&adapter->maps_lock);
 	if ((ret > 0) && !adapter->masked) {
 		ret = kvm_s390_inject_airq(kvm, adapter);
 		if (ret == 0)
@@ -2982,7 +3031,6 @@ int kvm_set_routing_entry(struct kvm *kvm,
 	int idx;
 
 	switch (ue->type) {
-	/* we store the userspace addresses instead of the guest addresses */
 	case KVM_IRQ_ROUTING_S390_ADAPTER:
 		if (kvm_is_ucontrol(kvm))
 			return -EINVAL;
@@ -3565,3 +3613,72 @@ int __init kvm_s390_gib_init(u8 nisc)
 out:
 	return rc;
 }
+
+/*
+ * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
+ */
+int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+			      struct kvm *kvm, int irq_source_id, int level,
+			      bool line_status)
+{
+	int ret;
+	struct s390_io_adapter *adapter;
+	struct kvm_s390_float_interrupt *fi = &kvm->arch.float_int;
+	struct kvm_s390_interrupt_info *inti;
+	struct kvm_s390_interrupt s390int = {
+			.type = KVM_S390_INT_IO(1, 0, 0, 0),
+			.parm = 0,
+	};
+
+	kvm->stat.io_390_inatomic++;
+
+	/* We're only interested in the 0->1 transition. */
+	if (!level)
+		return -EWOULDBLOCK;
+	if (e->type != KVM_IRQ_ROUTING_S390_ADAPTER)
+		return -EWOULDBLOCK;
+
+	adapter = get_io_adapter(kvm, e->adapter.adapter_id);
+	if (!adapter)
+		return -EWOULDBLOCK;
+
+	s390int.parm64 = isc_to_int_word(adapter->isc);
+	ret = adapter_indicators_set_fast(kvm, adapter, &e->adapter);
+	if (ret < 0)
+		return -EWOULDBLOCK;
+	if (!ret || adapter->masked) {
+		kvm->stat.io_390_inatomic_adapter_masked++;
+		return 0;
+	}
+
+	inti = kzalloc_obj(*inti, GFP_ATOMIC);
+	if (!inti)
+		return -EWOULDBLOCK;
+
+	if (!test_kvm_facility(kvm, 72) || !adapter->suppressible) {
+		ret = kvm_s390_inject_vm(kvm, &s390int, inti);
+			if (ret == 0)
+				return ret;
+			else
+				return -EWOULDBLOCK;
+		}
+
+	spin_lock(&fi->ais_lock);
+	if (fi->nimm & AIS_MODE_MASK(adapter->isc)) {
+		trace_kvm_s390_airq_suppressed(adapter->id, adapter->isc);
+		kfree(inti);
+		goto out;
+	}
+
+	ret = kvm_s390_inject_vm(kvm, &s390int, inti);
+	if (!ret && (fi->simm & AIS_MODE_MASK(adapter->isc))) {
+		fi->nimm |= AIS_MODE_MASK(adapter->isc);
+		trace_kvm_s390_modify_ais_mode(adapter->isc,
+					       KVM_S390_AIS_MODE_SINGLE, 2);
+	}
+	goto out;
+
+out:
+	spin_unlock(&fi->ais_lock);
+	return 0;
+}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8e6532f55a5a..29386afe6b29 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -70,6 +70,10 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, inject_io),
 	STATS_DESC_COUNTER(VM, io_390_adapter_map),
 	STATS_DESC_COUNTER(VM, io_390_adapter_unmap),
+	STATS_DESC_COUNTER(VM, io_390_inatomic),
+	STATS_DESC_COUNTER(VM, io_flic_inject_airq),
+	STATS_DESC_COUNTER(VM, io_set_adapter_int),
+	STATS_DESC_COUNTER(VM, io_390_inatomic_adapter_masked),
 	STATS_DESC_COUNTER(VM, inject_float_mchk),
 	STATS_DESC_COUNTER(VM, inject_pfault_done),
 	STATS_DESC_COUNTER(VM, inject_service_signal),
@@ -2844,6 +2848,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	struct kvm_device_attr attr;
 	int r;
+	struct kvm_s390_interrupt_info *inti;
 
 	switch (ioctl) {
 	case KVM_S390_INTERRUPT: {
@@ -2852,7 +2857,10 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		r = -EFAULT;
 		if (copy_from_user(&s390int, argp, sizeof(s390int)))
 			break;
-		r = kvm_s390_inject_vm(kvm, &s390int);
+		inti = kzalloc_obj(*inti, GFP_KERNEL_ACCOUNT);
+		if (!inti)
+			return -ENOMEM;
+		r = kvm_s390_inject_vm(kvm, &s390int, inti);
 		break;
 	}
 	case KVM_CREATE_IRQCHIP: {
@@ -3250,7 +3258,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		mutex_unlock(&kvm->lock);
 	}
 
-	mutex_init(&kvm->arch.float_int.ais_lock);
+	spin_lock_init(&kvm->arch.float_int.ais_lock);
 	spin_lock_init(&kvm->arch.float_int.lock);
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
 		INIT_LIST_HEAD(&kvm->arch.float_int.lists[i]);
@@ -4371,11 +4379,16 @@ int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clo
 	return 1;
 }
 
-static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
-				      unsigned long token)
+static int __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
+				     unsigned long token)
 {
 	struct kvm_s390_interrupt inti;
 	struct kvm_s390_irq irq;
+	struct kvm_s390_interrupt_info *inti_mem;
+
+	inti_mem = kzalloc_obj(*inti_mem, GFP_KERNEL_ACCOUNT);
+	if (!inti_mem)
+		return -ENOMEM;
 
 	if (start_token) {
 		irq.u.ext.ext_params2 = token;
@@ -4384,8 +4397,9 @@ static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
 	} else {
 		inti.type = KVM_S390_INT_PFAULT_DONE;
 		inti.parm64 = token;
-		WARN_ON_ONCE(kvm_s390_inject_vm(vcpu->kvm, &inti));
+		WARN_ON_ONCE(kvm_s390_inject_vm(vcpu->kvm, &inti, inti_mem));
 	}
+	return true;
 }
 
 bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index bf1d7798c1af..2f2da868a040 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -373,7 +373,8 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu);
 void kvm_s390_clear_local_irqs(struct kvm_vcpu *vcpu);
 void kvm_s390_clear_float_irqs(struct kvm *kvm);
 int __must_check kvm_s390_inject_vm(struct kvm *kvm,
-				    struct kvm_s390_interrupt *s390int);
+				    struct kvm_s390_interrupt *s390int,
+				    struct kvm_s390_interrupt_info *inti);
 int __must_check kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
 				      struct kvm_s390_irq *irq);
 static inline int kvm_s390_inject_prog_irq(struct kvm_vcpu *vcpu,
-- 
2.52.0


