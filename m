Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAAB7271ED
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjFGWp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjFGWp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:45:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0626119AC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 15:45:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb39aebdd87so128831276.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 15:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686177926; x=1688769926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1+MCqRHVNOx8W0kVp/VmN1Saomw+ZEFw4eyiGWfCUqk=;
        b=NPTep/eSq/8ePDH5Ce7IvCAKq8+wE6+eAcPZUxUU1JodNoE1DBdE9hasFa5OX20dIk
         p+CAvcoGml3CZLXA6gg7ZxrBivhsGWDztx3hNPwrXVLUXX3fGuqAzLJ3DkgeF6A9eCS3
         R+tQ+g5KLe4tPXhhL/5t7sFai+NWihGKmBWQsDlMy7bqoBGw0QcZfSlGdZRFs8HjnGzm
         MohmsFG0GpvJ/RlskUq7llqm7gI0VkN4Ce5KekHhbmK468/AmotHQa/TYY5UjxsVuB8A
         tLNxfwAgi0jdfdo6q/bntl6o2oL2/tJHKOWLenRWxd/7mtLp+BE6V8EmtB/kSic29y2W
         65jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686177926; x=1688769926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+MCqRHVNOx8W0kVp/VmN1Saomw+ZEFw4eyiGWfCUqk=;
        b=BrVV+SKbo2wbNqYqL2zW7lGL2LlUtA2JmO1b7j7zz/i4ZY2abVz8kP+w1w36SKXyEC
         T/d0ffUIN9ohMTRvziek2rv4P9FWwlcS5c++cUZs0/8S9qUxajnQp3EA7Q5scFMiOZFH
         7+X3WIEapiABUdCrNJ2Ani4N9cynK50NsHa1IdUvSTw42uQbnpFjKoCQlCEP6cYuhnJZ
         vt9FfbUD0zyQYO5khqk80UhOOgNluPp1FRF1pAbhjAbCdepDfDI7GtlPHbsjwbDUaBGo
         LzZR1aMsa4ckZlbbhbXg6woKR/W/EHXCyLIjzOtVPdrUgbDUn/4mHYhd0uyA8syYDARI
         YTMg==
X-Gm-Message-State: AC+VfDwhVqKUw2JWJFUbHGiNazxoqK72v7/gL5ctvY+X55Yuhog3IuzH
        t1JxuatZ8ZP2Sf2lLEJmY9f5GksnCdmvtiQ1EP/UqTndDrO7PiiZHSHv24366tnXJCMchhRv8fV
        fsD+Sw4zmDxZ1IZsx2A1AvWNJySBwfUwx8BhPEeDxdLTU7EZTonuxQSGz34GXqMjwS1y6
X-Google-Smtp-Source: ACHHUZ5/pC61pIo71Xy5814qFBDhuiVbOKRtzTXhNZWRQwz6wuog8bNqIfKBWIZG67J0HTA4XRY997jNaFrOV3AM
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:1826:b0:bac:adb9:40b7 with
 SMTP id cf38-20020a056902182600b00bacadb940b7mr245111ybb.5.1686177926213;
 Wed, 07 Jun 2023 15:45:26 -0700 (PDT)
Date:   Wed,  7 Jun 2023 22:45:16 +0000
In-Reply-To: <20230607224520.4164598-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607224520.4164598-2-aaronlewis@google.com>
Subject: [PATCH v3 1/5] KVM: selftests: Add strnlen() to the string overrides
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
index ee41ff0c5a86..adbf94cbc67e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -200,6 +200,7 @@ endif
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
2.41.0.rc0.172.g3f132b7071-goog

