Return-Path: <kvm+bounces-71759-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eO2cDLFxnml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71759-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC8B191500
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2B3733025251
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29662263C7F;
	Wed, 25 Feb 2026 03:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PjhRxiKI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FuJR4gjh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A21BD9C9
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991468; cv=none; b=hipeg1CNwsIkx9Sl67nAhzApjgCJelVHUDDkOpW9mZSZP7tWtW0BujPUwVfg6cmBl8XGjLEmr4jzBI8jfSvXRPGmk+mhvZ5/7T/yqE9QVUxh0+CZWot+uvkwBOccBRfOeEBDwkSxHSj52TgfvAcAAF1a4ynyK72E2gD8I7jHJlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991468; c=relaxed/simple;
	bh=D/HcMH8qipGU081+wbDh7ZzNQ1av8MpUMvJwp4zTjnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+UgQNiiPmf52bBFCjW9FoVjTcRExeaZENe5wia33ZINpt8VdqlPL5wrn46OEQUO2wa2etjLr71oOC0axKP1HJTBkOizbFg5R6A7s9thQXCRup4XIOMA3lynearedO6aOTW0rirozup/VpxuxRUKbze45+cGN3bbSsr4ouBqxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PjhRxiKI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FuJR4gjh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
	b=PjhRxiKIOpvJPo1wtO4JZPwopfm8J1kFfxJl5lCI7cm4QEeGQBSPWQY0wrBEgRr3nKmzLj
	L7TvdEzrz5SA21kRQjXFd2Af+TGV5o8YAnUPQHv1c8TJwFKIDrCvLIaw9Lop/WZ+nooOea
	NcJ8sSjv01ytQA1kO21OeNEarleEA+M=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-ABtiTqckMS2F1wFDH7BZRw-1; Tue, 24 Feb 2026 22:51:03 -0500
X-MC-Unique: ABtiTqckMS2F1wFDH7BZRw-1
X-Mimecast-MFC-AGG-ID: ABtiTqckMS2F1wFDH7BZRw_1771991462
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-354c7a38429so310383a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991462; x=1772596262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=FuJR4gjhBu/JQNgabnj7vrFxbNPU0hRkfQ+NC9bfAFRuKjQTdUSHAJL13LKQQN0WMp
         gMG3Ygc1753Unw2eR8Au20hwnWoWZlc0VKP2KFsigeahafbVud8u+4Tl26xm5Cx8GsIH
         cE55IT1NvF97UqjhcBNURnhpyoq5jIehHfInwQm18nnRl4UhzPfJNgIeroAsGp9UKgzA
         YEqDTneRk8dDnpcwb/rAWs2Yq1vyenF5GxXUQwVwjZYQ1KnddTq52nU2CJbqvjpDKNIX
         X4adF+f4pGV6T+dEqesBxxAFB6vFrJpNenw2u+h+Eu/NAn8Vk7l/p2+Jd33CCpdOgyzy
         k3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991462; x=1772596262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=P1jfM+WPTk8sOsvGQuqRfzXAGaBYHsTytp1zvGVly36SY8QHwAFtGh27PQDMhXKVeK
         7lBBfgD5LeuD3RWfLTlUjDqPNpv3a9Oav6ZN+NgakWURkIzsvBUix4i8Gm/fWCblUPpx
         Rv8qppsAzs0d8WQlLqcp9ue5SWOdtXZmktjw9ixL3mUH1KVEqJIxzAMJD/2/qIoTa5/u
         /Xa8UvyXF3rznhyt55IHE47M0aFNwSe5mkmzMxYuX97FhCQfyk5DMFf0TeISUP96YzaE
         7Z+tL9+YiLkwkxW6+PbQaVTecruw6acjFLPQKBD1s9QTxSvLA/v6tvz37B0WBwyi5LpE
         QeMw==
X-Forwarded-Encrypted: i=1; AJvYcCW9EbwlO8WWbcBisNeGDha3W692oL+Ki/n2JLR1sFxs41+taXJ/QfD3jg/teRdRGQSmzkw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAB+IrZW3VGGtTR7XAS5Wk+r1JvLDU49oVSl8tyeJWQoItEKYI
	IorZvUZUzfsGms5kIn2I8g2hFUP5dESUW+gsyhvLzHUmSDPQ7+ZM0cjQbrY3DyzOyOv565shAfa
	3dg2I7LJcpsePmGlwqfVDWxOQvU1CfSMT1gR680av++/+RCi/sbP6HQ==
