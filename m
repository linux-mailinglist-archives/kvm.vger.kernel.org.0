Return-Path: <kvm+bounces-5323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 828A68201FC
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 22:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22EBDB22056
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 21:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34F614AB0;
	Fri, 29 Dec 2023 21:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TrgNKAWJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B602514A8C
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 21:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6dc3b219395so195237a34.0
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 13:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1703886601; x=1704491401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EzYVT3U62jOpimrVBwbFtsr3YzUGPIXyIVj0onyqTs4=;
        b=TrgNKAWJGHw/Wzak7PxJFPG39pUIWmu8QUQlOeVjJr3tXRKheNpLr+0s12h7Njit4y
         aTo3eDEEq2YMWqyy19UU262rUB08KED62lukkFGy1nVrBTBebH5l0s4fowycFRIhsqKX
         eM8EvaveZOFRjgJM4md7d+4lfhdLbxwrSjh8WIpJQBk0uY/U0810eT0KVOw0MsFOOYeD
         oUOq9Ls26UlIqTidTGFs0yxfBiSb163/4r+pT2tCJF4qMDh8MzNoEWtHUVjffLfM7m/9
         ubEPqTAkXhupdniNVFx3fRAyyb2bicy7mkUwnqu+qWUxy/+m7AnOnnuRepzuOygXdtGy
         pG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703886601; x=1704491401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EzYVT3U62jOpimrVBwbFtsr3YzUGPIXyIVj0onyqTs4=;
        b=IsLJr3/gj0GAxW79c+eMCIHN7LvFqdDeiUlFaATfp1goBzSZQAL8g/+jYbPHWiwZnX
         UCUFZzKyolK1arLjw3+4I6i3IevNyr2pWft49s+gyUbxWQamS2IukjF8KK032hywL2El
         z1hKMNFWYwXnAKB+kT78jDF2rKiLZTTLivHnhCw2x9K7Z6K1rWCI8sT0wRSaXyOLdAKn
         PnER7LBpcA6/m6mj9pRDDTO71ccHTMQOTCn1YByZeWhXt4lZpWAF7ve0JjzU8ICKLfOW
         Xm2uDzA4yQDmpU989uQFqkLPihcskrAlVQnjP97KsZfT5yz4vC7p7XAacCzDunTLhTS7
         rU1A==
X-Gm-Message-State: AOJu0Yy23ZxIUqn4MnIIypKodRL+8KUNKC/1A7PQRiFmWB44JOgitXRE
	v3GFfMwZtIhNAw+yapEoprg2wR6MuCN8GA==
X-Google-Smtp-Source: AGHT+IEuODbSbFsbVriLOlUiOCO/2vbrQ4JMxcm5CHyM2vpKjHNqL2v71wan/bwXHLaT8EDFaqqeqg==
X-Received: by 2002:a05:6830:3b0a:b0:6dc:1846:fd with SMTP id dk10-20020a0568303b0a00b006dc184600fdmr883138otb.16.1703886600858;
        Fri, 29 Dec 2023 13:50:00 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id r126-20020a4a4e84000000b00594e32e4364sm1034751ooa.24.2023.12.29.13.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 13:50:00 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [v2 01/10] RISC-V: Fix the typo in Scountovf CSR name
Date: Fri, 29 Dec 2023 13:49:41 -0800
Message-Id: <20231229214950.4061381-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231229214950.4061381-1-atishp@rivosinc.com>
References: <20231229214950.4061381-1-atishp@rivosinc.com>
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


