Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8714562CC
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhKRSt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhKRStz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:49:55 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EAAC061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:54 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 133so6294720wme.0
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1TD+o6fA2jwMAGGm9K/LhqxPmEtAnkZjhJNXEULmUk=;
        b=OZ+0ycbkYM32+k3qsnQBx40UB+HQWYrf4ClPvT9L+GaXRo74oIjcfnG8tB2nzPRVUY
         MK0WqQiXpqYCXs+/HVInv8n6a3FB5TqhV55wnN8ET4JFpkolVeEHwW2rXqwADhwJyhQU
         dhkS7OnJKDDDDqhUuwZSW7rcWltcnbgqDhZsIHy+cBFzhXu90XSEB0kOSoFTwG87WC64
         nwfj2Zlr8ySTd99Z/TSoNnKZJvpfd8BU3Vc+zhM3ucXjuJTUTsZnXy+6wSYVxUPuq3ms
         M2w2fwo+xzjA+7N3KUJ4j800daGm7Npqu8dt6FFkdR9ur3B6aauwHp1Hb6Ar7WympXyE
         R8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1TD+o6fA2jwMAGGm9K/LhqxPmEtAnkZjhJNXEULmUk=;
        b=bl/yz+HPZ8QV3jE4ok9mSa6gEgCJFXOGoNCGhOvSIHizwCMUmNqibOmzpsvGedLbyr
         o6fnODm3F0U9DPV+XuCFq9Lx/HdBTBIGl3xnnwQdNylczfNTCAUeHvLGAHimwNM7qnu4
         LEtNjz2NJzSykMiNwgenGcpEslu+eJ2eZJD/z4UlFkFCZnk7jKeb2d6+w2Vac+y1FT2a
         c7NZg5xFJjm/Ic2Hy314EWReFsoFUPsZExjrJxUXlF9Q25/Ihjd7Ly77mbSZ7qX20CCp
         63LjD2Vf+Mup6e5aaPVBgpTK7oPpIHp5iaObmZIrtjmkQmZ1AbVWj4SM35PfryYjXCpD
         YoLg==
X-Gm-Message-State: AOAM530TQdDQQj88YUc836a5sb1DsM581DP4Q+TmNaYOfSmiJyQx3yqX
        3O8t3hNTwAk8Yt4eyH3UrMCgOg==
X-Google-Smtp-Source: ABdhPJwla25wllkelCSuqSunInape1qck1sRu6PWmBGXbmmbMp7JZz+bf9KnvBlWv5Jc/4k8cdhsXg==
X-Received: by 2002:a05:600c:1c20:: with SMTP id j32mr12131735wms.1.1637261212696;
        Thu, 18 Nov 2021 10:46:52 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id n1sm655518wmq.6.2021.11.18.10.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:46:50 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 56B171FF9A;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v8 03/10] Makefile: add GNU global tags support
Date:   Thu, 18 Nov 2021 18:46:43 +0000
Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If you have ctags you might as well offer gtags as a target.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b80c31f..0b7c03a 100644
--- a/Makefile
+++ b/Makefile
@@ -122,6 +122,9 @@ cscope:
 		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
 	cscope -bk
 
-.PHONY: tags
+.PHONY: tags gtags
 tags:
 	ctags -R
+
+gtags:
+	gtags
-- 
2.30.2

