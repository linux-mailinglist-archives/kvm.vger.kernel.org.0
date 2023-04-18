Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1D76E67A4
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjDRO5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 10:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjDRO5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 10:57:02 -0400
X-Greylist: delayed 2041 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Apr 2023 07:56:54 PDT
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E364BBA6
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 07:56:54 -0700 (PDT)
Received: from [167.98.27.226] (helo=rainbowdash)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pomEF-000Ub8-Ed; Tue, 18 Apr 2023 15:22:43 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
        (envelope-from <ben@rainbowdash>)
        id 1pomEF-0066nU-0Q;
        Tue, 18 Apr 2023 15:22:43 +0100
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     kvm@vger.kernel.org
Cc:     linux-riscv@lists.infradead.org, ajones@ventanamicro.com,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH kvmtool 1/2] riscv: add mvendorid/marchid/mimpid to sync kvm_riscv_config
Date:   Tue, 18 Apr 2023 15:22:40 +0100
Message-Id: <20230418142241.1456070-2-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
References: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the ONE_REG for the mvendorid/marchid/mimpid from the kernel
commit 6ebbdecff6ae00557a52539287b681641f4f0d33, to ensure the
struct is in sync with newer kernels for adding zicboz.

Ref: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/id=6ebbdecff6ae00557a52539287b681641f4f0d33

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 riscv/include/asm/kvm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 8985ff2..92af6f3 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -49,6 +49,9 @@ struct kvm_sregs {
 struct kvm_riscv_config {
 	unsigned long isa;
 	unsigned long zicbom_block_size;
+	unsigned long mvendorid;
+	unsigned long marchid;
+	unsigned long mimpid;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
-- 
2.39.2

