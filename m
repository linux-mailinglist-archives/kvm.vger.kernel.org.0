Return-Path: <kvm+bounces-5946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 718778290A5
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:13:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AE931F25838
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AA94CE00;
	Tue,  9 Jan 2024 23:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lg7IKhNr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624694CB2E
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6db0c931f7cso1014034b3a.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841426; x=1705446226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wANFkcf3/mrpI/C7ga3lU3ObqtiYxLFAZO6wmonones=;
        b=lg7IKhNrHY24Mgh2hctYvI6Ypg71cSimjNs3TvcS6+rjsXm88VyScerW2kH/N6VBqn
         ZUmd582XcPsjj3UJXgKTTz6nMF5v8JxCHeeTixL53nYdhPCsao+dH7m2GWxfAq3toM/+
         1A/lQRoXRkVyBeYlctbKMkQY9N4TIYnU3Suh5xOoxxrvv4ZeeLvR5kawqZQxNwtOeC39
         LL+M1cBpLboUR16ZtVhD+SWckFLSr6XKvjHaGW2AZ/W80PrfxCEJqyTN/CSC/MzV2YzC
         ueFPsisdoZtqYjYEBGKFMO3PaAP9JAYMlZmWqTp/GcfCb1gYIdtXSEAFI8Hif50JNyoO
         Xkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841426; x=1705446226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wANFkcf3/mrpI/C7ga3lU3ObqtiYxLFAZO6wmonones=;
        b=Z+N25kE+PAejdsTPQg2fEbR2LdzL6kTH9H6yMiDk3FHRZcDz9Z6MLX9QkeTeGe4svc
         NlyY1Pon5XM9Pb/7fKB8YCnSNf8op6koRI6C52Zmb598V3Ham+tB6mRQDuTM+5IkAUzL
         rKFkVUlAsNNRSiSMSoOhdN5ygUuqD66ux4EpUc40UlYB9npE6TpdbzWCEyRmMxputV5+
         /96CBGJAyvp6vngUgJuTahxYDcOXtNyH9EfXPCSxK+HAtrnFE0YP9dLQzXqNZY9xTmGK
         8YigvZIJWwejdPYQXVFPmwygP4IZzsni9Fb/Dqh/Zqzg0kHYzOtckImrIO4Q9B9Yh56y
         yV7A==
X-Gm-Message-State: AOJu0Yy/i1KVaKd3RKTNTXAzfaJqx1wRs1sjnlJllXFIFQjJ31gYTR2U
	ZdcoHX8yHcJjFu+3fTvhNRRE2IqyhR55aibDaQ==
X-Google-Smtp-Source: AGHT+IFSSOuKmnwGFSF6cWXqEiHbC+sn8cv2NT2Xn9cD3EODS/1ni7aYjWy/ewfqyaN7X8YdGXdI5Xw5CUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1896:b0:6da:bf5b:bd4e with SMTP id
 x22-20020a056a00189600b006dabf5bbd4emr27897pfh.3.1704841426743; Tue, 09 Jan
 2024 15:03:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:47 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-28-seanjc@google.com>
Subject: [PATCH v10 27/29] KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add KVM_ASM_SAFE_FEP() to allow forcing emulation on an instruction that
might fault.  Note, KVM skips RIP past the FEP prefix before injecting an
exception, i.e. the fixup needs to be on the instruction itself.  Do not
check for FEP support, that is firmly the responsibility of whatever code
wants to use KVM_ASM_SAFE_FEP().

Sadly, chaining variadic arguments that contain commas doesn't work, thus
the unfortunate amount of copy+paste.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 30 +++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6be365ac2a85..fe891424ff55 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1154,16 +1154,19 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
  * r9  = exception vector (non-zero)
  * r10 = error code
  */
-#define KVM_ASM_SAFE(insn)					\
+#define __KVM_ASM_SAFE(insn, fep)				\
 	"mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"	\
 	"lea 1f(%%rip), %%r10\n\t"				\
 	"lea 2f(%%rip), %%r11\n\t"				\
-	"1: " insn "\n\t"					\
+	fep "1: " insn "\n\t"					\
 	"xor %%r9, %%r9\n\t"					\
 	"2:\n\t"						\
 	"mov  %%r9b, %[vector]\n\t"				\
 	"mov  %%r10, %[error_code]\n\t"
 
+#define KVM_ASM_SAFE(insn) __KVM_ASM_SAFE(insn, "")
+#define KVM_ASM_SAFE_FEP(insn) __KVM_ASM_SAFE(insn, KVM_FEP)
+
 #define KVM_ASM_SAFE_OUTPUTS(v, ec)	[vector] "=qm"(v), [error_code] "=rm"(ec)
 #define KVM_ASM_SAFE_CLOBBERS	"r9", "r10", "r11"
 
@@ -1190,6 +1193,29 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	vector;								\
 })
 
+#define kvm_asm_safe_fep(insn, inputs...)				\
+({									\
+	uint64_t ign_error_code;					\
+	uint8_t vector;							\
+									\
+	asm volatile(KVM_ASM_SAFE(insn)					\
+		     : KVM_ASM_SAFE_OUTPUTS(vector, ign_error_code)	\
+		     : inputs						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+	vector;								\
+})
+
+#define kvm_asm_safe_ec_fep(insn, error_code, inputs...)		\
+({									\
+	uint8_t vector;							\
+									\
+	asm volatile(KVM_ASM_SAFE_FEP(insn)				\
+		     : KVM_ASM_SAFE_OUTPUTS(vector, error_code)		\
+		     : inputs						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+	vector;								\
+})
+
 static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
 {
 	uint64_t error_code;
-- 
2.43.0.472.g3155946c3a-goog


