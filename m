Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FCC6B3B8A
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjCJJ7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCJJ7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:59:16 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D83910A111
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:59:00 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r18so4507722wrx.1
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678442339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9N7u6WJBnH3s1uxLB4f4sp22AWC3MvK06S0R8KPoZzU=;
        b=CHYchpCxA9hMoOAVvA/vXfxOjtrxAnwW6xrOY2POdw2yOvNIo9dpsMvwSSapENpW4s
         00I/nzMqZf4901Ueiu5wr+OeUhM4fYoVilmuYwzYuEhEJSwLT6uFVIboXe4SaqjO4766
         8mJXNo7yb6fsvroYqBMnL7F7c5TZikVadDab03IYaRQefiL+O8Rdg0CwuuyYVuPmsati
         zMZoN88K+QuppUzmH5zpIJQ+2ciK5zDPrywMs8t2H81GFJiEd5ENqyHI7hf4/nBgCXxd
         e2sXSgL/XiM4D+RSaallpyOfu5yK9CpIa1VElHrKNAFf1UythTFvw7RLM1O2j1WT+Ay5
         1pHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678442339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9N7u6WJBnH3s1uxLB4f4sp22AWC3MvK06S0R8KPoZzU=;
        b=Z7Y41YyRCWgCcOuFF7yf4c9MnXc4Ka1hnPZR/mz8D/9KKwMsuJ0LXjaV0V3aSEUmrc
         KrRc0Wr1BPDs9VvUXF+v+0J0Ez6vSUOE93Y9pg77iw9XwsGxNIG5+fV+g6uprK2O+eRJ
         MD6GQeEU9KrGkB6TQO9kbHmOg8A8pCra4c9z0T6ZUSy6AITNoITRJLRWa66pbrWfTrzX
         KY3kgRIppT+hgmGyetPkRy7hRJhdoJI9Ox9A1nQHhq0XGXbFqfPTyhtAHAN4j7zJdD5N
         YfcvKi7R/TdDrcU3JW9G0g3DdN4YoZBJouI230DnkAH7i1lcRWPFq6QLfbskESYpzs/w
         7wFw==
X-Gm-Message-State: AO0yUKUM2IXuail2cvjLVa002OMrhoMFMo215zULt1lh8OzV+afCMvQi
        gNzaYesSrxUM5y6OyFVjLbsIcQ+lrNazQGVPuc4=
X-Google-Smtp-Source: AK7set++GFm8jqGl+OXdo6Ydv1Fz1ECYAPop4T6BWZZGqhBQ8z7WRNZ1B+7fVfa7MFzokMBqbJ4taw==
X-Received: by 2002:adf:e908:0:b0:2c3:e0a0:93f with SMTP id f8-20020adfe908000000b002c3e0a0093fmr15968908wrm.8.1678442338966;
        Fri, 10 Mar 2023 01:58:58 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j17-20020a5d4651000000b002c573cff730sm1751453wrs.68.2023.03.10.01.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:58:58 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     alex.williamson@redhat.com, corbet@lwn.net
Subject: [patch] docs: vfio: fix header path
Date:   Fri, 10 Mar 2023 10:58:57 +0100
Message-Id: <20230310095857.985814-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The text points to a different header file, fix by changing
the path to "uapi".

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/driver-api/vfio.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index 50b690f7f663..68abc089d6dd 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -242,7 +242,7 @@ group and can access them as follows::
 VFIO User API
 -------------------------------------------------------------------------------
 
-Please see include/linux/vfio.h for complete API documentation.
+Please see include/uapi/linux/vfio.h for complete API documentation.
 
 VFIO bus driver API
 -------------------------------------------------------------------------------
-- 
2.39.0

