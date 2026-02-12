Return-Path: <kvm+bounces-70920-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHVNA+ByjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70920-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7402B12AA1C
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F8E730FD561
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E0229993E;
	Thu, 12 Feb 2026 06:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SCMLHjoy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IeeGI3wf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E267288C3F
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877641; cv=none; b=TqzjCblIrLtSpW+Gv/lhA/MR3l/xjIXN46rDpNBsEiYBzzyKj9fyFzJ71e/uJZ9ai5BBeuXtdzG6AxLWY+B+A0Pt9j4EZdkHTSIc5IofVtZyqElwxB+H/1KJqAeW1fGonJS9R6jY1hBoJMXjIhV5Hsc+2SaE6fQEkfp2C6+SQMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877641; c=relaxed/simple;
	bh=RJKlKE7iSVS6fgSfWOUUgZHV5Gn+t0XjHpvPevBUZ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6NMZGqSgqjK0s2d2LnqvK1VYEGfGd2VCvb1l56GKCRhyYoWjqPpipn2mcs6OFy3a7JkhPYj+B4utUCf99svhC05Wl3F24rbbEnJ47Rz0Hr9Q55uPu0CXEgfAl+X7LjmU9XIBRBxHyHtOrjeYIRNknuHAqPGoDecap97UyWu+WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SCMLHjoy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IeeGI3wf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5baHEmSS1KnRdwjNGuB0g+ltPY1ZMuCXtAxZqqNbqAo=;
	b=SCMLHjoydYn2nwVOVf4GkGvViFSQGdzd8rBuy1ikINfFZBJihuK5aZEOTTSVABU8bejW2F
	oDeTNHrSqeNi55KF6InZ6Z6StZsad5OjHwlvTB8zYUGxw5EVuIcLVllcZs+QaR1KInHfrT
	7Qn36A4hJLIJR+LWeNsoj39ajxQqYbg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664--kY7CM7GNyKCKkGzYRH59Q-1; Thu, 12 Feb 2026 01:27:17 -0500
X-MC-Unique: -kY7CM7GNyKCKkGzYRH59Q-1
X-Mimecast-MFC-AGG-ID: -kY7CM7GNyKCKkGzYRH59Q_1770877636
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35641c14663so4472442a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877636; x=1771482436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5baHEmSS1KnRdwjNGuB0g+ltPY1ZMuCXtAxZqqNbqAo=;
        b=IeeGI3wf0jve1s/RgpiQABTJIph36T/5OkqYe5xaDXjH0BNHaRQD2yNHpmPdM6cSvC
         cIQODR+VejmKiEsqbziNN8N0QLzIQVtyvjgv5aykvr05o3VILV3Qjs2T6jOKRTa+kYRB
         QGZHhMduUv3FHlfZqJl9IJoOaNA1BFsNpnfRIvB1w2ruAFv6ULw+cVkJbB7MvWolqqFX
         e8tvQUtoQjfdnVT4jkxkXXqpSTx/rEI0JnCB6Pidu7u5vdjjwj1Q34vTHWILyfmVxSio
         qVUu8ADy4jmjBwgiHvHK3DJEd+1ssY5dtddV8ww7Z7FvZyu+ysl7qNV9+y3kC09gE26T
         NrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877636; x=1771482436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5baHEmSS1KnRdwjNGuB0g+ltPY1ZMuCXtAxZqqNbqAo=;
        b=iAWBbd8Ema46zjFNYZxzLmlId+wJ8OL/ZZINGpq/05q0XZc5iramyMA+7AuofZ2c7Z
         x6C3ehJy8RQzUYPKLfUG7DDCJZkmtNYa7+xKAou4iiVI91JNBCQOXtBznaw8ppf2hJ9p
         7SHUTu8kWkL0PolPG+ymDnArKo7ZJyiuBSK6Uz3Z67BsBNP5Ur+Pi9XOcG3PMrQ19XkS
         o/akfzb1LeIRivnvfjQ3gU9rPRtWqk0pxzHZxcThxc/oU2uoDLFbYZfDGhpYhWqEV7xs
         6cypDZEUPLMrmj7nfo9Xp97a7mhBAxV5sSaV39g2ydJ5L2ozYReiX4JoSv+JS3/BbSje
         gOGw==
X-Forwarded-Encrypted: i=1; AJvYcCWrXlKbauUMJQ811yGEccG1e56sxLYwCybir6xrZRbq1o5WiUxlgWCV0gIMbPFKtOJlj4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlLVu2B9xsC4f1h9G7+/THSIDA2s+XyHL315JirZ/CQSvguVnY
	yi8URYPhE2tYi+5aD+XqVLPngaf+ntVxfkSjScNXupSLuPbEm8F42hlFVHcg7rPlaxWs6kLH0tI
	7qzMyGcYUU2CiiAyZncgtYQuuMB7saqOtoQVZpaazKbmwIZXs+SZGyw==
X-Gm-Gg: AZuq6aKmoACyfONZcAXXyrZzXDtCGudJJ9BRAxottZu2UZh4jpaidFvP7oQ42ghqd7Y
	KZM3xr7OUFsyPvXpaq5ow5QugPT+roQ7NiBDD5SIn7FPIagrxWUPE8SVvfFP8Euv0cnIeuiAljS
	vOfbEPt2VywlG+j84BaxeowoTGPsEHjttFIh0sVXKS1WmfvBVyEWidQ+35++uIrY5COJXreavV9
	4KOS1J+5rdYnsIL/arfwPQasetgzBDbkjJRCckXwJ2nJ+7eB88ygQFPpB8VKMGkGcwl76CtbILN
	zAn6n4eM50i34w0x3uEuiANNmrfbo/v6CT3atIOPyJo/DZTVb+Fh0WHymCJMRKY/c+ook3wrs2O
	qWmtqKelnuw8ArPMpirOE/UIQJfLBvENkNasGQp5HCtZ6UgAFM7h27SI=
X-Received: by 2002:a17:90b:3851:b0:34a:e9b:26b1 with SMTP id 98e67ed59e1d1-3568f40232dmr1584984a91.26.1770877636224;
        Wed, 11 Feb 2026 22:27:16 -0800 (PST)
X-Received: by 2002:a17:90b:3851:b0:34a:e9b:26b1 with SMTP id 98e67ed59e1d1-3568f40232dmr1584965a91.26.1770877635918;
        Wed, 11 Feb 2026 22:27:15 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:27:15 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 28/31] kvm/vcpu: add notifiers to inform vcpu file descriptor change
Date: Thu, 12 Feb 2026 11:55:12 +0530
Message-ID: <20260212062522.99565-29-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-70920-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7402B12AA1C
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
index 5e81bf8ad2..4d4d361708 100644
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


