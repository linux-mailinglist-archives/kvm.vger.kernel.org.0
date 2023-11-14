Return-Path: <kvm+bounces-1661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CBE27EB27F
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E00C61F2503A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE56A41232;
	Tue, 14 Nov 2023 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GsDWmE5M"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D7D41235
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:16 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23A8D6E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:15 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9becde9ea7bso1375256066b.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972754; x=1700577554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhpN1sNxh5OOZ/KSUE3Y0jUPmEpPW/hS+3a5vlda+P4=;
        b=GsDWmE5Mag4wtJBIR1S2l9OJevfGpRVhzKLwM/rkQWHQ1jjeA2nhyi50HAG905BxLo
         zBCL/1PV4I0U38K2czP95ECg2Hzf92OZ/67kamKKxHkKkKbMVqDhbWNZsm8zypiJsU6d
         gIQlKHsXLrjVsvb7Gy6JMCxFoLnYI2+Sn+AiG2UJd6nA84xv5rgyXqUkNu789hM4xGll
         yji0BDevkdX0dK9hHm2QORAbnZlkp9QOuO8dlwRr6F53KspfN56OdZBLO83PsD5j38lV
         z6LFY6tw3EX8Lda7NhND0v6GyT43ScwYNLU0Dpxpn9qPX5aNP5NXkEX3/OuSZ0js7/bp
         anug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972754; x=1700577554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhpN1sNxh5OOZ/KSUE3Y0jUPmEpPW/hS+3a5vlda+P4=;
        b=OerZZ8sZ/leuPCZ5zUZGqVAjLECTBJaK/Yxkpe0QTCUp6nB4B584sDaQvbNFZ7oyYZ
         zn1Ks1XyGi3orpp79gc4LsIZFtEnsAo3k077JPthynJ/zF1OVO7WYzOsXMSPhhZ1dtlO
         MEZ+BRyQk4XhNBcys3AEex82XcDbDCdy08eI7r/zPp127wpNYM4sj9FrQ+gL/O3GD7Ci
         lJkbPs5PT28B0ELwI5gUA9lULLcUc34QlbsFoxiBQ5Hs+XvcPCsA7EV7Fe+Lr30N8Jlt
         0SDfyS/FMrXJs/VfIGX54nIg5UohGc65m8ClKd7z7bu7zIWBLd/ZYwUH+7kihgLNYaQL
         ewAg==
X-Gm-Message-State: AOJu0YyTgzXe5DGUxA4NwOdXbo01bibK9q05NRrvoSgKiSV4fTy09PDb
	9/jPhkPZpaYkNsM2qUgnpz+hng==
X-Google-Smtp-Source: AGHT+IEBPsAFKv3TcvW/4lHrf4Ji7dOfSz7fvZ7L1HUiABJvwud/gdEB/1UIkKrwYaMtMuFVPwAlYw==
X-Received: by 2002:a17:906:bf45:b0:9e5:1db7:3199 with SMTP id ps5-20020a170906bf4500b009e51db73199mr3052455ejb.4.1699972753957;
        Tue, 14 Nov 2023 06:39:13 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id g4-20020a1709064e4400b009e609088c09sm5584953ejw.1.2023.11.14.06.39.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:13 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 v2 08/19] hw/xen: Remove unused Xen stubs
Date: Tue, 14 Nov 2023 15:38:04 +0100
Message-ID: <20231114143816.71079-9-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

All these stubs are protected by a 'if (xen_enabled())' check.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 stubs/xen-hw-stub.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/stubs/xen-hw-stub.c b/stubs/xen-hw-stub.c
index 6cf0e9a4c1..53c6a6f2a0 100644
--- a/stubs/xen-hw-stub.c
+++ b/stubs/xen-hw-stub.c
@@ -8,36 +8,12 @@
 
 #include "qemu/osdep.h"
 #include "hw/xen/xen.h"
-#include "hw/xen/xen-x86.h"
-
-int xen_pci_slot_get_pirq(PCIDevice *pci_dev, int irq_num)
-{
-    return -1;
-}
-
-void xen_intx_set_irq(void *opaque, int irq_num, int level)
-{
-}
-
-int xen_set_pci_link_route(uint8_t link, uint8_t irq)
-{
-    return -1;
-}
 
 int xen_is_pirq_msi(uint32_t msi_data)
 {
     return 0;
 }
 
-qemu_irq *xen_interrupt_controller_init(void)
-{
-    return NULL;
-}
-
 void xen_register_framebuffer(MemoryRegion *mr)
 {
 }
-
-void xen_hvm_init_pc(PCMachineState *pcms, MemoryRegion **ram_memory)
-{
-}
-- 
2.41.0


