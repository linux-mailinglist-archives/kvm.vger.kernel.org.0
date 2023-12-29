Return-Path: <kvm+bounces-5329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D7982020C
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 22:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95D351C22551
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 21:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A66F9171AE;
	Fri, 29 Dec 2023 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xWDAVtAw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5801641E
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6dbfdb41a63so2443375a34.0
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 13:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1703886610; x=1704491410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9sAaI5x/m4qa/IsblGkrHPvGq73TiWdoovLssK6KVs=;
        b=xWDAVtAw0i1yX1oBfsj9Xbz9+pqZ2SYrxIjHNJbB//2JvXGt2rhHe6oXr2XCnckRcR
         ZmSelL0I71O1zxv44XyK5z1lt42GU89rNpwGIWIgkADcfwj5jDAMhFxywr+t3/dwlnNA
         k0CCq5WopeQ6uKN6255OgTrabyHQ/LSAt60CbhNzo50+sh2MQfQlF6cExW5ERwxbBtGo
         QqVeT/6wNqWoLEaXIUE4ZczKaoDlEHYRzgO6F4Y9yB+4p5gvyPRWjFgmWon7JlMXwEHu
         RwAy5Zb92hrXrrWslW+Lh4enzQLsNO949uG1t3m2Joa2bfH0Dt1lCdRptgBa5EDtR3Fa
         +/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703886610; x=1704491410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9sAaI5x/m4qa/IsblGkrHPvGq73TiWdoovLssK6KVs=;
        b=VqsHfXW5YaAfvp1mkLChd3wtsJZsPCdGgAEQAuKaKwVmCBmO64og2DRzLODVBZbi85
         gouSpOqR5kE+SQpfQlOzZI7pMExpq9bRvbfn+pmQCBqE4szQoTDHQPexriygXLJZZwW6
         glsEfLblZrNuQ5bLOuoTDRWgmsse2kNl60/GqMTmAZhB77uRWxh8Y9XqvJzJybOMF1AH
         40gPkBLci2asA3gNHuw2gh2h7ZieQOAnum3Fv2jUdEv5JAi9z1OKbv+k1Wzij5FZJLz+
         b14DAGgv1AqJFFbqfFd5q9aHmu8h54nbvVYZUhe2jIcdVJKcSPgqK4Jezx7L1S/+nLco
         08MQ==
X-Gm-Message-State: AOJu0YzGiD+Pgb8hV50NCayRlzk9Q5EFTVnd//beKx3FacFL6ZM4oJfD
	6nJf+wQUXNL01dOmDLOmRrFijltEp9UFwg==
X-Google-Smtp-Source: AGHT+IFoZdi69fR1RVMQrS5+z2lZ3ANAuSBiic5ImLxKQuR4x/mQOda884boDm8q+SDpYIGvV84mdw==
X-Received: by 2002:a9d:730f:0:b0:6d9:f1b4:c560 with SMTP id e15-20020a9d730f000000b006d9f1b4c560mr9972651otk.67.1703886610630;
        Fri, 29 Dec 2023 13:50:10 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id r126-20020a4a4e84000000b00594e32e4364sm1034751ooa.24.2023.12.29.13.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 13:50:10 -0800 (PST)
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
	Heiko Stuebner <heiko@sntech.de>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [v2 07/10] RISC-V: KVM: No need to exit to the user space if perf event failed
Date: Fri, 29 Dec 2023 13:49:47 -0800
Message-Id: <20231229214950.4061381-8-atishp@rivosinc.com>
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

Currently, we return a linux error code if creating a perf event failed
in kvm. That shouldn't be necessary as guest can continue to operate
without perf profiling or profiling with firmware counters.

Return appropriate SBI error code to indicate that PMU configuration
failed. An error message in kvm already describes the reason for failure.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c     | 14 +++++++++-----
 arch/riscv/kvm/vcpu_sbi_pmu.c |  6 +++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 8c44f26e754d..08f561998611 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -229,8 +229,9 @@ static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ct
 	return 0;
 }
 
-static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
-				     unsigned long flags, unsigned long eidx, unsigned long evtdata)
+static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
+				      unsigned long flags, unsigned long eidx,
+				      unsigned long evtdata)
 {
 	struct perf_event *event;
 
@@ -455,7 +456,8 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     unsigned long eidx, u64 evtdata,
 				     struct kvm_vcpu_sbi_return *retdata)
 {
-	int ctr_idx, ret, sbiret = 0;
+	int ctr_idx, sbiret = 0;
+	long ret;
 	bool is_fevent;
 	unsigned long event_code;
 	u32 etype = kvm_pmu_get_perf_event_type(eidx);
@@ -514,8 +516,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 			kvpmu->fw_event[event_code].started = true;
 	} else {
 		ret = kvm_pmu_create_perf_event(pmc, &attr, flags, eidx, evtdata);
-		if (ret)
-			return ret;
+		if (ret) {
+			sbiret = SBI_ERR_NOT_SUPPORTED;
+			goto out;
+		}
 	}
 
 	set_bit(ctr_idx, kvpmu->pmc_in_use);
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index 7eca72df2cbd..b70179e9e875 100644
--- a/arch/riscv/kvm/vcpu_sbi_pmu.c
+++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
@@ -42,9 +42,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 #endif
 		/*
 		 * This can fail if perf core framework fails to create an event.
-		 * Forward the error to userspace because it's an error which
-		 * happened within the host kernel. The other option would be
-		 * to convert to an SBI error and forward to the guest.
+		 * No need to forward the error to userspace and exit the guest
+		 * operation can continue without profiling. Forward the
+		 * appropriate SBI error to the guest.
 		 */
 		ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
 						       cp->a2, cp->a3, temp, retdata);
-- 
2.34.1


