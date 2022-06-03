Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7205A53C1A9
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240085AbiFCAon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240023AbiFCAoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:25 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA97633887
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 84-20020a630057000000b003f9caa5bccfso3047879pga.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9vC5gh1M6nD5/1rprbes9IFlVZ4jp452VtX7D5WkmNw=;
        b=JvyeroOccDHXG9qH1OYCI/jRxnh+VtCCeSdhT+IHI9yUeSI0MkuqsnOg3e63Frhdof
         V6SuFZASErceK75n4dDPSV3TecK4LvHNguu5Dt1AxUljBIxx87zdjz/TEg+mt6gyVO8F
         N8lHPHuE1Haheuz6WugEnFRtGMXAYMDKIUshxuIbOT0t75RIC4W15R5w3aV8/nriQPSC
         gC45gUhFhcdpp+mA7HD7grcw2lv/5VkTz9eAqRUN0GMSBqSXXMp6BgEnM7KZ9XlqmWq+
         GTCoP+6YiSgUvA7lmbdxYuKu53C2tDMsB8ZMsA4EXbo0Jrt1KxA8LywccH6YEX1WidKG
         Y/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9vC5gh1M6nD5/1rprbes9IFlVZ4jp452VtX7D5WkmNw=;
        b=4XK9OBiUEZX/+/6oDBGxR4UKbjFV322NxHBMgaD24CFuhYkP68NClVte3lq3hb6maL
         NDIRn+TL8LRsIUAEq2j8XL3XoJMJa3sfXialSGrS0fSWDl/bj6ch+W/gCsBrR+Sddaqt
         0p9jiSX39LNjTMi/xBlyEc9sYByPkoQxWT9azynTeu15C+85LJr6bQ/Bwa6TO/ftRSCY
         W5NIVQATEL2zt6w+cwq/5l1iadHT9FkuGycqxxwqGIcDekigFRmVzX3+UMvz8nzHBaYP
         6OdE6h4HTfn4dEHxTM+44cqLYtjCt9rspxqWiAQ/au8a0OK3eE8NCMnXBim5rNuRcefS
         LRfg==
X-Gm-Message-State: AOAM531kzKpwqQyi4wy/OYyWfLdjZT8/7VXiUDgNoNXxdRLBypTKIzHZ
        uqI0Ngs446rKaCNKpkYRpDBbbX/WPVg=
X-Google-Smtp-Source: ABdhPJxrU303zgyRmJxY67E2gV9NjsgMxPwY5MmE57xWheTepsXwRdoAgyzO6mRhv20bJJt8swxS99v7wG0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d502:b0:161:8e01:b4f1 with SMTP id
 b2-20020a170902d50200b001618e01b4f1mr7729793plg.137.1654217063385; Thu, 02
 Jun 2022 17:44:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:33 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-27-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 026/144] KVM: selftests: Rename KVM_HAS_DEVICE_ATTR helpers
 for consistency
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 4519ca2a48d1..3aecf097969a 100644
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
2.36.1.255.ge46751e96f-goog

