Return-Path: <kvm+bounces-5326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2355820203
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 22:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D436C1C21AAC
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 21:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2F015ADB;
	Fri, 29 Dec 2023 21:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="x6qHJOUI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489F154B0
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 21:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-58e256505f7so4537373eaf.3
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 13:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1703886605; x=1704491405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bzy66lxPBsLKj7NzWfh0sHPmHGdfbEMoaok8d/cKAlM=;
        b=x6qHJOUIl8u3MbW8LNtDl1CWgSvqprj/ug6IYuMJtIwJxY6J9mN9joJvYFQOga5Bu2
         bqltuxci5iYWQXlE8/CDOj6UygPLIttV3pNLgWNF+aCqdhnEnQw5ETzB79dfMylNA2Ok
         0ar1o9s5BhYWQoNJxS7ljTV9kEsgAY2MRwzKOpiANeZzam8ez6v9tXjai6A9xNCbOorb
         UIj1VSYScrrXzJfTWuZoBvUdwPsKOT+So7sX+Bk+RGkx91Ybek0roZuq7SsudKZ4vlBy
         qnPhRB+z7DvTTpAGhncmzkTzqPRVFAeen5ALlGY+XpClvbulTk718TScm2B5XVGG1Adb
         lo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703886605; x=1704491405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bzy66lxPBsLKj7NzWfh0sHPmHGdfbEMoaok8d/cKAlM=;
        b=Ir996kjxFUy72kqoDWz4txKvGc2h38/aIC0h0TxmUMXhTFYXIRfS8mqZ+OtROVTt1Z
         MTqwxcBBYe5RdIikhnNZFjkyyH4t3LPsTVgm0JR28CHe06Jg9HOYwjW9J1+4Dm1vEdIe
         R3Z9jDvbQmeB7qgySH097kj+XoMjGv+QxZXypGU3UGsp98uyOKfuQNd67rDiwi6rX7F2
         OxCf62Nxb9T1YNAaqbXPZRwYPi9SOL1TauLkVYxbSZE1ctgObNPKa1S3Xwo276rFKXBP
         aVAIGrCodkSQy/9xyk1ceMy9CSiDstNetfevwJa/zYU9RhQ2KM/pyd2tXckd1dPL+Ef/
         Pdfw==
X-Gm-Message-State: AOJu0YwFAiPDEDa3ISMuPXIUQ3XWeddXYtCoTos50VH22/ouOsqUnJhP
	gUym6Zx/XTOZ7Uct8V50k8NU3l93US+b9w==
X-Google-Smtp-Source: AGHT+IEtur4qNe8pb8V1uH0L25TQedsk0IjaWE3OpqgJ9z8PNa9Kv7iVaqWPAu9/vxyFbrEo/h0ycg==
X-Received: by 2002:a05:6820:606:b0:594:c97:2e39 with SMTP id e6-20020a056820060600b005940c972e39mr9339958oow.4.1703886605705;
        Fri, 29 Dec 2023 13:50:05 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id r126-20020a4a4e84000000b00594e32e4364sm1034751ooa.24.2023.12.29.13.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 13:50:05 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [v2 04/10] RISC-V: Add SBI PMU snapshot definitions
Date: Fri, 29 Dec 2023 13:49:44 -0800
Message-Id: <20231229214950.4061381-5-atishp@rivosinc.com>
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

SBI PMU Snapshot function optimizes the number of traps to
higher privilege mode by leveraging a shared memory between the S/VS-mode
and the M/HS mode. Add the definitions for that extension and new error
codes.

Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 914eacc6ba2e..75e95a7d9aa3 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -123,6 +123,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
 	SBI_EXT_PMU_COUNTER_FW_READ_HI,
+	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
 };
 
 union sbi_pmu_ctr_info {
@@ -139,6 +140,13 @@ union sbi_pmu_ctr_info {
 	};
 };
 
+/* Data structure to contain the pmu snapshot data */
+struct riscv_pmu_snapshot_data {
+	u64 ctr_overflow_mask;
+	u64 ctr_values[64];
+	u64 reserved[447];
+};
+
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
 
@@ -235,9 +243,11 @@ enum sbi_pmu_ctr_type {
 
 /* Flags defined for counter start function */
 #define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
+#define SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT BIT(1)
 
 /* Flags defined for counter stop function */
 #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
+#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT BIT(1)
 
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
@@ -276,6 +286,7 @@ struct sbi_sta_struct {
 #define SBI_ERR_ALREADY_AVAILABLE -6
 #define SBI_ERR_ALREADY_STARTED -7
 #define SBI_ERR_ALREADY_STOPPED -8
+#define SBI_ERR_NO_SHMEM	-9
 
 extern unsigned long sbi_spec_version;
 struct sbiret {
-- 
2.34.1


