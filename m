Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3769FA67
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 18:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjBVRt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 12:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjBVRtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 12:49:24 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DE62A6C0
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 09:49:23 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id w7-20020a170902e88700b0019ca50c7fa3so1862730plg.23
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 09:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DpJmow91+P1uUm2vvVjtoiUyGX/MQ97j5Cxp747w7F8=;
        b=VKSwYh0V4btWDXxmM43GcLyr7Af4gVYu3fZurjR8EXlupFOnv0fKkTU66i4bEECm6R
         A0tibHPcSiAESewarQLiPoCrJTPYCP+epOpVwObr3QR8y8hhqcszctW+A73tfvxCEFpg
         Ar/FvSLTvY7wQQTYWKdLqHNQgLCmYkFxAcnBIcsBn3Tt4iZu9A/yy1tkn4BHe+QbN3q9
         O0a3EstEXV3o+M5RPK75iU+LnigcL/qHYAIVg0LLlAhJltt3BfwJ3CyDq0G+RB2JQNs5
         SNy+2VJkDWI3Td9xPaPj14/TjO5eJs5YFsuYTJkCprptcXGMY9nE32TFQOkZ7eRk0USl
         v2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DpJmow91+P1uUm2vvVjtoiUyGX/MQ97j5Cxp747w7F8=;
        b=c24oh6rTIuSGkB5xROlZ3rUfeICiTWpdhxrI3FxIk3xA3R/funi4MCdaqrIM+psbK3
         CYssWFOV2nfJmtE3NworMqDO3P0IQB7OucCApYVk2wikXfka91eAsQkEvbULY/CX+BqK
         h5xxk0d6K2g/xVXa7rKDZ3BMQ0rVLfTJb5HApFf20SY9J43M8T85PRHuHHrOqnv2JJs1
         J51ahxUfcz95M4K0TwbsKUOaBDP7o69mnmUvPEUb4ize/iVhXrCS824tjKUDuO3jGV3l
         FCTW1TwNGzhkJl07wA3e0H2W/kk5hB5vRQC71OJSeH74wJB+wqyahYgcizgh8kgq+YlK
         eupg==
X-Gm-Message-State: AO0yUKXD3IlPg3GmLg7EdPiuRxVfzrCq1bkXDWEEmbzpVX9vonBdZJj7
        7657sXRGV6MpxiqJbKRoYtpk0YVnavU=
X-Google-Smtp-Source: AK7set9SJT9/oi1RQ9D03sKQtFd7cr9S+1ilJYcb20T1cWv6eUgUEEaiweNDpdbctk9pyNvcC+1btaTxeOI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6aa5:0:b0:4fc:8b10:873 with SMTP id
 x5-20020a656aa5000000b004fc8b100873mr1138892pgu.6.1677088163270; Wed, 22 Feb
 2023 09:49:23 -0800 (PST)
Date:   Wed, 22 Feb 2023 09:49:21 -0800
In-Reply-To: <20230220203529.136013-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20230220203529.136013-1-coltonlewis@google.com>
Message-ID: <Y/ZVoSR0sYyceEAr@google.com>
Subject: Re: [PATCH] KVM: selftests: Depend on kernel headers when making selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023, Colton Lewis wrote:
> Add a makefile dependency for the kernel headers when building KVM
> selftests. As the selftests do depend on the kernel headers, needing
> to do things such as build selftests for a different architecture
> requires rebuilding the headers. That is an extra annoying manual step
> that should be handled by make.

I 100% agree that this is super annoying, but auto-installation of header was
deliberately removed[1][2] (this isn't the first time this type of change has been
proposed[3]) to play nice with an out-of-tree build directory.

Argh, digging a bit deeper, KVM selftests' makefile is all kinds of funky.  It
defines its own header path, LINUX_HDR_PATH, but then also grabs KHDR_INCLUDE
since commit 0cc5963b4cc3 ("selftests: kvm: Add the uapi headers include variable").
That's flawed because KVM selftests will pick up the in-tree headers first, i.e.
out-of-tree builds effectively rely on the in-tree headers not being built.  I'll
send the below as a formal patch.

As for auto-installing headers, for those of us that build directly from the KVM
selftests directory, the best option I've come up with is to add an alias+script
for building selftests and have that do the header installation.

---
 tools/testing/selftests/kvm/Makefile | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 844417601618..01ea083a2cd9 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -186,8 +186,6 @@ LIBKVM += $(LIBKVM_$(ARCH_DIR))
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 
-INSTALL_HDR_PATH = $(top_srcdir)/usr
-LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
 ifeq ($(ARCH),x86_64)
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
@@ -198,9 +196,8 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
-	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-	$(KHDR_INCLUDES)
+	-I$(LINUX_TOOL_ARCH_INCLUDE) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
+	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
         $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
@@ -238,7 +235,7 @@ x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
 
-cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
+cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(top_srcdir)/usr/include include lib ..
 cscope:
 	$(RM) cscope.*
 	(find $(include_paths) -name '*.h' \

base-commit: c57c5ac42480250deb22b306ec6bcbdf0e6b5857
-- 

[1] https://lore.kernel.org/lkml/cover.1657296695.git.guillaume.tucker@collabora.com
[2] https://lore.kernel.org/all/b39b9e0b-45f3-1818-39fe-58921182d957@linuxfoundation.org
[3] https://lore.kernel.org/all/20221219095540.52208-1-likexu@tencent.com
