Return-Path: <kvm+bounces-3783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8B6807CC9
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 01:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 791551F219D4
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 00:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D170F37B;
	Thu,  7 Dec 2023 00:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0R45ZIE7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5856DD5A
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 16:12:03 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d03cf821e3so2293985ad.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 16:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701907923; x=1702512723; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r3cjh/OicCbB8QyzwRWb0eXa967TdIfrySjWwl2ZooY=;
        b=0R45ZIE7A6YWvzvIyTj1V2gHQ1TQW2emvV540o6LCLzrFZG8Ow8qoYKgrtP7XqnnSn
         UT95En8vIth4YXXfJRuAlpoWVnovM47wiCpHkbAbbggmMTPmFQySTmfqz0xPgE3V9MG4
         KcHiNImRFfBVt4S4bv9Ik5IYHxzcntUyv/9nESzNFMG3UQxJmnUB9Q66EclRX2Nn4yBt
         sdwLsAmOjmESbK5NbKEeVtBspMU3Tbfl2gt4dIGqONOVoDH/XGfmLdCDIHGS+mwokPkJ
         YeaFsvIHUBsKvIOOzecKIObTSnsZrrhiC/fQNx67s5he6NOmt8D7SBeDtZtEoquh4fDN
         sQuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701907923; x=1702512723;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r3cjh/OicCbB8QyzwRWb0eXa967TdIfrySjWwl2ZooY=;
        b=OQDEPF3Lj3fp7Q93ZNyL0l2ylKDYefFlianfvy0MbN3jv9x14M53VgxmwfbZPAWyVf
         3WE3UYOVdCgRWpAJ8emvuYxeBHRAcQBPpDEOYIhQuhE8e+WSfMO7P2nRHv5c7N69r87A
         JqfnjD2oUw3gIej60HEPkwTOcHdXdJiJWS8tjL/hjkZXNth+qJsu8C0yKa5zgvzGm3UG
         JessI04AcJOW2Skovn64DkmUncx96owPa+q/k/1s3ZkTbXoZpOmDuOjxP2Oe5KTz4HRe
         Qy+fLu/oB76x0JgSmDQ8FsGv5eYoV0Ab9EmIgQbdC7qgpuuL5TshmCxserbpS2hB5yn+
         MItA==
X-Gm-Message-State: AOJu0YyuI/6UB7w5YjAM/I2mqthb+BizgVExieLzYYAZ326aFdwtu+FV
	eUrxhrymBcb0IeeQ+6T141WQEL63a+5Q9PFNGL+0LDJs21qbXdhcHNarpoTl+HKb6wn0brmHGbi
	0uoXHfWvgYPwx97Tj/ubShdtKkMr9aUgYCbvBN9gr8xKccv20vVHHFZijEYWY8o/b2wfHNyc=
X-Google-Smtp-Source: AGHT+IFhH+WCd8DAawr4vLyQHCpqGtGc1HufViK0emU+lU7pKAr0bAQNvOdUDmWpsf2ekAPUQhaWWageB2FN+GwAog==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a17:902:eccd:b0:1d0:96b7:7f4 with SMTP
 id a13-20020a170902eccd00b001d096b707f4mr24174plh.12.1701907921779; Wed, 06
 Dec 2023 16:12:01 -0800 (PST)
Date: Thu,  7 Dec 2023 00:11:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231207001142.3617856-1-dionnaglaze@google.com>
Subject: [PATCH] kvm: x86: use a uapi-friendly macro for BIT
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	seanjc@google.com, pbonzini@redhat.com
Cc: Dionna Glaze <dionnaglaze@google.com>
Content-Type: text/plain; charset="UTF-8"

Change uapi header uses of BIT to instead use the uapi/linux/const.h bit
macros, since BIT is not defined in uapi headers.

The PMU mask uses _BITUL since it targets a 32 bit flag field, whereas
the longmode definition is meant for a 64 bit flag field.

Cc: Sean Christophersen <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 1a6a1f987949..a8955efeef09 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -7,6 +7,7 @@
  *
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/stddef.h>
@@ -526,7 +527,7 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
-#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)
 #define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 
 /*
@@ -560,6 +561,6 @@ struct kvm_pmu_event_filter {
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
-#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+#define KVM_EXIT_HYPERCALL_LONG_MODE	_BITULL(0)
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.43.0.rc2.451.g8631bc7472-goog


