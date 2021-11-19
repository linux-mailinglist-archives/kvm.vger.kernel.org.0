Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12F45732D
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 17:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhKSQkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 11:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbhKSQkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 11:40:19 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50739C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:37:17 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a9so19132275wrr.8
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMPYfacR2Cj+o7xlQDQb9ZFthvee/fPmicID5MFvuIA=;
        b=B/Eq/nE1KTPpwlO++bf+SrXNwr+P61EjRLmdrzsxg2yOW9MuTVqig2j3JPE3fMBATe
         Ai1JDSQagrGCpOon0ZrTRpMsPAE5VbI6/cU7j8XI5/v19gBh+ISt2B+LaKkzfj/kgkbw
         jq8OiJOMWRn2l4aIHmgmWq2hIMXTcXswe7hkHvLpnmQuVGyFMpBh9m/dKCPQu9Duqt32
         BSA2xcBz87ho7BmQJFJ9GP/RKEX9WkeJNKw1T+PyrCrc23u0fw9UKUQbDU3HUxpt3UvK
         VifvGlyUqo5pJigpEQRlidoYQcJWxjo749sO8xRMpdzk23ggIIaWX7tUHHScvPVOQclc
         lhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMPYfacR2Cj+o7xlQDQb9ZFthvee/fPmicID5MFvuIA=;
        b=8LRCvOzrfve3w9wuF2GSMj/WrZCIa6h8FoOCxwF8NCprhmD/JbDLcu4iOu69RoxpeV
         +jDLJOga3+L8JvISx05Qb8/LNkiiPdwISoZfnKR3yqsoZBwosBBdHgYHfGGUrXIwZnR/
         OE5sFcFgTHb9KctfUhqtS3baS/AJWAUQHjTzWZUax6Z16rtzNnYS0TvsDDHMzTAW8+hM
         6nj8jbzB4NZ1vryRlZDlON18JoqACL1JGvAOxt6EVioEW0HYbwXKHqurlPs9Ky9NHsXO
         YKOWgBmps4mhuAu064Zg7x1etlgM9PFc9al0quJb1DvztCFhICvcyaj8bJ5jxb/XkyFX
         gQ3Q==
X-Gm-Message-State: AOAM53210ad/TlCjVUwSPIjD6EWCgu201+bPtzbonTFP75RxR8JJ1AAe
        TTcPzlm2GPEhVssSq95RHmbeiQ==
X-Google-Smtp-Source: ABdhPJzikzRuzfho8zkpVhiRsUw1Knnj9YomD9yAbueZCm1uGY6mSMAb9MbUBrGha7HQsdqk6lPKpQ==
X-Received: by 2002:a5d:4492:: with SMTP id j18mr9149357wrq.397.1637339835869;
        Fri, 19 Nov 2021 08:37:15 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id h18sm259315wre.46.2021.11.19.08.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 57DF81FF96;
        Fri, 19 Nov 2021 16:37:10 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v4 0/3] GIC ITS tests
Date:   Fri, 19 Nov 2021 16:37:07 +0000
Message-Id: <20211119163710.974653-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

changes since v3:

  - dropped the pending LPI test altogether

Alex Bennée (3):
  arm64: remove invalid check from its-trigger test
  arm64: enable its-migration tests for TCG
  arch-run: do not process ERRATA when running under TCG

 scripts/arch-run.bash |  4 +++-
 arm/gic.c             | 28 ++++++++--------------------
 arm/unittests.cfg     |  3 ---
 3 files changed, 11 insertions(+), 24 deletions(-)

-- 
2.30.2

