Return-Path: <kvm+bounces-70919-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8K/lAdNyjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70919-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B6112AA00
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AEC0E30E6418
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B22291C07;
	Thu, 12 Feb 2026 06:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gsl7rIn9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/rY0aqx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3002128BAB9
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877635; cv=none; b=tGJrCPB0zi+jCqERwL9IYeVviDtDpUS8Eil2Tdw6wDFE1n+KaRTHBxEKmEuLQ35LcmQ3Lwi9gbT4yFZ7JvX5eBfBzP9AYB6JhlVZxADSyhCK3YklT4ESPaQzFVRAcu2M/UQQZ0zT8L0b/grt5L2rX575HCcQasPOih7e3fLFgks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877635; c=relaxed/simple;
	bh=IPksgd8tAPT00FC5dIFN5ta9KlatPLxmHV9qZYXJIwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPN6X2gjTH/oTm97WWl/5kkelrxra5wgUWPSGxMRucK5xM/ZIW3tazNnAZa/uDmHnQtCAx8hLCx5NIQtqiG5gDWUF0aOenulh8K1msbIS1ZFCEKDycxx2gE6BOeFeuu8WSENaSF+S6pDr0H9RdFeKaWJDfhX5SXNObdL5i4xSfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gsl7rIn9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=O/rY0aqx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
	b=Gsl7rIn9f/mGs/sB6kSZmpZo6b/EMvb1K/nunuUXPu99NZmsLBJEaCfiCgZRrTHD1TxdBE
	axNpfY0/8Byzo+CN7kUZmxN2MNCH134k+ssPJOPtisHzcaNQ/8FAyu3O2+YbdtCibJZ0ek
	y8bA0BzcQvMyihPEDN0tntVqy/LbuVQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-1kn9GwI4NJ2JnhgKpVjuiA-1; Thu, 12 Feb 2026 01:27:12 -0500
X-MC-Unique: 1kn9GwI4NJ2JnhgKpVjuiA-1
X-Mimecast-MFC-AGG-ID: 1kn9GwI4NJ2JnhgKpVjuiA_1770877631
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-352de7a89e1so2598876a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877631; x=1771482431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
        b=O/rY0aqxQOap/D62DZExPLVobJgEJe0gPu6slJ1JBXbRe3g9WIDxvtPolkhv8ao9eU
         9ptZSzBF770q8nubBLUW3gY4FQYHRhwFdBLvwxt6lICeoYg812UcenllrtEUofirWy3E
         KEKjIJLkpz0lvyIrqSaUWCRsCNkWJZQKGsiAEYvj8icrif5nCZiYstPxzU4XE2ThfwXl
         rSuFE9r+bFspqrvz/i4m3Pk7MrMWzClA+QZh7yURPmW0yiu9DGUD+6VrHZqk+mogzbL0
         HsUUNaOeeWAY5woRg3BAHr0dW/uY+4sTFyku1wnptvu7E5Od0i9fmO2rPsmSgXQBC0v6
         xUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877631; x=1771482431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
        b=qjd3rhqd7XHZ9V+1KbksYIzzrjX88PbsLLgjblOxecesuE+lINw6IIqAvvU4zWw8pH
         GnLr32kSAZqPJwegXfv+VkLodGE0HU55Oi63KYPKDsnraFWE99v6ASnbVcTNsiW6aMId
         evX5vHBNqTs5lE//GQiVdMJ01UwZbB0TIfI1ANZjS/sEfkmblZAyc+Qr8hU6pRJEhPtc
         3VDk4bdVXJQYnftbMRM/5c/HrvSUAGlobM2iTPRfl1vPb4CHSvYO+WuxbAgx617UjAUg
         z4EnNsRAV4HbfJb8IR44RKSbDm24c3TAMEFe1yqZRNHyRdjTgZUjVuREcf0uSFm7qryY
         XlKg==
X-Forwarded-Encrypted: i=1; AJvYcCW0sSDUDK3jZ3lTBb1VRIAUKBXBSY6KgWFhFEF9zP0z3kcMlLXDaoYKRP7SMuEwzhFCBCY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+8IdG9VLe70srttAp3bNGmg2+NAl/8DTcPbpTi2sVqGf4wlsI
	MOd+tZ5SSyv1FJjtiq+fFcrP7GBjGWS5irgE2icXPT9MDT04htduWHQho0xmw52bjUagdt4L8kU
	DGjIXKmnaSUIch/PvMsLp5tGkPXuYnQs5LDIGq05e7lBvgkM3hlpW1xb/jFDRFQ==
