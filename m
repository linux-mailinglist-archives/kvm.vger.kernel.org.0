Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5648D57E2EF
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 16:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiGVOTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiGVOS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 10:18:57 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30831A6F8C
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n12so6698323wrc.8
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aDNVolYznPQ7gawMVSW+MxEOx+fNulR9KeeWM3fdad8=;
        b=LQYn1Ea/O7oGvPFHvGR3bWVBj37cXXqYQ/ufN7l+GfoV7kSj4XKVahQhky1ofmYSTK
         wrL8Cou5VCfCLz8tMz8zkY0ZXZdrqa41LKTVmRHTeVulsqFOu1N9v4tZzuJbsEYtUNeK
         94Ia5MxHW2XI6Ghngwu/3+GgbHjF5zSqaEtfSUAka322yJxayUhqufxl5TRYHcrPZkTz
         MKO4DsOe1oAH5GEWOxIeZBrf1f/UFApv3suFS6vE+WqHc5JonanY2eM9YEjBKX6ffe+O
         yP1AJ9l6ows0I0QbYzxUVJqWN3nJlIs5oYuJqZ0u4+Z58qygxHQhKzZEp/+/a53IaNvf
         bbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aDNVolYznPQ7gawMVSW+MxEOx+fNulR9KeeWM3fdad8=;
        b=wVih8Mh7y9j57cLLZwyu+OcQgsO0lAjW2DcTNbFDQRN26imCb7BqIk27J5+b2Hekdw
         3++UidAsnAC/OxSM+DMfzt/QGi3eBwwQDX6pCJ5gqh7UkKy+OmBcGzJT5ku66sV2/DJ8
         0LZ8kgYLhYroxXnp//WOoMti6oF6ELNLS4BCntJJ4xQ/K0qqhoNJu2uYxKXfZ1ndcebX
         OB/UFZHtEXnYNh5hjDUnpyAY7fbWhtrfW3RndhFAeVyt0CTj1rZeFvXphb529VRkdapU
         FUH2gGCKi65q5d15pLFmFkunKf0kGaBx/yStIF4cD3lJWwyPvnW9in12M2fqR+G+QLbA
         taZg==
X-Gm-Message-State: AJIora8N6cI3U4pPT4qEGgoBQudFgvTS8+hz5JeGcPdtyw787rqFlq11
        3RL/a+jmqrZMVlcI2g70HDOiUw==
X-Google-Smtp-Source: AGRyM1vOsPNECwuWez3yZ/ztFYbJebGsxpig0/4/P7Vl630jmmxpEXMKdTwhZhIqwhSkY7KpNoc2lA==
X-Received: by 2002:a05:6000:508:b0:21d:4105:caf9 with SMTP id a8-20020a056000050800b0021d4105caf9mr85687wrf.699.1658499535793;
        Fri, 22 Jul 2022 07:18:55 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id az28-20020a05600c601c00b003a325bd8517sm6379415wmb.5.2022.07.22.07.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 07:18:55 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com, sami.mujawar@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 2/4] Makefile: Fix ARCH override
Date:   Fri, 22 Jul 2022 15:17:30 +0100
Message-Id: <20220722141731.64039-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722141731.64039-1-jean-philippe@linaro.org>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Variables set on the command-line are not overridden by normal
assignments. So when passing ARCH=x86_64 on the command-line, build
fails:

Makefile:227: *** This architecture (x86_64) is not supported in kvmtool.

Use the 'override' directive to force the ARCH reassignment.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index f0df76f4..faae0da2 100644
--- a/Makefile
+++ b/Makefile
@@ -115,11 +115,11 @@ ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
 	  -e s/riscv64/riscv/ -e s/riscv32/riscv/)
 
 ifeq ($(ARCH),i386)
-	ARCH         := x86
+	override ARCH = x86
 	DEFINES      += -DCONFIG_X86_32
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH         := x86
+	override ARCH = x86
 	DEFINES      += -DCONFIG_X86_64
 	ARCH_PRE_INIT = x86/init.S
 endif
-- 
2.37.1

