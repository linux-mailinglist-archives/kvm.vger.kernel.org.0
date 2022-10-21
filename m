Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC1C607B3C
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiJUPjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiJUPhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:37:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2B6DFB
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SJZaLliBDTJ2OenxBQMaGzRSU0FBn525QV6K9dfVAQ=;
        b=hiMoKLmuVK8E8tGhgaSqdEhTf80zmOVtfwq2BhF+j9Z5O2pSXAtNi/qLdAqWD3S/vn/H6j
        6v4oklzFs99GD0W/BCBmnGPYR5ah+oIYy3CU27c+eT1AcE8CZlyWzmWftWGhxf24Dqe7vv
        N0xZTSe8PWVoat9IDY8kKTuYCcMMzOw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-IZx6vnM3PQCmDRvy4mbAJA-1; Fri, 21 Oct 2022 11:36:45 -0400
X-MC-Unique: IZx6vnM3PQCmDRvy4mbAJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71D6C800B23;
        Fri, 21 Oct 2022 15:36:44 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F7E340CA41F;
        Fri, 21 Oct 2022 15:36:42 +0000 (UTC)
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
Subject: [PATCH v12 32/46] KVM: selftests: Move the function doing Hyper-V hypercall to a common header
Date:   Fri, 21 Oct 2022 17:35:07 +0200
Message-Id: <20221021153521.1216911-33-vkuznets@redhat.com>
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

All Hyper-V specific tests issuing hypercalls need this.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     | 18 ++++++++++++++++++
 .../selftests/kvm/x86_64/hyperv_features.c    | 19 +------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index f0a8a93694b2..40f8b1b423fc 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -185,6 +185,24 @@
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
 
+static inline uint8_t hyperv_hypercall(u64 control, vm_vaddr_t input_address,
+				       vm_vaddr_t output_address,
+				       uint64_t *hv_status)
+{
+	uint8_t vector;
+
+	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
+	asm volatile("mov %[output_address], %%r8\n\t"
+		     KVM_ASM_SAFE("vmcall")
+		     : "=a" (*hv_status),
+		       "+c" (control), "+d" (input_address),
+		       KVM_ASM_SAFE_OUTPUTS(vector)
+		     : [output_address] "r"(output_address),
+		       "a" (-EFAULT)
+		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
+	return vector;
+}
+
 /* Proper HV_X64_MSR_GUEST_OS_ID value */
 #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 71bb91602a7f..5ff4ff2365bb 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -13,23 +13,6 @@
 #include "processor.h"
 #include "hyperv.h"
 
-static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
-				vm_vaddr_t output_address, uint64_t *hv_status)
-{
-	uint8_t vector;
-
-	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
-	asm volatile("mov %[output_address], %%r8\n\t"
-		     KVM_ASM_SAFE("vmcall")
-		     : "=a" (*hv_status),
-		       "+c" (control), "+d" (input_address),
-		       KVM_ASM_SAFE_OUTPUTS(vector)
-		     : [output_address] "r"(output_address),
-		       "a" (-EFAULT)
-		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
-	return vector;
-}
-
 struct msr_data {
 	uint32_t idx;
 	bool available;
@@ -79,7 +62,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 		input = output = 0;
 	}
 
-	vector = hypercall(hcall->control, input, output, &res);
+	vector = hyperv_hypercall(hcall->control, input, output, &res);
 	if (hcall->ud_expected) {
 		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
 	} else {
-- 
2.37.3

