Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6527B390794
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhEYR2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 13:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhEYR2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 13:28:04 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6A4C061756
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f20-20020a05600c4e94b0290181f6edda88so7045701wmq.2
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tE71iJXd5lNAWxxJLNcL/6uDoH1J0xBWhsOfm3k1uws=;
        b=dkrq9aMX8W87CIgan64n+dK18+xIXr0zcUUaiLS/h5GRwmu+tfrCVKcSHwRYudRTWp
         uyY2t4vFoLQj7cIk23d5S6rAWNHLr8BeUV6dcQxo1gCrLqyRvBepEYMIZaCI3oaEKSXW
         DLdEdnjt7r2yFxFy6LhmeC5oYu4FfavlaZlo/33fKmfQRgRg49tlHMHIUy2ZYVkZPBMl
         5gjFbLuVWgzMO3GpVqra7VNOei53Q1cN7mLLRYZyIu534yaGGgXDVMwKqLea+2MapUDo
         bEgroCVzh7XnQKNvZca82hXV/60s9cPe4IuP1f8PhIsXWpqpNWauw0F/Q4CYH5W4YPZC
         mIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tE71iJXd5lNAWxxJLNcL/6uDoH1J0xBWhsOfm3k1uws=;
        b=ICRB3noP6L41hl6EDalXQJt1SZXVo+ZLimBHncImACM8pcjrLat+I2IG4pZc4huTz/
         MFEC1dBrouRmCcyPTXzefgShQzE8nB/uMLXKJUH2vBjRXh7ycnK73kHYiqSeUhIVG7Ut
         NWdIDnHBNkfYyAbgmfIy5h3okjbNjYlrQmn/G4XsZN19W7G7pjXtKYqDRSyV3gkcA4ad
         HAIbY4LWG7xzBdcH3Ao95sQUW38YB4KRSQ1ZjsgGhimUI8UD09qYvZu0k6g9jbznOkDS
         l/b0sLOJneFBXq3mA0Iwe02sXrfwJRATFMTno/rWzhfwy8KO71F+PspLUf6n+07l79dA
         6ayA==
X-Gm-Message-State: AOAM533bpepwVgtJOFR8V1wTwspvRg2avAZS/IGbaihEE2pH/6YjGh/O
        MiyoSVC3v/7mTFPUuHS53wXKvQ==
X-Google-Smtp-Source: ABdhPJz/21wU+3sZAyElQTvCNA8LBhNegY7oMJRYpI7UQ/mzMrv5nQN++xYeVZHvfU5bU4INii/eNA==
X-Received: by 2002:a1c:7402:: with SMTP id p2mr4841895wmc.88.1621963590525;
        Tue, 25 May 2021 10:26:30 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id o21sm11663983wmr.44.2021.05.25.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 71D031FF7E;
        Tue, 25 May 2021 18:26:28 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v2 0/4] enable LPI and ITS for TCG
Date:   Tue, 25 May 2021 18:26:24 +0100
Message-Id: <20210525172628.2088-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a companion to Shashi's series enabling LPI and ITS features
for QEMU's TCG emulation. This is part of our push for a sbsa-ref
platform which needs a more modern set of features. Since the last
posting this is now at v3:

  From: Shashi Mallela <shashi.mallela@linaro.org>
  Subject: [PATCH v3 0/8] GICv3 LPI and ITS feature implementation
  Date: Thu, 29 Apr 2021 19:41:53 -0400
  Message-Id: <20210429234201.125565-1-shashi.mallela@linaro.org>

The only real change from the last version was to drop the IMPDEF
behaviour check instead of trying to work around it for the TCG case.

Please review.

Alex Bennée (4):
  arm64: remove invalid check from its-trigger test
  scripts/arch-run: don't use deprecated server/nowait options
  arm64: enable its-migration tests for TCG
  arm64: split its-migrate-unmapped-collection into KVM and TCG variants

 scripts/arch-run.bash |  4 ++--
 arm/gic.c             | 22 +++++++++++++---------
 arm/unittests.cfg     | 12 +++++++++---
 3 files changed, 24 insertions(+), 14 deletions(-)

-- 
2.20.1

