Return-Path: <kvm+bounces-71750-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AAjrJYxxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71750-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A041914B0
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CD4713061453
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2038124A078;
	Wed, 25 Feb 2026 03:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YTjdCQ/m";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D0hnddqk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E6E79CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991431; cv=none; b=opKtcIOY/jxiM0na9Z8nR/5hQiGeZEkcpNCDQm46WHj5KRGvWCqLEJujaCOaubJDIYZ10JfH8+R6gZrs26Lh7J4Vco+MVYqgf7fwrXa3x8QaUuy3TwdlbkoubbJloTgnaaUaNSElW6YDASX97Zuj/mxpjI6jysOQMyhm72f+lkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991431; c=relaxed/simple;
	bh=qgAtsdiNrfHcHf0rbwQOyHuKls3BD8j8LlklsV14XpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp7H3ruFf6tfx5px8TdVPGyLzooS7l2KvIC9zTk1JqghBL89186bUpeObq/euhxq9DryAf6qJuucH7Xf0UocJonhSVbRjpvF6Mzjr/RnKpGlluUiNmshCzFcltVhFULLE7UcmhJKyeeoubHZQQpnYTmHDJyhTGEgxaKowv60CEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YTjdCQ/m; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D0hnddqk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P2JMNY57q+gMbuW6Ehyq7A57okqwWcUKTKfqA74PG5Y=;
	b=YTjdCQ/m18MEomBlhqc8irKkp9XoJms64gUpmevUuLGgeBuH9mx9raLHBBzSHjCQo9copx
	VDV2QdSQPKu512Px3FY5GufYUwZybFoS4px8ZF0ySXGIN7ZcH9dOsK41HYQE1D1TYB6W/a
	7yHLQJzG9AZcC+F7vQjd6aVuev1dN1s=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-wPu6YNOgN1azCG1lIQIP4Q-1; Tue, 24 Feb 2026 22:50:27 -0500
X-MC-Unique: wPu6YNOgN1azCG1lIQIP4Q-1
X-Mimecast-MFC-AGG-ID: wPu6YNOgN1azCG1lIQIP4Q_1771991426
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-358f4ed4eceso984976a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991426; x=1772596226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2JMNY57q+gMbuW6Ehyq7A57okqwWcUKTKfqA74PG5Y=;
        b=D0hnddqkIjU/4cv1/frZkThzG280sp8gqF5EYsHqx6GcXjxsxT2N3zXMksI9aJh7ql
         i5O64jdtD+AoQqACmKJDVcrDBhMDx0jpmTlqQCKw6eXZ7PtYA37bY84fDdKaP2KPHpzn
         HpcOto6AlmlDeboGGQI98eosBc77+jrF5GnEbA0/77dqCFv8qQEh3mge84qy7c2t3ECa
         BpkiyStsqFsYIsnmCnl/uJul4P6DlGCqKI9iWnoRubuVQkxWxWVux6t0nKM8mPsYHW7w
         NBRKSjPotc5yymWID3SObblCDlYSutVvJlwLCNjEt3SQhsmt3JXFPw0OS8pjz5LX7mya
         tlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991426; x=1772596226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P2JMNY57q+gMbuW6Ehyq7A57okqwWcUKTKfqA74PG5Y=;
        b=s7uUrCOazqYb+DIeNm30H9GBS26+RIew5tFs3ZgmlqEZFJQ6Hq3DbbhlA9+WJSOsQc
         aX1BJPi0m6744m5p7Zd2Lp8yn775xb1V4EuexJNTGQEzO4IDQwv7Wn8/dV8vPydCUTGy
         wviKTpjJQAWdBkc1MeFTilpFQRMJK9LsNGzGqXmbP9Me/Yo1o0YcsiIDoSAOJrgSOwBa
         mpBpmJe+70IexOV3rTTNmFeOgAOLJ3dc3U8IicCbJ9KI0BDLTkOYyl9dRn6OW5gde/hn
         yubPjiVxu/Rq/sXrh+i0KbgqiOPpQUAhWXzVeEVonfyckeIy6gxPhH7WiYOV2SzqtYtB
         3kHA==
