Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC64662D0
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357437AbhLBL5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhLBL5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 06:57:20 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19473C06175A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 03:53:57 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id q3so36227423wru.5
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IvLpBDRS2Pdn+vA+erULS+6P/ROHm9M1862F9XFkLVo=;
        b=O6eWGC3lK1k2bdwvVVPl5U+azr4tVe10ZfOseYEtT96guc8yYcVbGVXdvPxMDHDV6T
         ec8eelKu7vuYLLcWfa84OcJZa61vTDqh/68FnL5TMrUaeYOiUH+nlv5SGVJKjuRfJB2w
         eRQGbwxrDMMwzfi/qmdJgT1kRqCN/NxApzDQ8ev6Ifyl95rmkqHDyLjjOugf3wipv0c0
         D0V+iiqsk+YZ5tBgsw7mnMbz7TjwZxivudsoti9xuT8SvjMv+via/Z+rH9vGEbT53g6L
         SjqLUbQUkSEorUWLw3+7TYh7GhKlVDzrjRNzQTQialDgp8+rOui1JsLVZiQIx3kTkv/8
         x2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IvLpBDRS2Pdn+vA+erULS+6P/ROHm9M1862F9XFkLVo=;
        b=IC/JX0xfMho97I9Poym9ML67qP26+Ot7FCeM11UmFNeRZCtNFU9xJtTMz79A8gNpPe
         BEb171d6X3g00JgwbEwdTGTEO5jTy06+xDtm6Kz31+QHLpnm5p9WohPZYHdbhq7Ubi88
         KxQBAk01GutXqkUPaDemTgO1rIOqnH7qxSwq45qJbuW7YiA/UqjuP+mwSAUZ7eqck/xg
         nHOwYCxGefo4YPd19r+wYbkSB1i3dtCImonsnaYmJfh/8I7M2HzQqkmw27pyH7GawEnJ
         RFhPvjT+yaiGlDAySlhnCKJJlsWdo1Ry/bs5e9q1UC1C6Y0WZOR2yQBv9SkfFVrTcg3A
         lXgQ==
X-Gm-Message-State: AOAM530ZYx1KItOYrX8Kd8OwwAqyfEJ2I4kcvTH/hebJoKJmiwzIco7d
        5VApBPNlnDHrbvvLwZuJk+RuzA==
X-Google-Smtp-Source: ABdhPJwi/7A808rEy78vOiFE7u0TCcCzTOnMSi1t/OE7sTq+JunTgf07UGOwCnnDDX1W7awt1Jf5jQ==
X-Received: by 2002:a5d:4b45:: with SMTP id w5mr14000332wrs.272.1638446036493;
        Thu, 02 Dec 2021 03:53:56 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id j18sm2419580wmq.44.2021.12.02.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A6E631FF9A;
        Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v9 3/9] Makefile: add GNU global tags support
Date:   Thu,  2 Dec 2021 11:53:46 +0000
Message-Id: <20211202115352.951548-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If you have ctags you might as well offer gtags as a target.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>
---
 Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b80c31f8..0b7c03ac 100644
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

