Return-Path: <kvm+bounces-708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D507E1F80
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:08:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A2E9280D41
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0F718B15;
	Mon,  6 Nov 2023 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MC1qL/c1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FCF1864A
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:08:09 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345C8BB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:08:08 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507a62d4788so5742921e87.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268886; x=1699873686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIk2D2Zy+mW9KoNQEGhLCqqc6EXwTlAoiLD308KY354=;
        b=MC1qL/c1JmdA2KXSwgfHJKlCA7+0CjClNDrlzpwQSCtS3LwZxQvHhGlbwsPQoAvv5T
         Ke2Rv3m3G6W1HCszsuy078PCNSQcP2XQgb38kbywCev20nGWx2gij8c8aVTviThbKj7i
         h3llptGcshB5xHE8t8qgdUdOpHk36Q3c7CWuEwVB8dJvCZ9eSik15ZH/srOBPoFNgyqd
         zCIS87D4Y++AahEUkw6a9C8awyNp14AmrsvsUYP6h6cjV7vU0VUB+lR7u5YkBQH5f/hM
         E6lCzmsoXOFuTkRXshAWPsS8CbGhN0CeE19YYFCBW7rQamfWEbHbYHibmJCyn1f33Ma0
         2bbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268886; x=1699873686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HIk2D2Zy+mW9KoNQEGhLCqqc6EXwTlAoiLD308KY354=;
        b=N2UZOx9Jlu9/RJHw2+Io3XHwi7zp0OrrxJ/PWTYkvOgSy4Z2//ZpcPhk31sMfwNWmn
         a8NF5jZ/75bb+PAEn1q8KKYc90ls/jtMrKrJXgbKNdrKTsUyL0iy3id5iJP6uHm/wrX3
         8gpIC6gsVdNAv9oMfTHtf2vB+xtxn8csTQV7WCHfWYBTqejaD4gZa14yOFTl4RhErKR+
         MH87NIgV2fEHWVSCuub+6ULXR+AWQWNxl5NlJ21Z2tOFFTHAnZpSUgD4lWR04M9g0Z3c
         aOKTxOddcHdAhFIofpzvCxosbDnAVI86aeJwgKsJRgdiCW51aFuxcaAEK5fzKpFL8CZ2
         Nzfg==
X-Gm-Message-State: AOJu0YwitjABMVfNvunoIS1EtX0xyFb22YEMeG1W+S/0D5JFVHT0Ak6w
	135gQJb7nEFBDr5wJ990GQH3hg==
X-Google-Smtp-Source: AGHT+IHZzmpQpLISMOVN4u8fENAFmlJt/0w7I/6I45Xn+9+eLmWD1LIrIZlJ/g4SCbq5k1SLfQZs3Q==
X-Received: by 2002:a2e:7c15:0:b0:2c5:5926:de52 with SMTP id x21-20020a2e7c15000000b002c55926de52mr22771440ljc.53.1699268886360;
        Mon, 06 Nov 2023 03:08:06 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id a1-20020a05600c348100b003fe1fe56202sm12104665wmq.33.2023.11.06.03.08.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:08:06 -0800 (PST)
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
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>
Subject: [PULL 39/60] exec/cpu: Have cpu_exec_realize() return a boolean
Date: Mon,  6 Nov 2023 12:03:11 +0100
Message-ID: <20231106110336.358-40-philmd@linaro.org>
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

Following the example documented since commit e3fe3988d7 ("error:
Document Error API usage rules"), have cpu_exec_realizefn()
return a boolean indicating whether an error is set or not.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230918160257.30127-22-philmd@linaro.org>
---
 include/hw/core/cpu.h | 2 +-
 cpu-target.c          | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 5d6f8dca43..eb943efb8f 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1152,7 +1152,7 @@ G_NORETURN void cpu_abort(CPUState *cpu, const char *fmt, ...)
 /* $(top_srcdir)/cpu.c */
 void cpu_class_init_props(DeviceClass *dc);
 void cpu_exec_initfn(CPUState *cpu);
-void cpu_exec_realizefn(CPUState *cpu, Error **errp);
+bool cpu_exec_realizefn(CPUState *cpu, Error **errp);
 void cpu_exec_unrealizefn(CPUState *cpu);
 void cpu_exec_reset_hold(CPUState *cpu);
 
diff --git a/cpu-target.c b/cpu-target.c
index 79363ae370..f3e1ad8bcd 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -131,13 +131,13 @@ const VMStateDescription vmstate_cpu_common = {
 };
 #endif
 
-void cpu_exec_realizefn(CPUState *cpu, Error **errp)
+bool cpu_exec_realizefn(CPUState *cpu, Error **errp)
 {
     /* cache the cpu class for the hotpath */
     cpu->cc = CPU_GET_CLASS(cpu);
 
     if (!accel_cpu_common_realize(cpu, errp)) {
-        return;
+        return false;
     }
 
     /* Wait until cpu initialization complete before exposing cpu. */
@@ -159,6 +159,8 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
         vmstate_register(NULL, cpu->cpu_index, cpu->cc->sysemu_ops->legacy_vmsd, cpu);
     }
 #endif /* CONFIG_USER_ONLY */
+
+    return true;
 }
 
 void cpu_exec_unrealizefn(CPUState *cpu)
-- 
2.41.0


