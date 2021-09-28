Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF7E41B69E
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242308AbhI1St5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242317AbhI1St4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:49:56 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38007C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:17 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id b11-20020a17090aa58b00b0019c8bfd57b8so15062698pjq.1
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fUDvleBJkSGe8lOh3dkmzfGX4tHDQ1QKX/RO2ptqrSo=;
        b=Z/RQfgzZk+32gteH7i4kLw8gjtuBJ7t3NViFbhZXp8sry6tFNAHRXo5U4RgNhBY3d0
         sj4AhyFVQiC83kUxXxgTV4jowAJUgQLeqdvdpMwCRQWyD1Njj6x1AQHULah81+vgUPrD
         Oo1VDq4SYKoXMvcKMSrM6I3kft28OzdEO9TVb3l0SX9m4evY8RzIUff7mJwbS6Tf+g1v
         bC14awJMU2nNgl45jjhNqJXXw0ePyq4scvCHXKWWlcJzmKfLZfr3jzNWX3QSx8Prrvko
         i89+gvWWvWO9bWbMa/feewXtcNDfiy5Hb49ytXAwA3incJRdyHYCbl+k3+Dk0MHPa9Ua
         EsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fUDvleBJkSGe8lOh3dkmzfGX4tHDQ1QKX/RO2ptqrSo=;
        b=x1P13vnbB0RgoKKPnHpcU+8cJL6MZsxM/l6epuu9Am1u2s7djVU1TSAuQLp/m1hS0U
         HoQ4Aj14uPvhQxCz9RN5C/f7TIVNuQf7R4NU/gvzPETfrRMO0vWOBCuw2i4nhu8WQBqn
         mpGQxVSfWgQWdNfgLhdopGe2Y3Isx7EQRx4m5WdsQel96S6w7N14s85Pu79LH3b5ZInD
         AsQnYo+CjEmU8/lIUnb9pNBXGuWtSS0iadLRzHSn1cHR10LFy+SFTmusvdWpgLKrueLl
         IvtKWHM8eWoRSxn0ChfOYCYjWvW2+lx+vZUBFcSuK8QLzLv1YyO4z2VVP2RAisADhgDB
         s2dg==
X-Gm-Message-State: AOAM530K2s9nuCFX3nMV4yhigKvbbRTutq0NSjiPSlBKeTBq66fj8pN8
        Gjp3BBCBrGek0bfazkOKTP9k7OvWzLUnQK5v6KoUTlx9oVU9pwUXgIQuIKXqDGxNYsMGB7Ncc1N
        CZypFrP7p0GPARGp9hohFjWzmQQebpftvC9q+tr4QckijkLtQyWcZxqLZVPSphv8=
X-Google-Smtp-Source: ABdhPJxaPCod77YHjCMJtVQ4TqKDfVDSlfTU/H6e5uSeMsoXLnWnEuutJ+cCD0WdDIinQKs7VL8KioR3BtNsZg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1481:b0:43d:275b:7ba4 with SMTP
 id v1-20020a056a00148100b0043d275b7ba4mr7148929pfu.63.1632854896636; Tue, 28
 Sep 2021 11:48:16 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:48:00 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 06/10] KVM: arm64: selftests: Make vgic_init/vm_gic_create
 version agnostic
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make vm_gic_create GIC version agnostic in the vgic_init test. Also
add a nr_vcpus arg into it instead of defaulting to NR_VCPUS.

No functional change.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 896a29f2503d..b24067dbdac0 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -28,6 +28,7 @@
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
+	uint32_t gic_dev_type;
 };
 
 static int max_ipa_bits;
@@ -61,12 +62,13 @@ static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 	return 0;
 }
 
-static struct vm_gic vm_gic_v3_create(void)
+static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr_vcpus)
 {
 	struct vm_gic v;
 
-	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_dev_type = gic_dev_type;
+	v.vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
 
 	return v;
 }
@@ -153,6 +155,8 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	uint64_t addr, expected_addr;
 	int ret;
 
+	TEST_ASSERT(VGIC_DEV_IS_V3(v->gic_dev_type), "Only applies to v3");
+
 	ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
 	TEST_ASSERT(!ret, "Multiple redist regions advertised");
@@ -257,8 +261,7 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret, i;
 
-	v.vm = vm_create_default(0, 0, guest_code);
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -278,7 +281,7 @@ static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -295,7 +298,7 @@ static void test_v3_new_redist_regions(void)
 	uint64_t addr;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -306,7 +309,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step2 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
@@ -320,7 +323,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step 3 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-- 
2.33.0.685.g46640cef36-goog

