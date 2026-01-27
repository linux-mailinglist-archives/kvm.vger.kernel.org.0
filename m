Return-Path: <kvm+bounces-69189-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IB8DJ2BKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69189-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 059408FFE8
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4892C301C8A8
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F0F329384;
	Tue, 27 Jan 2026 05:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K6mlr33h";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="S3NhfjnK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9984F15B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491004; cv=none; b=tR1yVkZwENYNl+zaKT/wuC4BPrB3azrAjfzzlEYmujbXLdolnGEgZDZzsbnez1mMJ/dqdyW4NHVPiO1w2t8tHk8oP2gsMbZueOLbgti3j8cjznO1UvOFP7+DDAOkux/5cR3Ij4Ac2+enXQghklwNMTfkF6GaXEQy3OxPNM8BnZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491004; c=relaxed/simple;
	bh=OBcTHuODouRNMTEUwby2NqhL/QoreODfKDsS8Uhfd4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWIaYttOKJataX1pQX7jWFTVICoqvBb5Pktarllrw1rExiB2vEAk4ljFZwEIzJ9v34gSUiy5mPQK0dPjmjSDy0f3YpsDmGhE7nEKrRYUhYCWDuHN3iBUVTwmpmHnXUZ7drbj6zVuaS+2y7tMNooYJC+ES3OqPtrSV2ot4L0T2YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K6mlr33h; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=S3NhfjnK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0tIs2fKBt+d90Z4wFAen2VAZ4+rhynD1uhYc/rJjp5c=;
	b=K6mlr33h61Ec6SNLk4uDqKpXXGo3IJl04nkOkWCm0u+WA+Am6nQUbqkUHY29ZINfn7i1wN
	0OrlvSJvrJTpK6MV//WScZgbKxwJoBPyX9vwWbQe2DQTTvVmFvZk1BoRsv+euKgvj0n/jZ
	3oG7f4hEcAeqMU5NH8fEQbQYn9fSdGs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-iC3WX8rPOXWsU07JzVCKYg-1; Tue, 27 Jan 2026 00:16:39 -0500
X-MC-Unique: iC3WX8rPOXWsU07JzVCKYg-1
X-Mimecast-MFC-AGG-ID: iC3WX8rPOXWsU07JzVCKYg_1769490999
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso4698922a91.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769490999; x=1770095799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0tIs2fKBt+d90Z4wFAen2VAZ4+rhynD1uhYc/rJjp5c=;
        b=S3NhfjnKt0CJ1deldks7ouu4ipIFJO7IUIzfhTq6H4LmpXAG4rjbqaSl+ltXeE+OsX
         Hncs+E8FZijQEmt7VE8n10bGvhg4j2X35GjV2zFBPhbgA1pu20/03PShfDyhQiixpC8d
         QEG8s+GZpz3RDR8aGAJJSx0MnIRcUdDjH2R0qtlQib85EBopKD3wNmvdb/NtwoL1X0rl
         Cp1TE24Mc4g7F1jvTQAHlqx8lkmgJlST2OMwq1Q1LwDFGTbTMpH/jhmnuOetvEsei1+g
         UH+w3OBEeATQ5vRB1S7vm5gRv2bG70uEMoTSRQFGYneXlSkxmPLdGB5BagAB2ELlnb+w
         7dZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769490999; x=1770095799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0tIs2fKBt+d90Z4wFAen2VAZ4+rhynD1uhYc/rJjp5c=;
        b=LrK6urR6qD5az7Y1wFfzavSyqcfkuwT1Z5IUh8Z8hSG5E6+ZmvDJxnxKR9n89u7htY
         OVMt+K80wTm2Mf6+YG7THNfx0QMYTfv8QTZy4PwBJLOn+QpzgMHQLVvgF75FAg5IMiWO
         z/aZq7RYD83Axle7pyThSSmasR+GiIl/R3vYbaHd6vaLs7pjatMVO6fbtms8/o+7MXvo
         7iQtuImMHCefCal1wkhytFs8Ib671077dFBs3mleRFgKED9pAKVsW6L2Q16Xj6QQtmGH
         YKylxUxgYqwkFWfdZgSBWh5zQHgOn7qFbiI9JEtiX11Z9LPsTw3wZnY9ZusAnOlxH0zr
         5X9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVC3+dmFrz+NSHfBB6tH34BZ1l5FABTVNu4oBF3cGBB4sTTMEMTeGzICdQzwYbTfTJoOuc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUxgVw0M0Gzgqoy5vm1AG9hMov6PZIelrHw1cCXdBqf6rsPf0P
	GAxZqAahW7q2zkSzZcpai8y7gGjI6RCyS6GAv0ZXY21RQZXMla2/apwsFbrFkzC+VTb51QWMzeH
	Sw90CKBhyrqOERNDxD4PtMDrJbgahbf9Xc1PJFv/7XjXdILlfWE2Ctw==
