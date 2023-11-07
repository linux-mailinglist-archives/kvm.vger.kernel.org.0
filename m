Return-Path: <kvm+bounces-1076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA497E49B7
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9E162814E4
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE0A374D7;
	Tue,  7 Nov 2023 20:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KgtY7Hc1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41F9374CD
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:34 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B28510CA
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:34 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a8ee6a1801so83052817b3.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388434; x=1699993234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VURm3qKFEkUFzQoKppzRo3P8sq2mC6pF6UQMbNFBuGU=;
        b=KgtY7Hc1oR1IKD3YIs4ocfmTa/xrAbo/+8pa6KI10ma7iRKXBzrSMlERD/2faU1gVV
         3szArYmIUCyDB0/BgN0AX0PTMDZkXAnWq8INQoBpDfbHIb8lDZ9qpZpqQ3rAZvma1QVg
         Ni+WZh66Jle4uCms/DmqbmDexcnqf0tn6O94YnQwQy+789HOg843AbJ2M7VhWaoleZXm
         /TxRmNrHJwzvtVUonLlgwUZwxSLHo+q3/8uwnP6VnlyL4H/T7h6cmDSYOFYa7JunQ065
         7RtwfOJbNPbA1qxCJi2GbuNsT9kjXCj5vwbGYmdDIghSYiQVsChQ4IsuCYn5SZNTiIaA
         4lDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388434; x=1699993234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VURm3qKFEkUFzQoKppzRo3P8sq2mC6pF6UQMbNFBuGU=;
        b=ES1ECRfeFWhEWHev2CJIfE54FBup1vocyTNYY25A20LV6KX0oNTuN9ADOu2fomJAhF
         oJ+zLUzqj1lnUfGU8lRQe2ZlIlrZo0/vKR3yrN/7TW2gxHKpwK4BIDeAX/pOPWbnfIgi
         Op2Sl5AFFquuddw1nqWz3tPsxMQaz2Q/JEL1UXRsYogRpsQhmW3eKDChBqW9qW/NBboX
         X04aQ2MX2L8d1H/1uEvHW3lfKGtECI800FWrsZXLbHROHSzUK5wq359o0GqbX8nhIHNS
         7lnBKx1fEr5+lq6ALkuHSByRy8E/Zw/4UAWhmCWzY6NFIGbAygACwIIf0b9MVjBxpxUe
         lm7Q==
X-Gm-Message-State: AOJu0Yy1YO3cnZ1rlVKTaVL7fQ+FULEREw4I+JFF8BF2TwDThc9AtDGA
	EiymX8JmNhge1LJnFFUHjjAnnzYU1a0hM8P1FmFKwVYGhUP67A5rWKJRuZ4mz3dvNDmMAcbHk3f
	F4WGVPRdTPjzkJZJWOIACnvw2dpmxwM1J0B6UCU3PMOk7jg5Cs51UtIjD7S7IHeQ=
X-Google-Smtp-Source: AGHT+IFYlMTykIoHKWEWEDPriu/uKFKRlV6F2t2qSqzBMtA10UXuJ3YvEShZloxNkRDrWSf1n76Juc61Tk6I7w==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a0d:e24b:0:b0:59b:eb63:4beb with SMTP id
 l72-20020a0de24b000000b0059beb634bebmr282724ywe.7.1699388433543; Tue, 07 Nov
 2023 12:20:33 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:57 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-10-aghulati@google.com>
Subject: [RFC PATCH 09/14] KVM: x86: Move shared KVM state into VAC
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>, Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Venkatesh Srinivas <venkateshs@chromium.org>

Move kcpu_kick_mask and vm_running_vcpu* from arch neutral KVM code into
VAC.

TODO: Explain why this needs to be moved into VAC.

Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 virt/kvm/vac.c      | 5 +++++
 virt/kvm/vac.h      | 3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb50deaad3fd..575f044fd842 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -108,7 +108,6 @@ LIST_HEAD(vm_list);
 static struct kmem_cache *kvm_vcpu_cache;
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
-static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
 
 struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
@@ -150,7 +149,10 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
-static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+__weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+						   unsigned long start, unsigned long end)
+{
+}
 
 __weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
 {
diff --git a/virt/kvm/vac.c b/virt/kvm/vac.c
index ff034a53af50..c628afeb3d4b 100644
--- a/virt/kvm/vac.c
+++ b/virt/kvm/vac.c
@@ -6,6 +6,11 @@
 #include <linux/percpu.h>
 #include <linux/mutex.h>
 
+DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+EXPORT_SYMBOL(cpu_kick_mask);
+
+DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
+
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 DEFINE_MUTEX(vac_lock);
 
diff --git a/virt/kvm/vac.h b/virt/kvm/vac.h
index aed178a16bdb..f3e7b08168df 100644
--- a/virt/kvm/vac.h
+++ b/virt/kvm/vac.h
@@ -29,4 +29,7 @@ static inline void hardware_disable_all(void)
 }
 #endif /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 
+DECLARE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+DECLARE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
+
 #endif
-- 
2.42.0.869.gea05f2083d-goog


