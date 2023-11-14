Return-Path: <kvm+bounces-1657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E09EC7EB271
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99D06281274
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9451141757;
	Tue, 14 Nov 2023 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oR+q2E2h"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB95441748
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:38:49 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA72D198B
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:48 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-54366784377so8748477a12.3
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972727; x=1700577527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UVR+oDiuZU+TW6PLxAmD0Xj/DK6BF5fQU92EHH5K3Z4=;
        b=oR+q2E2h+BVzvH9q0zzS5CpWKgcvy7Y1YBzVAeaTK/vkAeR6F+Y/QIiLwkuXi1C0fp
         59HTK7+5h0cbgNzWy+6OXycxsZk9qfvsxUZvgOLqhfjrd8HzQHds2Q+siIhnDV+tGdFI
         6Cv3Ij5sgGMwZZdEbl92+dvlc3zVOOAXq80PEiTwA5F7FRidmZj1WxEq1ZI3saO8XUE2
         ydlgD9a9MUSCQhk4GRcLFhH76gtvqwguI1R1w3vIayxGvsnxX8xJpRAcoQ8beXMN6xLV
         c7iejFmvg1WVvL+3GMvdNQghQn8yCF4rHIGGoHYliL8p6wQR+2VAiPNyAGDdd15veSNv
         SVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972727; x=1700577527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UVR+oDiuZU+TW6PLxAmD0Xj/DK6BF5fQU92EHH5K3Z4=;
        b=uJKBvbsHNkkltKRHElzkQpZJk0mwUGew5U5NrRUp8zZS9gP1NIb/ZeGBP1pTrh02ae
         PhiBw5AYZ1RrCU4Isxzgd/FK/2KBGuumL5IaJj7LjyFCnSlulINNjflNNFLUekB1XOmy
         7S2v5sGI9o8wwFHQgMXi1nRkV4802bqUde+6WCrvfJ4E4LcPEEiXyvrdVFnhVrBMXU8m
         Uma4QqXWob9YqPajPS5+5hZVr0py6l+AlVuVtQoXQ1iwqvLhsFENvOClyAGtnorm1MCL
         l7NVeG52lpLDsyuE5PHS04qEv8G0G3Tbeag7ko+NKNVJkcnAH7H4XPJVit4jGLzXZzfI
         N5zw==
X-Gm-Message-State: AOJu0YynZFBw9gy9R+MRV2tyYM3x9nv1J/3Nuqbq5hdlFPSh6yzRw4rv
	wCFQbH0OM1kcAlZ5aOA5y07mlw==
X-Google-Smtp-Source: AGHT+IFU6fMqnyRTdYcaSZcZeeOvXEQ5/pqyJPjwVu+SyaMG1cEZXv2HxBOf7hgBnVZ045SVB8RX8Q==
X-Received: by 2002:aa7:c759:0:b0:543:5a91:a8b2 with SMTP id c25-20020aa7c759000000b005435a91a8b2mr7512514eds.19.1699972727421;
        Tue, 14 Nov 2023 06:38:47 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id m13-20020a50930d000000b0053e3d8f1d9fsm5267242eda.67.2023.11.14.06.38.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:38:47 -0800 (PST)
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
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH-for-9.0 v2 04/19] system/physmem: Do not include 'hw/xen/xen.h' but 'sysemu/xen.h'
Date: Tue, 14 Nov 2023 15:38:00 +0100
Message-ID: <20231114143816.71079-5-philmd@linaro.org>
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

physmem.c doesn't use any declaration from "hw/xen/xen.h",
it only requires "sysemu/xen.h" and "system/xen-mapcache.h".

Suggested-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 system/physmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/physmem.c b/system/physmem.c
index fc2b0fee01..04630711d2 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -35,7 +35,7 @@
 #include "hw/qdev-core.h"
 #include "hw/qdev-properties.h"
 #include "hw/boards.h"
-#include "hw/xen/xen.h"
+#include "sysemu/xen.h"
 #include "sysemu/kvm.h"
 #include "sysemu/tcg.h"
 #include "sysemu/qtest.h"
-- 
2.41.0


