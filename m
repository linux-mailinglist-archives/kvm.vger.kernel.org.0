Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536252D905C
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbgLMUUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLMUUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:20:45 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26226C061793
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:05 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id y17so14366834wrr.10
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vNFKJu+n4IZ/CMsPrcMiCbRPKxOJx+sfVgOoT8DzTzM=;
        b=CyOXhXqwoUkfAHoDJ5+Gr9Hbrb+VgeWX8hIQ/FNHc3Hb7BLFVqGC3+E3dFjW5fWpK2
         NRW34VR85opUiAoszJTDQUgchzByaZeYWoCmzg/UHX6imyHI2CIfws6UhWbrpp2JG8lN
         DTVs8W9OoeRiDkStjIGXi9phFLw/ahtRXN4O9fCNObwvwM05BNrZu7grhxs5ZqHpc1I9
         kHi5SMU83DA3eaCC9teGDk+Fi5d2G7J9SdtY2nH5Igv9F1sfBYmzRaWoSXFaoftMVp9w
         XALx4Whce6OghuL7VrmTJH8frRaQ09eyU3UiJAn+ft+nb1E2OQE++y9J76PKMuPOPpEw
         2Uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=vNFKJu+n4IZ/CMsPrcMiCbRPKxOJx+sfVgOoT8DzTzM=;
        b=Xsd2c1jdwtTyE9xsewqYJNHCTUVnQyXAtJjV650lUbb+CNrbRI9a1BIAkEGWjRqclf
         WuCeKeY1sYnAyVuLvGwCuuiQmuTr9zBF/2AKa1HG8HVIhUPSqgyjqKPk+DhSKQAfQhbk
         GoEWbRFyXL9/7OUmapsSKRcvMKK3jEUhLoAdXtms9nRG/+08jjT5fTUpZFRILXY69Q7e
         WSUZrYUzTzLiF/Drjn9AhU3ca69OJK5AKOx3RvYqlduQXaiptmT6hN248b17d3U2Zstb
         6QSqNr1xmm+iFZteHEMut5sRjYVVlUQuN/p34batL5U97O3so2XzjzRtA8UOuVmMl2jL
         flyQ==
X-Gm-Message-State: AOAM531nsB48n/PQddp9IRLtXTFwEyGC7cWiRcpJxk7KJ1WkIvdYxlMk
        ZicwVUK1FZ86uB2P56mgiJQ=
X-Google-Smtp-Source: ABdhPJw3B2k1CxOd1n/33Sb1EtYQBldcALPKmiH+xNbh4q3vPykzdo6PwXeiPFYLzDkgmyv3WTcvCw==
X-Received: by 2002:a5d:4242:: with SMTP id s2mr25494476wrr.187.1607890803857;
        Sun, 13 Dec 2020 12:20:03 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id d9sm29807500wrc.87.2020.12.13.12.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:03 -0800 (PST)
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
Subject: [PULL 03/26] target/mips/kvm: Remove unused headers
Date:   Sun, 13 Dec 2020 21:19:23 +0100
Message-Id: <20201213201946.236123-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-7-f4bug@amsat.org>
---
 target/mips/kvm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index cbd0cb8faa4..94b3a88d8f8 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -19,11 +19,9 @@
 #include "internal.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
-#include "qemu/timer.h"
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
-#include "sysemu/cpus.h"
 #include "kvm_mips.h"
 #include "exec/memattrs.h"
 #include "hw/boards.h"
-- 
2.26.2

