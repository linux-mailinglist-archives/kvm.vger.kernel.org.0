Return-Path: <kvm+bounces-1116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 018227E4E27
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD1BB281391
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E431118D;
	Wed,  8 Nov 2023 00:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l9AD/gMU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C146C101C5
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:32:16 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB4D210D
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:32:16 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b3715f3b41so84341077b3.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403535; x=1700008335; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4fLduEULj/w/qTyuS7dxoyFHFX9Y3I4W7nZGJLTTI/Q=;
        b=l9AD/gMU0/dtCaF8qUbSXvV2aPJepf1/58uKDor2tIhCv1IbdVaUMJXMbVFzQIMQGF
         95iBpUqUHQamuWByMvjSEt+EbP4L9EJCGkArZC4pRfN1iIMYYZU9Xd1kS4NP5oY1WGjP
         IlcGCrKkWvCo/LLNFhtEG0191KKVvvJ5JwQPriLNlGilhqYVkSHE9DN1SCfThzSmL4mm
         C1AuoVn82gzSDajT9i59urcgMzsw6ERkQhuYn/jFp9oQdvy+iQ/NgvpMC0XVg7NRcf+l
         5DTYRs2/hM6zkeclGZ1LXbH1HrFFVmc1tW2xqLgYiDrgqApO7RVxd9RUY9D3SMTnbqVR
         HwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403535; x=1700008335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4fLduEULj/w/qTyuS7dxoyFHFX9Y3I4W7nZGJLTTI/Q=;
        b=PQkNoHGjv/WQ5zea5jedwdyfkH+m0xeD3+XpdK52tAjEiuRGb4TzCXYlI6kHyMHPrU
         BJM+2oma9JbScMf9qI1dRdEAX4zQOE5wNXRSk9JQ8/9hcwj5qx4Aw7+JkijL4mhwKadU
         xtGCwnroeD7pE6klNKQcLlWzhbBU+6Fbx1lO+1egjmNS7z8OFp0T9GTGhvj9DedNIXYs
         7oiYIhZM91NrLUnQSNL93hhs9ybV7oYp5WRnBYqADfVMm/4zEOPg+5GOw40xp61xLvRe
         mobigFz53WZ/mURiNDLxreQ8YM+/9mLsCgLzYdZ5ouicWxnhBi0tm6WxV9ImSwYd5Ilv
         KXFw==
X-Gm-Message-State: AOJu0YxLVfsfHVXF03gjBOrbk9jQbKL+xE1mYa4DtUeKIUjj3TMVpoiE
	Qq3SBI4g0oLitcL8+hNwJkbnZ4Yqtwo=
X-Google-Smtp-Source: AGHT+IF26YecZ3TkuT4mazJpI08/dC8kqyOxF3VyvF05ZDK0MFVW2garzyomUhDteSezExjmTaKoCiF/Qf8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cb14:0:b0:5af:a9ab:e131 with SMTP id
 n20-20020a0dcb14000000b005afa9abe131mr4542ywd.1.1699403535389; Tue, 07 Nov
 2023 16:32:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:34 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-19-seanjc@google.com>
Subject: [PATCH v7 18/19] KVM: selftests: Move KVM_FEP macro into common
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


