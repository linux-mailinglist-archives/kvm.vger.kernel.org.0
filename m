Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40AB44E5B2
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 12:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhKLLu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 06:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbhKLLu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 06:50:28 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B1DC061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:38 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c4so14985080wrd.9
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y/FU8+bwf7DMlYAmB7NLQtYUyzsQrJXGMArM+f/WGbQ=;
        b=oIA3R5dQ8KPpSky2EHZb76G9smza8Up8hdy9YTLR/rN80He4si4N7T3hLw11/rUrND
         RDV7+4YZds9cFkEnxKHSAFfp5DSxwYa14HbCwQDYAdrEDER+XWxp3uhBtx8Iiu1W3/Vj
         Jyo+r/ob1dYpI0p0UZc+24JKo3yYlYk2kmNyQw0zJU2pM76AP1GvTATQcHn3vn9tgu00
         +W546e8e6D07Z1CUFzTuiGEKVhxTZcs6KvU5kFWKtxffq+qm31gjCGxlOwv4OhTfaRbL
         lU7p1XQkhVFqQ6xfBReh5rx+R6PouLMJroulc1ZE/BIM6KfGtzEIKGzjxl/OcpyZYAfK
         cSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y/FU8+bwf7DMlYAmB7NLQtYUyzsQrJXGMArM+f/WGbQ=;
        b=J3PxTDKbbhfLrMjaUxEUPzE8orPpURvoFb2Uz264Vag6ZRxdTJKHsdRtep3ah2p55y
         Rotqhc8WDLQ3rZNnJ2UWfvzgoVM6FiFNnQgro9S4O269vMBeyPCcaepEfKuKCB/5SFm/
         XA1fqs1U6pz6QP7cjtenOMZwTv6tu1/i3tPklXqUnHajH5JcjuwunMGGk94QCS7AUK5g
         fBAk70nBGgXzdyFNMALpeji1f46xtCoEp7wiOtmziwleU/oaMXB5cDXEvZrKTQUdGRft
         WhBwBrwnlXaDj9CFX39Qc0fcTyNJrTG/eiwbfCwRcHZrBmUQi4RaGP4IWFdQ8BQ/OVb5
         7gCA==
X-Gm-Message-State: AOAM531jOcWEPH4sPJNHcWqNQPsdvoteGyOo1bEdLhU9jRHdBfoaRp2J
        jHA3GCgm6xx7aW9FXOS5poB3eg==
X-Google-Smtp-Source: ABdhPJzW5BOflAYjrD9sAe1tHGRVbSLAvpIz35Bl4aw9fwu8ZT75ZP2FyPRAIGfrez5XVflGq+GsOw==
X-Received: by 2002:a5d:6c6b:: with SMTP id r11mr17814784wrz.231.1636717656571;
        Fri, 12 Nov 2021 03:47:36 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id h15sm5565709wml.9.2021.11.12.03.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 03:47:34 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 4C9FC1FF96;
        Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date:   Fri, 12 Nov 2021 11:47:31 +0000
Message-Id: <20211112114734.3058678-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Sorry this has been sitting in my tree so long. The changes are fairly
minor from v2. I no longer split the tests up into TCG and KVM
versions and instead just ensure that ERRATA_FORCE is always set when
run under TCG.

Alex Bennée (3):
  arm64: remove invalid check from its-trigger test
  arm64: enable its-migration tests for TCG
  arch-run: do not process ERRATA when running under TCG

 scripts/arch-run.bash |  4 +++-
 arm/gic.c             | 16 ++++++----------
 arm/unittests.cfg     |  3 ---
 3 files changed, 9 insertions(+), 14 deletions(-)

-- 
2.30.2

