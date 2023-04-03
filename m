Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441616D4620
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjDCNtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjDCNt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:26 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F39E6EAB
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:24 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so19552458wmq.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5aVTp29ura2AnXi+mbMTi4HjJNdcHU6J80+OlMAlxY=;
        b=ZHIf9dTR9loLxTXKZEIR0EGR/ksvgHBfh1pbCJ0NAkJGnCKcyHG7CzrW/CiT/e6zrH
         c5PIqG8eRCQSzO+W6MlMgOpUEKLOlaONVz+0y/Ie32Pv08zCE9wv5KII/7LySQ9cSifv
         0VrF88QHDe1uAetUbtrP+UgQGfpltXIh8k2NUcHjpHKnuEOzeGy0++076bIUD5CfPngY
         HxCpv57KPdzbJm73+iwV28AthNhhn3UrMkEROc9b4h6AZbsBiXpFFs5jAPNRM0gFsHDG
         Li+H/g22R0opKVbB3rO6gqSRAFd5djOPW5X0t3kyLNzlJi89cuEmwvGDtGR/ciSuieM3
         R7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5aVTp29ura2AnXi+mbMTi4HjJNdcHU6J80+OlMAlxY=;
        b=CIUY+7by4jmMPqYDnpJ1RYLWrNDBRBEm9YEJ7cJadzbbdYTCaU5OS1UUcBi2bDvDTp
         MQ4q9b0Ydw3VTJIMO6CMF/3hRCAvO5BxFG2A0UrAOA3LdsnLq3zMwN48BxW29KnS1vMo
         F7NXu4Pyw8Y5VHsHeIj/1lMPe7s0ZrTGtiauewAyHqGaz3/TWY7ahGXvh93mZX0upZqd
         LYZHmIe/pvVvxZSiXGWo0Sik3N7Z1z+O86OsIADby/V23mqo8G4q0Z8dcx2QmLe8HWgp
         LLyCjgNZ9sZTQB2z6l9vy00emjF3XcTbhUsdDCSPzCQBVOby1aIKIp3VnW5bwek9kToG
         e3rQ==
X-Gm-Message-State: AO0yUKXdvPAwm6Eh/tAoWNUvdYQ9vAB/T4EOD42zBLJzgxx85HckQwTz
        BiI0/tqoPfvDvhwlc7fS6XPXog==
X-Google-Smtp-Source: AK7set8lYRugOBzrVk1ygXZ1aDlYhbI/8TypyTwOwvLQVpeVrOmym+zLvkt3BbgcjuFifdsfynZTog==
X-Received: by 2002:a1c:7516:0:b0:3ef:3ce6:7c69 with SMTP id o22-20020a1c7516000000b003ef3ce67c69mr27186739wmc.8.1680529763045;
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id v20-20020a7bcb54000000b003ed2c0a0f37sm12120590wmj.35.2023.04.03.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 1C5EE1FFBC;
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
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Kashyap Chamarthy <kchamart@redhat.com>
Subject: [PATCH v2 04/11] MAINTAINERS: add a section for policy documents
Date:   Mon,  3 Apr 2023 14:49:13 +0100
Message-Id: <20230403134920.2132362-5-alex.bennee@linaro.org>
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

We don't update these often but now at least we have a few like minded
individuals keeping reviewers eye out for changes.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Warner Losh <imp@bsdimp.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Kashyap Chamarthy <kchamart@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230330101141.30199-4-alex.bennee@linaro.org>
---
 MAINTAINERS | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e1a60ea24..2f67894604 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -64,6 +64,20 @@ L: qemu-devel@nongnu.org
 F: *
 F: */
 
+Project policy and developer guides
+R: Alex Bennée <alex.bennee@linaro.org>
+R: Daniel P. Berrangé <berrange@redhat.com>
+R: Thomas Huth <thuth@redhat.com>
+R: Markus Armbruster <armbru@redhat.com>
+R: Philippe Mathieu-Daudé <philmd@linaro.org>
+W: https://www.qemu.org/docs/master/devel/index.html
+S: Odd Fixes
+F: docs/devel/style.rst
+F: docs/devel/code-of-conduct.rst
+F: docs/devel/conflict-resolution.rst
+F: docs/devel/submitting-a-patch.rst
+F: docs/devel/submitting-a-pull-request.rst
+
 Responsible Disclosure, Reporting Security Issues
 -------------------------------------------------
 W: https://wiki.qemu.org/SecurityProcess
-- 
2.39.2

