Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607933754E1
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhEFNjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234072AbhEFNjG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/bdOhY3sBOcIHJeoCe6CkJ1QfZvAaT12hvfPxmFulM0=;
        b=diAk3LMOlfbES4tV7FjKNoalRYDIzxql+fuvw50YYXcjrxxjmW98+zMC6uRAF5HQrsAU7U
        X1MzwlvgmJLId0zYbCZutsDUbsq7JH3SjRoBb3iSDlRZljwSgcpEUpuuV/CUbXl3uJW9Ms
        gyNv0PZMEjVVs+XkW90LB4grNr5xT/4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-IUzylFh0Nz-lohi4v2qUBQ-1; Thu, 06 May 2021 09:38:06 -0400
X-MC-Unique: IUzylFh0Nz-lohi4v2qUBQ-1
Received: by mail-wr1-f72.google.com with SMTP id 93-20020adf80e60000b0290106fab45006so2205420wrl.20
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/bdOhY3sBOcIHJeoCe6CkJ1QfZvAaT12hvfPxmFulM0=;
        b=RZS87O7GzTn8lL39Rexk2UXU9L3yM0JrQox4X/F47tqa9mGpWAKajgqzoMX/sz75lj
         JjtO1cWZMAcm4BwxIKoiMjFKinDltJv+1I1tDjwhtGWNT7qBgmmGKMUwp0yYAMSqWALy
         6q6KCZcxzFuf9mQIWg0hLfm4azm2a5aJ1yJNWQqpRKahDywXBSfsksD8aqfubr0ZveQw
         j8LgpKNx3pkAfs4NSw9xJE/1e1rCV26B2XumD0+1SJerX/I/FmGy5r8LWtGrkFYrRyr3
         rGIQIxtW21eql/9Pr6AfJirmj+pTiGsRbVdtiQcLghZkhxrjeGCSZemTM27P7yMUw7gg
         OHvA==
X-Gm-Message-State: AOAM531h/HROpZ2bMr1Ci2LfzehQKstnBlsDpJd1wDIE3WU0WqqBSh+e
        j5rywdckh9o3TX6kV7V/3D4/eECEDprhUTILhEd8BGqx3NId+2iYe14Spq8ZGJZtb7QGuTa7x73
        FDyFM5Es+3hcV
X-Received: by 2002:a1c:1bc9:: with SMTP id b192mr15231214wmb.3.1620308285136;
        Thu, 06 May 2021 06:38:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaU39xWPKmAxzTDnRmk4BpB3yHtP51ZUdmNXUtU3rYDqeE9UGHa8wm/T1yoDDa+r7xsmcCLw==
X-Received: by 2002:a1c:1bc9:: with SMTP id b192mr15231189wmb.3.1620308284991;
        Thu, 06 May 2021 06:38:04 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id o17sm4231200wrs.48.2021.05.06.06.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:04 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 1/9] audio/alsaaudio: Replace ALSA alloca() by malloc() equivalent
Date:   Thu,  6 May 2021 15:37:50 +0200
Message-Id: <20210506133758.1749233-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506133758.1749233-1-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".

Define the cleanup functions for the snd_pcm_[hw/sw]_params_t types,
and replace the ALSA alloca() calls by equivalent ALSA malloc().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 audio/alsaaudio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/audio/alsaaudio.c b/audio/alsaaudio.c
index fcc2f62864f..f39061ebc42 100644
--- a/audio/alsaaudio.c
+++ b/audio/alsaaudio.c
@@ -70,6 +70,9 @@ struct alsa_params_obt {
     snd_pcm_uframes_t samples;
 };
 
+G_DEFINE_AUTOPTR_CLEANUP_FUNC(snd_pcm_hw_params_t, snd_pcm_hw_params_free)
+G_DEFINE_AUTOPTR_CLEANUP_FUNC(snd_pcm_sw_params_t, snd_pcm_sw_params_free)
+
 static void GCC_FMT_ATTR (2, 3) alsa_logerr (int err, const char *fmt, ...)
 {
     va_list ap;
@@ -410,9 +413,9 @@ static void alsa_dump_info (struct alsa_params_req *req,
 static void alsa_set_threshold (snd_pcm_t *handle, snd_pcm_uframes_t threshold)
 {
     int err;
-    snd_pcm_sw_params_t *sw_params;
+    g_autoptr(snd_pcm_sw_params_t) sw_params = NULL;
 
-    snd_pcm_sw_params_alloca (&sw_params);
+    snd_pcm_sw_params_malloc(&sw_params);
 
     err = snd_pcm_sw_params_current (handle, sw_params);
     if (err < 0) {
@@ -444,7 +447,7 @@ static int alsa_open(bool in, struct alsa_params_req *req,
     AudiodevAlsaOptions *aopts = &dev->u.alsa;
     AudiodevAlsaPerDirectionOptions *apdo = in ? aopts->in : aopts->out;
     snd_pcm_t *handle;
-    snd_pcm_hw_params_t *hw_params;
+    g_autoptr(snd_pcm_hw_params_t) hw_params = NULL;
     int err;
     unsigned int freq, nchannels;
     const char *pcm_name = apdo->has_dev ? apdo->dev : "default";
@@ -455,7 +458,7 @@ static int alsa_open(bool in, struct alsa_params_req *req,
     freq = req->freq;
     nchannels = req->nchannels;
 
-    snd_pcm_hw_params_alloca (&hw_params);
+    snd_pcm_hw_params_malloc(&hw_params);
 
     err = snd_pcm_open (
         &handle,
-- 
2.26.3

