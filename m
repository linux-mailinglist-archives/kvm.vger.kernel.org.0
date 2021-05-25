Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F93390795
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhEYR2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 13:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhEYR2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 13:28:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09E8C061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:32 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z19-20020a7bc7d30000b029017521c1fb75so3957939wmk.0
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kXRo+YB1GVPx3XHHAG0hUMJe4NWtnjWLeQgYeSAHJxA=;
        b=fo46SNxQ9jXF57/LLsGQwmPBq998FOLgxXImtPzwjSv5PhYgCPlHc1Q5qu+x7mR2az
         vn211zLTZ2VgKYgYqldEHEjX99dW4IF9YkS1cymW/a07x23jOQtXuKq5f2ToD6ZVxTLH
         I/1t5tlD4sEFRhf7fVe/R9xfiIFQXTeLL50B72cbHkcwzWDYpsqsgEWbUMrcUWvco6Y0
         5pHuoh3pGs+v6jI414e2f0MTGut8gci+2Kzec0K6/q1qdhwgxP5N4y2iNZUafp3XiVzp
         6GFCTvkRLNcb+lIlSmsoFttxDc/QzKyADnycty46hjwHPlXltbrXid7ttt2DVp2JYlvP
         iJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kXRo+YB1GVPx3XHHAG0hUMJe4NWtnjWLeQgYeSAHJxA=;
        b=EdNcI+b9UkGfjmvn08e2TSmQ0rmY8znhk9+bvOygALbnJ/VKdhdJMLSFSqUNTqAN7N
         HNA6y6hUUg4Pav2jjULScHoedHlSNjSyXgp9ArOM82ipF9YAS8XeDvkNjBxNDM4Ay9QF
         brLmHXpIuAunXhm3H/xV2QeEXEVOTcGLEB+BhezjvKvOE4HuPu5VxNgEPHv0kfKZaTSa
         C/DIjcg0m9rXsuZh/CWcEb/nCIkaf0t3eVV4SzP5K4RWYOlqm7ujWTzBD+rh4cUt1ff4
         uqGD4yXmVVO8wtXs0BaH7xilKgmgjyzttZWrXPACEy+EaOITLbLtEbsI24q0oxUYEw91
         iaTQ==
X-Gm-Message-State: AOAM532/OvQ0D7+bJNbpo5EAFm15evNPyhRDX5iujb3tdTx7DN9uebBG
        5uQRqD9znm4lcvCkbgH2IWmT1g==
X-Google-Smtp-Source: ABdhPJzmGcXaLaloKoNuJvzV+Eso7SMQocRGBo9MMkwzzvUBiIigiYsDrY0W6M1IX6yPpG166F6kwg==
X-Received: by 2002:a1c:4043:: with SMTP id n64mr25571555wma.9.1621963591341;
        Tue, 25 May 2021 10:26:31 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z9sm11615062wmi.17.2021.05.25.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9809D1FF8F;
        Tue, 25 May 2021 18:26:28 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v2 3/4] arm64: enable its-migration tests for TCG
Date:   Tue, 25 May 2021 18:26:27 +0100
Message-Id: <20210525172628.2088-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525172628.2088-1-alex.bennee@linaro.org>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the support for TCG emulated GIC we can also test these now.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Shashi Mallela <shashi.mallela@linaro.org>
---
 arm/unittests.cfg | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index f776b66..1a39428 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -194,7 +194,6 @@ arch = arm64
 [its-migration]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-migration'
 groups = its migration
 arch = arm64
@@ -202,7 +201,6 @@ arch = arm64
 [its-pending-migration]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-pending-migration'
 groups = its migration
 arch = arm64
-- 
2.20.1

