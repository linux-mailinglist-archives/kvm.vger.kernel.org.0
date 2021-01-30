Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A465309416
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 11:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhA3KLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 05:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhA3B4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:56:11 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC38C06178C
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:22 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id u14so8142492wml.4
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rd+PClqm9GCes/hSRY8Vwer9UM1+ZxmgnVmbkhC6bwQ=;
        b=S8gP7rmCHgjQ7YTM/ADW7lbRknMIzFi/kvGjnDTBiXVwxuHAweAduqVLnoWGJLI2Ik
         JfdEKMmuSM3Uo8wpGPc7O5efkIfwempgLB5LYyAxcpbOduzxSzOy25mGYctn0157CNuf
         zV0ZhHXDZP2UT03nYTizMXR4Vs40tQPbvbnOmuxLCvtPCrY0PMsdGMwTdM2ArhKkBchH
         TWyvRrzcqLAWdaanShYSz+sOqcrd7NvfsPGFpWW+5oIunY8vE5ZXCX2iLvPjoaAaSoPR
         DrMJQdIPKVgaAINimQlPBxGcMGIfkres1tY3aYap3kkTCgMibqAulTso5blHDtdlfoUu
         cwiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Rd+PClqm9GCes/hSRY8Vwer9UM1+ZxmgnVmbkhC6bwQ=;
        b=lJ2hBVXrGDBO6wOT2n4tYxn/Z4rr5wIRrF1HGlDXIbbtSXixiXgDar8F4GdODb7/z3
         vnQ40LN/vnwvn5bK3/Uwicc5aB24YGys1jb3imm7s7m1tbsqcWACabstpbeER8Q7o1dx
         PQHgEH2R8EpVRyv2idG4plGebP+QiqVeWcAI7SozdgVNFeYOlc3cONVUh0zUtCJdtL+s
         NqcweajiysQzNYRe8klgdzZyhKhhePcdd5JoEcXJPioBabb7HZzIokGVF1jCNDPOtDAB
         QdD63omDTsATfH2TmckHTf8ToSVrV4QC3ytPb2rpqhfBQvqm6ziAx493YB2t9FBLvPR2
         VYAA==
X-Gm-Message-State: AOAM530HCKgS6zTu2/BVRK8f/TRnsm1a0Ti2STyq1QuktyS+gWF55Hv3
        j3l5+HUnZwEp/PCIvWh2VMg=
X-Google-Smtp-Source: ABdhPJyiwfRfgUFvof6J96IEb3nlU6yPh2kst4/42gIlUzuKzVr51L9y/LCynY6WSCm+1mWXoo7usg==
X-Received: by 2002:a05:600c:2204:: with SMTP id z4mr5915886wml.138.1611971601791;
        Fri, 29 Jan 2021 17:53:21 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id g1sm15181177wrq.30.2021.01.29.17.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:53:21 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 10/11] target/arm: Do not build TCG objects when TCG is off
Date:   Sat, 30 Jan 2021 02:52:26 +0100
Message-Id: <20210130015227.4071332-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
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

