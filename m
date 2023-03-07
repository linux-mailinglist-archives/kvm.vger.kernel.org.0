Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6E66ADD42
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCGL27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjCGL2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:28:50 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72D6360B2
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 03:28:47 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so10162656wmb.5
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 03:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yM2KjYGD7orZo6AEu6pU16rn3FTr1UxycOe1pdtgZ0A=;
        b=CuiKwmsUbs1gOBp7lmR93X4YFwAkwCqLH18nTj+qtUxbAcM4ElK5XPZq14ef1z2OaC
         NZsa4V8rz9PS2Vf/wHAa3u4O+gdlkogCyqk9Ih17YShaYv+sqfmI8w/sHyXKafRXgZW5
         SpOruP7QCCOYG8nZdxqxKv5JTBsWbR60HcKBLPDqxPISm2VS8QhPp6n5/hM3s5/ayBXl
         nbNdWT9Dcyq8j6SwPf5kKtQCXtVKhayMdh4PVKBrH1h2T/C43gjQRpQnFgqu5gs0OJ26
         5dF0hiipnwxX4XxnQl6wdxr+zvFvppsa8Afjdpc36n3ZkdRI8irs/SPQ+Z+023zV/zZK
         b6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yM2KjYGD7orZo6AEu6pU16rn3FTr1UxycOe1pdtgZ0A=;
        b=3600ALIBICLUsbosrvuosiQuNUEor2E3+CVaHkcKIjcZquw4BgqzRXIdxIEBsuimN0
         MyaNhHt4gbEzoSH9lxYGqQYQ4/vDoHnX++TBsFG2iy6NXLkv7qSRYoigCl2WQ30WYCg+
         oCfNAkYKRraJRj6gtz4ewcGdSr9fmIRQ7Kl+Z86TlBD8hNhYugmpxTyphXf8oLKLGraJ
         bhCC6Y6MLpe+hT3IO+jMTIgrI8eHRLdC8de7R8Pnvs+xubnxRaiVEVqIkeONRJJvF9iK
         jMMzrYCTOwZXLDhDGgc+of7iJc8yE3LX1w+r/zX6KAFyUdrwTCpZa9KibunQnJL/L6WT
         lL+Q==
X-Gm-Message-State: AO0yUKUdTahVZ3UhPQxHUaXcaFM/GMPjvAODXBXAx7XPjGzFJXrX6RmH
        Xmk7pnf7qNJlL7anb2hDedptKg==
X-Google-Smtp-Source: AK7set88BxEHbelSNh6ps8DSC6iaP2PD0fl51x4goNDO94VTcB1EXG+zzvc+L+VzA474e1nRXT5I/A==
X-Received: by 2002:a05:600c:35d2:b0:3ea:f6c4:5f2a with SMTP id r18-20020a05600c35d200b003eaf6c45f2amr11517830wmq.17.1678188526216;
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id h6-20020a1ccc06000000b003e118684d56sm17047627wmb.45.2023.03.07.03.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:45 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9FED91FFB8;
        Tue,  7 Mar 2023 11:28:45 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v10 1/7] Makefile: add GNU global tags support
Date:   Tue,  7 Mar 2023 11:28:39 +0000
Message-Id: <20230307112845.452053-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307112845.452053-1-alex.bennee@linaro.org>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If you have ctags you might as well offer gtags as a target.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>

---
v10
  - update .gitignore
---
 Makefile   | 5 ++++-
 .gitignore | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6ed5deac..f22179de 100644
--- a/Makefile
+++ b/Makefile
@@ -145,6 +145,9 @@ cscope:
 		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
 	cscope -bk
 
-.PHONY: tags
+.PHONY: tags gtags
 tags:
 	ctags -R
+
+gtags:
+	gtags
diff --git a/.gitignore b/.gitignore
index 33529b65..4d5f460f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -12,6 +12,9 @@ tags
 patches
 .stgit-*
 cscope.*
+GPATH
+GRTAGS
+GTAGS
 *.swp
 /lib/asm
 /lib/config.h
-- 
2.39.2

