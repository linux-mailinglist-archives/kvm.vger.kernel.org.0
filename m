Return-Path: <kvm+bounces-1655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F01D7EB26B
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F1E51C20B02
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8604123C;
	Tue, 14 Nov 2023 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wFWKca9Y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F5641749
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:38:38 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F59173C
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:35 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5409bc907edso8776941a12.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972714; x=1700577514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7OOTLwbh53U5+FgsPEU5EGeXSv4SaNpAAr4X/+o3UA=;
        b=wFWKca9YzdgRIktqGSmPdVOBQhv5b+AQgcbXZ/5TH3q8teOReqy7UwznHNG8eZIxfv
         3aZs9sOiB31o9YQ9LXGD1Lhn8ZN5Ak0bs166xn1euYsm/DFNgOOLB4hEEjewcL1DDT4a
         Qn/rUiX86yWYRcJ6VpkKaL3gIVvFc9erfrorIlbKs3ndWcepHDFeGQLwoKDC9vo9AzEP
         WKvxE3MTx0cSmfyicl4D6GQurnMBbizNUHI2KTKB3YQByVHfAUVvLHfxQO1EhF57o+5U
         qAoolUHu8Plz7bccG+0fF4CKIde8SVC5XvSBB1MP+X4RF9Pt72JKm0TbL/CX7u47F2eX
         nQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972714; x=1700577514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7OOTLwbh53U5+FgsPEU5EGeXSv4SaNpAAr4X/+o3UA=;
        b=m+CyDQQDejQfMXpAuCj8g926UEbmbdXI4jdy5HP9k3dYDMEkYnF8SC9HOAZfgIZmio
         sgcnXLamvvXGyh9Qbi8l5PVDCc3vMqPXwzlaZSqfBOBj2bk93tqsa5WANMgGqJMPJhob
         wXUCstCyT30Y+SlIMrOfvB1BcW0D0S3Yfisue9r+NWypu2CUhmZCQHo9AhTVLCIs6sIC
         frPTUCwbgaOqrMrutvxiIq7I2gIgTtobNgCPNDGGxCkkVg0HgUfnS/1kkXldZCrZHK2F
         bXNs4e+5hO9aIF6O8YURE/CgsmElAzBL67wrOy0Ds1AyHCZVIP9e5c4RyMsNXnanYu6m
         EfVA==
X-Gm-Message-State: AOJu0YxUT42WkRVr5Upjp2DmtVSoGUyzG2WYtV85O62G62a5P2wFwt4t
	ZumdBAYVASZthkKiD/3SiryKfg==
X-Google-Smtp-Source: AGHT+IELhzs9bxNKpuVpMav1CIPsLfztJ8ibvFnuauNtaNuW/pX7cLT4uf7lQThdsPSioUMrMZEBQA==
X-Received: by 2002:a17:906:ca5b:b0:9be:30c2:b8ff with SMTP id jx27-20020a170906ca5b00b009be30c2b8ffmr7193715ejb.61.1699972713904;
        Tue, 14 Nov 2023 06:38:33 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id ha17-20020a170906a89100b009dd8473559dsm5543525ejb.110.2023.11.14.06.38.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:38:33 -0800 (PST)
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
Subject: [PATCH-for-9.0 v2 02/19] sysemu/xen: Forbid using Xen headers in user emulation
Date: Tue, 14 Nov 2023 15:37:58 +0100
Message-ID: <20231114143816.71079-3-philmd@linaro.org>
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

Xen is a system specific accelerator, it makes no sense
to include its headers in user emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/sysemu/xen.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/sysemu/xen.h b/include/sysemu/xen.h
index bc13ad5692..a9f591f26d 100644
--- a/include/sysemu/xen.h
+++ b/include/sysemu/xen.h
@@ -10,6 +10,10 @@
 #ifndef SYSEMU_XEN_H
 #define SYSEMU_XEN_H
 
+#ifdef CONFIG_USER_ONLY
+#error Cannot include sysemu/xen.h from user emulation
+#endif
+
 #include "exec/cpu-common.h"
 
 #ifdef NEED_CPU_H
@@ -26,16 +30,13 @@ extern bool xen_allowed;
 
 #define xen_enabled()           (xen_allowed)
 
-#ifndef CONFIG_USER_ONLY
 void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length);
 void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
                    struct MemoryRegion *mr, Error **errp);
-#endif
 
 #else /* !CONFIG_XEN_IS_POSSIBLE */
 
 #define xen_enabled() 0
-#ifndef CONFIG_USER_ONLY
 static inline void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length)
 {
     /* nothing */
@@ -45,7 +46,6 @@ static inline void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
 {
     g_assert_not_reached();
 }
-#endif
 
 #endif /* CONFIG_XEN_IS_POSSIBLE */
 
-- 
2.41.0


