Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCF62AB3E7
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgKIJqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgKIJqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 04:46:05 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C73C0613CF
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 01:46:05 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h2so7343124wmm.0
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 01:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=skEK8mcEbaIFgeS0C2weI3p2dBXQu/ugQCxgA8/QJFY=;
        b=F06rSHBKrzqDcu8FaVWSwws98lz5ArIBJmV6GpbautZMtgl2r+YYdcFYVWealFs9t/
         TN5556bSf+/nyhzs1b3SBy/EWxHicKqZ77PPvLiHWH0LYMJsQTkFOCkdv3Gujh0dRK/z
         AxFEih+MVOq3F3oabqYB24UXKuUiDcZXd0swk1NYUYN7XB2He6dS9pJMeP/hJm+Tusds
         qIdbGRbFmSd2VGwpJ4N6MxCWNktY+ksnTGEsxY/EY+TaH6l2Q8bRgOUdy3ckSzbeLO1e
         I5KvkOpoJz7eBHHtPP/6EtSuKEsydtV4zevKzuf8S/v5aLa2bDTolpeFNcJVwqKm/moh
         aLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=skEK8mcEbaIFgeS0C2weI3p2dBXQu/ugQCxgA8/QJFY=;
        b=J+0b7dyZsw0/38THJ0XSsibhG7xdIjWa9g6VpYYu2q+r/AvyQ9VVpCASKqlbFAmSjS
         cog610XLQ2Gvca4yTrb7iHVv4c8Kb0MJp2A7rVrOkOTBmQ/RJW6RVxhj+sH5W7a/n4MI
         QJhA2ChttkpdwPEWr9FDzPZa5EPm9L4ZrWg8WbsMPRUwSm04/tR6LtCA+dHy34ZITUnX
         6q8JHs5Ekg7Xv41cUS8z1diIEQiljAJT+j8hdWC+mC1Rmp1i0TP+oBX37t0rE11AUizP
         PMzJsUT/xY95nvefYWZ3ghi/hFi7G4IQdnD+piiK6+UzjC0ZJdMZ0qRycf8m3u6vN6zq
         1ZIA==
X-Gm-Message-State: AOAM53379EpI0t8XfXWlaOTL/SmjaIeYM93CfxegnRMXcQqtAz38J4Vm
        Vx8z4O8syNgvYvOkfZ8bXr8=
X-Google-Smtp-Source: ABdhPJxDdTB7I9WJICHIIjy4yAPQvmdbvjdorOinX1TetlCZiYP42zLjOjlMNmvL8ohxokfQ4DLVcQ==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr10264042wmj.76.1604915164072;
        Mon, 09 Nov 2020 01:46:04 -0800 (PST)
Received: from localhost.localdomain (234.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.234])
        by smtp.gmail.com with ESMTPSA id u6sm12219003wmj.40.2020.11.09.01.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 01:46:03 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 3/3] accel/stubs: Simplify kvm-stub.c
Date:   Mon,  9 Nov 2020 10:45:47 +0100
Message-Id: <20201109094547.2456385-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201109094547.2456385-1-f4bug@amsat.org>
References: <20201109094547.2456385-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now than kvm-stub.c is only built on system-mode emulation,
we can simplify its #ifdef'ry.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 accel/stubs/kvm-stub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 680e0994637..68fdfce50ed 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -13,10 +13,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "sysemu/kvm.h"
-
-#ifndef CONFIG_USER_ONLY
 #include "hw/pci/msi.h"
-#endif
 
 KVMState *kvm_state;
 bool kvm_kernel_irqchip;
@@ -91,7 +88,6 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
   return 1;
 }
 
-#ifndef CONFIG_USER_ONLY
 int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
 {
     return -ENOSYS;
@@ -158,4 +154,3 @@ bool kvm_arm_supports_user_irq(void)
 {
     return false;
 }
-#endif
-- 
2.26.2

