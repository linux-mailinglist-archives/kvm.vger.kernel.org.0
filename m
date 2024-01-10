Return-Path: <kvm+bounces-6023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 334EB82A4CE
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C369C28A966
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A9254F80;
	Wed, 10 Jan 2024 23:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="HInTl4eJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686EA51017
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 23:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bc32b04d16so199257639f.0
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1704928484; x=1705533284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bzy66lxPBsLKj7NzWfh0sHPmHGdfbEMoaok8d/cKAlM=;
        b=HInTl4eJDD4Kw1xM3+3KIHchkh+cAZ0BqlJnYlYWf6F1XFFWdBmJHG/KNzaqU3ydJS
         Z9gse39jt1hKw5Gn3sWxg7PVIwMyZreoKKmRMYJjtyo/TBwxPTOD3aQdIXTTtcdqiFNE
         4byZC3Y28CDOZF6q1XHbNbzz0BYPlPAeDB7/REKagzfUfvvHwt4AL9F3sH+ZdlNRHiWH
         21/m8foolfeAB2WlTSeThoPebrlbhuDnb+mJS8t7HaxRcuLuaMYQEziw+BuLd4OCEKwu
         sYy/r7KkbKIoxWCCl3aFY06RZrFxhluLNo0EIX4FgHaGHYzepx6jR51BpVa1vJIPkZLN
         qtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704928484; x=1705533284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bzy66lxPBsLKj7NzWfh0sHPmHGdfbEMoaok8d/cKAlM=;
        b=kEO9X1ngbJLI7eTH3RBtWReFSc6cl2MGWgH69SU44VIWcd7ybSVCpoQqr90MH6xJxZ
         v7ec76l9Gjcq67d+liANHjFbZQxGAfCofFsb9izZo+HNWqdV+KbVaXMn7QXxRghjt5NL
         NRY+66XgeG1x5hXtqAR74WHCYxQELkCu1YRHeSdFsgNwDVO1AkGaxzz0lENpVBR7RJgV
         YFZOGamOFEoZriC0RUcMsRirRvaGwgqgzxyQNdnKKNaM+god3fzhINUjNdA2TJOjTnTH
         TpRUkBR8Fqi5eaN4pKkxP51pahhTwTQmvPlQPw12AfXrJR5IHM+eXc9aHh/qo/SkzCMR
         Hacw==
X-Gm-Message-State: AOJu0YyaSC2LdgNuuAVkGOpz0nNpVJYBnFRUYoNxAVOXY3gXGV4EHxmv
	fEKn54vTDCvCqkOYGTzsp+Hkb/JSLAGqsQ==
X-Google-Smtp-Source: AGHT+IGm7HAe0+skSsl/Idm/HM451rWShQSb9VP0fha0ecUw+9h1tvFJhWz0TqlC4nQuQ/KiihcYqA==
X-Received: by 2002:a05:6602:730:b0:7be:eeee:816e with SMTP id g16-20020a056602073000b007beeeee816emr392642iox.4.1704928484498;
        Wed, 10 Jan 2024 15:14:44 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id co13-20020a0566383e0d00b0046e3b925818sm1185503jab.37.2024.01.10.15.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:14:44 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
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
Subject: [v3 04/10] RISC-V: Add SBI PMU snapshot definitions
Date: Wed, 10 Jan 2024 15:13:53 -0800
Message-Id: <20240110231359.1239367-5-atishp@rivosinc.com>
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


