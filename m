Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB617EBF8
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 23:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCIWZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 18:25:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48940 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727279AbgCIWZT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 18:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583792718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Thxl5wIjIKH5B5NXRPkB8aLAOUeG1jEuoKaVSkWq1z8=;
        b=dP8HoQU6eMpuCFgriMe3esZTGsX1y7ITbYCbZJ11S+zqEcEMI1cbWme69bOQgOoy29eE0b
        iLN7wJMFyIzSrCMFY+LcNUspUNV/q3ZFxNONJxlcxL4vY8Chx6M4OGo49lBP15vuxH5ToB
        CtqwfbOy1ylHTIDbuRHC5cghSITo7kU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-W4sm6-wfOtKeqMcLw5Grsw-1; Mon, 09 Mar 2020 18:25:17 -0400
X-MC-Unique: W4sm6-wfOtKeqMcLw5Grsw-1
Received: by mail-qt1-f199.google.com with SMTP id g6so7819797qtp.20
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 15:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Thxl5wIjIKH5B5NXRPkB8aLAOUeG1jEuoKaVSkWq1z8=;
        b=YS+l93p8JLMqGbNArZnV3w5RRtDQU5Q2uKmSHNsKBO7nooCyEn1TFbYUM3Rofr8Rn3
         Ho49H4hEw8tfkAhEWm6dXcTw87Kl1e0lhq+CPc0GhVrk7D/zeEtDXqBTyGhrYLGLfvpu
         QTBW2OHAtlOty9McQFaryXiVvWUQjMCfeCNASE2mS88TncW93Qhkgqr3aA1KD5xz0TcB
         Wm9cMxdNmrbdMOFPCoPsIbpgQoirY1SBkTUdph0/lCTjXNARICc8THUrmiP/byY2dROb
         QlW4WwhYUbCMSAVz/N2m3aQktSCFCUfBg7JI7MPIJmkx3VrBBesARwnZ4/WsPtiLiHZ9
         dfdw==
X-Gm-Message-State: ANhLgQ3LPdDu3h/6+4mXWcoAHgBzjvC9EJ/8fWDMAAoE5Y/8DYzLBoRm
        KjiRU75Aw+MGv04TdCZmJ83wbEfphgtxrjLUW8T+W1mHauC/DJu5G3RF4LN6d839RgS/W/bna1B
        uA+ujb4b8kMD8
X-Received: by 2002:a05:6214:11e6:: with SMTP id e6mr2251477qvu.22.1583792716621;
        Mon, 09 Mar 2020 15:25:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vubzTyXkWiBklNfqu0HRtTuxAcmpUSp+Pb3Co+Z0PAU3CLBmZZaa1nK74Ks9GVPN1HHz83pqQ==
X-Received: by 2002:a05:6214:11e6:: with SMTP id e6mr2251465qvu.22.1583792716363;
        Mon, 09 Mar 2020 15:25:16 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id i11sm9183431qka.92.2020.03.09.15.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:25:15 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 09/14] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Mon,  9 Mar 2020 18:25:14 -0400
Message-Id: <20200309222514.345553-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be needed to extend the kvm selftest program.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 44 ++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 4b95f9a31a2f..50bf39d24f17 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1010,6 +1011,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_DIRTY_LOG_RING 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1478,6 +1480,9 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc5)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1628,4 +1633,43 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
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
2.24.1

