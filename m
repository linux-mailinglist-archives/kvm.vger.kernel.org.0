Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0B16378EF
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiKXMcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiKXMcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:32:11 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DA34A5BC
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:32:10 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so5017147pjs.4
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FA9FjjZ5D2eW+Rh+VzljTwaj+HI+o8no90Vzz6+CSqM=;
        b=fVt7pgRFKM1IppGlaB6ASS9Q6huUnib/Ja1MO68QU4EE+pnVD6fXb+X/fyIej1Jht5
         NqfL798atpZGI5HUZsvrfschj4YvWTCC8UaZa12Kl4aDmwMUamVXS59slngOzH/jHKdP
         mNpEojxFQEfDwZgzLIiWdRc70NtZK5lqgCfzmNIsEUK2NGkEK6pJrGYambiYMAe8vGLA
         s323ppEGnGuOh+BALUhdOOh0dfcEqIKeRbTPqdtrfHrCWdno/lvihPv66g0iLAte/1eh
         mPz0t2I1LM3RiP9nMc6R9x+8fAvkKSfIYmiGz2iTpO4Soc37lJaSMB+QYQ/bET89cvMk
         tQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FA9FjjZ5D2eW+Rh+VzljTwaj+HI+o8no90Vzz6+CSqM=;
        b=kxgfTXryfkCEUJrgCp7X8RFosSmIND9OUrVGnTMtyVpNKJ5axYHsQyctJ2GseR0yty
         86e66prIZEoDzR/RkyuKdWYpZ9tv1mV6xuNWMLP9nbJgeP1qakN8BxTU4C7JFJAFfLx5
         uozteUJ34kIa/k9O0/ucEq/W+x11Fk8BgQ81ReCrVqd5yQuI8P1CK0MoGbAxgSG6dlOo
         TW7r1rktLQj70HPUUBmQXObCOvrq7uD3zPla+GKcT04S1ZOz8XxzkEmjTW50Ty7jmqr4
         7h3dJCAM1IM/bP1FvAJNAMmGp9v4B4v/UPLXFAhFdDNQm78MQQ6NWR219Pg/g8QENkMv
         fHjQ==
X-Gm-Message-State: ANoB5pmwzBX4L3eWVt7fN7zCHatYHF21aZmHqcZbhX06cvUgeBgoWaef
        w+oGdywGGEpGhztkiWxJIQbK1Ylc5Dd+gQ==
X-Google-Smtp-Source: AA0mqf6QeDhFQkiJa5LDatvlmGTO6LRWMahcsXTapziRGL/ILJHLRn+ZQQRrGIR8CjY8vz3YpPSutw==
X-Received: by 2002:a17:90a:d38c:b0:214:ba3:4eb1 with SMTP id q12-20020a17090ad38c00b002140ba34eb1mr42491043pju.161.1669293130045;
        Thu, 24 Nov 2022 04:32:10 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t3-20020a1709027fc300b0018934d1ed31sm1162258plb.177.2022.11.24.04.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 04:32:09 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] lib: x86: Use portable format macros for uint32_t
Date:   Thu, 24 Nov 2022 20:31:49 +0800
Message-Id: <20221124123149.91339-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Compilation of the files fails on ARCH=i386 with i686-elf gcc on macos_i386
because they use "%d" format specifier that does not match the actual size of
uint32_t:

In function 'rdpmc':
lib/libcflat.h:141:24: error: format '%d' expects argument of type 'int',
but argument 6 has type 'uint32_t' {aka 'long unsigned int'} [-Werror=format=]
  141 |                 printf("%s:%d: assert failed: %s: " fmt "\n",           \
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use PRId32 instead of "d" to take into account macos_i386 case.

Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
Nit, tested on macOS 13.0.1 only instead of cirrus-ci-macos-i386.

 lib/x86/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 7a9e8c8..3d58ef7 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -457,7 +457,7 @@ static inline uint64_t rdpmc(uint32_t index)
 	uint64_t val;
 	int vector = rdpmc_safe(index, &val);
 
-	assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
+	assert_msg(!vector, "Unexpected %s on RDPMC(%" PRId32 ")",
 		   exception_mnemonic(vector), index);
 	return val;
 }
-- 
2.38.1

