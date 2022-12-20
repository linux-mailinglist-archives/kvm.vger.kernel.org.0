Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFC66522BB
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiLTOgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbiLTOfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:35:37 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927AD19027
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:35 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id b24-20020a05600c4a9800b003d21efdd61dso8948995wmp.3
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XMhNOxAat8eNdkiyGs2Ix1znKG/kXZPirOJB85LUlpI=;
        b=tuuTtptZkDdQy18iveDruU5wWLxJ6mNE/yT0lBCcCrqdm4wABFOo8dLKXQkDGTw7BX
         9hXd1cX4za77C69lsCw+xk3IHettYlv3hyiQHBqCRmdJYiNPi5780Valcxv4eT2DhwcU
         i55GnbL06FU6+zBl0NF3LVUgqrovzCTA/tihvRF5SipJYyp6xVScXhVB78oFlWCeMvNL
         tSSNgFnrlkv3BKKV8SMvMZmxScasaW8ffUBAWw5n09b2Bbw6c8ZerBdMMSj1uWMWE3U6
         CubFmqO7N3BF4eLsPVvHUxHRt80idvZkkDZY5KAPZ4LN88Lu7HomQwYnVnC7S3Csiw6x
         EENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XMhNOxAat8eNdkiyGs2Ix1znKG/kXZPirOJB85LUlpI=;
        b=y6p6F3CN0xhILd7tuEfyYvQUwpzN2mAvc2Sbwt3lAbwkmC/qbgv7gt8sSioggoSAaF
         iM5rjIlAY/feOi4PL9NJw7g7Ja/scJnXuj31EpASFA8looPyD/lJNfpWK1rJyVELIF2G
         4UEjI7DOfHi15Vx691KUMP4Czb+lICOuGLxzlpmBjdiIs5dyNdlb7QNOujaQsKywNuM4
         MTTcLoal14DWlkf34IepUvhTGu5VfqBkCEAUwIWBOaL4tfl7d0aAQkchZCciVudisrse
         JFs+kqZEgLDGsRH6LBb61V4m7ELPa2tvd3b9CvA79xdIl/vgqldTpDzHjGr3vhoQUoDF
         8NBA==
X-Gm-Message-State: ANoB5pmFR1e1WUWyw2DgPRBAQT5N1bKdl+Rqyw+yWNL6iXHtMjK+vMQo
        CL889I5dw3fjFgl7QldZrPEjxg==
X-Google-Smtp-Source: AA0mqf5ML62RUlsRMzJwc1uHMgsOffxm1fGEha6ZD3GBjMuG3hi8X9xxmxuHJ7xNgGdwVXkq/13FAA==
X-Received: by 2002:a05:600c:20a:b0:3d2:7e0:3d51 with SMTP id 10-20020a05600c020a00b003d207e03d51mr33818412wmi.17.1671546934177;
        Tue, 20 Dec 2022 06:35:34 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id z19-20020a05600c221300b003a3170a7af9sm15867680wml.4.2022.12.20.06.35.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Dec 2022 06:35:33 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/3] accel: Silent few -Wmissing-field-initializers warning
Date:   Tue, 20 Dec 2022 15:35:29 +0100
Message-Id: <20221220143532.24958-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Silent few -Wmissing-field-initializers warnings enabled by -Wextra.

Philippe Mathieu-Daudé (3):
  tcg: Silent -Wmissing-field-initializers warning
  accel/kvm: Silent -Wmissing-field-initializers warning
  softmmu: Silent -Wmissing-field-initializers warning

 accel/kvm/kvm-all.c | 4 ++--
 softmmu/vl.c        | 2 +-
 tcg/tcg-common.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.38.1

