Return-Path: <kvm+bounces-690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A347E1F59
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E98DA1C20BAB
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6678D1EB37;
	Mon,  6 Nov 2023 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WB8BvWTV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83321EB2B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:06:08 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BA698
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:06:07 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-40839652b97so32709365e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268766; x=1699873566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R87QIdTSbuBFqtOuBBqCdN1J8XfSkpLJYhBFwzXT2iA=;
        b=WB8BvWTVjbblMFHonJ5b+mqiY2CdZBOG48306okf57aSMtiYfazOtZxTj9ijt0twjC
         3SdGEj10wS84v8Ras1JBjlsp9kT260OK2tgXsE4GlRjshT+iCVHSwzRwLyjtPPzEiRgq
         iExstb9hpuwQPyDB8s+4ecbtaYT8HRcuBz/SND0CyRJmj21rRMFzfWVhmoXD+Y9qCsGU
         V6kasAxfmhQNU+aLz13RVywpoxxNW21kMLjPiUo0Rj7AR6nC7Isx1hc8vSzk/03jT/mj
         H6zWZQ8EYBZRw53OFoxUhE9ESshX987u1Zgq85EHyJl+mEeT6TLvG2ZViQyN223iVsfP
         pHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268766; x=1699873566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R87QIdTSbuBFqtOuBBqCdN1J8XfSkpLJYhBFwzXT2iA=;
        b=b1mx4YNBrJzGKokz1DBglby4iJZCAtac9nwYuyxtyxQ4F3y8zlDATumOENOL/bDa2+
         kaO8u1CvrJGXA8zKr1nlrgOWCfFaQPkQs2VOGiMmllzBI0z9YX3D6Zxkum0tn18IK3jQ
         B+E6hz0aAnEu4bCJadUIavule25kVtZKkd/DfUy53IrR4Y1oZ6n5jQA91bEEO2O02xbD
         UJcoeah60NaQVKzBkRah3h2Bw7oK0saTNETFfFVkofDl4n0d8k0N5/2me/8KjIKjZ6+7
         zsWNZJsuo+qWAewkIQW272kNjQ+bMVOCv5XA+c1Jdx/dAu+rRZ6XcqtWc6r8e5aXXXP1
         D0MQ==
X-Gm-Message-State: AOJu0YyiVD6aCEwLVAeMhvhDdVzDUmRGMFf6WNH+cEWYc598cXxvhg6S
	mNxcD1Vr/7IhRDZsGsXhx8SOHA==
X-Google-Smtp-Source: AGHT+IEAb7mlXjiV+t8xOiAWlZzqIbRP1ddqvYwThww0DxTtH+DpaAZtlEj/6Pj1UY+lnDvwGergOA==
X-Received: by 2002:a05:600c:3148:b0:405:1c19:b747 with SMTP id h8-20020a05600c314800b004051c19b747mr24127659wmo.15.1699268765817;
        Mon, 06 Nov 2023 03:06:05 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id i20-20020a05600c355400b0040839fcb217sm11896421wmq.8.2023.11.06.03.06.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:06:05 -0800 (PST)
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
	Alistair Francis <alistair.francis@wdc.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PULL 21/60] target/s390x: Use env_archcpu() in handle_diag_308()
Date: Mon,  6 Nov 2023 12:02:53 +0100
Message-ID: <20231106110336.358-22-philmd@linaro.org>
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

When CPUArchState* is available (here CPUS390XState*), we
can use the fast env_archcpu() macro to get ArchCPU* (here
S390CPU*). The QOM cast S390_CPU() macro will be slower when
building with --enable-qom-cast-debug.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Acked-by: Alistair Francis <alistair.francis@wdc.com>
Message-Id: <20231009110239.66778-4-philmd@linaro.org>
---
 target/s390x/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/s390x/diag.c b/target/s390x/diag.c
index 8ce18e08f3..27ffd48576 100644
--- a/target/s390x/diag.c
+++ b/target/s390x/diag.c
@@ -77,7 +77,7 @@ void handle_diag_308(CPUS390XState *env, uint64_t r1, uint64_t r3, uintptr_t ra)
 {
     bool valid;
     CPUState *cs = env_cpu(env);
-    S390CPU *cpu = S390_CPU(cs);
+    S390CPU *cpu = env_archcpu(env);
     uint64_t addr =  env->regs[r1];
     uint64_t subcode = env->regs[r3];
     IplParameterBlock *iplb;
-- 
2.41.0


