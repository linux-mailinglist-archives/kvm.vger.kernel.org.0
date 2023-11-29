Return-Path: <kvm+bounces-2795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3287FE15E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 21:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB3192821E1
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 20:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5487B60EFF;
	Wed, 29 Nov 2023 20:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KJRHbMaa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A466010D1
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 12:50:43 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c9b7bd6fffso3314341fa.3
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 12:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701291042; x=1701895842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SRIF0HwWnMcIde9FIOMMN3+/mbfqwhuX49V+gQ6VB9c=;
        b=KJRHbMaaJqcJTNcH8Wn6R6sEJxilH1s01Uc25vRwqD4L4TlBG2syP72K5dxkaVMv9s
         KQb+aa8Gm6JxXkmmr+LAq6PpeNTO/exJDvYK55Xz8iEa5TXMlxlMyBeD7P61rJr79uH0
         RkexLMNHE2VjTWlutEh/Y+8v6gzTPx/p1qgUoVu2RBHMeFZI16BkEYTDqL687Se18nCz
         ImnSHiCALiwrpkPpcvQEKqh1qjDu3nmpeP/4fCLKLtMtRMtC6B7tS6JHAVkL/RuQsssK
         7jyF7rurTBCeWIf6NrgYJRJFAg4S+uDDcLSS+gKsHG03NreyMFEo/FgIum2Rc3zhnajQ
         Mz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701291042; x=1701895842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SRIF0HwWnMcIde9FIOMMN3+/mbfqwhuX49V+gQ6VB9c=;
        b=Fs8iKVp+xCKj8Rvinee66dwrzuFWYE76N/b0uVTaPsA1ycCsXvNlpCrdt9AP6zE2m2
         pV4KvNSp8keklPXoCE2qykP7W4K00ds93hfmj/Fl881IE/ru2ouiiPk72LgdKDZNXx+M
         qFHRgW4BOE+7uBT0ZyuckOgeoNeWBkn1hJtjvXI04hSSC7egyZ2qNada+EuKAz1q/FWf
         KJB/LqPvdG007Aagl4PULnXdkHyC4WstO2N9v6YrOkKIiPP0uErZBwkmISl+NhV/VMU3
         Y7/+hbcoEFot8W2nQTiB4LFIg0mXWCPVmFp3IpNU8TJDwYkfkn/eSipfLG8DA7Ul7RVd
         XtJA==
X-Gm-Message-State: AOJu0YzaW6Gc0+ItKIp6bHNkzb49d5mZy/wiW19r5oUAMxMbWaDczQoQ
	YxIS50x12r0+233soCZ/ox/6iw==
X-Google-Smtp-Source: AGHT+IHvUUbkS8uQp7Mq/MO3uA81NKO6ABeKVWmmledI3OMctsyW8mvoi+BWILmqRXm+0/Dlg0QC1Q==
X-Received: by 2002:a2e:b1c7:0:b0:2c9:c3a2:c89b with SMTP id e7-20020a2eb1c7000000b002c9c3a2c89bmr1154586lja.45.1701291041715;
        Wed, 29 Nov 2023 12:50:41 -0800 (PST)
Received: from m1x-phil.lan (sal63-h02-176-184-16-250.dsl.sta.abo.bbox.fr. [176.184.16.250])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c4f0f00b0040b33222a39sm3398847wmq.45.2023.11.29.12.50.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Nov 2023 12:50:41 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH] accel: Do not set CPUState::can_do_io in non-TCG accels
Date: Wed, 29 Nov 2023 21:50:37 +0100
Message-ID: <20231129205037.16849-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

'can_do_io' is specific to TCG. Having it set in non-TCG
code is confusing, so remove it from QTest / HVF / KVM.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/dummy-cpus.c        | 1 -
 accel/hvf/hvf-accel-ops.c | 1 -
 accel/kvm/kvm-accel-ops.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
index b75c919ac3..1005ec6f56 100644
--- a/accel/dummy-cpus.c
+++ b/accel/dummy-cpus.c
@@ -27,7 +27,6 @@ static void *dummy_cpu_thread_fn(void *arg)
     qemu_mutex_lock_iothread();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
     current_cpu = cpu;
 
 #ifndef _WIN32
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index abe7adf7ee..2bba54cf70 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -428,7 +428,6 @@ static void *hvf_cpu_thread_fn(void *arg)
     qemu_thread_get_self(cpu->thread);
 
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
     current_cpu = cpu;
 
     hvf_init_vcpu(cpu);
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 6195150a0b..f273f415db 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -36,7 +36,6 @@ static void *kvm_vcpu_thread_fn(void *arg)
     qemu_mutex_lock_iothread();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
     current_cpu = cpu;
 
     r = kvm_init_vcpu(cpu, &error_fatal);
-- 
2.41.0


