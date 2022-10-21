Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F339E607B31
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiJUPiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiJUPhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:37:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA65827B0A9
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rUCg8qdmT/f9wGvYa9s3dkKIpVFfOtqQkOxHWueTN/k=;
        b=Dz1Bg+V7z7oqw8QP8v0u9dXchxf5RpQizG+rUmlGqzyP5Aob+gMe69YJ/V6b3JrW46zB1e
        Ip0x6aTAadkraJ7ESblSn4pbimZA60qSO6iPuoh5U6VQldv0KX1QSCBb3kgDWLoeFB4n8G
        tzIGbmHMY9RiSgtDu7YLmnqCDwdcIk0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-4encHOb_NaGJI73qvzMVkQ-1; Fri, 21 Oct 2022 11:36:42 -0400
X-MC-Unique: 4encHOb_NaGJI73qvzMVkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0213D29ABA0E;
        Fri, 21 Oct 2022 15:36:42 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7AAD40CA41F;
        Fri, 21 Oct 2022 15:36:39 +0000 (UTC)
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
Subject: [PATCH v12 31/46] KVM: selftests: Move HYPERV_LINUX_OS_ID definition to a common header
Date:   Fri, 21 Oct 2022 17:35:06 +0200
Message-Id: <20221021153521.1216911-32-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HYPERV_LINUX_OS_ID needs to be written to HV_X64_MSR_GUEST_OS_ID by
each Hyper-V specific selftest.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 3 +++
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 6 ++----
 2 files changed, 5 insertions(+), 4 deletions(-)

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
index 05b32e550a80..71bb91602a7f 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -13,8 +13,6 @@
 #include "processor.h"
 #include "hyperv.h"
 
-#define LINUX_OS_ID ((u64)0x8100 << 48)
-
 static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 				vm_vaddr_t output_address, uint64_t *hv_status)
 {
@@ -71,7 +69,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 
 	GUEST_ASSERT(hcall->control);
 
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 
 	if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
@@ -169,7 +167,7 @@ static void guest_test_msrs_access(void)
 			 */
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 1;
-			msr->write_val = LINUX_OS_ID;
+			msr->write_val = HYPERV_LINUX_OS_ID;
 			msr->available = 1;
 			break;
 		case 3:
-- 
2.37.3

