Return-Path: <kvm+bounces-699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E537A7E1F74
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 228F31C20BE9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68CC18B1B;
	Mon,  6 Nov 2023 11:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I+MH3LWD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFC618644
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:07:12 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FDA10F4
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:07:07 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-407da05f05aso30526955e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268826; x=1699873626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyckcOuF1Bcu5rrRcor+Uzyh2YOL0vEJEmdAm/ud3/A=;
        b=I+MH3LWDOPgqzZEkf89C2h6REEKSKe5oqO0k5PDkpmt8G3Nji9yOYoYFWzowNsc1+4
         VX0fpbuBxn8yHx24fKVHIGm5TG9BTAU2AYUOEr3ewoR6oOjWJTuSWfAvDcooC8BKeNXJ
         EAHjLZ4+3ObxPaG/TmR618ZYapQU1CzrVFxlJqhtQgADiLxpItD0AAkPKaYUwHuGH0tS
         uXf2/wmb06xMMYpXLrKwcz9c1Zz1/BMVAr5/MWReJgUXmVHMSAMTtR7P9aIEmU7Lh/ec
         gTuAt2jfVq7sKGgKNhahPnIs3t5Er3419Ud/pEkwjS3nVpX83ndkMHMIEbIpUINQP3WR
         ZxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268826; x=1699873626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GyckcOuF1Bcu5rrRcor+Uzyh2YOL0vEJEmdAm/ud3/A=;
        b=cr/LmINDxC41Gq01Qy6e4vFPnM0JMBGSHs0UBZA+QiIR7R/ELEoZHIlxFM9A7AiXiS
         A8C9XYNXP4qNcFacYGrK7v2CgHNP4f4S7i10gIHQYsT9H4DymzJPZQs0YC3VKjAlM59d
         JVw7AR0xHcwxz8Xtd8vaYs6qH4IJnneoHsNNXjB0WUfVqe2GZpvi+e/Rt2x1onVOLtHd
         U0Ou5g61YM4UaZCY+nMhjkqKgberXxNiof0ZTeIopzfzy0JlW2dezapdAgYjt++WTDeH
         HHR8Dig5eB3J3PT/F+nUPMFPZUVEyVlSZpwZ1jxpWTk0jbvIzE7tbNzyNbrHuncHk+tF
         FmTA==
X-Gm-Message-State: AOJu0YzEeemS7EyQZvvShYc15+5DaEbcJgbj65ufPe8AZM90y2Iau0Em
	QE93QraOiHqlM/7r0K7ryXdBfg==
X-Google-Smtp-Source: AGHT+IFFKKaoUyusuMn43SnLhory9traUNVPbmAEOKUR6lhSW54LBkg8wsQBYrYSz3Gl8EhHfaGVqQ==
X-Received: by 2002:a05:600c:4f02:b0:405:3885:490a with SMTP id l2-20020a05600c4f0200b004053885490amr23785982wmq.0.1699268825836;
        Mon, 06 Nov 2023 03:07:05 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id k18-20020a5d6d52000000b0032da4f70756sm9120501wri.5.2023.11.06.03.07.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:07:05 -0800 (PST)
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
	Sergey Evlashev <vectorchiefrocks@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Subject: [PULL 30/60] target/mips: Fix MSA BZ/BNZ opcodes displacement
Date: Mon,  6 Nov 2023 12:03:02 +0100
Message-ID: <20231106110336.358-31-philmd@linaro.org>
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

The PC offset is *signed*.

Cc: qemu-stable@nongnu.org
Reported-by: Sergey Evlashev <vectorchiefrocks@gmail.com>
Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1624
Fixes: c7a9ef7517 ("target/mips: Introduce decode tree bindings for MSA ASE")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230914085807.12241-1-philmd@linaro.org>
---
 target/mips/tcg/msa.decode | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/mips/tcg/msa.decode b/target/mips/tcg/msa.decode
index 9575289195..4410e2a02e 100644
--- a/target/mips/tcg/msa.decode
+++ b/target/mips/tcg/msa.decode
@@ -31,8 +31,8 @@
 
 @lsa                ...... rs:5 rt:5 rd:5 ... sa:2 ......   &r
 @ldst               ...... sa:s10 ws:5 wd:5 .... df:2       &msa_i
-@bz_v               ...... ... ..    wt:5 sa:16             &msa_bz df=3
-@bz                 ...... ...  df:2 wt:5 sa:16             &msa_bz
+@bz_v               ...... ... ..    wt:5 sa:s16            &msa_bz df=3
+@bz                 ...... ...  df:2 wt:5 sa:s16            &msa_bz
 @elm_df             ...... .... ......    ws:5 wd:5 ......  &msa_elm_df df=%elm_df n=%elm_n
 @elm                ...... ..........     ws:5 wd:5 ......  &msa_elm
 @vec                ...... .....     wt:5 ws:5 wd:5 ......  &msa_r df=0
-- 
2.41.0


