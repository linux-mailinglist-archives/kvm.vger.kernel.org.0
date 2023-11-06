Return-Path: <kvm+bounces-692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E517E1F5B
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F353281557
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5CC1EB35;
	Mon,  6 Nov 2023 11:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eUm5LyCN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72DA1EB29
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:06:24 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE95D6F
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:06:21 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-408002b5b9fso32364755e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268779; x=1699873579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JKKmt1EY/kf3nircSCgd4NoTIWcG19r0u1T6OQDS20=;
        b=eUm5LyCNRxVPPiU2LziOuhXPudnk3Oi1pkWbCTIF27q9oU6qxXl9Ai/F6pL7iMzfjW
         hAIp1mqlTkdHkLxG7ba2IV5mr+prZEXmdMRSeBS6D9D2vBC3EBW6v8l8YPWa6C2PI6n4
         0w2zBzkzEkVb0QHsw4Xn4KMLHKVbq+zE9w8ANPmq44py8pPl0NsMuVOT5KmKxMY3Gkud
         uHcuJ7wAE7Gty640Yrb8Eu2i9uDy4jvIlXaBn4ywsDfRvMBddiX7fjMFbZkqLsXvEu+I
         c/Z/VR13ytV7KhpxhaTIg+SuqnRbeIaMzW7I2zZtDsNOwhkWYPz7iI6c9ZhQRteJY4Pw
         nc8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268779; x=1699873579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9JKKmt1EY/kf3nircSCgd4NoTIWcG19r0u1T6OQDS20=;
        b=MXTDJCrpuQ97SZ3vfmUQIReQm+dnSNwr0R+OB6MF/2L4jXdNWG5ewrXnp2i/Hb2EGM
         +9ThdaeJhD7SAVjZDBj3brQp5DYD8SH4lN64UNHb7+0U1Zvg+iNpXxe5pjHdORk5C9ob
         KgM4BhxL5Vzyl6HZdXh7Ek8LZu4McAgH4UW78SlpiXjYd0I3X1on1/OSk/mJSvHhAWPK
         XPRCKgLkibO/59OsKzPMniAlUQlVkpMQjQU3GCJPOCAL+vz8o0iGRFnw9jw6WviaqXg4
         aVGK0XWV610/eLZXIQgqJ87dcbiEBEEluGa4cL5yYA+FKDjItyP77YJJq/0q4fOqbw/5
         URNA==
X-Gm-Message-State: AOJu0YxgEZH39Cz1+1tuiLpOd/Gy+Ha344eHorO1kC94R1NGI3Dqr5hT
	O4wjULQYPoD4Uv2YS2OpiURHJw==
X-Google-Smtp-Source: AGHT+IEfybZ7H2Z3J3gHYnthxWPdDRlfQr2CrB6JP1W6Rr4GrrWr88wGlPvt7oAiYP8kPnl41aGPqw==
X-Received: by 2002:a05:600c:1913:b0:409:351:873d with SMTP id j19-20020a05600c191300b004090351873dmr24821001wmq.31.1699268779697;
        Mon, 06 Nov 2023 03:06:19 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id e22-20020a05600c109600b0040523bef620sm5449491wmd.0.2023.11.06.03.06.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:06:19 -0800 (PST)
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
	Roman Bolshakov <roman@roolebo.dev>,
	Zhao Liu <zhao1.liu@intel.com>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PULL 23/60] target/i386/hvf: Use x86_cpu in simulate_[rdmsr|wrmsr]()
Date: Mon,  6 Nov 2023 12:02:55 +0100
Message-ID: <20231106110336.358-24-philmd@linaro.org>
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

We already have 'x86_cpu = X86_CPU(cpu)'. Use the variable
instead of doing another QOM cast with X86_CPU().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Roman Bolshakov <roman@roolebo.dev>
Tested-by: Roman Bolshakov <roman@roolebo.dev>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Message-Id: <20231009110239.66778-6-philmd@linaro.org>
---
 target/i386/hvf/x86_emu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
index ccda568478..af1f205ecf 100644
--- a/target/i386/hvf/x86_emu.c
+++ b/target/i386/hvf/x86_emu.c
@@ -676,7 +676,7 @@ void simulate_rdmsr(struct CPUState *cpu)
         val = rdtscp() + rvmcs(cpu->accel->fd, VMCS_TSC_OFFSET);
         break;
     case MSR_IA32_APICBASE:
-        val = cpu_get_apic_base(X86_CPU(cpu)->apic_state);
+        val = cpu_get_apic_base(x86_cpu->apic_state);
         break;
     case MSR_IA32_UCODE_REV:
         val = x86_cpu->ucode_rev;
@@ -776,7 +776,7 @@ void simulate_wrmsr(struct CPUState *cpu)
     case MSR_IA32_TSC:
         break;
     case MSR_IA32_APICBASE:
-        cpu_set_apic_base(X86_CPU(cpu)->apic_state, data);
+        cpu_set_apic_base(x86_cpu->apic_state, data);
         break;
     case MSR_FSBASE:
         wvmcs(cpu->accel->fd, VMCS_GUEST_FS_BASE, data);
-- 
2.41.0


