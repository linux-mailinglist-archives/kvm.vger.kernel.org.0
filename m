Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6EC6528CF
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiLTWUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 17:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLTWUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 17:20:47 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301BCB6C
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 14:20:44 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id t17so32689170eju.1
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 14:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=9E9OdYg8rklb+n+BqaLynkWqMIPmrmsuCh9R6XB9EVc=;
        b=ZDQW1QYpGELk1zGf5SJNRyIPkAHgAdyil3fUoKQMUxMdWNyKfkxDFWzPgVY+bJI7oA
         n9UMMx4U2akgI+AlEdi78ifrxFCgui6CF1fwJccnNFzRm276v3+L+JoyjdLdL0FxM1q7
         QqTbYcSUfDBNmI5yexiz6vvhyvqZrvm+/afiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9E9OdYg8rklb+n+BqaLynkWqMIPmrmsuCh9R6XB9EVc=;
        b=jj93dEjsVBOmkQRVjhpCyPlp1tnuavOggp6J33bwAZ9BV4/g3j2kx10gfdJUELdjvX
         esuRyi3MnLZYvwwTSHI0qu5iZ3ugFbzIIdoLfWpS/YEBNmiVZg/W4JPn8tpvFLFtReIq
         Bnwi683FLOEbDENKu29Pl/Dlul2UfAu+TI21BdudoTv+DI/rP09iYEyDI6qzAORaMY36
         P3R6KSAGYJZ/LtmFFCbv8KM86M5qiKxA97pv4jbE1TUOzcmzjJR3obyagJosYqwM/ml5
         befgSdgbUPdOCL0OFCXMuGTyCLiiMH3qCDmaoofZfASYGZz3dJExuoTJr5dcz5IXkzAN
         dOHA==
X-Gm-Message-State: AFqh2koM9cQWYzxf7UeF+4zBR02PI4g5+mv0uXOXB7EHrF+jjdXdes1T
        uieGjmFm14KSYntUV/WZw3ZK4zDY+iJv9xNHIpc=
X-Google-Smtp-Source: AMrXdXszwTvAADXrAZaLt9wbuu0uoUjxJOFyzVRY16BFZuH2MyiduC9esRCnmTU36PmL8kfoj3LG6Q==
X-Received: by 2002:a17:906:1f04:b0:7fc:4242:f9ec with SMTP id w4-20020a1709061f0400b007fc4242f9ecmr12409527ejj.43.1671574842597;
        Tue, 20 Dec 2022 14:20:42 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090631c100b007c07b23a79bsm6243545ejf.213.2022.12.20.14.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 14:20:42 -0800 (PST)
Subject: [PATCH 0/3] spelling: Fix some trivial typos
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC01omMC/w3LQQ5AMBBA0avIrDXRKSpuU+1gEkpmsBF31+VL/n
 9BSZgUxuoFoYeVj1xg6wriGvJChlMxYINoERtzkux8UTLeuX5uO+dpmKHkU1Ayk4Qc1zLke9u+7w
 dmSEckXwAAAA==
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Tue, 20 Dec 2022 23:20:29 +0100
Message-Id: <20221220-permited-v1-0-52ea9857fa61@chromium.org>
To:     kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        devicetree@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=781; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=Uxupm1LWHFzt6uFbcYk+VJKH13pu0G4Zt+hRVhu4Jp0=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjojUuHq+JBFt6IVEsSQ7zcSBoUIC7ZdDRNB2xAWFw
 ac7FWUWJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY6I1LgAKCRDRN9E+zzrEiLBJD/
 4oRAaAz7XLCAXkfbS0I7Dt6qdP6xvPSWlHhiPKTc9oIcZBR2LgTNMpWpq0Rsa3TuIjCGBaID2ki7it
 wM3OpCyHfM8Om465zWSaJlpBZswgAnFnLvHx8YiKAUuQm+C4puOVxQrD8Uyk/sYqZdMmA+X9iavofC
 SOrko8CuZ/NytOuHLIJl3MPsf5UJAE2QvIMAAj9ar+nMX34E7Ru7igrFKTLmoX/8uLZHSx4RNyAGpU
 jXdZgMsmYhOdj6ghpukmJeVgXvv2iULI7ELHktbwyBlPTNvn/3D6FLDFgD2uT0vuhw7D/doKadszNG
 u5OroQ+KhEFFzvVVwP3j+GMPlGkPGPSkP1NQS30Ad+CiuoJ3xf5u6e/8xswCW4gvfzTObo+o1+Rbcd
 4VMuTGQj+nCebacMcjtO86SOvjTOel+G9yjbKOkZjGV0Dp//VThl2CW/xWJ9K0a2lrx+h0Gg7fyujJ
 Zyowq+q9beMuQtisS1NTHIYPclR0Ic18OKzC0hYFsTMqGp+VGK0NLKVz4Ooyj/hJ1on3Kn7i2NYRWJ
 HkEpNwqGc8dAi4dUVcNqCqkrk8YoS8jw8Dfr28PKb2MY56n5jCvnWK4WFrvhmxfyUlh491/KiirJxA
 CZwgjwO7OhWxQakijLL/ymELvvXH7DKmtUIYaMM/DGijl2qVW4aEOJ/L5fsQ==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like permitted has two t :), Lets add that to spellings to help others.

Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

---
Ricardo Ribalda (3):
      scripts/spelling.txt: Add permitted
      KVM: x86: Fix trivial typo
      of: overlay: Fix trivial typo

 arch/x86/kvm/emulate.c | 8 ++++----
 drivers/of/overlay.c   | 2 +-
 scripts/spelling.txt   | 1 +
 3 files changed, 6 insertions(+), 5 deletions(-)
---
base-commit: b6bb9676f2165d518b35ba3bea5f1fcfc0d969bf
change-id: 20221220-permited-7336f4537e8f

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
