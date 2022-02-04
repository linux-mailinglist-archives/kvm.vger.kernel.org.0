Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D71C4A9C81
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376506AbiBDPyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376353AbiBDPyG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:06 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214EJ3mu006647;
        Fri, 4 Feb 2022 15:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4JtnqvL7N//9lo4OWZa+wonRRoQMA8l8CqU48HoYSsU=;
 b=WK6/9P3sTNJ4xEP+Kd2qGdkM1jdVkzzuw66DyNEdgMXtTZhilqSy2SvM+pfLwZm6oNAV
 WVvenziosqeJfV3RRWSCebnzdN9s1EVsu3FjJwP4xRytpHOvbSTFhEtYuAEVdpfTmIHb
 hJCXuavmHwLP7XRVzzMtc6md2hd6Xv9Mp0/p85ORVbER24yvdu1pneeuoEHCSK+X7pcu
 F29FVKinvXWg+VwAsm5bgiXkf0V/wp1OyeCFp+Wj/WQUxcFJozx7CWgOZ6+F06pwW3cq
 A4eTl9aVLyY2CadcZPKHYfBxQxg52w+VAWCaU7hBbZFsBu/bHdOcDJfHiZtD5i3xrxQr DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12gagv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:06 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214FQ0OZ027131;
        Fri, 4 Feb 2022 15:54:05 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12gafy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:05 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214Fld4f009753;
        Fri, 4 Feb 2022 15:54:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e0r11p0ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214Fi2XM41353692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:44:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B62F1AE04D;
        Fri,  4 Feb 2022 15:53:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33A59AE055;
        Fri,  4 Feb 2022 15:53:58 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:58 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 13/17] KVM: s390: pv: cleanup leftover protected VMs if needed
Date:   Fri,  4 Feb 2022 16:53:45 +0100
Message-Id: <20220204155349.63238-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _HJE0wIws8YEhh9mLcVDDI0saMmzuIZs
X-Proofpoint-ORIG-GUID: UxHgzB8xuBQNKGSr51iQVUQr8UKDltxk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In upcoming patches it will be possible to start tearing down a
protected VM, and finish the teardown concurrently in a different
thread.

Protected VMs that are pending for tear down ("leftover") need to be
cleaned properly when the userspace process (e.g. qemu) terminates.

This patch makes sure that all "leftover" protected VMs are always
properly torn down.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/pv.c               | 69 ++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 1bccb8561ba9..50e3516cbc03 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -922,6 +922,8 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	void *async_deinit;
+	struct list_head need_cleanup;
 	struct mmu_notifier mmu_notifier;
 };
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0fc8d1aec396..141fb9d74ecd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2787,6 +2787,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_s390_vsie_init(kvm);
 	if (use_gisa)
 		kvm_s390_gisa_init(kvm);
+	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
 	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
 
 	return 0;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 4e4728ec83a7..6098af63f112 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -16,6 +16,19 @@
 #include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
+/**
+ * @struct deferred_priv
+ * Represents a "leftover" protected VM that does not correspond to any
+ * active KVM VM.
+ */
+struct deferred_priv {
+	struct list_head list;
+	unsigned long old_table;
+	u64 handle;
+	void *stor_var;
+	unsigned long stor_base;
+};
+
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
 {
 	kvm->arch.pv.handle = 0;
@@ -163,6 +176,60 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	return -ENOMEM;
 }
 
+/**
+ * kvm_s390_pv_cleanup_deferred - Clean up one leftover protected VM.
+ * @kvm the KVM that was associated with this leftover protected VM
+ * @deferred details about the leftover protected VM that needs a clean up
+ * Return: 0 in case of success, otherwise 1
+ */
+static int kvm_s390_pv_cleanup_deferred(struct kvm *kvm, struct deferred_priv *deferred)
+{
+	u16 rc, rrc;
+	int cc;
+
+	cc = uv_cmd_nodata(deferred->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", rc, rrc);
+	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
+	if (cc)
+		return cc;
+	/*
+	 * Intentionally leak unusable memory. If the UVC fails, the memory
+	 * used for the VM and its metadata is permanently unusable.
+	 * This can only happen in case of a serious KVM or hardware bug; it
+	 * is not expected to happen in normal operation.
+	 */
+	free_pages(deferred->stor_base, get_order(uv_info.guest_base_stor_len));
+	free_pages(deferred->old_table, CRST_ALLOC_ORDER);
+	vfree(deferred->stor_var);
+	return 0;
+}
+
+/**
+ * kvm_s390_pv_cleanup_leftovers - Clean up all leftover protected VMs.
+ * @kvm the KVM whose leftover protected VMs are to be cleaned up
+ * Return: 0 in case of success, otherwise 1
+ */
+static int kvm_s390_pv_cleanup_leftovers(struct kvm *kvm)
+{
+	struct deferred_priv *deferred;
+	int cc = 0;
+
+	if (kvm->arch.pv.async_deinit)
+		list_add(kvm->arch.pv.async_deinit, &kvm->arch.pv.need_cleanup);
+
+	while (!list_empty(&kvm->arch.pv.need_cleanup)) {
+		deferred = list_first_entry(&kvm->arch.pv.need_cleanup, typeof(*deferred), list);
+		if (kvm_s390_pv_cleanup_deferred(kvm, deferred))
+			cc = 1;
+		else
+			atomic_dec(&kvm->mm->context.protected_count);
+		list_del(&deferred->list);
+		kfree(deferred);
+	}
+	kvm->arch.pv.async_deinit = NULL;
+	return cc;
+}
+
 /* this should not fail, but if it does, we must not free the donated memory */
 int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
@@ -190,6 +257,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
 
+	cc |= kvm_s390_pv_cleanup_leftovers(kvm);
+
 	return cc ? -EIO : 0;
 }
 
-- 
2.34.1

