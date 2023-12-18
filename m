Return-Path: <kvm+bounces-4709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 434BB816B58
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75DC41C228BC
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0DA1B26D;
	Mon, 18 Dec 2023 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="mlU7iF0H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8CE19BD7
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6d9dadc3dc0so2547525a34.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 02:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702896083; x=1703500883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuZhnPGQBcArCwk7TKa9E5XMHvxU9EnFz3QAUH89JKI=;
        b=mlU7iF0H+X8kH0u88e2s3ebD5URpNJRoXk+OoiXTiNhyu4GKJSEDjiaZvIkCQqPv83
         VCQrKNC2HdGIvXpbrsYH2D3zZAtZCkvmUukIlIdqZNwja6OgD0iXYvEUza2HIFGfaPby
         J6wYIK583Kj+gnEuLm78ayjX9ruD2BUawPygT9om4mG87MUf9Vx9GLzUHF/vf152XkSS
         BsCdKR0jyfUxSwqq07ofGjNTEPnfLmeFAG+UT0IDsBolWv74c2DgMPGI35h6mkcoSdBy
         Ew54S7LkKRzlGzNvISTiD7AgbzR3nwhlencFGZHl6JtHfXE3tlAnp9OcwOm8cgCpE3sp
         ZcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702896083; x=1703500883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EuZhnPGQBcArCwk7TKa9E5XMHvxU9EnFz3QAUH89JKI=;
        b=O6vj7Z79ubxk2PNKocag/fjkeDeKqBMwPNM8kh+52ICNU5j81gnBpxhlHqEpflggbN
         HC24I00qfSG34tq7XJ9K8E/9EhKM9d646160ftAuVuud04Kf+gHHICY82BDvcZTRoj28
         UEmEF0RFMX9AvSzC7UabOHkJnzgADSkO6IuDQnY/BnvmO6ekk3pStjMMahneJhIrsWNx
         1NH/cbOc9HK5V58xEEPeGVxjpJUsEabT24AUhkP8W3jjnUyUgGnpKDGGii7LtF2+bKof
         ggfUUJ1vsZaIm/WWtOPkK31buf4n45QsgEcttIWZs/zWQ8tB2pqSsHonFF0gOM0tigfw
         YDLw==
X-Gm-Message-State: AOJu0YximaX2i3ZtB8CCwXhqfwt/pAPHV8iIgwSUDcHvZFXPKkB+vIqX
	cxMMEjcfrx+wBP3crv02DuJ/ag==
X-Google-Smtp-Source: AGHT+IF6Ilh9KFK64k+SlLgRCkTr3HSZb02y2w9rk8KeaGdRb4uXnCguyVV8KmCSxDozdmEA37nryg==
X-Received: by 2002:a9d:744b:0:b0:6d9:d132:ef24 with SMTP id p11-20020a9d744b000000b006d9d132ef24mr16649366otk.25.1702896083511;
        Mon, 18 Dec 2023 02:41:23 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 185-20020a4a1ac2000000b005907ad9f302sm574970oof.37.2023.12.18.02.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 02:41:23 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
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
	Will Deacon <will@kernel.org>
Subject: [v1 04/10] RISC-V: Add SBI PMU snapshot definitions
Date: Mon, 18 Dec 2023 02:41:01 -0800
Message-Id: <20231218104107.2976925-5-atishp@rivosinc.com>
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

SBI PMU Snapshot function optimizes the number of traps to
higher privilege mode by leveraging a shared memory between the S/VS-mode
and the M/HS mode. Add the definitions for that extension and new error
codes.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index f3eeca79a02d..a24bc4fa34ff 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -122,6 +122,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
 	SBI_EXT_PMU_COUNTER_FW_READ_HI,
+	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
 };
 
 union sbi_pmu_ctr_info {
@@ -138,6 +139,13 @@ union sbi_pmu_ctr_info {
 	};
 };
 
+/* Data structure to contain the pmu snapshot data */
+struct riscv_pmu_snapshot_data {
+	uint64_t ctr_overflow_mask;
+	uint64_t ctr_values[64];
+	uint64_t reserved[447];
+};
+
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
 
@@ -234,9 +242,11 @@ enum sbi_pmu_ctr_type {
 
 /* Flags defined for counter start function */
 #define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
+#define SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT BIT(1)
 
 /* Flags defined for counter stop function */
 #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
+#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT BIT(1)
 
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
@@ -259,6 +269,7 @@ enum sbi_ext_dbcn_fid {
 #define SBI_ERR_ALREADY_AVAILABLE -6
 #define SBI_ERR_ALREADY_STARTED -7
 #define SBI_ERR_ALREADY_STOPPED -8
+#define SBI_ERR_NO_SHMEM	-9
 
 extern unsigned long sbi_spec_version;
 struct sbiret {
-- 
2.34.1


