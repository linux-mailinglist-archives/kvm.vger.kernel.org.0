Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2232190C5
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgGHTfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:35:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41510 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726806AbgGHTe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594236868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZK74dzjSy8T3R+12pLZXg3ORuRszBwsy+Uum3012XO0=;
        b=VPdrjD6LuRwN1RKF3oP9rNyT+CfLkSn0zvSV9HAeUKjPY+3/rj6Js+HJ7Lk6PsmIU+SqSv
        QiQB1gcRf1gMahbyOfBEKHe79JiRzCJHHZQc9qXGgBQR4mOur3zjTB5f3qE04k5umHis9P
        a+W/ljr3QoqjEllSIPw97VhPqhNWgaY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-x2PGuJ1xOb6RmIiGkjnXVQ-1; Wed, 08 Jul 2020 15:34:26 -0400
X-MC-Unique: x2PGuJ1xOb6RmIiGkjnXVQ-1
Received: by mail-qk1-f197.google.com with SMTP id v16so21515952qka.18
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZK74dzjSy8T3R+12pLZXg3ORuRszBwsy+Uum3012XO0=;
        b=hsLQo6WjzKn07sLgtTErYvarhTKQ6NOz/chZOqYUJ7XvnNQXRmCqSckzT/cgvtNhip
         mBTmUqgb5ISSOpLDK5QxlRfweojtaLXvOyTrgIfOFGsu2mKnVBkFYk9t7He96dhkYkNn
         PNp/IfHA/MTJLT51N4MzsmDHHa5FglFi2QVyGTK7IidWnNPNYQ0/2kYMbM7KQsNuSiuC
         p1/x/HTWUINueeJF3QF9NXiis+UBhAvoQJ6RgvK95pOpILq1iNcmfuHQh45gdgci1F9A
         kbcPxK4T+3sEYjuttM0UI0XkavP2s+WV6Kuv5avNRYtNdjuq6ZLsiv8fj7cMDhFLQLIA
         AN4Q==
X-Gm-Message-State: AOAM533ZI8lccCNjXJJ8zRnIMRymrh64pGO15WhBNFLHrTRvYyjV6be5
        e9NJY9yV9yUnwYSpH8QpV3ESuUiFwFiEmUlCYNEQ3UJDac2D5BFnjqhQsXyQAxf6fRMof+3Mwba
        xu0uo4r/po1mz
X-Received: by 2002:a05:6214:612:: with SMTP id z18mr58313890qvw.46.1594236866090;
        Wed, 08 Jul 2020 12:34:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFSchYlOtevPJYCwsyJKUPX8tFeehIlcbcjp5bl/v9L5LM3SLhfdQLFAeBsoE8fPhhEkT3TQ==
X-Received: by 2002:a05:6214:612:: with SMTP id z18mr58313867qvw.46.1594236865839;
        Wed, 08 Jul 2020 12:34:25 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id f18sm664884qtc.28.2020.07.08.12.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 12:34:25 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v11 08/13] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Wed,  8 Jul 2020 15:34:03 -0400
Message-Id: <20200708193408.242909-9-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708193408.242909-1-peterx@redhat.com>
References: <20200708193408.242909-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be needed to extend the kvm selftest program.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 53 ++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index fdd632c833b4..4f7a0a7ce85a 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1017,6 +1018,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_DIRTY_LOG_RING 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1518,6 +1520,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc6)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1671,4 +1676,52 @@ struct kvm_hyperv_eventfd {
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

