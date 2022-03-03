Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AA04CC9DD
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiCCXM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbiCCXMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:12:24 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8887FA0BE9
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:11:38 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id u20so11154819lff.2
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HExtPNOOGsZ27tIV7KyWHUbKgy1omlMDtnwSMdGi6kM=;
        b=jPmZ62UpEANcrNDe/jDx0O830rxNDt/SLjzWAtqjwkB5D372Pev06+0icLNNrMjlQd
         jkkg7GmCt5Jc1BuNsh0WVQrv77LxTH9q2BZPZG8NgrRr43Czv1aSfl7NCMPE4L3gKTSA
         sR+v4Crjet8T7xCTGoA8eTDwokIOcwa8kQR6k/nsK+Jdk0FFdSE3OXqCeKRgcib6UKrc
         74iMlbKvrq+FhagtJ/tmzA7arLF6EtU7gMZDKBVeQ40aPgqs2MXvFRIWNtFx4U5Cbu5W
         k3djjNJ4HGyoJrVdFOrQT+ACY/4ao2HEJUKd7lXkKg/aPdwsWTK2B7NyKqly1EZhoVdi
         t10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HExtPNOOGsZ27tIV7KyWHUbKgy1omlMDtnwSMdGi6kM=;
        b=WCWsm/S54S1Z/eOeh3u/76HIpAoLkuexdrkYbXldTDFAexK/NIdfU9MSrC8S9QJQ1K
         UgfkfOCPRPiMXUYNfL8uQHLRz/aBipVyBDc19NTENf2yJEfzWvXpa79v/t+JYeugvjTf
         faVm1pFoP5GHOWoryyKQxqC+9aT/tOMtyAZvreqUgx8tLAxFpOLMMTqBiuxltvmM5fl4
         /RUrreOdyXzHSf8m436HDVnf98L23mBsA1AaL086Wx2evlpL71cqWovho7h9Lrq11RGp
         deUtmo4O7mT19gYrBYwPNW9zXPzs2YbSogBPh+aPO483rkHkKeDn+yC8bTp2Z5aFOHMb
         VpCQ==
X-Gm-Message-State: AOAM531ts2ke7jYLisFMkPU6QlawFuQdUN6OMCs9uwe1Hof65ZX9khrP
        FXpcikMyVy2a6/h7agKAmbx7gXr80wI=
X-Google-Smtp-Source: ABdhPJyvyyH50lhcaguaotDrmME02+fZip56ezIFAfUdt/UVT9yI87lFdFNttuZoRQQYCo22FX7KaQ==
X-Received: by 2002:a05:6512:31c9:b0:43b:ef1b:7194 with SMTP id j9-20020a05651231c900b0043bef1b7194mr22584057lfe.493.1646349096788;
        Thu, 03 Mar 2022 15:11:36 -0800 (PST)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id g13-20020a2ea4ad000000b0023382d8819esm725264ljm.69.2022.03.03.15.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:11:36 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Cc:     Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 4/5] Makefile: Mark stack as not executable
Date:   Fri,  4 Mar 2022 01:10:49 +0200
Message-Id: <20220303231050.2146621-5-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303231050.2146621-1-martin.b.radev@gmail.com>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
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

This patch modifies CFLAGS to mark the stack explicitly
as not executable.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index f251147..09ef282 100644
--- a/Makefile
+++ b/Makefile
@@ -380,8 +380,11 @@ DEFINES	+= -D_GNU_SOURCE
 DEFINES	+= -DKVMTOOLS_VERSION='"$(KVMTOOLS_VERSION)"'
 DEFINES	+= -DBUILD_ARCH='"$(ARCH)"'
 
+# The stack doesn't need to be executable
+SECURITY_HARDENINGS := -z noexecstack
+
 KVM_INCLUDE := include
-CFLAGS	+= $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
+CFLAGS	+= $(CPPFLAGS) $(DEFINES) $(SECURITY_HARDENINGS) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
 
 WARNINGS += -Wall
 WARNINGS += -Wformat=2
@@ -582,4 +585,4 @@ ifneq ($(MAKECMDGOALS),clean)
 
 KVMTOOLS-VERSION-FILE:
 	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
-endif
\ No newline at end of file
+endif
-- 
2.25.1

