Return-Path: <kvm+bounces-71756-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DIdAqJxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71756-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B53CF1914DC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CA988301C15A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404A82BD00C;
	Wed, 25 Feb 2026 03:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X74Wvrdo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vc8gW2mB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221841DB34C
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991449; cv=none; b=Cw9tDFNrvPqMYRRmmbtlJOO5etek5wqMRNOh9pEqTwryr+xZeOHX7w416AHJp/UF6Ki+VypYn8HYiLq+iBY7kce58IQlqNa+99ybbFOu6jlQh/0W4IhWN0YWTifqmskBWI2n58HzS3kJEYjsh8kUSMhz1zM1RcDvj0avN77X1FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991449; c=relaxed/simple;
	bh=iCc8+xVvXuzx97JVGkb9HIaj4d8V7Y1Drptneb6/Qvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByORtOpczMiYWCm5KS0824FfipD3YTGWPs4DeXKbdOej9vau+yrZVIttRYFbRQRhWhmjAS2Vm8MFuwQl5VsTXNUUJQi9asOg8HxRRJfrMFW96zIEMuLZmfU+rmxbvTTQkyz0eL+ibpnYALzFjBoYgGM78IhV/xAhZ7mj7QoLrWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X74Wvrdo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vc8gW2mB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8EBAMm0+61u9Fn6aJibmSGLnXTBDJJJE91zdBC7Xh+k=;
	b=X74WvrdowHz4VEDj1qBNy+97eHNPOpkRCT9IBHQMbRPRe+vxvDwCZmCgBJqAqqQYXDWBjc
	r8ch39TyQR1U83YkncPyr5UJZA06K/rbZ4I5bB8smrO+LoglinYhItex66G1karWSZOYBv
	uOrmNEBreskUfH6rWWIUMoATJzLAtEA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-Z51yPIENMKmP4ArRl8NWvw-1; Tue, 24 Feb 2026 22:50:43 -0500
X-MC-Unique: Z51yPIENMKmP4ArRl8NWvw-1
X-Mimecast-MFC-AGG-ID: Z51yPIENMKmP4ArRl8NWvw_1771991442
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c6e1dab2235so3739969a12.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991442; x=1772596242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EBAMm0+61u9Fn6aJibmSGLnXTBDJJJE91zdBC7Xh+k=;
        b=Vc8gW2mBXUNK+M1+m32mbcND33SePWWJAljrDO92HiEF3ehHcho1vVzuQiHShg9ijh
         rLXyfiZFhxezsE5v5zEMQq0odkQMFjksjvNNuVwHHxLoWN5XSD9lGf+sshD7E0yV8ESu
         zI1L6WfQBcAdO/FsHDRpfYcxeR4IGjIBOnHwed90Erx1DXbast2B3jTAz6i6DpAlqxZP
         xlcXqre9gk3Zm3fBoXG2KaUFBBXvRE2+5bdHiMDCyLM2k5m3BtrYWoWWiSBdjBmst3j4
         FKzyK62pw8GQxh+nsjcreiyiSB810AF6g7OmwJlHqIp7pqO6SptBkgchUuF6vKd+BWtk
         +Pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991442; x=1772596242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8EBAMm0+61u9Fn6aJibmSGLnXTBDJJJE91zdBC7Xh+k=;
        b=PsXcqlzGbwR17rZWTgOBRfxowN4o4YcekzgjGxAZWSZ2gFtjYdhOZ8o9dLPtw4bRPb
         kQtRuh9WZoR++vqhgTszYfuNe2nplS9AdYuISoErN/8uWtPBIbwuk6Nos4x3mdfnrdB9
         VbbBtd6uVmzGz2K7d3mdmxYdAdKCBx7nonuene1b1/BKqGv9Zx7cgQE8pfTF83guOKp5
         arBGjdI+laGZH3OgPJTzxIJRjTmQ9fctYfYBCev6d5RFVvIU0xcsYjBReAzkEjPsC1aD
         QHga9Km2FxjxZxh2SV6FYa7NdU7+6ryxyII4ss90BbGaEO6BRtYV9NkPOXyqEkdsEGBT
         jUpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV59U5wbRkDOMEfDMD8jXO4PKjQoPRXj3lHqThWOTiyi2MNRvTDzkkxzA9REiagzzC6wv0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu67cGp+sE+vQAWwV7ZTmJWnL2gzaGXYquZwlIoDOBDJDF/pDK
	zjTj11uqWu1rjrJrlHXcqeTetgRINeXcmamNWWFve7cqJTVNA69zOyPz+ilav1VWHqS8L1a+xaC
	VlHaU1q6I0O5BJLvqrCH3TLtOCR9Di3wNuF0ZXFbK4Eao15tdN7CHew==
