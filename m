Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1002A2E13
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgKBPUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 10:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgKBPUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 10:20:48 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5822C0617A6
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 07:20:46 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w14so15036659wrs.9
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 07:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zsoLpTPvbfDjEd3BTKWBJg3n1+l4gj6JVB0+8bMwSMU=;
        b=HmtPp910xThA01pL3B9QJDzM6myxOQbI+Gxv1vc6oac7iOA0ZXJQlHuq/+mHtde0X+
         OfcMSK5kznkjMW2e37tU9WeWtUF/ehvgMx77Hvy2j/YhuAWr2JWWTq+2rF5jNonVIGbD
         cCSqCJ03TKw0ntRupzKEmRuIb7vqNrbM7ZjMJ1dyUUTFAq7QYOcoPlQY6BSvbU5ivx1u
         2ja7v3leUJx7kGjq4+D8hYbHBwnlqSZkHzw7OQggIsENJu2wboHE39wVaYvHlfopqTaz
         gmSuc/NRG00fKNAAatDeqOG57nb8eBHuWtuyK6Mk/YJvrj1Yz6MBIwM8xHmW9fbnRR1V
         p5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsoLpTPvbfDjEd3BTKWBJg3n1+l4gj6JVB0+8bMwSMU=;
        b=FLZ0h4giQM9lA5K1X7v3HFpgEsNW9wQ7TcQYBUZQli9B4+DYf5ejnwkF7wBmv5FY/Y
         PdnwYNdldPEroaVKrZXyMPW5yJWhnO7g+HsLY9lxtH5Wb21oUGAL80RQlNoxZjDb7VWu
         r4F3mTpl8EYaaYM8kze29bZK684+fHRcOlgbifxBLP6k0Z331x2+nWD2S/nZ9MgEIQki
         HOltvq8lEhoyRlD74otekxLo6/nlnurv2zvad12nmiYtoJKYj7yr1d7e0yHaQppgPSFE
         P7rjwOuHe1RlkH0ClthqMnRC/uGzDjdRLPRa1mnrtERqu99dsLTEgTfDGBWeyO1OItHX
         wuvA==
X-Gm-Message-State: AOAM533QvZ/MSuqHgxDR7pXlH334EH3bqms86SIdeG61Y1TLDZiMOt5l
        V0Asv9bvwCXU6UQNAW/eknUDYA==
X-Google-Smtp-Source: ABdhPJwlFwfWfCpdDsl2PScT66d3xFr7tIJPKogPvk6kP2iU+Xbqm7qx9Peryv+18kqHISpx03BO0g==
X-Received: by 2002:adf:f3c4:: with SMTP id g4mr22117429wrp.207.1604330445459;
        Mon, 02 Nov 2020 07:20:45 -0800 (PST)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id b18sm15138014wmj.41.2020.11.02.07.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 07:20:44 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v2 2/8] ALSA: pcm: use krealloc_array()
Date:   Mon,  2 Nov 2020 16:20:31 +0100
Message-Id: <20201102152037.963-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201102152037.963-1-brgl@bgdev.pl>
References: <20201102152037.963-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/pcm_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index d531e1bc2b81..c6f8f9e252e0 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1129,8 +1129,8 @@ int snd_pcm_hw_rule_add(struct snd_pcm_runtime *runtime, unsigned int cond,
 	if (constrs->rules_num >= constrs->rules_all) {
 		struct snd_pcm_hw_rule *new;
 		unsigned int new_rules = constrs->rules_all + 16;
-		new = krealloc(constrs->rules, new_rules * sizeof(*c),
-			       GFP_KERNEL);
+		new = krealloc_array(constrs->rules, new_rules,
+				     sizeof(*c), GFP_KERNEL);
 		if (!new) {
 			va_end(args);
 			return -ENOMEM;
-- 
2.29.1

