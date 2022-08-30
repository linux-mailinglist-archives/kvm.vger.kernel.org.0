Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227BF5A7121
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 00:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiH3WwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 18:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiH3WwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 18:52:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4AD7694A
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:52:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f1-20020a170902ce8100b001731029cd6bso8666346plg.1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=URAHiYLmtg+Z3MrsGzcHN5w+hFulasNv1el++5Sk8ME=;
        b=q57kByUnqlRks+F8OXYQyfpUD9jtv+QVczUZ6wOmFSZ8w5Nae0oqqHL/qzNTbnRpKk
         GJpBRVR+QU2L3iEiyyQcFU27g8IduI4TMD44r/Ib946vdkjYx89nfN+trwKxONsPWWYY
         zFz3jPmnbP9BSP2G3lZLmfx/Rcwr8MuKUerJoVgnNlQMh+TmKhRBgIu+hECfN9oEU4dy
         BJNIigqiE33z53fJ66YN7rSr3hnsSPJycBSRBKKplfYpN8mNRDJc00X26Zguvl8Zulzy
         yWTbQfE28DM6TyxtVNxj5G7Hx0dI4keXteF1mgb7P19XTWx5dPO1pFl6dvseb598FU/9
         Woqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=URAHiYLmtg+Z3MrsGzcHN5w+hFulasNv1el++5Sk8ME=;
        b=fJQf1MiUiZiEjI0lSz0Js9mEgm2pfesG4emW7JwU5DyHKeIW1qfBAZfXnDyuH6vuXx
         62cXFd7kGUvOY2tgeJwzyaZyklXPo7OD+2ePmErdX3VIBszEF4wwUHlcBmnx/2kSIc+B
         vSuz/RsQL5oGZlbIcKJtEpurWNzpzFMILO16umIfJxKsKa4Kld7XL1E7EUpmy+7UeF9M
         PaaMMml2b/ztzTNqLdsJyK9fIhDss+O7b6FL9ZhytKXSO3fQ1CgiS6xYzSG1M/GhyD7u
         o8raMTHdlFxqCaedetYejQxGrrABlBQxA6WdAES4vO3QBSeIntx/TiB1V4m0aE/1U5L5
         KPaA==
X-Gm-Message-State: ACgBeo1pmsYtwEDVBcuewpNTgq4Gj1ofgzcDzoBZtYDIQ6Jn+eiKojbs
        90Jka9w9FXsdo4kIqq4UY1vbqED1hjg272MIn2UmiCk0p+/JpEaV4Vbvn8QJPVLKzD1UJCCfof5
        WsHMN0PyLk9zm0KmEV0nKaKZmkihcv6JVtVS44aXfjf8wrzqUkDvznbRvjDkeIUg=
X-Google-Smtp-Source: AA6agR4CjTgL/o2OlN427d9VG/6TpTn+PuUa3syR94OoXog6H4YLqP+44Tfc3wI2MpJoYsDtGTbzKssEFltEFg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:b692:b0:16f:87a0:ddbb with SMTP
 id c18-20020a170902b69200b0016f87a0ddbbmr22262172pls.35.1661899936937; Tue,
 30 Aug 2022 15:52:16 -0700 (PDT)
Date:   Tue, 30 Aug 2022 15:52:10 -0700
In-Reply-To: <20220830225210.2381310-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220830225210.2381310-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830225210.2381310-2-jmattson@google.com>
Subject: [PATCH v2 2/2] KVM: x86: Expose Predictive Store Forwarding Disable
 on Intel parts
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
index 07be45c5bb93..b5af9e451bef 100644
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
-		if (entry->eax == 1) {
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

