Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4381E640C7C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiLBRqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiLBRpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:38 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F87EE11A8
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:29 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id m17-20020a05600c3b1100b003cf9cc47da5so2814633wms.9
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E8eIZIOTFSHtVkJmIkwiyFF0y+C+tlZXEXKV5fvsuno=;
        b=e9IDouXfpTSkQYjuCbbtIpfmVCcJv2mfFjBsCaTFMY2rJ1DQ2hi2x0fIqQ2elNTiyB
         pUlHDS+JKUSi/Vm0DFiAxYXG3fsenCKqexBcelDVa30jqI9+qj8OKQU2yHhMiidMkHqm
         gYCoRL529tXldEogvFsy1B0noHa+7QuRTcAWJQoSvoxSw0E8uv50c1a5Do8JVeSD71Ol
         FuI1dsFPEAuxQ0kfhyyA8UdbAuB3mhIMZuByaRg4s7gmjcMIp5IFCLargQE5zgSWUnPx
         pQ98756rH/drzw94itOfVVKS5+mTkjH/7RhC6XYCJt8FcxK/EQ5NB6KZgfKEOncItEAb
         DZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8eIZIOTFSHtVkJmIkwiyFF0y+C+tlZXEXKV5fvsuno=;
        b=fWAZv1O+Yqv12UUxaiIe/THAuwUPoGz9anFClH6EryBp+kmDw4FaDWoqe+FyUHnNnW
         K24072pXVgwm69R9T6CTHJSv2Kflli8pADkjOJVeYeH5E/PjJY5e2o49jV01I7sRfDDE
         8EfponI9canVKMHWP9dlP+6tKZUgPOwoZfN9zkXQpd5Iv9zg8gVr0x1sYDQHUWP+A3rs
         +00xdEikkdItoyvG6ne+Kt1bpHc+7fzarrU0Gw4q+bkVJ9PnLtwBzddTKj0UgQGQ8vVC
         e18ww9CmMTOLOVcJAGtMvW3SQPvVHQFSwKY+UweGeebKnlvnuyDe4OsAK1chUfzm/4vR
         BiJQ==
X-Gm-Message-State: ANoB5plwYADhXkBjWgf8D8fF40hoWuxr4tIPOX2I0/zm21s8q6BxbVyP
        te+AWav5wQdf3iRkdUMA/EqP9w34r7oLAorlFvkSBO28qiaR/juE8SI0aqPYpamqzDDjY04jTyn
        8Ql3TO3VSt++2vVttTH/0y8kkv7yBuC+QLDYKhXqDhzXp3T01Yt9QTR0=
X-Google-Smtp-Source: AA0mqf6EfJKf1MWAukgvlsb+btHTzUv18ftmQpzYMrFJoz6A8kUp8+8aFS5J6TlwV1nafBlAQitb0lfaDQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4d07:b0:3cf:8108:de64 with SMTP id
 u7-20020a05600c4d0700b003cf8108de64mr39606262wmp.139.1670003122986; Fri, 02
 Dec 2022 09:45:22 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:15 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-31-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 30/32] pkvm: Enable exit hypercall capability
 if supported
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This hypercall allows the guest to communicate with the host via
the new exit type. It will be used in future patches to
communicate guest-triggered change of memory sharing status with
the host/vmm (kvmtool).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/aarch32/include/kvm/kvm-arch.h |  1 +
 arm/aarch64/include/kvm/kvm-arch.h |  1 +
 arm/aarch64/kvm.c                  | 23 +++++++++++++++++++++++
 arm/kvm-cpu.c                      | 10 ++++++++++
 arm/kvm.c                          |  1 +
 5 files changed, 36 insertions(+)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index 467fb09..5666f2f 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -7,6 +7,7 @@
 
 struct kvm;
 static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
+static inline void kvm__arch_enable_exit_hypcall(struct kvm *kvm) {}
 
 #define MAX_PAGE_SIZE	SZ_4K
 
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 02d09a4..9af002b 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -7,6 +7,7 @@ struct kvm;
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
 void kvm__arch_enable_mte(struct kvm *kvm);
+void kvm__arch_enable_exit_hypcall(struct kvm *kvm);
 
 #define MAX_PAGE_SIZE	SZ_64K
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index f65c9c1..604a5e8 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -163,3 +163,26 @@ void kvm__arch_enable_mte(struct kvm *kvm)
 
 	pr_debug("MTE capability enabled");
 }
+
+void kvm__arch_enable_exit_hypcall(struct kvm *kvm)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_EXIT_HYPERCALL,
+		.args[0] = KVM_EXIT_HYPERCALL_VALID_MASK,
+	};
+
+	if (kvm->cfg.arch.aarch32_guest) {
+		pr_debug("EXIT HYPERCALL is incompatible with AArch32");
+		return;
+	}
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_EXIT_HYPERCALL)) {
+		pr_debug("EXIT HYPERCALL capability not available");
+		return;
+	}
+
+	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &cap))
+		die_perror("KVM_ENABLE_CAP(KVM_CAP_EXIT_HYPERCALL)");
+
+	pr_debug("EXIT capability enabled");
+}
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 98bc5fd..cb5a92a 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -146,6 +146,16 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 {
+	switch (vcpu->kvm_run->exit_reason) {
+	case KVM_EXIT_HYPERCALL:
+		pr_warning("Unhandled exit hypercall: 0x%llx, 0x%llx, 0x%llx, 0x%llx",
+			   vcpu->kvm_run->hypercall.nr,
+			   vcpu->kvm_run->hypercall.ret,
+			   vcpu->kvm_run->hypercall.args[0],
+			   vcpu->kvm_run->hypercall.args[1]);
+		return true;
+	}
+
 	return false;
 }
 
diff --git a/arm/kvm.c b/arm/kvm.c
index 094fbe4..f4b0247 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -84,6 +84,7 @@ void kvm__arch_init(struct kvm *kvm)
 		die("Failed to create virtual GIC");
 
 	kvm__arch_enable_mte(kvm);
+	kvm__arch_enable_exit_hypcall(kvm);
 }
 
 #define FDT_ALIGN	SZ_2M
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

