Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F642D0824
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgLFXmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728623AbgLFXmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:42:10 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDEFC0613D1
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:41:30 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 91so7087425wrj.7
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k4WG/zg3A8ipr+8A7P0n4m3RDjKDl/Q06gfRVWrIvHA=;
        b=CjcdPERRFYdDm7Pq8nJzQdznI0uVtZpeDPO3WiImxywEkNRymEGw3O+sZ22xkrGx5/
         bFDTITaUssJz2fpNucSftj2HmbFSrHezuDKTlZxJbK8dwwFA2DcFmq7o9w/134W9cCKi
         3ARmMzZ9ID0hkxT/8DJNST9AHvUxO4KoFX0tORXJnt0ZTP8n1Q3Dbeo0WxzpQQIuru27
         yAkx+F2wjMu2Xwmcsp9Tftqw/uBUWbHKbD+NAsK8dmWmMhW4TKYwUSRKDE+TROTp8JzE
         k4rZJuzsSdwvxfCQDv4J5klz/iUt2Xmsj7boknXR/GV1mLiIz5ApJ5PD8hw0wulZerRo
         oYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=k4WG/zg3A8ipr+8A7P0n4m3RDjKDl/Q06gfRVWrIvHA=;
        b=bMbTu9gkcR+n+Ro3usEAYMrrfngCS+CdGNY8b8AIkfs/GQw495Uf+wF7KGEOxEAQe7
         jZ8ziWECe9H5G4C3nrYqJ9QwKE1MfH2zvmTDEgIv2/4EQBBMJkPmhsD6c3zIs94PAPh9
         aC9CcjRD1JHByUFBXJeZVym8+oFRO6CWiz6u2HYaX/fHml4j/ilunUKceVjSisAajQS9
         8Jh+cm9J++rs3oJNwbQYbHbBK9N4usDbHIuu4/XEZ1KiJK8I7CR3X2CzzxjBP56CAR2k
         Pib/gdd4itvz7XBrlhvDUG99BtX5PJ4IJ0MGd67ZLp7+HfOuVQvEyuJWPruNkYZb9JeH
         fm1w==
X-Gm-Message-State: AOAM532KO35vpaEDqphRYlrxiJ9S7Giu+1rqV5Vah5j5R6H3Mq6B8nrC
        X/YKNOzghnM2cGYlgY6fL3E=
X-Google-Smtp-Source: ABdhPJzlEBxNwEXGOad/lFiRSGUTbNn0/EeExTcljG+Dg6lArdB7sGAjkFzn+Ckd4AU+UsiZozhsiA==
X-Received: by 2002:a5d:6842:: with SMTP id o2mr9986471wrw.132.1607298089266;
        Sun, 06 Dec 2020 15:41:29 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id s13sm11135976wmj.28.2020.12.06.15.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:41:28 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 19/19] target/mips: Only build TCG code when CONFIG_TCG is set
Date:   Mon,  7 Dec 2020 00:39:49 +0100
Message-Id: <20201206233949.3783184-20-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
We are very close to build with '--enable-kvm --disable-tcg' :)
---
 target/mips/meson.build | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/target/mips/meson.build b/target/mips/meson.build
index c685f03fb28..ef70d9040e2 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,11 +1,13 @@
 mips_ss = ss.source_set()
 mips_ss.add(files(
-  'common_helper.c',
-  'cp0_helper.c',
   'cpu.c',
+  'gdbstub.c',
+  'common_helper.c',
+))
+mips_ss.add(when: 'CONFIG_TCG', if_true: files(
+  'cp0_helper.c',
   'dsp_helper.c',
   'fpu_helper.c',
-  'gdbstub.c',
   'lmmi_helper.c',
   'msa_helper.c',
   'op_helper.c',
-- 
2.26.2

