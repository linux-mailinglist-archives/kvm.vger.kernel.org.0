Return-Path: <kvm+bounces-1668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CABE67EB294
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE14B1C20A80
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5971641754;
	Tue, 14 Nov 2023 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KnhyAbya"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B4A4174F
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:40:05 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81323D50
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:03 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-53d8320f0easo8830043a12.3
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972802; x=1700577602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfmEPJkfg9xcA7W0yB07+uhlzLrR51RZZmvLOIuALj0=;
        b=KnhyAbyagKPjTnwE6rGubFAZz4qz4fyt8LDRu1PknKppD26ApLIW/KsWajMWT9YEOE
         wuaO72FVSzQvWkHga/jIDT4B7EdNzdxj3iI1HC4sMgg8beAewtavRGAixAjl79V6PClf
         /XzTo8o0ULEM/tHHKS5kQba5wSlW8YX8knbX4i2VUO44Vote8LAxgy/TbFuk4PgN0v47
         KIX2QGCciWe8tsekGCsvq8wOQkk127kv8qyCFeHlUlTblthr2WAQpLXNWtX0mXwZ8c2t
         hdixWAsPeaAfHNiQ0KTd4ykwwdvIJAHvQ3xKPaLiHjHqxBxDKrISblINgFIkFlp9W/Ra
         i+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972802; x=1700577602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfmEPJkfg9xcA7W0yB07+uhlzLrR51RZZmvLOIuALj0=;
        b=coydYU4lTDAEzGqfX90fYx8qpKHdO6aaZro8n0t0rpRei+4E6TRDlagW3SRg3pB1G7
         U/U1rFKEwXLciiLCOk08ZgCkvphhnx30aVOKM/EOZjLS6C9PcOEvAngjMTfuxFt1Xg3f
         EwgRwzb/hut+G8sNtatu20Raht63yX3igJJYIr52OdhTw7E8chh5YtFfRnop6M1HfLTa
         qHQiutpQtuhW5v4Hz3NKFZndqF59VdA/oxA8V2ss87Lg1jv/gAGp0QtC+kOdXSex6I0T
         K7r2fkzV3DYWcpgpRXbtHpUkCMKJWCCeMVKp1tBA665iR8wPg0ULsDCTzA51n57hXOIp
         gMkA==
X-Gm-Message-State: AOJu0Ywfbe/mV7IyTcdFo2JnURvPv67OTfUZFgztVWEVXhMAK8hXoDWj
	IaD6tWTLDNON99a8XIRkDm1vhw==
X-Google-Smtp-Source: AGHT+IFr1fCG0rC/823Fjj2RnGPLFEJJu5Vypm0crh2s8xGJ38WYt9mRvWNiRlcZ2yw4Up2Qw1V1LQ==
X-Received: by 2002:aa7:d704:0:b0:53d:e0cf:cb95 with SMTP id t4-20020aa7d704000000b0053de0cfcb95mr7775616edq.21.1699972802002;
        Tue, 14 Nov 2023 06:40:02 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id r30-20020a50aade000000b005434e3d8e7bsm5309632edc.1.2023.11.14.06.39.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:40:01 -0800 (PST)
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
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH-for-9.0 v2 15/19] hw/xen: Reduce inclusion of 'cpu.h' to target-specific sources
Date: Tue, 14 Nov 2023 15:38:11 +0100
Message-ID: <20231114143816.71079-16-philmd@linaro.org>
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

We rarely need to include "cpu.h" in headers. Including it
'taint' headers to be target-specific. Here only the i386/arm
implementations requires "cpu.h", so include it there and
remove from the "hw/xen/xen-hvm-common.h" *common* header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/hw/xen/xen-hvm-common.h | 1 -
 hw/arm/xen_arm.c                | 1 +
 hw/i386/xen/xen-hvm.c           | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/hw/xen/xen-hvm-common.h b/include/hw/xen/xen-hvm-common.h
index 8934033eaa..83ed16f425 100644
--- a/include/hw/xen/xen-hvm-common.h
+++ b/include/hw/xen/xen-hvm-common.h
@@ -4,7 +4,6 @@
 #include "qemu/osdep.h"
 #include "qemu/units.h"
 
-#include "cpu.h"
 #include "hw/pci/pci.h"
 #include "hw/hw.h"
 #include "hw/xen/xen_native.h"
diff --git a/hw/arm/xen_arm.c b/hw/arm/xen_arm.c
index 6b0e396502..b478d74ea0 100644
--- a/hw/arm/xen_arm.c
+++ b/hw/arm/xen_arm.c
@@ -33,6 +33,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/xen/xen-hvm-common.h"
 #include "sysemu/tpm.h"
+#include "cpu.h"
 
 #define TYPE_XEN_ARM  MACHINE_TYPE_NAME("xenpvh")
 OBJECT_DECLARE_SIMPLE_TYPE(XenArmState, XEN_ARM)
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index 0fbe720c8f..f1c30d1384 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -22,6 +22,7 @@
 
 #include "hw/xen/xen-hvm-common.h"
 #include <xen/hvm/e820.h>
+#include "cpu.h"
 
 static MemoryRegion ram_640k, ram_lo, ram_hi;
 static MemoryRegion *framebuffer;
-- 
2.41.0


