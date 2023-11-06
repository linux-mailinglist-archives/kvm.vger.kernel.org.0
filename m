Return-Path: <kvm+bounces-701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1891F7E1F79
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67852B22577
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF751A70C;
	Mon,  6 Nov 2023 11:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HxkprFIC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2481A598
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:07:30 +0000 (UTC)
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6253D73
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:07:20 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c6b48cb2b6so61122941fa.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268839; x=1699873639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S8/5vIGDLKMGAXYMu1UZsIS0RjKQzcO4h+Duvu/oNU4=;
        b=HxkprFIC4OGDu5zmDRCgl4rUg3HUPT6iT7yscdI7ZLfbbZiJp5wA2m8x2b6m4siGZA
         GTF770ccxx0Prpc0G2oz8+4ITg0QKzhfR6ofBOBHQ/Pgzd1loHAaWob44K/SRmKiQw//
         oQMXVIyz6a++UmRuwVX2rxWHYgMIOP79z6Rah01ZSUqZF9djXappWbc0w6W2oZJgeVXY
         QSfzMUzbwuYLPWHSK9/Iq254yruTmYL5VTh7veHKSRDtnmAwx60lJ0tlOQkAzfOl63Zh
         pL7K02ME+jx7GJDGBP6CG1wCvIL/ISJnW/ZUEZP51741g3p006zgZbbusu9Qr7KZ98G4
         Kdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268839; x=1699873639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8/5vIGDLKMGAXYMu1UZsIS0RjKQzcO4h+Duvu/oNU4=;
        b=UYMwQXyOTZrWkHDTHRX5mDoQqet+d9sF7vn/SClni2ISmizFo59josBcqOVm281LoC
         LmVLTdShyaUFsarK2CAEv5MV+TuPLBfvKUWw00c+KUKyAL7zUKe3gryjG2ZRn5ZJDJQe
         OHQwZC3Eih843ot2Cr7SBVr7bILl33B9s7iZfz++w+HC+KyFB2b7Qx1jyvw6D+NgUjLv
         TQVusZpIEnpG9nLeeJZJCVJw5NH2ISqx1gjID1ubmXIAx/IxWa9c019Lj1qj9zS/xayK
         i0VboZEipBqjEzy14EKU4G438L8uH1CGGL3hu7E4y27+9UNt5XKf6IsGZ7D0RFIo5dYD
         Lu1g==
X-Gm-Message-State: AOJu0Ywn7ylQlFTQgQvS04hijQlZScZiOcs3iJAiat7i3KxgKU//KEGG
	ysRDXrxKb6c3if18wkDXkYqKvQ==
X-Google-Smtp-Source: AGHT+IGUmAjl7n06mFubnd+gEr0baz8hJiaRcQUniE2ytONQaxbr97H+8iARFxziBtFUQ6m1v/mnVw==
X-Received: by 2002:a2e:940e:0:b0:2c6:e46e:9849 with SMTP id i14-20020a2e940e000000b002c6e46e9849mr10927288ljh.15.1699268838970;
        Mon, 06 Nov 2023 03:07:18 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c470900b003feea62440bsm11701095wmo.43.2023.11.06.03.07.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:07:18 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PULL 32/60] sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
Date: Mon,  6 Nov 2023 12:03:04 +0100
Message-ID: <20231106110336.358-33-philmd@linaro.org>
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

kvm_get_radix_page_info() is only defined for ppc targets (in
target/ppc/kvm.c). The declaration is not useful in other targets,
reduce its scope.
Rename using the 'kvmppc_' prefix following other declarations
from target/ppc/kvm_ppc.h.

Suggested-by: Michael Tokarev <mjt@tls.msk.ru>
Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>
Message-Id: <20231003070427.69621-2-philmd@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h | 1 -
 target/ppc/kvm.c     | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 80b69d88f6..d614878164 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -521,7 +521,6 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void *source);
  * Returns: 0 on success, or a negative errno on failure.
  */
 int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target);
-struct ppc_radix_page_info *kvm_get_radix_page_info(void);
 
 /* Notify resamplefd for EOI of specific interrupts. */
 void kvm_resample_fd_notify(int gsi);
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index d0e2dcdc77..9b1abe2fc4 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -268,7 +268,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_info *info, Error **errp)
                      "KVM failed to provide the MMU features it supports");
 }
 
-struct ppc_radix_page_info *kvm_get_radix_page_info(void)
+static struct ppc_radix_page_info *kvmppc_get_radix_page_info(void)
 {
     KVMState *s = KVM_STATE(current_accel());
     struct ppc_radix_page_info *radix_page_info;
@@ -2368,7 +2368,7 @@ static void kvmppc_host_cpu_class_init(ObjectClass *oc, void *data)
     }
 
 #if defined(TARGET_PPC64)
-    pcc->radix_page_info = kvm_get_radix_page_info();
+    pcc->radix_page_info = kvmppc_get_radix_page_info();
 
     if ((pcc->pvr & 0xffffff00) == CPU_POWERPC_POWER9_DD1) {
         /*
-- 
2.41.0


