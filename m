Return-Path: <kvm+bounces-724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9EF7E1F9E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9705B21538
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119F21EB31;
	Mon,  6 Nov 2023 11:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h2AqQrVy"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0731805F
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:09:55 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6155998
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:09:54 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-32f8441dfb5so3013680f8f.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268993; x=1699873793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UYA9fxIVAJDV/ugwhxZLfTB1YL01/OCPxws1OIhgNw=;
        b=h2AqQrVy2qtISuUIN5l52VZSVRUyRN8s56S4Z/hrVkM14shLLUBX6Hw+D0qhsjCzqB
         SeF6CWdwHdLiCiDiKnvChncL5WPlg+YKDFcAvTD/Kav9bGZ+7yGK1vDHx2urdMdhVWVr
         CyuaweiE1gfe6HVrBh4lMv4xA2/nfxICWl06ojUf7PqdkhL+XUzDR/LZCVEtMs3aB2ZV
         4djUEJQFCjj09zKBPox+GI3nZZ41fInymQQpUXvmayRgiZhdH9QPCPkjIHgJ7E5yotif
         ++sG90lDMOYyI+q8zsckjOrQFOYFWYKrV9jSAV9jvhc5ll/4wJDBltLWDs7yKPSwnDZi
         OfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268993; x=1699873793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UYA9fxIVAJDV/ugwhxZLfTB1YL01/OCPxws1OIhgNw=;
        b=Jw65RFEaQZcYE6yNHKmQqYrazBj9PDwMYwaegta0pg9IEWS0UvPMdXAOUkg2t/hJKG
         BeoZhtanjB9VX/uEvCY5RPOSd2Bpuw0Kmk6a+SuzATbuo9M6hFx4wsb2L6eeganIU3QY
         ljDxxRC/J5iIFfXuQ7rdnhLgK9XznhTENR0oGpDTKuJLLNFQAWItMPNxhFWzmbG9tyTu
         F15LqY77AdNHb8Yfbio2CVuvxrZ7tzB3M0039AwlKGFP9NzLYjg9GvpU4FUUWS3nBct/
         K3DQ23l7qClRXUiRe8+DH1x7IgoZJQaXJkXMaxoNOiviKA/utWtV7b/YnQzlXeWyZwm5
         mVRg==
X-Gm-Message-State: AOJu0YxSJPLUahvON8qDomZ5O+ZJSGOlK6cga1LyAJXMGG+K/6X+x/1Y
	xwGzBJFf8+DbNGmh9bLyzlALhg==
X-Google-Smtp-Source: AGHT+IEJYwaQv9zhCAnw87q6XL1cNQIMVWd4njIJAfgg35jyjWT0oa+xJ0fh+sg8SmmssH1mUhxHcw==
X-Received: by 2002:a05:6000:4021:b0:32d:b991:1a71 with SMTP id cp33-20020a056000402100b0032db9911a71mr27821328wrb.0.1699268992895;
        Mon, 06 Nov 2023 03:09:52 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id f18-20020a5d58f2000000b0032da4c98ab2sm9102932wrd.35.2023.11.06.03.09.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:09:52 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Titus Rwantare <titusr@google.com>,
	Patrick Venture <venture@google.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PULL 55/60] hw/i2c: pmbus: immediately clear faults on request
Date: Mon,  6 Nov 2023 12:03:27 +0100
Message-ID: <20231106110336.358-56-philmd@linaro.org>
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

From: Titus Rwantare <titusr@google.com>

The probing process of the generic pmbus driver generates
faults to determine if functions are available. These faults
were not always cleared resulting in probe failures.

Reviewed-by: Patrick Venture <venture@google.com>
Signed-off-by: Titus Rwantare <titusr@google.com>
Message-ID: <20231023-staging-pmbus-v3-v4-7-07a8cb7cd20a@google.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i2c/pmbus_device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/i2c/pmbus_device.c b/hw/i2c/pmbus_device.c
index 3bce39e84e..481e158380 100644
--- a/hw/i2c/pmbus_device.c
+++ b/hw/i2c/pmbus_device.c
@@ -1244,6 +1244,11 @@ static int pmbus_write_data(SMBusDevice *smd, uint8_t *buf, uint8_t len)
     pmdev->in_buf = buf;
 
     pmdev->code = buf[0]; /* PMBus command code */
+
+    if (pmdev->code == PMBUS_CLEAR_FAULTS) {
+        pmbus_clear_faults(pmdev);
+    }
+
     if (len == 1) { /* Single length writes are command codes only */
         return 0;
     }
-- 
2.41.0


