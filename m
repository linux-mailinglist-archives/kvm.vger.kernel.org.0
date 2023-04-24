Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EEE6ED83B
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjDXW7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbjDXW7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:59:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BB36E82
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:00 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2470e26b570so2854595a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682377140; x=1684969140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KTxwJNyDzO4UQd4QGSqMyj1j0pyih/Zhsb1jsC7qgpI=;
        b=NEkf0cAW8ZSrwtJ2y/ot+bzX0ZgQzh1kxJ7vhFkZdPyeNXQtN+WE2BsBlPqOdtz/QB
         Mc3mWAevT8lh0G1+2SLnG94Kj2R0Mqd8V4dMO9gmfx6YotS6FCHwmyvxqMnbcVhuc13P
         h8kjt7vUvrhMgSI8kWVhw7p8y+4PEtvHQm7oUQiEr1XowfrVgn9HAbwK7lKOIU9l38Fl
         7tUsc6fEE4QTNsBSQcXAdAzQpZDzSopWy2KA9eNOFwcpN7GrM+xOTpooLsWnUD9cP/5p
         W+pvK2Zj9mXqEdvJpZKKrpzTHASFUbGAZRBfNacfkmZT3WFrBfeyJIDrRYWrMERQ5LyI
         bX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377140; x=1684969140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTxwJNyDzO4UQd4QGSqMyj1j0pyih/Zhsb1jsC7qgpI=;
        b=dwFzkiGGyMa+HLBgDFpl85q40iS9RoiGbVE9widDYalAq89/s92BN2OXxjRqmDVa9d
         eA80rya3Z+yDTfqNL/xcNOqXJfU4sJkkPJspFbUYMjwYbkpwuxY0X+wfIfaBrMaWdkms
         LuGeRTM/on1J9BuIo2AMLQ/z+M4arsWPosfZ1CxhkQcid2WQl5Fmv2QZxeAlLmVA1ViZ
         /J2reD69dW2U7w1gbIuvIGsEnaixiijxMkguBdIDD6timgGkiRqRc5zx+LkuBc4cErEx
         TKcGpmidEzfnxYR8JllA96JQ1f4Lk99yGY9RfU9T6hi994FLRlO1cg/GaNPVUiJCIS/1
         OvgQ==
X-Gm-Message-State: AAQBX9enqZ/ANJ/FaCtrHXyeEnO1fxds/cdqBKpjuvddzRkZZAgebDcI
        2uS2gNiIpBjXLkZP59tY5V1ZfTkFjh4KE0ECdjPxEUC3/lL0VA+M9SQWa+7AYDgKCdwA+P47k09
        bs84wAxYYW8F4purH/wBqkeccAazOZyiAig4AENP9k0A+HqsS31TNAMG803j2F5f954Aa
X-Google-Smtp-Source: AKy350ZdbJvnQ7+JhyxGMnWDNU/wJRH+qY+szhq5fh73l4sATab+S3fbjerdGg/dMPzc2LDL/qVUEWYvj/2H+2RA
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:9c5:b0:247:96d9:eb40 with SMTP
 id 63-20020a17090a09c500b0024796d9eb40mr3545056pjo.3.1682377140043; Mon, 24
 Apr 2023 15:59:00 -0700 (PDT)
Date:   Mon, 24 Apr 2023 22:58:49 +0000
In-Reply-To: <20230424225854.4023978-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424225854.4023978-2-aaronlewis@google.com>
Subject: [PATCH v2 1/6] KVM: selftests: Add strnlen() to the string overrides
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Add strnlen() to the string overrides to allow it to be called in the
guest.

The implementation for strnlen() was taken from the kernel's generic
version, lib/string.c.

This will be needed when printf() is introduced.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile              | 1 +
 tools/testing/selftests/kvm/lib/string_override.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 18cadc669798..d93bee00c72a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -198,6 +198,7 @@ endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
+	-fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
diff --git a/tools/testing/selftests/kvm/lib/string_override.c b/tools/testing/selftests/kvm/lib/string_override.c
index 632398adc229..5d1c87277c49 100644
--- a/tools/testing/selftests/kvm/lib/string_override.c
+++ b/tools/testing/selftests/kvm/lib/string_override.c
@@ -37,3 +37,12 @@ void *memset(void *s, int c, size_t count)
 		*xs++ = c;
 	return s;
 }
+
+size_t strnlen(const char *s, size_t count)
+{
+	const char *sc;
+
+	for (sc = s; count-- && *sc != '\0'; ++sc)
+		/* nothing */;
+	return sc - s;
+}
-- 
2.40.0.634.g4ca3ef3211-goog

