Return-Path: <kvm+bounces-6018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C0D82A4C3
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:15:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A825A1F2757F
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC5A4F8BE;
	Wed, 10 Jan 2024 23:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Wr57N0GF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D344C4F898
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 23:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7beda6a274bso71206639f.2
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1704928480; x=1705533280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EzYVT3U62jOpimrVBwbFtsr3YzUGPIXyIVj0onyqTs4=;
        b=Wr57N0GF9FCH05IyXCuhWmHZX0l+bZe+kIK+c1oRB6QHWSCB/DuXXqMzjijbGwNfoB
         /lgWKIrKjSVsIYVPfi0OduAAdtvoKC5ZfMQKsB8GbMaNKKO1u6Ft6/X3CbBFJzN+OFi0
         0HLG7Xh/qTk3YEDIxXJAgmFk5tXxu/vwkgMnP448fDGEzKlVz2i6IwofNb0jcChgpvsR
         AUrskYhOXGXvv1+XRmQBn/MNjxolUb3Tw+nc0qI4u4EGUZMkyALJfbjyZ/WYCwIRmtkK
         uyB7j2Vp7LwI4OSoenCKHmZ7DQ1u+KRwG4fr1s46xDyZW1v7+Orph15bz8j4b04rtCi2
         90eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704928480; x=1705533280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EzYVT3U62jOpimrVBwbFtsr3YzUGPIXyIVj0onyqTs4=;
        b=eUP5oFHbejyZXizY8f9QWoxpl2EFksDUSpXucUZPbnA08O2DzuL11muS+FmPhZu0zl
         Gj9JyWR4tlGrmOScD0S7+q3btM3Itusvyo47hVh7U951uDRgE0soa35WW5Jj8JjND9ex
         TvegpFxg5FRHLghhuIHrea0lt7iwU2rS7HTOdhGkGhzSRwCslTIlF5gOk9rNeFF+yX5S
         hdisgyklYsEF0+EtLkw+fwL4u+Y+MrU0mIpwNaxhZrB4CteE07CrGgCrM9SPAf53Vx78
         VFYJ9xOrXPFzdcGMbc0+kMyEUB8iY7xyvzJFv6GURK/S2lx/3QX37kZ08KjdbudlvamB
         GoRg==
X-Gm-Message-State: AOJu0YzJNWhe53LLMzYU+ag8TzFQpdDMPOohqOe3wvE2rjw/T8o2diwT
	uc+WvHkl46R0FMIwLgc/CUs3YCALqgKnzQ==
X-Google-Smtp-Source: AGHT+IHBtYFpa0Fm4UJ7oZUXxQPb/ffVF39Gpk3+VL2e9dxmW6edwLnfASayEBNATNo0KU8KYSyH6A==
X-Received: by 2002:a5e:dc44:0:b0:7ba:77f3:b7e2 with SMTP id s4-20020a5edc44000000b007ba77f3b7e2mr364158iop.42.1704928479976;
        Wed, 10 Jan 2024 15:14:39 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id co13-20020a0566383e0d00b0046e3b925818sm1185503jab.37.2024.01.10.15.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:14:39 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>,
	Vladimir Isaev <vladimir.isaev@syntacore.com>
Subject: [v3 01/10] RISC-V: Fix the typo in Scountovf CSR name
Date: Wed, 10 Jan 2024 15:13:50 -0800
Message-Id: <20240110231359.1239367-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240110231359.1239367-1-atishp@rivosinc.com>
References: <20240110231359.1239367-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The counter overflow CSR name is "scountovf" not "sscountovf".

Fix the csr name.

Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr.h         | 2 +-
 arch/riscv/include/asm/errata_list.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 306a19a5509c..88cdc8a3e654 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -281,7 +281,7 @@
 #define CSR_HPMCOUNTER30H	0xc9e
 #define CSR_HPMCOUNTER31H	0xc9f
 
-#define CSR_SSCOUNTOVF		0xda0
+#define CSR_SCOUNTOVF		0xda0
 
 #define CSR_SSTATUS		0x100
 #define CSR_SIE			0x104
diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/asm/errata_list.h
index 83ed25e43553..7026fba12eeb 100644
--- a/arch/riscv/include/asm/errata_list.h
+++ b/arch/riscv/include/asm/errata_list.h
@@ -152,7 +152,7 @@ asm volatile(ALTERNATIVE_2(						\
 
 #define ALT_SBI_PMU_OVERFLOW(__ovl)					\
 asm volatile(ALTERNATIVE(						\
-	"csrr %0, " __stringify(CSR_SSCOUNTOVF),			\
+	"csrr %0, " __stringify(CSR_SCOUNTOVF),				\
 	"csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),		\
 		THEAD_VENDOR_ID, ERRATA_THEAD_PMU,			\
 		CONFIG_ERRATA_THEAD_PMU)				\
-- 
2.34.1


