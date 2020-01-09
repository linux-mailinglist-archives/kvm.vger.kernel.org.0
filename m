Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66AB7135C02
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgAIO6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:58:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732069AbgAIO6T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:58:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EkI6h8xSN7v+a4eMQahKlRzNqUClc6kri5FkEiWNSSA=;
        b=QApgU3+BKXSIIzpsfnHfNqtIW0nY2BldtgSGuXmyIbFy0wvl0XE/l9E+CLUrgHVDhjs6D4
        HzSdQ49TxB7u8PhJdsjyfNmY55p4092/GsjAUzvHIqgHObdipcwsEMAQV6py/ZL28GO+na
        SnDmrx7TXzYGnA4fU9D/BNVzrmSOMPM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-47R9hmKfN4mTfDuN8BY3JA-1; Thu, 09 Jan 2020 09:58:17 -0500
X-MC-Unique: 47R9hmKfN4mTfDuN8BY3JA-1
Received: by mail-qt1-f198.google.com with SMTP id b14so4394110qtt.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EkI6h8xSN7v+a4eMQahKlRzNqUClc6kri5FkEiWNSSA=;
        b=G2PGJzZrAR+p7DG87bbb4ytO3VETSn0kX/mFr4rPcSXY8o853c4h+z19pBpxECdy1a
         TnrSaGtuRYehLh/GbXpz79xhFYk3cS3iKRC6sNhDUu2q29ASpVA86exXT1ZHqLbmru5t
         pNtlkjQzX4qrh9tx1aTUrAiEgIFkn3KPTpIkM5j0hiew9ojI+a/X27l5k6DHEZnv4LXI
         EMngUCntFWu4rWGZ6Cy7wB3r+t4xZ2DvJ16DbxQ8BkVbm/QDqs3xeuHZuYEfkO42oMhu
         RlFRNQjo/PF37PYDX1JI3LR9yVlxk4fYh07+N0yyc/s2kuvXjW52j0KI4ufJB70T0Wqj
         wURw==
X-Gm-Message-State: APjAAAV9zJBMxKXJjNZSO0DqGXA5nIVE0uh2kGRlOUTwrCGXK2qH/9MI
        /R1INna+rh1p85w9uA7L4jzJFDaqzpw7Rz/wFlj/nWDuVq3IWshh53sArJUwtha/j/OOsouK2y1
        d1MmrAWmx3gYP
X-Received: by 2002:ae9:f442:: with SMTP id z2mr10150768qkl.130.1578581896686;
        Thu, 09 Jan 2020 06:58:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqzBAarLMa55uVokrirkTNLb6eELDuIHQGq/dU1S1sfC9y2eLW5K4vaMv9gn/0Ij3PCki0kUlw==
X-Received: by 2002:ae9:f442:: with SMTP id z2mr10150744qkl.130.1578581896459;
        Thu, 09 Jan 2020 06:58:16 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:16 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 16/21] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Thu,  9 Jan 2020 09:57:24 -0500
Message-Id: <20200109145729.32898-17-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be needed to extend the kvm selftest program.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f0a16b4adbbd..d2300a3cfbf0 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -247,6 +248,13 @@ struct kvm_hyperv_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
+struct kvm_dirty_ring_indices {
+	__u32 avail_index; /* set by kernel */
+	__u32 padding1;
+	__u32 fetch_index; /* set by userspace */
+	__u32 padding2;
+};
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -421,6 +429,13 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+
+	struct kvm_dirty_ring_indices vcpu_ring_indices;
+};
+
+/* Returned by mmap(kvm->fd, offset=0) */
+struct kvm_vm_run {
+	struct kvm_dirty_ring_indices vm_ring_indices;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1009,6 +1024,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_DIRTY_LOG_RING 179
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1473,6 +1489,9 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1623,4 +1642,23 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+/*
+ * The following are the requirements for supporting dirty log ring
+ * (by enabling KVM_DIRTY_LOG_PAGE_OFFSET).
+ *
+ * 1. Memory accesses by KVM should call kvm_vcpu_write_* instead
+ *    of kvm_write_* so that the global dirty ring is not filled up
+ *    too quickly.
+ * 2. kvm_arch_mmu_enable_log_dirty_pt_masked should be defined for
+ *    enabling dirty logging.
+ * 3. There should not be a separate step to synchronize hardware
+ *    dirty bitmap with KVM's.
+ */
+
+struct kvm_dirty_gfn {
+	__u32 pad;
+	__u32 slot;
+	__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
-- 
2.24.1

