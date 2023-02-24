Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933C16A2457
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBXWhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBXWhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:07 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCB56F424
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:02 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so366836plh.8
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=98oyGAb7RcHKqjAwNAgyr6FZh3Kgxofbnet0C96SQlo=;
        b=ayxF4y7TQAo+UGt7rUOON3JjQmIAFE3tu/dbrAubdUMOL4J4yq7C6I3nnT866uqY2S
         60todAkVK8dh6tEm/ouX42F5P8iNnci0heFTv9Q2QCNNBNITFiEG7UQKDUCc+64ofXX+
         7cjGtB1Zoxct9+KUGoe3xeOl48wxhNQfeU+8aLKZOhyZTiYDPeDb+7nowADCgTQAJTdg
         jEmHgEIQTDvrbddlXX0rm7tSPCUNl0YeHpRlBlh/M33vIFGCDNFZq3o64h7ROrV2mcz+
         LdBeK4pP69SnY6m1D7V+lKi6qIb0eWcH7aT8sE5GedZSKaFhhLdbTDh8HtGbTCEgc9YB
         QW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=98oyGAb7RcHKqjAwNAgyr6FZh3Kgxofbnet0C96SQlo=;
        b=H9I+JkGp1px7bkrxxWpZ6APMGqXbKFilO/nCffBee6vD1T62Krs7Bs3pmI3u6r+UsS
         9DE769tJtkJMeeg4IYcRGIXXu25yM7zljfY/VSrNAkxRG11sUato4ufLumgpJ0Eo/kzm
         v8SdDHLfP+Z075/fFcaUPaM9D8aD++YHJ1VUmgh8txv8WFUB8sz+x8p00Ltr9hFdsPVA
         D/fivMZlOjwrLdnljvSDjs3WZxrN7bZVh8hdbBcrObaUL/rlatgay4EHFRa/aoHXzFJf
         YxrCaKtA/py3f6M3RdtFAMe2krQd6cc2+FvV0ShiBSOs5Kq5wFcCyYUuFSoV8+e9qWek
         l+jA==
X-Gm-Message-State: AO0yUKV/1Z8DeeV2ID/zKKY7bgTONYJGm7jciFUXj19O4qeWhUddRGb9
        IGNF+RAlnRTu8FUe6NNL/q1F+hggH1+i4vnJd8RssfG6OpUX7CwwNNWqhItdjY1VeOM1SQ7K/LP
        rvWl26lmM/+Dxp5PJkAWvmMUWu3M8hYDCvmC5eNA9cyAvy5aW1Wymidrm+fbSFdCDhqJ0
X-Google-Smtp-Source: AK7set8fvWLgVkhrrdgS/Nk2LrBhZ2ZOJqn3nvkF/akZTEMWMmIHvgy6dNDJm0TRJKYpuZkwc1Pkqy1D7IK8feXu
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:49ca:b0:231:1d90:7b1b with SMTP
 id l10-20020a17090a49ca00b002311d907b1bmr2302784pjm.2.1677278221945; Fri, 24
 Feb 2023 14:37:01 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:00 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-2-aaronlewis@google.com>
Subject: [PATCH v3 1/8] KVM: x86: Add kvm_permitted_xcr0()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
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

Add the helper, kvm_permitted_xcr0(), to make it easier to filter
the supported XCR0 before using it.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 7 ++++++-
 arch/x86/kvm/cpuid.h | 1 +
 arch/x86/kvm/x86.c   | 4 +---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8f8edeaf8177..e1165c196970 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -60,6 +60,11 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	return ret;
 }
 
+u64 kvm_permitted_xcr0(void)
+{
+	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+}
+
 /*
  * This one is tied to SSB in the user API, and not
  * visible in /proc/cpuinfo.
@@ -981,7 +986,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0xd: {
-		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+		u64 permitted_xcr0 = kvm_permitted_xcr0();
 		u64 permitted_xss = kvm_caps.supported_xss;
 
 		entry->eax &= permitted_xcr0;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..224c25e02748 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -33,6 +33,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool exact_only);
 
 u32 xstate_required_size(u64 xstate_bv, bool compacted);
+u64 kvm_permitted_xcr0(void);
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
 u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f706621c35b8..596b234fc100 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4519,9 +4519,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = 0;
 		break;
 	case KVM_CAP_XSAVE2: {
-		u64 guest_perm = xstate_get_guest_group_perm();
-
-		r = xstate_required_size(kvm_caps.supported_xcr0 & guest_perm, false);
+		r = xstate_required_size(kvm_permitted_xcr0(), false);
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
-- 
2.39.2.637.g21b0678d19-goog

