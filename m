Return-Path: <kvm+bounces-678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD83E7E1F40
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EF20B21463
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E002318AE4;
	Mon,  6 Nov 2023 11:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NS6KuHO0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3EF182DB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:04:45 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AD4B0
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:04:44 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-307d58b3efbso2509362f8f.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268682; x=1699873482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edoh0A4VIBHnomUl2UTL+gBl3YX8JThMwON2libfRQU=;
        b=NS6KuHO0cmCmp/6pMY9kb7noz1GPDcCvR2gyiLYsCZ8p6GUV85Xfe1g4gX9zmBufdB
         LUxj7KIGnpMov6o7V/e02UYTb//dy71qk1uPEwiijZZvMHWJFP7wBGTCniGrhGSLYjf1
         NmU/JJvZ3xxiD+kXjyFwoSY0ok/bVOs+iE4U2sxW/lI2ejGOhhk5k6W7FdZ4Rtn4oaW+
         AYVn0+DYs4Bjan+ePLkrRE0ML4ueIr1EVv3m3ArkhuUDZ2v3b0BpXZXw/uRKcsaRGuCs
         BxF2VBsiAUc7tRGcKZcXAIcrbs/bRs9RW1o+h+O4A25GUkF0igJAoUidrBfB0VaWSDyB
         dlZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268682; x=1699873482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edoh0A4VIBHnomUl2UTL+gBl3YX8JThMwON2libfRQU=;
        b=crMHoiUBUKuHG5IaK7ZhTmmOXxaYsleDwnSutdpMdnWs32/y8WopGNrm8KtGaq3SIv
         ejG0kU6pU9GY1+sGA5o/IAVOHLAhDDfmAX1wqEEZd/Nwcm0PHJrd67anEUfCSjuDGsDH
         WBpxv0t+zjSkfTlvt1tC5p7xLY2IC4jdaTMF7+0O3f2gjqLMPUPhYRrHfXMuIoj4tSTq
         F4BphCj2lyvgiTmChf5RafFTPxpPU6HzqW+TovbqCZGJ1wjNWc2s6LnOl56/Bxw4BBZj
         kT8zKxuMIvRF92rjholIuKTM9+Z1fICqzA/aNKUPEHlmBlP+ewmSm1TkT9WVaR/WyhYw
         NG3w==
X-Gm-Message-State: AOJu0YzlGj0HHXS4don5eONnLAn6V2nPUbYHerPfmYyisKXSBjrh1Ci8
	7qo4THOYnv1uYbDLLy+ervNRDg==
X-Google-Smtp-Source: AGHT+IFlBVNG2dMbfKa3SmCrF8WLEs8NXPQC60vm5+BiWuQcq5Hh8zZkMSTj4OjAvWykBZy1YCBg/g==
X-Received: by 2002:adf:f0c8:0:b0:32d:a2a3:9533 with SMTP id x8-20020adff0c8000000b0032da2a39533mr23224446wro.59.1699268682776;
        Mon, 06 Nov 2023 03:04:42 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id y3-20020adfe6c3000000b003140f47224csm9111991wrm.15.2023.11.06.03.04.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:04:42 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: [PULL 09/60] target: Mention 'cpu-qom.h' is target agnostic
Date: Mon,  6 Nov 2023 12:02:41 +0100
Message-ID: <20231106110336.358-10-philmd@linaro.org>
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

"target/foo/cpu-qom.h" is supposed to be target agnostic
(include-able by any target). Add such mention in the
header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231013140116.255-3-philmd@linaro.org>
---
 target/arm/cpu-qom.h        | 2 +-
 target/hppa/cpu-qom.h       | 2 +-
 target/microblaze/cpu-qom.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/arm/cpu-qom.h b/target/arm/cpu-qom.h
index 153865d1bb..dfb9d5b827 100644
--- a/target/arm/cpu-qom.h
+++ b/target/arm/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU ARM CPU
+ * QEMU ARM CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
diff --git a/target/hppa/cpu-qom.h b/target/hppa/cpu-qom.h
index 67f12422c4..4b1d48f7ca 100644
--- a/target/hppa/cpu-qom.h
+++ b/target/hppa/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU HPPA CPU
+ * QEMU HPPA CPU QOM header (target agnostic)
  *
  * Copyright (c) 2016 Richard Henderson <rth@twiddle.net>
  *
diff --git a/target/microblaze/cpu-qom.h b/target/microblaze/cpu-qom.h
index 2a734e644d..78f549b57d 100644
--- a/target/microblaze/cpu-qom.h
+++ b/target/microblaze/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU MicroBlaze CPU
+ * QEMU MicroBlaze CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
-- 
2.41.0


