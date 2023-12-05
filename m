Return-Path: <kvm+bounces-3572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 888BA805680
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B983F1C20FB0
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF0E5FEF9;
	Tue,  5 Dec 2023 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="dW1W/uR0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3940BA8
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 05:50:49 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6cdde2aeb64so5447618b3a.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 05:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701784248; x=1702389048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5tYmQsqbSCasY24iJ5yb8DOXoFWsecoLxSrfb0V9jc4=;
        b=dW1W/uR0a7KvhRBQpjvHd/QPlHiBMLG8RSPeoC/k0obgBaaZzViwFNMiO8xOOTQyOi
         /JYGU7ZTHxTh1HTnmHR4OHdD/cZG7Gr3g8x0WdT5ApXoQup9tv5aXZAlykEmU1ePMMTU
         wkBUKCK5vW4foSJz4MhvRzA/kUHtKheiscGKZuNYt4BHhpTLW36AnI2DFLkzqjGMo4WX
         1CzAB0or6UlAhCEQ/bMq5bBp1vI06i0XhgkSjDjwqRlHYgOXEZrhI4qbxEP895mUOkzK
         AvfTXwb1B6g8H2/E7vO8QvdyzUD0G/2OlBVNwnTBwa+Kl1DMmsTXF+SfwI28UY2gZYNu
         C7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701784248; x=1702389048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5tYmQsqbSCasY24iJ5yb8DOXoFWsecoLxSrfb0V9jc4=;
        b=KSd2Wyb0n+AgOZcx4GtFmFQPvuEmyYnEDPqv6UtqukrDtHb+OGChnccXtWJGLVsTxF
         ChkXLr3y/YXnbrpXoaBp5qKZeyuL9W5xVrprb799wQQ8orlyrHjDECZGJ7VTI7RZ23IG
         /OCoIuoUJcVy4mMrXJpXZykpnRnHJPq4YCQChPOKSXaN0gZ4ybaho5aEikM5ObJCZFVp
         aMfe98VFKzALqrt9vIlPHw9ugC39WDonj56bML/E9dTl3WdOcvalBasgkwJUXn6Kn7rb
         4UH6AxPQoX3uWOe3Y4WgMGsBEUJDwjQZTiLK9oEQ8VdDZubHiDhfhAmZfIHMHrdYufpq
         eLKw==
X-Gm-Message-State: AOJu0YxNH8HrbKDYrRYpTAXieLpCT+J51wsmzSjMbuJ6BKJSkmWxBW8H
	z3TbXZ0J7RjsRlLkqAjssYoXWA==
X-Google-Smtp-Source: AGHT+IF58FDgCNhIFgf4+jcYpbFJRPEkybjdmIZdZej549U3kiTnM5En7t4y+alYXvh+9RPZN62oTQ==
X-Received: by 2002:aa7:99d2:0:b0:6ce:725f:7da9 with SMTP id v18-20020aa799d2000000b006ce725f7da9mr521727pfi.59.1701784248583;
        Tue, 05 Dec 2023 05:50:48 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id c22-20020aa78c16000000b006ce77ffcc75sm673641pfd.165.2023.12.05.05.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 05:50:48 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 0/3] RISC-V, KVM: add 'vlenb' and vector CSRs to get-reg-list
Date: Tue,  5 Dec 2023 10:50:38 -0300
Message-ID: <20231205135041.2208004-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This v2 has a build warning fix in patch 3 found by kernel test robot
<lkp@intel.com>.

Changes from v1:
- patch 3:
  - remove unused 'cntx' pointer
- v1 link: https://lore.kernel.org/kvm/20231204182905.2163676-1-dbarboza@ventanamicro.com/

Daniel Henrique Barboza (3):
  RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
  RISC-V: KVM: add 'vlenb' Vector CSR
  RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST

 arch/riscv/kvm/vcpu_onereg.c | 35 +++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_vector.c | 16 ++++++++++++++++
 2 files changed, 51 insertions(+)

-- 
2.41.0


