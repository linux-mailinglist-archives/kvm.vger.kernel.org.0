Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EF24CC9DA
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbiCCXMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiCCXMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:12:20 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DA7D2049
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:11:33 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id b9so11121460lfv.7
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CQqGHruTtbJvIlbmz2/eb9aoqTKQirisELQUTvAZ75I=;
        b=jh0Fwf1F7dRv2mt3mRxijt/UhCa9RS9i9BJOLqk2jEOa9Pu71Ig6dqvthD2URya+mm
         nUwodCX+JCVHg/ldR4tw9TF07otsfJjeOWUFZ02puIlYHsFOPaE75dFQePCLJSwYF6X4
         1VCI3r2RFGyXDWNg1rAbUDSVUgTbK3NTWCy0YljvyvlitMZZoF+gjQ62yyVJQDWc9c1P
         qPEHcCMTa21+xPBF5qynntE1b1pJU7IB5HSPWw+Ak2O8l836jpfuvwTZcBqMuf1I4PHW
         X4nCTATbKm8ExwHUAN6Siz6VixDLqIDAqSlpnu4yT/d/kYyLt1mQcalt/BmOG7AC5tvU
         fPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CQqGHruTtbJvIlbmz2/eb9aoqTKQirisELQUTvAZ75I=;
        b=vbMSxQHaZD1qZRlC7qTohpjfyQWwIeTJ++s6A6TUDfXUlUYAHc53uL2d1awlYjA4An
         x3sLHTBjscp1KRpJiBIGVLqs2KLe3JMsN0RAVT3o8zEc+WDCFyXf6k2ahTX3DsDdV/+u
         k5U6DLOgkldQptf1k2Cbk79F/A/4DkdA9dXplR6O194XB8kTqSpm5I8J6+fmvMamjH3h
         kuSj8gEsNKhexEVsrYki4wWv6uM4+beAwxyXAjNsCNGERgKI8zdh+f+Hg5wWxR1yBdV+
         vLTAAgYJYmFdUt/v0kwQVapdjNB3B/taQm7LB52Aro9JF6RrrPxGvD2OMuem1xe5Rj6U
         r1qA==
X-Gm-Message-State: AOAM531ARHpW1j2uqplQsnXcq9gqWgo1jTXEb3vhvNQ4tsvXQBCLoi8/
        3NfA/6hv7mt+lkaQY7nFu5dhE0HHupc=
X-Google-Smtp-Source: ABdhPJwN0VsSUjFXJoWsrpNniDNeaopVnOua+DaetYbqGjNzz9csms93NUBUz0Qo3dMOLLDvzNXNrg==
X-Received: by 2002:ac2:54ad:0:b0:443:153e:97fc with SMTP id w13-20020ac254ad000000b00443153e97fcmr22917331lfk.252.1646349091993;
        Thu, 03 Mar 2022 15:11:31 -0800 (PST)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id g13-20020a2ea4ad000000b0023382d8819esm725264ljm.69.2022.03.03.15.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:11:31 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Cc:     Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 1/5] kvmtool: Add WARN_ONCE macro
Date:   Fri,  4 Mar 2022 01:10:46 +0200
Message-Id: <20220303231050.2146621-2-martin.b.radev@gmail.com>
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

Add a macro to enable to print a warning only once. This is
beneficial for cases where a warning could be helpful for
debugging, but still log pollution is preferred not to happen.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/util.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index d76568a..b494548 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -82,6 +82,16 @@ do {								\
 	__ret_warn_on;						\
 })
 
+#define WARN_ONCE(condition, format, args...) ({	\
+	static int __warned;							\
+	int __ret_warn_on = !!(condition);				\
+	if (!__warned && __ret_warn_on) {				\
+		__warned = 1;								\
+		pr_warning(format, args);					\
+	}												\
+	__ret_warn_on;									\
+})
+
 #define MSECS_TO_USECS(s) ((s) * 1000)
 
 /* Millisecond sleep */
-- 
2.25.1

