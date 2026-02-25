Return-Path: <kvm+bounces-71758-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eIZKIK1xnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71758-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F191914F9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B8E9306B9CA
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC4429E0F7;
	Wed, 25 Feb 2026 03:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czbsYpHG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRvLYYzC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0047021420B
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991464; cv=none; b=DocHx1+iwJHg3UltCpBUcWj1s5n+BRc1O2zPQHnc/8hn8Efk0qtT5sQdTJU3fnLQAWi3cO/cMEIziMDBHg/acu7MOXDJqXAXYw4Nh+AmAWPmapFWXpdtHtu322wU7tHeyIdAhCW1cTi2jAGaTofflfLzK0qBISfPoLH24YtcLfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991464; c=relaxed/simple;
	bh=Cs02N7kjiZapYJkD7+u3Bj2uUy7XDPWKIqfr00KkQ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He5Ihxw1SiyE+WKQx161iorfG2l6ccQbAABknj+47R2iwCwZBm8ISVWQQGzfWcbvU0/k4XOjxPynOUSvv0JblcoaOo224DB9rdI7QH61DgZteqw/3/NdKF1NpO42To9GB5wjySiIHD3j/g8obeBZOJ38c5Bo1XP3MTaSGVB+Olw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czbsYpHG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRvLYYzC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/RPK8AZYmVrk+p/35E6Q/RhKlnBCZugmIfxMJDIXfQk=;
	b=czbsYpHGQNodCXoJ6rAVQYrKYUenDDllwwm8ysuSTj6nfY+v0HfgyRJxWq/bkBXN8TuFs2
	QSRXM+iUpJLsPdPuStPlTXsEtCn6YS/1CZZ2+05mcAUEFOK+3ldfRXENVLxizxaIGNfDwU
	pIvTvKBH9ARvGavbLlcpSvQNWdzFrl8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-fMcqrdYDOdux8fvL0VLW5g-1; Tue, 24 Feb 2026 22:51:00 -0500
X-MC-Unique: fMcqrdYDOdux8fvL0VLW5g-1
X-Mimecast-MFC-AGG-ID: fMcqrdYDOdux8fvL0VLW5g_1771991459
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3562bdba6f7so37445196a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991459; x=1772596259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/RPK8AZYmVrk+p/35E6Q/RhKlnBCZugmIfxMJDIXfQk=;
        b=IRvLYYzCh8Cf5g7PUU58xaibzzBWZmjW8dqaiNLKCVx5teo4sTQhXatg/D1TQEl1Zy
         KY/hgOCNY76a8QGTS1n8y1wSjj4St9hYPHiD0O3xPNrz5YriGs0mavegv4K78XuWTFVq
         csX3WBfTKs8gjh0uAAxpiC+0T6Lo1/zk8+CCQYI3uktROYox6lv8ZJddh9b2WghTa6Q1
         BDLdIO+LTptVVonUfjaXmQhIWPGDlycC0BFHeILZLXrNdQTyTaFdUQiIg5uyfOoogRAT
         Gsa4mR4CethTnVJwewM8LiDPuJmKE+WkmCBV9/1nTR9sRpkqkAzeVspTAIlhV/Oc+THF
         /neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991459; x=1772596259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/RPK8AZYmVrk+p/35E6Q/RhKlnBCZugmIfxMJDIXfQk=;
        b=YcrYp8CCTdxp1oYtv3WYzcqMdyDR+NvphIvpsPetR0MnvRBV5MiPf1HJCYwBdyuB/k
         fiIxfAJCbgk7WR76KyqOfP5tYQfCWihJKrqQbQy/cctNsqNyvAeYTngyUUU6SYrG0Vtr
         gj7Oa7QKrYGyGOT91BIuc6dorLpoxQ/WD2Vf3lvM/lbzCLmgCHQU9LXUCSMSzt5pgsRA
         zJLhHwyZFvbFpLdzHGYAfI6dDJnuSm0vXaPVV0SZoACBaGSChsM/qBcStHP4/H8J7DOj
         EUs7en6FB6UK+OnoGt9OSjEGiuDe3R1q8o2U02a8eRcprps2vr0ZG+dZ1SalYOv7Z1QQ
         hBHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnCTMLO2FZQwvTgk/8Cv8Ri0Fdk4quQ0946u9vWU6rd6MKRnkFZMSNtmTo4xGQzKyO7B8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzKJzQ4MfI+uldY1OvsbO4q3Mtdi7kVOHwv+voulUw6U1EDwHz
	OtWlrPGvj6jN2wF6lmtcwY7Jn3UoE8ujMjUsVp6HDiwPnOiYQL8hxLVfGkDsceEha4H6VjFIbAN
	IevTkwTwpiql14Ga9VxYfpPJ3U3s7oKRg0Oq16WvyTixgjVHoAGcyBw==
