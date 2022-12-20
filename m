Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4096528DB
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 23:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbiLTWVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 17:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiLTWUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 17:20:48 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A60DC0
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 14:20:44 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id n20so32737768ejh.0
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 14:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ff5536TPGy7D2NNNjsXDf23J22rQqcLPw+nFPE9DWUs=;
        b=RlC3wj9udUOd9Z4MeptTa5TEXLAqHb6HEd3Z19qFrysoSSBkdOiEfdzeG9449aRMvQ
         0unnC6BQCOaguK2G4y0NeKaMm3/QqO1o8mnHqdMZB8LlzYCTSZWJ8OsuxC2UIHZF6sZM
         QIaG7iWvOW4yxSx6OXKK3pQu/1vP63eifpmq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ff5536TPGy7D2NNNjsXDf23J22rQqcLPw+nFPE9DWUs=;
        b=AIs/aKErTp5Tb4r9WABsACTbY+MJtW9DDgmo1f6g2XVJkfULi6H8VSYTe0S3Nrb59f
         0AbIqhEPRz7YmLJLhcGHKqY4nBJAkzcTWvOxHBCJNAdZQgp9UTQGsLsAOt9Xl385OWLL
         me+5YooIz0RJdKSeFEl8ORzBhwFe6QNYv7DjzAEXWsuIfYb6yjmo9e2SGZ1p4uiirlyc
         URBYKYz4ZlvgxCNKav5wDp8w0MPgY4Sbp5eBx8dFFlouRagz7HUWBQld/K0AHSqZzGa6
         OyRH8SGoOPUFhSBl3h7UASge1Xymk2e5O3BS3OdKHLx+VW8qcy/R5Uxj0G/x8XTGnfoh
         FMmg==
X-Gm-Message-State: ANoB5plHPFwdKgxSewrLZzqTRxUzhtc7LBfbQJ1EeU9dUAIOUSY1S3LA
        Tn9OYIoCPVM7BT8sghfB2hvn2vi9GPodpVcUnHg=
X-Google-Smtp-Source: AA0mqf44EaNDy4oV47i7M6y+uxPEyg0vM4jNfisU2TiJJcV2xF6ZN8l2rpJHX0j65cVIRZvDpzuRaA==
X-Received: by 2002:a17:906:859a:b0:7c1:4bb2:f62c with SMTP id v26-20020a170906859a00b007c14bb2f62cmr39222646ejx.40.1671574843329;
        Tue, 20 Dec 2022 14:20:43 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090631c100b007c07b23a79bsm6243545ejf.213.2022.12.20.14.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 14:20:43 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Tue, 20 Dec 2022 23:20:30 +0100
Subject: [PATCH 1/3] scripts/spelling.txt: Add permitted
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221220-permited-v1-1-52ea9857fa61@chromium.org>
References: <20221220-permited-v1-0-52ea9857fa61@chromium.org>
In-Reply-To: <20221220-permited-v1-0-52ea9857fa61@chromium.org>
To:     kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        devicetree@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=639; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=cflrsbyZV7KEjeBqC6ItOzcRpayWYLYhATctd5/dw+o=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjojU03uV5xat88LM8okJo3Jj325e3MiLeojmE/2tF
 NZ2mBWCJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY6I1NAAKCRDRN9E+zzrEiAUJD/
 4oaOMxs+Bu6dVpiV/v5i3F7hbgTZ6zM1rtKMg0xhqrohTHYxPskFRDAqfJEo498V1FjD3JEj04E0V9
 fY7ImxkPNd79lrlKqfO0v53ErW6igWCu6u5zoBdGRbS8XcuIfDEUlCK6l9ulO5VOv4qABqTkYIFZcz
 wvo+DXr1ikcHww+YMKxBgKmXbmGIUoW/XPiueOApeVX2jzx57GXusYweN/FslzYQkKCgJRQBxAHsNd
 AblRLfXI9agL+zwjbq32oWouGlmVMIaPMwF8nw/lyM1QKWrOdWrV9jVUjCc7kITUvtM4V0+l4bqVCf
 zYit5XuJ0q380wITRw1yaQf/WUe0HfkuTBSi2yQ6T5yvQ1TLzkU9mJ1xpqTFSwommLErlnmwrAkAQJ
 8GWFs2SOYWPVQwZqHbrPLt8cmrSKOz+QJ4YAwixBrRV0OmDuxu9IGx+5vzTxTSKd86HRGGWiWgeEYh
 gcWiNPWHzGaRQBpUAMC3Idjaeam1HnLB2IytRv0jvaDLUoHMn+V6DzywxyQB+9fNQENNyk/n22mmyZ
 AT2SSwKJezfSdACMYwS6RyFYlgGl0mTPaf3/AJ2Dy5aJJxwLKR33zzpKv5ss3/djHZo6Hn2WEUG9u/
 RuBwIrODKLO/u6XNBXxALQJdqbyyVn5mFHQyp3ShfqdtwmM1d7x4KOHqQxag==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add another common typo. Noticed when I sent a patch with the typo and
in kvm and of.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 scripts/spelling.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index ded8bcfc0247..bb788a733722 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -1121,6 +1121,7 @@ perfomring||performing
 periperal||peripheral
 peripherial||peripheral
 permissons||permissions
+permited||permitted
 peroid||period
 persistance||persistence
 persistant||persistent

-- 
2.39.0.314.g84b9a713c41-goog-b4-0.11.0-dev-696ae
