Return-Path: <kvm+bounces-726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9DE7E1FA2
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:10:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C38B1C20BE6
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6B118B0C;
	Mon,  6 Nov 2023 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O6Paq7jX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE061EB29
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:10:09 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D0FBB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:10:07 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-507962561adso5646661e87.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699269006; x=1699873806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ut7p2F8ycBCH0WfVrPlQ2F/inhGj3Q9WVzKOY6zxb1o=;
        b=O6Paq7jXnc+hsSDDjMuowrwbUIsW9OOYVr0pU1u0WRVdcZulp+cIWrRRIG++IcbaDc
         UXS/SiZ2/wdPecqCHusoazuMwrKgqsYv2+Bc8/7zcW/dPkW2kZa9ifnbGCiKoCkcwQUr
         jzkdR1/4gI+sqdI9V6R4DUPswA0hOH0dnN8qLcBMfWo7nzJmhmlEc4qhyW6uTHbSn5Fn
         P+Ff1x8NWto/cWRv3+4bUrEVEUb1Wj84LbS/4zUm3zS+w2gBOeeUJ3Yd4wj33bPd1baE
         ehAMUJxUhzItXb7B3FfNXBTE8nnVQOasbKMN9x4Acwnbpk69AVu0CPqhLHcLwFdbP4Ec
         bM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699269006; x=1699873806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ut7p2F8ycBCH0WfVrPlQ2F/inhGj3Q9WVzKOY6zxb1o=;
        b=ovOH1pGIwteh2TChOJqpjym0HHOxPb3ICIE0rRPlWs3HynEAb/tmmg+/mrgzQ1Z3sc
         jWzTN5vE6qbXMKS7buvQUn4FqRjL0h3NOfkx5wGuYKW9/W/Uuy4Ve6NC2sJRsSGGBARv
         2MjPFVNt1v9HY/elTvZKXIMN5WFPza31SUf4K6ZboA7bpWJFnRisSEfnqNTDGi1KY7q0
         smdfZAyiQSMkrvHaphiiK2+WcZBF3IIv+lv9665/U9ruskrvDAS8FdnzvWAANZ3snZbp
         P66341pPTIrLy+sNvDArmGvvlYp3e02rwK5gEQ6ksfqUgqCHzAGIGC/x83dW5zq2LTIB
         rY8g==
X-Gm-Message-State: AOJu0Ywj6B2CQDHWbEurvauCFgABusNspRvjPpOwK9Q0A3vrpntTt4fR
	2pvdOfm7SrWsZ2ENer7l9GlUbQ==
X-Google-Smtp-Source: AGHT+IFV61WUgaftWSmxlAIXL8iGaW0THkIGj/tNK5wYBo9dUSgSqDELMeQc5HMjnGPaXiCVpA73WA==
X-Received: by 2002:a05:6512:1599:b0:508:1470:6168 with SMTP id bp25-20020a056512159900b0050814706168mr25813290lfb.57.1699269006155;
        Mon, 06 Nov 2023 03:10:06 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id l9-20020adfe589000000b0032f7d7ec4adsm9119404wrm.92.2023.11.06.03.10.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:10:05 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PULL 57/60] MAINTAINERS: Add include/hw/timer/tmu012.h to the SH4 R2D section
Date: Mon,  6 Nov 2023 12:03:29 +0100
Message-ID: <20231106110336.358-58-philmd@linaro.org>
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

From: Thomas Huth <thuth@redhat.com>

tmu012.h is the header that belongs to hw/timer/sh_timer.c, so we
should list it in the same section as sh_timer.c.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Message-ID: <20231026080011.156325-1-thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c01c2e6ec0..3014e768f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1617,6 +1617,7 @@ F: hw/intc/sh_intc.c
 F: hw/pci-host/sh_pci.c
 F: hw/timer/sh_timer.c
 F: include/hw/sh4/sh_intc.h
+F: include/hw/timer/tmu012.h
 
 Shix
 R: Yoshinori Sato <ysato@users.sourceforge.jp>
-- 
2.41.0


