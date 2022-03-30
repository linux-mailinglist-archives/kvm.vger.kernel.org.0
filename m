Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8346F4EBCFE
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 10:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244473AbiC3Izp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 04:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241961AbiC3Izo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 04:55:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45483C625F;
        Wed, 30 Mar 2022 01:54:00 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mp11-20020a17090b190b00b001c79aa8fac4so930658pjb.0;
        Wed, 30 Mar 2022 01:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxPG2mpbpgdg5W4Fei+LZxCM5WvyBZ/Qj+QMe9CK3jY=;
        b=fb9L9eiz8qiv7DPCbCwNZpgBKumJDRNq5mAnoM7B+Q55TYiAmg9/14WbKKhOclNjDh
         xivJd7PE/9U2zznTUtUX8hT0wq9av9saSlg8fWgFhE8WEF4cwPKrDYyQWP/DuE5b9NHP
         l/HLBNf73anYJlBXXmpvgMPAs+RJTRDnCpo2MBFoFyYomBhZgljwD8s6QBK8VZxV2vUK
         C8UPMRhJlJFozi1vMmjhtq07SD9pg+Nq8OZKckgoEE9qDnWQ2BPxRAzyRBxsN5MlAGdM
         e/i4eZUb3/VebNYF/AkAt6lnLgol7sm2KT81hBQIXzvQwTpIb2zArqkRdKnnqAP8ykIA
         SCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxPG2mpbpgdg5W4Fei+LZxCM5WvyBZ/Qj+QMe9CK3jY=;
        b=CROiM9QvzXNU9Q2TKBmluY5dTCruz72c/5S32e9qm6G9qInq2l0lV5Lfvas+H9LNFN
         m54K9MbEJ4AbCzwb1LlBNIDharYfaUO7FXtb0Z24sxyGnb+Lx+myaB4hEsAGQ9VagKUb
         LOiHaoqK8+pOvJkY+n07Jw6l3jvbSk9ss8rzALWMh0bxa0WtdcmmjQ/BEZ07nHTvCD+8
         Q8TdsxFXlplF2eOubcaV+rAOyuBwydqbUULHLO4rmBNGtai4ltdrGM8d5TuZs3qCgJzK
         9++zuiOp9j22Crua7vuO/ARiiGheoz61bcwgayw8C1mxUGy39NotntuYCqOs503yEzz6
         0BMg==
X-Gm-Message-State: AOAM531POkB7PlS5rSJATpHiFKSD0KqEJO7bEf4udSqqyPm5TwUoQiHq
        ONs/MuRudEjQuBEmfqBlJ2yM8LMuCXIhJg==
X-Google-Smtp-Source: ABdhPJwMwBaLic4lwVwv7/0D/7PuCm5tTIxAiD7c7QDxF0gaX268LJTtGRFkZwClWHc8xcRCZktbcQ==
X-Received: by 2002:a17:90a:8a05:b0:1c6:e527:c613 with SMTP id w5-20020a17090a8a0500b001c6e527c613mr3824656pjn.143.1648630439739;
        Wed, 30 Mar 2022 01:53:59 -0700 (PDT)
Received: from localhost.localdomain (118-166-41-36.dynamic-ip.hinet.net. [118.166.41.36])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm23674796pfc.98.2022.03.30.01.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 01:53:59 -0700 (PDT)
From:   Zhiguang Ni <zhiguangni01@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhiguang Ni <zhiguangni01@gmail.com>
Subject: [PATCH v1] d_path:fix missing include file in d_path.c
Date:   Wed, 30 Mar 2022 16:53:35 +0800
Message-Id: <20220330085335.350416-1-zhiguangni01@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include internal.h to fix below error:
fs/d_path.c:318:7: error: no previous prototype for ‘simple_dname’ [-Werror=missing-prototypes]
  318 | char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
In fact, this function is declared in fs/internal.h.

Signed-off-by: Zhiguang Ni <zhiguangni01@gmail.com>
---
 fs/d_path.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/d_path.c b/fs/d_path.c
index e4e0ebad1f15..f9123b84f1ba 100644
--- a/fs/d_path.c
+++ b/fs/d_path.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/prefetch.h>
 #include "mount.h"
+#include "internal.h"
 
 struct prepend_buffer {
 	char *buf;
-- 
2.25.1

