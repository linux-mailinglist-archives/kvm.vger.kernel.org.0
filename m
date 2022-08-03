Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E05588DDE
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbiHCNtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238558AbiHCNtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:49:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 750892409F
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+WNP5g0MFdn4fojH2m6YlFR7oOtayB1+T9v33lYjzc=;
        b=irKxB+h5ZgU0JljDWuFRucS4ycnjFyMOgZbDZVa+WWIKrprgAv5nEc0iTZBE/GT/po0ggm
        1gtAg4vTQZ3dAgSAqRBKl1DN9R1pXTWO9+EV5RfaL3XHoIL1uONG6jDXdEbM5R2V9sAk4D
        azSignQUmCoKuKsB7ozpsNklvxlLHwE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-889pXwtuP1ahCrL8VRjzig-1; Wed, 03 Aug 2022 09:47:24 -0400
X-MC-Unique: 889pXwtuP1ahCrL8VRjzig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E74038037B5;
        Wed,  3 Aug 2022 13:47:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37D2D2166B26;
        Wed,  3 Aug 2022 13:47:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 40/40] KVM: selftests: Rename 'evmcs_test' to 'hyperv_evmcs'
Date:   Wed,  3 Aug 2022 15:47:20 +0200
Message-Id: <20220803134720.399620-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Conform to the rest of Hyper-V emulation selftests which have 'hyperv'
prefix. Get rid of '_test' suffix as well as the purpose of this code
is fairly obvious.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore                          | 2 +-
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../selftests/kvm/x86_64/{evmcs_test.c => hyperv_evmcs.c}       | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{evmcs_test.c => hyperv_evmcs.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9305809537f2..a73b3f4b8911 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,7 +15,6 @@
 /x86_64/cpuid_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
-/x86_64/evmcs_test
 /x86_64/emulator_error_test
 /x86_64/fix_hypercall_test
 /x86_64/get_msr_index_features
@@ -23,6 +22,7 @@
 /x86_64/kvm_pv_test
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
+/x86_64/hyperv_evmcs
 /x86_64/hyperv_features
 /x86_64/hyperv_ipi
 /x86_64/hyperv_svm_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6d43e7da431c..1f1ac0de201b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -78,11 +78,11 @@ TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
-TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_evmcs
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/evmcs_test.c
rename to tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
-- 
2.35.3

