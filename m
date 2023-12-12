Return-Path: <kvm+bounces-4264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0420D80F864
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEC401F21777
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E44165A76;
	Tue, 12 Dec 2023 20:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AEo3KYgZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFFF1BEB
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:44 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d09a64eaebso54442955ad.3
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414063; x=1703018863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=spishPpmYPggI3jrHmifejwbO19KNsurBr8OcADllgg=;
        b=AEo3KYgZ5i4SDTChjzjNMVNy33d2JI1HsAM93C7g2gSTWDWPhwfbWiB8PxD5l9Kw0W
         aUryWzAf7iYF+PLR5rzIWHfzcC/XYF6woNz6CJTUWVcpwa7HSwujY5Zxr50q/Xm82vUb
         Ub60azWqR4PIeT08pUtRasltsapmhsVQnMkZb1BpktQodsAbtDlCS/CkW4QlkeMKzuij
         UClgkq1wZfp0hsgR2MiNVBofEGKLAIyNV7u7xSku5HIzACXkNTIII2DVTaUmZEh0zOuh
         7J+491qVYITd/vnf23XhOAz1S9bNyczCyinHmdrSsL4dbS2/NB++8/9nzM02lrWk71xR
         OOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414063; x=1703018863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=spishPpmYPggI3jrHmifejwbO19KNsurBr8OcADllgg=;
        b=l868fXeOysa4Jd3MDJlGYib1jk0HkiWla1m1QDal4u5lxRw+8M0EKA5r8FnLsceLbo
         JJhpf3IBJe3l4Msym7fzmFcm0HAyd4BSFv90hVcrwwIc/JeVjsesaK7A+fupql9G6XRq
         cWCCuq/vwF8Dp90CcVkMmH8NPZHmIm2HsF3ukFdW+T4w6+yNQ2IEX01rvwTjlCvl+Olg
         WjhiAPInsIBHWUFMsORt7KmzKtskbc3VSe57FkACIIvBF9hkgOx9TmSgqzlGY+jvWjgi
         U5OFKw9HaKAz6zyso8O5AXbECEHSkDUl8/NGYW7rqLbJCNevKxL55ah1N/VXIwnLveVw
         3/wQ==
X-Gm-Message-State: AOJu0Yz8ihlsLvZG2lgy123j/fjPDtW4J5yDkH0Nd6PN2BeeoEaR1Wye
	uJosDeuVPBpBu5BNuaXLOIG+xqF9MQ==
X-Google-Smtp-Source: AGHT+IFlKWTN0Mjg+LZyGbYruNVICl9MYmL7i6+AqPcCDng1ipNePVkwIpMa5H+DBM6rjcGy9KpJR8EGiA==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a17:903:234a:b0:1d0:6638:b9da with SMTP id
 c10-20020a170903234a00b001d06638b9damr52616plh.8.1702414063541; Tue, 12 Dec
 2023 12:47:43 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:40 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-26-sagis@google.com>
Subject: [RFC PATCH v5 25/29] KVM: selftests: TDX: Add support for TDG.MEM.PAGE.ACCEPT
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Sagi Shahar <sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, Haibo Xu <haibo1.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Roger Wang <runanwang@google.com>, Vipin Sharma <vipinsh@google.com>, jmattson@google.com, 
	dmatlack@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h | 2 ++
 tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c     | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
index db4cc62abb5d..b71bcea40b5c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
@@ -6,6 +6,7 @@
 #include "kvm_util_base.h"
 
 #define TDG_VP_INFO 1
+#define TDG_MEM_PAGE_ACCEPT 6
 
 #define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO 0x10000
 #define TDG_VP_VMCALL_MAP_GPA 0x10001
@@ -38,5 +39,6 @@ uint64_t tdg_vp_info(uint64_t *rcx, uint64_t *rdx,
 		     uint64_t *r8, uint64_t *r9,
 		     uint64_t *r10, uint64_t *r11);
 uint64_t tdg_vp_vmcall_map_gpa(uint64_t address, uint64_t size, uint64_t *data_out);
+uint64_t tdg_mem_page_accept(uint64_t gpa, uint8_t level);
 
 #endif // SELFTEST_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
index 061a5c0bef34..d8c4ab635c06 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
@@ -236,3 +236,8 @@ uint64_t tdg_vp_vmcall_map_gpa(uint64_t address, uint64_t size, uint64_t *data_o
 		*data_out = args.r11;
 	return ret;
 }
+
+uint64_t tdg_mem_page_accept(uint64_t gpa, uint8_t level)
+{
+	return __tdx_module_call(TDG_MEM_PAGE_ACCEPT, gpa | level, 0, 0, 0, NULL);
+}
-- 
2.43.0.472.g3155946c3a-goog


