Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481003749F3
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 23:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhEEVNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 17:13:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233738AbhEEVNf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 17:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620249158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gqZEVFVeZ1PP5CqVjY9bmTR5zVRvOWsxXWPKEVWrRSk=;
        b=gY5Rx3Q7V55uJUS5JC2o2BYyF3eSr66pjB8CeBgzbPylsW4hGn1jpW3qbEzf7Mos+md85M
        U/rouloOmcIK1oJ8UMvPdSzKc5dNk27afIczwlA6p5oExFVclpFw0W+qgIMacFfvRPrc60
        mThiY77P2+9KyS+l762/oT5yQR7iem4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-9e9KUVFQMOqkQruZSyFzAw-1; Wed, 05 May 2021 17:12:36 -0400
X-MC-Unique: 9e9KUVFQMOqkQruZSyFzAw-1
Received: by mail-wm1-f70.google.com with SMTP id b16-20020a7bc2500000b029014587f5376dso1785829wmj.1
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 14:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqZEVFVeZ1PP5CqVjY9bmTR5zVRvOWsxXWPKEVWrRSk=;
        b=uVFJbzL75ETUrW77YOvh7NBcYLq6/Xavqw0+HwTta6HtRY6FhmTHwZlwKP4VY7Z8U8
         f9B5xCh12ijmQYmY74NO6aR3oPJdWoEB3r0WUFiJa648J+QqIzARZLol/jd9nMpD0Yba
         /o9PiknME+65v3rtYWeplmP8YJzeQFPTKmzU4JriDlFn8YxS6vedYWjNA63obTt18rkU
         LVpinsIKya/YrDXQIxOMiJothEXeo0on43Pi7yjWIM9n/2SgGA7ZeYPNN+hyTm686v4P
         LJxauIImMM5ewYfGX0ukJbTv59hp8G3bvSU+33yN/7+JAuVQda3zit/rBkk3HNyb5KmQ
         x8Mg==
X-Gm-Message-State: AOAM532gIHN4SYHqkbd9t5o9Eq9H9j8o6etG/Tl+wesrO0QlTroJVHs1
        lBhpC3zFGY3YuUyRuJ5T7qL1OuIRS/T2FJq9lWi2+9cS8F/RhbQ8xJwAenkkuM4HcxacTyKfJlZ
        QfRd5RSbBeylG
X-Received: by 2002:a5d:4351:: with SMTP id u17mr1030237wrr.47.1620249155513;
        Wed, 05 May 2021 14:12:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdfQQZsRtZ7nyL+DSHqlEkFdqu+Hv47j75LD54ri+lhlT8Xt5UqHtwkM5tFFazugNDQCPNDw==
X-Received: by 2002:a5d:4351:: with SMTP id u17mr1030222wrr.47.1620249155407;
        Wed, 05 May 2021 14:12:35 -0700 (PDT)
Received: from x1w.redhat.com (astrasbourg-653-1-188-220.w90-13.abo.wanadoo.fr. [90.13.127.220])
        by smtp.gmail.com with ESMTPSA id g129sm8432025wmg.27.2021.05.05.14.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:12:35 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-block@nongnu.org,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-ppc@nongnu.org, Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH 21/23] target/ppc/kvm: Avoid dynamic stack allocation
Date:   Wed,  5 May 2021 23:10:45 +0200
Message-Id: <20210505211047.1496765-22-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210505211047.1496765-1-philmd@redhat.com>
References: <20210505211047.1496765-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use autofree heap allocation instead of variable-length
array on the stack.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/ppc/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index ae62daddf7d..90d0230eb86 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2660,7 +2660,7 @@ int kvmppc_get_htab_fd(bool write, uint64_t index, Error **errp)
 int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
 {
     int64_t starttime = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
-    uint8_t buf[bufsize];
+    g_autofree uint8_t *buf = g_malloc(bufsize);
     ssize_t rc;
 
     do {
-- 
2.26.3

