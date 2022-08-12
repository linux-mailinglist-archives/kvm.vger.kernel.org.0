Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163B8590F72
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 12:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiHLKaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 06:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbiHLKaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 06:30:14 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC430A9;
        Fri, 12 Aug 2022 03:30:11 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 837E91E80D9D;
        Fri, 12 Aug 2022 18:27:59 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id L2B5n7LVHWzq; Fri, 12 Aug 2022 18:27:56 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id D735B1E80CB7;
        Fri, 12 Aug 2022 18:27:56 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH 4/5] kvm/kvm_main: The npages variable does not need to be initialized and assigned, it is used after assignment
Date:   Fri, 12 Aug 2022 18:30:09 +0800
Message-Id: <20220812103009.8362-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20220812101523.8066-1-kunyu@nfschina.com>
References: <20220812101523.8066-1-kunyu@nfschina.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The npages variable does not need to be initialized and assigned, it is
first assigned before it is used.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 82f2b90718a9..f047799bf19b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2516,7 +2516,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 {
 	unsigned int flags = FOLL_HWPOISON;
 	struct page *page;
-	int npages = 0;
+	int npages;
 
 	might_sleep();
 
-- 
2.18.2

