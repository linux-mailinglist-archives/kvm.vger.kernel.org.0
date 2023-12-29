Return-Path: <kvm+bounces-5324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDAC28201FE
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 22:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7ACAE1F22DDF
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 21:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915EC14F98;
	Fri, 29 Dec 2023 21:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="mJ6ljrMV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6140C14A9E
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 21:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6db9f489cddso3171425a34.1
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 13:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1703886602; x=1704491402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpN1MW+95i3F5wasxziCwuSYEcNzMGQOQLUR8+9YpL0=;
        b=mJ6ljrMVda40JXAxwyYNXmMQg5teWjgAC/H6nnGGysjMi+WUrdU/0H4Nu9ja0XfNGZ
         2E2XicSCKutq+2E3Mvl3LzmN1gK1yHQqq8hxpIV+q7MwoYrJm2bZauyw0pgGv77PGcSn
         NYzfieiyCeViOVFxBzlxWcyNVxLhx/CSn4jY7Aidn2+PhhKD6nGGBYBxwwBoEIfvsYb/
         t7VTauAvMonfYgToyoF86mSqx1oSmqXrSP9qGHN+rISAoqR6Pro2z7SftU1slbfd774V
         uSaiELnO1sUMrc7Ubz5tG/cw1mF9q3qxEw1CZAzrKXZaWMgF/Q/AHUZxtdMsMse6bbz0
         cD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703886602; x=1704491402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DpN1MW+95i3F5wasxziCwuSYEcNzMGQOQLUR8+9YpL0=;
        b=Kg3tOgs1vDw/4eDHysBRvOr11slti4oEvou6trpMCc7WqTK9ZeYwHb7W9+//bQtLcP
         m/Awb0pmcvXwqVIGk0AS5T8cKuZXvFWvPaQDbJOs9tmLdUeBmE31rT89SjVjZjMt+X4l
         iPMTKq6P5srqh0ssKZlqvqsizOFcPFHIyQrGkoMNGJhKYkOfxyz+IkMe8cbxBVgySjdo
         DTHas04jWLxHSjCesDsF7hPFWww8SffoNBrMZPiTUT0ESiQuVpU/JfEzMSrvlVYKw9QE
         2+0RQng9/QD5EiE63LHrUjk9+gxzgDREjqrVv3nX8KGpqFh26L5L/U1uCdtELQt1k+nY
         WFVw==
X-Gm-Message-State: AOJu0Yy+qvptoLZVuj+HG7Z4ZrOiclBfnxixKiV8J1bztUhG3Ek9r+dE
	g/bPMGObPamOLkEieIcAfPI0e+qUzxwbOg==
X-Google-Smtp-Source: AGHT+IEoMYlA+EqYZ2pNrGiuaXbA/ou3plDe34hdp2Cqt+fbfmvLcabjhNZrNrL5tfUhk6UK6bCctg==
X-Received: by 2002:a9d:6f09:0:b0:6db:f8e8:758d with SMTP id n9-20020a9d6f09000000b006dbf8e8758dmr2480275otq.31.1703886602427;
        Fri, 29 Dec 2023 13:50:02 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id r126-20020a4a4e84000000b00594e32e4364sm1034751ooa.24.2023.12.29.13.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 13:50:02 -0800 (PST)
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
	Heiko Stuebner <heiko@sntech.de>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [v2 02/10] RISC-V: Add FIRMWARE_READ_HI definition
Date: Fri, 29 Dec 2023 13:49:42 -0800
Message-Id: <20231229214950.4061381-3-atishp@rivosinc.com>
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

SBI v2.0 added another function to SBI PMU extension to read
the upper bits of a counter with width larger than XLEN.

Add the definition for that function.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index b6f898c56940..914eacc6ba2e 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -122,6 +122,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_START,
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
+	SBI_EXT_PMU_COUNTER_FW_READ_HI,
 };
 
 union sbi_pmu_ctr_info {
-- 
2.34.1


