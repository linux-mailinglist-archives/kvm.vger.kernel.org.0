Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A1727F47B
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgI3VzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:55:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731017AbgI3Vyq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 17:54:46 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601502884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIGige7ZhInewzYRPVG4SbUa2xPbjg0ugngQgGXMaLA=;
        b=Lmd9tUjXq94+TYIGpS8QZ4REY5TR8UDkVzsyn3J/e2QEnyDYCObLC2JfEBY/m1mZpuMDIp
        T/HFOuHIhWO0/OfgPQ87zTMxYwTNoT7cQC3q36pBmcEX+dtMM0eVIljR4YfIRHwBOX3F1x
        D/0f9ggUdMvddFnInaOTRUpu2KGL6q0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-ztM7ZfW3NDu53otKwPtohg-1; Wed, 30 Sep 2020 17:54:42 -0400
X-MC-Unique: ztM7ZfW3NDu53otKwPtohg-1
Received: by mail-qv1-f70.google.com with SMTP id p20so1864907qvl.4
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 14:54:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rIGige7ZhInewzYRPVG4SbUa2xPbjg0ugngQgGXMaLA=;
        b=UV1LEpeXKkmudj922MmmQoqsU5IHfrDi04cg8o6PCkAkB+5cOfnh00NGMKBsKfhIWB
         lTCmXXau+BK9UtgrSZXIbY7+q7ITFAbtaJnPEsZpTmQFmPKZtpy6OEEdKl6fZJ6ll/gX
         vGHAHorJ9G7bwY2GIGM2wtB+H9aYZDPKyVSl+2dnbQiVZpJfbvk2HfdIIQSP6PVcZa0g
         vqHluZ8coBxUxJ9DW2QVrAyaYT0zNpP9EIsJMcx9Gj8wAzcTIPioQZ5KJJHcFXpFaq/V
         snS6ct6j8RgZSR8gCXqcCtIyVp+zNd1v/astfYQbn7+4he3YjTcgfxbeyOWDI/eWN3Fj
         rNmA==
X-Gm-Message-State: AOAM530cBCQaRmU7kxUhhSnwLhvnjfxXNs6ytTfv7Et9VB4l5N8vQwUw
        DsWee9UcM2oskru2ujC8RXvyzBnDYHMpFN8gn0u8Qn70/QYdl7KvpuOWmub7BgyZF9ezmoZopia
        zneXY6GPbIT2v
X-Received: by 2002:ad4:430e:: with SMTP id c14mr4565073qvs.38.1601502882043;
        Wed, 30 Sep 2020 14:54:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxI4/HOLBvYrM1mF0RpHETcVaf75yQL69EPKx0W4hsr60slah0MjjRwmVYfaArRXQQalM8Z3g==
X-Received: by 2002:ad4:430e:: with SMTP id c14mr4565054qvs.38.1601502881759;
        Wed, 30 Sep 2020 14:54:41 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id x197sm3746615qkb.17.2020.09.30.14.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 14:54:41 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v12 08/13] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Wed, 30 Sep 2020 17:54:39 -0400
Message-Id: <20200930215439.48150-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930214948.47225-1-peterx@redhat.com>
References: <20200930214948.47225-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be needed to extend the kvm selftest program.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 53 ++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 7d8eced6f459..b899205793ff 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -248,6 +248,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1037,6 +1038,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_STEAL_TIME 187
+#define KVM_CAP_DIRTY_LOG_RING 188
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1538,6 +1540,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc6)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1691,4 +1696,52 @@ struct kvm_hyperv_eventfd {
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
+/*
+ * Arch needs to define the macro after implementing the dirty ring
+ * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
+ * starting page offset of the dirty ring structures.
+ */
+#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
+#define KVM_DIRTY_LOG_PAGE_OFFSET 0
+#endif
+
+/*
+ * KVM dirty GFN flags, defined as:
+ *
+ * |---------------+---------------+--------------|
+ * | bit 1 (reset) | bit 0 (dirty) | Status       |
+ * |---------------+---------------+--------------|
+ * |             0 |             0 | Invalid GFN  |
+ * |             0 |             1 | Dirty GFN    |
+ * |             1 |             X | GFN to reset |
+ * |---------------+---------------+--------------|
+ *
+ * Lifecycle of a dirty GFN goes like:
+ *
+ *      dirtied         collected        reset
+ * 00 -----------> 01 -------------> 1X -------+
+ *  ^                                          |
+ *  |                                          |
+ *  +------------------------------------------+
+ *
+ * The userspace program is only responsible for the 01->1X state
+ * conversion (to collect dirty bits).  Also, it must not skip any
+ * dirty bits so that dirty bits are always collected in sequence.
+ */
+#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
+#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_MASK            0x3
+
+/*
+ * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
+ * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
+ * size of the gfn buffer is decided by the first argument when
+ * enabling KVM_CAP_DIRTY_LOG_RING.
+ */
+struct kvm_dirty_gfn {
+	__u32 flags;
+	__u32 slot;
+	__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
-- 
2.26.2

