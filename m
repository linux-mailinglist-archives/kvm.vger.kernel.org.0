Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9D936D5A0
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhD1KTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239179AbhD1KTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 06:19:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E19C061574
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:47 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id a22-20020a05600c2256b029014294520f18so4144123wmm.1
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PKGDTgiVcM/lQ6iRrmAsUOi9EArz4u3h1iRq434eRSA=;
        b=KR9NTcMYjJQLFeqrQ2TR6ifAqSo99rz39UJx//d3x6y1Dy1pWofUW08E+LT0G8mVAu
         1IM32Pw4NlYnD+xTg/GD6c9VGP7xlLlG9Y2F8puVHsRfS6nDxFa18AxQoLHqOEEiDhFD
         CYUxDhIHvSkLOYmsljUOkO0Pc96WjOXotVbjEexdG/4GSmx91wy1wz3Yo5tqu5m7YE+z
         0ZaBAmhS4XQ54zJmw/RMOXvBqZhFFJ8zXcLcP4QHA4ByKgyzYDoGTPRNb/OtE5I0ZTTr
         nSsnifL9HuaMPbTmyJO09WDgQ3PpZisNvjT6fIKEq7wyFN0EhJEa3+WDeIHyObwh4Rvu
         UZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PKGDTgiVcM/lQ6iRrmAsUOi9EArz4u3h1iRq434eRSA=;
        b=lyfRZq+cyOCGBrKO8h4MCQbIY4QdiEXBkZirr+Ysec3xhIAb8jINPkV6egKmQtO4Li
         wQP7ZfUSkuABex09B+5PiPMiwGSB9pJ0sF7066dyouRTgSEcQ1lChpvIVf++83JGC3Q2
         aPUdrkc0FwAAUnfPsI/b+B7tYC2u7lE+YElWPWJItl5Mz+j4Usi3Zyo/59q1ANqIUtH5
         I9p0hap3k66OXnQV1TcNEWKxPyV4sVv9ayWW0Bv70nFtjs6lsUSPZt/2q+dflqGObFZz
         NvUYi9C1HiDSBUgJqwks5zOpoC7fVepCa2WLCSJoVb3tRGXAqFJYS3Tht077ke4ZWH+/
         CTdg==
X-Gm-Message-State: AOAM531MX94S1QrpeLlzUAaRE45sUWrGsZBOglHibKKuoDU8fmDjR8ye
        SkfKE+V8GqYkoKS7PVyQ7Oa0IA==
X-Google-Smtp-Source: ABdhPJzL3juJCDl3XA6F0deoJp88yUP3zghVWwtGs9VLwPOsZipRSr61EUnv0vcux7XC7IERZPmCgQ==
X-Received: by 2002:a05:600c:228a:: with SMTP id 10mr30822102wmf.115.1619605126000;
        Wed, 28 Apr 2021 03:18:46 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id l14sm7760562wrv.94.2021.04.28.03.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 1B26B1FF7E;
        Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v1 0/4] enable LPI and ITS for TCG
Date:   Wed, 28 Apr 2021 11:18:40 +0100
Message-Id: <20210428101844.22656-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a companion to Shashi's series enabling LPI and ITS features
for QEMU's TCG emulation. This is part of our push for a sbsa-ref
platform which needs a more modern set of features.

  From: Shashi Mallela <shashi.mallela@linaro.org>
  Subject: [PATCH v2 0/8] GICv3 LPI and ITS feature implementation
  Date: Wed, 31 Mar 2021 22:41:44 -0400
  Message-Id: <20210401024152.203896-1-shashi.mallela@linaro.org>

Most of the changes are minor except the its-trigger test which skips
invall handling checks which I think is relying on IMPDEF behaviour
which we can't probe for. There is also a hilarious work around to
some limitations in the run_migration() script in the last patch.

Alex Bennée (4):
  arm64: split its-trigger test into KVM and TCG variants
  scripts/arch-run: don't use deprecated server/nowait options
  arm64: enable its-migration tests for TCG
  arm64: split its-migrate-unmapped-collection into KVM and TCG variants

 scripts/arch-run.bash |  4 +--
 arm/gic.c             | 67 ++++++++++++++++++++++++++-----------------
 arm/unittests.cfg     | 23 ++++++++++++---
 3 files changed, 62 insertions(+), 32 deletions(-)

-- 
2.20.1

