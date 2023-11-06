Return-Path: <kvm+bounces-710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5EDD7E1F83
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0DD9281655
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2C51A5B8;
	Mon,  6 Nov 2023 11:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ngnx2d/3"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168D81A592
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:08:23 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA9BA3
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:08:21 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4081ccf69dcso31193385e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268900; x=1699873700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P0lV2v0Wmf5sVpflPIAh1iXlsF2JSjaFEuoVMwFWbSs=;
        b=Ngnx2d/3m8cZGHYdRchAYpFRDUTReMyqRiGsXxHhQwfSgzJlmGa1JfC0UawsHQ6jKn
         yVQV7jhK9gYKPxxtZoiAqcdWTZBAfjBAjDuTa46cYPWGn7gK3ci/HJU4ASPNIxJqYiOD
         TOBdyV+4VilpwU1EE42vPX4xn2ayyzEam1D6+hDe93wl5Gq79X/5N/7mlp+YX207p95/
         lBdT4EY/tyVAxucxuAsHq9gdEIfp8YcpTB41dCE+/r2h/EgCa8try9WoKekIPb2PiB6+
         4xoQeTFw4oiBSAYfCTA5KghUC66g0dunr8WQEvfXRfeugx9Fak9mb17WS/LiawRhdzFL
         vWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268900; x=1699873700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P0lV2v0Wmf5sVpflPIAh1iXlsF2JSjaFEuoVMwFWbSs=;
        b=OnAfXJzKHnTWn4cn9Ut6Ze3suoioGaTjmlPedA3ZTSK8/lgMKoT14pasdDKl5aCWso
         S7oLSY9JHga/fXxC1Gbt3rr3Nmj2ygkPxqKjZpSy/6GE/A4zQZH71aGn9lqa8/4QY3vK
         C1Zpqtbt8RjZKHWO0mm5kXIN8ALcL+uKaMAlT5GXnFbw01KMKAnHTHG8mCtemOUJR7sa
         Mnk3CGaGrCO4T4iC3RAahhuQzqyTZihGBK8iKgQAYr3Zs0+U6tU8tBmB7PH0qpWfSwM+
         EXsCWq9FuhjXxj9mfaC981KbR9D5yFOHjlCD10fNxrFf3gpoEhdpJxktIIINvxeLSUV7
         iAqg==
X-Gm-Message-State: AOJu0YwQsaxsZ0sNsZcYf9l20JAyLs6NBAxkPql3DjqaRP4mYNgtY9wI
	VWYKBK/qY+HpfKBTXrN/uC/eFQ==
X-Google-Smtp-Source: AGHT+IE5qy7fo5hvbTA76kNpTwyuY8BAliZrJmEatPyDDOojWhCYCUN5LQHLcBtUF5POiIT/JDO9Og==
X-Received: by 2002:a05:600c:3205:b0:403:aced:f7f4 with SMTP id r5-20020a05600c320500b00403acedf7f4mr11411925wmp.12.1699268900310;
        Mon, 06 Nov 2023 03:08:20 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id j19-20020a05600c1c1300b004060f0a0fd5sm11862251wms.13.2023.11.06.03.08.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:08:20 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>
Subject: [PULL 41/60] hw/loader: Clean up global variable shadowing in rom_add_file()
Date: Mon,  6 Nov 2023 12:03:13 +0100
Message-ID: <20231106110336.358-42-philmd@linaro.org>
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

Fix:

  hw/core/loader.c:1073:27: error: declaration shadows a variable in the global scope [-Werror,-Wshadow]
                       bool option_rom, MemoryRegion *mr,
                            ^
  include/sysemu/sysemu.h:57:22: note: previous declaration is here
  extern QEMUOptionRom option_rom[MAX_OPTION_ROMS];
                       ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Ani Sinha <anisinha@redhat.com>
Message-Id: <20231010115048.11856-3-philmd@linaro.org>
---
 include/hw/loader.h | 2 +-
 hw/core/loader.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/hw/loader.h b/include/hw/loader.h
index c4c14170ea..8685e27334 100644
--- a/include/hw/loader.h
+++ b/include/hw/loader.h
@@ -272,7 +272,7 @@ void pstrcpy_targphys(const char *name,
 
 ssize_t rom_add_file(const char *file, const char *fw_dir,
                      hwaddr addr, int32_t bootindex,
-                     bool option_rom, MemoryRegion *mr, AddressSpace *as);
+                     bool has_option_rom, MemoryRegion *mr, AddressSpace *as);
 MemoryRegion *rom_add_blob(const char *name, const void *blob, size_t len,
                            size_t max_len, hwaddr addr,
                            const char *fw_file_name,
diff --git a/hw/core/loader.c b/hw/core/loader.c
index 4dd5a71fb7..7f0cbfb214 100644
--- a/hw/core/loader.c
+++ b/hw/core/loader.c
@@ -1070,7 +1070,7 @@ static void *rom_set_mr(Rom *rom, Object *owner, const char *name, bool ro)
 
 ssize_t rom_add_file(const char *file, const char *fw_dir,
                      hwaddr addr, int32_t bootindex,
-                     bool option_rom, MemoryRegion *mr,
+                     bool has_option_rom, MemoryRegion *mr,
                      AddressSpace *as)
 {
     MachineClass *mc = MACHINE_GET_CLASS(qdev_get_machine());
@@ -1139,7 +1139,7 @@ ssize_t rom_add_file(const char *file, const char *fw_dir,
                  basename);
         snprintf(devpath, sizeof(devpath), "/rom@%s", fw_file_name);
 
-        if ((!option_rom || mc->option_rom_has_mr) && mc->rom_file_has_mr) {
+        if ((!has_option_rom || mc->option_rom_has_mr) && mc->rom_file_has_mr) {
             data = rom_set_mr(rom, OBJECT(fw_cfg), devpath, true);
         } else {
             data = rom->data;
-- 
2.41.0


