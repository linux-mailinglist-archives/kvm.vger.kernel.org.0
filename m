Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CE12EE8B2
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbhAGW32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728631AbhAGW31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:29:27 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE05C0612FA
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:36 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 3so6824861wmg.4
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D0ZV7Tyr2j4fG9lWfj8Aj9YT0gOWwwyKM8Utajfqaqw=;
        b=uL1azVrMrokowUnmYU/jXaVk+Ba4uvSXR1nKEuFGEOMYHVweWhLEPVOzvjfhinZhMx
         XS/XYqhbmlkJNGcyhrzTeVjtCdE7/On5B8TpkyPHPsqLipGsiNRl4GJ4uLTPXBX+IcTp
         DlfYYtsw3kFz5JSQSOeGUlQ+1XBVdgMSjWhgDA9P0Tr/jUlXbRJqBMuE9OT2i+D0xPvr
         BSFBLVE6NzguPiutbZJWNT7iNVekOdsrDrZ/Jlx3fDANLXV9gi5g628fmwrLounbePqi
         J5QK3FiCTobV5aIAA3UNr4+BtwCmQPW42xoZL+nVdv2uZ9FZ6AaMcPWAfVpj3rEkKjSn
         8+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=D0ZV7Tyr2j4fG9lWfj8Aj9YT0gOWwwyKM8Utajfqaqw=;
        b=WFjPBxBxVr3nzeNxAAIOYF7V3xSaJnhOQx5Cc/GHnIEJpGb52XVwCvgAAISm9IZU95
         H9cRwT4yPco6eRfiSF/k8qYeVp8RyhJzf5zBsEAzwpm2lENPTeBrL6wmBevLG6mng1aj
         i/+KMOrzHldLqWKbnX4YPGsGxLFspq30rsnLMSriRYte8I+M5dVLHBx+shE0zRxa0pDi
         MfqOk0jcP+2J0/rWyAZGaJQmgDN9Bl3iFD33VOgez93feIqeZWO6CjgLkl6DixVwxlcu
         Mn68V7F7PKJ1/sC7nO2GiqQhLXt4rxeLmDW1vMppnEpdQpg/ay1xn8rKvAS/VwUfBgmN
         FAvg==
X-Gm-Message-State: AOAM530BavBcXmNtwF1MeYtQfrFINdjkT6rnTS1QL88bSCC4D26oZGO5
        ZkLucqpLrHcp1XUpVv7xhLo=
X-Google-Smtp-Source: ABdhPJwTubkYm60fTqneKGYSwtRCJWkNzO9wICrkxUQL5Qd4H9Q/yF7YPiKn9A1Eda9+ks8qWYLV/A==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr491314wmi.179.1610058515651;
        Thu, 07 Jan 2021 14:28:35 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id s13sm10723025wra.53.2021.01.07.14.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:28:35 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Huth <huth@tuxfamily.org>
Subject: [PULL 66/66] docs/system: Remove deprecated 'fulong2e' machine alias
Date:   Thu,  7 Jan 2021 23:22:53 +0100
Message-Id: <20210107222253.20382-67-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'fulong2e' machine alias has been marked as deprecated since
QEMU v5.1 (commit c3a09ff68dd, the machine is renamed 'fuloong2e').
Time to remove it now.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Reviewed-by: Thomas Huth <huth@tuxfamily.org>
Message-Id: <20210106184602.3771551-1-f4bug@amsat.org>
---
 docs/system/deprecated.rst       | 5 -----
 docs/system/removed-features.rst | 5 +++++
 hw/mips/fuloong2e.c              | 1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/docs/system/deprecated.rst b/docs/system/deprecated.rst
index bacd76d7a58..e20bfcb17a4 100644
--- a/docs/system/deprecated.rst
+++ b/docs/system/deprecated.rst
@@ -309,11 +309,6 @@ The 'scsi-disk' device is deprecated. Users should use 'scsi-hd' or
 System emulator machines
 ------------------------
 
-mips ``fulong2e`` machine (since 5.1)
-'''''''''''''''''''''''''''''''''''''
-
-This machine has been renamed ``fuloong2e``.
-
 ``pc-1.0``, ``pc-1.1``, ``pc-1.2`` and ``pc-1.3`` (since 5.0)
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
diff --git a/docs/system/removed-features.rst b/docs/system/removed-features.rst
index 8b20d78a4d0..430fc33ca18 100644
--- a/docs/system/removed-features.rst
+++ b/docs/system/removed-features.rst
@@ -120,6 +120,11 @@ mips ``r4k`` platform (removed in 5.2)
 This machine type was very old and unmaintained. Users should use the ``malta``
 machine type instead.
 
+mips ``fulong2e`` machine alias (removed in 6.0)
+''''''''''''''''''''''''''''''''''''''''''''''''
+
+This machine has been renamed ``fuloong2e``.
+
 Related binaries
 ----------------
 
diff --git a/hw/mips/fuloong2e.c b/hw/mips/fuloong2e.c
index 29805242caa..bac2adbd5ae 100644
--- a/hw/mips/fuloong2e.c
+++ b/hw/mips/fuloong2e.c
@@ -383,7 +383,6 @@ static void mips_fuloong2e_init(MachineState *machine)
 static void mips_fuloong2e_machine_init(MachineClass *mc)
 {
     mc->desc = "Fuloong 2e mini pc";
-    mc->alias = "fulong2e";             /* Incorrect name used up to QEMU 4.2 */
     mc->init = mips_fuloong2e_init;
     mc->block_default_type = IF_IDE;
     mc->default_cpu_type = MIPS_CPU_TYPE_NAME("Loongson-2E");
-- 
2.26.2

