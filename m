Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A894CE6F5
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiCEU2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiCEU14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:27:56 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB1A5F77;
        Sat,  5 Mar 2022 12:27:06 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id s16so805567qks.4;
        Sat, 05 Mar 2022 12:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29ovwB48anktERLMPCyEgINdzt1pLgVPcEHPNJUixaA=;
        b=FNZ9hPBC8sjIzuz1EiBPSmtTFLkQxdRjT/31n7HEQdYrw2RG6BINrV5z8QQ2K7WIkI
         wnmiP2n/cy2Hg6hD4qcCeyeASULLX9nAdo9/DH2EXVCoIoNof3aYN2oi9asdZiR29Ctk
         lBx0MAI1MqhrOexBc3/LEoFPaJnx0ws+cZhT8c8tAvOUIhKz51VPJ3EgsojDcy6q5Bor
         iRjAo8keCEde0jjiK7BwRWi0QGrMVyyFRBR4f3sH4KAJFtLB7OhLcXFrs9IQlSSfQpHA
         z++b4YoPRgB3Gdw8eQdD5eMsg6AnusIP1qT1YopJAh9r0PIS381ZJMMMOlTR4+hzoklN
         FZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29ovwB48anktERLMPCyEgINdzt1pLgVPcEHPNJUixaA=;
        b=AQLaeIY7LdRILuZC3ho+XTncJInHr92biXuNMCBOuXept6zg08brDgVL0akr21wB9B
         xHo7u0QQsybSJtjkDUW6+7HrdcDQWANdnwQQ9kETf4B5cYYI59Ufrx5IMBHoysl06JA6
         o9JJD/1ky7kEgitxRlLyRw4ETPojTB5H93VZqnkqiOUwZt9XOlP8qwIGK+dcV+nJW+3L
         hxIo7jm2viM9G+7TWVcsfRLP36j9W0NgPyI3UiWp3y6ErsI1tOl1C1pmk+dwhfP1lpkP
         iMHX3PDjfgTwTb91B24uKrxievs+O1UmJoirsEwzlm/PljO3qtENuAozd40/majZksZN
         bzRg==
X-Gm-Message-State: AOAM532XlXX4ZD42OzVqAoUpD+2oJNfZEG6tqs7pjxlpNgfSRSfkbiWo
        v+087luLx//r8iCJSL2doaQ=
X-Google-Smtp-Source: ABdhPJzbVJvptsTu4/TqWrNtMxGE6vN+P3tDpCsfRprNTl/Gyv8Xb3MSMRpuMQ3yuYgB4ybYhQByxw==
X-Received: by 2002:a05:620a:2541:b0:649:60c8:d689 with SMTP id s1-20020a05620a254100b0064960c8d689mr2839444qko.664.1646512025503;
        Sat, 05 Mar 2022 12:27:05 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id e9-20020ac85989000000b002de2bfc8f94sm5654208qte.88.2022.03.05.12.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:27:05 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] KVM: fix checkpatch warnings
Date:   Sat,  5 Mar 2022 15:26:32 -0500
Message-Id: <20220305202637.457103-1-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Fix "SPDX comment style" warnings

This patchset fixes many checkpatch warnings in the virt/kvm directory.
The warnings and errors that will remain are of the following kinds:
* "memory barrier without comment" warnings that don't have trivial fixes
* "function definition argument should also have an identifier name"
  warnings
* Numerous minor issues in kvm_main.c that merit a separate patch

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

