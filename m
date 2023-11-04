Return-Path: <kvm+bounces-566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4057E0C84
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:04:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EFCA281FA0
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AD5E54E;
	Sat,  4 Nov 2023 00:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vB8uk2ra"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7E9C2C4
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:25 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AB51729
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5b0c27d504fso20296607b3.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056197; x=1699660997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ivj987AddR8Owbgd5+Jve951XXZrxlCEMaI81HO/fho=;
        b=vB8uk2rachPlU9IgHAvpB3Hex6MGK3TRc2L9isZdLll/Fr2xUopomBfabgLbdmkMt5
         91EPG9deV9taAczbA/Y8BNhdKPfuata77syMBR4C152f5AK6DVxSOESXBJPmbtQjzhDl
         dOgvwwi9GmZwq+P+FQrSpRMZIi03x5MBt5ga0s1KA3YCFl6L5hIHD8hN7d6nUWDyF6d3
         TIOkNf+noq6k30PDhvpxRCrfIqUJ8zYYUZZc4y3D2DYxVbvCYMclNXkIYicJBEKr/yVA
         urW+2xo+qqL/tDA6WuMdaL2mxadjQ+vhERKIbgGm5mWDKwi8LxXTKdhUzcqhcTr0n6v7
         x84Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056197; x=1699660997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ivj987AddR8Owbgd5+Jve951XXZrxlCEMaI81HO/fho=;
        b=W9jhUWQeg0xzZdTDIv2khUtTgQvH6/WwXBxRPI5B+CAOceh+RGfjN0n+ZlBbBQncsJ
         w23y0S+re5q4zPyLuv6TlvbA1h7LPBggIYWg3c5dX78ZpvON2jieSeDpJ3eZJT/PVrIo
         XcgxBkvZWR3tjJjJchlBTdXLRQkoyvi0qnvX694yNThdpr1n8W8hId/abEfAKraaIpbl
         XLLqTosqzGGObUoZatUL3ZHfRc5zxRwBZaWnUgrYl2K9RsbDTP+q9AGALtGMf2DGpTH4
         rhXhCNzvw2+y03cKpOtC22/H7kgYMB9wAJ7kTGKROmVelWHgQNZE1otr10dgDAHWEPZa
         30fQ==
X-Gm-Message-State: AOJu0YxtAPRhmdDXmog+dFzz6lfCs5Yoa5aD9MPbi06ILoEfAF6M4CPN
	cnAERPA5rs/od2vZhdQU4Q62kaSvuQ4=
X-Google-Smtp-Source: AGHT+IE/fyh2EC7KV93wZTxCRE6YJwWbGaND7lBPBJsISEAlzdVjQRVpH2PkEEXxHztcKHoC8cQnXECLu8M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3690:b0:5ae:75db:92c5 with SMTP id
 fu16-20020a05690c369000b005ae75db92c5mr114654ywb.2.1699056197083; Fri, 03 Nov
 2023 17:03:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:37 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-20-seanjc@google.com>
Subject: [PATCH v6 19/20] KVM: selftests: Move KVM_FEP macro into common
 library header
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
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
index 47612742968d..764e7c58a518 100644
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


