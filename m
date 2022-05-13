Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F2C52593E
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 03:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376275AbiEMBG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 21:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376279AbiEMBGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 21:06:20 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E17041F96
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:06:19 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id c1so6048520qkf.13
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OjjY2Dy4GLZuLCCYpACYir1hiB3WugR5A1xH69ZEgIM=;
        b=Hwr4t1mkXAcDTk5JFHqjrwedZg2MP3wTbfrpKE6V0jg7Mpv5pKElpH5HsZw0uqOhxM
         mnULt754SjTleWI++GGtU4HUy9GY7yAbYTmG6jyZrONIi9OJh39jSCLDORe7CfCQ3PLX
         qUlWI+1VFwcV2Md12WTi0Sedd/9AZgumPHpvIC3hLtEy1avTN0WluE8f08eIma6AxQG/
         DoEPdPDH7MY3krKFoBu0qFfR8jlaT0tsO7rA1YvmI+nB5D4lv3UfYDgJO4ANddwBwqyU
         LY2dt09Vk9uPfx6WZBveVizRaq6Ga2fCMR9RdEoDHH3bApGahGpSw5r81ApaA09DQhAH
         kxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OjjY2Dy4GLZuLCCYpACYir1hiB3WugR5A1xH69ZEgIM=;
        b=GNomoIJmJ2J5Bn2q0nakPIoBMbfjaoP+EgBNTS/6bLPFszbhIgR/uH4xmUEFH6DWL1
         oJ21uk8GYgVjYxSOOmchIJXUL6jgEPj9AiH6NsaUYv2nQFtKZEtjCHhBBFhHvF54+4bi
         kyTbIbwUEHZlHZDLq8Zr305OzLZEGFlsjsGqRX6YI7A4spFpR4fiJ2oqUTqcRXozJGKt
         tsIYHti9cQ/yoOQ5oOLPUKTG8MWPAjl5OGLmxlGN1OI1pm7UvCmM17bxYxA4hKTLpJ70
         PD7luU0e8ywP3ikCoOAKo2jpk9mCK7+W0XzeSmcKIsrep4BYqiRbLDHTFXswF7tGMS/O
         Ui0A==
X-Gm-Message-State: AOAM5323RgeDG/WnfkZO/b6SseSzv8jgF8dovZiy5RNcfKJykoxTKKHT
        2FGZTuP2/hM9L5wwElPvTqi/Z8gQ3JcI/Q==
X-Google-Smtp-Source: ABdhPJyXOCyfV2B8dPXdFhr2zPTczBJzT0FMCRTF7S3344/uC5UVdmr53dEztyM4cP42XSxPsR1TCA==
X-Received: by 2002:a05:620a:4708:b0:6a0:42da:a46f with SMTP id bs8-20020a05620a470800b006a042daa46fmr2038473qkb.469.1652403978256;
        Thu, 12 May 2022 18:06:18 -0700 (PDT)
Received: from doctor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id cc6-20020a05622a410600b002f39b99f6b2sm619130qtb.76.2022.05.12.18.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:06:17 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH 1/2] kvm-unit-tests: invoke $LD explicitly in
Date:   Fri, 13 May 2022 01:07:39 +0000
Message-Id: <20220513010740.8544-2-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220513010740.8544-1-cross@oxidecomputer.com>
References: <Yn2ErGvi4XKJuQjI@google.com>
 <20220513010740.8544-1-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change modifies x86/Makefile.common to allow building on
illumos; I have also tested it on Linux.  This switches from
using the C compiler as a linker driver to simply invoking the
linker directly in two places, allowing us to easily use gold
instead of the Solaris linker.

Signed-off-by: Dan Cross <cross@oxidecomputer.com>
---
 x86/Makefile.common | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index b903988..0a0f7b9 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,7 +62,7 @@ else
 .PRECIOUS: %.elf %.o
 
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
-	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
+	$(LD) -T $(SRCDIR)/x86/flat.lds -nostdlib -o $@ \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
@@ -98,8 +98,8 @@ test_cases: $(tests-common) $(tests)
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
-	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	$(LD) -m elf_i386 -nostdlib -o $@ \
+	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
 $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
-- 
2.31.1

