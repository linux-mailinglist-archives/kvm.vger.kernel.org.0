Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38444137249
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 17:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgAJQF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 11:05:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38485 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbgAJQF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 11:05:27 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so2323637wrh.5
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 08:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/DmvPJlY9Tmv4EyIG/NDnFk433eow2vkRfUSRyghGd0=;
        b=ZGts9mEsV07oqMlH5CGwSt00UWM0Vhti8vRXxb5TEq9QRrXQJuYE7jQMZqw8HkyyAS
         sV/PLumRLEtdMsCQeerA3sVA2vS7CrLAEQ7hwe0cIMc+mToYOAxqRm/Pe52vxzA02HfA
         PFPISdEWNRntwUhvfwVSkiVgxtgs3PmKbjkYAEy0e3PN828LfaH9kiQq3ZgPHuJ4rybp
         FNfwTYKFCs3OdjzPHPk1WZ+Oajm3TxK8owHm/HfsLF0DOyMl0QNKjyiyApvsOQ4YH2MP
         UvZ+5hfmtLRzrHEwCA3Sv1mdagoBY/97MR1UDieUNaC6N4CX2GpiamxSKcaDcaYG7V8i
         5vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/DmvPJlY9Tmv4EyIG/NDnFk433eow2vkRfUSRyghGd0=;
        b=BrD4gUk1CER+j7kXJoEWZ6owZmjzuepScGIc+cG6uv5T6/wXXrJR2hT5zyb4qlsxKk
         I1lT/YrtJMI9IJFWEJEOGKDDTP5c8X3rpDRfyhM9iJjoXy4dOBJ5+Rsetmc8YD2S1SsF
         i0TTgifdHxrZ1R5pUahxjxOCKaUdXhmu6fNRnZY4I1nvRko+Rv+xCiqGcPtl/aA5dWkd
         EqRm+EpGcx0rOOBFrmiwIIV50z5p7V7Er8I78EZaS9xa7BIVv5NRB0H+eIohIRGoorS4
         5cWxZL43O7VW2qQv/YeBllpyneiFrzlZ3fZQBUgbuM+ooGs7cpO2L1W/97LqAmPjNA2/
         LTKg==
X-Gm-Message-State: APjAAAUXeGGEL5zmEes98OTAVczXekcbvQv0dECQ993gIuKA+r84ZDvl
        34H56M6B6K58Ni7tInffki7I/A==
X-Google-Smtp-Source: APXvYqwIgQwXtS11bXhGVH9Pe2V3XwcTTGW7CWEBZv0DL+719DfIpRZwWKHhcoYjgXjNyQ3lv3A/JQ==
X-Received: by 2002:adf:f5cb:: with SMTP id k11mr4164701wrp.71.1578672325294;
        Fri, 10 Jan 2020 08:05:25 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id p17sm2684593wmk.30.2020.01.10.08.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 08:05:23 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2601D1FF87;
        Fri, 10 Jan 2020 16:05:23 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH] arm: expand the timer tests
Date:   Fri, 10 Jan 2020 16:05:11 +0000
Message-Id: <20200110160511.17821-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This was an attempt to replicate a QEMU bug. However to trigger the
bug you need to have an offset set in EL2 which kvm-unit-tests is
unable to do. However it does exercise some more corner cases.

Bug: https://bugs.launchpad.net/bugs/1859021
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arm/timer.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index f390e8e..ae1d299 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -214,21 +214,46 @@ static void test_timer(struct timer_info *info)
 	 * still read the pending state even if it's disabled. */
 	set_timer_irq_enabled(info, false);
 
+	/* Verify count goes up */
+	report(info->read_counter() >= now, "counter increments");
+
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
 	isb();
-	report(!gic_timer_pending(info), "not pending before");
+	report(!gic_timer_pending(info), "not pending before 10s");
+
+	/* Check with a maximum possible cval */
+	info->write_cval(UINT64_MAX);
+	isb();
+	report(!gic_timer_pending(info), "not pending before UINT64_MAX");
+
+	/* also by setting tval */
+	info->write_tval(time_10s);
+	isb();
+	report(!gic_timer_pending(info), "not pending before 10s (via tval)");
+	report_info("TVAL is %d (delta CVAL %ld) ticks",
+		    info->read_tval(), info->read_cval() - info->read_counter());
 
+        /* check pending once cval is before now */
 	info->write_cval(now - 1);
 	isb();
 	report(gic_timer_pending(info), "interrupt signal pending");
+	report_info("TVAL is %d ticks", info->read_tval());
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
 	report(!gic_timer_pending(info), "interrupt signal no longer pending");
 
+	/* QEMU bug when cntvoff_el2 > 0
+	 * https://bugs.launchpad.net/bugs/1859021 */
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
+	info->write_cval(UINT64_MAX);
+	isb();
+	report(!gic_timer_pending(info), "not pending before UINT64_MAX (irqs on)");
+	info->write_ctl(0);
+
 	report(test_cval_10msec(info), "latency within 10 ms");
 	report(info->irq_received, "interrupt received");
 
-- 
2.20.1

