Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9214CE70F
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiCEU4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiCEU4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:56:34 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07C060DB8;
        Sat,  5 Mar 2022 12:55:44 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id c7so9053191qka.7;
        Sat, 05 Mar 2022 12:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dLjEiFN28e+Vj0lWlZ9hSloKdl9lKcIh6UsFQqrofGE=;
        b=bZe3hHOHz9cWr4ATGEtyfYBSGKayqrnCjCNKfskBrO0FttP4gS7tyYk+d7tfAKVCP3
         ah7fbX6kaw8qyLhBSQXqpzKLp93tQQGSqYMY4o99YYiQT/otcmIyeE/Q27hfVE1V4V/S
         EU8LRtZNbkY5m7mYp/jWi174Sq2EWuNIREeJGWRqOBOnhj7IsRAjgoU5bz1sxCQfk37q
         de6AbFqGamfDeODiu1KE5hczkqGsWVsGxmqDf6unULEyd/ZNGGMuPvDyCzitYjvakCf3
         S+Snhsogl4ABoWKAkOqwlVNmMkHFqLQvISQkyWL+K940vsO40pDv4ZSXB1qJSiNDTgbp
         FSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dLjEiFN28e+Vj0lWlZ9hSloKdl9lKcIh6UsFQqrofGE=;
        b=P3YTiaCroRLm0WRuYmfCrdh7bt8R2Q0TogHUN3+97Bk9SmiFVjbKAi1Bu8zq0MC10e
         rkSu9PLdsJvejaayNhxVQxOf4RGSA5D6ARH2QI4jSQvpV0gAJHsDZe4Z3kwEGGxDXIIi
         I9cDM0fsC6NJvwymSR9inrlnCcXbOLZXSQvExCwP9CTShyNTtQvFuqke1SNdvguxUgGZ
         zaCZ2G3n5FFOVDaYjE/A6WN4ld1HZ1QIUzgRJ0qunZOjD7AqPMANmLFZ+s0UtTO1eoyv
         2+sm3Bt2XUQvBk4Hi7SGmTTWJIUZnECNdCJ8naVNBSVRgKfPXXvX5wugBruoh3dxd6n5
         gYpg==
X-Gm-Message-State: AOAM530i5n1o2TFdwCPw6BFNqr/tOVob9XBC/5y8P1IPdRY1bgP3d1cD
        dtB+yiSayMX3xSpdmHOsv3E=
X-Google-Smtp-Source: ABdhPJyEsGHwkZhS17UFs8fmzJKN6V1ociic6tjpUeU2Mq8rOGYWbgEbM6CBAPQAaYO7+olVyuoSLw==
X-Received: by 2002:a05:620a:c52:b0:648:d550:5583 with SMTP id u18-20020a05620a0c5200b00648d5505583mr2932763qki.232.1646513743854;
        Sat, 05 Mar 2022 12:55:43 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm5877525qtk.8.2022.03.05.12.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:55:43 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] KVM: Use typical SPDX comment style
Date:   Sat,  5 Mar 2022 15:55:23 -0500
Message-Id: <20220305205528.463894-2-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305205528.463894-1-henryksloan@gmail.com>
References: <20220305205528.463894-1-henryksloan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Henry Sloan <henryksloan@gmail.com>
---
 virt/kvm/dirty_ring.c | 2 +-
 virt/kvm/kvm_mm.h     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 222ecc81d7df..f4c2a6eb1666 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * KVM dirty ring implementation
  *
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 34ca40823260..41da467d99c9 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0-only
+/* SPDX-License-Identifier: GPL-2.0-only */
 
 #ifndef __KVM_MM_H__
 #define __KVM_MM_H__ 1
-- 
2.35.1

