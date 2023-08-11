Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7BF778A83
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 11:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbjHKJ7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 05:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbjHKJ7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 05:59:47 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFDC272D
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 02:59:42 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6bca38a6618so1643374a34.3
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 02:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1691747981; x=1692352781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6f/7e2hRXnjJufuWqfsfocdz7yearaf3cWQNf3Rdlh8=;
        b=KXTJQwrXoH8Yhpgingmux3byYKPMNHpYkvPd4JDKKAMVrUoQtA4mB04zSnTNhSAk4B
         1FRjB3yysaG0vWpIIdSyFMBZHoNWvTFjEla1FBzKf0oWI1ZoPFAtKUT9IYMnL7u9zXbq
         Yx3a477X4uwuz1qNhwzLv+I/d7Nd7EwEbS2gIGMfzfk5AxkEOF5MR+UrcOY2F1kovCzM
         Mw6GMBFKYHdN0ow3eR84det/058/2FU9wjibUZsHZEuhmDUtYhDYbteAjZ1YX4p+aIu1
         r6vqKlbv72rac6rpJoM3yt4nBzhvJB54U54WrD7+NsAMDoun1xTRhOBTLa9shgRz7u6q
         3JEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691747981; x=1692352781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6f/7e2hRXnjJufuWqfsfocdz7yearaf3cWQNf3Rdlh8=;
        b=Nuv8SKCNvuvZFEcNLIq3z8vqClgQ34OQibP8MLkvEdQEqmkC6A6BwmKwh+bF/5ZLPR
         EoOZP3kvd839EVScIb5H4HDb+ZD3TwVoE26B4FdegWjJ46HgBvgYqIvKiJWUeFVzzU02
         cMHheUM82lIu7X+Tf6lf2Z78TCpRCqjpb6cpgvA56Xn+Xay9HKbhT+ZZbU6vpftoxU81
         I5SqWKP88rflDgWysRajhxa4nQCeHu8oNkpc1U7H5TPu03ZOpN6sfJwgyWlMJmy7mE/K
         dZnAjmQO7Qtwmtfd3EKoqzqvl/5dPXFIsqQOJyVPaSCaQ6RM37Ui3gIcUiMtSo9v6keN
         mlow==
X-Gm-Message-State: AOJu0YyEqjmf6m2vp5i4XjRa8g/SB7z2ZHAhk1FxpeRpCyZ/N/WUyCyo
        WnrT4z1CjAo5Zk+8KpfU8npmYxevfp7xVV5Y/Eie+r4e
X-Google-Smtp-Source: AGHT+IE2j43GNkkVn+A0sfJP+7J+1txCCdTEFlURRtaqClHRmUTrSQ5qCWqLqnO8P3VAPsyUwedJdA==
X-Received: by 2002:a05:6830:1e76:b0:6b9:6481:8e33 with SMTP id m22-20020a0568301e7600b006b964818e33mr1356200otr.13.1691747981082;
        Fri, 11 Aug 2023 02:59:41 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id fs22-20020a17090af29600b00268062f93e5sm3013613pjb.15.2023.08.11.02.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 02:59:40 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     kvm@vger.kernel.org
Cc:     Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH kvmtool] virtio: Fix typo in comment
Date:   Fri, 11 Aug 2023 17:59:34 +0800
Message-Id: <20230811095934.254946-1-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A minor typo fix, change "too" to "two"

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 virtio/blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/blk.c b/virtio/blk.c
index a58c7452f97b..225e40ca8f7d 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -23,7 +23,7 @@
 #define VIRTIO_BLK_MAX_DEV		4
 
 /*
- * the header and status consume too entries
+ * the header and status consume two entries
  */
 #define DISK_SEG_MAX			(VIRTIO_BLK_QUEUE_SIZE - 2)
 #define VIRTIO_BLK_QUEUE_SIZE		256
-- 
2.40.1

