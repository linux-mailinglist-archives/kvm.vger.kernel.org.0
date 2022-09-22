Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABE55E6265
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiIVM3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIVM3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:29:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC701E512A
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663849749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JVZB5r5tG+l6W9rGzVpbjr3rW5QLZOxDCejh1mQrm2g=;
        b=XZ5+7QQtusOiu+8vWBwAXWzPxrzqQ4IaG8WmG4zsHEv6YRW9PXVzjVpgWs9gl4AvCGUuAT
        YhH/uq/4135SbCg/SwEP4CQbj36D+UEKgC3S34InGL46SALnXlqRhHSP2Rw6T7UTkAo7lD
        m3TMGjkI4bWytbpK5aYeav6lfd6yJvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-YBUm-pVLOUugLJkfS1kpEg-1; Thu, 22 Sep 2022 08:29:05 -0400
X-MC-Unique: YBUm-pVLOUugLJkfS1kpEg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB5FC855420;
        Thu, 22 Sep 2022 12:29:04 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBD9A4A927D;
        Thu, 22 Sep 2022 12:29:03 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH] ci: Update the list of tests that we run in the Fedora Cirrus-CI
Date:   Thu, 22 Sep 2022 14:28:50 +0200
Message-Id: <20220922122850.266424-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "msr" test recently started failing since it got extended, but
the kernel of the CI machine is not new enough to handle the new
tests. Thus we have to disable it in the CI for now.
On the other hand, there are a couple of other tests which seem
to work now, so we can include those in the list instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 ci/cirrus-ci-fedora.yml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
index 6eace8b..d6070f7 100644
--- a/ci/cirrus-ci-fedora.yml
+++ b/ci/cirrus-ci-fedora.yml
@@ -20,6 +20,7 @@ fedora_task:
     - ./run_tests.sh
         access
         asyncpf
+        debug
         emulator
         ept
         hypercall
@@ -32,7 +33,7 @@ fedora_task:
         ioapic
         ioapic-split
         kvmclock_test
-        msr
+        memory
         pcid-asymmetric
         pcid-disabled
         pcid-enabled
@@ -50,6 +51,8 @@ fedora_task:
         tsx-ctrl
         umip
         vmexit_cpuid
+        vmexit_cr0_wp
+        vmexit_cr4_pge
         vmexit_inl_pmtimer
         vmexit_ipi
         vmexit_ipi_halt
-- 
2.31.1