X-Gm-Gg: ATEYQzy6rebWkeuI36Q9PLRe35XWle7yWW2McK29ui3vCzk5aO33dqzHoavDDHaUF6Z
	wyFrvUEaDJK6o9RpjfzBC+XCHhd7vMzD9mtPD3MeKaoxEI8zXXWHKXB33zDtVU/2qbUt47MsH//
	jwrWMa0MbUczubwLPpzSl3CqJReezj7rLH3d5vOs75w0xbKqAy+9vz6OoT2EAQZyKSPAu0Xq76U
	YZsrB7I/ySyPaF9w8Ds9CdIgkORaIi5yVQTx118rFo9XCkNZ5wZL7vxI+Ex4/rZzgYhj7d+YShX
	GDWpccelJ7jVO1pACS2pUpPnNy067XaAEmtukX5wcmzQyfBjipImYSdmew6L9j1CHruiOYV3WU7
	MlmZ3TeqVOmD7NUffUEiepJCWv5GAj7mUTbvpf8obov9NpN8yS4VpZF8=
X-Received: by 2002:a17:90b:4b8d:b0:352:ba0f:fb28 with SMTP id 98e67ed59e1d1-358ae7c84famr12398119a91.1.1771991458868;
        Tue, 24 Feb 2026 19:50:58 -0800 (PST)
X-Received: by 2002:a17:90b:4b8d:b0:352:ba0f:fb28 with SMTP id 98e67ed59e1d1-358ae7c84famr12398096a91.1.1771991458510;
        Tue, 24 Feb 2026 19:50:58 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:58 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 15/35] accel/kvm: rebind current VCPUs to the new KVM VM file descriptor upon reset
Date: Wed, 25 Feb 2026 09:19:20 +0530
Message-ID: <20260225035000.385950-16-anisinha@redhat.com>
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
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71758-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 30F191914F9
X-Rspamd-Action: no action

Confidential guests needs to generate a new KVM file descriptor upon virtual
machine reset. Existing VCPUs needs to be reattached to this new
KVM VM file descriptor. As a part of this, new VCPU file descriptors against
this new KVM VM file descriptor needs to be created and re-initialized.
Resources allocated against the old VCPU fds needs to be released. This change
makes this happen.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 215 +++++++++++++++++++++++++++++++++--------
 accel/kvm/trace-events |   1 +
 2 files changed, 174 insertions(+), 42 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d244156f6f..a347a71a2e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -127,6 +127,10 @@ static NotifierList kvm_irqchip_change_notifiers =
 static NotifierWithReturnList register_vmfd_changed_notifiers =
     NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_changed_notifiers);
 
+static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp);
+static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp);
+static int vcpu_unmap_regions(KVMState *s, CPUState *cpu);
+
 struct KVMResampleFd {
     int gsi;
     EventNotifier *resample_event;
@@ -420,6 +424,90 @@ err:
     return ret;
 }
 
