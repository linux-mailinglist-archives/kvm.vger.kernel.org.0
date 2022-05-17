Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2957B52AB7B
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352501AbiEQTFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352500AbiEQTFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFA04ECC3
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q17-20020a656851000000b003c66b4c5d54so36365pgt.6
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6YlkJV/T5mcjduBBp9QBuhMyd/oE9TQS23+/anwwZk0=;
        b=j6dZh6yLsqom/8TT5Agx6SRA7Tj1asUR9CBz6vxv1aVEOIeac0DWO0oqSe75lT1a0l
         jl2cSfuhBg2Z4U1npHh99sKD4Q8avpn68nhZ4xfmdy5U3LomUwn/hNE4JxmGoGYe6bE4
         A6iFDyvZldT1RISoJ/kiZEuOXwNtV4uPQJaUl/rncFdtRdUa6CAZtLuur5m9ldYzre1c
         IKRgBKCKIuXX1bEbFkxLuwGcECvYaOIpYLRbu82Rp/HSUj9h88Ky1Bl7ANhvGYdbyLJh
         un3kLLDi3JN8pvsHqAogOPfpEnkA9RldAvv8WjiQQjQxT5eWgv7JY1uqznLz14pCZNmh
         Tghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6YlkJV/T5mcjduBBp9QBuhMyd/oE9TQS23+/anwwZk0=;
        b=fedYBUQNx4yL4uNwM7y+dQrQxHKV90ITDGhunBvTZQvC5uoEFsa8NNLYMMLZT6kWBG
         obQO7OMPbCLUsiVC/3idmofTH95+hXxJh5rJpHhMgaoovFnrQQPY1nQ19kBuya/SCF9L
         4SEM2hLEn6+S97gf3mwWgLybYqQtg/Nhac5B7IvOMsytKdZYKopwTcRfpwg0Z7vs94TQ
         5zlXm+2ENY7N6ZV0D8xVF8bM0iJXp5XGPjGDDnpe6PEDw6DyqxyYlKhTMK0FtZlnPWsD
         6NH58pCEchFitMP+RTx6Qxo/i/7ttyIGsL3VfsBA3vj4pFEjDc7sNZ8l25utnnQvxb/v
         vhpw==
X-Gm-Message-State: AOAM531+EFGCmVth9zn9ow5+UJTmfF+TMOSjFk34azKobk8o1clMkSNQ
        S1yCUvvdk40znisB0sqOsEPtABpfMv+fxQ==
X-Google-Smtp-Source: ABdhPJwd+cSZ5X7CiNRk7yEjyGl9P5mm4DO6RCuJqcaFfrQkvhZOEgb36BoGpCSrWDwBsS2cdXarclyqpRHMdw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:82d9:0:b0:4fa:2c7f:41e with SMTP id
 f25-20020aa782d9000000b004fa2c7f041emr24156849pfn.1.1652814338775; Tue, 17
 May 2022 12:05:38 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:22 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 08/10] KVM: selftests: Drop unnecessary rule for $(LIBKVM_OBJS)
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the "all: $(LIBKVM_OBJS)" rule. The KVM selftests already depend
on $(LIBKVM_OBJS), so there is no reason to have this rule.

Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index cd7a9df4ad6d..0889fc17baa5 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -189,7 +189,6 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
-all: $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
-- 
2.36.0.550.gb090851708-goog

