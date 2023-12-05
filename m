Return-Path: <kvm+bounces-3615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C95B805B45
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE1AE1C20FCA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA84D68B87;
	Tue,  5 Dec 2023 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GQm/BT6z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496B7188
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:45:23 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1d048d38881so27408675ad.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 09:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701798323; x=1702403123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nk8NgzrKm+wkNVpQxcRmHDVuKy2huQw3GIldbaDgVGo=;
        b=GQm/BT6zXmUIsUWdqEMZW6Kv/3tkkQCi3QzSBv5NLMfTuQu2f9HdYs0A+Ioos9jWPu
         S+qw2gV/w1+m6fEVSnrrYB6vKSHxmvAVeQ+2b4H2slvgzI189QcgkdUNsqE+uB4Tv+JG
         pgoQyL/IQGIg0Ll5h8jymc41PgJSM95jJJfXU2b1wEumqRsp7Jvcs3GwDGopFUvC9JHA
         jPE1r4ZWTBzShR1yC/Wg6L+77i/SN8R/uKFEvdHx19F8/ZXTmHdXcUXYbKF0hkKuWx2e
         VagSZwUUWmIEo/9gc/92CPM2eJYxiLpl/tkSsDBd1OhwNhmgDIPgG478r/P6oj2wp0Jj
         CRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701798323; x=1702403123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nk8NgzrKm+wkNVpQxcRmHDVuKy2huQw3GIldbaDgVGo=;
        b=WLiHsDGzmEG0yfFTYZEiibsaM0IlDjaM9JfkTux/YydlCjZPEV+4TZsRMaEwFIgbhR
         kNcT/OXnCpT8JMLycQ8Q4YH4gKfxDep3pIBngJj+OZehgx+Kgo8Jq44wjfop5ldsnoQa
         AFTTtItMjOGqR5+4kj1rNvUH2tQ1xeynqsqVLTZXHxVLK4p+vU4yW1UxsNu8NPkYjGd+
         aM2yfJ52PEh1DShiHlWwoL5H6zm2fPLaW61ZbEJMHgGCqk6lbwo0H3P0LtG6miWD0BiB
         2RSq96mPMnYBQhw0JBymg01ANzK9vq2VBE73hHdT110g/p/iyuDo1ZL7KrmE9wrT1bQy
         bHEw==
X-Gm-Message-State: AOJu0YyOmu1P6Ed6B9Gjmu/e1D3Dorr54VQaAubWzcbyrkxIwOjpH7S8
	D9DFTztF7c81QOLXzqCno7PkZg==
X-Google-Smtp-Source: AGHT+IG0GExbyqlK/kAKXYSccGAsVEs/1H+k21xYDZ8oLJ3/T4boaiQc1BmYZnymkCLTHSKphQx7Fw==
X-Received: by 2002:a17:902:a984:b0:1d0:6ffd:cec6 with SMTP id bh4-20020a170902a98400b001d06ffdcec6mr3406901plb.127.1701798322713;
        Tue, 05 Dec 2023 09:45:22 -0800 (PST)
Received: from grind.. ([152.234.124.8])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b001c74df14e6fsm10465705pll.284.2023.12.05.09.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 09:45:22 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 0/3] RISC-V, KVM: add 'vlenb' and vector CSRs to get-reg-list
Date: Tue,  5 Dec 2023 14:45:06 -0300
Message-ID: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

In this version we're exporting all vector regs, not just vector CSRs,
in get-reg-list. All changes were done in patch 3.

No other changes made.

Changes from v2:
- patch 3:
  - check num_vector_regs() != 0 before copying vector regs
  - export all 32 vector regs in num_vector_regs() and copy_vector_reg_indices()
  - initialize 'size' out of the loop in copy_vector_reg_indices()
- v2 link: https://lore.kernel.org/kvm/20231205135041.2208004-1-dbarboza@ventanamicro.com/

Daniel Henrique Barboza (3):
  RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
  RISC-V: KVM: add 'vlenb' Vector CSR
  RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST

 arch/riscv/kvm/vcpu_onereg.c | 55 ++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_vector.c | 16 +++++++++++
 2 files changed, 71 insertions(+)

-- 
2.41.0


