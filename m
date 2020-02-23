Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340B2169AA1
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 00:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBWXNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 18:13:13 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39634 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgBWXNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 18:13:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so8218517wrt.6
        for <kvm@vger.kernel.org>; Sun, 23 Feb 2020 15:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=17jafNN09kR214AJV/UiO1WaS1l0h7pxacDQ7S+m8cI=;
        b=jliOvUS8RqUtzGqm9QO5M//+Js5++/fGeLeHvbawBnJF685R0C/LKXuYiCAg1Ao/FU
         5vIF9m0fLIcj4zm0mtLhXcJ3kXeTm4LcCVsTUT/ecUhNSzwC6OV39mxcCy7xuOOFx6HE
         LExChMI7ZqP0mGuZtYRX8M05JcPjs0iFfMVwieXJvpj1Zx21JpJ3l9mrVdF+GihoOBV4
         lCcJkQPK0MoXcWRI2/QSy1KRW1I/KnddhJQWiYQ006ujeqLHLBX2kx8Jirb9WER3xfpe
         xV0Ch8UySlBbon9WbcZHnuhnJium6w7UopPjCh4D4aLeqBiXrkfKUAwzcXDke8axFU3y
         Znhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=17jafNN09kR214AJV/UiO1WaS1l0h7pxacDQ7S+m8cI=;
        b=p1NgB6iq4/dOqG7rjOlBTFL4ajXbmNv3I3iutBaKf0kQOBM27aBB6q2YzI6IeoFR5k
         xcM7rX6x5xMRcEX1a2GLNMBB2hdd/qUE3K5UvAr2hom1YvPtQXRbFCmZIm7RVqgWT/Ld
         h/Hk4VeNR1Afs5BRUwQQ49iApR8dHW2oZ07RUy4LsYplvCcOkUhJoOBW3H3x9Z80QAiL
         fIS6Wm9kWBSHxX0jC5/yJ1HXrfpbd1BJbgzMT57EDAAVdOU6I4zYrNAA4fU+TBVbpRQv
         9YQl8pOqmz5MoOmKYUqN0b6Mnj43erR3pwYZGR0WbmD3MudVENezAqCVzrXryB6kw2Dz
         03xQ==
X-Gm-Message-State: APjAAAVMHxRI6tUakVeigBFVMhUjaI5Vr3h1olJm5x3vbJz1Ovcg+wVp
        X4V5kN3B5NviVysKd9WK9jhKBio6sDc=
X-Google-Smtp-Source: APXvYqy5GvHfvDu/xIN6Q/aavdQ6vgTyeEPdVzYXI39bUwpPGwsrO7O8orUVEov2mT3qy4HM2QkTFg==
X-Received: by 2002:adf:9d4a:: with SMTP id o10mr12871277wre.392.1582499591334;
        Sun, 23 Feb 2020 15:13:11 -0800 (PST)
Received: from kali.home (lfbn-ren-1-602-70.w81-53.abo.wanadoo.fr. [81.53.179.70])
        by smtp.gmail.com with ESMTPSA id v14sm10485050wrm.30.2020.02.23.15.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:13:10 -0800 (PST)
From:   Fabrice Fontaine <fontaine.fabrice@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [kvm-unit-tests PATCH] Makefile: fix stack-protector tests
Date:   Mon, 24 Feb 2020 00:14:14 +0100
Message-Id: <20200223231414.3178105-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename fnostack_protector into fno_stack_protector and
fnostack_protector_all into fnostack_protector_all otherwise build will
fail if -fstack-protector is passed by the toolchain

Fixes:
 - http://autobuild.buildroot.org/results/ad689b08173548af21dd1fb0e827fd561de6dfef

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 767b6c6..754ed65 100644
--- a/Makefile
+++ b/Makefile
@@ -55,8 +55,8 @@ COMMON_CFLAGS += -Wignored-qualifiers -Werror
 
 frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
 fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
-fnostack_protector := $(call cc-option, -fno-stack-protector, "")
-fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
+fno_stack_protector := $(call cc-option, -fno-stack-protector, "")
+fno_stack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
 wno_frame_address := $(call cc-option, -Wno-frame-address, "")
 fno_pic := $(call cc-option, -fno-pic, "")
 no_pie := $(call cc-option, -no-pie, "")
-- 
2.25.0

