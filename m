Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658C6561589
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 10:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiF3I6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 04:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiF3I6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 04:58:52 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54A0D11C14;
        Thu, 30 Jun 2022 01:58:52 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 8D1741E80D21;
        Thu, 30 Jun 2022 16:57:31 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WR8269BycBpK; Thu, 30 Jun 2022 16:57:29 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 698B51E80CB6;
        Thu, 30 Jun 2022 16:57:28 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        tsbogend@alpha.franken.de
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        renyu@nfschina.com, Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] KVM: MIPS/MMU: Fix spelling mistake
Date:   Thu, 30 Jun 2022 16:58:45 +0800
Message-Id: <20220630085845.74566-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change 'writeable' to 'writable'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 arch/mips/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 1bfd1b501d82..833e5dd97d27 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -541,7 +541,7 @@ static int _kvm_mips_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa,
 			goto out;
 		}
 
-		/* Track dirtying of writeable pages */
+		/* Track dirtying of writable pages */
 		set_pte(ptep, pte_mkdirty(*ptep));
 		pfn = pte_pfn(*ptep);
 		mark_page_dirty(kvm, gfn);
-- 
2.34.1

