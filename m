Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA722D906F
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405355AbgLMUWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404268AbgLMUWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:00 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF20C0617A7
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:19 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id a6so11953235wmc.2
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Yr9a6Psm/oyHKmjhGMfMuU1IeIspGuWtps3QIVvufw=;
        b=Vn2q1Ow1BONmjF96cTF1iuZedFmZh8/Kfc3IyYU8GUDXnVkpse/tCYcuwZtedQiIuE
         bjkdIDpBrP1LcSAEuX82fBqYt73JXehS6eaUypgRP9CPPkUXiC6xA9aYBUlAA/FTup/z
         oZ1eiAZSZ/pl6LzxvDQZpSHatnOIAGUUQ9p11vZZ+KI7OHKfUYkGdMGqlPPUFdidgj9V
         UFFTaw659ZLAyICXt5Pzn1pl1QbZUmMDglxXYfzhBhP0u15wgDoZFJrmNTF4QEWaVWVE
         VV+VR3vZC4CKms5TJh60iwujuyC/XEIQH5zmEnlmhIMb2U/4M90u5G9fEPju4pAdEHax
         csyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=7Yr9a6Psm/oyHKmjhGMfMuU1IeIspGuWtps3QIVvufw=;
        b=bhuUYrhk6Z/DM5q5dzEN7jENVRMEeYgA4a+GBjiT3x877q0GkxtzBQTERq+FG90fkk
         FcPLrOmx4kTjlpE411Jgu3nSkr9RBbMSJFidh0t+Iaiiz0IUoxkFSKc9x6GEOVOPLe6Y
         HgMPFn1qNjpSXDpkH2Ox46j0o2iGFPVu7yPTvvGZ5UjtEg+23S9yF+hwP3w6uooH2Z9l
         vqLqG79IaWmpt77TJOSU8Kf83LIdW/cak3eDqxky3/E4fs4yqudBsJkzh2U6PjTeyTHM
         2vFXfiiJT1xl/8HkP3tPEMOTvlOL9Ad43NJrUM85rB0oHKbWthMyPlWiw6A0//8T8hfo
         IPGA==
X-Gm-Message-State: AOAM530y4kvOq01AJ5iGknWoidDq8FIIORTkHsY9oLF0v2otaeDy+mFS
        GXbBMsyCjtyiqn65e6IFQ3Y=
X-Google-Smtp-Source: ABdhPJzZI3n5VAnjAGiUXhbEjHscCsJk++wli2kENHVGP8fh2ufslHZhGmxtSJPM+1FKajpsttoGSw==
X-Received: by 2002:a1c:98cc:: with SMTP id a195mr24641019wme.150.1607890878540;
        Sun, 13 Dec 2020 12:21:18 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id y7sm28088689wmb.37.2020.12.13.12.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:17 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 18/26] target/mips: Do not initialize MT registers if MT ASE absent
Date:   Sun, 13 Dec 2020 21:19:38 +0100
Message-Id: <20201213201946.236123-19-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not initialize MT-related config registers if the MT ASE
is not present. As some functions access the 'mvp' structure,
we still zero-allocate it.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201204222622.2743175-4-f4bug@amsat.org>
---
 target/mips/translate_init.c.inc | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index 5a926bc6df3..f72fee3b40a 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -993,6 +993,10 @@ static void mvp_init(CPUMIPSState *env)
 {
     env->mvp = g_malloc0(sizeof(CPUMIPSMVPContext));
 
+    if (!ase_mt_available(env)) {
+        return;
+    }
+
     /* MVPConf1 implemented, TLB sharable, no gating storage support,
        programmable cache partitioning implemented, number of allocatable
        and shareable TLB entries, MVP has allocatable TCs, 2 VPEs
-- 
2.26.2