X-Gm-Gg: AZuq6aLiy/Yy94CdsEpmqnq0EK/+YCW4798dET/WI6z0cuNCj4qSImhIcpa5r2LGwrl
	55Scr5xQnDgpiJbToPNyxNEPNLOephdppf5X/bON8FC34fdpAgSyneOx3e1T/povhp2gLGN2Bf4
	fW2OmDIAedykTIj8PuV5oc83EY/93GlqWjJE3SXOZiPu7ZwlYUR93FKoQOVcAaWB031hJ3FuQJp
	SGZCT4jXe0KkBn/i5P5Mi36X/zOaHioleStvCpyU8HbV6WCKfmXinjzBb3kwD+ja6s1qWOaViDU
	YKBtflRn+3ryzzt3lvFHhxSInKfYE6C8ZgkHCnKRydv5sULY0vpKS2KDSVtpSt8WNUGhqcKp6x2
	3EugvjsGVl7YRhRmhZMq2Akk0Mvv94j1TLq8rK1TCYg==
X-Received: by 2002:a17:90a:d648:b0:34c:2e8a:ea42 with SMTP id 98e67ed59e1d1-353ffa55bb1mr523359a91.7.1769490998605;
        Mon, 26 Jan 2026 21:16:38 -0800 (PST)
X-Received: by 2002:a17:90a:d648:b0:34c:2e8a:ea42 with SMTP id 98e67ed59e1d1-353ffa55bb1mr523343a91.7.1769490998206;
        Mon, 26 Jan 2026 21:16:38 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:16:37 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 02/33] accel/kvm: add confidential class member to indicate guest rebuild capability
Date: Tue, 27 Jan 2026 10:45:30 +0530
Message-ID: <20260127051612.219475-3-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69189-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 059408FFE8
X-Rspamd-Action: no action

As a part of the confidential guest reset process, the existing encrypted guest
state must be made mutable since it would be discarded after reset. A new
encrypted and locked guest state must be established after the reset. To this
end, a new boolean member per confidential guest support class
(eg, tdx or sev-snp) is added that will indicate whether its possible to
rebuild guest state:

bool can_rebuild_guest_state;

This is true if rebuilding guest state is possible, false otherwise.
A KVM based confidential guest reset is only possible when
the existing state is locked but its possible to rebuild guest state.
Otherwise, the guest is not resettable.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 include/system/confidential-guest-support.h | 20 ++++++++++++++++++++
 system/runstate.c                           |  6 +++---
 target/i386/kvm/tdx.c                       |  1 +
 target/i386/sev.c                           |  1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/system/confidential-guest-support.h b/include/system/confidential-guest-support.h
index 0cc8b26e64..5dca717308 100644
--- a/include/system/confidential-guest-support.h
+++ b/include/system/confidential-guest-support.h
@@ -152,6 +152,11 @@ typedef struct ConfidentialGuestSupportClass {
      */
     int (*get_mem_map_entry)(int index, ConfidentialGuestMemoryMapEntry *entry,
                              Error **errp);
+
+    /*
+     * is it possible to rebuild the guest state?
+     */
+    bool can_rebuild_guest_state;
 } ConfidentialGuestSupportClass;
 
 static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
@@ -167,6 +172,21 @@ static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
     return 0;
 }
 
+static inline bool
+confidential_guest_can_rebuild_state(ConfidentialGuestSupport *cgs)
+{
+    ConfidentialGuestSupportClass *klass;
+
+    if (!cgs) {
+        /* non-confidential guests */
+        return true;
+    }
+
+    klass = CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs);
+    return klass->can_rebuild_guest_state;
+
+}
+
 static inline int confidential_guest_kvm_reset(ConfidentialGuestSupport *cgs,
                                                Error **errp)
 {
diff --git a/system/runstate.c b/system/runstate.c
index ed2db56480..5d58260ed5 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -57,6 +57,7 @@
 #include "system/reset.h"
 #include "system/runstate.h"
 #include "system/runstate-action.h"
+#include "system/confidential-guest-support.h"
 #include "system/system.h"
 #include "system/tpm.h"
 #include "trace.h"
@@ -543,8 +544,6 @@ void qemu_system_reset(ShutdownCause reason)
      */
     if (cpus_are_resettable()) {
         cpu_synchronize_all_post_reset();
-    } else {
-        assert(runstate_check(RUN_STATE_PRELAUNCH));
     }
 
     vm_set_suspended(false);
@@ -693,7 +692,8 @@ void qemu_system_reset_request(ShutdownCause reason)
     if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
         reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
         shutdown_requested = reason;
-    } else if (!cpus_are_resettable()) {
+    } else if (!cpus_are_resettable() &&
+               !confidential_guest_can_rebuild_state(current_machine->cgs)) {
         error_report("cpus are not resettable, terminating");
         shutdown_requested = reason;
     } else {
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0161985768..a3e81e1c0c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1543,6 +1543,7 @@ static void tdx_guest_class_init(ObjectClass *oc, const void *data)
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
     klass->kvm_init = tdx_kvm_init;
+    klass->can_rebuild_guest_state = true;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1d70f96ec1..176329bd07 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2760,6 +2760,7 @@ sev_common_instance_init(Object *obj)
     cgs->set_guest_state = cgs_set_guest_state;
     cgs->get_mem_map_entry = cgs_get_mem_map_entry;
     cgs->set_guest_policy = cgs_set_guest_policy;
+    cgs->can_rebuild_guest_state = true;
 
     QTAILQ_INIT(&sev_common->launch_vmsa);
 }
-- 
2.42.0