X-Gm-Gg: AZuq6aK6VDHVG03DEzKy8kgp0zN29bNlAr+I+R/A/e5vgnUu48t7AT3NsqCe9GvkQQ6
	zABEFborPALvRVRKAXAPiKb+qIp/SaqQmu4Dg8vDDQ5Z4w3iZk+ukDKCX46FodJ+bONyMbn3P4X
	IjaW++IkuBklfbZj0Re54jv4DDUXLCH0F2S8cTEer3WP4XActgXsLdOdvSntRKJm4GtQcHBytIC
	+1vYbDQxt1rYj7KjwxOdSpMeUUQVhnOITZKcg+vOt3g+gb5YsarT7ac89JdpIrwn08aVPhILdYa
	hUYAQA3sESWv09yPUnXcrEg0YpJzOjctrnGjhBxsGUlD4YJYO46LFsJSrM/8vraGNvhtzzPHXpc
	SRyaEPSGLLQ3sSM6o/1SplouxaSqUjE1AJsHLypFOkE+XJao0FqgBp4U=
X-Received: by 2002:a17:90a:d2ce:b0:341:2150:4856 with SMTP id 98e67ed59e1d1-35693d5e966mr1153074a91.17.1770877630757;
        Wed, 11 Feb 2026 22:27:10 -0800 (PST)
X-Received: by 2002:a17:90a:d2ce:b0:341:2150:4856 with SMTP id 98e67ed59e1d1-35693d5e966mr1153054a91.17.1770877630409;
        Wed, 11 Feb 2026 22:27:10 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:27:10 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 26/31] kvm/xen-emu: re-initialize capabilities during confidential guest reset
Date: Thu, 12 Feb 2026 11:55:10 +0530
Message-ID: <20260212062522.99565-27-anisinha@redhat.com>
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
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70919-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 69B6112AA00
X-Rspamd-Action: no action

On confidential guests KVM virtual machine file descriptor changes as a
part of the guest reset process. Xen capabilities needs to be re-initialized in
KVM against the new file descriptor.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/xen-emu.c | 50 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 52de019834..69527145eb 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -44,9 +44,12 @@
 
 #include "xen-compat.h"
 
+NotifierWithReturn xen_vmfd_change_notifier;
+static bool hyperv_enabled;
 static void xen_vcpu_singleshot_timer_event(void *opaque);
 static void xen_vcpu_periodic_timer_event(void *opaque);
 static int vcpuop_stop_singleshot_timer(CPUState *cs);
+static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr);
 
 #ifdef TARGET_X86_64
 #define hypercall_compat32(longmode) (!(longmode))
@@ -54,6 +57,30 @@ static int vcpuop_stop_singleshot_timer(CPUState *cs);
 #define hypercall_compat32(longmode) (false)
 #endif
 
+static int xen_handle_vmfd_change(NotifierWithReturn *n,
+                                  void *data, Error** errp)
+{
+    int ret;
+
+    /* we are not interested in pre vmfd change notification */
+    if (((VmfdChangeNotifier *)data)->pre) {
+        return 0;
+    }
+
+    ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (hyperv_enabled) {
+        ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR_HYPERV);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+    return 0;
+}
+
 static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t *gpa,
                            size_t *len, bool is_write)
 {
@@ -111,15 +138,16 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint64_t gva, void *buf,
     return kvm_gva_rw(cs, gva, buf, sz, true);
 }
 
-int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
+static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr)
 {
+    int xen_caps, ret;
     const int required_caps = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
         KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | KVM_XEN_HVM_CONFIG_SHARED_INFO;
+
     struct kvm_xen_hvm_config cfg = {
         .msr = hypercall_msr,
         .flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
     };
-    int xen_caps, ret;
 
     xen_caps = kvm_check_extension(s, KVM_CAP_XEN_HVM);
     if (required_caps & ~xen_caps) {
@@ -143,6 +171,21 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
                      strerror(-ret));
         return ret;
     }
+    return xen_caps;
+}
+
+int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
+{
+    int xen_caps;
+
+    xen_caps = do_initialize_xen_caps(s, hypercall_msr);
+    if (xen_caps < 0) {
+        return xen_caps;
+    }
+
+    if (!hyperv_enabled && (hypercall_msr == XEN_HYPERCALL_MSR_HYPERV)) {
+        hyperv_enabled = true;
+    }
 
     /* If called a second time, don't repeat the rest of the setup. */
     if (s->xen_caps) {
@@ -185,6 +228,9 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     xen_primary_console_reset();
     xen_xenstore_reset();
 
+    xen_vmfd_change_notifier.notify = xen_handle_vmfd_change;
+    kvm_vmfd_add_change_notifier(&xen_vmfd_change_notifier);
+
     return 0;
 }
 
-- 
2.42.0


