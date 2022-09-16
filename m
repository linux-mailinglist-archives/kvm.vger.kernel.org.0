Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B46B5BA51E
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 05:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIPD1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 23:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIPD1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 23:27:11 -0400
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E4B074E0C;
        Thu, 15 Sep 2022 20:27:08 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15])
        by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66323ed0b9d8-61dc4;
        Fri, 16 Sep 2022 11:27:07 +0800 (CST)
X-RM-TRANSID: 2ee66323ed0b9d8-61dc4
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.97])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86323ed02ed3-af15b;
        Fri, 16 Sep 2022 11:27:07 +0800 (CST)
X-RM-TRANSID: 2ee86323ed02ed3-af15b
From:   liujing <liujing@cmss.chinamobile.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        liujing <liujing@cmss.chinamobile.com>
Subject: [PATCH] KVM: duplicate code
Date:   Thu, 15 Sep 2022 23:26:56 -0400
Message-Id: <20220916032656.6264-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

in "static int FNAME(walk_addr_generic)" function,
there is an explanation that uses two to's, which is redundant code

Signed-off-by: liujing <liujing@cmss.chinamobile.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 39e0205e7300..5ab5f94dcb6f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -472,7 +472,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 #if PTTYPE == PTTYPE_EPT
 	/*
-	 * Use PFERR_RSVD_MASK in error_code to to tell if EPT
+	 * Use PFERR_RSVD_MASK in error_code to tell if EPT
 	 * misconfiguration requires to be injected. The detection is
 	 * done by is_rsvd_bits_set() above.
 	 *
-- 
2.18.2



