Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D899536559
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 17:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353943AbiE0P5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 11:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353992AbiE0P5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 11:57:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37BA16BFC4
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 08:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653667018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1sMy8xaJxhqapgk5p9GIXqaotAkSrql7bAakOStiUU=;
        b=hyFQcQXoLa6mbKzWc3e379eQuD7GOzaR8gUFSdMaefrkh63KQK75XqVtfvpir97wuIwzIf
        +NZTxcJf5tWPAhO03CRUIKHFjnOHUVZt5Yozx7F5iUWH7Q6gXeJQvT9H8lx7gCOIgaAUHn
        VxNyDtILjVa0jDkFC1GIWsgSnqSPIEc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-x2Ss9UikPtOD2emhN0F_hg-1; Fri, 27 May 2022 11:56:55 -0400
X-MC-Unique: x2Ss9UikPtOD2emhN0F_hg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E66262949BC7;
        Fri, 27 May 2022 15:56:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D05A62166B29;
        Fri, 27 May 2022 15:56:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 24/37] KVM: selftests: Move HYPERV_LINUX_OS_ID definition to a common header
Date:   Fri, 27 May 2022 17:55:33 +0200
Message-Id: <20220527155546.1528910-25-vkuznets@redhat.com>
In-Reply-To: <20220527155546.1528910-1-vkuznets@redhat.com>
References: <20220527155546.1528910-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HYPERV_LINUX_OS_ID needs to be written to HV_X64_MSR_GUEST_OS_ID by
each Hyper-V specific selftest.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 3 +++
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index b66910702c0a..f0a8a93694b2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -185,4 +185,7 @@
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
 
+/* Proper HV_X64_MSR_GUEST_OS_ID value */
+#define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 672915ce73d8..98c020356925 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -14,7 +14,6 @@
 #include "hyperv.h"
 
 #define VCPU_ID 0
-#define LINUX_OS_ID ((u64)0x8100 << 48)
 
 extern unsigned char rdmsr_start;
 extern unsigned char rdmsr_end;
@@ -127,7 +126,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	int i = 0;
 	u64 res, input, output;
 
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 
 	while (hcall->control) {
@@ -230,7 +229,7 @@ static void guest_test_msrs_access(void)
 			 */
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 1;
-			msr->write_val = LINUX_OS_ID;
+			msr->write_val = HYPERV_LINUX_OS_ID;
 			msr->available = 1;
 			break;
 		case 3:
-- 
2.35.3

