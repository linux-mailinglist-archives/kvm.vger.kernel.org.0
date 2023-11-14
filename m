Return-Path: <kvm+bounces-1664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C30FA7EB288
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19EDC2812CE
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F55A41759;
	Tue, 14 Nov 2023 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xHU+YqVU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BFC41750
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:37 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA38185
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:36 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9d0b4dfd60dso855575766b.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972774; x=1700577574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6XE67RaqwP19rEjPR9cmWaIkbDnma1jGWKj3qDcuG2M=;
        b=xHU+YqVU95cmfV0IASuDjHDx6kTp201HyOYJsSF0au9qdZpRfolyHYwaZvplv9b4J7
         cX+4gZUv1zzWH0Cz+hyWQEBy6IarMLIcpKz5BdaAUm6ORR88MDMynQRWwkDdQYOlCwqA
         pt60KaLDMM4KZ5bOWJDGzRFPT8umZRyvJ9O46xJ24hH3Lp8wBvVqAlwT9OOLteNp0oGW
         WkUBfC/PMzdHf1pZJgbjsRfF5vdfXCQkZVDK10Ly6gl3isrXfUNkQ8WYS4M8MuRGJHvP
         tCOE9ZF184ayuB7b+gv/YfRRo8mFnCrygGxhMNqh5OpWrO/IQ/b4xAsO/M12XEN5qhAx
         5mRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972774; x=1700577574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XE67RaqwP19rEjPR9cmWaIkbDnma1jGWKj3qDcuG2M=;
        b=LL6QgYLsPYnEBScT9qGjEB9DWYUvOuhC5pLCxn/aJz1Q5eMkl1/peHMkbALEKMHZEy
         qSpvL4hNYS0M2W7UHP8Z0BPlsBqEKajWWaZvSbSAIExXZYDNGOGbqTmRM+RtapKUjmMM
         mGIkuG5alCRIH66uhXBxtW2H6D0bBki6xG4i3eUqI/8+jkD19wGtcnL26X1EXFEq/AN1
         bk7X+szVg60WpWMrIr5vxFK/+BwSELbRMwjwcANAOU/9YLyyAH9GMqMr5PhdO7qEmW+y
         MtGeQZoJflRmHg1c4D3Do5DNdBgdwJNhrsdoaQXLSPhpJ2IkKc16odLfr99+UrGY6DWT
         pwVQ==
X-Gm-Message-State: AOJu0Yx3nFQAHJ8CyP/gqdL0xWAIEFV6qtEWuKjbi5K5PlebDGddhDIj
	vksN4Z1XCo2bYEPoH+55uZT4sQ==
X-Google-Smtp-Source: AGHT+IH5uADtxqVb0gu9wkOPtm794L9VQ3NjNtPGCuhDFtQMH4f3XXf2p8ohPfBbgEKWHzCsn1iRrg==
X-Received: by 2002:a17:906:899:b0:9df:e457:cef6 with SMTP id n25-20020a170906089900b009dfe457cef6mr5737290eje.77.1699972774671;
        Tue, 14 Nov 2023 06:39:34 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id qx25-20020a170906fcd900b0098e34446464sm5684531ejb.25.2023.11.14.06.39.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:34 -0800 (PST)
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
	Peter Maydell <peter.maydell@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH-for-9.0 v2 11/19] hw/xen/xen_arch_hvm: Rename prototypes using 'xen_arch_' prefix
Date: Tue, 14 Nov 2023 15:38:07 +0100
Message-ID: <20231114143816.71079-12-philmd@linaro.org>
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

Use a common 'xen_arch_' prefix for architecture-specific functions.
Rename xen_arch_set_memory() and xen_arch_handle_ioreq().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/hw/arm/xen_arch_hvm.h  | 4 ++--
 include/hw/i386/xen_arch_hvm.h | 4 ++--
 hw/arm/xen_arm.c               | 4 ++--
 hw/i386/xen/xen-hvm.c          | 6 +++---
 hw/xen/xen-hvm-common.c        | 4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/hw/arm/xen_arch_hvm.h b/include/hw/arm/xen_arch_hvm.h