X-Forwarded-Encrypted: i=1; AJvYcCWqenOBFlzTO/HLd0aBLHc9+bUvKPL6kstDhkwFTmBgAF5FWFPRm+PoTfxW8V0TSsMf0OE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw46+QNys9EpLUqsnsGtOAHockkf73Jlwk5vEbou6/mAgosbDlG
	d38uf2jIkQ92ybiu/n8ovPDUKLqFLN6we/b+XDYxJDLv+zdu29rzfnoEwF3zi6AbZUqXLBwvyr5
	2oCbpxcAEAdO7sAR5UTcLg+eqJf64hYRqE+bOTZQ/HfDGAW/AW2jLyg==
X-Gm-Gg: ATEYQzwBtB8kB6noDcQF1M/go9OkGNywyoZVBmPAj3OER8QDUjv1GU9+dXqgsi0znlG
	DW5u2Tu+yl9l5E9mui3htcokWudsR3uhLulC56ArnMebN+5vatDZ3htem4sjX7ucN3ZLsjwA/d6
	vkbmo5D6lrJS0k8hxO/NrBVXctaxfLgGxh4E4gygGmTafmL1/+6qJ/5OLQmlHvCzfCG1iNtqx7J
	7bE1PiDgrsr+5rvBqhumRBsQerweh4xP5pDB6JA8WBaCT8IfENUKW5ZbUSKRu2sSKC1Z6kl1Ji6
	BQmJ/DxPRZh0f8CuX9X9lBQ70sHVhfwMkO97wdapnEj+jaX7EIC2C0vytkQ4SePDrRz+jaJ/6b4
	+4KEeqDxfUPNTfxcXZ/oi8SM3AM3M+AwiExyCHsw3kkD0g9k2V0t0XyM=
X-Received: by 2002:a17:90b:2b8b:b0:354:bfb7:db13 with SMTP id 98e67ed59e1d1-358ae8d3af1mr10627434a91.35.1771991426191;
        Tue, 24 Feb 2026 19:50:26 -0800 (PST)
X-Received: by 2002:a17:90b:2b8b:b0:354:bfb7:db13 with SMTP id 98e67ed59e1d1-358ae8d3af1mr10627421a91.35.1771991425813;
        Tue, 24 Feb 2026 19:50:25 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:25 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	ani@anisinha.ca,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v6 05/35] accel/kvm: add changes required to support KVM VM file descriptor change
Date: Wed, 25 Feb 2026 09:19:10 +0530
Message-ID: <20260225035000.385950-6-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71750-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 62A041914B0
X-Rspamd-Action: no action

This change adds common kvm specific support to handle KVM VM file descriptor
change. KVM VM file descriptor can change as a part of confidential guest reset
mechanism. A new function api kvm_arch_on_vmfd_change() per
architecture platform is added in order to implement architecture specific
changes required to support it. A subsequent patch will add x86 specific
implementation for kvm_arch_on_vmfd_change() as currently only x86 supports
confidential guest reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 MAINTAINERS            |  6 +++
 accel/kvm/kvm-all.c    | 88 ++++++++++++++++++++++++++++++++++++++++--
 accel/kvm/trace-events |  1 +
 include/system/kvm.h   |  3 ++
 stubs/kvm.c            | 22 +++++++++++
 stubs/meson.build      |  1 +
 target/i386/kvm/kvm.c  | 10 +++++
 7 files changed, 128 insertions(+), 3 deletions(-)
 create mode 100644 stubs/kvm.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 233d2a5e71..6377ff5898 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -152,6 +152,12 @@ F: tools/i386/
 F: tests/functional/i386/
 F: tests/functional/x86_64/
 
+X86 VM file descriptor change on reset test
+M: Ani Sinha <anisinha@redhat.com>
+M: Paolo Bonzini <pbonzini@redhat.com>
+S: Maintained
+F: stubs/kvm.c
+
 Guest CPU cores (TCG)
 ---------------------
 Overall TCG CPUs
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0d8b0c4347..cc5c42ce4d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2415,11 +2415,9 @@ void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi)
     g_hash_table_insert(s->gsimap, irq, GINT_TO_POINTER(gsi));
 }
 
-static void kvm_irqchip_create(KVMState *s)
+static void do_kvm_irqchip_create(KVMState *s)
 {
     int ret;
-
-    assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
     if (kvm_check_extension(s, KVM_CAP_IRQCHIP)) {
         ;
     } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
@@ -2452,7 +2450,13 @@ static void kvm_irqchip_create(KVMState *s)
         fprintf(stderr, "Create kernel irqchip failed: %s\n", strerror(-ret));
         exit(1);
     }
