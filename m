Return-Path: <kvm+bounces-4238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C4180F81D
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:47:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C08DB20ED0
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D213C6413C;
	Tue, 12 Dec 2023 20:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mKnVKtaL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0FBBE
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:03 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dbccc6dfa6cso79810276.1
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414023; x=1703018823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ir7Qh8CW4lvS6Nb/8/FOXimO+77Lwly2G5VfmqeIAwU=;
        b=mKnVKtaLzz92jCYRp6EPap2lEuR2Ltznu7AUYXOTqHFp9r+93Xb4LgOrqRZ2hs9cvE
         fu1w5OKc4nSSrms2nsLNDKTSccJD1EG0YS0Gz7hvMVpoyT9EqEK3pfplUcBqrey37+7I
         F6gpHgP1kJ6dcFyyJkGReiIGh7OM9BkQTtuNVRW9JbUiZgcFGsyluFwRzgDJ/zWL4ku0
         x6unFUGGqXruJzLPPQHZUwa5gfgNAL4YFO6scmoPySYy9BIiqmrxx3A3XeookSYFiK4a
         yXhB7w2+8vdydEh7ocG7Tkk7Qpz2nBlp653rUwZYRNBJbKTxmZBObdRBKm8hVv+UJXaB
         hdYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414023; x=1703018823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ir7Qh8CW4lvS6Nb/8/FOXimO+77Lwly2G5VfmqeIAwU=;
        b=gRHINAlT/2hL4/ffyKUt+b47LzynQJQYXwzEapWKX243ums64mR2Tr1N467zbTn8V7
         UOt/lnbwrgXN6UpcivMX37cm/6wGRllLncpl3lbLtldoqA8DEbnx4dakXVM3gTkObor7
         N2Z48YlnFBqYpWY/Sg3Epheyjliz2OEM5kpHQqRIaM9ns1EhkRRZEQ2lXBb8NcTo1VcY
         g0I8Q4sUoUZu9Fw5XLvbo7XF1uFvtFrX7v1xBxgpCajSeCCxNAqrJidR5qcutnC4Z8Uy
         di2Sl46ChLLO4ENtK+H36zCf8OQrRovdHyxz+qvyKcNrRnwVJ40s3qRsNygCBzWd2FbB
         Dx/A==
X-Gm-Message-State: AOJu0YzF9ZjGFtoV7tcGPQKAdAby0ipvRAgaVSIKl9o5Cdj6AoLEg+Hp
	xOWlrXr2Dqbpi5y5lO8CnDkI+pQWsw==
X-Google-Smtp-Source: AGHT+IFD5ajTV8O858cXODhPLGEEFN7xEKYfb0cjWPaPFQbSpbsFud7FYSS4rJTN/cV8ArjTn5X1GoxmxA==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a25:cb55:0:b0:dbc:b2d4:4793 with SMTP id
 b82-20020a25cb55000000b00dbcb2d44793mr34903ybg.6.1702414023009; Tue, 12 Dec
 2023 12:47:03 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:18 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-4-sagis@google.com>
Subject: [RFC PATCH v5 03/29] KVM: selftests: Store initial stack address in
 struct kvm_vcpu
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

TDX guests' registers cannot be initialized directly using
vcpu_regs_set(), hence the stack pointer needs to be initialized by
the guest itself, running boot code beginning at the reset vector.

We store the stack address as part of struct kvm_vcpu so that it can
be accessible later to be passed to the boot code for rsp
initialization.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c  | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c2e5c5f25dfc..b353617fcdd1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -68,6 +68,7 @@ struct kvm_vcpu {
 	int fd;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
+	vm_vaddr_t initial_stack_addr;
 #ifdef __x86_64__
 	struct kvm_cpuid2 *cpuid;
 #endif
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index f130f78a4974..b6b9438e0a33 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -621,10 +621,12 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_setup(vm, vcpu);
 
+	vcpu->initial_stack_addr = stack_vaddr;
+
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
-	regs.rsp = stack_vaddr;
+	regs.rsp = vcpu->initial_stack_addr;
 	regs.rip = (unsigned long) guest_code;
 	vcpu_regs_set(vcpu, &regs);
 
-- 
2.43.0.472.g3155946c3a-goog


