Return-Path: <kvm+bounces-2638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 257957FBD82
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5775282D26
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1AB5CD0E;
	Tue, 28 Nov 2023 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="R5eUFLd1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBB1111
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:08 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ce28faa92dso42843925ad.2
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183428; x=1701788228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cM+iyx3HzV6Q0lhdkwsJZGfIeyqwEQZL5+dROw33NYg=;
        b=R5eUFLd18vglNoLmRuiu28eJIHQJpwpLKXAfQhk00+um5bUbnQuPh5bSmzH9Erxu/5
         wFIfdUP3vX6TwY9uWA+6bLQ3l2sFj4oanC4XpwLrFxHGCLfe2t2H1RCBvsdpk0ySG3Hg
         /ZhucgLKvAaIjxXOssFmtOXgDXiOirjuG2pmlgNapt3wWFqvcoQo/bnASlMgYmjoDtBu
         UKRqwcWgJUETgH7DuOGRur0JBhciXedpz544q+cdzVSBfjTjrx4zR0BRE6Ze9uzspyYw
         kuEBIn5dTIEXUHYjORzRttiiglh7isVMWXp+Ih58L9k1+4qzTfx77bhTFHcHW3GhFJl0
         uHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183428; x=1701788228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cM+iyx3HzV6Q0lhdkwsJZGfIeyqwEQZL5+dROw33NYg=;
        b=TFMxWXIofhhuWgPZXOEid5h7UM0vwLWVYUz+audkjeZd9qeIUXNt1CYsyvq+zvoRXC
         RhCvInmCmrSE+sufdNLvX54zIJJbhT0QheGRN0xhFC6e45E9l20a0dUrmjgg6n/5hC2C
         ckH3qhNZ945M0Hm3nOwI01qWxWAe2qP/GRARk2nr+jHi9mH5JvDOfhhTFRm7hrpDiS8s
         Vtk/l2KijcQH4oZw8pUJIcabbh9gEXbv23HrVP3c2VJpta0KmSZa+2bqRMDMGcZOMLH3
         RoDVzCyd5dnrFzwQNIwwddNf9B58y0wClN+CfmWoU2lfxKsEes5NlqMbx51CsZFeRTeQ
         lIsQ==
X-Gm-Message-State: AOJu0Yw+KVwZZFnFKHIrE+FIH5SAAL1CTpdoREn1ro+W2OwOOTB4dRty
	VBgq/LYxupTqzFpDES1djxrq7w==
X-Google-Smtp-Source: AGHT+IG2Giid5R0skwB+Jt13gqXafpEZhJYgvRusyq4PgzHNzsOI9MZxpjGMI2cqqBeg3wiP22haAw==
X-Received: by 2002:a17:902:d508:b0:1cf:d597:194c with SMTP id b8-20020a170902d50800b001cfd597194cmr6879024plg.49.1701183427550;
        Tue, 28 Nov 2023 06:57:07 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:57:07 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 07/10] riscv: Add Smstateen extension support
Date: Tue, 28 Nov 2023 20:26:25 +0530
Message-Id: <20231128145628.413414-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145628.413414-1-apatel@ventanamicro.com>
References: <20231128145628.413414-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Smstateen extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index a4d54eb..0fe0f0b 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -16,6 +16,7 @@ struct isa_ext_info {
 
 struct isa_ext_info isa_info_arr[] = {
 	/* sorted alphabetically */
+	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN},
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index c524771..49eb3e6 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -25,6 +25,9 @@ struct kvm_config_arch {
 	OPT_U64('\0', "custom-mimpid",					\
 		&(cfg)->custom_mimpid,					\
 		"Show custom mimpid to Guest VCPU"),			\
+	OPT_BOOLEAN('\0', "disable-smstateen",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SMSTATEEN],	\
+		    "Disable Smstateen Extension"),			\
 	OPT_BOOLEAN('\0', "disable-ssaia",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSAIA],	\
 		    "Disable Ssaia Extension"),				\
-- 
2.34.1


