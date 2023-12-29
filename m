Return-Path: <kvm+bounces-5328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F84820209
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 22:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EC5E1C224D7
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 21:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A7616434;
	Fri, 29 Dec 2023 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="EEImOoWz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA215E80
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 21:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6dc049c7b58so1907148a34.3
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 13:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1703886609; x=1704491409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fyVFitalYEi2ik2oU3cHAgTTSiVjR9gn+8uYrWaU68=;
        b=EEImOoWzxDbg4FYod9z6qjzQEZqwSp+XNmPasWQFTh3kD2mt17xuEEk83zWon9ySs9
         51rnvadQHaGAmFPrkb4W399eq5Clmu5sflmopAFh+eVj14mlmF/8gFj6YS153lZwHojE
         19EM4wPH5bx8UG6ReYjBxx+ebdm4Sk/roeiQ57IpDtZFyyoLfYGFhOEO3nIwLcP+O81j
         UTc2Fo6wehk/NwVVmAgmHAiAPUdEmmhQE9zzSopV9s9kJprrae/x4+11jUaSDayBWyP1
         2LVvQZKoC+cCDRSxxFbAmrUCqS5OZti02VNBd/ECpp5MfJFqRIWYFrXDDsAC+fnJv/J2
         6XIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703886609; x=1704491409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2fyVFitalYEi2ik2oU3cHAgTTSiVjR9gn+8uYrWaU68=;
        b=UegdLCZBW2MXFX+h3s47DWA/OtwH7LlZoZw01DxQq7hXs3la4ZkI/6AqfLrkv4tC7L
         ett5FflPCqqVRCNuWPRVYkKSQP2Y7XZg0/DXr9kHWzbAYv2uvi6XnMrwxxtmSmT/cc+t
         bkhTQYJXR0chpTJguS8iefxSnufzL2BOlnwCHzZOgbp135X1aL7hwH03QcIgYI81pOKs
         p61dDGGUSAad/xB/zgNeiIrMQRZaJe2b9ZUrurHHbw+6Py1P3vUUVZtjJLnPzoZUfgJX
         ql/RYZdjhXD9YYhmtzAJVfiUVpnYk1wslvf7hDz7bCNxmEGHuDLXbSZzFbrSJd2g+Byg
         z0+g==
X-Gm-Message-State: AOJu0YwmnAwxfsErHE69wxxYh3/tqsWjj5zp4chh+1xK5k5akifUW05L
	q2smyRaphwnIGSZAer38qdcl2pk8oUoc+g==
X-Google-Smtp-Source: AGHT+IHbk3CijDIRIrtiDGuY/LNrpS3P4TiEu1ZTTNPQVqNgmydk0JZ2Oa/okLXufROZVjkTabBcJw==
X-Received: by 2002:a9d:7f0f:0:b0:6db:e1d0:6628 with SMTP id j15-20020a9d7f0f000000b006dbe1d06628mr6576894otq.74.1703886609050;
        Fri, 29 Dec 2023 13:50:09 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id r126-20020a4a4e84000000b00594e32e4364sm1034751ooa.24.2023.12.29.13.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 13:50:08 -0800 (PST)
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
Subject: [v2 06/10] RISC-V: KVM: No need to update the counter value during reset
Date: Fri, 29 Dec 2023 13:49:46 -0800
Message-Id: <20231229214950.4061381-7-atishp@rivosinc.com>
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

The virtual counter value is updated during pmu_ctr_read. There is no need
to update it in reset case. Otherwise, it will be counted twice which is
incorrect.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86391a5061dd..8c44f26e754d 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -432,12 +432,9 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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


