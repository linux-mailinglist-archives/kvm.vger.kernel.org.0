Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A084D17B8
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 13:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346931AbiCHMhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 07:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346934AbiCHMgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 07:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02CD246B36
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 04:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646742955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=15wWv9LVAZnxxtccB9zs+XyKPK703Asi9tPPEBhDSuQ=;
        b=EmdG8W7HJejBkf9qSR3ZUedoNx1rHTMy5uxrTKJySnt22TE46CMYpFKVmqGbWv10WE7wQB
        tG8x/WkMLoIQllF3MeEDTgBbOjCdQd+BRFlX9bwsZaV8J2rm+0pW9b4ayEenhwcxIBBH7t
        nX6Vb0F5c4Yvfj+8a638uRzVVq7Bpz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-DOoRzjYPNguc3wplRM31XA-1; Tue, 08 Mar 2022 07:35:51 -0500
X-MC-Unique: DOoRzjYPNguc3wplRM31XA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B49E61091DA0;
        Tue,  8 Mar 2022 12:35:50 +0000 (UTC)
Received: from thuth.com (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9CB28494F;
        Tue,  8 Mar 2022 12:35:49 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH] x86: Update the list of tests that we run in the Cirrus-CI
Date:   Tue,  8 Mar 2022 13:35:38 +0100
Message-Id: <20220308123538.538575-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new tests that have been added in commit bc0dd8bdc627f0
("x86/debug: Add single-step #DB + STI/MOVSS blocking tests")
require a fixed kernel which we don't have in the Cirrus-CI yet,
so let's disable the failing "debug" test for now.

The "pcid" test has been renamed to "pcid-enabled" in commit
cad94b1394aa519 ("x86: Add a 'pcid' group for the various PCID+INVPCID
permutations").

Some additional tests are working fine now, too (pcid-asymmetric, msr,
vmx_apic_passthrough_tpr_threshold_test, vmx_init_signal_test,
vmx_pf_exception_test, vmx_sipi_signal_test), likely since the update
to Fedora 35, so we can also enable them in the CI now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 ci/cirrus-ci-fedora.yml | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
index a6b9cea..6eace8b 100644
--- a/ci/cirrus-ci-fedora.yml
+++ b/ci/cirrus-ci-fedora.yml
@@ -20,7 +20,6 @@ fedora_task:
     - ./run_tests.sh
         access
         asyncpf
-        debug
         emulator
         ept
         hypercall
@@ -33,8 +32,10 @@ fedora_task:
         ioapic
         ioapic-split
         kvmclock_test
-        pcid
+        msr
+        pcid-asymmetric
         pcid-disabled
+        pcid-enabled
         rdpru
         realmode
         rmap_chain
@@ -59,6 +60,10 @@ fedora_task:
         vmexit_tscdeadline_immed
         vmexit_vmcall
         vmx_apic_passthrough_thread
+        vmx_apic_passthrough_tpr_threshold_test
+        vmx_init_signal_test
+        vmx_pf_exception_test
+        vmx_sipi_signal_test
         xsave
         | tee results.txt
     - grep -q PASS results.txt && ! grep -q FAIL results.txt
-- 
2.27.0