+}
+
+static void kvm_irqchip_create(KVMState *s)
+{
+    assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
 
+    do_kvm_irqchip_create(s);
     kvm_kernel_irqchip = true;
     /* If we have an in-kernel IRQ chip then we must have asynchronous
      * interrupt delivery (though the reverse is not necessarily true)
@@ -2607,6 +2611,83 @@ static int kvm_setup_dirty_ring(KVMState *s)
     return 0;
 }
 
+static int kvm_reset_vmfd(MachineState *ms)
+{
+    KVMState *s;
+    KVMMemoryListener *kml;
+    int ret = 0, type;
+    Error *err = NULL;
+
+    /*
+     * bail if the current architecture does not support VM file
+     * descriptor change.
+     */
+    if (!kvm_arch_supports_vmfd_change()) {
+        error_report("This target architecture does not support KVM VM "
+                     "file descriptor change.");
+        return -EOPNOTSUPP;
+    }
+
+    s = KVM_STATE(ms->accelerator);
+    kml = &s->memory_listener;
+
+    memory_listener_unregister(&kml->listener);
+    memory_listener_unregister(&kvm_io_listener);
+
+    if (s->vmfd >= 0) {
+        close(s->vmfd);
+    }
+
+    type = find_kvm_machine_type(ms);
+    if (type < 0) {
+        return -EINVAL;
+    }
+
+    ret = do_kvm_create_vm(s, type);
+    if (ret < 0) {
+        return ret;
+    }
+
+    s->vmfd = ret;
+
+    kvm_setup_dirty_ring(s);
+
+    /* rebind memory to new vm fd */
+    ret = ram_block_rebind(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
+    ret = kvm_arch_on_vmfd_change(ms, s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (s->kernel_irqchip_allowed) {
+        do_kvm_irqchip_create(s);
+    }
+
+    /* these can be only called after ram_block_rebind() */
+    memory_listener_register(&kml->listener, &address_space_memory);
+    memory_listener_register(&kvm_io_listener, &address_space_io);
+
+    /*
+     * kvm fd has changed. Commit the irq routes to KVM once more.
+     */
+    kvm_irqchip_commit_routes(s);
+    /*
+     * for confidential guest, this is the last possible place where we
+     * can call synchronize_all_post_init() to sync all vcpu states to
+     * kvm.
+     */
+    if (ms->cgs) {
+        cpu_synchronize_all_post_init();
+    }
+    trace_kvm_reset_vmfd();
+    return ret;
+}
+
 static int kvm_init(AccelState *as, MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
@@ -4015,6 +4096,7 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "KVM";
     ac->init_machine = kvm_init;
+    ac->rebuild_guest = kvm_reset_vmfd;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index e43d18a869..e4beda0148 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -14,6 +14,7 @@ kvm_destroy_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_park_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_unpark_vcpu(unsigned long arch_cpu_id, const char *msg) "id: %lu %s"
 kvm_irqchip_commit_routes(void) ""
+kvm_reset_vmfd(void) ""
 kvm_irqchip_add_msi_route(char *name, int vector, int virq) "dev %s vector %d virq %d"
 kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 8f9eecf044..5fc7251fd9 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -456,6 +456,9 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
 
 #endif /* COMPILING_PER_TARGET */
 
+bool kvm_arch_supports_vmfd_change(void);
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s);
+
 void kvm_cpu_synchronize_state(CPUState *cpu);
 
 void kvm_init_cpu_signals(CPUState *cpu);
diff --git a/stubs/kvm.c b/stubs/kvm.c
new file mode 100644
index 0000000000..2db61d89a7
--- /dev/null
+++ b/stubs/kvm.c
@@ -0,0 +1,22 @@
+/*
+ * kvm target arch specific stubs
+ *
+ * Copyright (c) 2026 Red Hat, Inc.
+ *
+ * Author:
+ *   Ani Sinha <anisinha@redhat.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "system/kvm.h"
+
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
diff --git a/stubs/meson.build b/stubs/meson.build
index 8a07059500..6ae478bacc 100644
--- a/stubs/meson.build
+++ b/stubs/meson.build
@@ -74,6 +74,7 @@ if have_system
   if igvm.found()
     stub_ss.add(files('igvm.c'))
   endif
+  stub_ss.add(files('kvm.c'))
   stub_ss.add(files('target-get-monitor-def.c'))
   stub_ss.add(files('target-monitor-defs.c'))
   stub_ss.add(files('win32-kbd-hook.c'))
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6d823a7991..a4e18734b1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3389,6 +3389,16 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
-- 
2.42.0


