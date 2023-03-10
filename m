Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594986B3AEA
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCJJlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjCJJkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:40:15 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740715FFA
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:39:46 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYni-00GpVx-DH; Fri, 10 Mar 2023 09:12:34 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Max Chou <max.chou@sifive.com>
Subject: [PATCH 43/45] target/riscv: Add zvksed cfg property
Date:   Fri, 10 Mar 2023 09:12:13 +0000
Message-Id: <20230310091215.931644-44-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
References: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Chou <max.chou@sifive.com>

Signed-off-by: Max Chou <max.chou@sifive.com>
Reviewed-by: Frank Chang <frank.chang@sifive.com>
---
 target/riscv/cpu.c | 3 ++-
 target/riscv/cpu.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 323e0c462b..84a225bf5f 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -114,6 +114,7 @@ static const struct isa_ext_data isa_edata_arr[] = {
     ISA_EXT_DATA_ENTRY(zvkned, true, PRIV_VERSION_1_12_0, ext_zvkned),
     ISA_EXT_DATA_ENTRY(zvknha, true, PRIV_VERSION_1_12_0, ext_zvknha),
     ISA_EXT_DATA_ENTRY(zvknhb, true, PRIV_VERSION_1_12_0, ext_zvknhb),
+    ISA_EXT_DATA_ENTRY(zvksed, true, PRIV_VERSION_1_12_0, ext_zvksed),
     ISA_EXT_DATA_ENTRY(zvksh, true, PRIV_VERSION_1_12_0, ext_zvksh),
     ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
     ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
@@ -1222,7 +1223,7 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
     * in qemu
     */
     if ((cpu->cfg.ext_zvkb || cpu->cfg.ext_zvkg || cpu->cfg.ext_zvkned ||
-             cpu->cfg.ext_zvknha || cpu->cfg.ext_zvksh) &&
+             cpu->cfg.ext_zvknha || cpu->cfg.ext_zvksed || cpu->cfg.ext_zvksh) &&
         !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f ||
             cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
         error_setg(
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 40c4e23209..55bbc4375a 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -475,6 +475,7 @@ struct RISCVCPUConfig {
     bool ext_zvkned;
     bool ext_zvknha;
     bool ext_zvknhb;
+    bool ext_zvksed;
     bool ext_zvksh;
     bool ext_zmmul;
     bool ext_zvfh;
-- 
2.39.2

