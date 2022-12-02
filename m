Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED13F640C6E
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiLBRpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiLBRpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:09 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826D1DEA75
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:55 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id o10-20020adfa10a000000b00241f603af8dso1254252wro.11
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ru8qbdvAloJLwy+YGAn5IzE203RPNqWWa5fSGCZqBCo=;
        b=jKvyUlwdpl0YKXAJUrLmjMPBIDPj/ChNCuoXhRm98+hESGUiyCtw4pigFVZXMyU1ju
         HYuzZJAoDIRGeZfBObvuM/nptO+ml36NAm8a0lVA3cDhWsvAEsvbuxMNIREEo3aAk0Un
         tJnhvpHGila41E/L1t0JdzzCDBOIdgBJXQxpm9tzXjWIGKpM8wpMkJsvZAR3MxNpF2Jz
         Hp49Px4I8eFbQEUi78E6n6bin4JIU4HszFBQTQ86xwNjw0UWooJsQy3HdLTHZ+WpyVDi
         TUemRzDJzso8O6K6mRfxjWURbFo2Th4C2rWliFavcaLWQbDu+Vpovy0cFRzQynpdSKmv
         qoug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ru8qbdvAloJLwy+YGAn5IzE203RPNqWWa5fSGCZqBCo=;
        b=AIL7+haUaQHPrVy/gwMsajqJ1NOVRaiG8LdlSYbHLdKoNmjXlcjtsnTCdiGVDJz8r1
         a0a6iRb/S0ZefzNfkw4wrupBJf40N3h5JzRODApBz1x6kgjigvK8OQN6Jo109/RmnMag
         hDSJJo7y/THXZxMfs1RqwXcI2oGCpodGtJYc3m2BamaQjDcuUi/uo/6XmUKxbJhmDLrj
         05S6+UC/f6OM8CCGpTIXzM1MKwwq5mQUFESnURUHwaeRjfRqmVl4rvu/PVqBFbwcqXmA
         4nq5dZtez2yEGng4IZscCOqRbndYha720UjqaZN+s/jnJVP567U309jQA5+OwJMCJT1v
         CSHg==
X-Gm-Message-State: ANoB5pkaq81Pvdh2SZDcfgq+fVpoAPa15aXLzUqpFMb2lzDYWFay1iV2
        xC/9v2V3bDRsdLUqx3luCGOiepsnnLvQH5HOMmnhFFmqFfWq6j9zFNo1Oke0bNlT4ef/su80GNR
        aO5RbeBFLZzcSb+qkui/w51s7dssLUdhxS5OE5sTFUcjoQEMUNop0GLU=
X-Google-Smtp-Source: AA0mqf6PTb77JiquoUva7B0ZaY1i+B88dlD/YT6FogNOrGUtp+XZqAHOL51r4orhcL94vmp0VCXVWC2oNg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:1e0c:b0:242:3fa4:820d with SMTP id
 bj12-20020a0560001e0c00b002423fa4820dmr3875680wrb.564.1670003094138; Fri, 02
 Dec 2022 09:44:54 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:01 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-17-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 16/32] Remove no-longer used macro
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

Not needed anymore since we're not doing anonymous allocation.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/util.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index 74713d9..79275ed 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -35,7 +35,6 @@
 extern bool do_debug_print;
 
 #define PROT_RW (PROT_READ|PROT_WRITE)
-#define MAP_ANON_NORESERVE (MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE)
 
 extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
 extern void die_perror(const char *s) NORETURN;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

