Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5541EA347
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgFAMA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:00:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727810AbgFAMAX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 08:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591012821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axZO0oxS1oTWaBb+moPh6wvEC4bE59rtqAl5fhCdw3Q=;
        b=TX4ruA3/LAqOiwv6ZjL92fyakf0GbsqHavc44PH3/9BZDH0goMJCaUBS+bW56vZ9vFjEJx
        UEnnjFrD8C/D2PotrHanUEkmzRNEd+gjszlBmRjL0/bNO+bh0inK4Ogw+dyoy9M1UMaf9H
        Xotg3Cwlc1lMd4Grs/cvjiqHFoJ5BSU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-inpGNd4MM1iHfaY6ZJXkQQ-1; Mon, 01 Jun 2020 08:00:20 -0400
X-MC-Unique: inpGNd4MM1iHfaY6ZJXkQQ-1
Received: by mail-qv1-f71.google.com with SMTP id a7so8366851qvl.2
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axZO0oxS1oTWaBb+moPh6wvEC4bE59rtqAl5fhCdw3Q=;
        b=RAsu+88JZuu2W4NSgNfUF3+WWLTnbd0NuLEH7gYaRvIaelKwkZlbtze+HRAtqBDmnW
         Nnx2DTkaPXmSfuZIk4iLM1b4z4qIe0LY8rLzNk+6lfStU+/g866OWkP+tSJUpxXWej1N
         5hUcY4hOIbXR/uf/wezAQDsknUM0tHJU1gK5XC2Lac2qUnaXiDuQTMonUKsK9bwAxK5w
         yCjITLZdLYagMZMAqYBz0A4ou9NbbOuUejZEqgEsG8qXe+iH1LWFvewB+iO4QBZMArfP
         E84eBYrh6zft8/fSxhlksDp3ktSOdV22Ig8s2QwUTFFAw6824Q74Vzm//47qClrPS4tY
         EfVA==
X-Gm-Message-State: AOAM531rls07CFdQMlNP36foWsUGO9GcoChw39JNxQwiQbZEeWxWeZak
        1dFtqJ5ECJfkoXlRHU+rxkjJ8GjSw3Cu4+Qzmk1aelUgiTH7hDeBHdEHBmilGEUQoSaP4+9TwHi
        BtZBsh6+K90+P
X-Received: by 2002:a37:8ec3:: with SMTP id q186mr20526029qkd.231.1591012819585;
        Mon, 01 Jun 2020 05:00:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQ04nOkeg/EMO4TKp+1Y9b5EgySF1Z6v76c86wvZLT7jGk078f3gO0GCmVO51vsrW+lD/YJA==
X-Received: by 2002:a37:8ec3:: with SMTP id q186mr20525992qkd.231.1591012819298;
        Mon, 01 Jun 2020 05:00:19 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l9sm14474185qki.90.2020.06.01.05.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:00:18 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 09/14] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Mon,  1 Jun 2020 07:59:52 -0400
Message-Id: <20200601115957.1581250-10-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601115957.1581250-1-peterx@redhat.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
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
index 428c7dde6b4b..74f150c69ee6 100644
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

