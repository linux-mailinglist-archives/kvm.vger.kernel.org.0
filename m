Return-Path: <kvm+bounces-672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D837E1F39
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F1001C20B89
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68E21EB47;
	Mon,  6 Nov 2023 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jCSQ8K4g"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2D71EB38
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:04:03 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D127FA
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:04:02 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50943ccbbaeso6157739e87.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268640; x=1699873440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPtEnXMJWXTavrW+hTGrjLz6IdGpJzROhuSvymabGIo=;
        b=jCSQ8K4gcPRRXf+WzgIn4jYDdAK+tWrGHgCpc09cU432occoDcDnMdGghmtvgT5NBK
         T6Z6zxcjhgoOg1PjJD7X4H17XYT+yneIRJLOgLbJOTpTwP+uJIv7DSzKstqHhCGqqgWS
         2AEkppI5yLt9rAw3EDS6K8EXN4l6D5h6mFLgVQcNIPmm4lKkEyzaZVQWtNRqhQHHJRJA
         tIjWaNvsub97b+GRXUk1lxNt9G7pObGuVESQ/YaZ1pzovdtkji6TherXM9mIHAMtTB+T
         HbWkGT5c/+t55Qa1rLvlXVkXSqs7heG49sjNyuGZokdLZ2asrqtFRjR2e4hvsVvcsiPa
         ItPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268640; x=1699873440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPtEnXMJWXTavrW+hTGrjLz6IdGpJzROhuSvymabGIo=;
        b=RCeqccSmQzZAj5usk6t2GYJ7JCS01E6RxIbx9dhs+qqVeW1Upjyx3tKb1LVoN/N5+g
         u7K21OP3Jv1MSePDGbQ4nq8ntHsGOZn6jIQLUFWNV/12F0lepTa/IauI3ippbrSSxVa5
         wBv3+EcHrl1ccHhRLnnpF/mQrqcD1V4FOQ4UpefiGLhgmBl/MJsr+UzZoHOH/wXixx1J
         7dX8eLJmIas25nv0jQFAmQw1vhVvtkfGkO6ACrPYKr41aQIpGg6okghHvJYaNSZN++mx
         L8ZD1yWQmrAYmcUMPYSbwOVERt6mMjze8/qhnoMP21/AHKIoLf1hKz/NNzjxaGbZ+NKy
         RtKA==
X-Gm-Message-State: AOJu0YzYJrQ1a/eAA8JSPqoCGU6GgSs+C4fVxc3KCk1RACDnKlCyxXas
	oLSUN9+hLlwv89oI9+ijcFLsTQ==
X-Google-Smtp-Source: AGHT+IHnmaFN+GKLxd2N49xPwJp/PkOfW8YFcpTs0zHKDnkUPvcBfxvj2jLWyUiBIPgGTifMjl5zjg==
X-Received: by 2002:a05:6512:1282:b0:505:6ede:20a9 with SMTP id u2-20020a056512128200b005056ede20a9mr26978590lfs.65.1699268640437;
        Mon, 06 Nov 2023 03:04:00 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id l10-20020adff48a000000b0032fdcbfb093sm19447wro.81.2023.11.06.03.03.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:04:00 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Beraldo Leal <bleal@redhat.com>
Subject: [PULL 03/60] tests/vm/ubuntu.aarch64: Correct comment about TCG specific delay
Date: Mon,  6 Nov 2023 12:02:35 +0100
Message-ID: <20231106110336.358-4-philmd@linaro.org>
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

Wether we use a software MMU or not to set the SSH timeout
isn't really relevant. What we want to know is if we use
a hardware or software accelerator (TCG).
Replace the 'softmmu' mention by 'TCG'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231002145104.52193-2-philmd@linaro.org>
---
 tests/vm/ubuntu.aarch64 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/vm/ubuntu.aarch64 b/tests/vm/ubuntu.aarch64
index 666947393b..eeda281f87 100755
--- a/tests/vm/ubuntu.aarch64
+++ b/tests/vm/ubuntu.aarch64
@@ -25,7 +25,7 @@ DEFAULT_CONFIG = {
                      "apt-get install -y libfdt-dev pkg-config language-pack-en ninja-build",
     # We increase beyond the default time since during boot
     # it can take some time (many seconds) to log into the VM
-    # especially using softmmu.
+    # especially using TCG.
     'ssh_timeout'  : 60,
 }
 
-- 
2.41.0


