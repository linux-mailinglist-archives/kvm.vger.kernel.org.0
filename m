Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1597464F3B3
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 23:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLPWHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 17:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLPWHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 17:07:44 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AC71740C
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:07:42 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m18so9295859eji.5
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F8aJDmXaJ45RwFgpaAMRLc5en+AzGpJRkJS1lv4bVUU=;
        b=Un7xZStzCgeJwfbzFGvvuKI64oQoTAYOaj4nDuFHdDv8fch6sdsHmzN1m3ysk9Vfmy
         mwM6FdoCkSqbArN4DmhjifBAKf1zLtdaE0qIpBufGVDg9dTMwR7p1TUGB6+95M2Xikk6
         DNtxSZ29wd3+Kd6isoJw6WzdrNnFh6Yi730rLfaU5A3hkQQ8TsZixgg6ixImURn22uMh
         4M7zD9Vlj402Kb2Wyb7MeJmPKVlQfTr8SWiVroT2kQuajrJJav6qSFO/mdSjNlqZeF5/
         Alu1fMH51kFwtWOhC+6zawL8AbTDBsqKrGtbrBKDzu6HixFH4IwbUFSAdMfZQyRjtbmj
         O89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8aJDmXaJ45RwFgpaAMRLc5en+AzGpJRkJS1lv4bVUU=;
        b=EwhNpYmbw+a0ckZIgvmIifseRX6GkKH/JJLfgoaom/7Hs+y2t67xmGaNZYTYKbcL/+
         zgCvO36k9rUsCTUEyRfOVUdehbxKFGa/vPi/DTBWZ/gOHTFzKcCH6aZ4PcWIWLai10zS
         x6K6kAu8M8STxOhRKvgMesrSPMvDabV/B+v+uZEXGnah8zN7k5bXZEoIYoSVa1gcp1md
         MS7x4VZtRQwBFPmuGbjqgOWlBZF5CmRbWzXHH41m5DUcvKw7T981IAKW/udGSSgEm8+j
         w55+CrvCZTty5sAAn74KiSGwNYjQgDhsugilw1/S8rQLBIpHoE1mhXG10Ex64vHZ4NJY
         hCSg==
X-Gm-Message-State: ANoB5pkBFMPPiGoXmKY2G0nrTjwFjB+tW6KffujnykkgPNtQn4l7KYRR
        FUF6CDN413QPp4PZ3sC6sufp7Q==
X-Google-Smtp-Source: AA0mqf77vAvGiZ9Kd5R3p7qXCE2gyNrK+9EPQTV5PoFhN0NSvB0665+jYPW5Y+BZc+XOF6szbDoXyQ==
X-Received: by 2002:a17:906:2506:b0:7af:1139:de77 with SMTP id i6-20020a170906250600b007af1139de77mr30684332ejb.4.1671228461556;
        Fri, 16 Dec 2022 14:07:41 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id n11-20020a170906088b00b007c11e5ac250sm1298642eje.91.2022.12.16.14.07.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Dec 2022 14:07:41 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/2] sysemu/kvm: Header cleanups around "cpu.h"
Date:   Fri, 16 Dec 2022 23:07:36 +0100
Message-Id: <20221216220738.7355-1-philmd@linaro.org>
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

These patches are part of a big refactor cleanup
around "cpu.h". Most changes should be trivial IMHO.

Philippe Mathieu-Daudé (2):
  sysemu/kvm: Remove CONFIG_USER_ONLY guard
  sysemu/kvm: Reduce target-specific declarations

 include/sysemu/kvm.h | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

-- 
2.38.1

