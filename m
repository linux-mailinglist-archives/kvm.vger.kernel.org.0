Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE72F128686
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLUCEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:04:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53727 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726666AbfLUCEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 21:04:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ulPWf8Brzg5F7en4DnY+b2FP2/4bB7SIlRQb5Tezjhk=;
        b=R9t2ev+fi1N5DYsLN0hhheS+2T/US+FEu+zxZ1mVF+jDfmf+nJV81jPG+ceN9AsruqxG0n
        tPYGBKYWIJomf4yB5QO6HKjTEqrrQ4Urncz2mJQR1xa54ZZhUbRKXaTvpn7Rc1JS94DA/i
        vWw7WJ7SFntWQexOvokMKG7ctGk/CZ4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-bpx6fQSNN_6TgyMFYEjoPw-1; Fri, 20 Dec 2019 21:04:51 -0500
X-MC-Unique: bpx6fQSNN_6TgyMFYEjoPw-1
Received: by mail-qk1-f198.google.com with SMTP id a6so4471601qkl.7
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 18:04:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ulPWf8Brzg5F7en4DnY+b2FP2/4bB7SIlRQb5Tezjhk=;
        b=lEzozLqRW73uoXjQlopkzsWLk99/QcylMGxQbA2+HEGQvzleOxKqhjhZXJYcJPupcq
         tw7W5jBAscnfuGb7m68jTCN3EKYvUm9JGfZCzxodQpWvZ/pGinZZMjJKTde0Mp9k3POC
         v0S6Wi0CzEGhgI/uXONEJuxQiycQd3UkwsxI4OWs8DDv3qRH65ouWjWEf3J+KaidFM1R
         mgT0g5mLyOcIfhvOZ2V4Jb50OUP74PFmoWx95GRfXCDavOTFNNK4NtRl157mlbl002fK
         a1t8qOJc/XDeiirzP5RBlYOJTAAQwyv/K9Bns3rfktjbJjzPFsN/5LlMo/KJy03EH3jl
         dVtg==
X-Gm-Message-State: APjAAAXNjsXTUPcUeP2JundoXpOWWtYcSDFg2lleTqT72t3GYVXXh+Cg
        Aw3W0k8VZpkiVUpedQ0/Ybfs1ekKLhoMK+r4/BhIp0CdxPxcD1wcT64RmrbQxjjqh/4ebNLimE4
        bNUsy8R8KI8ru
X-Received: by 2002:a37:a70c:: with SMTP id q12mr4993678qke.484.1576893889517;
        Fri, 20 Dec 2019 18:04:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwi6EpBxyuC1AaxbuV0H2bPRBVFZGuE77abXFYffswUMBxwuwWHioRNl3ysylFXmR1QHzb/VQ==
X-Received: by 2002:a37:a70c:: with SMTP id q12mr4993661qke.484.1576893889274;
        Fri, 20 Dec 2019 18:04:49 -0800 (PST)
Received: from xz-x1.hitronhub.home ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id t7sm3400114qkm.136.2019.12.20.18.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 18:04:48 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 12/17] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Fri, 20 Dec 2019 21:04:40 -0500
Message-Id: <20191221020445.60476-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221020445.60476-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be needed to extend the kvm selftest program.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 36 ++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 52641d8ca9e8..17df0de21cce 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -235,6 +235,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_DIRTY_RING_FULL  28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -246,6 +247,11 @@ struct kvm_hyperv_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
+struct kvm_dirty_ring_indices {
+	__u32 avail_index; /* set by kernel */
+	__u32 fetch_index; /* set by userspace */
+};
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -415,6 +421,13 @@ struct kvm_run {
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
@@ -1000,6 +1013,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_DIRTY_LOG_RING 176
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1461,6 +1475,9 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1611,4 +1628,23 @@ struct kvm_hyperv_eventfd {
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

