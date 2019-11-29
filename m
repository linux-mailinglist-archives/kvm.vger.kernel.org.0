Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC98010DB11
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbfK2Vf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32509 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387418AbfK2Vfb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZpdoO8QRbjuY5mDRDtcxZHO4nZtgRquhpHelnraUvg=;
        b=ZwadUVqMP1kDLu27vQuDCu5jDTmm2300WSyVfbKqE9yIi7ewDpj++LQtihJ+TrHDER5J44
        dY6ZAUpBPX8Ee083JY2FS4ssmvZcUcmr7/6tNIup9OvI8qT94u5iY4/7wi8XNwtUuyxNDD
        IKyvbzRKgUSvt6mCJZ5HF0O0GlO/uKg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-60OSuQCqOB2pnysdMkI0Pw-1; Fri, 29 Nov 2019 16:35:25 -0500
Received: by mail-qt1-f199.google.com with SMTP id t20so7504142qtr.3
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LPDpRSfU7OJDvK+Jv1HyG5MKUTN9E4L4yVGOfnatozs=;
        b=fSOqP4IuwpypR/PJGECS9Gc9ygBcUVfiiq4dUqk2qEz0gGf1ElJ3jv6E8XnSA0ImoF
         lBpP+/ST9UY5IoXJWbogusfD81RSZDAgV+aecd7VkZUvUq8pVXhZzh+GSxFFh1S2Sq4U
         Ach5nxn5u674UylPK9lXLFmyPSQQynRz01o7cBpdeGfHFCAMLQ7wMsGVfsKCJXo4PoOu
         vWnvKOy0mJ1wnKOkfYoTr+wtuBJxxXq3uZ0mLbnxnj57/ZvUPnYi7wsuNpaTATUN4a6r
         CLKbzHCQ0W6JFDdhmDNPiDSlllA45gdaEo31edKxB2dJCvKd4RIpxXN4pG8SFsv6LJbk
         WRiQ==
X-Gm-Message-State: APjAAAXiAEntpXZSZEfnPDR7m6V7u+jKxXMu4PVDjGWGB2ACbmixeX7q
        4QRkOCpHH00LWxOyXkoWwN+dDHG4ZAPrO03dxIgaDyAmJICK2xkboLYxnCpfbT5z4JKjvlxyHvS
        xLWSpkcdP2u+h
X-Received: by 2002:aed:24e4:: with SMTP id u33mr54423799qtc.259.1575063323861;
        Fri, 29 Nov 2019 13:35:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8f1cm2E9EATQGs2NbJnhtjkcM3Mr1wBhqvHx80R6fUIyhQEakj9JIIhVHAr3mSX4XrMGYWg==
X-Received: by 2002:aed:24e4:: with SMTP id u33mr54423779qtc.259.1575063323647;
        Fri, 29 Nov 2019 13:35:23 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:22 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 09/15] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Fri, 29 Nov 2019 16:34:59 -0500
Message-Id: <20191129213505.18472-10-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: 60OSuQCqOB2pnysdMkI0Pw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be needed to extend the kvm selftest program.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 47 ++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index 52641d8ca9e8..0b88d76d6215 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -235,6 +235,8 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -246,6 +248,11 @@ struct kvm_hyperv_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON=094
=20
+struct kvm_dirty_ring_indexes {
+=09__u32 avail_index; /* set by kernel */
+=09__u32 fetch_index; /* set by userspace */
+};
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=3D0) */
 struct kvm_run {
 =09/* in */
@@ -394,6 +401,11 @@ struct kvm_run {
 =09=09} eoi;
 =09=09/* KVM_EXIT_HYPERV */
 =09=09struct kvm_hyperv_exit hyperv;
+=09=09/* KVM_EXIT_ARM_NISV */
+=09=09struct {
+=09=09=09__u64 esr_iss;
+=09=09=09__u64 fault_ipa;
+=09=09} arm_nisv;
 =09=09/* Fix the size of the union. */
 =09=09char padding[256];
 =09};
@@ -415,6 +427,13 @@ struct kvm_run {
 =09=09struct kvm_sync_regs regs;
 =09=09char padding[SYNC_REGS_SIZE_BYTES];
 =09} s;
+
+=09struct kvm_dirty_ring_indexes vcpu_ring_indexes;
+};
+
+/* Returned by mmap(kvm->fd, offset=3D0) */
+struct kvm_vm_run {
+=09struct kvm_dirty_ring_indexes vm_ring_indexes;
 };
=20
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1000,6 +1019,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
+#define KVM_CAP_ARM_NISV_TO_USER 177
+#define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_DIRTY_LOG_RING 179
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20
@@ -1227,6 +1250,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS=09KVM_DEV_TYPE_ARM_VGIC_ITS
 =09KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE=09=09KVM_DEV_TYPE_XIVE
+=09KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME=09KVM_DEV_TYPE_ARM_PV_TIME
 =09KVM_DEV_TYPE_MAX,
 };
=20
@@ -1461,6 +1486,9 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE=09  _IOW(KVMIO,  0xc2, int)
=20
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 =09/* Guest initialization commands */
@@ -1611,4 +1639,23 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK=09=090x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN=09(1 << 0)
=20
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
+=09__u32 pad;
+=09__u32 slot;
+=09__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
--=20
2.21.0

