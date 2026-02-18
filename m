Return-Path: <kvm+bounces-71228-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLy6JfyllWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71228-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 403A6155FA3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AEE663045C1E
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA3D30DECC;
	Wed, 18 Feb 2026 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjtOglj0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOQPs9Ut"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3709730DEB8
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771414998; cv=none; b=IEyIItNwAlzQW1VYDDLWgR87WER5UGwOHcKhzYZCu73pnVHlz8DScrrdfBQhsy1Dw6Llg+RYmbTcKPQcqAivKC+inIKSqq7+GnrIFYNaTIEgFu41opbG4QxHzYobtlvfBpH9+aodAdv5EQWyMms3uaYKb/dzVmTcIbY9dxRYfng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771414998; c=relaxed/simple;
	bh=iCc8+xVvXuzx97JVGkb9HIaj4d8V7Y1Drptneb6/Qvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okhww5/KnDlWAis0hyBrNjLkGv+n6ZxHpujF9C/hNlz9Qi9SttEnmRocL4tzSVtgMHDIYcukWuX3Yz5zw1ueZw7J0OQb+13oLQ1FbMaNSllyUOA1hGaFQXpxGS+H4bNznaQZlhmff2EULPgPdSaGjzs8u+roIf9S/jP/1Kdu1Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjtOglj0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOQPs9Ut; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771414996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8EBAMm0+61u9Fn6aJibmSGLnXTBDJJJE91zdBC7Xh+k=;
	b=XjtOglj0GG7wlbQttPqWLfnAvNQaGBXsvNulnLJ1P3/6FPNA+1QkjR2LGBz/VeV10cNQPw
	GwG3L7FVulAeK2DzxCaPmvb8X1RmkBJVMjU0GSuvkXMc+G7ibIxiy4E3dxWq3ufR5W9vfB
	gYR62MM/gVlYdC78eKtS8asmKCOHfbM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-lpdJPr4JP42hD7erMnAAkA-1; Wed, 18 Feb 2026 06:43:14 -0500
X-MC-Unique: lpdJPr4JP42hD7erMnAAkA-1
X-Mimecast-MFC-AGG-ID: lpdJPr4JP42hD7erMnAAkA_1771414994
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a7a98ba326so11881835ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771414994; x=1772019794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EBAMm0+61u9Fn6aJibmSGLnXTBDJJJE91zdBC7Xh+k=;
        b=hOQPs9UtNanFaAimNuChjR8TeGipFO9Xt1tGN6KHuoJKCzq1mKYShb9bVQosNT3OSH
         kO4Hi5fpQKVYeLNn0iUD3TfWUAC4ft6ANEh1xA0zQb547tz1DBO1IFFusdz6uBfahrJf
         s7G+lGREn+BGd8dAQC8ZBfgrct9nXhlv6y37HEFvZNI0xrcqMFiukSO2Nc4ASFuEI8gB
         WdzUkHfXDFQiOTWc1HlF2vJ68UIga8+fhNF0ez/506zNdNQbLRhn9JQiMoWBpu/7BqYa
         XgMvmjgSVn57M1z/szF9xww4H+W6kZcclGEwFQnsgv3QZ8H2gCGORNFxTOO6HY18NfU8
         DmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771414994; x=1772019794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8EBAMm0+61u9Fn6aJibmSGLnXTBDJJJE91zdBC7Xh+k=;
        b=ulbmYjEZm7JFIC6wIqiPYNZ0e+BJL50d5io/ZV6B141hMQ43SO+85vmi2cDLxLiRRd
         BGzFLfwJ9McMMVefp8KcCxM7R8RqxME06WCPhQaFjPhfv2FFADkslNHtPuai+00gIkoD
         yCKltLYmb+8eDg/o1sxXD4bZjY6FwebQMd1Wm5z/z2jOxo+yctav0rx1sRp1RZuzMnyt
         LzcHWujtpgLpl3xP29c/nRPUHw7T4C8oeOWpuALbC7JACNDATNRpgonmM1QXjoYM7k4Q
         Eu0Sxd3QNR5r0tkr0VM4L/9M3jZLuO/gKOIYgniAOrM7cDxQa0mbvoknWCHHgQeb4MUC
         yHCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzHLvnE/tfpybYKu4+FLE6keyHZRPVW+DON/s4NdtocNdv/vy9oBAM4zhWJejgGNeJHfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKBcsSB8UjN1TBI/eGqyIeAXmfCpIQHJGdM/8FOQDJRa2xgA3G
	NcrZbOw7IguJrFkXvzgshvVPMzUM/5de8kxf2p9RxdnkjNVoyk5CQ2ygmMc0U4lGIVilqoKT6L8
	kxl3xXaJoH5BFp77lyxI3w2IHOyKNisIUSeRxjNr57cSEWpAjm8Um9w==
X-Gm-Gg: AZuq6aIxTWLGmYdSMED0GrvTYJaUDOpNqUn15/GYhkzfvrJ1LjzzeeFBs1QICGpZcXa
	IorPBtosGKW4TTwpOWbOt5WiifK8UDj+1th/6meT/VgiO9MIXULtbnK67bP6RyrdX8hsrhySAKx
	eIhOe5BlCIQM6So9PL4cFRGxLJah+rtzoxQSTmXr9KdjXsfp/vdSeACJjPHSj8jFZN6Vup2aO3c
	fuQ/d44cyxCuZNoogjFs83zILigVw0kAi4luou9GQoovuAUZz9eWsEjR4bOpiRf9gHnLCogsaZX
	PjRvh6PTJGc2oPskWGC2q59lxhbFnp3p4zgPgUDPO740oqz08MTMHslVsjn9DvLdyRqSqplwbjZ
	KEdjDOvcQ5AEQAigTj0jtHfAil2yeci7ZX/8Z0+vRLadSw9gu727a
X-Received: by 2002:a17:902:d4d0:b0:2aa:e817:1bda with SMTP id d9443c01a7336-2ad50b980dcmr15409685ad.12.1771414993682;
        Wed, 18 Feb 2026 03:43:13 -0800 (PST)
X-Received: by 2002:a17:902:d4d0:b0:2aa:e817:1bda with SMTP id d9443c01a7336-2ad50b980dcmr15409535ad.12.1771414993250;
        Wed, 18 Feb 2026 03:43:13 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:12 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 09/34] kvm/i386: implement architecture support for kvm file descriptor change
Date: Wed, 18 Feb 2026 17:12:02 +0530
Message-ID: <20260218114233.266178-10-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71228-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 403A6155FA3
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


