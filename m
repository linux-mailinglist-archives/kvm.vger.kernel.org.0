Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19946661BA
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbjAKRW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbjAKRVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:21:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8CA33D56;
        Wed, 11 Jan 2023 09:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAAEEB81C8B;
        Wed, 11 Jan 2023 17:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F416BC433EF;
        Wed, 11 Jan 2023 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457685;
        bh=nQ/FgwW4vCV/82AO+CiVvxSVywwFvyd81VlYJvv3+mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cu4MF1WU8L/w1VT9eJ9YbvvwI+Npsyq9vX5U3+o8YY37j9vHLXpaHY46RsetWAQ1r
         D/IgBo5kWDJ005wyMDlWxFogQB8ActEQXei0EwPYWaYHnJhGAPBzp7aI/I4g9ShW2i
         xCwZxvgoa2K+B81APqxdPMaa5SLNwyUhMob6jjYE6yngCXRtB3vAwYWDjBk5IymH9h
         gRIIrk9sAMms/3pyqsV5FE8iLFMPIRdaG2cVyAkTrgLg9M0VfDjgKL40FQUj4NlmAy
         4u7lk9K6qWkPCCcaDQnrsbRvADI8G4uMZ1FyEVA2MJM6+3nFJLbKRjEG2kXGG1lNfY
         8K5N+x+lDHHGQ==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH v3 13/13] riscv: remove riscv_isa_ext_keys[] array and related usage
Date:   Thu, 12 Jan 2023 01:10:27 +0800
Message-Id: <20230111171027.2392-14-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230111171027.2392-1-jszhang@kernel.org>
References: <20230111171027.2392-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All users have switched to riscv_has_extension_*, remove unused
definitions, vars and related setting code.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
---
 arch/riscv/include/asm/hwcap.h | 31 -------------------------------
 arch/riscv/kernel/cpufeature.c |  9 ---------
 2 files changed, 40 deletions(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 1767a9ce1a04..e3749bee5c24 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -60,19 +60,6 @@ enum {
 
 extern unsigned long elf_hwcap;
 
-
-/*
- * This enum represents the logical ID for each RISC-V ISA extension static
- * keys. We can use static key to optimize code path if some ISA extensions
- * are available.
- */
-enum riscv_isa_ext_key {
-	RISCV_ISA_EXT_KEY_FPU,		/* For 'F' and 'D' */
-	RISCV_ISA_EXT_KEY_ZIHINTPAUSE,
-	RISCV_ISA_EXT_KEY_SVINVAL,
-	RISCV_ISA_EXT_KEY_MAX,
-};
-
 struct riscv_isa_ext_data {
 	/* Name of the extension displayed to userspace via /proc/cpuinfo */
 	char uprop[RISCV_ISA_EXT_NAME_LEN_MAX];
@@ -80,24 +67,6 @@ struct riscv_isa_ext_data {
 	unsigned int isa_ext_id;
 };
 
-extern struct static_key_false riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_MAX];
-
-static __always_inline int riscv_isa_ext2key(int num)
-{
-	switch (num) {
-	case RISCV_ISA_EXT_f:
-		return RISCV_ISA_EXT_KEY_FPU;
-	case RISCV_ISA_EXT_d:
-		return RISCV_ISA_EXT_KEY_FPU;
-	case RISCV_ISA_EXT_ZIHINTPAUSE:
-		return RISCV_ISA_EXT_KEY_ZIHINTPAUSE;
-	case RISCV_ISA_EXT_SVINVAL:
-		return RISCV_ISA_EXT_KEY_SVINVAL;
-	default:
-		return -EINVAL;
-	}
-}
-
 static __always_inline bool
 riscv_has_extension_likely(const unsigned long ext)
 {
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index c394cde2560b..5591d45e96b5 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -29,9 +29,6 @@ unsigned long elf_hwcap __read_mostly;
 /* Host ISA bitmap */
 static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
 
-DEFINE_STATIC_KEY_ARRAY_FALSE(riscv_isa_ext_keys, RISCV_ISA_EXT_KEY_MAX);
-EXPORT_SYMBOL(riscv_isa_ext_keys);
-
 /**
  * riscv_isa_extension_base() - Get base extension word
  *
@@ -266,12 +263,6 @@ void __init riscv_fill_hwcap(void)
 		if (elf_hwcap & BIT_MASK(i))
 			print_str[j++] = (char)('a' + i);
 	pr_info("riscv: ELF capabilities %s\n", print_str);
-
-	for_each_set_bit(i, riscv_isa, RISCV_ISA_EXT_MAX) {
-		j = riscv_isa_ext2key(i);
-		if (j >= 0)
-			static_branch_enable(&riscv_isa_ext_keys[j]);
-	}
 }
 
 #ifdef CONFIG_RISCV_ALTERNATIVE
-- 
2.38.1