index 8fd645e723..6a974f2020 100644
--- a/include/hw/arm/xen_arch_hvm.h
+++ b/include/hw/arm/xen_arch_hvm.h
@@ -2,8 +2,8 @@
 #define HW_XEN_ARCH_ARM_HVM_H
 
 #include <xen/hvm/ioreq.h>
-void arch_handle_ioreq(XenIOState *state, ioreq_t *req);
-void arch_xen_set_memory(XenIOState *state,
+void xen_arch_handle_ioreq(XenIOState *state, ioreq_t *req);
+void xen_arch_set_memory(XenIOState *state,
                          MemoryRegionSection *section,
                          bool add);
 #endif
diff --git a/include/hw/i386/xen_arch_hvm.h b/include/hw/i386/xen_arch_hvm.h
index 1000f8f543..2822304955 100644
--- a/include/hw/i386/xen_arch_hvm.h
+++ b/include/hw/i386/xen_arch_hvm.h
@@ -4,8 +4,8 @@
 #include <xen/hvm/ioreq.h>
 #include "hw/xen/xen-hvm-common.h"
 
-void arch_handle_ioreq(XenIOState *state, ioreq_t *req);
-void arch_xen_set_memory(XenIOState *state,
+void xen_arch_handle_ioreq(XenIOState *state, ioreq_t *req);
+void xen_arch_set_memory(XenIOState *state,
                          MemoryRegionSection *section,
                          bool add);
 #endif
diff --git a/hw/arm/xen_arm.c b/hw/arm/xen_arm.c
index 8a185da193..bf19407879 100644
--- a/hw/arm/xen_arm.c
+++ b/hw/arm/xen_arm.c
@@ -129,14 +129,14 @@ static void xen_init_ram(MachineState *machine)
     }
 }
 
-void arch_handle_ioreq(XenIOState *state, ioreq_t *req)
+void xen_arch_handle_ioreq(XenIOState *state, ioreq_t *req)
 {
     hw_error("Invalid ioreq type 0x%x\n", req->type);
 
     return;
 }
 
-void arch_xen_set_memory(XenIOState *state, MemoryRegionSection *section,
+void xen_arch_set_memory(XenIOState *state, MemoryRegionSection *section,
                          bool add)
 {
 }
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index 1ae943370b..5150984e46 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -659,8 +659,8 @@ void qmp_xen_set_global_dirty_log(bool enable, Error **errp)
     }
 }
 
-void arch_xen_set_memory(XenIOState *state, MemoryRegionSection *section,
-                                bool add)
+void xen_arch_set_memory(XenIOState *state, MemoryRegionSection *section,
+                         bool add)
 {
     hwaddr start_addr = section->offset_within_address_space;
     ram_addr_t size = int128_get64(section->size);
@@ -700,7 +700,7 @@ void arch_xen_set_memory(XenIOState *state, MemoryRegionSection *section,
     }
 }
 
-void arch_handle_ioreq(XenIOState *state, ioreq_t *req)
+void xen_arch_handle_ioreq(XenIOState *state, ioreq_t *req)
 {
     switch (req->type) {
     case IOREQ_TYPE_VMWARE_PORT:
diff --git a/hw/xen/xen-hvm-common.c b/hw/xen/xen-hvm-common.c
index cf4053c9f2..cf6ed11f70 100644
--- a/hw/xen/xen-hvm-common.c
+++ b/hw/xen/xen-hvm-common.c
@@ -65,7 +65,7 @@ static void xen_set_memory(struct MemoryListener *listener,
         }
     }
 
-    arch_xen_set_memory(state, section, add);
+    xen_arch_set_memory(state, section, add);
 }
 
 void xen_region_add(MemoryListener *listener,
@@ -452,7 +452,7 @@ static void handle_ioreq(XenIOState *state, ioreq_t *req)
             cpu_ioreq_config(state, req);
             break;
         default:
-            arch_handle_ioreq(state, req);
+            xen_arch_handle_ioreq(state, req);
     }
     if (req->dir == IOREQ_READ) {
         trace_handle_ioreq_read(req, req->type, req->df, req->data_is_ptr,
-- 
2.41.0


