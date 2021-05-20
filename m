Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E038ADAE
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbhETMK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbhETMKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:10:03 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95FEC00F789;
        Thu, 20 May 2021 03:44:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so5205219pjp.4;
        Thu, 20 May 2021 03:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LRY+3cJVXzz2zcOenbypgu3Wy1PZW3y4sq5PxyFROR0=;
        b=sx5X8GbCdxGlmtdtk6i28Qbu++UYP1OyWcUVsh1Z4P2G8nPl/BajRPrYBl6LYmbn/G
         2d51AT2Mkf9nIaR87KlwB4g1DWNVA37B2MNmKD43CxxIjFoo9ugktQpMVZgace5+9D0s
         WasPefkQS8WqT2cKX3WTUgcpyDpzg5gVn7sS1B0J+0L0IlNzcDR+yHOEp/aeBGGx+7mx
         4yWxEPkJEvuuhN7HL0nlV0qd8xbBe+W00H97ivLM/SMsYTumY+cZFpHJHDL5uKZFu6AR
         zMLL2DTaFPST0lbLuyZXLVumbFybcj04+sCGEP+2INQ8g5EI/KUettMabLV6qWKuHHuX
         etIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LRY+3cJVXzz2zcOenbypgu3Wy1PZW3y4sq5PxyFROR0=;
        b=SDu9KhNz1JA/99UqbtnmFjXYSeUyi4wbypBaN/dcxlLV2vapd4gjwDxeD2/F7xCz3e
         CMaCs3NUdCWP3WL4qY9ucLkc+5kq73mD3gRen6q3YGoUVMXqDXadOqLJ7lAHKeWcbs1+
         gbMSTLcTOMYBxEFHBQfF77+nqyHM5brDXOY4SzfQGPVS9SQGskmDYBN5rQFp9z4ZV8vF
         JQeTzr+3QBXN2UQZ6SJSxqngg230Z1JdAgdgkTFb31x12uyVX1b/Ma4wYtMCpCtp1o+U
         gwt0fGU229krkRBQZDp5y1z0zv27GSmWmeyFozJx4LIZ5cAi6406Xy+sRuDWlwSdgqMO
         aHEg==
X-Gm-Message-State: AOAM531nI+EufRPBSdnSUttd3ahnIIj51RjJea5zViHufPZDkxCfnURS
        y/fZbd61vDv2DmC4nFj3ia8=
X-Google-Smtp-Source: ABdhPJxlZ+1aFVq5YW6UEzC3HQLJbeJXnzNN90quf3pOC74eAip1OmzI0t0O+OqTO1/BdCxiiJM9pA==
X-Received: by 2002:a17:902:c409:b029:f0:d31d:4877 with SMTP id k9-20020a170902c409b02900f0d31d4877mr5064760plk.74.1621507481485;
        Thu, 20 May 2021 03:44:41 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id z12sm1762572pfk.45.2021.05.20.03.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 03:44:41 -0700 (PDT)
From:   Joe Richey <joerichey94@gmail.com>
To:     trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH 1/6] x86/elf: Don't use BIT() macro in UAPI headers
Date:   Thu, 20 May 2021 03:43:38 -0700
Message-Id: <20210520104343.317119-2-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

A previous patch [1] used the BIT() macro to define HWCAP2_FSGSBASE.

This macro is defined in the kernel but not in the UAPI headers.

[1] https://lore.kernel.org/patchwork/patch/912068/

Signed-off-by: Joe Richey <joerichey@google.com>
---
 arch/x86/include/uapi/asm/hwcap2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/hwcap2.h b/arch/x86/include/uapi/asm/hwcap2.h
index 5fdfcb47000f..6d2175b43710 100644
--- a/arch/x86/include/uapi/asm/hwcap2.h
+++ b/arch/x86/include/uapi/asm/hwcap2.h
@@ -6,6 +6,6 @@
 #define HWCAP2_RING3MWAIT		(1 << 0)
 
 /* Kernel allows FSGSBASE instructions available in Ring 3 */
-#define HWCAP2_FSGSBASE			BIT(1)
+#define HWCAP2_FSGSBASE			(1 << 1)
 
 #endif
-- 
2.31.1

