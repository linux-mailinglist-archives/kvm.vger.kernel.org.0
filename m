Return-Path: <kvm+bounces-1434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D87C47E7749
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15E971C20D21
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4243125B4;
	Fri, 10 Nov 2023 02:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CYAlUniJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF911CA1
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:14:02 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC2E47B3
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:14:01 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc252cbde2so15664365ad.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582441; x=1700187241; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eeEpHUJR4aSIdr4KeWYcEqsui8csxJQ9oememfgsBgo=;
        b=CYAlUniJJyd5oS9loxyK2HllttVfhxLg/R+cDtqV2F8Xz7Zjr3V9a1cP3XvlBVpa/y
         VPbzxG2Zi2heCHKRNSv5S87E6w/txUXRLx1+v0tlFxtCKHACOTAvS0TNbkVlaGtmshqT
         FSIg5hM6aI+DgPPbF8DuMm3iE+eC/763t0RF+gRA+lbTjAvSVYvBPdu+xiW6BjOaKAsy
         8Or5koy7lP7s4YHB5VDriaCoNE7IQsrzv4+XxRI1dZ/u8LuCCleiYmJ84u0T5O5L8yYL
         +83n2klE8doJwk2r0IixUxnQg/T2XhyJjYfxa2AsDaRuHFhpVH1MFbuktnpHcrfrYbmR
         dmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582441; x=1700187241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eeEpHUJR4aSIdr4KeWYcEqsui8csxJQ9oememfgsBgo=;
        b=PfZJVmdv72WYy7Id1uixNJGzS+xfVbIpWNpSBEZ/w9WiGHLQRP1+YZSMI09CTa4nCB
         2MZ2dTAguS6VhmNvxt9XQUnYfS+9548eqaL/wHMXhGVrh0Pu0MvGHkt2877mtbY8Ske7
         C1Pwu1vy+yGea3KggspxwXeAYo34NRXc4RfrZUTTmR5lHl4eM+u7sbygiCRQdgmUfgpX
         O1Mr8G9bA9X9V3D7ViNpH1AU65ixtjGDdIZ5TUNanKLnnnhr2ZF6Yz3JZn1/HYNwpi5n
         m7duF3mTF8/5F9nMdc93elE01qVfxV5OO7k1zL3FhnEeGjHB26g4BZrs+QhbUmwo8f9J
         vQ5Q==
X-Gm-Message-State: AOJu0YycGBPB/suuRhlarJUf6MKu4FTOjcOo7axXqbciRO6R+YMplPS3
	4VwiaVCSNGIVVstnGRGloZBzpXb88i0=
X-Google-Smtp-Source: AGHT+IGgeUlI1gIdhxbnrF8t5uag7i1+4BWQCrg9/FxqqTptdnxIjWrg8BCH+R9iQPV7aVv/lNp1lonHIGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:efc1:b0:1cc:2bd6:b54a with SMTP id
 ja1-20020a170902efc100b001cc2bd6b54amr926859plb.10.1699582440858; Thu, 09 Nov
 2023 18:14:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:13:05 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-26-seanjc@google.com>
Subject: [PATCH v8 25/26] KVM: selftests: Add helpers for safe and safe+forced
 RDMSR, RDPMC, and XGETBV
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add helpers for safe and safe-with-forced-emulations versions of RDMSR,
RDPMC, and XGETBV.  Use macro shenanigans to eliminate the rather large
amount of boilerplate needed to get values in and out of registers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 40 +++++++++++++------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e83b136ca15b..ba16d714b451 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1215,21 +1215,35 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	vector;								\
 })
 
-static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
-{
-	uint64_t error_code;
-	uint8_t vector;
-	uint32_t a, d;
-
-	asm volatile(KVM_ASM_SAFE("rdmsr")
-		     : "=a"(a), "=d"(d), KVM_ASM_SAFE_OUTPUTS(vector, error_code)
-		     : "c"(msr)
-		     : KVM_ASM_SAFE_CLOBBERS);
-
-	*val = (uint64_t)a | ((uint64_t)d << 32);
-	return vector;
+#define BUILD_READ_U64_SAFE_HELPER(insn, _fep, _FEP)			\
+static inline uint8_t insn##_safe ##_fep(uint32_t idx, uint64_t *val)	\
+{									\
+	uint64_t error_code;						\
+	uint8_t vector;							\
+	uint32_t a, d;							\
+									\
+	asm volatile(KVM_ASM_SAFE##_FEP(#insn)				\
+		     : "=a"(a), "=d"(d),				\
+		       KVM_ASM_SAFE_OUTPUTS(vector, error_code)		\
+		     : "c"(idx)						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+									\
+	*val = (uint64_t)a | ((uint64_t)d << 32);			\
+	return vector;							\
 }
 
+/*
+ * Generate {insn}_safe() and {insn}_safe_fep() helpers for instructions that
+ * use ECX as in input index, and EDX:EAX as a 64-bit output.
+ */
+#define BUILD_READ_U64_SAFE_HELPERS(insn)				\
+	BUILD_READ_U64_SAFE_HELPER(insn, , )				\
+	BUILD_READ_U64_SAFE_HELPER(insn, _fep, _FEP)			\
+
+BUILD_READ_U64_SAFE_HELPERS(rdmsr)
+BUILD_READ_U64_SAFE_HELPERS(rdpmc)
+BUILD_READ_U64_SAFE_HELPERS(xgetbv)
+
 static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 {
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
-- 
2.42.0.869.gea05f2083d-goog