X-Gm-Gg: ATEYQzxeFXRPK5vooSiW+nXxvQO5wUhuYWpYS2QRqY4YxznGhsWMVLHBIT+5S7aRQIh
	iRv8PhAsopC7doeCPxscGKGHRQ4dOxqZ5idsb7jfjZL2hSRcTzS1hxBS7EZNg2HrPN/LLnbybz7
	hnNLHdAOn4ljqAQ+1hIKrgeowNWUIpawbOS6Y7jQLL25jdn3lmYNcoT60zureOuDbRBdYAd0cyH
	jpTF5zSJNxUnq9xIGR36ASZ+pGV0E2QZ7g3k3iHlXhtu9VG/Gw7z33kDQ1mefzeXsXw7nLNHYbZ
	x3PSHrtRGbxJflSAQd3ESucrirfngGcMgS3yTGjyUyI4Bgua0OosHoAYvRsJCI0k+kg+mtkAY4+
	r52mvqgbb/nOaBFX/XNkQEhToDMZ2JszWFI5/TZOkmCzfPViaHqMpsbg=
X-Received: by 2002:a05:6a20:9e49:b0:38d:fc34:c88d with SMTP id adf61e73a8af0-39545fab8admr11806012637.55.1771991441729;
        Tue, 24 Feb 2026 19:50:41 -0800 (PST)
X-Received: by 2002:a05:6a20:9e49:b0:38d:fc34:c88d with SMTP id adf61e73a8af0-39545fab8admr11805987637.55.1771991441314;
        Tue, 24 Feb 2026 19:50:41 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:41 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 10/35] kvm/i386: implement architecture support for kvm file descriptor change
Date: Wed, 25 Feb 2026 09:19:15 +0530
Message-ID: <20260225035000.385950-11-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71756-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: B53CF1914DC
X-Rspamd-Action: no action

When the kvm file descriptor changes as a part of confidential guest reset,
some architecture specific setups including SEV/SEV-SNP/TDX specific setups
needs to be redone. These changes are implemented as a part of the
kvm_arch_on_vmfd_change() callback which was introduced previously.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c        | 49 ++++++++++++++++++++++++++++--------
 target/i386/kvm/trace-events |  1 +
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 83657fe832..8679e7d3fa 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3407,12 +3407,30 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
 
 int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
 {
-    abort();
+    int ret;
+
+    ret = kvm_arch_init(ms, s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
+        X86MachineState *x86ms = X86_MACHINE(ms);
+
+        if (x86_machine_is_smm_enabled(x86ms)) {
+            memory_listener_register(&smram_listener.listener,
+                                     &smram_address_space);
+        }
+        kvm_set_max_apic_id(x86ms->apic_id_limit);
+    }
+
+    trace_kvm_arch_on_vmfd_change();
+    return 0;
 }
 
 bool kvm_arch_supports_vmfd_change(void)
 {
-    return false;
+    return true;
 }
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
@@ -3420,6 +3438,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    static bool first = true;
 
     /*
      * Initialize confidential guest (SEV/TDX) context, if required
@@ -3489,16 +3508,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
-    /* Tell fw_cfg to notify the BIOS to reserve the range. */
-    e820_add_entry(KVM_IDENTITY_BASE, 0x4000, E820_RESERVED);
-
+    if (first) {
+        /* Tell fw_cfg to notify the BIOS to reserve the range. */
+        e820_add_entry(KVM_IDENTITY_BASE, 0x4000, E820_RESERVED);
+    }
     ret = kvm_vm_set_nr_mmu_pages(s);
     if (ret < 0) {
         return ret;
     }
 
     if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE) &&
-        x86_machine_is_smm_enabled(X86_MACHINE(ms))) {
+        x86_machine_is_smm_enabled(X86_MACHINE(ms)) && first) {
         smram_machine_done.notify = register_smram_listener;
         qemu_add_machine_init_done_notifier(&smram_machine_done);
     }
@@ -3545,16 +3565,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                 return ret;
             }
 
-            ret = kvm_msr_energy_thread_init(s, ms);
-            if (ret < 0) {
-                error_report("kvm : error RAPL feature requirement not met");
-                return ret;
+            if (first) {
+                ret = kvm_msr_energy_thread_init(s, ms);
+                if (ret < 0) {
+                    error_report("kvm : "
+                                 "error RAPL feature requirement not met");
+                    return ret;
+                }
             }
         }
     }
 
     pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
-    kvm_vmfd_add_change_notifier(&kvm_vmfd_change_notifier);
+
+    if (first) {
+        kvm_vmfd_add_change_notifier(&kvm_vmfd_change_notifier);
+    }
+    first = false;
 
     return 0;
 }
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index 74a6234ff7..2d213c9f9b 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -6,6 +6,7 @@ kvm_x86_add_msi_route(int virq) "Adding route entry for virq %d"
 kvm_x86_remove_msi_route(int virq) "Removing route entry for virq %d"
 kvm_x86_update_msi_routes(int num) "Updated %d MSI routes"
 kvm_hc_map_gpa_range(uint64_t gpa, uint64_t size, uint64_t attributes, uint64_t flags) "gpa 0x%" PRIx64 " size 0x%" PRIx64 " attributes 0x%" PRIx64 " flags 0x%" PRIx64
+kvm_arch_on_vmfd_change(void) ""
 
 # xen-emu.c
 kvm_xen_hypercall(int cpu, uint8_t cpl, uint64_t input, uint64_t a0, uint64_t a1, uint64_t a2, uint64_t ret) "xen_hypercall: cpu %d cpl %d input %" PRIu64 " a0 0x%" PRIx64 " a1 0x%" PRIx64 " a2 0x%" PRIx64" ret 0x%" PRIx64
-- 
2.42.0


