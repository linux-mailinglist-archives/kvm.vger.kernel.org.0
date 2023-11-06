Return-Path: <kvm+bounces-689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CEF07E1F57
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:06:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1AE6B21B5D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D07D1EB34;
	Mon,  6 Nov 2023 11:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WBE0801e"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDE91EB2B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:06:02 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70160BB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:06:00 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-40850b244beso33448265e9.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268759; x=1699873559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdevyuV5vDNMMgKGndHL1Lb3pKI2mM3BGOnKiVXcZMA=;
        b=WBE0801e4XnuSIlK6JsYwl4jQIIH5PUy/D4CUwckJKbnX+5qROFaBLXMVFpCqynx9T
         RV9MZ/8hKv3MRHtPHzCe9kE1rBIaSR41OqZSf7dn7Za2pE5+6GTeDn3QYa/fmnw05aPJ
         h9Actf+0F50QmQ1It/6fi9Rn2YRjx85vgP+8aQ/+pG5GXnzFqZ4i1Tv+ixVFm5cocVqx
         ROZE38bDnd6hMGva2L5vpo0JaeTSPJhevV8BacMn7Yc/0RAXg0BO9KV6jLb28NYPQLFJ
         sYZsnc+9yP2lTSibuvyzoN9U12QCmh+zSfd4L47pRUdIotT52jn3Sc/9u30gUVGpPotP
         Ib7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268759; x=1699873559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdevyuV5vDNMMgKGndHL1Lb3pKI2mM3BGOnKiVXcZMA=;
        b=pefOmXRuD4nKxotAIQR2DVpUBJCYfewDSGyJ4Kk8cDuZSCeadumI0/VfhB2BN7iM0k
         FEGjgE60S4wdVJufkti99IONu0XhcD7rC5EqkaHvHA52U4Xq/RAXj2UxtM+4WBOx85bT
         IXhwZEXwSgNFBx/tm/oZ42WWSDvHeu+fJrJeM9994l0IVpWf9Z3uPaY2C/m2JGUXIcCC
         QXoC5ESg08feqTNBFxzzhnl41OfgtA9GPPvRO+H9P8Mpz7f3pzajyAs/STTaMAERRDk5
         cLQYMl7F2x5fykxgl+V4vZSK62++ntjZDBvCxWMN4V09KMT9L6JsxXfOUCoT3zapX+VS
         cHhA==
X-Gm-Message-State: AOJu0YygL0kHB7Z/+p0B7ZhjrPnHoR/f0eaBqtB0IZkmRTZg6dUrmp+B
	BFaOYMfDuye7NUenVeURRZ1fwg==
X-Google-Smtp-Source: AGHT+IHx5XXxhtGZu6ZCbciI1JQ5kvGzt8XZDokYAdmWLiQ+Wf2MWQYdjQaCgeHE7cevbJyqEkuPhw==
X-Received: by 2002:a05:600c:1c9a:b0:401:d803:6243 with SMTP id k26-20020a05600c1c9a00b00401d8036243mr25577656wms.32.1699268759004;
        Mon, 06 Nov 2023 03:05:59 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id r13-20020a05600c458d00b00406443c8b4fsm11744176wmo.19.2023.11.06.03.05.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:58 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Richard W . M . Jones" <rjones@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	LIU Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liweiwei@iscas.ac.cn>
Subject: [PULL 20/60] target/riscv: Use env_archcpu() in [check_]nanbox()
Date: Mon,  6 Nov 2023 12:02:52 +0100
Message-ID: <20231106110336.358-21-philmd@linaro.org>
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

When CPUArchState* is available (here CPURISCVState*), we
can use the fast env_archcpu() macro to get ArchCPU* (here
RISCVCPU*). The QOM cast RISCV_CPU() macro will be slower
when building with --enable-qom-cast-debug.

Inspired-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Reviewed-by: LIU Zhiwei <zhiwei_liu@linux.alibaba.com>
Reviewed-by: Richard W.M. Jones <rjones@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Message-Id: <20231009110239.66778-3-philmd@linaro.org>
---
 target/riscv/internals.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/riscv/internals.h b/target/riscv/internals.h
index b5f823c7ec..8239ae83cc 100644
--- a/target/riscv/internals.h
+++ b/target/riscv/internals.h
@@ -87,7 +87,7 @@ enum {
 static inline uint64_t nanbox_s(CPURISCVState *env, float32 f)
 {
     /* the value is sign-extended instead of NaN-boxing for zfinx */
-    if (RISCV_CPU(env_cpu(env))->cfg.ext_zfinx) {
+    if (env_archcpu(env)->cfg.ext_zfinx) {
         return (int32_t)f;
     } else {
         return f | MAKE_64BIT_MASK(32, 32);
@@ -97,7 +97,7 @@ static inline uint64_t nanbox_s(CPURISCVState *env, float32 f)
 static inline float32 check_nanbox_s(CPURISCVState *env, uint64_t f)
 {
     /* Disable NaN-boxing check when enable zfinx */
-    if (RISCV_CPU(env_cpu(env))->cfg.ext_zfinx) {
+    if (env_archcpu(env)->cfg.ext_zfinx) {
         return (uint32_t)f;
     }
 
@@ -113,7 +113,7 @@ static inline float32 check_nanbox_s(CPURISCVState *env, uint64_t f)
 static inline uint64_t nanbox_h(CPURISCVState *env, float16 f)
 {
     /* the value is sign-extended instead of NaN-boxing for zfinx */
-    if (RISCV_CPU(env_cpu(env))->cfg.ext_zfinx) {
+    if (env_archcpu(env)->cfg.ext_zfinx) {
         return (int16_t)f;
     } else {
         return f | MAKE_64BIT_MASK(16, 48);
@@ -123,7 +123,7 @@ static inline uint64_t nanbox_h(CPURISCVState *env, float16 f)
 static inline float16 check_nanbox_h(CPURISCVState *env, uint64_t f)
 {
     /* Disable nanbox check when enable zfinx */
-    if (RISCV_CPU(env_cpu(env))->cfg.ext_zfinx) {
+    if (env_archcpu(env)->cfg.ext_zfinx) {
         return (uint16_t)f;
     }
 
-- 
2.41.0


