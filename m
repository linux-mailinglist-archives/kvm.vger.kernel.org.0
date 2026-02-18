Return-Path: <kvm+bounces-71241-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6L2xB2SmlWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71241-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:45:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7376315608A
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48B5C304D958
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCEB130DEAA;
	Wed, 18 Feb 2026 11:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JamQZVqq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bWOpxnc+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67F53033D8
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415060; cv=none; b=g2XDNO+uKI16pShFA6eaAMgi8IjeSukIU9ye+sTPmOOvG/nLIo3XONJBAcKsQvlBU/D9KgRZlyrUKz+eXGrhxx0mW+3F7ddH/qf43ElT//YNzrZTDvZaX6hFsgdKZhVIyq66CltYAleQjw5be07CwvQkUzaFlJH2Wkxolp4Z8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415060; c=relaxed/simple;
	bh=0l/Y/XB5Dg23lTxFWXVdRRF292iRY8ntChwHZR+uHfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGUC8pHP4pzeByThX02FLOGcNbc8gihxObJu5pAln70cKKxsQNIlOquZfJUoUzXHIsY6aOxf4JhbN9mh3SvLcl17xSrTbNxttESjk20co5zZBURPMF2HxHLnu62LVYxnqGb7/JCypxT3vEqfR1p50hwPy/7LOutHJlKwzblLtNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JamQZVqq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bWOpxnc+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1nGeqoQ1o3VYpe1DNoWnGTiyMQ3GWu83ptlZVbrEhc=;
	b=JamQZVqq0v2AE1jmLEFxAPr+Tknx26d+SDGTeOMPsOJ09K/ri3qHonI8JF21oWu74j1GFz
	uGxtkGOrfdOOChQoP3j14ess3ytWv8jFnDiM0OVVmRpK/w5tftos1qlGTMzIVutR6PwzGX
	KopWAYhYUBGYoKlbB1DRINj5Z/QTiaY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-6NFPlVZLOIeZDb5q43ofwA-1; Wed, 18 Feb 2026 06:44:16 -0500
X-MC-Unique: 6NFPlVZLOIeZDb5q43ofwA-1
X-Mimecast-MFC-AGG-ID: 6NFPlVZLOIeZDb5q43ofwA_1771415055
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aaf0dbd073so66409625ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415055; x=1772019855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1nGeqoQ1o3VYpe1DNoWnGTiyMQ3GWu83ptlZVbrEhc=;
        b=bWOpxnc+Ew9orrVq5GGUEA0U81Nn3E57FKnK4Z7mFqTQFXPmrMGyCk3SFR2ETUhoFF
         AfbLdtVz8KnJEnAc+0xsKXtRJZcTVID+02qh5UTIf8Df6VbWBBARWFf4lJUQ0DTCxvmt
         RGbVFTMdROFUFTJsYqZ25Vsd4eyto0UNHfip+yOCRUiPfBXtFBj4rUFMnrnZ4wmWrJHb
         o3Ct7HRYI8OpI4k4imMxH+AyYAKuG/mEMsJM4Yy46gtw4QCSJc1Lq4FsAORd4C51qA3a
         Lm4xnnHraNFrboPSzNUOU9+BsaG5bDyXDZS5z/boq/wSs4kZAfsF390Qhmb07JaIl8k3
         7bIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415055; x=1772019855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L1nGeqoQ1o3VYpe1DNoWnGTiyMQ3GWu83ptlZVbrEhc=;
        b=xOdEpVL4zXIYeXhw1TnE0/PjuR0cT2oaZZpeD+jEz74yCxJaRj3hYlCJM+jV+Iu/X/
         loE9xKGRB2Mf158/ahpWWvy0NP+fVSI+9L3laeg0qDqgZA92/2ZjYK8wGbM2+WQDUF1H
         GE0KKfgMku4iuVhmkrWlRO3h6qoeNbZ9PcdbnMmsMKlL0bxDM4bpujMNguOqcxxxdJJf
         drasbL6sUX/ZgmOdzzSOcAC+y1sK9aSZIDX+215gv1xEu+XvtXY0W9yGIqOcZPrKs5vx
         G/vrUndyNkX8XJ+y7HYUFvs2hgUch/aLOfC4DmTlnbbjWbhYY27aQPFEj8KvaTA2kuQ2
         JewQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDXlo4+99IyvPzHmHSRcA/rdWUmyPrFIWrZmzVJuaEcE5I6PCtUhqW9T11AK+5+y4l42Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLjlApeLecYSTrcxeFHS1ulJOe1RdNj1vPgZbskvmy8bJpI1WZ
	wqneBJJZeTUyKkdfJhuSTHOdIwqQtJVAXHLwYbIlf+K7eBXNiPc9zsHAYdrrtLqfCwktATpvHXD
	KHwv2RHNc+MeQs/OODUQk2oTBb/mJ8Ix0hdqCG+uvPa9tOSmGRjA2Aw==
