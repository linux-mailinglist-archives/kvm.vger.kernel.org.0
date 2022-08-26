Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBABC5A30B9
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 23:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345030AbiHZVAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 17:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344803AbiHZVAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 17:00:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3519E1916
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:00:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b9-20020a170903228900b001730a0e11e5so1711843plh.19
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=h4rAinPFGMG5yc8vpdGKhK71xBVSYfag1nRdoNB2yBU=;
        b=fw5AHYzCT6Fwb0A6pieP7JFsZ5ZWGGTbe/IhWbwDDI33BOcorXXk9nAuHxGjE5bN3e
         oP4IpB1Bq5ilBwuJW59mCXp48Yzr8I6KV0l8KLIlfduAqZqY7LiizoqZktlG4uPIVHHR
         Iei4m7NelOBDQvSLR40H6BI7vNJZVXRRTlA6e9ZdkcH3lFr1DYNQKKLCoAt3FdVC4NOw
         n8YdvMvCd2NEeAI6uMvCa+PGH94iqbzjBrjiJMMDbYdlluieLLcJ+PynEmZDOc8zgyzG
         UhzxB8nXkI6IApNDnwqQp6pLOLfe1LulGW7Xbinh7Xg8Ac0k3xh5RdDBWgCgJ1H9xqT7
         TQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=h4rAinPFGMG5yc8vpdGKhK71xBVSYfag1nRdoNB2yBU=;
        b=R0EBJZOeA9V+fAoQqxvYelDiYErU+2fCniK1Y9XBnmPAzvs/Hzq90ZnMPIHYFc7v0l
         /LvLslUeIKJCjpU05HVq4G5fbRGptyY7Oaq9rRb6OkHyPDYTqf71mB1uNeWgtngGeCFq
         /j4ZXqHxp/R+7faJrhhSh7hq/Lt809nriPHIFDspVeUeK7lY/MDHkGvURLaRogUY0RBr
         7qZ8W60fAfDPXI5vUIWRixk3mYgZxVks3Fo8Q+4nk0XLSt25w9Qkf3onHNLNTCSfnxsa
         d0I1SrzXcdnvfuxJEDo6BqcoQsEA6GHu9eug0Le4DiTsT4mJxhhr8QwNoo04HLjIa0pX
         78SA==
X-Gm-Message-State: ACgBeo23/rf2aVqpRmX1uNbhjZCVLMLwkXu+2ZRW5jAHkGJOx3IT+zdX
        ElbVtjNccBJKhj39q/MnLDx89IQbSY9STpyob7lf18/lsBx1Qy+2l5BXS6kPpYhVR69j5wOAM9x
        DFnvnnzbJ/M9gn7QYh7IOzQvX1DS4OoJ4rY7DETaX6Wqtaj7C/0tgMlXGWnMEm/k=
X-Google-Smtp-Source: AA6agR6/e+urKTZ+3FN64BzLpnvKjtT2iG6+36Uu94+gTivqntR5dyHDZPaEl08dVcwYCJgslvHzAfTBkJstmA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:b08d:b0:172:e2f8:7f1f with SMTP
 id p13-20020a170902b08d00b00172e2f87f1fmr5039753plr.21.1661547631109; Fri, 26
 Aug 2022 14:00:31 -0700 (PDT)
Date:   Fri, 26 Aug 2022 14:00:19 -0700
In-Reply-To: <20220826210019.1211302-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220826210019.1211302-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826210019.1211302-3-jmattson@google.com>
Subject: [PATCH 3/3] KVM: x86: Expose Predictive Store Forwarding Disable on
 Intel parts
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
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

Intel enumerates support for PSFD in CPUID.(EAX=7,ECX=2):EDX.PSFD[bit
0]. Report support for this feature in KVM if it is available on the
host.

Presumably, this feature bit, like its AMD counterpart, is not welcome
in cpufeatures.h, so add a local definition of this feature in KVM.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 64cdabb3cb2c..b5af9e451bef 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -62,6 +62,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
  * This one is tied to SSB in the user API, and not
  * visible in /proc/cpuinfo.
  */
+#define KVM_X86_FEATURE_PSFD		0          /* Predictive Store Forwarding Disable */
 #define KVM_X86_FEATURE_AMD_PSFD	(13*32+28) /* Predictive Store Forwarding Disable */
 
 #define F feature_bit
@@ -677,9 +678,9 @@ void kvm_set_cpu_caps(void)
 	);
 
 	/*
-	 * AMD has separate bits for each SPEC_CTRL bit.
-	 * arch/x86/kernel/cpu/bugs.c is kind enough to
-	 * record that in cpufeatures so use them.
+	 * AMD has separate bits for each SPEC_CTRL bit.  Except for
+	 * PSFD, arch/x86/kernel/cpu/bugs.c is kind enough to record
+	 * that in cpufeatures so use them.
 	 */
 	if (boot_cpu_has(X86_FEATURE_IBPB))
 		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
@@ -880,13 +881,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	/* function 7 has additional index. */
 	case 7:
-		entry->eax = min(entry->eax, 1u);
+		/* KVM only supports leaf 7 indices 0 through 2. */
+		max_idx = entry->eax = min(entry->eax, 2u);
 		cpuid_entry_override(entry, CPUID_7_0_EBX);
 		cpuid_entry_override(entry, CPUID_7_ECX);
 		cpuid_entry_override(entry, CPUID_7_EDX);
 
-		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
-		if (entry->eax >= 1) {
+		if (max_idx >= 1) {
 			entry = do_host_cpuid(array, function, 1);
 			if (!entry)
 				goto out;
@@ -896,6 +897,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->ecx = 0;
 			entry->edx = 0;
 		}
+		if (max_idx >= 2) {
+			entry = do_host_cpuid(array, function, 2);
+			if (!entry)
+				goto out;
+
+			entry->eax = 0;
+			entry->ebx = 0;
+			entry->ecx = 0;
+			entry->edx &= BIT(KVM_X86_FEATURE_PSFD);
+		}
 		break;
 	case 9:
 		break;
-- 
2.37.2.672.g94769d06f0-goog

