Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA24DD53A
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 08:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiCRH3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 03:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbiCRH3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 03:29:22 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501062AC9
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 00:28:04 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r10so10548614wrp.3
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 00:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SbOXNtOmmIfqpr8gpev7N8RGJMhW6VkCzPqWgJ3acHI=;
        b=Q+fKZkSzBhuoHvh9IqBoRVa7tqSmMqseugJbjsu4GSJQglA/YXlvXcJ+Gz5GLKrfo6
         hPCWVZjdkwBDReLRKA9SpiN2Cm19bcuRn/y+pRL6iRhtwFokwlCd5NKTD5HZ0eVOMKAo
         bBYYrI2nK4G/VXinsNXQ+WXEgU1KrvzDLcHRiYxyDV3E8oZEJQQfama74APnviHZjaDo
         KAdDHKF5tSoNVFx4M+cYUNNGIHn4yGXFKpA3aADGTmBrYG5tN4TH/kL4+LGjyBq+QAUL
         n0bgupnTcHIx5D+4yxIvojtYLpj67b9qo/oIHr9BmkBCKCCU706kBtXp2PEH884shNXM
         9/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SbOXNtOmmIfqpr8gpev7N8RGJMhW6VkCzPqWgJ3acHI=;
        b=C6Ki4udFQcDp4AM2IDr0Z3dYL97BaOpepVkaDTnC8QdQ10O12QoRyfd9mn9FVEPelO
         N0tBmrIAXyTnI1txoFVEFskI3RVP0NLl53w2GwqofRBSKR8/OOrRTiPLASVwvkbKYizI
         pXN0Sp0dADNRETSQyVLCCu47W8wNnaB8wmMRiklIp3MO3YrnCskqxv6KdIG+LcpxKcci
         Vd9n4bHCqz+mxLPr0OAJ+h2R3gEaQZ7pkfLin1CZsC3EvCpbvHqjyfKQGiAg4/Kfu0iR
         zqUEzdbKrkxFEAZpOK2DYx8MYW9RH+VnusGSRqu6t4kTGayQYQJtlo/GcP4WwJXwW2em
         U4PA==
X-Gm-Message-State: AOAM532NKOlpTyABejm//xadxF8oEWDtE5UzDS4L7gVJVPRVQhVlDPnt
        7yi1z7SJuFmtvTINcUDZanxazL006M0=
X-Google-Smtp-Source: ABdhPJzYmkDJvRUxPxwbfefLiZLz7hwQXKijkgkc/nP63BhWtIdrK3ouwtYNgfzOfN2+Ajgjqz4Lsw==
X-Received: by 2002:a05:6000:1c06:b0:203:f71c:62a1 with SMTP id ba6-20020a0560001c0600b00203f71c62a1mr1276756wrb.660.1647588482641;
        Fri, 18 Mar 2022 00:28:02 -0700 (PDT)
Received: from kali.home (lfbn-ren-1-1379-66.w86-229.abo.wanadoo.fr. [86.229.226.66])
        by smtp.gmail.com with ESMTPSA id l9-20020a5d6d89000000b00203d62072c4sm6074099wrs.43.2022.03.18.00.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 00:28:02 -0700 (PDT)
From:   Fabrice Fontaine <fontaine.fabrice@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [kvm-unit-tests PATCH] Add --disable-werror option
Date:   Fri, 18 Mar 2022 08:26:52 +0100
Message-Id: <20220318072652.616541-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the user to disable -Werror which can sometimes raises unexpected
build failures.

More information on why -Werror is an issue can be found here:
https://embeddedartistry.com/blog/2017/05/22/werror-is-not-your-friend

This patch is a tentative to find an upstreamable solution to a patch
that is carried in buildroot for more than 5 years:
https://git.buildroot.net/buildroot/commit/?id=0bb0443ee97c61dad1b9e595b0e421de3eed58b9

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 Makefile  |  5 ++++-
 configure | 10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 24686dd..24b50a6 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,10 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 
 COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
-COMMON_CFLAGS += -Wignored-qualifiers -Werror -Wno-missing-braces
+COMMON_CFLAGS += -Wignored-qualifiers -Wno-missing-braces
+ifeq ($(CONFIG_WERROR),y)
+COMMON_CFLAGS += -Werror
+endif
 
 frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
 fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
diff --git a/configure b/configure
index c4fb4a2..8447762 100755
--- a/configure
+++ b/configure
@@ -30,6 +30,7 @@ gen_se_header=
 page_size=
 earlycon=
 efi=
+werror=y
 
 usage() {
     cat <<-EOF
@@ -75,6 +76,8 @@ usage() {
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
 	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
+	    --[enable|disable]-werror
+	                           Disable -Werror (enabled by default)
 EOF
     exit 1
 }
@@ -148,6 +151,12 @@ while [[ "$1" = -* ]]; do
 	--disable-efi)
 	    efi=n
 	    ;;
+	--enable-werror)
+	    werror=y
+	    ;;
+	--disable-werror)
+	    werror=n
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -371,6 +380,7 @@ WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 CONFIG_EFI=$efi
+CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
-- 
2.35.1

