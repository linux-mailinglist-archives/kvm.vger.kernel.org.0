Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8831D5007E4
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240796AbiDNIGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbiDNIGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:06:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2F24D9CA;
        Thu, 14 Apr 2022 01:03:32 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E7CCZf019011;
        Thu, 14 Apr 2022 08:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FxbavKEaL2/SWhpxwKH0jwQ38hSAD5RMhN8l0yeKXak=;
 b=ExCCQkJbh9QMVYgu725Z05khBBReNqfLE6kk1MhagK0LybhVRlNjKkomVtmmJugwjwS2
 DFY3M3erJyW9SXmJzM7PMwtDzSUc2OlkVC7IYvlPyG0KjDdIKs4v62MWsLVdazFYEmIG
 fhOBJqsNJFND+jw5UNzzCwr8w/nwXnGBFdDTgLuvTLCfjpAsGrKQcTklW2CMWTncQnPJ
 pL4DL1U7pdSNs7PKIAsM+6ectoJ0Yakbgv9PsKIQA3XsaXsfvysDDZ/HGi2gVzIAYt4M
 ilH2IRC1PADBRGmoae0isLSBcXwWAmrN5SCJrQeBls11Mk3DmvfZ46CGQmEXQr9gmSRY FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3febpbmmc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:31 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23E7n2I1008494;
        Thu, 14 Apr 2022 08:03:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3febpbmmbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23E7m62k029543;
        Thu, 14 Apr 2022 08:03:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj7yhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23E7oqge46203250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 07:50:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEB37AE059;
        Thu, 14 Apr 2022 08:03:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 527FAAE057;
        Thu, 14 Apr 2022 08:03:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 08:03:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v10 14/19] KVM: s390: pv: cleanup leftover protected VMs if needed
Date:   Thu, 14 Apr 2022 10:03:05 +0200
Message-Id: <20220414080311.1084834-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 417w_Rx1QfBRmakKTDQqkt9YWUuEuA4J
X-Proofpoint-ORIG-GUID: BxHHnhtJ1QOd-X0Uvkjtw_jImkq0fouz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 arch/s390/kvm/kvm-s390.c         |  2 +
 arch/s390/kvm/pv.c               | 69 ++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 5824efe5fc9d..b40a267fd64d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -924,6 +924,8 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	void *async_deinit;
+	struct list_head need_cleanup;
 	struct mmu_notifier mmu_notifier;
 };
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 722cab6fa02b..05c976bf2438 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2881,6 +2881,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_s390_vsie_init(kvm);
 	if (use_gisa)
 		kvm_s390_gisa_init(kvm);
+	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
+	kvm->arch.pv.async_deinit = NULL;
 	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
 
 	return 0;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index bd850be08c86..b20f2cbd43d9 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -17,6 +17,19 @@
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
 
+/**
+ * @struct deferred_priv
+ * Represents a "leftover" protected VM that is still registered with the
+ * Ultravisor, but which does not correspond any longer to an active KVM VM.
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

