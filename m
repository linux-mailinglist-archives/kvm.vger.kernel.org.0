Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57625E5460
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 22:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiIUUQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 16:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiIUUQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 16:16:19 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42344A4B05
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:16:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r126-20020a632b84000000b004393806c06eso3997248pgr.4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=lpyPWQxXRZTNHwtFSxl2dSmKDyXDF3+wOW3rgKVQSqU=;
        b=FZjzOxu686KYJiTxPDOZC2FoprduGFjXZkXWBmtmref8jEQABYD+cTHV1X1j/wWRWk
         hEQjTfY5iwgk88XSmO8/WJuulmqUMG0b1kY/372bTTh7psaWGjaCV5FAm68KMWeqeprh
         YYe0MxR2J34t4bJcatTbx0+97HHnaF2R6zAW9QQzKr6okqkMkkHmFqohMNXNy5BgY6nR
         9TgYAfld3a60ADIeg8m/rfFi8pJwLVoExi7GgJdY8v3pqSHNqzGB1H+P8ZdJBOVlxdmT
         2pKCEHWCpgX7FlFr325mNTY25Si/+X2Ir2lKhZEafAtvD6rw4W84QKkQ8bayeoovRnm9
         MIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=lpyPWQxXRZTNHwtFSxl2dSmKDyXDF3+wOW3rgKVQSqU=;
        b=jUOIfmM5Zz3CcIqRjMi+mQD2XaZNZ2Zwpqt8hC4FVOBIn7bOLQTyndgpHN/N47oWqv
         ILY6Qr3pC3+r8daWi8pQadzGRFFb8yIbJcLzzZO9ub7Yx54XgyLYC3HBH6tEBZB/gf6N
         zmNc1CyYYs52FozZGZJ5O5uY26TaQlTHTOlZ6H0ACJC2jzxncE25zdLbp3GGFf8LHMYM
         a+vk2hKFEm8Vb1m7cxRbSnYzhNexKm28ovP16Etqitu0sUnFOUZ6ULhhlEUQQEOQqLqV
         ORZhESfPvpmtW8yjX34SYuCrOqMftSolnP119T7BbfbqOU6GL8OfVFMaiRL+2ajYchQR
         ch9Q==
X-Gm-Message-State: ACrzQf1CNiYNwt8LIfUo+hScIaZ2ugrqlWb7AUtjOQ5fc2/38A4SHo+5
        Xuvjr0WNXnXT4K9r7vV18nBkDwPxaI4=
X-Google-Smtp-Source: AMsMyM7sKDV6zZ24NK8ohlR4v+6+rr8Xi2VEFhgNFa6ouqqjOS4ISAUDxFK+iWxhRL/DvQOZDBQvFFt8S+k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3144:b0:202:e2cd:2d2a with SMTP id
 ip4-20020a17090b314400b00202e2cd2d2amr11288766pjb.39.1663791376230; Wed, 21
 Sep 2022 13:16:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 20:16:07 +0000
In-Reply-To: <20220921201607.3156750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921201607.3156750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921201607.3156750-5-seanjc@google.com>
Subject: [PATCH 4/4] x86/hyperv: KVM: Rename "hv_enlightenments" to "hv_vmcb_enlightenments"
From:   Sean Christopherson <seanjc@google.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM isn't littered with "struct hv_enlightenments" casts, rename
the struct to "hv_vmcb_enlightenments" to highlight the fact that the
struct is specifically for SVM's VMCB.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/hyperv-tlfs.h                   | 2 +-
 arch/x86/include/asm/svm.h                           | 2 +-
 arch/x86/kvm/svm/nested.c                            | 2 +-
 arch/x86/kvm/svm/svm.h                               | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.c                      | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.h                      | 6 +++---
 tools/testing/selftests/kvm/include/x86_64/svm.h     | 4 ++--
 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c | 2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 4c4f81daf5a2..f7a431bcb2c3 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -588,7 +588,7 @@ struct hv_enlightened_vmcs {
  * Hyper-V uses the software reserved 32 bytes in VMCB control area to expose
  * SVM enlightenments to guests.
  */
-struct hv_enlightenments {
+struct hv_vmcb_enlightenments {
 	struct __packed hv_enlightenments_control {
 		u32 nested_flush_hypercall:1;
 		u32 msr_bitmap:1;
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 6befed2b30a6..621f064bb7cc 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -164,7 +164,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * for use by hypervisor/software.
 	 */
 	union {
-		struct hv_enlightenments hv_enlightenments;
+		struct hv_vmcb_enlightenments hv_enlightenments;
 		u8 reserved_sw[32];
 	};
 };
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a6a87d9743ce..bc9fb4dbf0ae 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -201,7 +201,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	struct hv_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 	int i;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9eb2fc76732f..5e1178bc9a64 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -152,7 +152,7 @@ struct vmcb_ctrl_area_cached {
 	u64 virt_ext;
 	u32 clean;
 	union {
-		struct hv_enlightenments hv_enlightenments;
+		struct hv_vmcb_enlightenments hv_enlightenments;
 		u8 reserved_sw[32];
 	};
 };
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 5d4036611a37..0b657c7cd21b 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -16,7 +16,7 @@
 
 int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 {
-	struct hv_enlightenments *hve;
+	struct hv_vmcb_enlightenments *hve;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
 			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
 
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index c8f8045305be..e08cd7192559 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -18,7 +18,7 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	BUILD_BUG_ON(sizeof(vmcb->control.hv_enlightenments) !=
 		     sizeof(vmcb->control.reserved_sw));
@@ -63,7 +63,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		struct kvm_vcpu *vcpu)
 {
 	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	if (hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
@@ -71,7 +71,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 
 static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 {
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 	u32 vp_index = kvm_hv_get_vpindex(vcpu);
 
 	if (hve->hv_vp_id != vp_index) {
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index 0c32549c6b64..49292190c219 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -58,7 +58,7 @@ enum {
 	INTERCEPT_RDPRU,
 };
 
-struct hv_enlightenments {
+struct hv_vmcb_enlightenments {
 	struct __packed hv_enlightenments_control {
 		u32 nested_flush_hypercall:1;
 		u32 msr_bitmap:1;
@@ -124,7 +124,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * for use by hypervisor/software.
 	 */
 	union {
-		struct hv_enlightenments hv_enlightenments;
+		struct hv_vmcb_enlightenments hv_enlightenments;
 		u8 reserved_sw[32];
 	};
 };
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 81b204ee509a..f8e43c798c86 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -46,7 +46,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	GUEST_SYNC(1);
 
-- 
2.37.3.968.ga6b4b080e4-goog

