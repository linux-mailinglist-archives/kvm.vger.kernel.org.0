Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F03854786A
	for <lists+kvm@lfdr.de>; Sun, 12 Jun 2022 05:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiFLD4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jun 2022 23:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiFLD4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jun 2022 23:56:50 -0400
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A83B2B1;
        Sat, 11 Jun 2022 20:56:49 -0700 (PDT)
Received: by mail-pg1-f194.google.com with SMTP id y187so2750408pgd.3;
        Sat, 11 Jun 2022 20:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoaSUf1WFSjsOvPzlBjVzQMptxVWTVe23Qs0wJkHTIY=;
        b=SdrhLUozjMkTO9thtIlaq7kMIP6XZF0IyCAzxR5hUcJRPtRABi3yyMxPjUcRLShXBf
         5cJ6H+8Mjf5JKUWAyykMJBAKQpcdtltEK79njJLDTggHV5IDYoTAf47cmImeIkHS9sYO
         nRebN9Snl8zJ0Fh5nPY5efX0MbFRJ4fN+rL/8n3hPxJJwqNYc4+wIVu/nVimiwcP1F5o
         ibqHW4oijQ0sH4CK5EyEnrZY9GJFw+aavqrzlE+jBcU3aHfcgzGGUrdiyxOzCoM2kofS
         C7nlpY6BtaY7Z6wEz9KeEAU+N4mnrHk3U4qY+nUtKvo4bKzH5zboqs45OKvx9LEI8mdF
         JpWA==
X-Gm-Message-State: AOAM530Z2yvV14wdWiSUWxlpV8wnhq+R/01oZGQd/FlFiwbU9XgYb5ZH
        rOtm4XNGDLJHGBRCfX2FhWZkOOWohw==
X-Google-Smtp-Source: ABdhPJxWn0fONySkSmipTk9dtvqhSDx6JppTqnAeeFggbEXAeWpX+9KP/0coNM8gSDD66P2C7jyj3w==
X-Received: by 2002:a63:2160:0:b0:3fc:b8ac:1976 with SMTP id s32-20020a632160000000b003fcb8ac1976mr47086037pgm.453.1655006208625;
        Sat, 11 Jun 2022 20:56:48 -0700 (PDT)
Received: from localhost.localdomain ([156.146.53.107])
        by smtp.gmail.com with ESMTPSA id n15-20020aa7984f000000b0051bd3d55773sm2370518pfq.63.2022.06.11.20.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 20:56:48 -0700 (PDT)
From:   sunliming <sunliming@kylinos.cn>
To:     isaku.yamahata@intel.com, pbonzini@redhat.com, seanjc@google.com,
        mingo@kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sunliming@kylinos.cn, kelulanainsley@gmail.com, x86@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: x86/mmu: Remove unused "type" of split_page_type()
Date:   Sun, 12 Jun 2022 11:56:41 +0800
Message-Id: <20220612035641.1161945-1-sunliming@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The variable 'type' in split_page_type() is set but not used, so remove
it.

Fixes the following w1 warning:

arch/x86/kvm/mmu/mmu.c:982:28: warning: variable 'type' set but not used [-Wunused-but-set-variable]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 arch/x86/kvm/mmu/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7b3df91a93cf..f4d577335f94 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -979,14 +979,12 @@ static void split_page_type(gfn_t gfn, struct kvm_memory_slot *slot,
 			    enum pg_level level)
 {
 	struct kvm_page_attr *page_attr = page_attr_slot(gfn, slot, level);
-	enum kvm_page_type type;
 	gfn_t base_gfn;
 
 	if (WARN_ON_ONCE(!kvm_page_type_valid(page_attr) || level <= PG_LEVEL_4K))
 		return;
 
 	base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
-	type = page_attr->type;
 
 	/*
 	 * Set the type to KVM_PAGE_TYPE_MIXED in advance since when a large
-- 
2.25.1

