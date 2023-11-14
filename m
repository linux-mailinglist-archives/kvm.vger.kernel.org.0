Return-Path: <kvm+bounces-1656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 521A77EB26D
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 023A41F25011
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0951341757;
	Tue, 14 Nov 2023 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Uv9VV2Zk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A274174F
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:38:43 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C43D4B
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:42 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-53e04b17132so8861668a12.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972720; x=1700577520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kBdIXHGvx5/0R2xC8Q+GilhuZtCQOtnJ9hpGFyppJEE=;
        b=Uv9VV2Zkny1SjVtm6tIagaw90v/mpvSDVxWQD4QVt/v68BTJA10UT7BzbJ/9xZUbBy
         cV2OKjT8a5R3Wxh5TdnbfhnuG5n93R4erY8lCPP9QzEtDFp4yyoGtg/X6klsjKwavBPJ
         H+kfkGZCbgp9hrgDzbsnA9s8vuiy78pgIu8TYTrYVCfoVT101WLIj5rlgxl+QVrQVwRK
         p5LOY8EPEndCsBpqR2WxtnE1rLCNrbRwRNSOuWeuPNuZZf5ZB85mkH3ccj4lhy5It3I2
         CTsV4sg/NsyQ5AIG+W2WHwhIl1Jfhv3/Ir72quH7aupwC0NcNwwZYh+Z8F2pQWxUP9tR
         BI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972720; x=1700577520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kBdIXHGvx5/0R2xC8Q+GilhuZtCQOtnJ9hpGFyppJEE=;
        b=Sf+o/bTC0Vj5l6MvoAMkO1Te4jFhNcwKAj6M8yE/Ba5wdeit7p1nsZ3I7OATtKgUjT
         A4Ytyv1bNWQjGP9sb5zFUvFe4mhuuVNBpUzwpLMw5Au9Rmu6ZY00a9lJx7qL70XsRDPL
         LlW528JKM0U5VutZI9w27NXpvmIufXrj/N3hG0CWEQqkGBgUUXSGCXz+6a6ZJx7lEY0n
         K5B+LtLqQNwWhpQByFosk+fpdyZKlK3Z+5hsDHgdpWBjOjssfOBfpqba1C27FzUGVbMP
         LmkQspjwF+RBbAg1i1E0c23qo1ZS77LcwTghKLrJQRbwPWLUmoeImEzlHvjGO2eA+wCo
         v9dA==
X-Gm-Message-State: AOJu0Yxy734po7xUPfMBND98bArhRunJ9I1W+ELcYHe4X21WhTzcE6Gz
	OW31K9qyGawWBo2Ia11Dr7ni3g==
X-Google-Smtp-Source: AGHT+IFii/vTCRNAFXoxhgp7tKdZ5NzaA4D0hMTO7kCC4hnZ5p3PauJ+Zda1OHH5OQndb4HCu48Kbw==
X-Received: by 2002:a17:906:6b97:b0:9d2:e2f6:45b2 with SMTP id l23-20020a1709066b9700b009d2e2f645b2mr7411114ejr.71.1699972720502;
        Tue, 14 Nov 2023 06:38:40 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906094200b009ad7fc17b2asm5613097ejd.224.2023.11.14.06.38.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:38:40 -0800 (PST)
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
Subject: [PATCH-for-9.0 v2 03/19] sysemu/xen-mapcache: Check Xen availability with CONFIG_XEN_IS_POSSIBLE
Date: Tue, 14 Nov 2023 15:37:59 +0100
Message-ID: <20231114143816.71079-4-philmd@linaro.org>
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

"sysemu/xen.h" defines CONFIG_XEN_IS_POSSIBLE as a target-agnostic
version of CONFIG_XEN accelerator.
Use it in order to use "sysemu/xen-mapcache.h" in target-agnostic files.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/sysemu/xen-mapcache.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/sysemu/xen-mapcache.h b/include/sysemu/xen-mapcache.h
index c8e7c2f6cf..10c2e3082a 100644
--- a/include/sysemu/xen-mapcache.h
+++ b/include/sysemu/xen-mapcache.h
@@ -10,10 +10,11 @@
 #define XEN_MAPCACHE_H
 
 #include "exec/cpu-common.h"
+#include "sysemu/xen.h"
 
 typedef hwaddr (*phys_offset_to_gaddr_t)(hwaddr phys_offset,
                                          ram_addr_t size);
-#ifdef CONFIG_XEN
+#ifdef CONFIG_XEN_IS_POSSIBLE
 
 void xen_map_cache_init(phys_offset_to_gaddr_t f,
                         void *opaque);
-- 
2.41.0


