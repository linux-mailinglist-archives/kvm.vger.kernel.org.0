Return-Path: <kvm+bounces-4706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3643A816B51
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:41:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4C5BB213C8
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9EE1182C7;
	Mon, 18 Dec 2023 10:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WtH5fJIX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A2714F89
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 10:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6d9d29a2332so1256706a34.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 02:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702896078; x=1703500878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EzYVT3U62jOpimrVBwbFtsr3YzUGPIXyIVj0onyqTs4=;
        b=WtH5fJIX6zigazMmQLZNqE4vdxwNUnwY5Lta2nOIAxsy0eQL4KNqxlkE8zo2zfmW1N
         hUoh0rvtG2fyB6TlyHZNmoR/kMv2+DYuNcZazV/2SGiRUsn255ppkcYxjEnMgF23Sh57
         3oYc22swfDMVjK5/RJ0Oeqn4BdofM1GwQghpJ5hsteEHaRb+vjDvJ/NBFT+UeQ47Qy23
         ua2cIuxASJO3kYfVMzBEu9mf/eI9stLDfOPYkYCHvHG+pdu3iVj2NHRQmmm8FYaUEy/K
         CkiOGNLM+fBH5xmZDddnX+lapJLmAL569zpZyK6Up1FwMrWgbTaXsPxI/tICooBkLVFP
         EluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702896078; x=1703500878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EzYVT3U62jOpimrVBwbFtsr3YzUGPIXyIVj0onyqTs4=;
        b=G8c4WtSyZsOFzQ5GpijcXIJfB4YkMUJWb0KKJ8M1vPGy3sEWpIAFqTlZ9fZwNKiGp5
         Psgz3jsZQTHACIBWpO3mi7Q7KvmEPXyUOqZO8EQmOvJbQh+ouD0F6B6qtGmGReq9jXep
         wnrpPll2dlazoNINylvuPcvuRkFDY4B/LBGKOuOQpTpo8wDZYtDzDeb9awjzUlBNF5ho
         GdSrca1xfKfPGdTohrUIadgD+wZ8VzPh10Tf3M7nh5xyMiL8ekPcOdbceFDPTwP6zy1Y
         MknAYFGshLHXs0NDq96BcCRh2+I+3SmrGsikp9zJ3KTp04Evczmue+w5K9XlaGfzbhAy
         9njw==
X-Gm-Message-State: AOJu0YzdlBS1boFtMQtIWU1CP2heuUAhjQkz4HkywlvY3sSsq81JcQWe
	+Lmur/5MgPojLyAgKnnppHHTJA==
X-Google-Smtp-Source: AGHT+IHap3UnechuN3domT4X1LYxQydZehOxW5SUbyRuhBv7FJIHHp0fJMugr+7DMK4DyTgTcIzVvg==
X-Received: by 2002:a9d:7dc9:0:b0:6da:5056:62de with SMTP id k9-20020a9d7dc9000000b006da505662demr2117996otn.7.1702896078450;
        Mon, 18 Dec 2023 02:41:18 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 185-20020a4a1ac2000000b005907ad9f302sm574970oof.37.2023.12.18.02.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 02:41:18 -0800 (PST)
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
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [v1 01/10] RISC-V: Fix the typo in Scountovf CSR name
Date: Mon, 18 Dec 2023 02:40:58 -0800
Message-Id: <20231218104107.2976925-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218104107.2976925-1-atishp@rivosinc.com>
References: <20231218104107.2976925-1-atishp@rivosinc.com>
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


