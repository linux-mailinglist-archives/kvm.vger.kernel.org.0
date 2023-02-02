Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401BC687A76
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 11:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbjBBKnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 05:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjBBKnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 05:43:08 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3C410EF
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 02:42:57 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 203so868372pfx.6
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 02:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ldGt9CJfPI87gpBgmJqLjVS33kkn4ot4dZ1LzRIHTPU=;
        b=EtrrguGOFagT+7kLAk6uTCf2dZGN0V2lCd1mIKii+4o1yT5n+YV479v6rWAtqm2894
         EABYCzqBz/fN0oOMwM36Nc4O0fdp75HasO+9aAwoPjBMW4W2zcwIQgfkF+9EpEO9xn4o
         Z6ctl6ZFxsBKfXQwhY63l3R8/ALoTj59C0Fh3wdAH5WIRVI2hODdscuiwrLQYb9GWb/G
         O1LtgdXqkxmXCrRTUwfgY5dCuAKAdPHsHXRVDaQ5lGBXymtSHAUmrc+pl7NnlwWRWMbO
         IJx1h97Zk6ylX+8ravr91EOpEZcOkJXEyaQ45X0bW61KQkKlmO/4g4W5CGF7wlsAFF12
         TCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ldGt9CJfPI87gpBgmJqLjVS33kkn4ot4dZ1LzRIHTPU=;
        b=C6xUIUE6LggQLg31iGlCpHsh+ufNcNBESnAvJweOvMI1euE+UdbJEOhIzYPLWh4eS4
         ceS4g1VdOTacT2zc6wqXyfGRh4c5CaA4vblDexA3rr7ELCekMI862RdgiTr4XNBIr9xu
         wO6iGHMeyq+EZqNlL6u0iinPEa2Y3Bj2OiujCYGSHtRjDa1Gp7ENViZbr8gT3OiPuaH0
         oPspb6ZDlwhcLjTllhB3K56hegrA6yPhVKpefy78cly13OhDbmkSRdHbAq9rHxu2yJQt
         aaHwIQArYdcpBMjDWVgr880CjpSqVNZnDmQthtyo0Jx1+Sm7DjOyw8WWygjOWxO406PG
         0x8A==
X-Gm-Message-State: AO0yUKX0YESOLSb5A3zi4gV+GBpD9aWY2RGntgVGhx4TZIBjLkdp7Zaf
        /X3my5LYt0nFNrU31i8yVmfnIA==
X-Google-Smtp-Source: AK7set/Rs7+nLs58UmDprCnbeh0PTlwwm4Q7EdQOVVglBIKiQVz3PTwKOQuKPXet1bSUyYwrziJkYg==
X-Received: by 2002:a05:6a00:248c:b0:58d:abd5:504a with SMTP id c12-20020a056a00248c00b0058dabd5504amr6366086pfv.31.1675334576527;
        Thu, 02 Feb 2023 02:42:56 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id u144-20020a627996000000b0055f209690c0sm13294220pfc.50.2023.02.02.02.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:42:56 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>
Subject: [PATCH] vringh: fix a typo in comments for vringh_kiov
Date:   Thu,  2 Feb 2023 19:42:48 +0900
Message-Id: <20230202104248.2040652-1-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Probably it is a simple copy error from struct vring_iov.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 include/linux/vringh.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 212892cf9822..1991a02c6431 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -92,7 +92,7 @@ struct vringh_iov {
 };
 
 /**
- * struct vringh_iov - kvec mangler.
+ * struct vringh_kiov - kvec mangler.
  *
  * Mangles kvec in place, and restores it.
  * Remaining data is iov + i, of used - i elements.
-- 
2.25.1

