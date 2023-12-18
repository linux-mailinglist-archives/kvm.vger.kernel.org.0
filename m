Return-Path: <kvm+bounces-4708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EECD816B55
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41A7B1C225F0
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89BC1A284;
	Mon, 18 Dec 2023 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="QaVAqSbu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA918EC4
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-59171d44b32so2026542eaf.3
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 02:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702896082; x=1703500882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSo5xMz9BHWeXpc9J2d4I3sRbXRS1RJF/2qH5J8y/oA=;
        b=QaVAqSbu6wG0lw/XmeIzBkzv0hvwmHQdVcwlbE4f/7JQ2g51OiBxCX+dBr4h+8fmst
         IZplqTviue3hEGJA8ZNufXATcAGhU6Q2yjAhoZu0sbApRdK3MBeTNp1F2Oj7tJSFzsPk
         ZSWpVUwnZgPUOSLKfQOQ4GlbghZAq7y77B96E3Y/7IhiY9fm7LUkLIGs8gakDT28BvJl
         JTaImIqjhxim9AhndAo1G3eTB52Gx9ziRAuKX1x34W1TNUk/PdzCr2MFX9rJD8xy7Gxk
         qZx6SXo871HlWIc5Cs+UrLIGAZ3rIYgu2pFq34i7zcDB9yibRhP/5gsk5Nm4baf2cjIp
         a84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702896082; x=1703500882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VSo5xMz9BHWeXpc9J2d4I3sRbXRS1RJF/2qH5J8y/oA=;
        b=BpWBfORWeO4dBkWUFkX6DZSFWmmDWLQ4GXPRw98rDuJyETFIglFGjlW7c/6tER0GZZ
         kRQUAEYjHq5Qd+vXNrrDK/gvY7d2eX+6EIPCsXbUekjBVogiMXQ/EsFRB805MtIBSyFW
         LOdleyT/11lfOTSGH59Reah5mJVhqUnKqRNAEGP8YhxbFdxSAqShUN3bYR0MdSh7nG6u
         DmDV5wpiQFb9wPQSzjGb17S7nGfj9OiKh6Gs6D/L2YJr/TnLTArb8fe75NXU0EiC4hEK
         kWLQRRmyhFq3PJV6SixUqWIshEcaI+160M8rb0PuMcLVyO+2KRWYVmKbGlvItm7xv5b/
         RBaw==
X-Gm-Message-State: AOJu0YyX/f+eTdJVSOZ14zaraE9rdMFIOUKbDOAppbWa5K5nZ9hsBwmg
	BlHuEHmOCGhOKzNff3yGTkzjFQ==
X-Google-Smtp-Source: AGHT+IFCk8w9wlM+fFH3HyxpC64QXnD52t+pZZjSo3r/qSB2t69XXBqCZkM0+zsVKb4UdUBtxGWvrw==
X-Received: by 2002:a05:6820:1ad6:b0:590:8496:b5d1 with SMTP id bu22-20020a0568201ad600b005908496b5d1mr16558518oob.2.1702896081753;
        Mon, 18 Dec 2023 02:41:21 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 185-20020a4a1ac2000000b005907ad9f302sm574970oof.37.2023.12.18.02.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 02:41:21 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
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
Subject: [v1 03/10] drivers/perf: riscv: Read upper bits of a firmware counter
Date: Mon, 18 Dec 2023 02:41:00 -0800
Message-Id: <20231218104107.2976925-4-atishp@rivosinc.com>
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

SBI v2.0 introduced a explicit function to read the upper 32 bits
for any firmwar counter width that is longer than 32bits.
This is only applicable for RV32 where firmware counter can be
64 bit.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 16acd4dcdb96..646604f8c0a5 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -35,6 +35,8 @@
 PMU_FORMAT_ATTR(event, "config:0-47");
 PMU_FORMAT_ATTR(firmware, "config:63");
 
+static bool sbi_v2_available;
+
 static struct attribute *riscv_arch_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_firmware.attr,
@@ -488,16 +490,23 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 	struct sbiret ret;
-	union sbi_pmu_ctr_info info;
 	u64 val = 0;
+	union sbi_pmu_ctr_info info = pmu_ctr_list[idx];
 
 	if (pmu_sbi_is_fw_event(event)) {
 		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
 				hwc->idx, 0, 0, 0, 0, 0);
-		if (!ret.error)
-			val = ret.value;
+		if (ret.error)
+			return val;
+
+		val = ret.value;
+		if (IS_ENABLED(CONFIG_32BIT) && sbi_v2_available && info.width >= 32) {
+			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI,
+					hwc->idx, 0, 0, 0, 0, 0);
+			if (!ret.error)
+				val |= ((u64)ret.value << 32);
+		}
 	} else {
-		info = pmu_ctr_list[idx];
 		val = riscv_pmu_ctr_read_csr(info.csr);
 		if (IS_ENABLED(CONFIG_32BIT))
 			val = ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
@@ -1108,6 +1117,9 @@ static int __init pmu_sbi_devinit(void)
 		return 0;
 	}
 
+	if (sbi_spec_version >= sbi_mk_version(2, 0))
+		sbi_v2_available = true;
+
 	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
 				      "perf/riscv/pmu:starting",
 				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);
-- 
2.34.1


