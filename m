Return-Path: <kvm+bounces-3395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E08F803CFC
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:29:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 285A91F211A2
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949B82F878;
	Mon,  4 Dec 2023 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BhnxKog1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5E4CA
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 10:29:11 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5bdb0be3591so2661964a12.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 10:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701714551; x=1702319351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HRGQ4jVpktID0BGp61Hzxxr59ElZZNf4bjZk+jO72BI=;
        b=BhnxKog1XDtzm3s+lHdX/67VPvcawKzCGHh5gO6BzewF7f73f1Y4RZKr02AgXHcwSM
         YAbNF6Rxdt6eOyUhPCz7qrRFmCsvvISAV97dgcc25SDt11g/V1ugDOX/IvHAPRtAjU53
         MUx7yijuDtgMHuL31HkVsYTkwAYAbRm2U/DLRw5nYSN7j6zDCjuwL7g4QnhQlH76IuZn
         4FWKRWSjUj80VGbsQ/xCsLHN4VC6o2abXk0TXCLar7bpvF3CBzLTcZ5xh1kuWQ1VzXC3
         6qo9mtXJsHrbn/EsMP/14BY6WPNkdD8oBMbq8XGidLyqUpAt5w+bYhwZIde0ZTE5Ccfo
         nm3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701714551; x=1702319351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRGQ4jVpktID0BGp61Hzxxr59ElZZNf4bjZk+jO72BI=;
        b=RFmgm+zg/w8svtCx4AguMnV+QYMzLC8INZB8A47Kp8x8Zj8x1m6go0z/XaYH5OejFt
         ceJdOov68JuRTTjXWKKUA3R0lbc5mJGmMgEJNWKaYnfH7XuwZd8q1IRZgwAM7vMjZ1Lr
         0yOqqsX3KSEJGt36UMOp3ozYnTFsMmpXIEz4RGy4XxywsEfJQ24ub3Bb4lbWDPqUUhyO
         HuvPZATfCb4A7DCSyX23aYXsu+DP7m4HWBc8GBpT+NbqNCuVnn+24IJ2EHGUlGC+IlPg
         +X/Zds/3OsQRTsYSCW+8EgULzPbDBRrArEqdS9SpRr7z48jeoOzeIPXoSIyW/vC8sqoH
         pS7g==
X-Gm-Message-State: AOJu0YzFLfjcFI/qhNYu2Xy9/QlbZeEXL9OMyyEJ/B0Um3gE7j/zQMxh
	4Zrk0JELHlkHcUb6XVs6SMEOzvZ5Oy9TxnP7O7s=
X-Google-Smtp-Source: AGHT+IFdjEbMZ4SAIgiXAHGarJ2zK+RGLw1nD4/QZyl9nTQOxkoQxpDwatU9eTBPhuxrPLxRaNdHlA==
X-Received: by 2002:a05:6a20:1610:b0:18b:9053:d865 with SMTP id l16-20020a056a20161000b0018b9053d865mr4810361pzj.42.1701714550706;
        Mon, 04 Dec 2023 10:29:10 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id it19-20020a056a00459300b006cdce7c69d9sm1806224pfb.91.2023.12.04.10.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:29:10 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 0/3] RISC-V, KVM: add 'vlenb' and vector CSRs to get-reg-list
Date: Mon,  4 Dec 2023 15:29:01 -0300
Message-ID: <20231204182905.2163676-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

At this moment we have the following problems in our Vector KVM support:

- we need a way to deliver 'vlenb' to userspace. Otherwise it's not
  possible to determine the right vector regs IDs (since they vary with
  vlenb). In fact, KVM will error out if 'vlenb' has the wrong size,
  even for vector reg 0;

- an appropriate way of delivering 'vlenb' is via get-reg-list, which
  ATM doesn't have any vector CSRs;

- even if we do all that, we're not initializing 'vlenb' at any point.
  Userspace will read vlenb = 0 and won't be able to do much with it.


This series aims to attempts to fix all these problems.


Daniel Henrique Barboza (3):
  RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
  RISC-V: KVM: add 'vlenb' Vector CSR
  RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST

 arch/riscv/kvm/vcpu_onereg.c | 37 ++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_vector.c | 16 ++++++++++++++++
 2 files changed, 53 insertions(+)

-- 
2.41.0


