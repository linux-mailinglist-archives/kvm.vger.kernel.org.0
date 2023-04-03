Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC8B6D461D
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjDCNt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbjDCNtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:25 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C879E728F
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:23 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v6-20020a05600c470600b003f034269c96so7931000wmo.4
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHHLYJ1Q7CDYpzOnQyJie+UJ0r74Mi54/+ouByLjk3E=;
        b=CWzuya7JW2bY34opxAKYIrNfyS65J2Ve7Op8RUvVCTJWgo8mFVV0WttZ5XTBIOpOuw
         qEc0uVEkLj4BSXrkGYzQuo4l+mgtk1/Cg5F8oZdEugZIT790Y3kd7/R/ROH79z7UrZQ0
         v3Sn6tKQEDY9L3zgiYs7vsdbe8VCOYPEkeTzMCKl6g63yKNr+tFOllZTZi0lmaKWowSm
         PARwtkZgJ1mpnizEjF6BHJMoGJzl5i5cHzOy7KasRbZka01wrMHVeI0zfyoEPcjqUfVu
         oF/kl0e4k2mu2v96VOyu3vif1056EhDnaETNYv0h58W43SS6YkTyw2bu6X5j4qNswFKj
         vOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHHLYJ1Q7CDYpzOnQyJie+UJ0r74Mi54/+ouByLjk3E=;
        b=ke6GCH6+3pM5QTeJmesO4IorXdjgiXNNBsmUxtDpJvFRMTcy9ivzrJxXsAQyULRgK/
         5S7p5qszG4cMNc7x4KfKmyOMFsdTu/SiEsAaKuIWAkS/Nt2u7TBSllHtozDkQu/pqUIf
         nGPI4GZzk0Iu7H2e2Eon228C0pI6wNg3ht4ZBlLJckBIte6co+26T8Vgc+2XATg3e/fT
         BBbGU/rxmLZurU0JkrhEvjKlYO9WzY6khBx84fwY86K6Ngth7y6+zVRWdes02YSOQR1p
         v9YmH6X69UlpQfDeHU5MTwzRqXzQpKnaurn9Gin0o9LTak5qO0Wd/vri0bxqy1x2uuqh
         94oA==
X-Gm-Message-State: AO0yUKXXMmO4MtMlMLWqZLhFgHP9T8y+vwORI+LxhbkOqzSP1nBgyQZS
        TTINAoEnbcVoXuxpeYECyrG6CA==
X-Google-Smtp-Source: AK7set8bJ8p2Mjm4rby/PfqCRzfAP52hZFXF8mjkWC1Vnn5qr98rrvtqR8gLVZ45HJE2Z+KffldK9w==
X-Received: by 2002:a05:600c:acb:b0:3ee:4f92:907b with SMTP id c11-20020a05600c0acb00b003ee4f92907bmr26589298wmr.14.1680529762237;
        Mon, 03 Apr 2023 06:49:22 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id iv19-20020a05600c549300b003ef69873cf1sm19941464wmb.40.2023.04.03.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 05D4F1FFBB;
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
        Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH v2 03/11] gdbstub: don't report auxv feature unless on Linux
Date:   Mon,  3 Apr 2023 14:49:12 +0100
Message-Id: <20230403134920.2132362-4-alex.bennee@linaro.org>
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

The later handler if conditionally compiled only for Linux but we
forgot to ensure we don't advertise it lest we confuse our BSD
brethren.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Fixes: 51c623b0de ("gdbstub: add support to Xfer:auxv:read: packet")
Reported-by: Warner Losh <imp@bsdimp.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Warner Losh <imp@bsdimp.com>
Tested-by: Warner Losh <imp@bsdimp.com>
Message-Id: <20230403120250.2071560-1-alex.bennee@linaro.org>
---
 gdbstub/gdbstub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 2a66371aa5..0760d78685 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -1468,7 +1468,7 @@ static void handle_query_supported(GArray *params, void *user_ctx)
             ";ReverseStep+;ReverseContinue+");
     }
 
-#ifdef CONFIG_USER_ONLY
+#if defined(CONFIG_USER_ONLY) && defined(CONFIG_LINUX)
     if (gdbserver_state.c_cpu->opaque) {
         g_string_append(gdbserver_state.str_buf, ";qXfer:auxv:read+");
     }
-- 
2.39.2

