Return-Path: <kvm+bounces-1074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8107E49B3
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A492D2813E3
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3CB3717C;
	Tue,  7 Nov 2023 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EBCKaE9l"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5673037157
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:29 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F054E1710
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:28 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7af53bde4so82825307b3.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388428; x=1699993228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zwz/DX5/0PSQdls3zWf864vgsuhHF2nqgARPPlW8Wak=;
        b=EBCKaE9lyd7KS5tGr0R8hozcNPyXxeYYqOl1nLYpOihopsV83AhYOO10Ym7yUjVCNj
         aC0IPs0z01PZtdgxtSsNui2D5dXQ69t5px7kUzejNzttdUhZD0D6D5UbnCXLcrWd5xuD
         bfSZgqnw3RUmpGtXEybBfkxqYm+7Wk3xKyHIVmok97hRwtjyu3ErZjvt5zi19LmjfZmx
         V/FJoMKCpEz2L9a6S8oZwaiIXoZZ5ZNgjOkifr0MIvv2ySDFA7p7SV1sSRAOnYL0HZuV
         hzHNpx/SCIfqbCG26heBnFBv9FvVMTdqgn7XkrM72IjLf4NJ1MvJIy0wuMao4Mu4sK0h
         gn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388428; x=1699993228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwz/DX5/0PSQdls3zWf864vgsuhHF2nqgARPPlW8Wak=;
        b=VOE2vnszhvf5f9EszH/dK/8FtVjDqgDNw8dS8xHjqo33g/l2GPGk98JCwofc1/SxCx
         pd3yIcfp130kwdta6U7ZBn62e0MgKS5Zi41VP1XtF4BsmiMHjZ8YfOLH1IY7NN1G9lMe
         GlpQNzrR3zbeaxiMeg+QPzpMcljfFhkwyGQ37sRmahFMTIy5IkorPXL3ev6KJ0a6qj+U
         ja29SK7r6IjwBWPCG3QIQadtXxspds7APdQJiOpA1ZQ4XFxklPoV2L9uLdnhH1th5fiX
         YNgvFUx0KuiwWk7RTo5aGQZZd2vW7qRe5XROGBrW4HKhCUEtOkCib7yBvzwhrs1vN7or
         a2PQ==
X-Gm-Message-State: AOJu0YzJgCQ5DiIm2D06QVe2QZQYR2+QMalLvLmatMi2mS0iGLbjS2hI
	6ogSdbSdzfsZLv4aC48SpYd9o91eTWPNQAvyBSv2l5lroPWV1SNmaoSn3/nd5Dp6UtNKkKvxgku
	LcMN/pfjPAoPQ//YRmZLh4S7mqaJ1Ovhv0PUewqZw3sjO9ZfEV83rIapbrgPtOHw=
X-Google-Smtp-Source: AGHT+IE6r0sMd4kiFjw74n4jFrPY3A6ZLSngl/1kFEoTU04Ea3WGhGaUk1oh3I8bkSM8wWmAUocFK/sAzUMi/w==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a81:4ec2:0:b0:5a8:3f07:ddd6 with SMTP id
 c185-20020a814ec2000000b005a83f07ddd6mr284468ywb.6.1699388427125; Tue, 07 Nov
 2023 12:20:27 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:55 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-8-aghulati@google.com>
Subject: [RFC PATCH 07/14] KVM: SVM: Move shared SVM data structures into VAC
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Move svm_cpu_data into VAC.

TODO: Explain why this data should be shared between KVMs and should be
made global by moving it into VAC.

Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/svm/svm.c |  9 ++++++++-
 arch/x86/kvm/svm/svm.h | 16 +---------------
 arch/x86/kvm/svm/vac.c |  5 +++++
 arch/x86/kvm/svm/vac.h | 23 +++++++++++++++++++++++
 4 files changed, 37 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/kvm/svm/vac.h

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f0a5cc43c023..d53808d8ec37 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -234,7 +234,14 @@ static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static unsigned long iopm_base;
 
-DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
+struct kvm_ldttss_desc {
+	u16 limit0;
+	u16 base0;
+	unsigned base1:8, type:5, dpl:2, p:1;
+	unsigned limit1:4, zero0:3, g:1, base2:8;
+	u32 base3;
+	u32 zero1;
+} __attribute__((packed));
 
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 436632706848..7fc652b1b92d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -24,6 +24,7 @@
 
 #include "cpuid.h"
 #include "kvm_cache_regs.h"
+#include "vac.h"
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
@@ -291,21 +292,6 @@ struct vcpu_svm {
 	bool guest_gif;
 };
 
-struct svm_cpu_data {
-	u64 asid_generation;
-	u32 max_asid;
-	u32 next_asid;
-	u32 min_asid;
-
-	struct page *save_area;
-	unsigned long save_area_pa;
-
-	struct vmcb *current_vmcb;
-
-	/* index = sev_asid, value = vmcb pointer */
-	struct vmcb **sev_vmcbs;
-};
-
 DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
 
 void recalc_intercepts(struct vcpu_svm *svm);
diff --git a/arch/x86/kvm/svm/vac.c b/arch/x86/kvm/svm/vac.c
index 4aabf16d2fc0..3e79279c6b34 100644
--- a/arch/x86/kvm/svm/vac.c
+++ b/arch/x86/kvm/svm/vac.c
@@ -1,2 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/percpu-defs.h>
+
+#include "vac.h"
+
+DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
diff --git a/arch/x86/kvm/svm/vac.h b/arch/x86/kvm/svm/vac.h
new file mode 100644
index 000000000000..2d42e4472703
--- /dev/null
+++ b/arch/x86/kvm/svm/vac.h
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+#ifndef ARCH_X86_KVM_SVM_VAC_H
+#define ARCH_X86_KVM_SVM_VAC_H
+
+#include "../vac.h"
+
+struct svm_cpu_data {
+	u64 asid_generation;
+	u32 max_asid;
+	u32 next_asid;
+	u32 min_asid;
+
+	struct page *save_area;
+	unsigned long save_area_pa;
+
+	struct vmcb *current_vmcb;
+
+	/* index = sev_asid, value = vmcb pointer */
+	struct vmcb **sev_vmcbs;
+};
+
+#endif // ARCH_X86_KVM_SVM_VAC_H
-- 
2.42.0.869.gea05f2083d-goog


