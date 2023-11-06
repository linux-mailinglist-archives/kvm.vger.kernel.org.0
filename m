Return-Path: <kvm+bounces-669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8927F7E1F35
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44D0B28102A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5941B271;
	Mon,  6 Nov 2023 11:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A3eVwSza"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA011A5A3
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:03:49 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F36D8
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:03:48 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-407da05f05aso30502905e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268627; x=1699873427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1L9VmGyQhU2xkGMEVSpI4IfVFp3akp+nAwSDeWPJyrs=;
        b=A3eVwSzaSYki1dGnz2ik6DHSo85yBr67k49znaAOTpN9kUL1wSaxUhRhMrjGuiTx+z
         0bN7E2lanESedXbvj1djYwmvq4dynv7pIG7LSYfwW0GOkpVeVc82l3yNvHAzTDz/0eI2
         hFhgwon72PHbTP7SLX8sqE9vAo8tZVsYHVw1SKpNkHX5aHMJ5qH/gOLSvnU5NgdVa5f2
         3Ae2nBC5lfKmhb81cm2vbyOVHk8t59OoLkvP4i2CWJXUoj1dzL/YlgWundR6cgOaaSNy
         G5oSSCRxAN8apqRwoN/8isIMH6v5IZViFuEg3+Ynth1YplDeKp+yGfTs6Ukm8g1au/H2
         Fypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268627; x=1699873427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1L9VmGyQhU2xkGMEVSpI4IfVFp3akp+nAwSDeWPJyrs=;
        b=VflNn19oZJXRdj8y8rcYwUgikiZ2vSdCJOGoQuXzaCMPUubsmgWggtPdNBYeV2NS7r
         IjZAh/MVnoJxSBxGHKJsAiqcwkrgBGUOtyEShek5qS65q+bRTjwwRQdOMBPqXs6fzE16
         AQCkYbZ0sqRhY7WhJy/E2j7l4D+qQQRk6s5CpkuUBWyPHTAtecGk1+WfQbaWoMELyad0
         5Pn+szm1z2CGQSKMDpkv7+Ri/hjli5qknPJ6ztf1FqOggBvlx3ErhKd35PlD/T80Fzjf
         nxPNtoQnDDcWqA5aJzdJps/4yzgSxkJlY9Tu+wQk5TbtDo2z5v3lGQEZpI3lPXQ+j7ad
         TEvA==
X-Gm-Message-State: AOJu0YxZBhpv7ZzuCiw7rHITVMlMM84kUb3Xgs4tB8TGfhl3oytRcVBI
	cfREB9lnhZ2tO8lnQFYe501c00st7cFVcf/12MI=
X-Google-Smtp-Source: AGHT+IGVsR41OZiJW09UO8f2QQjHedYyrhNpAeIFY/pbatQ8PPEnpOP8OnIgt0CWNcPde4ZS+yy1Rw==
X-Received: by 2002:a05:600c:19ca:b0:406:8c7a:9520 with SMTP id u10-20020a05600c19ca00b004068c7a9520mr22789124wmq.36.1699268625910;
        Mon, 06 Nov 2023 03:03:45 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id q8-20020a05600c46c800b0040776008abdsm11817395wmo.40.2023.11.06.03.03.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:03:45 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PULL 01/60] vl: Free machine list
Date: Mon,  6 Nov 2023 12:02:33 +0100
Message-ID: <20231106110336.358-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

Free machine list and make LeakSanitizer happy.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-ID: <20230722062641.18505-1-akihiko.odaki@daynix.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 system/vl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/system/vl.c b/system/vl.c
index 3fb569254a..ff76eb0d07 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -1529,7 +1529,8 @@ static gint machine_class_cmp(gconstpointer a, gconstpointer b)
 
 static void machine_help_func(const QDict *qdict)
 {
-    GSList *machines, *el;
+    g_autoptr(GSList) machines = NULL;
+    GSList *el;
     const char *type = qdict_get_try_str(qdict, "type");
 
     machines = object_class_get_list(TYPE_MACHINE, false);
-- 
2.41.0


