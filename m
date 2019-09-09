Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC80DAE17C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390034AbfIIX24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 19:28:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34927 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390012AbfIIX24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 19:28:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so8749580pgv.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qVl7cQbHqivg+5+bjZkAPrH4/YkagYFqBsqHpTn7Ee4=;
        b=WRsagKgPHRVWRodqOxjFyH3SxApwemVrFs+C4fnZP36b/kGtMnwy18biKBGghKT4FY
         r3mwmnzylOimTxzwHNfkTtS+xJnFwvv8FVNYNNX3Yjj1QLWsXXMboecQJftGZkj6H3gm
         H1XRadrTmtfTPOBhRNNf82rThU+sJ4lN+9Y7MUmctoEa4sImtm6/tJJjFoB/4eOIF8LI
         gl3ZYpUdOt1KjT1meUv58ZQJHA4S7wCWk91e9+ku7WGZmXEue+VVya7Q+00O6Yq6yWR3
         G9KdJLg3g/SQJ0h0nxsK8WBk9BNmfHE5vMWQaWz9q+6euy0HQCtfxh5AC4AwcXWr3/oF
         dtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qVl7cQbHqivg+5+bjZkAPrH4/YkagYFqBsqHpTn7Ee4=;
        b=gnX3x0AzEXcZosekvz5ag3LrkMX8ulqKG9SLJJL2X/iK77PdwJzOqbfW0p9XORbaI5
         n5T0LfvZLeT471VL+Fu8ImK566MsSYExa0MVKXIrsGTrLAt+SNTzekcGSLWxoNdXQDPN
         xC2a886ZPu039sjehPE+7B+e+zwrE8rkkYKp0oeuNrGKCJt2DZu9OMfUabuJW7AVth68
         Tb7QfC3SG6SaRhZ7L5vSgMvmYGzgew4HzlMK4tigEpbjTSFcr8sQv+EbepJFVPzSlEqu
         b+henGuAegUFY78WpjPIDMMSjpKneM4omX1FLft0c2bhj56uHiEQh9bJYij1XzwDv2Vh
         s9Sw==
X-Gm-Message-State: APjAAAVH31nJMfiPW2pChrBru59uYrrnfcwygHULZyJJP76BWMB6mt/Q
        Akc84mEXWoACaDBO1a3RroU=
X-Google-Smtp-Source: APXvYqy74ypbCbkeOd3DP0v0kuCuTg9ctzC3gCjVLeu7UnM8pah7J4FtODCIU/4r47JUwH7t6E+DOQ==
X-Received: by 2002:a63:dd16:: with SMTP id t22mr24577946pgg.140.1568071734456;
        Mon, 09 Sep 2019 16:28:54 -0700 (PDT)
Received: from localhost ([47.88.172.238])
        by smtp.gmail.com with ESMTPSA id d14sm24833225pfh.36.2019.09.09.16.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 16:28:53 -0700 (PDT)
From:   Haozhong Zhang <hzzhan9@gmail.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, Haozhong Zhang <hzzhan9@gmail.com>,
        Haozhong Zhang <hzhongzhang@tencent.com>
Subject: [kvm-unit-tests PATCH] Makefile: do not pass non-c++ warning options to g++
Date:   Tue, 10 Sep 2019 07:28:23 +0800
Message-Id: <20190909232823.24513-1-hzzhan9@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haozhong Zhang <hzhongzhang@tencent.com>

-Wmissing-prototypes and -Wstrict-prototypes are C and Obj-C only
warning options. If passing them to g++ (e.g., when compiling api/),
following warning messages will be produced:
  cc1plus: warning: command line option ‘-Wmissing-prototypes’ is valid for C/ObjC but not for C++[enabled by default]
  cc1plus: warning: command line option ‘-Wstrict-prototypes’ is valid for C/ObjC but not for C++ [enabled by default]

Move those options from COMMON_CFLAGS to CFLAGS so as to mute above
warning messages.

Signed-off-by: Haozhong Zhang <hzhongzhang@tencent.com>
---
 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 643af05..32414dc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,3 @@
-
 SHELL := /usr/bin/env bash
 
 ifeq ($(wildcard config.mak),)
@@ -53,7 +52,6 @@ cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
 COMMON_CFLAGS += -g $(autodepend-flags)
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wclobbered -Wempty-body -Wuninitialized
 COMMON_CFLAGS += -Wignored-qualifiers -Wunused-but-set-parameter
-COMMON_CFLAGS += -Wmissing-prototypes -Wstrict-prototypes
 COMMON_CFLAGS += -Werror
 frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
 fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
@@ -71,6 +69,7 @@ COMMON_CFLAGS += $(fno_pic) $(no_pie)
 
 CFLAGS += $(COMMON_CFLAGS)
 CFLAGS += -Wmissing-parameter-type -Wold-style-declaration -Woverride-init
+CFLAGS += -Wmissing-prototypes -Wstrict-prototypes
 
 CXXFLAGS += $(COMMON_CFLAGS)
 
-- 
2.23.0

