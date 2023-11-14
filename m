Return-Path: <kvm+bounces-1669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B7F7EB297
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84DD1C20B09
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C4A4175A;
	Tue, 14 Nov 2023 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K7b1OCsa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCB04174E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:40:11 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE561BE
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:10 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9be02fcf268so853489766b.3
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972808; x=1700577608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAcrCtDRFE27SgAEHRwd23jK5KSLpjZ+znXdyGAiZas=;
        b=K7b1OCsaQXPdOfk3pYBZtqd1sPvaWvF0D8VS8CHocI1GYIeBo4Vwdxvwd3rYoD3+Yq
         4pbW7ttPnwDogpK++YjagpiNSNHXi3gbjktM8KT1vYYJMfqou2UPypWs/JtJZoxRUB/O
         aZahISvvg7h3loIpUwhSddZr1g6bP4EiT/K9mvWPidVeL4T5hFlyAgrRBFxpYRDyD9UT
         tn139J2mn39C9i2qLhZzeIP5c09QGGYgmixddtPNoBpjhNExaYZyL5kW4oKHieCbQyms
         mykM56l6P8Fl1GhUTHs4gzVftfK00bzYugamWebS2+dzwLlqufkNlHKoOsBrpiaCtiB5
         sZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972808; x=1700577608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAcrCtDRFE27SgAEHRwd23jK5KSLpjZ+znXdyGAiZas=;
        b=gugQSZv6794xpibtaYUarj25cQQ9A9DKOuuOPZ4Urv09oRVSvex7TUeNYT8rJG4XGn
         SyGCSjttRUKk86yESeDfp5Nw6gRYQcN6EOs9lyWlAKMnX4TwRGjNw7ahASZ17jCZvnJf
         yN0DJKOUxwyJe/DYyfVmViJk2Z6WA6uqPsHquxIICmVwf/vBYAPtAGZr9ixUrrNIr1gJ
         IQH+bsMWo7+QedtdaKmpWPfYMNdRCJwdTXJp+kqbIKDT/Ei9yO6LwiKJj8VdOSPL/Acr
         RnaWvdvYQid6x6/LeYRdyMebPt0dUZGlMAoYWAj3yNvgYjypz5yG10V2P9XhsePsFC88
         o16g==
X-Gm-Message-State: AOJu0YxFkkMMu/QUHtjjxalRNjtFSQo8PHvxin2gRwxFGWBNXWOogo3X
	f64C1NqsUURnA2hwuN9P+2NXyA==
X-Google-Smtp-Source: AGHT+IFRbdN3aM58BgezwVky3EFK69MoaorjbUe4txfqvi/Mr07fntHT95KnMqBlE8Dz9TGy0ZX5tw==
X-Received: by 2002:a17:907:9848:b0:9dd:5adc:b1d2 with SMTP id jj8-20020a170907984800b009dd5adcb1d2mr6678484ejc.38.1699972808614;
        Tue, 14 Nov 2023 06:40:08 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id y10-20020a1709064b0a00b009dd7bc622fbsm5606206eju.113.2023.11.14.06.40.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:40:08 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 v2 16/19] hw/xen/xen_pt: Add missing license
Date: Tue, 14 Nov 2023 15:38:12 +0100
Message-ID: <20231114143816.71079-17-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit eaab4d60d3 ("Introduce Xen PCI Passthrough, qdevice")
introduced both xen_pt.[ch], but only added the license to
xen_pt.c. Use the same license for xen_pt.h.

Suggested-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/xen/xen_pt.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/xen/xen_pt.h b/hw/xen/xen_pt.h
index 31bcfdf705..d3180bb134 100644
--- a/hw/xen/xen_pt.h
+++ b/hw/xen/xen_pt.h
@@ -1,3 +1,13 @@
+/*
+ * Copyright (c) 2007, Neocleus Corporation.
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ * SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Alex Novik <alex@neocleus.com>
+ * Allen Kay <allen.m.kay@intel.com>
+ * Guy Zana <guy@neocleus.com>
+ */
 #ifndef XEN_PT_H
 #define XEN_PT_H
 
-- 
2.41.0


