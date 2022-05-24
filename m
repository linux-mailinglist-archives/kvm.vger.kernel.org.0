Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EDB532FFB
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 20:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbiEXSAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 14:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240101AbiEXSAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 14:00:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEA862215
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 11:00:35 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b135so5354915pfb.12
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 11:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpFVq8r/umd/zveVH7C5Avfe0R2MqP8rdf1ZoFjkovs=;
        b=gBqn6zb2xhCTUNdRRFpcqFCryfyq2Jcg3h22HySfX5vcvCxmC2wv81Otof56M+w5SN
         MhEmiFBC2/QxfHq7yD4NUvrOur26lO2HYPYir7whJu/3D5fKTNwDt7GPYtnGlB02N76z
         HP37Sl68PGq+GYGM0SG3pCRF+W9/Qh1yrtZRO+EIveoIH5pPV8D2SKnl+LkWUanEqK3q
         tNzpKaWGrxD62g6d3IrUGYjdE/XUNI020eDu9daQS3a5+cGs1CrB6DR6zxdcK9Z+S8T2
         EmsMk8M2bLuf3RBGrSg6UdVISibJbfULc038LplcpnkKEo/oZrjS+A8exvXUsh/SzL4u
         u5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpFVq8r/umd/zveVH7C5Avfe0R2MqP8rdf1ZoFjkovs=;
        b=AakbEgpzEgHDAValn3eKwKdBiiI6eB6lajItKi9rYRt0k5yhg0nDjyUxerwtkmZe/F
         +4QviSsGWuwgNHvufcnl+dPi8ripmvl6sooitZ8z4crm6inLZPTQ/D1GiY14JFbXAmsP
         qSgxAmDqbm5oEpFLupms+8SmXwe7BJ6a967jX/3D2uF6JDnqCmW+6hMq+4ryAHyMv2Pe
         rhyL8nR9hcp9qDTglrT2BvE64nDF7Cog/LEVGVcdhsSnq/f7ruR1toDF+1qLqELiBI0H
         ttXRf10HDJjy2sjZi7BGbKu8Dnx6bDyek73yp1P4G3sqy/9vnXlcI2VokLP44GWOd6/p
         NWEg==
X-Gm-Message-State: AOAM5306my/mgIgFh3sUePdtsa1QUHRNw9VItH1JvhPsFGC7YruhTSqp
        ZanhOFCS7pJF8cdDpCl8BDNyepzyNtfRZA==
X-Google-Smtp-Source: ABdhPJymORb0KY/vaUicJgZyiKEBLF4E1EbcJid/Ik7KxRVqoJToK9vGibA+ynCKumJFJgymF5CghQ==
X-Received: by 2002:a65:6e9b:0:b0:3c5:f761:2d94 with SMTP id bm27-20020a656e9b000000b003c5f7612d94mr24733432pgb.79.1653415234819;
        Tue, 24 May 2022 11:00:34 -0700 (PDT)
Received: from daolu.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id gk10-20020a17090b118a00b001d7d8b33121sm24403pjb.5.2022.05.24.11.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 11:00:34 -0700 (PDT)
From:   Dao Lu <daolu@rivosinc.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, kvm-riscv@lists.infradead.org,
        apatel@ventanamicro.com, Dao Lu <daolu@rivosinc.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v2] Fixes: 0febaae00bb6 ("Add asm/kernel.h for riscv")
Date:   Tue, 24 May 2022 11:00:30 -0700
Message-Id: <20220524180030.1848992-1-daolu@rivosinc.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes the following compilation issue:

include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file
or directory
    5 | #include "asm/kernel.h"

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Dao Lu <daolu@rivosinc.com>
---
 riscv/include/asm/kernel.h | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 riscv/include/asm/kernel.h

diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
new file mode 100644
index 0000000..4ab195f
--- /dev/null
+++ b/riscv/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	512
+
+#endif /* __ASM_KERNEL_H */
-- 
2.36.0

