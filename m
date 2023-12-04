Return-Path: <kvm+bounces-3396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F597803CFD
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDA9D28113A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBAC12FC2B;
	Mon,  4 Dec 2023 18:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Doeaq1dP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160A5D5
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 10:29:14 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5c66bbb3d77so815146a12.0
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 10:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701714553; x=1702319353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kw9lx7rfek+Fyxn9H19uerjKbw2z7hmkxzJlnytvErY=;
        b=Doeaq1dPJxVMgNm1ELPfevgBMEFPj3noVI/Tfy0pjJL1yEuPdpMauvu8Vvlm1x+fhW
         Jg/QKyAFGWZeGF4D0a/MwIY5mwriANUE4vD+lUzCHCOenRRCmYS6eOl50EP6CKKyQBTw
         FVzwP4yYykEHAkLAlmap8KbDM8LEzh8Vkrpp3H3xwVfAXaA0iweROLDioCinQMP29JWB
         2fsKYGACJl+QfJjTgioZ/sT48jHiqG45vDUza8en651OISKc9eOQxEolsC0XY92IqFMA
         o5K5kmYSX8dIxxkt1qMglbbDYFSTf6WzPq+SoF5G9BhLUoC9iotdmiMkrJJLQrVXil42
         NQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701714553; x=1702319353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kw9lx7rfek+Fyxn9H19uerjKbw2z7hmkxzJlnytvErY=;
        b=AmhyaG4dqgLicMNXlClLUcMJ1e1BtH04cl246iGYdQ8CyAAr8mSUcRYy8z/8wd1ohA
         fDOuLNWJOhn+D/hqemllTwIWFt7VglTc3kdGbVe6G5xjSeiGFsTGhWStVfSUh3kwpETB
         QJomSlfS3Xlh/E3p0I4AElzftelONLBlBjFaeyeUHkAsJTcHwUa4ZPPC1/gL5g5tkBdt
         8AJHasFLQ6NV3gzyjcu4fhkkkbtk8x/T9ooKLbJiLcdcvxrHcTSDpO5VImLnsRbPPXH7
         a8ivXsdL1RE7NStp3Tqll5ACdFQtH+fMczMcPMROW0B3CpKBEAqywoKVA3RJ8yzvN/7p
         dsRg==
X-Gm-Message-State: AOJu0YyfYlMbnE0YUtoRWZC47o2uV5hJdoV6JrkOCnGII2tXZmzwHhoj
	WrVHnrlgAjMJRtdM45opr+2PEg==
X-Google-Smtp-Source: AGHT+IE7Ek+QAO98xYFQUhE2+KsLzefRKGzxvQR6MjetLHTqt5mcn71POBm0SK15aUZ0cAx/t3xcWg==
X-Received: by 2002:a05:6a20:e123:b0:18b:fde7:71ac with SMTP id kr35-20020a056a20e12300b0018bfde771acmr3150854pzb.60.1701714553529;
        Mon, 04 Dec 2023 10:29:13 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id it19-20020a056a00459300b006cdce7c69d9sm1806224pfb.91.2023.12.04.10.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:29:13 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 1/3] RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
Date: Mon,  4 Dec 2023 15:29:02 -0300
Message-ID: <20231204182905.2163676-2-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231204182905.2163676-1-dbarboza@ventanamicro.com>
References: <20231204182905.2163676-1-dbarboza@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'vlenb', added to riscv_v_ext_state by commit c35f3aa34509 ("RISC-V:
vector: export VLENB csr in __sc_riscv_v_state"), isn't being
initialized in guest_context. If we export 'vlenb' as a KVM CSR,
something we want to do in the next patch, it'll always return 0.

Set 'vlenb' to riscv_v_size/32.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_vector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index b339a2682f25..530e49c588d6 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -76,6 +76,7 @@ int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
 	cntx->vector.datap = kmalloc(riscv_v_vsize, GFP_KERNEL);
 	if (!cntx->vector.datap)
 		return -ENOMEM;
+	cntx->vector.vlenb = riscv_v_vsize / 32;
 
 	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
 	if (!vcpu->arch.host_context.vector.datap)
-- 
2.41.0


