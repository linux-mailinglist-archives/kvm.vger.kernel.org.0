Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06C7640C71
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiLBRpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbiLBRp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:27 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923B6EFD2A
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:11 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id c26-20020a05600c0ada00b003d07fd2473bso1955411wmr.9
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4+qWJurAOH4Q75h2TLkoqQeRdLRNZJQrceNDqoL1TZ8=;
        b=BXEnd9RLsRVLBMzRUYnEpE1fU3R++U4Nu+XsV23SMEn55IEZroaqj0pjxMGzdvE8pp
         9QdMSuHureSfZPU+UAEluTeFHQO+1lQ0uV8HfeU4z8f0NbraVIUOBbmdRU6+1tbmU4Y7
         ZzGqbWFTZzwxvkF+iUz6OQvAVu3fu4vcIG2sbbwekDFHB1AA3eePrA56nRN6Znk9oshF
         lImYGS/YTagTmjxgb/yfWNEX1OsODL7ue1bQh8jFPqIUVjky66+YoDZ2pHL/mQYUa6jV
         wLAjB8yWXLRFOK2VDv2GqQNoyXtE3IVPcDVwE6hqOLlGs/nXGDO+F1csgbBsDT6VZedO
         ORmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4+qWJurAOH4Q75h2TLkoqQeRdLRNZJQrceNDqoL1TZ8=;
        b=Wi6CqRJnW+bmwVULiemMKRgbEeUcGeaZTfkF7W5U+QF6LpzN1Lx+eG4KE9G4aIqO6s
         F57C0xoIKcSTmBl0WbPul3QtR3e+ehCx5a0vRx7jr2F9q0aIuQq8LlX24czEWBJHlquy
         22frYvZijjmb4A2B099UHAW23UYJobS17sLlWJoa1FWPsACAaE8LOIG+Nmq/eRm3st6T
         J5fTdn1ij4fGQYdRkSFaEfdkfhrQct+LNR/+qPfSqAAHOx7rE7dLDqWgUrWRsH+aVK7O
         Ri+BaIl0vrxTVOxiJMscsobDedslBKyz4BtcouwNrEZSQTVseNC622a119UrA/W1yfEA
         a2fw==
X-Gm-Message-State: ANoB5pmRHBzfWWNLNPI1iV+atwnrx2ip29nAVSZnvjH6CsRpO1g5SDS6
        hQisKhQEb9x4vsiXTB+u7BVFIULJSv4k+LWElSj/kJPDw9PUusYEa/fAiRbKZxFOF9habPpChMK
        2uFmdfuXrnwtRLqlSeErvQXlJgI6cVzfuslvaxtSoZpZxgteozDvWqCg=
X-Google-Smtp-Source: AA0mqf50EftSpucIJunkyF9cz3Sg2D2WWnpg9pQZK8pDqLbmuGpyZ3B7yOCEVMCIHt6L4HzCnyQGn3qvsA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c9f:b0:3b4:cd96:1748 with SMTP id
 k31-20020a05600c1c9f00b003b4cd961748mr204711wms.2.1670003100209; Fri, 02 Dec
 2022 09:45:00 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:04 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-20-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 19/32] Add memfd_restricted system call
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
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

This enables building kvmtool on a host that doesn't have the
kernel with the new extensions yet.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/util/util.c b/util/util.c
index 1f2e1a6..1424815 100644
--- a/util/util.c
+++ b/util/util.c
@@ -10,6 +10,17 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
+#include <sys/syscall.h>
+
+#ifndef __NR_memfd_restricted
+#define __NR_memfd_restricted 451
+__SYSCALL(__NR_memfd_restricted, sys_memfd_restricted)
+#endif
+
+static inline int memfd_restricted(unsigned int flags)
+{
+	return syscall(__NR_memfd_restricted, flags);
+}
 
 static void report(const char *prefix, const char *err, va_list params)
 {
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

