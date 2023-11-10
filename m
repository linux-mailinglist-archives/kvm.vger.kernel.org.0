Return-Path: <kvm+bounces-1431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4A57E7742
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:15:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9526C281369
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6116B11187;
	Fri, 10 Nov 2023 02:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jgep/4ES"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A012B10959
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:56 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032924794
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:56 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da1aa98ec19so1952450276.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582435; x=1700187235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4fLduEULj/w/qTyuS7dxoyFHFX9Y3I4W7nZGJLTTI/Q=;
        b=jgep/4ESbx2q//xdJmZN0gH1c4O22bP02/cTi8dnKfkpKYV8DgjNvSJnJDFNu3j8Qf
         w/5naJFyjdrLyMXcYWgljl9FFuYDXFQX9LI2ccxn7AZBrf8zg+COLqsvZ2uTO4lpyCse
         D3+quN+0QtGsHXcT1R4mkwTa4B5nVNv/PX1W5v27bnObsDj66xIQbqe7vxPIVWHzsKVd
         l2Ewf9qfRoMRuZXJMKS10WQs5JV6nL3a2m5RPb1qpLq4/Vury2TjCKEadpHtNFrq0nhK
         p96mi6TsL210Z2AoseEfw9vNdXvMJiddN6PsCvVr8M2QqjEkG7Jdvg9YJaQ80icJVKZ6
         M3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582435; x=1700187235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4fLduEULj/w/qTyuS7dxoyFHFX9Y3I4W7nZGJLTTI/Q=;
        b=p/cPLvmCosYxfX7t/J1yuGUJ/MxHDyXEpVApFJh5uyloYW9gmhCSZEaFLP9n7HpqG7
         btQuF+2Agq8c4m6qTIvZ0CjguNzoo4kTYRJBedKcvjxvA5TNRwv4jQez2P+483lMg1U8
         fxtamYzr67RPn0KG9yRM+eC3Yd4M9YCQeDJ4r6eFtpMCZoyNoxbUMximMuMpNAN1UZUW
         nFbA3aZT/Vgi70afOd+yDOLhkPoetBcbNdR1+XihV02Mgvf6JNEw6QDhyFK2bwjY6XtH
         rh/nW7ZxjYSQ2yL5mTbjYN1FovomKdiEHrpEz8Qhx7LhzGq29j1V0PGaizjWth4Q5/XO
         xcmw==
X-Gm-Message-State: AOJu0Yy4uJ+3it+OZn3/OojOJ8DYf4RzUjPtLfKxcbxWafcg27Ib75Z1
	uSaJN08Z+VZnvM5dxghaQ6VbL+NwUMk=
X-Google-Smtp-Source: AGHT+IFCCj3dYYPcyP4RKhTRYyIWOxqoaA83nLmEG6oKXFSqAV/Q/a0CLt7ZXM5r6z/FPR+5hNdBQ+VpRRE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d689:0:b0:da0:622b:553b with SMTP id
 n131-20020a25d689000000b00da0622b553bmr185399ybg.12.1699582435282; Thu, 09
 Nov 2023 18:13:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:13:02 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-23-seanjc@google.com>
Subject: [PATCH v8 22/26] KVM: selftests: Move KVM_FEP macro into common
 library header
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Move the KVM_FEP definition, a.k.a. the KVM force emulation prefix, into
processor.h so that it can be used for other tests besides the MSR filter
test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h       | 3 +++
 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8a404faafb21..e5c383bd313b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -22,6 +22,9 @@
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 
+/* Forced emulation prefix, used to invoke the emulator unconditionally. */
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+
 #define NMI_VECTOR		0x02
 
 #define X86_EFLAGS_FIXED	 (1u << 1)
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 9e12dbc47a72..ab3a8c4f0b86 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -12,8 +12,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-/* Forced emulation prefix, used to invoke the emulator unconditionally. */
-#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 static bool fep_available;
 
 #define MSR_NON_EXISTENT 0x474f4f00
-- 
2.42.0.869.gea05f2083d-goog


