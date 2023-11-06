Return-Path: <kvm+bounces-700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0557F7E1F77
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C287B22437
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F63199CE;
	Mon,  6 Nov 2023 11:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YYVh/pkZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED0618E05
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:07:21 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F38D4D
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:07:14 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40838915cecso32072305e9.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268832; x=1699873632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysTm3sVa8NXK5p6adWouAn7jMZtjrRCTYZ5tPCHuc7A=;
        b=YYVh/pkZQNYXP7k/N5UbLPmszCb88jopRJAdsACawZD6NxYrHkBo3Z/4YsKgaspEmc
         CTWP/MreBVH3AljkVvnM8iFhkt6KNkk+e3P1pRmQjUCCxRW8m+Cg6t6uslA21zg1hSYP
         lhfVtJhiCrT0qL1Api3mYUqjyFWaphaoFGcrbqTlkMPrW3NqG/EMKKylQVUJ36HKhm38
         mWBdP09SckwQoBk0irSLH2Z4HovaWLRwsy/7aE0AyrHL7TSCOGQfwzSf1v72FfpSdas3
         S6vq4oJB2tIZuOXczGRz0Iue46TheAvk3z4ZrfHmGBMuBgKUe5Pu/+I740FFNhT7LYBE
         trxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268832; x=1699873632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ysTm3sVa8NXK5p6adWouAn7jMZtjrRCTYZ5tPCHuc7A=;
        b=cNVXEtcSLp8Wse+FtH8726OsmpmCwosmGN7htUaNdUF8OgF3s+Hero4U+9fEwzhDJ5
         EXwYbaCmxeiZ56APjhdzbJqhII1pgGCHx+m5v2jRineoMvBZRUwzMi6BPwvjbbFPsCmD
         jPaslRYcO3HtG1Lb11Is4UVh5rE9No39Hwph8DAGCPBnPB2E40EBV2KN3QgfuZWzsvPD
         Qj/1yWgPQtjfIiVOR7taAhA+cULgjhSI1m8SgbfPSQzuD4X7bskOMfvwrtiQwwwwRy9p
         XRFzoeBkXO5rKtiDdchs7eOYmMNCPBlUDU6jpLPmnxy0TuvWMXHlCcJPxu+GmG+gAds8
         Jhbw==
X-Gm-Message-State: AOJu0Yza7a8/ek4jUCFYPtq2CGhThVCx3hBeotr0y+NXbWPhaUXzZbHa
	jtS3DPLCLddPEB0aHLPupyTheg5MH3hYxOsjtIw=
X-Google-Smtp-Source: AGHT+IGkZmXraGC+Dqk5EDM2vOTL7rIZmIj2iksC9goOWR5dfHU27l8hEGkXXJizaXpag9YQzn2U8A==
X-Received: by 2002:a05:600c:4f55:b0:408:3707:b199 with SMTP id m21-20020a05600c4f5500b004083707b199mr21831254wmq.3.1699268832460;
        Mon, 06 Nov 2023 03:07:12 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id jg2-20020a05600ca00200b004065daba6casm11958500wmb.46.2023.11.06.03.07.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:07:12 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-stable@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Subject: [PULL 31/60] target/mips: Fix TX79 LQ/SQ opcodes
Date: Mon,  6 Nov 2023 12:03:03 +0100
Message-ID: <20231106110336.358-32-philmd@linaro.org>
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

The base register address offset is *signed*.

Cc: qemu-stable@nongnu.org
Fixes: aaaa82a9f9 ("target/mips/tx79: Introduce LQ opcode (Load Quadword)")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230914090447.12557-1-philmd@linaro.org>
---
 target/mips/tcg/tx79.decode | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/mips/tcg/tx79.decode b/target/mips/tcg/tx79.decode
index 57d87a2076..578b8c54c0 100644
--- a/target/mips/tcg/tx79.decode
+++ b/target/mips/tcg/tx79.decode
@@ -24,7 +24,7 @@
 @rs             ...... rs:5  ..... ..........  ......   &r sa=0      rt=0 rd=0
 @rd             ...... ..........  rd:5  ..... ......   &r sa=0 rs=0 rt=0
 
-@ldst            ...... base:5 rt:5 offset:16           &i
+@ldst            ...... base:5 rt:5 offset:s16          &i
 
 ###########################################################################
 
-- 
2.41.0


