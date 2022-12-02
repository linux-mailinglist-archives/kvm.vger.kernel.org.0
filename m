Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E57640C7E
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiLBRqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbiLBRpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:39 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71802E11A9
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:29 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id y5-20020adfc7c5000000b002423fada7deso955991wrg.7
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=60bGsGvOuzsAih8loS2U41EM+pg36WcOg61x1u2LkyQ=;
        b=Ovbm1Hb3f/ASfmn+WumjbavCzzHTtBiZofkBBePxPlJxJyyxIlfAq+Mzai0/UNbX98
         AnC7prbH5HtdL42CqBpJjPAGcxD2LI5i9kAImE/EWvW1GbKVXHossexjArNDMAdpN8Ro
         /pWXbmXVfGK21oCa55ulT70CsJ9vPSFEDAkk5IC+fDfGLt2ZvjW7BlzoP+WzWCW7QKw3
         RqcJc5xaupsH/cyBm/ZOGZ7TxInLkYNgP0EonJPh0LCGndBLcjcejap55MA6fRXEgzoe
         OvjxnPUSnPGMTPpPGzPb+nOXUPupa6LPPRvvetLqYqlIEpuT+37sLlwXR2nRvWtAYlu1
         gjLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60bGsGvOuzsAih8loS2U41EM+pg36WcOg61x1u2LkyQ=;
        b=npJajxbuMITdOixJq/h8H0Csyve90m0mlcUd0Pd2MGFY8Lqxf472X9tcURCTrsyNBH
         a7GGN3qHft0S2oO6HJ6/lGbgpyB8bZTE55djr8YZS66FqT851+uv8JlOUdgtmMcwniUK
         CH8gt3LMOWS/sRHGGzYGGvYe1lmrLyi2a7CL5r132SjA1jb0ZxzmMsSxl9AsaD7mw72b
         PxNhcfgPovvj0I1pNSzuZpLRnW3H66t+sDsCSCwXORq5VRXr9SQiQHo8aj6bcQ1EYPfY
         cv8uIOGqbUrKuoRi3feFZcH1y2VRhbMluwbv+QbshM91phXKxR41sIPL98yhQWhcKTAE
         onTg==
X-Gm-Message-State: ANoB5pmeWYdXVhEz53Iw5ZoH2uN645NtViAc1cE2VdBFbpkEUFp4k4YB
        JAdtJVxcuNH0IJYvF8j1BYEcS0Wgc/7KiKB1dITG4/wS5nxcLOerS0OCuO8xl7T4CYKIq1iP9gW
        FERwi2PSSD0UBkekXXLvmjsThAqwCkhzTGoSB5LZPLdKmvuKzcG4Pbzk=
X-Google-Smtp-Source: AA0mqf5CaEwzOsRkM2CW3GffNOmQ6eWQhWvm6e5oD6mwACVptAW1KgmpZ2jE6v0xc6Hwqs8d+2isyxuHEg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:a4a:b0:3cf:e138:cd80 with SMTP id
 c10-20020a05600c0a4a00b003cfe138cd80mr41264459wmq.78.1670003125248; Fri, 02
 Dec 2022 09:45:25 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:16 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-32-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 31/32] pkvm: Handle (un)share hypercalls coming
 from the guest
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

(Un)map guest memory if it's sharing status changes.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/aarch64/include/asm/kvm.h |  7 +++++
 arm/kvm-cpu.c                 | 58 ++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 316917b..662c178 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -467,6 +467,13 @@ enum {
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
+#define ARM_SMCCC_KVM_FUNC_MEM_SHARE		3
+#define ARM_SMCCC_KVM_FUNC_MEM_UNSHARE		4
+
+#define KVM_EXIT_HYPERCALL_VALID_MASK	((1ULL << ARM_SMCCC_KVM_FUNC_MEM_SHARE) |	\
+					 (1ULL << ARM_SMCCC_KVM_FUNC_MEM_UNSHARE))
+
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index cb5a92a..fcefec8 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -144,16 +144,64 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 	free(vcpu);
 }
 
-bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
+static bool handle_mem_share(struct kvm_cpu *vcpu)
 {
-	switch (vcpu->kvm_run->exit_reason) {
-	case KVM_EXIT_HYPERCALL:
-		pr_warning("Unhandled exit hypercall: 0x%llx, 0x%llx, 0x%llx, 0x%llx",
+	u64 gpa = vcpu->kvm_run->hypercall.args[0];
+
+	if (!vcpu->kvm->cfg.pkvm) {
+		pr_warning("%s: non-protected guest memshare request for gpa 0x%llx",
+			   __func__, gpa);
+		return true;
+	}
+
+	map_guest_range(vcpu->kvm, gpa, PAGE_SIZE);
+
+	return true;
+}
+
+static bool handle_mem_unshare(struct kvm_cpu *vcpu)
+{
+	u64 gpa = vcpu->kvm_run->hypercall.args[0];
+
+	if (!vcpu->kvm->cfg.pkvm) {
+		pr_warning("%s: non-protected guest memunshare request for gpa 0x%llx",
+			   __func__, gpa);
+		return true;
+	}
+
+	unmap_guest_range(vcpu->kvm, gpa, PAGE_SIZE);
+
+	return true;
+}
+
+static bool handle_hypercall(struct kvm_cpu *vcpu)
+{
+	u64 call_nr = vcpu->kvm_run->hypercall.nr;
+
+	switch (call_nr)
+	{
+	case ARM_SMCCC_KVM_FUNC_MEM_SHARE:
+		return handle_mem_share(vcpu);
+	case ARM_SMCCC_KVM_FUNC_MEM_UNSHARE:
+		return handle_mem_unshare(vcpu);
+	default:
+		pr_warning("%s: Unhandled exit hypercall: 0x%llx, 0x%llx, 0x%llx, 0x%llx",
+			   __func__,
 			   vcpu->kvm_run->hypercall.nr,
 			   vcpu->kvm_run->hypercall.ret,
 			   vcpu->kvm_run->hypercall.args[0],
 			   vcpu->kvm_run->hypercall.args[1]);
-		return true;
+		break;
+	}
+
+	return true;
+}
+
+bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
+{
+	switch (vcpu->kvm_run->exit_reason) {
+	case KVM_EXIT_HYPERCALL:
+		return handle_hypercall(vcpu);
 	}
 
 	return false;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

