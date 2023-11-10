Return-Path: <kvm+bounces-1433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CC87E7747
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3F871C20D52
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB15C11CAF;
	Fri, 10 Nov 2023 02:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zc2J2ZH1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CED7111A0
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:14:00 +0000 (UTC)
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBE947AC
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:59 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-28035cf4306so2340596a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582439; x=1700187239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vea+L5qfDMmA4c3KSY8Nr6t7qY/kdDKuIJUR/t/IBFw=;
        b=Zc2J2ZH1qpKtA1YEdrNCiRvIMuwRxfoHgTwcPWn6GdAniCPnEFXZYuT+lylNfxezPY
         9s3YSiPHhGcQ4ml89co19KcXHbeAgivCWDg0V42e+8ALaRoB4bLnhtO3tj6Do2wjisCH
         ekq0B5+KGYHTY46WxDg7Luh6YXjCt/EU9h0mevUGGggziJxy0WbUTjSqy/vxY87TBXJZ
         vPrSasPQ9RaaoaI9Hq8S8/O3s4OejvdReeCRY6+hiRaxQZvBZo/MtsG0Ba26zyrXyLCe
         mFqvAHS8OnZfmEfulbl7ETTQpfbd0FFLpkqqkr2IOLf8VstII/0L5+bO5xrXQF/k+V8G
         RQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582439; x=1700187239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vea+L5qfDMmA4c3KSY8Nr6t7qY/kdDKuIJUR/t/IBFw=;
        b=O1NtE+4wish3YVqtcE6mM1O2Gh7y/QlOXvmzdzWxZh8q7Xwp7Cy47mQko2mYeMvQQS
         nrFPEejFp5vYNIdu6DwpQvPAuPrpmc0FwIV4oU2TvZh99NkCp0sOl1eKR0s178VZXi5A
         qQl5+SHXvI1fF5KYfpjaYCHqwjNzF1nllqXXyc+QBniQkVSHikbCsbqo+WYf309I8Jxr
         RMM6tpdxCsqLrMW20cK79Bp0DWzgR1Dr3HW3NgZ5B7ZN33wshkYO1lLTGtfpeaY2IsDH
         GU4jM0ZJ6hOHdMYsry5I2kCD5pedw56zLsrFY95l940UgZxLnkRoiXolso3p0Bmdtz1n
         QAtA==
X-Gm-Message-State: AOJu0Yzaf3s1JaO2/JfRU+A1L4JvtUz8Vq2xDAUS+u++JX+SYNEfBRdX
	iW78DH0g/kylXBTYrJesw2qc2j19fdQ=
X-Google-Smtp-Source: AGHT+IF3OotkCl6FE905DL9htCJEBRfunRVZHrs80Tufaz6gebQoWvA8TOLiX7DJdJKHSH61Ok0uqFxjCUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2291:b0:280:47ba:7685 with SMTP id
 kx17-20020a17090b229100b0028047ba7685mr339413pjb.0.1699582438954; Thu, 09 Nov
 2023 18:13:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:13:04 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-25-seanjc@google.com>
Subject: [PATCH v8 24/26] KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
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
index e5c383bd313b..e83b136ca15b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1153,16 +1153,19 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
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
 
@@ -1189,6 +1192,29 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
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
2.42.0.869.gea05f2083d-goog


