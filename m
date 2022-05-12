Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A086525682
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 22:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358426AbiELUpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 16:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355122AbiELUpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 16:45:39 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D38622EA4C
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:45:38 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id i20so5389582qti.11
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KP0IkqliWF7IJ2Jb+iCy0BgntD4ovxiVj1cA0S86+bE=;
        b=LDtaR+pPrCSvdhBsy7kpdY2otl/VPai2Lx4ahg0/fHjlNgzUXucQ92MFlfI+dujFwP
         sZ3/JDAr4BgaJCwBoHUCbO1FOyL0nr91B+9You+11TMt3lNjg2vHVtZhbQbJp0YGLk4c
         7h80/Tc8yRP348/m+zqOW9hgjXbZ98tqz/wl1LPWDlgoSeiyu9F7p8voaJOsq39BnfOp
         lLH+VsgebmhR4sLhGg8OpnajCtyYwRrTmJWXPQXssXIF2Od2xPy4J7FajTwdI+5u4an9
         zkIlHGnaZ6eOqnVGLx9vokoI0nrf98cZoIXqHpRFGbcQS9/gsTJ2QBcYIrJF+bqbgH/7
         FfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KP0IkqliWF7IJ2Jb+iCy0BgntD4ovxiVj1cA0S86+bE=;
        b=KzYVZWzCyvZAfTpAgHC6rkOf6vzgyXvWrhMIOfjaP65qQjfGVq54bR3VLCzl5YH4Ds
         l6B9oGpvNiueZMSIT6GhEQWe2Qs6PaIRSRpU/h+dwAivvmV56i+fBkwRqkPzvJuWuBlw
         fQqvvtCk/0uesloFkk7IaJOVWoM/0n6wX059a3gfdy6YWMzMViQcGxEjBNuRGg83cbDE
         N9fgxRob6MNsoUBI8gnE+TI1m3RrXEIFeE8BzlhLzDaQohz5MKY3Cw/XntdKzTlnoEWR
         x/ys6wOvo++NLtyk9iyG5aLhWRe9rSjdDF3vTpC+4cfNM37nsQJ6NdoCAe8BdpLZRU70
         C5tQ==
X-Gm-Message-State: AOAM5314g2ID5ghEAL5884qG7j7IbxnFExIPc9BWxnR+joSRUlTEVlGc
        VKWJqjfsIfRJ6NnfA5eibtzrcjvDE90izQ==
X-Google-Smtp-Source: ABdhPJyYeIRpvQHPGv8ChNTsbF516O98qijbseqvO1shEWzsx43Wj1PkPhc7ye5NJhGd4wHzf3ZvRA==
X-Received: by 2002:ac8:7f89:0:b0:2f3:b83d:c4e9 with SMTP id z9-20020ac87f89000000b002f3b83dc4e9mr1638206qtj.673.1652388336810;
        Thu, 12 May 2022 13:45:36 -0700 (PDT)
Received: from prithvi.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id s42-20020a05622a1aaa00b002f39b99f687sm402451qtc.33.2022.05.12.13.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 13:45:36 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH] kvm-unit-tests: Build changes for illumos.
Date:   Thu, 12 May 2022 20:45:00 +0000
Message-Id: <20220512204459.2692060-1-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.36.1
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

We have begun using kvm-unit-tests to test Bhyve under
illumos.  We started by cross-compiling the tests on Linux
and transfering the binary artifacts to illumos machines,
but it proved more convenient to build them directly on
illumos.

This change modifies the build infrastructure to allow
building on illumos; I have also tested it on Linux.  The
required changes were pretty minimal: the most invasive
was switching from using the C compiler as a linker driver
to simply invoking the linker directly in two places.
This allows us to easily use gold instead of the Solaris
linker.

Signed-off-by: Dan Cross <cross@oxidecomputer.com>
---
 configure           | 5 +++--
 x86/Makefile.common | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 86c3095..7193811 100755
--- a/configure
+++ b/configure
@@ -15,6 +15,7 @@ objdump=objdump
 ar=ar
 addr2line=addr2line
 arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
+os=$(uname -s)
 host=$arch
 cross_prefix=
 endian=""
@@ -317,9 +318,9 @@ EOF
   rm -f lib-test.{o,S}
 fi
 
-# require enhanced getopt
+# require enhanced getopt everywhere except illumos
 getopt -T > /dev/null
-if [ $? -ne 4 ]; then
+if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then
     echo "Enhanced getopt is not available, add it to your PATH?"
     exit 1
 fi
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
2.36.1

