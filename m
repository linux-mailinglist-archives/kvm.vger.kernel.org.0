Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B16687E78
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 14:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjBBNUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 08:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjBBNT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 08:19:59 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3678C1E5
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 05:19:57 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvK-004Q6t-92; Thu, 02 Feb 2023 12:42:43 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 28/39]  target/riscv: add zvksh cpu property
Date:   Thu,  2 Feb 2023 12:42:19 +0000
Message-Id: <20230202124230.295997-29-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>

Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
---
 target/riscv/cpu.c | 4 +++-
 target/riscv/cpu.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 5076699226..9a412d9d53 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -104,6 +104,7 @@ static const struct isa_ext_data isa_edata_arr[] = {
     ISA_EXT_DATA_ENTRY(zvknha, true, PRIV_VERSION_1_12_0, ext_zvknha),
     ISA_EXT_DATA_ENTRY(zvknhb, true, PRIV_VERSION_1_12_0, ext_zvknhb),
     ISA_EXT_DATA_ENTRY(zvkns, true, PRIV_VERSION_1_12_0, ext_zvkns),
+    ISA_EXT_DATA_ENTRY(zvksh, true, PRIV_VERSION_1_12_0, ext_zvksh),
     ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
     ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
     ISA_EXT_DATA_ENTRY(smaia, true, PRIV_VERSION_1_12_0, ext_smaia),
@@ -800,7 +801,8 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
          * In principle zve*{x,d} would also suffice here, were they supported
          * in qemu
          */
-        if ((cpu->cfg.ext_zvkb || cpu->cfg.ext_zvkns || cpu->cfg.ext_zvknha) &&
+        if ((cpu->cfg.ext_zvkb || cpu->cfg.ext_zvkns || cpu->cfg.ext_zvknha ||
+             cpu->cfg.ext_zvksh) &&
             !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f || cpu->cfg.ext_v)) {
             error_setg(
                 errp, "Vector crypto extensions require V or Zve* extensions");
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index ebee902806..92624bfc57 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -465,6 +465,7 @@ struct RISCVCPUConfig {
     bool ext_zvknha;
     bool ext_zvknhb;
     bool ext_zvkns;
+    bool ext_zvksh;
     bool ext_zmmul;
     bool ext_smaia;
     bool ext_ssaia;
-- 
2.39.1

