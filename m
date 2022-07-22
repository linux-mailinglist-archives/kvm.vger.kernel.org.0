Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385AB57E2EE
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 16:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiGVOS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 10:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiGVOS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 10:18:57 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEE7A6F98
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:56 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d8so6678631wrp.6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LabL9zieDRj0VzUTnSVQxp5Ep3yS8XLutQqUJnE1wfk=;
        b=JklDJqFjftBTKNNoaqnTOOmvNDD36NuAScKaadfl6iaeWry87wxnq+W9F3sM99VUuu
         ypMUtvoikqWQsuiHgXSy7FC/VjiJSiAyLCwBBtNd5teG+WCJan94QhTNmStv6GjklUBg
         3qzoBgFty9W1QWST/wqE9f0Qv0XBYSSwD57KtmnyBcPLOoy7WgplSVSmji7dDPFMDiw9
         kT4FQDMCsHUBamggDcQIHnscC38Vu0U9IMiMRAQNlzyvMSfH4mmTh1cA0sY0Hd8756U4
         K75295KXKBHALG8nnj7Rjw6/AXu2QUipCYMebFFGOwC5OwlBXoEMmj9jGplxpUt88RM4
         NJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LabL9zieDRj0VzUTnSVQxp5Ep3yS8XLutQqUJnE1wfk=;
        b=mCNQXptcZSJs4xvxRbrLvo99/WXd3yr5gWjZGyKqZQbyUgALwLwr3OGnu/WdhqxhxV
         ZQpxPD7Y7tXKJJc6kvtXUICKv9Bm2Yjz0LjtpZGFAnWRVd7g6IfN1x4Tg/nu53AtbXtH
         fAOJiaj1y33pOVQwg1PxWFox4P5ZlSAo94fBye1VNoZAGvyuKuN4UE57aOMEU32zqwY+
         2WTT8XtC40wLfYoeNMLJKpnVVrPCwmJWDF0iRz8nGDd3uCVw0pLQngQcnfI092uPBjvI
         y9XMI024llW3MMVS2svEacrDjvppq0CUsZR2F6gaAYKSPiXbUriNoVm9UksUbJ9bLPkq
         N3jQ==
X-Gm-Message-State: AJIora+xDmaa+PdJTGQQpdvDC7d+PtzJhWJNeq7EItDykuB9aeN3eeAn
        kCK3UAn54tLs1zh4jYByCPHs5f9kZo7TZQ==
X-Google-Smtp-Source: AGRyM1u+yWlQsWp2hchgGK3q74e8Z8M8KWwH0hSCdkyr3hnAljQ1tDuLseEOAJSKLNG01G3Uv7DwOg==
X-Received: by 2002:a05:6000:186e:b0:21d:ac3c:a066 with SMTP id d14-20020a056000186e00b0021dac3ca066mr104572wri.57.1658499534976;
        Fri, 22 Jul 2022 07:18:54 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id az28-20020a05600c601c00b003a325bd8517sm6379415wmb.5.2022.07.22.07.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 07:18:54 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com, sami.mujawar@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 1/4] Makefile: Add missing build dependencies
Date:   Fri, 22 Jul 2022 15:17:29 +0100
Message-Id: <20220722141731.64039-2-jean-philippe@linaro.org>
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

When running kvmtool after updating without doing a make clean, one
might run into strange issues such as:

  Warning: Failed init: symbol_init
  Fatal: Initialisation failed

or worse. This happens because symbol.o is not automatically rebuilt
after a change of headers, because .symbol.o.d is not in the $(DEPS)
variable. So if the layout of struct kvm_config changes, for example,
symbols.o that was built for an older version will try to read
kvm->vmlinux from the wrong location in struct kvm, and lkvm will die.

Add all .d files to $(DEPS). Also include $(STATIC_DEPS) which was
previously set but not used.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1f9903d8..f0df76f4 100644
--- a/Makefile
+++ b/Makefile
@@ -383,7 +383,7 @@ comma = ,
 # The dependency file for the current target
 depfile = $(subst $(comma),_,$(dir $@).$(notdir $@).d)
 
-DEPS	:= $(foreach obj,$(OBJS),\
+DEPS	:= $(foreach obj,$(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS),\
 		$(subst $(comma),_,$(dir $(obj)).$(notdir $(obj)).d))
 
 DEFINES	+= -D_FILE_OFFSET_BITS=64
@@ -590,6 +590,7 @@ cscope:
 # Escape redundant work on cleaning up
 ifneq ($(MAKECMDGOALS),clean)
 -include $(DEPS)
+-include $(STATIC_DEPS)
 
 KVMTOOLS-VERSION-FILE:
 	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
-- 
2.37.1

