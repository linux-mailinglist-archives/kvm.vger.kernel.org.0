Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83D329ABB9
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 13:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750978AbgJ0MSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 08:18:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38889 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899705AbgJ0MRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 08:17:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id n18so1655856wrs.5
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 05:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ajG2eJaPSZ0bX/1WDeWm0EaqfEJqxAhsr1ZG8pJATY=;
        b=XHOIZDPFdLQqYweDS35MDqPOY+CIlpJefK0zBWfY0YBTimhWcawEQs8dTrakE90RO7
         AfsytdKycv6sjHXN2trxR/+eOiuM7wcXVt5IB8qtwwAQMxE4BkNW/+a/GHnw+CWx2wsB
         hGq7TZ6iovNwqijODvBmZWQde1pIjIB5HPsJl/6X5swnxCmi/14lryrQsGpQHt5jA5cY
         IH9hXgKEdIPUw1YcA/W+R9L29LSTdk7ImHzGZaTNpbL+xJ2ChLwLclaOJCS3Z4u/Bf9u
         JVbkgQtqzawUBytpFhmYgsiop5B0mx4A7abqvzrfSU90qALU5F3Ra0TXyhHJ+ZhCt7b5
         VUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ajG2eJaPSZ0bX/1WDeWm0EaqfEJqxAhsr1ZG8pJATY=;
        b=Gyh5E79Ku33F8i3XeQMbFcQ3eOMEbpCnYIHTO2TQCSXJ7wyCp5HOkOs3+W/BT97RU5
         y2ve28iFd64SCeZ8j6QjhRstLxM8vRgCqpAWq6aVHlBnzce5UxOksdTMLN8JXVeXC9I8
         Oec/UMl/FiCIbeXHhviWHn75qGYdSaaKfxsA1r5HTK8FiEa//wOyjXh+fMO+xVlZ+ceB
         RjWt5XgvZ5g8AZYxjyQyFnMhKqU+e1r/NNyfcs66LaKUW2zDJ69IkRkD6G+mv1Ar+Qyv
         5N9Ks8f2Lw7mFdkm/JIr3DIHBIRaSTWzeBOnJP6p4mK++3LA5U9JKQnizc0N//AcetgX
         3k2Q==
X-Gm-Message-State: AOAM5314baA0xgeziS+E00AmQfFUwIVvo3OYwL4hbw5lKDozhQnCbfaa
        HFbJoeBLOcVAxW/zn9YBnRQ7lA==
X-Google-Smtp-Source: ABdhPJxi+QacVHd5+AE8Jqv2dW1ZUW5QhwXfI6u/s0dk/pyhkeRg2gSWT3PEaZdn2SLI49Q2m9AoSg==
X-Received: by 2002:a5d:4ac1:: with SMTP id y1mr2494500wrs.303.1603801068178;
        Tue, 27 Oct 2020 05:17:48 -0700 (PDT)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id a2sm1731908wrs.55.2020.10.27.05.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:17:47 -0700 (PDT)
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
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 6/8] drm: atomic: use krealloc_array()
Date:   Tue, 27 Oct 2020 13:17:23 +0100
Message-Id: <20201027121725.24660-7-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027121725.24660-1-brgl@bgdev.pl>
References: <20201027121725.24660-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpu/drm/drm_atomic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 58527f151984..09ad6a2ec17b 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -960,7 +960,8 @@ drm_atomic_get_connector_state(struct drm_atomic_state *state,
 		struct __drm_connnectors_state *c;
 		int alloc = max(index + 1, config->num_connector);
 
-		c = krealloc(state->connectors, alloc * sizeof(*state->connectors), GFP_KERNEL);
+		c = krealloc_array(state->connectors, alloc,
+				   sizeof(*state->connectors), GFP_KERNEL);
 		if (!c)
 			return ERR_PTR(-ENOMEM);
 
-- 
2.29.1

