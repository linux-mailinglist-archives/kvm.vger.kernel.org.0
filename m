Return-Path: <kvm+bounces-1659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2FC7EB279
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5D161C20925
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EBC94123A;
	Tue, 14 Nov 2023 14:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WR7pGy3/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59EE41746
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:03 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6F01FD9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:02 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-545ed16b137so8049511a12.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972740; x=1700577540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2i2PCnBLcbag3MdE1ImS65uDPosS8yIjq0X323T5yY=;
        b=WR7pGy3/lEwF9HSN3ataHNSjGbe67kB8HorCDX5kKmnNJKHtcPygLQ1H8e98v1fhqD
         P4CJSsDZD7p4MDJrkchbHYOtpWZifbcD8yvwHy1mYvNijXzjsUV8mq4zPMclIIKDYKa4
         nM3pFB2MqVF75+hStQQgABNJQiEYO1qLSsgzONgr/hzOdFDs6caP1c/5lRzj+RNcQxAJ
         hYgLKqVU4+hpXhzoUOm1T0L1zYz7b950600EtQxxGJSsjSjOCdlrw9Kt1kk7Nn679S4N
         n4Lmj+viB6u2OPP3GChiA4FqCTucZkV3qfkwT8F1X6APEQJ92/CLigCoZSuV+BZYVjws
         UkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972740; x=1700577540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A2i2PCnBLcbag3MdE1ImS65uDPosS8yIjq0X323T5yY=;
        b=P/CDCuUEZpMFLH7Lee3ayTL8vKnwr638mWrk1JFuk3WmZilnW1czxxorXF/2BnAzbb
         TLwj/Jwmtz26wtUg0dcIj9tdV4yu4riiz9Q5SIOBTXYqI9Nc8mesIVMQ+SRgivwQH7G2
         I4UHkOa2ITiOfgmVgeLbbaOoQk8LoshiXBa7iY4rkbwuVmLh3owKVuBdJPPk1Ud+9aTh
         kasRQ0x28+VJp3wV7HbYU95d1xZLT2WCshDDMC7UMx6+rUluxj45OvJtnbo2CjtQ5rjR
         sp4xmcN6mN3r1u/Q1TJJqWoGoJ/KNWKC55Tah6OCQqttSAN70pUF3lEpFyiaOkehGqPx
         hiOA==
X-Gm-Message-State: AOJu0YzCIohbresofaf9+5KAIaSU2uF/Wd+hn/rDdVA+lrXROMfybrED
	qmovfv3rjd9ebE8TViX1+eqHXA==
X-Google-Smtp-Source: AGHT+IHSJfSbRj04/mwMI7ongNHq1l4+SKd+JSAzh7MEswy3END/JCbC/d/lhlupvrq+nM36Jvq7cA==
X-Received: by 2002:a50:fb14:0:b0:53d:eca8:8775 with SMTP id d20-20020a50fb14000000b0053deca88775mr7423669edq.26.1699972740609;
        Tue, 14 Nov 2023 06:39:00 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id b21-20020aa7d495000000b0054353639161sm5133902edr.89.2023.11.14.06.38.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:00 -0800 (PST)
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
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH-for-9.0 v2 06/19] hw/pci/msi: Restrict xen_is_pirq_msi() call to Xen
Date: Tue, 14 Nov 2023 15:38:02 +0100
Message-ID: <20231114143816.71079-7-philmd@linaro.org>
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

Similarly to the restriction in hw/pci/msix.c (see commit
e1e4bf2252 "msix: fix msix_vector_masked"), restrict the
xen_is_pirq_msi() call in msi_is_masked() to Xen.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/pci/msi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/pci/msi.c b/hw/pci/msi.c
index 041b0bdbec..8104ac1d91 100644
--- a/hw/pci/msi.c
+++ b/hw/pci/msi.c
@@ -23,6 +23,7 @@
 #include "hw/xen/xen.h"
 #include "qemu/range.h"
 #include "qapi/error.h"
+#include "sysemu/xen.h"
 
 #include "hw/i386/kvm/xen_evtchn.h"
 
@@ -308,7 +309,7 @@ bool msi_is_masked(const PCIDevice *dev, unsigned int vector)
     }
 
     data = pci_get_word(dev->config + msi_data_off(dev, msi64bit));
-    if (xen_is_pirq_msi(data)) {
+    if (xen_enabled() && xen_is_pirq_msi(data)) {
         return false;
     }
 
-- 
2.41.0


