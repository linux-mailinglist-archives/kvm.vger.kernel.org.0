Return-Path: <kvm+bounces-2629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A71D67FBD76
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D73931C20E4A
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBF55C915;
	Tue, 28 Nov 2023 14:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="o8lj6AeP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9B2210E
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:55:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ce627400f6so44870055ad.2
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183322; x=1701788122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+aK5RATSMuwz0R11fQ6d3osSrL0r31QZEh4gl5Kftw=;
        b=o8lj6AePTJKotUIH1flyqPRRwjpM/ftdYvv6XxsaJxj37UQ7IakeqdQRP3w9SkZitF
         xa5FMLLyuPnKNMa+J155d7a4rYXPy/tXu460VPXJx3sHtMz6SykUL1o8xra0usQKQs/Y
         7KasoMcevznFfOEaFYaTMcvB8CSddFhef+v+2eKXM7hnAxG6/HOzG6ZHicwfoe9rsfNe
         Yj/1Iu1ZU/5nCzDb4IOZqDs4BCW9hYVNtK5o9QpHlSEB7bpSVbBSnPewfvMurS8fMB2S
         GSwPA0mY8QnY8pCf2ujliOj+jdUwOfQy26Z0xkfbn3zqi6jOKz3X3OIMml94iI5hIQvY
         79VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183322; x=1701788122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+aK5RATSMuwz0R11fQ6d3osSrL0r31QZEh4gl5Kftw=;
        b=qMcXqx44iylbpRDL1sURmkR+nAjxuRS6O8DZtnVv4gEiZjJQZqWSrNSMGz/4QY5RdY
         7aIcfhDdICzvvxSyha19TMomxLNNCbnbGOkzN7XR2IXtGlamKjN/DFqqWZ56VRWbAUCk
         i5dAJjASEtNl3loNftTmVzzxRkKY7TiXFWDgii5bwtv8Z4QYp9uhM+xYPSFL3yiqbmol
         /FPjdGAxk8lpMC2QNVv79IZWFa3D6FL2lq9bhYAnaw6JbYON+wUBsseU9H5YPV5q2Z20
         Nzwdyddzxy/nHAQLRQcsLGOGz/QU0lrp6nJtyqhHxladspcWy/2QzMxVMjuAsJ0S/Ibx
         CGFA==
X-Gm-Message-State: AOJu0YzwM2jN5ePQ5RSqzWDM/PngBZsVvAPDF41DnF3/c3mXcW8v41gu
	DhMEJLp4JPLxt0vsdF+u7I/AbQ==
X-Google-Smtp-Source: AGHT+IH2xWVOITfzziniBlNh6pTHruM1083PD+Pd2O1gzhC3MdYm+hsrORloedeBl+KCem0W7nVbUQ==
X-Received: by 2002:a17:902:c949:b0:1cf:bd6c:f7fd with SMTP id i9-20020a170902c94900b001cfbd6cf7fdmr11119342pla.49.1701183322059;
        Tue, 28 Nov 2023 06:55:22 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001bf11cf2e21sm10281552plg.210.2023.11.28.06.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:55:21 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 14/15] RISC-V: KVM: Allow Zfa extension for Guest/VM
Date: Tue, 28 Nov 2023 20:23:56 +0530
Message-Id: <20231128145357.413321-15-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145357.413321-1-apatel@ventanamicro.com>
References: <20231128145357.413321-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Zfa extension for Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 32c7ff23ecce..909bd98220ee 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -165,6 +165,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIHINTNTL,
 	KVM_RISCV_ISA_EXT_ZVFH,
 	KVM_RISCV_ISA_EXT_ZVFHMIN,
+	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 6b2d81c8cfe7..ba18587ae8c7 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -47,6 +47,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZBKC),
 	KVM_ISA_EXT_ARR(ZBKX),
 	KVM_ISA_EXT_ARR(ZBS),
+	KVM_ISA_EXT_ARR(ZFA),
 	KVM_ISA_EXT_ARR(ZFH),
 	KVM_ISA_EXT_ARR(ZFHMIN),
 	KVM_ISA_EXT_ARR(ZICBOM),
@@ -123,6 +124,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZBKC:
 	case KVM_RISCV_ISA_EXT_ZBKX:
 	case KVM_RISCV_ISA_EXT_ZBS:
+	case KVM_RISCV_ISA_EXT_ZFA:
 	case KVM_RISCV_ISA_EXT_ZFH:
 	case KVM_RISCV_ISA_EXT_ZFHMIN:
 	case KVM_RISCV_ISA_EXT_ZICNTR:
-- 
2.34.1