X-Gm-Gg: AZuq6aIEPFJ7KrdkdaBKtqkYWFFW4e6ubJlId3iqUyRI4MbmKN8pr6BhxV3QMT4C2Ca
	hDe0vUqNXwbrrsGRQOaUIdT3zdFN6d4bZtOuXIvXI+6cIJ5mf1BSlB763SFTJyeMctVQUHQfwZ/
	rl1VJPj5Yg4sm8oXBIhVOkDC2jxCUtUf+EJLlXn+POyy8/3PLfbSRo9+LJhnoLVIiF8egVxSBMo
	DfpR59TtnpgAq2Aj1EXuThleECkcjQhCZkYSAS/GsYHq6Y46d2Z8Z2ZmlCcsruI3/kEha5QeYix
	zl77OMQzbpqNOOiH8nxj4DMl2mU6iUyC87ihltlURArZkJ4M4bfPa7L/BKZ2RAMwXuX7HDntSaA
	+nP3A724T5y8vdLc4NShTFrX27acIgQJaNidavpklljRW6ft7Sk8K
X-Received: by 2002:a17:903:2f8f:b0:29f:2b8a:d3d with SMTP id d9443c01a7336-2ab50525225mr157634545ad.4.1771415055512;
        Wed, 18 Feb 2026 03:44:15 -0800 (PST)
X-Received: by 2002:a17:903:2f8f:b0:29f:2b8a:d3d with SMTP id d9443c01a7336-2ab50525225mr157634365ad.4.1771415055103;
        Wed, 18 Feb 2026 03:44:15 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:44:14 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 29/34] kvm/vcpu: add notifiers to inform vcpu file descriptor change
Date: Wed, 18 Feb 2026 17:12:22 +0530
Message-ID: <20260218114233.266178-30-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71241-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7376315608A
X-Rspamd-Action: no action

When new vcpu file descriptors are created and bound to the new kvm file
descriptor as a part of the confidential guest reset mechanism, various
subsystems needs to know about it. This change adds notifiers so that various
subsystems can take appropriate actions when vcpu fds change by registering
their handlers to this notifier.
Subsequent changes will register specific handlers to this notifier.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 26 ++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c | 10 ++++++++++
 include/system/kvm.h   | 17 +++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 7be39111bb..d7ea60f582 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -127,6 +127,9 @@ static NotifierList kvm_irqchip_change_notifiers =
 static NotifierWithReturnList register_vmfd_changed_notifiers =
     NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_changed_notifiers);
 
+static NotifierWithReturnList register_vcpufd_changed_notifiers =
+    NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vcpufd_changed_notifiers);
+
 static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp);
 static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp);
 static int vcpu_unmap_regions(KVMState *s, CPUState *cpu);
@@ -2314,6 +2317,22 @@ static int kvm_vmfd_change_notify(Error **errp)
                                             &vmfd_notifier, errp);
 }
 
+void kvm_vcpufd_add_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_list_add(&register_vcpufd_changed_notifiers, n);
+}
+
+void kvm_vcpufd_remove_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_remove(n);
+}
+
+static int kvm_vcpufd_change_notify(Error **errp)
+{
+    return notifier_with_return_list_notify(&register_vcpufd_changed_notifiers,
+                                            &vmfd_notifier, errp);
+}
+
 int kvm_irqchip_get_virq(KVMState *s)
 {
     int next_virq;
@@ -2838,6 +2857,13 @@ static int kvm_reset_vmfd(MachineState *ms)
     }
     assert(!err);
 
+    /* notify everyone that vcpu fd has changed. */
+    ret = kvm_vcpufd_change_notify(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
     /* these can be only called after ram_block_rebind() */
     memory_listener_register(&kml->listener, &address_space_memory);
     memory_listener_register(&kvm_io_listener, &address_space_io);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index a6e8a6e16c..c4617caac6 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -87,6 +87,16 @@ void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n)
 {
 }
 
+void kvm_vcpufd_add_change_notifier(NotifierWithReturn *n)
+{
+    return;
+}
+
+void kvm_vcpufd_remove_change_notifier(NotifierWithReturn *n)
+{
+    return;
+}
+
 int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
                                        EventNotifier *rn, int virq)
 {
diff --git a/include/system/kvm.h b/include/system/kvm.h
index fbe23608a1..4b0e1b4ab1 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -590,4 +590,21 @@ void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
  */
 void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n);
 
+/**
+ * kvm_vcpufd_add_change_notifier - register a notifier to get notified when
+ * a KVM vcpu file descriptors changes as a part of the confidential guest
+ * "reset" process. Various subsystems should use this mechanism to take
+ * actions such as re-issuing vcpu ioctls as a part of setting up vcpu
+ * features.
+ * @n: notifier with return value.
+ */
+void kvm_vcpufd_add_change_notifier(NotifierWithReturn *n);
+
+/**
+ * kvm_vcpufd_remove_change_notifier - de-register a notifer previously
+ * registered with kvm_vcpufd_add_change_notifier call.
+ * @n: notifier that was previously registered.
+ */
+void kvm_vcpufd_remove_change_notifier(NotifierWithReturn *n);
+
 #endif
-- 
2.42.0


