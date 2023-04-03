Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9466D4621
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjDCNtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjDCNt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:26 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF787299
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v6-20020a05600c470600b003f034269c96so7931045wmo.4
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIAbN9ckX3lGfUzvEPz/vzPNYZxaSL+GVZgf5wv9fMw=;
        b=LWUprjACAXh+rLjO+aP8mffyvPwH4ehS4JZikFQAibUBF0T9DkF4kdhb7lHWFZKQRr
         /4ALZYok7J+Boq7MVhqfKjWiCieBWXUjgeEJGbFtw1Gds6GKdMxi9wLJzMjrcdJqohlV
         OoEZ8CMWkpf2UDeGOvCGc6UJHpsMgIGU8iejcuZl1+Bp+OKnTfv1/AYDwIGGA9ZYn4bB
         DVlZHzvRpSe45DYQHZsUV8HowyoYF7txt7KNlkEbkUdkQFEt6b7odwVWcP7zut9mXuEF
         BU32cAEjuwEi2re9se/CocXw7PQ4xlznkJFvt9jpcG88WWkCPUHT2fIj0ckekv1APwPG
         2xtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QIAbN9ckX3lGfUzvEPz/vzPNYZxaSL+GVZgf5wv9fMw=;
        b=wBiS/nUFUKbjvXQD75btK7pw8Z+2g+2BalEAi8vhFkF4aDFOTiOIZWyg/1LTYAPUK5
         97a4v/emoD25MLlbTOLDGKZIHP269yxSO01/ff0Mc/z1RsFk2nlMB3W1on28t8LPQheb
         jzQW+6I9eieVhfgWZee3hZNExsXcJWD5L+tPJB+yI3HIKo4gJGpnYXjK7YBWVsedOm/f
         PcvY0fDG/I3sHXOBfu2z0azzFnK8Ds5b1GqER93PMwm1C+JQDXCTxRvX1H9/q8f2MwaQ
         3IgovSb8P+ASYL+Px16mVqjhWBgiv7TFbkG34eoFwdG90DwZfqS7RsVZd8vF7IzbCHHH
         PqYw==
X-Gm-Message-State: AO0yUKXDEWn8Q+jQUWzzFD4EsW9cwm7HFXZVe0ZE+W7nl4FEDPU+SkAX
        y0MJOZURsR0KR/prnDY6W8F/Zw==
X-Google-Smtp-Source: AK7set/iPqa1oDkXeWQmk6LoRUQ6t2lI5DVpIiIXbiFyL4cXuZzRcD8PTVowcXFiJ8fJgH1SLa7O1Q==
X-Received: by 2002:a05:600c:ace:b0:3ed:98c1:2e5b with SMTP id c14-20020a05600c0ace00b003ed98c12e5bmr26622637wmr.9.1680529763808;
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id l7-20020a05600c4f0700b003ef5deb4188sm19526847wmq.17.2023.04.03.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 329FE1FFBD;
        Mon,  3 Apr 2023 14:49:21 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH v2 05/11] qemu-options: finesse the recommendations around -blockdev
Date:   Mon,  3 Apr 2023 14:49:14 +0100
Message-Id: <20230403134920.2132362-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403134920.2132362-1-alex.bennee@linaro.org>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are a bit premature in recommending -blockdev/-device as the best
way to configure block devices, especially in the common case.
Improve the language to hopefully make things clearer.

Suggested-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230330101141.30199-5-alex.bennee@linaro.org>
---
 qemu-options.hx | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/qemu-options.hx b/qemu-options.hx
index 59bdf67a2c..9a69ed838e 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -1143,10 +1143,14 @@ have gone through several iterations as the feature set and complexity
 of the block layer have grown. Many online guides to QEMU often
 reference older and deprecated options, which can lead to confusion.
 
-The recommended modern way to describe disks is to use a combination of
+The most explicit way to describe disks is to use a combination of
 ``-device`` to specify the hardware device and ``-blockdev`` to
 describe the backend. The device defines what the guest sees and the
-backend describes how QEMU handles the data.
+backend describes how QEMU handles the data. The ``-drive`` option
+combines the device and backend into a single command line options
+which is useful in the majority of cases. Older options like ``-hda``
+bake in a lot of assumptions from the days when QEMU was emulating a
+legacy PC, they are not recommended for modern configurations.
 
 ERST
 
-- 
2.39.2

