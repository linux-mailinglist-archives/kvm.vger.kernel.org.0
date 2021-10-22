Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B93A43719C
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 08:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhJVGRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 02:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhJVGRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 02:17:45 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1C0C061764;
        Thu, 21 Oct 2021 23:15:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w14so10081117edv.11;
        Thu, 21 Oct 2021 23:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D7VyhyVFqGiDLOi0b0J5PndE5AU+ffBlyz6llD7egu4=;
        b=TS+J4Al3sMzV26NQKn3chW4Y5DPwz6ZgsxtYGkRaiHjYuvuFg3J/NTZGq+ib0DDywj
         YmED8b+6p/0wRvkOoosk8qqzfff2zAxwghpKPsVK6m5P1RTke8fFhbyTcqjz4SRecmxB
         8rTFbNjCGaS3Axp10JUmD8YFqBE27/gvk9LuaK+HGVgdjWOh88tpGWyurpb1D8BpYEus
         yGdbiIaXNc79YMHYiDvWhoezFbvN6gTh8kLyg1QiD7pPdfRvS/VLqiIVA1p2i2xzIfXC
         HD8DgUnYWqdmgZxAcGEP38j1SudXm7AhzEQOQl/DTu7OHR2K5rwHdnjos00gp864XNs8
         3z8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D7VyhyVFqGiDLOi0b0J5PndE5AU+ffBlyz6llD7egu4=;
        b=FtNv7I6pBikFV3w2+QsR+SNZyZfpIKZ32LNRfmBh/lTTJIdU4wY0iDgs6geRncR+c0
         tWOUlyKVzGTgUHwnCsanzNtS2xKgZwqnn4vpLItI4vs9dgxywKBbwvT5cVds29cJNjjn
         9l3rvf3CdFoZGpcPd2DgSgad1e08Zx6NYKCtZz2dvRNPqXicl93gMi+olK0OPZj83hzu
         Dw/ZVaTOMOekqUjEpEv5EVHGalj5KTycFiDzpOrKVFlJiTkYOng+YYg7A39HNu65x1zA
         5w3T9A7HwnGmaIYsYYb7MkTaLqvvKFwhoOW3JTwZax0MpxWVtxev2s6HByBTMPMCCYQC
         J4xA==
X-Gm-Message-State: AOAM530Hsrp9+uVUum7Gu/BSgGXVVgyKStNdo2swrLCfhSkdBBUqSusD
        SZCoJGwMWU+wf/CJlmx8L8g=
X-Google-Smtp-Source: ABdhPJwu/4BoryeayGd7ByNreZLZztNsbNVBdT/fKy92ljUk/Ozzu1AnOb/HVAiRYhX+teLfmLYNDw==
X-Received: by 2002:a17:907:90d7:: with SMTP id gk23mr7483091ejb.300.1634883326467;
        Thu, 21 Oct 2021 23:15:26 -0700 (PDT)
Received: from localhost.localdomain (i5C74E2CB.versanet.de. [92.116.226.203])
        by smtp.gmail.com with ESMTPSA id w11sm4108710edl.87.2021.10.21.23.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 23:15:25 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Anup Patel <anup.patel@wdc.com>, Atish Patra <atish.patra@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] riscv: do not select non-existing config ANON_INODES
Date:   Fri, 22 Oct 2021 08:15:14 +0200
Message-Id: <20211022061514.25946-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support") selects
the config ANON_INODES in config KVM, but the config ANON_INODES is removed
since commit 5dd50aaeb185 ("Make anon_inodes unconditional") in 2018.

Hence, ./scripts/checkkconfigsymbols.py warns on non-existing symbols:

  ANON_INODES
  Referencing files: arch/riscv/kvm/Kconfig

Remove selecting the non-existing config ANON_INODES.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 arch/riscv/kvm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index a712bb910cda..f5a342fa1b1d 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on RISCV_SBI && MMU
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
-	select ANON_INODES
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
-- 
2.26.2

