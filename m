Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48C9516005
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 21:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244433AbiD3TPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 15:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbiD3TPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 15:15:02 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBDB51332;
        Sat, 30 Apr 2022 12:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uJF7w0KVfCE/YA1nGgKtXl1p7lo511Mm0AmaJ0sR/yk=;
  b=eQBk0LYzQjD6XGO4wy1hoKaVqmTjjWoetmyGs+Cz90N0tC6OjrITc/od
   rro6gWjwNjE8QcRomslEDFe9YpTFv2tWfOlCYi15NTOQYOMMkVA1emIC9
   yhBNfViZV5FwOHNeSme3Wg1bbXIOQGPHCGvX7ahrxldHe4lLwphv00Bpc
   Q=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,188,1647298800"; 
   d="scan'208";a="34084619"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2022 21:11:33 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Anup Patel <anup@brainfault.org>
Cc:     kernel-janitors@vger.kernel.org,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] RISC-V: fix typos in comments
Date:   Sat, 30 Apr 2022 21:11:20 +0200
Message-Id: <20220430191122.8667-6-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 arch/riscv/kvm/vmid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 2fa4f7b1813d..4a2178c60b5d 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -92,7 +92,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
 		 * We ran out of VMIDs so we increment vmid_version and
 		 * start assigning VMIDs from 1.
 		 *
-		 * This also means existing VMIDs assignement to all Guest
+		 * This also means existing VMIDs assignment to all Guest
 		 * instances is invalid and we have force VMID re-assignement
 		 * for all Guest instances. The Guest instances that were not
 		 * running will automatically pick-up new VMIDs because will

