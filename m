Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0861495FCA
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 14:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380727AbiAUN3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 08:29:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380726AbiAUN3L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 08:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642771750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2PBE8349W+pORnjnNy3WMgm07NQBV8dZAmx6X3HKn1A=;
        b=Mb9EXCGIA9pJC3LS6zt7QyDxSypyObPwqeoWTAQaXZ+0qtYLvUXpwptiWecxLJxbXnJfNg
        /YNcKK30n7oCy2rdp2ByVsCbRfQsvkeGEajuoZ+KATroYv4TowBOImPm3xtC654UhD5b4z
        uyeB1n+fV3eGTWb9E6cfoOp57E/9oFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-DsspPE7UO0aD9UtMTOEkmQ-1; Fri, 21 Jan 2022 08:29:07 -0500
X-MC-Unique: DsspPE7UO0aD9UtMTOEkmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B05A884DA41;
        Fri, 21 Jan 2022 13:29:06 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D9637E213;
        Fri, 21 Jan 2022 13:29:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
Date:   Fri, 21 Jan 2022 14:28:51 +0100
Message-Id: <20220121132852.2482355-5-vkuznets@redhat.com>
In-Reply-To: <20220121132852.2482355-1-vkuznets@redhat.com>
References: <20220121132852.2482355-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to reusing the existing 'get_cpuid_test' for testing
"KVM_SET_CPUID{,2} after KVM_RUN" rename it to 'cpuid_test' to avoid
the confusion.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore                        | 2 +-
 tools/testing/selftests/kvm/Makefile                          | 4 ++--
 .../selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c}   | 0
 3 files changed, 3 insertions(+), 3 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 8c129961accf..20b4c921c9a2 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -8,11 +8,11 @@
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
+/x86_64/cpuid_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
 /x86_64/emulator_error_test
-/x86_64/get_cpuid_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ee8cf2149824..ec78a8692899 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -43,11 +43,11 @@ LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handler
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
 
-TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
+TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
-TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
rename to tools/testing/selftests/kvm/x86_64/cpuid_test.c
-- 
2.34.1

