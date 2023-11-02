Return-Path: <kvm+bounces-381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 042187DF1EB
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 13:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34C781C20F6C
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 12:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1240E15E90;
	Thu,  2 Nov 2023 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="bJlBdzJ0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D3B14AA3
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 12:02:03 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D26110DB
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:01:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1cc1e1e74beso7239175ad.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 05:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1698926518; x=1699531318; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KoS5Yzc43oJ/fOlEyyLAOhYHKPtTN8IraB0rRBs3MmU=;
        b=bJlBdzJ0AHhWdQCIf3SrLDFKVkvXvKWlDTdT8FDfZxgdcFinpT6OXPPgolZt1g9YVU
         J6jEJSkdOMB9kDm3ikWP+8NJUFaVjFPscf5aHmWoj9x4hzKyTGMPvXDOqAKKtVMVySNs
         nWWmjg8qBBW6xaf1DJyjJ5RxPJc4RPEmsQ1SpnQNshYyfjCoLu5ldn8pe2eu63EuWypR
         uuXvsCJv/2c2H434TOfVT+LhaGErdJ8Wd9Sf9+zrnRVIRefeBJkxCgeyAxuzbjo9lcaZ
         EmQ3V7UgEj4ssX4veBaph+/7ekgNmJEfbXKP03TMUZjcYKhAFDNYLw5osLZZYLEOLLRI
         tWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698926518; x=1699531318;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KoS5Yzc43oJ/fOlEyyLAOhYHKPtTN8IraB0rRBs3MmU=;
        b=gUz6/whWn6pGSOOtwfPOqIiDvO50wBbrRYs3F6kR+pTNqCflJp9IpvVspvC6SmkB8A
         d+yNSwMiJmJGYFEB2JMJVbeLTS/ZAXoDZV3lSH2d+hCPhl0VHV/cPg/PGZVKKQqTCC8t
         ESEln3Rrsgtqu02BYiEyrqCr0u0tgRgI1FBOwXGbhdIfOM/XpITRj8MCeKOelNDxjnMa
         RQ2TXO3+5FEClezm4aiXZuoDXY5n/k7UwBvORiLin5gHoP0DyqDRSGBZjNGXdK6K8pGS
         NXV8cJY7Qg3BC25yzYhNPhuUwhpvjoAVpc9jGSC30dp4zACYtqOlQAUwNim3EjQ/jAUV
         17ig==
X-Gm-Message-State: AOJu0YwUk30/DbmWRCkBFUvQ9AYGdGbMROHTNIkP8mx4Y9M9wt/7FoV9
	3fIm3A2soLNdGVMY14y3Oq80pA==
X-Google-Smtp-Source: AGHT+IE6nEv56zM0QCxqMU8kUXvOQDH9qhvdkxo16VJLcIXw6R7KqMseiu/2jgHWmzTZVVw8yrOyzQ==
X-Received: by 2002:a17:902:e80f:b0:1cc:7af4:d12c with SMTP id u15-20020a170902e80f00b001cc7af4d12cmr4685399plg.62.1698926517886;
        Thu, 02 Nov 2023 05:01:57 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id l12-20020a170902f68c00b001cc0f6028b8sm2969008plg.106.2023.11.02.05.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 05:01:56 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	tjytimi@163.com,
	alex@ghiti.fr,
	conor.dooley@microchip.com,
	ajones@ventanamicro.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] RISC-V: KVM: Add Svadu Extension Support for Guest/VM
Date: Thu,  2 Nov 2023 12:01:24 +0000
Message-Id: <20231102120129.11261-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102120129.11261-1-yongxuan.wang@sifive.com>
References: <20231102120129.11261-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

We extend the KVM ISA extension ONE_REG interface to allow VMM
tools  to detect and enable Svadu extension for Guest/VM.

Also set the ADUE bit in henvcfg CSR if Svadu extension is
available for Guest/VM.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 3 +++
 arch/riscv/kvm/vcpu_onereg.c      | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 992c5e407104..3c7a6c762d0f 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -131,6 +131,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICSR,
 	KVM_RISCV_ISA_EXT_ZIFENCEI,
 	KVM_RISCV_ISA_EXT_ZIHPM,
+	KVM_RISCV_ISA_EXT_SVADU,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 82229db1ce73..c95a3447eb50 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -487,6 +487,9 @@ static void kvm_riscv_vcpu_update_config(const unsigned long *isa)
 	if (riscv_isa_extension_available(isa, ZICBOZ))
 		henvcfg |= ENVCFG_CBZE;
 
+	if (riscv_isa_extension_available(isa, SVADU))
+		henvcfg |= ENVCFG_ADUE;
+
 	csr_write(CSR_HENVCFG, henvcfg);
 #ifdef CONFIG_32BIT
 	csr_write(CSR_HENVCFGH, henvcfg >> 32);
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index b7e0e03c69b1..2b7c7592e273 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	/* Multi letter extensions (alphabetically sorted) */
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
+	KVM_ISA_EXT_ARR(SVADU),
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
-- 
2.17.1


