Return-Path: <kvm+bounces-6020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F6982A4C7
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:15:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCBE0B26C67
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D16A51C49;
	Wed, 10 Jan 2024 23:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tDNJTu0k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13AE5025B
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 23:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bc32b04dc9so159911839f.2
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1704928483; x=1705533283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/Smp2oLhuu6GIJFXbIgbmjKI2p4Ava6d/2TN1s81h4=;
        b=tDNJTu0k+yFq3L3KJ1TlvG0de0hqJNgp72hRJEcgyiPJerjd5+ENKWervVnJyxiElb
         eRzJ2JeH0db3SlvhNU21G507dUlxpi429f6KHY3Tr8OquJ/OOSC132bJRpwnYgYO4WjN
         sVz/XDNZzfg7fDNHreLqXJzoFrePfIyl8xbWPBaIsQFwoLrJEMQAqitBSCndrjiCji1b
         q2ByzrRpgPoNnCq+ErHE3m2dO02/zEvXWREuI/9UFHuXYfKZYqA6qDiJZoVDWHRXdBSw
         g9ZQ7VCW3z63LkRbMgi4VxjvuOwQ6CED5n3gKMeMTm4U/rvkzUfoKjjp3jk5ZgJY11bJ
         P8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704928483; x=1705533283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/Smp2oLhuu6GIJFXbIgbmjKI2p4Ava6d/2TN1s81h4=;
        b=XcqZ+CoI38UtbWALzPd8I8qq8EPqpWcpe73o1xX+5N5T5ysThLWC8tXNY/lpMXqxku
         8EB3Yj7JkKuahAOBUFS5GtoCm9RPIanqlhdw4pFiOu39OK+anSlmWDLDyB7KMiHmVYUM
         GEhsrFYUMroFONTdoSoO+JyYD47qKgE00PX9FmCjzNMq5SS57r8SdDO6+72lauHzQfw0
         mRhNVRh0pB+bT4LJrmLO5pWaf7C+rZLHR6soJ7Diuy1GPFXzywJfI1FvqMfBNjNc4xPR
         6gqZMnGqPYimqEhgSG2WkwB1tEx5420qVvhqgtwuHHoi24pP0joHHaGlzMLxfeVTbRDw
         TD6Q==
X-Gm-Message-State: AOJu0Ywpl7m2+vY2V4nJOaspR5EIytDaOL/NVRzGrflAFGGqWK/fu7KI
	noJU+Rq8qKMYjw9//ITUrYGD0Dv65guw7g==
X-Google-Smtp-Source: AGHT+IEO+CT+BOK9YfH/14uu4wNMxjKsnPCEdlLu9xcMpHCvuY2p3WWb+zLXSonhnsccpODzARsukg==
X-Received: by 2002:a05:6602:2819:b0:7ba:85e4:f8de with SMTP id d25-20020a056602281900b007ba85e4f8demr324455ioe.42.1704928483021;
        Wed, 10 Jan 2024 15:14:43 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id co13-20020a0566383e0d00b0046e3b925818sm1185503jab.37.2024.01.10.15.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:14:42 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
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
Subject: [v3 03/10] drivers/perf: riscv: Read upper bits of a firmware counter
Date: Wed, 10 Jan 2024 15:13:52 -0800
Message-Id: <20240110231359.1239367-4-atishp@rivosinc.com>
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

SBI v2.0 introduced a explicit function to read the upper 32 bits
for any firmwar counter width that is longer than 32bits.
This is only applicable for RV32 where firmware counter can be
64 bit.

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 16acd4dcdb96..ea0fdb589f0d 100644
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
+			return 0;
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


