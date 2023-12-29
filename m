Return-Path: <kvm+bounces-5325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 107F5820200
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 22:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 428281C221AF
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 21:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161DD156C7;
	Fri, 29 Dec 2023 21:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="g2c35EpK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BB714F78
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 21:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6dbaf9b1674so4299259a34.2
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 13:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1703886604; x=1704491404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQnx2W4Ek1hjKyLE2uCBAG/NCAjRLiMW8LRvzu1a/Ms=;
        b=g2c35EpKzmZPP2z7yzr8YlnmrjO9QJelUFi8QUuHKksx7pyep0CGP5qnBd3q31EUJ7
         kLvklzSaOVitqaUoMyJsU5f0mUS5QMrj2wY8mradpUv1aL3Wab6mac6+q2wZODIDJyi9
         lN7GFyVOQFAtFBsabz0ZT+xXZBbw6LViiS3srFnw7gThAAHDrrmArvSQwvTRprRdsfhw
         2lZtUXnUStt4mwREXzyClGCBg4jkTVUgohK3zjPbFt8hETHG9+fCJN7PEOZ5Asu4p7Ub
         l0Y92Vsa5tWabzJvYV9wglvdvtolmTd7+Mo8hufe6h2zhOj1NhrulRr1KAhdrXsCoj6r
         myTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703886604; x=1704491404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQnx2W4Ek1hjKyLE2uCBAG/NCAjRLiMW8LRvzu1a/Ms=;
        b=V70TaNs+eD4EEPseGgnfAPBpiUE6TYHIGFo8xGpAc4q5cp1KGMaleug1XvcRkj0vnL
         PtOP5GgzU4s8GbMIr0GShgaMgoyuTT+X1WLakoTjiVa3ERSHPm3FtDy8gN47y3KwqRWC
         TPf6byBdf/r/FJ2bTTK/uVpY7rnyw61DtadbDFcNER3T4S8wl053XzNH5HdMaOzLXGYB
         /SP2BZ6xgHhfuehK5HHNYbXdS+H1qmVUcYVLZjal9FGo2un7VTRoAqCBkJ2KG/3IaGzH
         Rxp7DNRQ4VI4sE1PVvsaqATdQkG56QGRhQWusONrkA5cT8lkTRmAfodwszxUOQIFSScZ
         b4KA==
X-Gm-Message-State: AOJu0YzKx2wv0MLwEgOJWRlOJNg2WuRo5i+4cwpfoN+PtCkNMMXgPLBA
	4J1uNIHpA4qaMH3o/VYR3vCM59e15uANQA==
X-Google-Smtp-Source: AGHT+IGmwpkM+uVHGjFQccXxZaaYJeJ1IhrumVOeH5sSfp7pqnUVUDaH5arZfjBaoHfdSXN04lAOjg==
X-Received: by 2002:a9d:7f81:0:b0:6db:e98c:23c6 with SMTP id t1-20020a9d7f81000000b006dbe98c23c6mr5087739otp.2.1703886604078;
        Fri, 29 Dec 2023 13:50:04 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id r126-20020a4a4e84000000b00594e32e4364sm1034751ooa.24.2023.12.29.13.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 13:50:03 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
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
Subject: [v2 03/10] drivers/perf: riscv: Read upper bits of a firmware counter
Date: Fri, 29 Dec 2023 13:49:43 -0800
Message-Id: <20231229214950.4061381-4-atishp@rivosinc.com>
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

SBI v2.0 introduced a explicit function to read the upper 32 bits
for any firmwar counter width that is longer than 32bits.
This is only applicable for RV32 where firmware counter can be
64 bit.

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
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


