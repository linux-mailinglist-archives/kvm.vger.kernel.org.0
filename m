Return-Path: <kvm+bounces-4510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA44813367
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 15:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D37EB1F216AE
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 14:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007835B1E7;
	Thu, 14 Dec 2023 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VjDr8nDK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8D510F
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 06:42:50 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3363aa2bbfbso1758630f8f.0
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 06:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702564969; x=1703169769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1SWxyyNzlsjwPy0q/4QbwRxuffpVyZhHt3UlcyYmbr8=;
        b=VjDr8nDKW1oqWN5bRQbnY2x0kvview7w74i1tmN4PrJLmLfuVIJGATo7e4K2ggSVaN
         WLS3992CGUncZmED8HvMIJPP9jkFSyU4m/uPK5gIE1FielWDAQb97p0TcGQ47cLwGY6B
         PbWb9sHmwrwkpxNa/r5HYRmYIqfFtdS/idUY/zon8ADDWQxH10GKSMV729GDAeu39aL5
         XfZ25ofjDYwWnIfcAZnzeOtm8WDwGVUw6oNBzl18lAo0Gue8xNSVrzhHokPgROS09+k1
         xniMtSHhxb8i/Wx3INtraFlGz8PfQHkrxzC3IbHy7JJ91heXcV8BR37JQlxfsr8/j1Od
         rYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702564969; x=1703169769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1SWxyyNzlsjwPy0q/4QbwRxuffpVyZhHt3UlcyYmbr8=;
        b=gqlOAJxA2SbScH6EnPyZE43gCR3ZcSvt6xWIW81fzKcEkPBBB1BoEeeKD0kFoVc2ro
         /fc69zeAQAjscb6XN8BJBB+TmfccpYt/bX7jvblDvRjEdJeL4DL2QtaY0h6d5xytVyTp
         qE53EZZzqJ7koRElBmFctWIH8s+EtMWJECB8dgWxZlYL/wjmgljqgJp/y/uYbqCj+bAm
         8DIYnVwfNjFTzqT19aJ9CZWZjr+6L5QO1fyUHtI7A+BMw4xQcufRJ8N7UQNFyNgLt70l
         vUjCM174jqQHhZPRl0JMboci/1AxnDyHtzMfwsF0o9cphg6jSuCO5x6doZYSfZe8C0ge
         XPrQ==
X-Gm-Message-State: AOJu0YzO6846yUPJVPGBAUO9PkLcHo7S/nVgIU0m7ZUIkrdOmTF4UEEj
	V4ziOJ0LDD3wsXjCMTr54zUfUDxqL+icc9ZdWRE=
X-Google-Smtp-Source: AGHT+IEtM4YWr1SY7BR4AadjmbL/DehKmBeFshSqCwIBI4qLY+SQ5PNZW7qIchr7zPwTRbVn9BMnuA==
X-Received: by 2002:a05:6000:1b86:b0:333:5247:be11 with SMTP id r6-20020a0560001b8600b003335247be11mr5103718wru.119.1702564969390;
        Thu, 14 Dec 2023 06:42:49 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id j4-20020adfea44000000b00336471bc7ffsm1917888wrn.109.2023.12.14.06.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 06:42:49 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id A4FC25F7A7;
	Thu, 14 Dec 2023 14:42:48 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Cleber Rosa <crosa@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [RFC PATCH] tests/avocado: avoid a copy to support read/write rootfs
Date: Thu, 14 Dec 2023 14:42:43 +0000
Message-Id: <20231214144243.36887-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While the test causes the rootfs to be updated we don't actually need
to persist anything between runs. Avoid the copy by enabling
"snapshot=on" for the drive instead.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/avocado/kvm_xen_guest.py | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index d73fa888ef..f30313e6cf 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -57,14 +57,10 @@ def common_vm_setup(self, readwrite=False):
                                           "367962983d0d32109998a70b45dcee4672d0b045")
         self.rootfs = self.get_asset("rootfs.ext4",
                                      "f1478401ea4b3fa2ea196396be44315bab2bb5e4")
-        if readwrite:
-            dest = os.path.join(self.workdir, os.path.basename(self.rootfs))
-            shutil.copy(self.rootfs, dest)
-            self.rootfs = dest
 
     def run_and_check(self, readwrite=False):
         if readwrite:
-            drive = f"file={self.rootfs},if=none,format=raw,id=drv0"
+            drive = f"file={self.rootfs},if=none,snapshot=on,format=raw,id=drv0"
         else:
             drive = f"file={self.rootfs},if=none,readonly=on,format=raw,id=drv0"
         self.vm.add_args('-kernel', self.kernel_path,
-- 
2.39.2


