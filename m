Return-Path: <kvm+bounces-730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE19A7E1FAB
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86EF2281621
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5101EB2F;
	Mon,  6 Nov 2023 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n8l9ZI/O"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810621A708
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:10:29 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BFA10DD
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:10:26 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-509109104e2so5579183e87.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699269025; x=1699873825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBR3Oh8zClbS1YQ62m6eKxWZ4Ons8qsU0E4Liv4Rvg0=;
        b=n8l9ZI/O3VCPjKKwhlguMHar3XNfCp7tyCNywAL0BlErgA6BQ44f+TrfMzJpGvrmay
         GhSMjsLWYt2kRYr/gx9yPXI3XsANxJlpn0mynrB4nd3xTRMEb51jYZxLN4elHi8YPYAl
         dMsMC7qS+HFUkbyxjpIKMcLbNX61pndH1OcawcZBzxOXwPHzveEsjknwlp6jllT/2a3Q
         MbsMnN+X4P8y5XyUc67pcDhpMzzyIhk8FMr9eMvwuygcngZM53aKryBF5+1xRxQcphag
         CQSL8lrrKspVptWaDoU3Qe6kV8LlOzYVtLUwyYTslxu9pHz+uzOY6TQq0X0eGx/4Ylt9
         8BEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699269025; x=1699873825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xBR3Oh8zClbS1YQ62m6eKxWZ4Ons8qsU0E4Liv4Rvg0=;
        b=jYGeXkpH5XMq2l5B/lUKKMo8VZipXo6Aw2dtM/4AWXQbLv8ZUGQf3SNceNFH/UvAZG
         xZrQ77s80Uf8FdnIVHWeAu3fYiLA2HOJeHdqZ4RXdIGBUHC9wjBJlkrnUP/zCUPbW+mF
         3qLlkRC5ADNiZW4u++z7zysvW1RN6c5jRohdIPr58TTmFV6sOrz9JcyrxNX70S+MpcJB
         EvSMqvU1cgYw29YFCGSQxovl2hrUFSr7OgVOu0wY27rxd3aw5T726S/KIHQAuF5nShiv
         yar2OLNz/hwsJ+0JnVeePBKMwYsEY4qFpUpX9ionUXIcVH6WmmUeWiWRJhyCbE2s045W
         ZCrQ==
X-Gm-Message-State: AOJu0Yx7ft7/V9rHilitNEfFzmtkPt+IkBVqGO2BBVHxFumx0b0tvCkt
	PjjCXBeadn1/orzCI3V5p1NBtw==
X-Google-Smtp-Source: AGHT+IFMIKgYKaG2x26tSZ+5foWBGqKNS7CQHWd9OLbklpXVybTTE5AVAduGsFeWircKlsRiiuVWlA==
X-Received: by 2002:a05:6512:318f:b0:509:45ed:1083 with SMTP id i15-20020a056512318f00b0050945ed1083mr12662290lfe.40.1699269024745;
        Mon, 06 Nov 2023 03:10:24 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id bh7-20020a05600c3d0700b00401b242e2e6sm11965729wmb.47.2023.11.06.03.10.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:10:24 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Adrian Wowk <dev@adrianwowk.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PULL 60/60] ui/sdl2: use correct key names in win title on mac
Date: Mon,  6 Nov 2023 12:03:32 +0100
Message-ID: <20231106110336.358-61-philmd@linaro.org>
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

From: Adrian Wowk <dev@adrianwowk.com>

Previously, when using the SDL2 UI on MacOS, the title bar uses incorrect
key names (such as Ctrl and Alt instead of the standard MacOS key symbols
like ⌃ and ⌥). This commit changes sdl_update_caption in ui/sdl2.c to
use the correct symbols when compiling for MacOS (CONFIG_DARWIN is
defined).

Unfortunately, standard Mac keyboards do not include a "Right-Ctrl" key,
so in the case that the SDL grab mode is set to HOT_KEY_MOD_RCTRL, the
default text is still used.

Signed-off-by: Adrian Wowk <dev@adrianwowk.com>
Acked-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-ID: <20231030024119.28342-1-dev@adrianwowk.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 ui/sdl2.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ui/sdl2.c b/ui/sdl2.c
index fbfdb64e90..4971963f00 100644
--- a/ui/sdl2.c
+++ b/ui/sdl2.c
@@ -172,11 +172,19 @@ static void sdl_update_caption(struct sdl2_console *scon)
         status = " [Stopped]";
     } else if (gui_grab) {
         if (alt_grab) {
+#ifdef CONFIG_DARWIN
+            status = " - Press ⌃⌥⇧G to exit grab";
+#else
             status = " - Press Ctrl-Alt-Shift-G to exit grab";
+#endif
         } else if (ctrl_grab) {
             status = " - Press Right-Ctrl-G to exit grab";
         } else {
+#ifdef CONFIG_DARWIN
+            status = " - Press ⌃⌥G to exit grab";
+#else
             status = " - Press Ctrl-Alt-G to exit grab";
+#endif
         }
     }
 
-- 
2.41.0


