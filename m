Return-Path: <kvm+bounces-6022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B59CE82A4CB
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FF8C283E66
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C2B53E35;
	Wed, 10 Jan 2024 23:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="aJ1KB07B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DED52F8A
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 23:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7bc332d3a8cso298784539f.2
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1704928487; x=1705533287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QezjoA6tUvS/5tHzC/r6igb3Gn0pDkI0esE0F/349nk=;
        b=aJ1KB07B8xihJBHSJu4x2wtWXbNbhYGzAFZGya+OUrELM3nq3Eh9ov7hLGURIubBOQ
         UYKqK+jOqqrTbUsmKI9l8CXvfgBw8+8XEehKCQiH/hD6l7t4o5Ntko+7+ItTDOd6PsBp
         0+7c3BwXyQu+dEj9dZ6l9eTHn3/DcFLlnn8uX0YUPQHo8ZneH9fIwhA3lFMIXeQSvLfH
         zJj0dvoNbYIHSXVZdOiyMEDIiNmZirnP0ao1w90AFeFIDbZ/A9xymJ6zNO8Z0A/zaAQJ
         IC2dt27Am5lZdmiABZoiC9jLsvIHVDxRKjp2kYhKcR0QbGct0Zc6K2d8mRlvByZamvR9
         ptiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704928487; x=1705533287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QezjoA6tUvS/5tHzC/r6igb3Gn0pDkI0esE0F/349nk=;
        b=Xkd5e1neuRbWZfDw/bqppEzMZLeTDMu6DShmd7WJp+MViHWf0tmaDtAtaPw0rNagYu
         vn90HWV0y83UZusjXkqLp2sQ2wq2PQbec/2WaEXm8dUK8bxTeqxOrWkwmNtoilDtWbtR
         c2i2gki+9/Jkn97+Mpog2g9Wub5BO4kFIMA+Cx5+Ady0xpQpNxoiw6KZ4P4oKFF0iqTt
         qoMYfkkDrB9ZfJAy9ZZYubbwlcojHAU1UD68E1UI1BW4CR3owB3U5EDZ+XWN3+QqI97w
         1cc7J916H2OYl6+DnlZalDh6rwLW/oxLscQBhLebxp8FE2PnPUO6d58Tf2N1ahr/umnn
         jP1A==
X-Gm-Message-State: AOJu0Yx3u2V/Ous+IM3sYxG5EmkREu/b8fPw1Wu826/SMdpbgjVqVHmj
	hK4fHTyiRAI4sKH3K38NLGde49BiDW7QqA==
X-Google-Smtp-Source: AGHT+IEDUT17GMF4Ey0i/oYBIUhinUi3IYTlxkvNGgesi1C9N3qaiFERFQSZ9E+my76bd2GnH6ne4g==
X-Received: by 2002:a5e:890c:0:b0:7bb:df90:6936 with SMTP id k12-20020a5e890c000000b007bbdf906936mr380036ioj.41.1704928487361;
        Wed, 10 Jan 2024 15:14:47 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id co13-20020a0566383e0d00b0046e3b925818sm1185503jab.37.2024.01.10.15.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:14:47 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
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
Subject: [v3 06/10] RISC-V: KVM: No need to update the counter value during reset
Date: Wed, 10 Jan 2024 15:13:55 -0800
Message-Id: <20240110231359.1239367-7-atishp@rivosinc.com>
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

The virtual counter value is updated during pmu_ctr_read. There is no need
to update it in reset case. Otherwise, it will be counted twice which is
incorrect.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86391a5061dd..b1574c043f77 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -397,7 +397,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, pmc_index, sbiret = 0;
-	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
 
@@ -432,12 +431,9 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				sbiret = SBI_ERR_ALREADY_STOPPED;
 			}
 
-			if (flags & SBI_PMU_STOP_FLAG_RESET) {
-				/* Relase the counter if this is a reset request */
-				pmc->counter_val += perf_event_read_value(pmc->perf_event,
-									  &enabled, &running);
+			if (flags & SBI_PMU_STOP_FLAG_RESET)
+				/* Release the counter if this is a reset request */
 				kvm_pmu_release_perf_event(pmc);
-			}
 		} else {
 			sbiret = SBI_ERR_INVALID_PARAM;
 		}
-- 
2.34.1


