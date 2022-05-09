Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98E5520608
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiEIUoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiEIUoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:44:12 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A39285AF1
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:40:18 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a30so5542275ljq.9
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hwKFuevP3nmLw+gVv3xEA1GCgqbzrzuPJGFdNpKxNrk=;
        b=QiAcwnX+wwS2RSM9hJ+4h8ibJ/QABRHWD8T87QH5/FAsTSw3K4J11tKze3FsZt2Q9p
         h2XGv6YsIrMENIieGnslhj6D7dwx+ZO4oFS0/fmLv6DDuLrH0BHFAtP3ORfnqSk1/Bps
         2semilWcfvpSXBV1sjZ6zH8sPPljieHXvafxkKOK40JHVrLCxUtlMN1Bo35UhKA725fr
         ujeH392Zu5UOxr7idO9WoR8qZQgxntum5Y8IqcYbeXNzuq3TxgWHqzM1+KOIgNvpcc6T
         RG4LGKqz1bxiwsYR38s0qrk7KDwGO3YXAQZL0kN4G4hxtbP2zKsF0Oyi20Z/ZvT7fPV3
         SyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hwKFuevP3nmLw+gVv3xEA1GCgqbzrzuPJGFdNpKxNrk=;
        b=iPcrb6dxul+vDeXmJnvpZLU57vbLFALN1KGTRoZcMgxFhDWLwNqXcqzRO7IN3P7mqL
         APHuAH18qAJz2DypwQ9+e7DzInhd636i3Tfr+1DUkirj9AZRljEhgDV26qFBzgF6SSEL
         kwepwltRYBMAZUt9RN3Y+2xp8HMVlln9OHDjzrT6PeCNGfjUzw8vJQGfVv17kBrF09BR
         Wl7+lFghUkf53IoE9PZqGkbgQ7Fbw4s6bB6trQojEm+P3Aj1bIpbuVPlfXtxDFSE1E10
         1tf0MnrdyhNPgz+vvjE3qBrTwmC6z3oOQtu4vy76G0vu6xj2TeZuTa7aMKJVmjcSRtMj
         c7lA==
X-Gm-Message-State: AOAM533Rt7XfEi3+NwW7y/5uTWcFREAgdk0RN1aSsMewMXvi++JYZibH
        CAX1gZ4zwEtDSbLGGYFXrlBgYvqAmHY=
X-Google-Smtp-Source: ABdhPJw5syuJ9HPvQXe/GXo94+/cNCoU4/CHzhYySnA5T6zXN05M5euROKo02i4xEgWMDyJZOGEkOw==
X-Received: by 2002:a05:651c:243:b0:24a:fb54:31d3 with SMTP id x3-20020a05651c024300b0024afb5431d3mr11764423ljn.242.1652128816082;
        Mon, 09 May 2022 13:40:16 -0700 (PDT)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b0047255d21121sm2051961lfi.80.2022.05.09.13.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:40:15 -0700 (PDT)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, alexandru.elisei@arm.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v3 kvmtool 1/6] kvmtool: Add WARN_ONCE macro
Date:   Mon,  9 May 2022 23:39:35 +0300
Message-Id: <20220509203940.754644-2-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509203940.754644-1-martin.b.radev@gmail.com>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
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

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
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

