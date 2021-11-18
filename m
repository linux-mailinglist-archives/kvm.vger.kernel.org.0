Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763E34562D0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhKRSt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbhKRSt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:49:58 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086EEC061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:58 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id n29so13392479wra.11
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FbAh+aztF0zh2yPX+S7IKVelQO7NqMfexMVIl0szM/Q=;
        b=dKTCZqGr5BEyXulWz04B3VqIQibV6GuezrZHpHVmtIMOLiasDW+K4vSFElaAkUpH1W
         7o4deOFOMy/+LnRBRHXXr/q8me3q6o900zSJ0u4zHpw3BlkRO7QYo9d/LMt0F4XSEtf1
         8b7pm5Mgd+tvJhilUfDAC6h4e0IiQ7tr92FGj0Je/C6vuxuqZ+Nb2uAMgpkO6fSS2E1f
         PoM+6pn8SFi6S2IQvHO5k78NkkNoOOQCAn3/xPJexhPL7a+qfSbWtUFH9MpOMwXZTufk
         R/8hGXhC1V+3N/pWUZkvfAppZxvuI0/6MUeYPlTNOgPDEDmA5mtQ6tQ92ZMkx6o0qKL/
         lWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FbAh+aztF0zh2yPX+S7IKVelQO7NqMfexMVIl0szM/Q=;
        b=mLFNp9ll1tQJMFZV4OXo7FsMja/HOifRM2vgrJO/5XilaVlCtq2DBFS+njSK7Rof0h
         VJSxCHI9X+8ph6bwcIF16kECzkfrAFqesp255yVNM8wxJBrLzzYUM1tOY0YxljHoupyW
         sv1+m8K1o1L8dzFJHUDd1MAjP9ifFdQhduUb343BtJk4O8PGDWFnaadjmRFI1CS7XkmH
         Jrj2HlYNrS03KJnfP+04v4KrWpffeYv0k4sW4rzYBnB0CYJxXMhDTYcP/BnNkMoOJOrp
         XzY9DAMiw/+qAHwlHgMAGl3QVreCegMaOrUJm4Y3xzCTslwd7X7vAUsfeLna1y3HNPkM
         3+4Q==
X-Gm-Message-State: AOAM530TsMhZni+ZCj1CxdCHMmZaavopkeqejfdnWm14U1m5OZCo3WuS
        UET5iGUljBIwEXfR7w0ZFe8lDw==
X-Google-Smtp-Source: ABdhPJwuqcWCq5OtkKnnGu4FzRENuBcr3VIuVBqyCASUcE2XGA1oVULFg2sKZDvp1S0mXlH38p+wWw==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr34905244wrw.118.1637261216576;
        Thu, 18 Nov 2021 10:46:56 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id c1sm644533wrt.14.2021.11.18.10.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:46:54 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 490751FF98;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the README
Date:   Thu, 18 Nov 2021 18:46:41 +0000
Message-Id: <20211118184650.661575-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 README.md | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/README.md b/README.md
index b498aaf..5db48e5 100644
--- a/README.md
+++ b/README.md
@@ -182,3 +182,5 @@ the code files.  We also start with common code and finish with unit test
 code. git-diff's orderFile feature allows us to specify the order in a
 file.  The orderFile we use is `scripts/git.difforder`; adding the config
 with `git config diff.orderFile scripts/git.difforder` enables it.
+
+Please run the kernel's ./scripts/checkpatch.pl on new patches
-- 
2.30.2

