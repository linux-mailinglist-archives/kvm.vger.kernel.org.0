Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502BA2A2E12
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgKBPUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 10:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgKBPUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 10:20:46 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD021C061A48
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 07:20:44 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id e2so9869796wme.1
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 07:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//ohTnlCNdzVCN7+X/oV4S8f/hxX7VdQ1OV3L6uwfhQ=;
        b=hf6tvqncwp3fkOIckHP3XNhZspBIs+DJCE72k4fKwWNNEV8tVYATPrk61RVN2LLtoy
         wyuT8kZJhciWHJYnIywhLp+tPKS38UhRZoDdJRNvydyfnF4jPWOOLNFaCIa5fWpPbqiE
         CPEcfMQCT8yeENUO+TRhPv8NZwnqBa/5qBgOFPacWV7BhHFuUJ5ASnX9vmHxuqU/2Ygy
         yl+QCczTs9fSAAWT/g0PiS+PxK7jWNW2R3D8R0j5FcPe+c2M0+55tW8i3tKhxnOrTffM
         d3zN4lSBg/UxZjb51Fwl4foaEs43EhxOe1ue2FxQvf65j62JS7V+E/ior/FALPI70AY8
         3BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//ohTnlCNdzVCN7+X/oV4S8f/hxX7VdQ1OV3L6uwfhQ=;
        b=kCw5AwzAdtSxxsp3Ve24r61gF8jnOJfNSNJhb9t2sENg1/06nxMONLrhYDlu3nNGaP
         mKxoBf8i0QuGtv34zBK115WFITdjUjq/kxbkTVz99owjLRMcH7qYjCz7EaVZWN9Z2Ni+
         GHeX+TuwM1ICfETtTyAGPG2PWd/xloLPHSX2g/6hwufXIBPlV/kjn8emdc2hp9g/t4Ad
         Pr/jma/iwxVPgO0DgWViU5vt1VdbtgGJmuF8LT28/2aUpTY/Y1VxE962TkMb9B9879V8
         ZVqJmYl6frgCrONRHNd0YAD/+k4o7dMgL4rR06Vdz2xVnokH8v7wWqLFxDNaBlKjEUCr
         8veA==
X-Gm-Message-State: AOAM5319UoZrV1K9c2SGKXtgPACHLNfdDDzUlaG6yALV5mU2uiTa/VY3
        vNjQZp+fJJVbEvoPz4cA1559Bw==
X-Google-Smtp-Source: ABdhPJxGlAsjxjuqTsCnImH4txzUDEh+1CeV9f1Ji5E5b7hmF0/rUwH1lj/uHarBz/RRB7bv+TJwGA==
X-Received: by 2002:a7b:cf25:: with SMTP id m5mr18034156wmg.124.1604330443460;
        Mon, 02 Nov 2020 07:20:43 -0800 (PST)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id b18sm15138014wmj.41.2020.11.02.07.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 07:20:42 -0800 (PST)
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
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 1/8] mm: slab: provide krealloc_array()
Date:   Mon,  2 Nov 2020 16:20:30 +0100
Message-Id: <20201102152037.963-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201102152037.963-1-brgl@bgdev.pl>
References: <20201102152037.963-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

When allocating an array of elements, users should check for
multiplication overflow or preferably use one of the provided helpers
like: kmalloc_array().

There's no krealloc_array() counterpart but there are many users who use
regular krealloc() to reallocate arrays. Let's provide an actual
krealloc_array() implementation.

While at it: add some documentation regarding krealloc.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 Documentation/core-api/memory-allocation.rst |  4 ++++
 include/linux/slab.h                         | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 4446a1ac36cc..6dc38b40439a 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -147,6 +147,10 @@ The address of a chunk allocated with `kmalloc` is aligned to at least
 ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
 alignment is also guaranteed to be at least the respective size.
 
+Chunks allocated with `kmalloc` can be resized with `krealloc`. Similarly
+to `kmalloc_array`: a helper for resising arrays is provided in the form of
+`krealloc_array`.
+
 For large allocations you can use vmalloc() and vzalloc(), or directly
 request pages from the page allocator. The memory allocated by `vmalloc`
 and related functions is not physically contiguous.
diff --git a/include/linux/slab.h b/include/linux/slab.h
index dd6897f62010..be4ba5867ac5 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -592,6 +592,24 @@ static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 	return __kmalloc(bytes, flags);
 }
 
+/**
+ * krealloc_array - reallocate memory for an array.
+ * @p: pointer to the memory chunk to reallocate
+ * @new_n: new number of elements to alloc
+ * @new_size: new size of a single member of the array
+ * @flags: the type of memory to allocate (see kmalloc)
+ */
+static __must_check inline void *
+krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
+		return NULL;
+
+	return krealloc(p, bytes, flags);
+}
+
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
  * @n: number of elements.
-- 
2.29.1

