Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B874CA39A
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbiCBL1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241297AbiCBL11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:27:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1950A606E0
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 03:26:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cx5so1517298pjb.1
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 03:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UyAauvBmSug4drW2djAafs3kx5pIR74OsbYQ7t+MiHk=;
        b=G3vRR8G365996uOtex4UNfFbnEuDaVHAgWCrUpNyIM4K51NwbPFu88Ml+S6bQpgrpt
         Dp8QCr0T5ND4gtwi49Uqy84n9pjftDRTFfx+3BOfaFWLXYl+xipo0YMN92HcFnIhIiOT
         ZEAE2We8PA2ndeExMPYMK5gKkXVwwjklMBeh8MVM4iVd/AGnynGYVxTwYO5THy3Lw8w2
         WXMUsByrIMayIRBeHy8cKq8c+Z5VaTYLTHZVVjLoD7ot5jFwwNpGcTEcX3emRnDtdQ7V
         aIYWAEM9U90bqRfUI3qqaWmz2QxqOaoltrtqnQ/9eubsb/iTkyTxxOUktM4/dQJbFvLC
         Gbjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UyAauvBmSug4drW2djAafs3kx5pIR74OsbYQ7t+MiHk=;
        b=yMySi5tDcBn2bJFvc3OWUGRz2R3ql/xTBQpy+Xgst+IkgdzF9Y9LPZPCf8FPugfIVg
         1yg/W7llxmAzgNNAVeZUEfGzflcReufBzru/vDBnkKw5M6mvBM8peoT80GqSice8vDQt
         qti/ue2e4PnUOl39fvk96ILck8uz4jKFFHiZyRGqu+ETVAOY+wEvsz0AnTTbgFDqSXSv
         Mof0fj/8ElSx2z27hYYEaqkZ9f3BaexdiYbUziZI3CRYtD9xX5JIkM9/zdhmSVEceU1J
         TYIZjeN5DaXBbCaol83YwW95tU8n+XMntXh+mCCN1fM4LhTuCvhj4JZlN2+iBI8R+v4W
         764g==
X-Gm-Message-State: AOAM531+C9WsH6ZMH4vxC7KQpRVOAgx9KrXB7ncCCL0jjwdgwr48rIPE
        5xIx/HEkC50YtYTZgfE+63w=
X-Google-Smtp-Source: ABdhPJzRxPR578U9VrO4mTXK05SGSrj85tZo/tsYiVS7CcggYY/KOOeGbRFGb3h5G6xpzMMwJPQXhQ==
X-Received: by 2002:a17:903:11c7:b0:151:7290:ccc with SMTP id q7-20020a17090311c700b0015172900cccmr11479019plh.95.1646220404646;
        Wed, 02 Mar 2022 03:26:44 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z18-20020aa78892000000b004e19bd62d8bsm21425155pfe.23.2022.03.02.03.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:26:44 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [kvm-unit-tests PATCH RESEND 2/2] x86/pmu: Fix a comment about full-width counter writes support
Date:   Wed,  2 Mar 2022 19:26:34 +0800
Message-Id: <20220302112634.15024-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302112634.15024-1-likexu@tencent.com>
References: <20220302112634.15024-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

Remove two Unicode characters 'ZERO WIDTH SPACE' (U+200B).

Fixes: 22f2901a0e ("x86: pmu: Test full-width counter writes support")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 3d05384..052c2b7 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -587,7 +587,7 @@ static void  check_gp_counters_write_width(void)
 	}
 
 	/*
-	 * MSR_IA32_PMCn supports writing values Ã¢â‚¬â€¹Ã¢â‚¬â€¹up to GP counter width,
+        * MSR_IA32_PMCn supports writing values up to GP counter width,
 	 * and only the lowest bits of GP counter width are valid.
 	 */
 	for (i = 0; i < num_counters; i++) {
-- 
2.35.1

