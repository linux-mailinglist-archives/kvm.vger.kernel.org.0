Return-Path: <kvm+bounces-1667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F9B7EB290
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45D2BB20BD0
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8817A41755;
	Tue, 14 Nov 2023 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lWtMoWwY"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0754174E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:57 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDC310D
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:56 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9df8d0c2505so1150163666b.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972795; x=1700577595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1LXi3GoLl/gkTzQsgGS9qqbGm09JIagG9772ckn2qA=;
        b=lWtMoWwYSJXjwoJOFHq05ry/Y8EgDgwVTS4YeTppe+cZZ+1KOORfUr5Z9luc0iFgKc
         KEzOv2AxoYuKvnF6QDexCePDqE6Kyhm70RzHt+HGHlNqfr0ToORDqayLWJZhyz6BXVzr
         EWTaZFQgSlDMBeyZZvduqpSqHxZIETF9+khxkoE+X4CrTKoM+ecgm3xoGElNiBpqcCee
         hydEWfTjfH/chcoFnf1NBi6pLDcJIJl8P0jX82ldMy0nioqnVPx/YlDUe5kdc+k2bnM1
         Dn+vDjsHfRL0S9kAuyBAPvCcPtqyGOgXUK68h4+w8r5EOcEOKofkNTNnnBCzGxaQ+RwO
         gioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972795; x=1700577595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1LXi3GoLl/gkTzQsgGS9qqbGm09JIagG9772ckn2qA=;
        b=kSZq7NXo6nwGdbuCC4FT3OQXMZRdT+OdRcOd8bl83qpyvz0iFlLY5mnehc22D/sBb9
         RWKbIy5rp2OF/xo+muv5fI0n1Hjbj6xjEZxlJcECyMYQGKpJmlGxJNQJBacXtFVFeK5D
         fIjmDM5zR/w+mJ7FATCoTSXAl0NyM7yjacvs42mqHZHHiBRKteUqoVVPy2yOvXgxA5E/
         kT0bmkokFGLUVFAR9H10QWkIVUHEr+tUoU5LuVJvLyfZKvP4Zuc56ZQAKuyQk7nd2n8I
         vJ+pawy1zfroRKVFeYvHP6o/r+pnLPyS6PnPb7byeybYMBd78puLd2NyYFTl5TuQKc3O
         e4UQ==
X-Gm-Message-State: AOJu0Yz7O1UXhNjsUWSFNC968kfZ+t20BofJcUW+urtMdVWfIVdh8Bk1
	6Q5pi4cISUIv0m/LzTUnj4wptg==
X-Google-Smtp-Source: AGHT+IFO0v0Kbx5mK0/IVC1YCc6AdDt4TudkiuPrPaddeZvjZPoy7Sp5UUV1A0HKtR5wjcSegxv9ZQ==
X-Received: by 2002:a17:906:e51:b0:9ba:b5:cba6 with SMTP id q17-20020a1709060e5100b009ba00b5cba6mr2289558eji.14.1699972795126;
        Tue, 14 Nov 2023 06:39:55 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906080a00b009a193a5acffsm5624675ejd.121.2023.11.14.06.39.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:54 -0800 (PST)
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
Subject: [PATCH-for-9.0 v2 14/19] hw/xen: Use target-agnostic qemu_target_page_bits()
Date: Tue, 14 Nov 2023 15:38:10 +0100
Message-ID: <20231114143816.71079-15-philmd@linaro.org>
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

Instead of the target-specific TARGET_PAGE_BITS definition,
use qemu_target_page_bits() which is target agnostic.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/xen/xen-hvm-common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/xen/xen-hvm-common.c b/hw/xen/xen-hvm-common.c
index fb81bd8fbc..73fa2c414d 100644
--- a/hw/xen/xen-hvm-common.c
+++ b/hw/xen/xen-hvm-common.c
@@ -2,6 +2,7 @@
 #include "qemu/units.h"
 #include "qemu/bitops.h"
 #include "qapi/error.h"
+#include "exec/target_page.h"
 #include "trace.h"
 
 #include "hw/pci/pci_host.h"
@@ -14,6 +15,7 @@ MemoryRegion xen_memory;
 void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size, MemoryRegion *mr,
                    Error **errp)
 {
+    unsigned target_page_bits = qemu_target_page_bits();
     unsigned long nr_pfn;
     xen_pfn_t *pfn_list;
     int i;
@@ -32,11 +34,11 @@ void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size, MemoryRegion *mr,
 
     trace_xen_ram_alloc(ram_addr, size);
 
-    nr_pfn = size >> TARGET_PAGE_BITS;
+    nr_pfn = size >> target_page_bits;
     pfn_list = g_new(xen_pfn_t, nr_pfn);
 
     for (i = 0; i < nr_pfn; i++) {
-        pfn_list[i] = (ram_addr >> TARGET_PAGE_BITS) + i;
+        pfn_list[i] = (ram_addr >> target_page_bits) + i;
     }
 
     if (xc_domain_populate_physmap_exact(xen_xc, xen_domid, nr_pfn, 0, 0, pfn_list)) {
-- 
2.41.0


