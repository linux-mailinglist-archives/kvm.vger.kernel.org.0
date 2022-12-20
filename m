Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421946528D8
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 23:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiLTWVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 17:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbiLTWUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 17:20:53 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0224EFF1
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 14:20:46 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so32650987ejc.4
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 14:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BqVeiww+NOGuJ80IBdkQW5CZZF4hxEmqJMfx0IhJh70=;
        b=mcU6setFGJ5gCXIq1m++XpFCpFENnOu+HT7f8B5ILRC+mDwKLfMJ5aHv4TElao8rFm
         TzuM6RIWibdlfeUPF/uwjZQiax2B9zzAO7Bh/MPjx1wNW2v9ShfPWhCahSOCVhejADuI
         EmIaA3Zznc6A8h/G3mawG6Cq4la/JMtFyeeh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqVeiww+NOGuJ80IBdkQW5CZZF4hxEmqJMfx0IhJh70=;
        b=aFTs0phdEOm3kMJRM4/MF/MbtT6LBeoE4GjkU6itGHyfss5IrtbMJoz/I4iUzmucbj
         hvmo7xFP+DObAZ5hFbxVF5P5PsnLopZAVYwe6O+9lfwEI/kJxvFBQUUubBRgBAErcLeE
         b9YY+2xjXOIxg3mHEcv9GJLaoTP1krFd7t5v8w6CZuOIxMUBAypc9NG/WXQ/mK0i2Zyr
         3UG8XsWarF09bGZa+7m2S+spWZAGzJCidwyBHbHR9zX/jfs6YAqU3mNlklF4v4IFKxw0
         9C34Cxl2wdR1yI0k2b5OQeHt/S3PIguh0cPAE2qOI8J10kbTr8Ja+fDm958jKw/9jXar
         tb7g==
X-Gm-Message-State: ANoB5plkr7/XQTSp0gRdy5fozlCMv3wrIT0hBGR6kn/mZxBiR/Tre3+t
        kTljU29kh+J5jcdIjbnUo1tXVA+ocmq+owZreL8=
X-Google-Smtp-Source: AA0mqf6k3btlERyy+zOoPOkJMEDVBWshH49Mqmf5GV2+sWneDSnU3Hbmr1nIdVcesvziluGHekdVNA==
X-Received: by 2002:a17:907:674b:b0:7ae:5473:fdb8 with SMTP id qm11-20020a170907674b00b007ae5473fdb8mr45354363ejc.22.1671574845401;
        Tue, 20 Dec 2022 14:20:45 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090631c100b007c07b23a79bsm6243545ejf.213.2022.12.20.14.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 14:20:44 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Tue, 20 Dec 2022 23:20:32 +0100
Subject: [PATCH 3/3] of: overlay: Fix trivial typo
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221220-permited-v1-3-52ea9857fa61@chromium.org>
References: <20221220-permited-v1-0-52ea9857fa61@chromium.org>
In-Reply-To: <20221220-permited-v1-0-52ea9857fa61@chromium.org>
To:     kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        devicetree@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=929; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=EVGUhLvp+CBdiiN2SRgHwvUVDtF39jc9lfi8Nhj8eQg=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjojU4lSGQAc5i8dMgGSBB2KvP8BQXxGJVfRRsa8CU
 mjSidXaJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY6I1OAAKCRDRN9E+zzrEiP5BD/
 40h6+7u1m7q61L9GjRt1LJ9pZSE5bVzQZW9xAMa8dTRAGwVuglR+gyzKebHukgYtcGjbvUrFn1GJer
 nMmgRqm8GLUmvmpN9qD76evEchndvnxDC8TygJGiL7ratyHSwsIxBLAMRvnsk2XiaXi7lN5thz9Mwd
 DrPdw/Mt++IpfjIxC1OxRm39YL+Nah/G/E67lMbkpFXzNvXlEGzp64hCMSffKfIUgdHq56+N3C3Xgh
 jlRBDztGDYjou++mwZ7pItAcqtF/X02kPtrF4zsd6Hv5kst2+NW3aUL8xZ71WEzOjteiwv+SLD/1RL
 VYKoy+JqSN1k6qXv5GaEXoeIvd/rC14T892qQnoZSVjRytRVNsVmpDlZz5n7RSNc0Bnndprkq3eHpW
 3LtlPVGThTEwe7ST5vUU1va+5x5ouB02SylXXkZ7Rg1PRmKQuYqlc+Dz/w7TuYs4WS9sHNht6ofGTw
 X0pOqLCcKhr9+Jtf984ZswP0VEtYVsSFn+1RBEUw7zc3/FSaAbJWS5EzZRPs+yV1qGgU30wVWFTwb7
 ypqLbpG1DrK9MHb8YZNtBjZxAZ0stpPzd2xh6KUzVZ6LAb0Oy3ZPrV1eFjjpScPnrdcs9+sgGUJNb3
 nIOPogPj5bR1uKKeKTxjd57wNrvQY36mz32AHC9ryeP/0MUTBaxP7koDmaig==
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

Permitted is spelled with two t.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/of/overlay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index ed4e6c144a68..2e01960f1aeb 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -1121,7 +1121,7 @@ static int node_overlaps_later_cs(struct overlay_changeset *remove_ovcs,
  * The topmost check is done by exploiting this property. For each
  * affected device node in the log list we check if this overlay is
  * the one closest to the tail. If another overlay has affected this
- * device node and is closest to the tail, then removal is not permited.
+ * device node and is closest to the tail, then removal is not permitted.
  */
 static int overlay_removal_is_ok(struct overlay_changeset *remove_ovcs)
 {

-- 
2.39.0.314.g84b9a713c41-goog-b4-0.11.0-dev-696ae
