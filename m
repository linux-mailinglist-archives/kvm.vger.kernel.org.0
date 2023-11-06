Return-Path: <kvm+bounces-820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9B27E2F6A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 23:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8DD3280D11
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 22:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9934E2EB05;
	Mon,  6 Nov 2023 22:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8K/cwsF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5882D048
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 22:06:00 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ED910A
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:05:59 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6c398717726so2178468b3a.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 14:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699308359; x=1699913159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/O5mNQYvmSeM4g33PS0eM+ofipQ6AbL8BoPwtDwzqak=;
        b=j8K/cwsFvRv2oFXjZVVgP0O+ehmV/GHJ7QQRRZhfLszAwkTZvW85iIEZD3XrtLG5vk
         YcvHYd7dDHvXNYQCJuPC8q+BaP+LN+4VP8YU03ynRakzLVIB6AKAUE+635TegNjdzVii
         m3M85TjI/PneaDbz0AE2ss2sKpO/zY6fh6mu34AS8BE4c2Uui+6Dj+MCZIc/iVkCjDJM
         Q/cQ2lBzKujbSfWztZeISUYyPgr40RJc72bVIUlH+wsWwi5+XcIK9zi2qxYtt905CGtV
         qPd/1f5TMVVneLlCqexeOlIPKqqn495H6gBvo6cr4Rx0F1BLfRK5LToI/ee0K7wQn/aG
         KrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699308359; x=1699913159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/O5mNQYvmSeM4g33PS0eM+ofipQ6AbL8BoPwtDwzqak=;
        b=V4lzaUIbafnRmNFdd44evkaDMyrzM2SE4UDuXOeYC909Htbiis3NON2grYe5iylQ79
         3tfgcrz8EbzGY3PV9nK49s51wiK7+PLaOKxdHFO/e5+U0zctWnKJzX5e4pqejCOYhMx1
         PX59F85vV2vhrz1gVC9TCJ5vDuP/RqKNV7tN4lJqc9W1rWRNXE2rCO0C8+rAZjVikVuX
         p7BmiACixEoVxpOLGfWmbqtSYz+fYEvxN16LrFTYEmAfVUDG4piQBlpyu90bUvQePBh1
         i2/X5005hNOVczsOcUlnSylG5tE9UxbghK4OBYBwPqxccWty2DTZmhjdmXonPa9cZV8W
         twRQ==
X-Gm-Message-State: AOJu0YwIMighzPa8llI7nqbBWFL+AZ/M2AW34u3iW17RjN1NnJIPFDgu
	tskStvPFoLjyosX60I5/Ab4=
X-Google-Smtp-Source: AGHT+IG51xwsXhXTi9GpjcP4vczglPWY2Z+iqaRZ+zr5SoLpDZO3UkBOCdQUd1pjQ+D8WmQxa+j6mA==
X-Received: by 2002:a05:6a00:17a9:b0:6be:265:1bf6 with SMTP id s41-20020a056a0017a900b006be02651bf6mr29519997pfg.32.1699308359061;
        Mon, 06 Nov 2023 14:05:59 -0800 (PST)
Received: from paxos.mtv.corp.google.com ([2620:15c:9d:2:b062:65c9:e9d5:831b])
        by smtp.gmail.com with ESMTPSA id t17-20020a056a00139100b006933866f49dsm6252195pfg.19.2023.11.06.14.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 14:05:58 -0800 (PST)
From: Lepton Wu <ytht.net@gmail.com>
To: brijesh.singh@amd.com
Cc: tglx@linutronix.de,
	kvm@vger.kernel.org,
	Lepton Wu <ytht.net@gmail.com>
Subject: [PATCH] x86/mm: Guard adding .bbs..decrypted section with CONFIG_AMD_MEM_ENCRYPT
Date: Mon,  6 Nov 2023 14:05:28 -0800
Message-ID: <20231106220528.3193206-1-ytht.net@gmail.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit b3f0907c71e0 ("x86/mm: Add .bss..decrypted section to hold shared variables")
usage on some kernels without CONFIG_AMD_MEM_ENCRYPT. Fix it by guarding it
with CONFIG_AMD_MEM_ENCRYP.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>
---
 arch/x86/kernel/vmlinux.lds.S | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 54a5596adaa6..d39798a23f86 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -69,6 +69,8 @@ jiffies = jiffies_64;
 #define ALIGN_ENTRY_TEXT_BEGIN	. = ALIGN(PMD_SIZE);
 #define ALIGN_ENTRY_TEXT_END	. = ALIGN(PMD_SIZE);
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+
 /*
  * This section contains data which will be mapped as decrypted. Memory
  * encryption operates on a page basis. Make this section PMD-aligned
@@ -88,6 +90,12 @@ jiffies = jiffies_64;
 
 #else
 
+#define BSS_DECRYPTED
+
+#endif
+
+#else
+
 #define X86_ALIGN_RODATA_BEGIN
 #define X86_ALIGN_RODATA_END					\
 		. = ALIGN(PAGE_SIZE);				\
-- 
2.42.0.869.gea05f2083d-goog


