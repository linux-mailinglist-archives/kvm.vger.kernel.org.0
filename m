Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984ED16F8AF
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgBZHo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:44:56 -0500
Received: from mail-yw1-f73.google.com ([209.85.161.73]:49299 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBZHoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:44:55 -0500
Received: by mail-yw1-f73.google.com with SMTP id j63so2654918ywf.16
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MPs9SjjXPdQ3g+8JCLKgeYABN+oF1DJ3MQKhqKdCCeE=;
        b=NNMxzPyWcPdUrihQXaU4e+ps8WMo5ta29zZkt36qf+rJEnOP0Kw6dqoKJdJhk0aygv
         oTE19LlIqgZ2l0Vq8k6FLKiIKu/pdbAjtn9/x96jKL+vI3ucym0NKLv8QcsmVS1Q0AaW
         6kLXqu0HuzSotIx4atbnBPCDX2UwRZvPwmWNCS59YbCNbDT1z5xgYkj9yi1piVa2dZZe
         JX+xuSNPPf/LBvhwqHa+4aJQSk9ISMU2e5dGMW6tLudalwlVtwlHAuXYQIgd3YKrPQVx
         55Vr2Q6MNydyT3hbpHyXClNigMJoGkNXhRv+1P9W1yyxyKS4mOEblvxAKGzZQfuZUpOR
         OBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MPs9SjjXPdQ3g+8JCLKgeYABN+oF1DJ3MQKhqKdCCeE=;
        b=MuMBP6aYIWLOy9vEBQaJj/3EllDFPMGDISbLkAiSG8hp37TSWfUwIIWUL07AD40s7/
         +YRXikVMgSDGkwTUL9R4pMkZMvsoabF9rZ6z+Bd9JXbOaXopRpLHRKqDXE6OZ9+4gruR
         ndG9558af0Uiv4LsayOpueymmBsnrU5G32v8Jqin9JxooMYh7dUaQRnlsU+mBsiX/CsJ
         wkvWRTx0BjElLrUutw4VTrdoMCwAN+U9voX2GHvYE7yxK4Wba1VWdZJeR49QRsRstOtT
         GscD1ZPlDmHMXr8v1fNk5E9WTl2kFpuX7Q2JXdENOYo29rLpepmoYbaEzPqYiNdx8l6F
         OGRQ==
X-Gm-Message-State: APjAAAWj5FFbU2/k3/D/o0rmCM8j0MqKPMaet/iSZdOcMjqXQ602HAFx
        JlHxC3T/fXjnpeZNSLGBFx1/24e6EXiv2b+UqdTr6/x6Z19WDSMM6EvpBA6U2C5PFQa/xKQfybb
        togImUlnEMvfij6mZOJ7f1FVj9QMIStdsVqiBhRl7iF+2mJqwc0Vi5w==
X-Google-Smtp-Source: APXvYqxw8sbZEcncXybGIuNwvlSVTwa77cerJtDcBY66xCmQpF7kxrAaCfi2ceaI+b4Kiee8k96iOxaT3A==
X-Received: by 2002:a81:1bc6:: with SMTP id b189mr2351619ywb.275.1582703094538;
 Tue, 25 Feb 2020 23:44:54 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:22 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226074427.169684-3-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long values
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

The "pci_bar_*" functions use 64-bit masks, but the results are assigned
to 32-bit variables. Use 32-bit masks, since we're interested only in
the least significant 4-bits.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/linux/pci_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
index 1becea8..3bc2b92 100644
--- a/lib/linux/pci_regs.h
+++ b/lib/linux/pci_regs.h
@@ -96,8 +96,8 @@
 #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
 #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
 #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
-#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
-#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
+#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fU)
+#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03U)
 /* bit 1 is reserved if address_space = 1 */
 
 /* Header type 0 (normal devices) */
-- 
2.25.0.265.gbab2e86ba0-goog

