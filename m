Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6EA6D4627
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjDCNtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjDCNt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:28 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD9E6EAF
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:27 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l37so17153564wms.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2FeLZKR7rrXEZU0aPhVzNZ/e8CIWD3g/VnvrT6YWk8=;
        b=kZmtBOf2iDPBbqPfDNkM9lOnUFuhMtgPgELYV+FeVe/tevJcmAoJoNpdgj0ET4cVJn
         VHV1zWCKYwQ54Kaa4Qk/UY5c2/V28c2nip5l6WG2XVmBYXaCUJcgq2H25E5MoOxv/J9o
         gqaz602XARMBoQilmFjbdQMTpXp9Ols/uPMZwaXeWQ/YsftVBAnOCkPFJVwOEhJAGzHj
         4igZo/d/GSphULrD/hJbheAsFgf9D4zgVjv6r61QXFW0doyoAWpTelVO61it552Ydcqp
         YwZABI2ajwBiOLZhRjDPk5sQYvjnZNLMorQ7GQa/YoFiart/Ta2VcGkqcwVjjuQk0okv
         /LVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2FeLZKR7rrXEZU0aPhVzNZ/e8CIWD3g/VnvrT6YWk8=;
        b=dU5G7wFE2fv+qaAN9vybkJBl3ovdXOTBRYqOHfQHKg210xU9AuzjZCmkH/6gEDMINF
         to6NH8CwIMlsxccwkwaRvi+/WGLbUHK9Dp1O4F7GWP6sU1BR4krSQyQrwWiT8rVi9cPn
         MKOvdMRp+wTj7nqbb2IMhi+cRoOTd4wVkhcnP8v/OVG6qy2J7pCbPIyQCqu9kqe+D3GG
         YY8druZNBGeLhKUOeVgzlYrDMZp/2ciBjxBqeqUXm+gfrcvRQAnEKN6SFvaExseCVfTP
         CrS5hyUl6aX4lKtVVF2BtpHGrN7GMp5ZL8YlN47o/H6s3Td4UmedDxwjUOS+FdMcMz9O
         AXSQ==
X-Gm-Message-State: AAQBX9ePMrkh6RU6EZsqIJQft5x4zDWJRSJ3K2RRBd+lrg+YMlgFcYuW
        wnFXBuKQM/ts3gGwq3QNsHCxAw==
X-Google-Smtp-Source: AKy350YA40DrGkbdfx/WSsRDtrRoPhUtAlw/ACRAcCii+kLbD9pF4FXTjcactSbOaqPqWUvzTTEOXw==
X-Received: by 2002:a1c:4b04:0:b0:3ed:c84c:7efe with SMTP id y4-20020a1c4b04000000b003edc84c7efemr13588895wma.7.1680529766064;
        Mon, 03 Apr 2023 06:49:26 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id m8-20020a7bce08000000b003ee70225ed2sm12182902wmc.15.2023.04.03.06.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id AC70C1FFC1;
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
Subject: [PATCH v2 10/11] gitlab: fix typo
Date:   Mon,  3 Apr 2023 14:49:19 +0100
Message-Id: <20230403134920.2132362-11-alex.bennee@linaro.org>
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

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230330101141.30199-11-alex.bennee@linaro.org>
---
 .gitlab-ci.d/base.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitlab-ci.d/base.yml b/.gitlab-ci.d/base.yml
index 0274228de8..2fbb58d2a3 100644
--- a/.gitlab-ci.d/base.yml
+++ b/.gitlab-ci.d/base.yml
@@ -75,5 +75,5 @@
     - if: '$QEMU_CI != "2" && $CI_PROJECT_NAMESPACE != "qemu-project"'
       when: manual
 
-    # Jobs can run if any jobs they depend on were successfull
+    # Jobs can run if any jobs they depend on were successful
     - when: on_success
-- 
2.39.2

