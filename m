Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEC309BC8
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 13:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhAaL47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 06:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbhAaLz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:55:29 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D052C0613ED
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:22 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id z6so13442648wrq.10
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rd+PClqm9GCes/hSRY8Vwer9UM1+ZxmgnVmbkhC6bwQ=;
        b=slxe/n+gWVTJ0YqCL3Bn1rdJcLxnKsXS1n7WF9oDy93hJBrTu2I3a2iCbMx2QDDRf6
         cvW4fsFH+RBNOH8Xizz/iAt4S26E5y/x/GNkhqNZmKoFK0IiYXFUyThdM4/jwqc/fgDh
         Y8sSf3tw+ovhP/bOMS00qPGcsrcwEr4MAVjaD4Adx0t14YzqI1NvnOJU9VgFgQeaG54O
         V+6f04a2Rwu6cmu95TNxszsXA3x1TBUu0rBat0w9gSOTxcp7PNPqNvAJyHXskdJMCaKx
         yFY9GcHTyxHSb+UJ+i+xVssw6kxrn3Nc/CZDLYpgrtE9kqvzklrUNMRkM1Y9GXFVF1zD
         r1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Rd+PClqm9GCes/hSRY8Vwer9UM1+ZxmgnVmbkhC6bwQ=;
        b=NSoOHmmFs+SWv7l2jZGixxG/dmktPlLPFiko/TS0O1RNqqzcTrpt6MRIQAHYoxEgc3
         3nMyPsdAKk5Z13SCmJwUBTG/833FxHVrhr++yVvYW6j7v1oahdQDCEGmqJ0zB2z83zPv
         FAnXKbeoVR7QtU7gf3Iuvb75sRDCUc6syNWRCrjlRz/EWY5bw0XBZF1G/wzPDmuM6gus
         nXW7978o739vevroHpOiK4M7+tRcmZJdDJohGXlsDIerZxBVCgzK9l5izkXRPOX3IZmY
         Z6odbnI5GDvMQqbY2jRadH+yMmdzyCxjjV5LjfqUqbBL95F14KvUVB5r8uikDoSrHSRq
         3/ww==
X-Gm-Message-State: AOAM530t4OfNgDA7EISO552xV3hAoVfm7T8mONZ+D4zcLCKYu/FnN6n/
        /cS5D+BjY4SYPxQFN/2+aPU=
X-Google-Smtp-Source: ABdhPJyhH4FzLWznIwV2JMINXQ8Kq1HB+Q7Ewfh1h/EdNga37TZknXhQRMlYya4ZrjBKEH1uV/ip3A==
X-Received: by 2002:a5d:6c6b:: with SMTP id r11mr13497246wrz.38.1612093880944;
        Sun, 31 Jan 2021 03:51:20 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id h23sm17669371wmi.26.2021.01.31.03.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:51:20 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 10/11] target/arm: Do not build TCG objects when TCG is off
Date:   Sun, 31 Jan 2021 12:50:21 +0100
Message-Id: <20210131115022.242570-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We can now safely turn all TCG dependent build off when CONFIG_TCG is
off. This allows building ARM binaries with --disable-tcg.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
[PMD: Heavily rebased during more than 2 years then finally rewritten]
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/arm/meson.build | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index aac9a383a61..11b7c0e18fe 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -27,7 +27,8 @@
   'gdbstub64.c',
 ))
 
-arm_ss.add(files(
+arm_tcg_ss = ss.source_set()
+arm_tcg_ss.add(files(
   'crypto_helper.c',
   'debug_helper.c',
   'iwmmxt_helper.c',
@@ -38,12 +39,12 @@
   'vec_helper.c',
   'cpu_tcg.c',
 ))
-arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
+arm_tcg_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
 arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))
 
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: files('kvm-stub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+arm_tcg_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'helper-a64.c',
   'mte_helper.c',
   'pauth_helper.c',
@@ -52,14 +53,16 @@
   'translate-sve.c',
 ))
 
+arm_ss.add_all(when: 'CONFIG_TCG', if_true: arm_tcg_ss)
+
 arm_softmmu_ss = ss.source_set()
 arm_softmmu_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
   'machine.c',
   'monitor.c',
-  'psci.c',
 ))
+arm_softmmu_ss.add(when: 'CONFIG_TCG', if_true: files('psci.c'))
 
 target_arch += {'arm': arm_ss}
 target_softmmu_arch += {'arm': arm_softmmu_ss}
-- 
2.26.2

