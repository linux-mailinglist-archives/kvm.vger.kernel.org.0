Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86A3390798
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 19:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhEYR2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 13:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhEYR2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 13:28:07 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98019C061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso13958572wmm.3
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=67YF8LAkTfMHmF/4xYtvDZYwRzZrAqbRd318422rBrs=;
        b=hAnPW/aujGCGTiMaO633MECpr3iVHFpZ74vutulN+WOw6UBGyXz1GAaCqDy11v/83w
         JuVngu6+qj9Su7GGBaw9lzZT2V+jnbrmRIQ2QPqfC74LIPdh6NoSQift2znc8TncYSJ/
         5WIrp8G4eEpd3baVNrwwPG3T7qYR29ETlcLmvHvNXZIG4TWI6uQZ/WRe4XqQzzUQSazm
         6IBPpj5SyPDcxOHUZ27Kiq7khCjkeEfbJeUbA6BT0DdnPSSHSScNYlJbZsLKWy7Veuaf
         LYpI1sjWu2KxELfeHYiNKrz44tAd7ChLYpR64Wbw9meArxZ0YZxcQqRWkEjFPuAkrWuR
         oK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=67YF8LAkTfMHmF/4xYtvDZYwRzZrAqbRd318422rBrs=;
        b=qdIHHDPtvGbfL7Kc8w89TnCInfUN4n5FTpnNX+HAxtBaoV3Iy6PkSIFfL85uL9g7Z3
         U5UCXem1LvlgHvHMW+7ULO5wOrRUTlraGU63CEOPKUkmNRt3BPmXezEQym1xO3x8fEdS
         YfQqazaoTa+8G0CVqGQ297+w3YmZgyS95NSKo33Kc4iyuuPLkDiXXcIRlCs40UT2F/OM
         M/bMQ4R8ZywIHMlK9/fRUmNI6WkB9CW0yiijsKZ02jFPHWEl51U1rQlA/lbl3KdCGWGl
         gQmYQaicdQO7Nku5Fb3OLepz6z0dMj6Qs3EJsUFEENOnybOSv0ieEaPH8mH/8RFTJzhn
         rZbg==
X-Gm-Message-State: AOAM533KG+z4BGiPWwI/ECQq/F4Tf88HWM4m9FawOr0/9RwYHNlpD60n
        XPoAsJshc+famaNuQHrTP2b7iQ==
X-Google-Smtp-Source: ABdhPJyJYp7TsGzqNrotyZGIGuywGHZ+6MdxUnOEr81W2n3xaTYmNh+EG/ECQ+nN4DEwKaeEZHRcUw==
X-Received: by 2002:a7b:cf09:: with SMTP id l9mr25588294wmg.184.1621963596208;
        Tue, 25 May 2021 10:26:36 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z131sm3621434wmb.30.2021.05.25.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 7EE4C1FF87;
        Tue, 25 May 2021 18:26:28 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v2 1/4] arm64: remove invalid check from its-trigger test
Date:   Tue, 25 May 2021 18:26:25 +0100
Message-Id: <20210525172628.2088-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525172628.2088-1-alex.bennee@linaro.org>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While an IRQ is not "guaranteed to be visible until an appropriate
invalidation" it doesn't stop the actual implementation delivering it
earlier if it wants to. This is the case for QEMU's TCG and as tests
should only be checking architectural compliance this check is
invalid.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Shashi Mallela <shashi.mallela@linaro.org>
---
 arm/gic.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 98135ef..bef061a 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -732,21 +732,19 @@ static void test_its_trigger(void)
 			"dev2/eventid=20 does not trigger any LPI");
 
 	/*
-	 * re-enable the LPI but willingly do not call invall
-	 * so the change in config is not taken into account.
-	 * The LPI should not hit
+	 * re-enable the LPI but willingly do not call invall so the
+	 * change in config is not taken into account. While "A change
+	 * to the LPI configuration is not guaranteed to be visible
+	 * until an appropriate invalidation operation has completed"
+	 * hardware that doesn't implement caches may have delivered
+	 * the event at any point after the enabling.
 	 */
 	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
 	stats_reset();
 	cpumask_clear(&mask);
 	its_send_int(dev2, 20);
-	wait_for_interrupts(&mask);
-	report(check_acked(&mask, -1, -1),
-			"dev2/eventid=20 still does not trigger any LPI");
 
 	/* Now call the invall and check the LPI hits */
-	stats_reset();
-	cpumask_clear(&mask);
 	cpumask_set_cpu(3, &mask);
 	its_send_invall(col3);
 	wait_for_interrupts(&mask);
-- 
2.20.1

