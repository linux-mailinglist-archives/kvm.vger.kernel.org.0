Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CC762970F
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbiKOLRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiKOLQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:27 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C22E614B
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:26 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id u13-20020adfa18d000000b00236566b5b40so2657942wru.9
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C9R+z2LfKFQNn3W3okfxPlt0ApO8wFNDoYzLdWHqipE=;
        b=TEb62ETv4s/fBxh8STMq8bC+bnsCcOj4LS7CIyyc0mr356/Rwu6h6Sx9SSHU3Kx5SZ
         y6Qm+g596y9sON2XOJS28ERfBmIWcnlaIbVdcZ3/41zzbe6XwIfiXPBIQFQTEe7+7Xun
         v9MkhqvSqVkFJV7Z5udpPF1KOoZSUIQxw9IUu/imSn5v3LRImQws0/efQ7swdr6VwLw9
         ctVoc4qb/ASFJnlVYvDhNVbbq/YixCeWAy1ZUPH89VZUrGQm0oaUy4XUJbMZKAmmQjBQ
         PIYhqUtgqxkJNYlob4O+T1cxXRu/BOpzdXxsjZwRkjLkyv8UuY0mAioRAgHiXtN0gqnu
         9+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9R+z2LfKFQNn3W3okfxPlt0ApO8wFNDoYzLdWHqipE=;
        b=6+C4MiafL/tDrNjJlfVbwxJyZC7Z5sQp1gOsc+xQuEWK3ACKgm2YEcSGpdiJP3Qrny
         mkK3wuMJmh8W2DvLOEjywK36Kg9bfm3q+cySC6Bzlu687yw+7wyTMLVCuKCyAdk8cBmX
         7uDOkaUw0dr2ldM+MOcMm6+prCgx1XRo6VpGSetTtdG3qbZRbJx29OmvlFsd+NSXqtAw
         0aX/GhcuXqoUhPqJw4DqBL0oTmZlvzrH5v06CXDM3ZaoEmJNbPrqev3W9Mr+9MCmXX43
         f6xco/hRfQK5A4BX6LVTHrBX6qFC0kbtf9lqGUW8lr9PCHjawjX+1h/7OJDC8vKZzy8w
         JhVw==
X-Gm-Message-State: ANoB5pk1n32379bmxwV6XeHPe7DjMQNAuDYqXkl6KnaKvZsKyokp55d9
        NbfS7f+QYZfy0v3FknMGXKn3P6YN1r/JE/M3zttN7vcR/i0Tmcr/a1hA44PqBBZeHJMuonR54A1
        D/z6qFuFSCSb5Gsi5w+25HdHZZHKbIDRpbo/kjtKYDaQMfm4VqsXEeW4=
X-Google-Smtp-Source: AA0mqf7BCbGj3TedjfZGh/xq4ME17hGxGp4AlXDiQ8fzErVnCv8X/Qi4OqbvXB8dgg0VpGlnDyA3jhlRjA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3c93:b0:3b4:cd96:1748 with SMTP id
 bg19-20020a05600c3c9300b003b4cd961748mr120128wmb.2.1668510984581; Tue, 15 Nov
 2022 03:16:24 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:47 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-16-tabba@google.com>
Subject: [PATCH kvmtool v1 15/17] Remove no-longer unused macro
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not needed anymore since we're not doing anonymous allocation.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/util.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index 369603b..f807fcc 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -35,7 +35,6 @@
 extern bool do_debug_print;
 
 #define PROT_RW (PROT_READ|PROT_WRITE)
-#define MAP_ANON_NORESERVE (MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE)
 
 extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
 extern void die_perror(const char *s) NORETURN;
-- 
2.38.1.431.g37b22c650d-goog