+static void kvm_create_vcpu_internal(CPUState *cpu, KVMState *s, int kvm_fd)
+{
+    cpu->kvm_fd = kvm_fd;
+    cpu->kvm_state = s;
+    if (!s->guest_state_protected) {
+        cpu->vcpu_dirty = true;
+    }
+    cpu->dirty_pages = 0;
+    cpu->throttle_us_per_full = 0;
+
+    return;
+}
+
+static int kvm_rebind_vcpus(Error **errp)
+{
+    CPUState *cpu;
+    unsigned long vcpu_id;
+    KVMState *s = kvm_state;
+    int kvm_fd, ret = 0;
+
+    CPU_FOREACH(cpu) {
+        vcpu_id = kvm_arch_vcpu_id(cpu);
+
+        if (cpu->kvm_fd) {
+            close(cpu->kvm_fd);
+        }
+
+        ret = kvm_arch_destroy_vcpu(cpu);
+        if (ret < 0) {
+            goto err;
+        }
+
+        if (s->coalesced_mmio_ring == (void *)cpu->kvm_run + PAGE_SIZE) {
+            s->coalesced_mmio_ring = NULL;
+        }
+
+        ret = vcpu_unmap_regions(s, cpu);
+        if (ret < 0) {
+            goto err;
+        }
+
+        ret = kvm_arch_pre_create_vcpu(cpu, errp);
+        if (ret < 0) {
+            goto err;
+        }
+
+        kvm_fd = kvm_vm_ioctl(s, KVM_CREATE_VCPU, vcpu_id);
+        if (kvm_fd < 0) {
+            error_report("KVM_CREATE_VCPU IOCTL failed for vCPU %lu (%s)",
+                         vcpu_id, strerror(kvm_fd));
+            return kvm_fd;
+        }
+
+        kvm_create_vcpu_internal(cpu, s, kvm_fd);
+
+        ret = map_kvm_run(s, cpu, errp);
+        if (ret < 0) {
+            goto err;
+        }
+
+        if (s->kvm_dirty_ring_size) {
+            ret = map_kvm_dirty_gfns(s, cpu, errp);
+            if (ret < 0) {
+                goto err;
+            }
+        }
+
+        ret = kvm_arch_init_vcpu(cpu);
+        if (ret < 0) {
+            error_setg_errno(errp, -ret,
+                             "kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
+                             vcpu_id);
+        }
+
+        close(cpu->kvm_vcpu_stats_fd);
+        cpu->kvm_vcpu_stats_fd = kvm_vcpu_ioctl(cpu, KVM_GET_STATS_FD, NULL);
+        kvm_init_cpu_signals(cpu);
+    }
+    trace_kvm_rebind_vcpus();
+
+ err:
+    return ret;
+}
+
 static void kvm_park_vcpu(CPUState *cpu)
 {
     struct KVMParkedVcpu *vcpu;
@@ -483,13 +571,7 @@ static int kvm_create_vcpu(CPUState *cpu)
         }
     }
 
-    cpu->kvm_fd = kvm_fd;
-    cpu->kvm_state = s;
-    if (!s->guest_state_protected) {
-        cpu->vcpu_dirty = true;
-    }
-    cpu->dirty_pages = 0;
-    cpu->throttle_us_per_full = 0;
+    kvm_create_vcpu_internal(cpu, s, kvm_fd);
 
     trace_kvm_create_vcpu(cpu->cpu_index, vcpu_id, kvm_fd);
 
@@ -508,19 +590,11 @@ int kvm_create_and_park_vcpu(CPUState *cpu)
     return ret;
 }
 
-static int do_kvm_destroy_vcpu(CPUState *cpu)
+static int vcpu_unmap_regions(KVMState *s, CPUState *cpu)
 {
-    KVMState *s = kvm_state;
     int mmap_size;
     int ret = 0;
 
-    trace_kvm_destroy_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
-
-    ret = kvm_arch_destroy_vcpu(cpu);
-    if (ret < 0) {
-        goto err;
-    }
-
     mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
     if (mmap_size < 0) {
         ret = mmap_size;
@@ -548,39 +622,47 @@ static int do_kvm_destroy_vcpu(CPUState *cpu)
         cpu->kvm_dirty_gfns = NULL;
     }
 
-    kvm_park_vcpu(cpu);
-err:
+ err:
     return ret;
 }
 
