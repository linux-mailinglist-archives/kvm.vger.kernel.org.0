Return-Path: <kvm+bounces-697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6789B7E1F71
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08B23B21905
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505EE1C6A3;
	Mon,  6 Nov 2023 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bTpmU5ZL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25311A737
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:06:55 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329D1D8
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:06:54 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2c50305c5c4so62262801fa.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268812; x=1699873612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6pej+XFgeNy8hwy7UMk7tmyBIA+j/BAJUFV7Aiq4os=;
        b=bTpmU5ZLc5ri5Q00b6T1J30V3JDJV2sLvqLDS120vyRgZ5/4lzOlm/tiFzU8Wxv7u6
         +dVzAQ6kZ/wBEhSV8FWG/BUV0T9goeLvYkWqpon68Mrxy8k012UeZY/3pS4n2qbe7Fzd
         Y7h4h0Chm4Vg64Aw/V7ETaBUKwZfW4aWMFVOW/YcSZEqdrbghgzDUHbXdwoLB862iTUT
         KnndFYXJMma6JpVZGcZXM1p/x05CB/oxiciJCyEtXo0F3wa0jyEKeW2c9u7F3isVysBL
         eVoh4pzzmcAJdgVcjNgrY8RgzCpB84py51Ox7XsBnOndBzX6toNy12FvUfxcWIF0JLgb
         Zdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268812; x=1699873612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+6pej+XFgeNy8hwy7UMk7tmyBIA+j/BAJUFV7Aiq4os=;
        b=HudCeijGqy2vvL8JK4yCiKXKU5NKa7Td4eGF/zKqWs5lP2KAZ6fzinYDFbpFILWhF9
         6zUIPFvf5Gt/VW2oNkpdDYvgR4QE8cHXR6Y/cRfHDhxZ7AsO9mw1uwe92uTnA313E+5O
         3p+LDcvL7lArC7lzaDUWOz0sQH9z+BesUm8HU/V78tNwvqbgRkNndbLujp7EACvb7E2t
         m7uUwK9mBDSp0EWMe9PZ50LnNyXMTpi4uFh/smW59hMN1X3oQuwiFtmNalOd7I3MnEKW
         v7HNoo5UxcTZ0+ArXlm+DIn3XdYYVSQCLCRfqA2KyornY1DgvxlsaIkNWRHWYSk4xfW2
         /0yQ==
X-Gm-Message-State: AOJu0YxWJCw7Ie6+n6OSfv2y//OlwfrSFmDi+mZU9NwxhgbBmhEltjOM
	0MmGauFapLVH4WL9qka+aFPEKw==
X-Google-Smtp-Source: AGHT+IH9cDYwLDc1MRsfDAEGSPwPoLCFIf+s8baeSOuvBOTKWXUgUmhGOWDpYJxS4pQKbqZtqaKfYw==
X-Received: by 2002:a05:651c:200c:b0:2c5:2d7:412 with SMTP id s12-20020a05651c200c00b002c502d70412mr18916048ljo.19.1699268812592;
        Mon, 06 Nov 2023 03:06:52 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c459000b003fefaf299b6sm11914693wmo.38.2023.11.06.03.06.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:06:52 -0800 (PST)
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
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PULL 28/60] target/i386/kvm: Correct comment in kvm_cpu_realize()
Date: Mon,  6 Nov 2023 12:03:00 +0100
Message-ID: <20231106110336.358-29-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230918160257.30127-4-philmd@linaro.org>
---
 target/i386/kvm/kvm-cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 56c72f3c45..9c791b7b05 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -37,6 +37,7 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
      *  -> cpu_exec_realizefn():
      *            -> accel_cpu_common_realize()
      *               kvm_cpu_realizefn() -> host_cpu_realizefn()
+     *  -> cpu_common_realizefn()
      *  -> check/update ucode_rev, phys_bits, mwait
      */
     if (cpu->max_features) {
-- 
2.41.0


