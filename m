Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94F51B252
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379108AbiEDWyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379391AbiEDWyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AA0E9F
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:15 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id ij27-20020a170902ab5b00b0015d41282214so1373394plb.9
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=B5xOiYq5DBAgzQjdMn5ipYvk589ia+w+WkBY20rzQmc=;
        b=nUNaJYl42mqq5KWNJAYDmh0gmn1fX1BTePbY6srWLqwQAgRp6OS/oxPmRSOYsFThO8
         c5wMjwlCzAp9MF3qDoPXvfGWJinG2mzE1fHjZ8067kAJxpvZKWHs6Rzp/EHUEwlE1ECA
         z52ulOecNiDYVg762aNPWZJEXiK0jN+NcVmbFoiTT9X2XMAxzUPJRgIg01gXchGVPFIX
         4Was4gWuiHvBG+jQVIP8NjjkJW5s7G+OpDYWBxf+lFtGDH9jPOis+7lKusYUekucGeqZ
         X1ogKVruKBsKYXr29EbskU5HaTBUgHtuRACiw530Qd9JENL+/SGYE9fkxru3lZ5RaYCY
         Qejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=B5xOiYq5DBAgzQjdMn5ipYvk589ia+w+WkBY20rzQmc=;
        b=d6O8wIl7tojWT2sbrqGSv6BwRsbkro/U7AYw15ABljK3zfknSOR61VeBcCffITq3ZH
         J2VAjgmg5y5t7ndOFLT6JppbPuzeAo4hYvbzCxSGso3//FG6/yQrxobCy3ZvDADi4NOg
         nNQc1xeRBpJkKtSPBT7It6cmO6thj83/JQDi8LCncqmoI2YPDKOyiNAiOAvSeZnP+qT4
         uzmOlYIXkU6hnrdhqHVUR6Q8w/Qh0gmLC3YY6BnjDRk0Ch0rCq8PBLK7oyOAqeVJe7eU
         RenrSlpkDFgf1zY8vlNepf+BvxCj3ABKMMqwydLDGbNu9N73PnI4UJnAAV7Et6iDcCl+
         z3KA==
X-Gm-Message-State: AOAM531wc32uTIbXIXHbwZNVJMzwzInKnDPNP1Mnph6zegAs/KpFIynb
        xZyv9L04zJMNynPRmQy2DVkfD7c3XVQ=
X-Google-Smtp-Source: ABdhPJy8HeUz1cbMyhSv1En5hiPh/kxB3sjVoxFOG+Pu+WFk0VXRYKu4kAKE49V8TJq6IlIkTpReR+LKBqw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1b0d:b0:1dc:672e:c913 with SMTP id
 nu13-20020a17090b1b0d00b001dc672ec913mr2228005pjb.102.1651704614650; Wed, 04
 May 2022 15:50:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:31 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-26-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 025/128] KVM: selftests: Rename KVM_HAS_DEVICE_ATTR helpers
 for consistency
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename kvm_device_check_attr() and its variants to kvm_has_device_attr()
to be consistent with the ioctl names and with other helpers in the KVM
selftests framework.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c      | 12 +++++-------
 tools/testing/selftests/kvm/include/kvm_util_base.h  |  6 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c           | 12 ++++++------
 .../selftests/kvm/system_counter_offset_test.c       |  2 +-
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 1015f6fc352c..223fef4c1f62 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -127,14 +127,12 @@ static void subtest_dist_rdist(struct vm_gic *v)
 						: gic_v2_dist_region;
 
 	/* Check existing group/attributes */
-	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			      dist.attr);
+	kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, dist.attr);
 
-	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			      rdist.attr);
+	kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, rdist.attr);
 
 	/* check non existing attribute */
-	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
+	ret = __kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
 	TEST_ASSERT(ret && errno == ENXIO, "attribute not supported");
 
 	/* misaligned DIST and REDIST address settings */
@@ -176,7 +174,7 @@ static void subtest_dist_rdist(struct vm_gic *v)
 				 rdist.attr, &addr, true);
 	TEST_ASSERT(ret && errno == EEXIST, "GIC redist base set again");
 
-	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+	ret = __kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
 	if (!ret) {
 		/* Attempt to mix legacy and new redistributor regions */
@@ -203,7 +201,7 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	uint64_t addr, expected_addr;
 	int ret;
 
-	ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+	ret = kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
 	TEST_ASSERT(!ret, "Multiple redist regions advertised");
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 1ccf44805fa0..66d896c8e19b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -482,8 +482,8 @@ void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
  */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 
-int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
-int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
+int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
+int kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
 int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
 int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
 int kvm_create_device(struct kvm_vm *vm, uint64_t type);
@@ -494,7 +494,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
 int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
 
-int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr);
 int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			 uint64_t attr);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 17e226107b65..ca313dc8b37a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1610,7 +1610,7 @@ void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg
  * Device Ioctl
  */
 
-int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
+int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
 {
 	struct kvm_device_attr attribute = {
 		.group = group,
@@ -1621,9 +1621,9 @@ int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 	return ioctl(dev_fd, KVM_HAS_DEVICE_ATTR, &attribute);
 }
 
-int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
+int kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
 {
-	int ret = _kvm_device_check_attr(dev_fd, group, attr);
+	int ret = __kvm_has_device_attr(dev_fd, group, attr);
 
 	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 	return ret;
@@ -1686,18 +1686,18 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 	return ret;
 }
 
-int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr)
 {
 	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
-	return _kvm_device_check_attr(vcpu->fd, group, attr);
+	return __kvm_has_device_attr(vcpu->fd, group, attr);
 }
 
 int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 				 uint64_t attr)
 {
-	int ret = _vcpu_has_device_attr(vm, vcpuid, group, attr);
+	int ret = __vcpu_has_device_attr(vm, vcpuid, group, attr);
 
 	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
 	return ret;
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index b337bbbfa41f..2b10c53abf4f 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -30,7 +30,7 @@ static struct test_case test_cases[] = {
 
 static void check_preconditions(struct kvm_vm *vm)
 {
-	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL, KVM_VCPU_TSC_OFFSET))
+	if (!__vcpu_has_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL, KVM_VCPU_TSC_OFFSET))
 		return;
 
 	print_skip("KVM_VCPU_TSC_OFFSET not supported; skipping test");
-- 
2.36.0.464.gb9c8b46e94-goog