X-Gm-Gg: ATEYQzyyuKPeIxzArNIXg9O9PLqMaeDSqZ3rrBkk4ofSMJ6AArdRGso86yjiLggZThX
	XCWxzLscJ6cMrczy03LYLRnmPEMobWXyvwzF8lV1YJw6cGO2ZiApBlLvtWqQvs69IHS5KkS0Fwa
	Bszy8VawlsJ/2Pqmu2ehCeMl0bmvIqwqc8PHkfPKv+mBThFDeVWZ1quLZo2wM6dd5S5SOtwW9Ao
	pz0mKmPazaDUWh/j0hwR3y4t2PBemaJSyUxhoF+9MFm4qR/e5VFZJMw+cMhGtH5rmyjpnFlaAif
	UEXHRYE+Xge8HaATtkJJOkcU21QkzzawoJfxHUJhpsJemmHgPac0LidaWWdTwtI5TisfCPVrml5
	wJOFlPerOAW9b1+eytGDbSLTE0IBJFvL2WsaycovD+EXWjgk8KHXUA4I=
X-Received: by 2002:a17:90b:4a51:b0:356:24c8:2291 with SMTP id 98e67ed59e1d1-359008bd1e4mr1891315a91.0.1771991462093;
        Tue, 24 Feb 2026 19:51:02 -0800 (PST)
X-Received: by 2002:a17:90b:4a51:b0:356:24c8:2291 with SMTP id 98e67ed59e1d1-359008bd1e4mr1891299a91.0.1771991461744;
        Tue, 24 Feb 2026 19:51:01 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:01 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 16/35] i386/tdx: refactor TDX firmware memory initialization code into a new function
Date: Wed, 25 Feb 2026 09:19:21 +0530
Message-ID: <20260225035000.385950-17-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71759-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 1BC8B191500
X-Rspamd-Action: no action

A new helper function is introduced that refactors all firmware memory
initialization code into a separate function. No functional change.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 73 ++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index a3e81e1c0c..fd8e3de969 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -295,14 +295,51 @@ static void tdx_post_init_vcpus(void)
     }
 }
 
-static void tdx_finalize_vm(Notifier *notifier, void *unused)
+static void tdx_init_fw_mem_region(void)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
-    RAMBlock *ram_block;
     Error *local_err = NULL;
     int r;
 
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_tdx_init_mem_region region;
+        uint32_t flags;
+
+        region = (struct kvm_tdx_init_mem_region) {
+            .source_addr = (uintptr_t)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size >> 12,
+        };
+
+        flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
+                KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        do {
+            error_free(local_err);
+            local_err = NULL;
+            r = tdx_vcpu_ioctl(first_cpu, KVM_TDX_INIT_MEM_REGION, flags,
+                               &region, &local_err);
+        } while (r == -EAGAIN || r == -EINTR);
+        if (r < 0) {
+            error_report_err(local_err);
+            exit(1);
+        }
+
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
+            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
+            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+            entry->mem_ptr = NULL;
+        }
+    }
+}
+
+static void tdx_finalize_vm(Notifier *notifier, void *unused)
+{
+    TdxFirmware *tdvf = &tdx_guest->tdvf;
+    TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
+
     tdx_init_ram_entries();
 
     for_each_tdx_fw_entry(tdvf, entry) {
@@ -339,37 +376,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
     tdx_post_init_vcpus();
-
-    for_each_tdx_fw_entry(tdvf, entry) {
-        struct kvm_tdx_init_mem_region region;
-        uint32_t flags;
-
-        region = (struct kvm_tdx_init_mem_region) {
-            .source_addr = (uintptr_t)entry->mem_ptr,
-            .gpa = entry->address,
-            .nr_pages = entry->size >> 12,
-        };
-
-        flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
-                KVM_TDX_MEASURE_MEMORY_REGION : 0;
-
-        do {
-            error_free(local_err);
-            local_err = NULL;
-            r = tdx_vcpu_ioctl(first_cpu, KVM_TDX_INIT_MEM_REGION, flags,
-                               &region, &local_err);
-        } while (r == -EAGAIN || r == -EINTR);
-        if (r < 0) {
-            error_report_err(local_err);
-            exit(1);
-        }
-
-        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
-            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
-            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
-            entry->mem_ptr = NULL;
-        }
-    }
+    tdx_init_fw_mem_region();
 
     /*
      * TDVF image has been copied into private region above via
-- 
2.42.0


