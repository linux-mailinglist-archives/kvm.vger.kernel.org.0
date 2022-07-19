Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63FD57AA95
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiGSXuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGSXuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:50:19 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7976222B5
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:18 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id j9-20020aa78009000000b0052b5ccdf6b8so2116936pfi.6
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lxeM6vO2F4cE69KMm+OUfNaRAkZ+4gn+w9GC88OjZ4s=;
        b=o+bh8roK+w9ayZyoe9MY9troUTKam3j0RLQPLnbDvPqeFGpBUL3Oex4vcaljiPDLUu
         iHaMjgqmmWKn5DKlZTaKG/sJk+4PCSAwt8fRD/9tlfr0XQBSyD1DMp+aJuoNKHMAAXtQ
         5FlCJsZtP1WQL+Of3aVaYWd90fKCBPaxo/RhsIEmRPbO+HoxGKT5VMQS0zWhnNfHYZHh
         b4LRJLSD3xuQNaY80JFL3rcAq4xBwu1jol6B8piD3Cs8EQ1pQBm/gh6N3xW9G88cOrY+
         VUvkdVfg+EYuQZs2K6UR0vwEPOMRkhrEfPPFV27ZVR0Fjvnx4QtdWe3jYMC8JUbzpsM6
         u1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lxeM6vO2F4cE69KMm+OUfNaRAkZ+4gn+w9GC88OjZ4s=;
        b=DmRzlaKAtBj2jlQh7xlT+yZ6I92eWcQejHT0s9pF6OESWx7Hd1PhpMiGW5Qrl28ds+
         FiRzZ2k/ck68He0FiSXhg9qcI+xsK2S40lWKmOBNqBI1mDHawFiQS5pnh9PFG3GKOWGA
         jrCYCJJZZvpPrAM6ZnNgopWZULNp76L4qiwC1Cr1AdWwmWlXM/BUAhxIJSjT7I2QQbyA
         tK26Q7IrxrUrjlRBn002Pxg1f0IUaBmsh7oIcX+zUaZ7CYVZyIRati2uX51SpNxRBdYn
         fnrXV5Mlc7GvBsKCq8qsOOZiUP7pWxQWyQfRlK4HezPGg9lhe57gY0r6rHYV5Rt5+S5H
         v7NQ==
X-Gm-Message-State: AJIora/W5d4l37KzhRjrV0czzljH7tDP7Svel8OKNWWcVhcCaEezd3Km
        cXZA+EuP37FEY9gsqEJkxJSc0eQQ+MeMJu+88tulgRmFrm6dNQ7gU62sW/uEG3Va+6wZWFzR0f2
        Fk64JIp2ycV+gZpapjD7KjZWOui9XvrMPpKg+n9NhP3zBA2WzY90uPyxP8aV+aH02kOnJ
X-Google-Smtp-Source: AGRyM1uDng+1UOzTDGGyaScdzThcOgLNA0gzlUYQteWO0uWccQZqHR9dTN39YWjQmZBQ15JRaiXh6YF3kIrY8f3/
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:22d6:b0:52b:343b:6dcf with
 SMTP id f22-20020a056a0022d600b0052b343b6dcfmr26897453pfj.54.1658274617822;
 Tue, 19 Jul 2022 16:50:17 -0700 (PDT)
Date:   Tue, 19 Jul 2022 23:49:49 +0000
In-Reply-To: <20220719234950.3612318-1-aaronlewis@google.com>
Message-Id: <20220719234950.3612318-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220719234950.3612318-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH v2 1/3] KVM: x86: Protect the unused bits in the MSR
 filtering / exiting flags
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The flags used in KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
have no protection for their unused bits.  Without protection, future
development for these features will be difficult.  Add the protection
needed to make it possible to extend these features in the future.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 6 ++++++
 include/uapi/linux/kvm.h        | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ee3896416c68..63691a4c62d0 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -224,6 +224,7 @@ struct kvm_msr_filter_range {
 struct kvm_msr_filter {
 #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
 #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+#define KVM_MSR_FILTER_VALID_MASK (KVM_MSR_FILTER_DEFAULT_DENY)
 	__u32 flags;
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 031678eff28e..adaec8d07a25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6171,6 +6171,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		break;
 	case KVM_CAP_X86_USER_SPACE_MSR:
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_MSR_EXIT_REASON_VALID_MASK)
+			break;
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
 		break;
@@ -6384,6 +6387,9 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
 		return -EFAULT;
 
+	if (filter.flags & ~KVM_MSR_FILTER_VALID_MASK)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
 		empty &= !filter.ranges[i].nmsrs;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a36e78710382..236b8e09eef1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -484,6 +484,9 @@ struct kvm_run {
 #define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
 #define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
 #define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
+#define KVM_MSR_EXIT_REASON_VALID_MASK	(KVM_MSR_EXIT_REASON_INVAL   |	\
+					 KVM_MSR_EXIT_REASON_UNKNOWN |	\
+					 KVM_MSR_EXIT_REASON_FILTER)
 			__u32 reason; /* kernel -> user */
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
-- 
2.37.1.359.gd136c6c3e2-goog

