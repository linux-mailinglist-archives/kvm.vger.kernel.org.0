Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E8152F219
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 20:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352430AbiETSJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 14:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350982AbiETSJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 14:09:51 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701B918C056
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:09:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h9so187636pgl.4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+dtArUegwarjxubnsISRKRDYhZbE8jdwnCWW1KH0SJY=;
        b=n3fa+w9MhwWpwLlrne2euNd5ASkofCUrFad1Cy8yvFLKxr/kp+u3ZZnqAl5fzanji7
         E6YgrokEkUb5yvGQR20Tt11hXJHXThhpOnEHauJciRJqwakfLMpTjzVUn+NM3feL41R/
         BKwpNGzDAghYmUCQeQ+ddyCart2gX4x9B44jyDsKn8Y39mZyi5+zbMsl92nQ3f/ehFOc
         ES4hLhaymH9qdBWGDza6vDmLFC5zdr+ebGYAeLGh4BO2mJrEaVZx1FR3XH0Armb5G1ZJ
         SbxofMr4OjZeXSWT63DRVK14dAZbxQ9ZNFrQ+bI7DzKquCpR9EXOIkFya4kDUY0gSZfi
         VZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+dtArUegwarjxubnsISRKRDYhZbE8jdwnCWW1KH0SJY=;
        b=boaNSiwQFRgZoaw7PPHGqQnWIkIhJgz2OJ66UH6Malnv3uhvw2inoUTjZNGeNHxiYH
         XJNR3YWLm4vmctGbGzphoQ5Q6I0ZyWEs7xDMLE/oJhlCzW/hlDNFEHksOCVINFsJBEpC
         DnTrKXaOSdq56ibYcRJLA5571ZeYaPB54zpbVH/7+cN4jR6uVUEsXPnhAyiDlC/26tam
         sC36fF8r0JTunVPOL5eMLAdEinG+WX/lfF9pKkjzc0He/c9595UXf1oYUUKHlUnG8sIK
         l8Wn5g4T34/08vgv+l1JQJNbKhIj9fneLW9PpOfDHfjnlwALg6V8vDfJzjdqvVYU2AI6
         ZMqA==
X-Gm-Message-State: AOAM533umgbMgJyjNYMJZjGCzy33u0B5Cjc2z8xF102x2n58I+x5MX86
        ty8lGfTecllfBJces3sceoFCh4VxTuV+rw==
X-Google-Smtp-Source: ABdhPJxqn/FlVqIYoxRNQb4SQzFJsUBsSvcDpJaId7OL0RVFaXLy5Prc4CUmoyJwG5F3d/wQca0uvg==
X-Received: by 2002:a63:350c:0:b0:3c6:bf88:1509 with SMTP id c12-20020a63350c000000b003c6bf881509mr9475843pga.144.1653070189753;
        Fri, 20 May 2022 11:09:49 -0700 (PDT)
Received: from daolu.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id y68-20020a62ce47000000b005184af1d72fsm2284272pfg.15.2022.05.20.11.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 11:09:49 -0700 (PDT)
From:   Dao Lu <daolu@rivosinc.com>
To:     kvm@vger.kernel.org
Cc:     Dao Lu <daolu@rivosinc.com>
Subject: [PATCH kvmtool] Fixes: 0febaae00bb6 ("Add asm/kernel.h for riscv")
Date:   Fri, 20 May 2022 11:09:46 -0700
Message-Id: <20220520180946.104214-1-daolu@rivosinc.com>
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

Signed-off-by: Dao Lu <daolu@rivosinc.com>
---
 riscv/include/asm/kernel.h | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 riscv/include/asm/kernel.h

diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
new file mode 100644
index 0000000..a2a8d9e
--- /dev/null
+++ b/riscv/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	4096
+
+#endif /* __ASM_KERNEL_H */
-- 
2.36.0