-void kvm_destroy_vcpu(CPUState *cpu)
-{
-    if (do_kvm_destroy_vcpu(cpu) < 0) {
-        error_report("kvm_destroy_vcpu failed");
-        exit(EXIT_FAILURE);
-    }
-}
-
-int kvm_init_vcpu(CPUState *cpu, Error **errp)
+static int do_kvm_destroy_vcpu(CPUState *cpu)
 {
     KVMState *s = kvm_state;
-    int mmap_size;
-    int ret;
+    int ret = 0;
 
-    trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
+    trace_kvm_destroy_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
-    ret = kvm_arch_pre_create_vcpu(cpu, errp);
+    ret = kvm_arch_destroy_vcpu(cpu);
     if (ret < 0) {
         goto err;
     }
 
-    ret = kvm_create_vcpu(cpu);
+    /* If I am the CPU that created coalesced_mmio_ring, then discard it */
+    if (s->coalesced_mmio_ring == (void *)cpu->kvm_run + PAGE_SIZE) {
+        s->coalesced_mmio_ring = NULL;
+    }
+
+    ret = vcpu_unmap_regions(s, cpu);
     if (ret < 0) {
-        error_setg_errno(errp, -ret,
-                         "kvm_init_vcpu: kvm_create_vcpu failed (%lu)",
-                         kvm_arch_vcpu_id(cpu));
         goto err;
     }
+    kvm_park_vcpu(cpu);
+err:
+    return ret;
+}
+
+void kvm_destroy_vcpu(CPUState *cpu)
+{
+    if (do_kvm_destroy_vcpu(cpu) < 0) {
+        error_report("kvm_destroy_vcpu failed");
+        exit(EXIT_FAILURE);
+    }
+}
+
+static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp)
+{
+    int mmap_size, ret = 0;
 
     mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
     if (mmap_size < 0) {
@@ -605,14 +687,53 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
             (void *)cpu->kvm_run + s->coalesced_mmio * PAGE_SIZE;
     }
 
+ err:
+    return ret;
+}
+
+static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp)
+{
+    int ret = 0;
+    /* Use MAP_SHARED to share pages with the kernel */
+    cpu->kvm_dirty_gfns = mmap(NULL, s->kvm_dirty_ring_bytes,
+                               PROT_READ | PROT_WRITE, MAP_SHARED,
+                               cpu->kvm_fd,
+                               PAGE_SIZE * KVM_DIRTY_LOG_PAGE_OFFSET);
+    if (cpu->kvm_dirty_gfns == MAP_FAILED) {
+        ret = -errno;
+    }
+
+    return ret;
+}
+
+int kvm_init_vcpu(CPUState *cpu, Error **errp)
+{
+    KVMState *s = kvm_state;
+    int ret;
+
+    trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
+
+    ret = kvm_arch_pre_create_vcpu(cpu, errp);
+    if (ret < 0) {
+        goto err;
+    }
+
+    ret = kvm_create_vcpu(cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret,
+                         "kvm_init_vcpu: kvm_create_vcpu failed (%lu)",
+                         kvm_arch_vcpu_id(cpu));
+        goto err;
+    }
+
+    ret = map_kvm_run(s, cpu, errp);
+    if (ret < 0) {
+        goto err;
+    }
+
     if (s->kvm_dirty_ring_size) {
-        /* Use MAP_SHARED to share pages with the kernel */
-        cpu->kvm_dirty_gfns = mmap(NULL, s->kvm_dirty_ring_bytes,
-                                   PROT_READ | PROT_WRITE, MAP_SHARED,
-                                   cpu->kvm_fd,
-                                   PAGE_SIZE * KVM_DIRTY_LOG_PAGE_OFFSET);
-        if (cpu->kvm_dirty_gfns == MAP_FAILED) {
-            ret = -errno;
+        ret = map_kvm_dirty_gfns(s, cpu, errp);
+        if (ret < 0) {
             goto err;
         }
     }
@@ -2710,6 +2831,16 @@ static int kvm_reset_vmfd(MachineState *ms)
     }
     assert(!err);
 
+    /*
+     * rebind new vcpu fds with the new kvm fds
+     * These can only be called after kvm_arch_on_vmfd_change()
+     */
+    ret = kvm_rebind_vcpus(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
     /* these can be only called after ram_block_rebind() */
     memory_listener_register(&kml->listener, &address_space_memory);
     memory_listener_register(&kvm_io_listener, &address_space_io);
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index e4beda0148..4a8921c632 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -15,6 +15,7 @@ kvm_park_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_unpark_vcpu(unsigned long arch_cpu_id, const char *msg) "id: %lu %s"
 kvm_irqchip_commit_routes(void) ""
 kvm_reset_vmfd(void) ""
+kvm_rebind_vcpus(void) ""
 kvm_irqchip_add_msi_route(char *name, int vector, int virq) "dev %s vector %d virq %d"
 kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
-- 
2.42.0


