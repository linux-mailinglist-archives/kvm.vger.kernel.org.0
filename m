Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5841136D5A3
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbhD1KTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239186AbhD1KTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 06:19:33 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1865AC06138A
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h4so53384776wrt.12
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIGl3K3qE3k2BXQSfM80xkGe4hRnH3OA6tpOjjNrd3E=;
        b=Tocu2ZsTcx7VJN6+MVikFztL2wEkgN20wGnOqWs/UwSTwQ8IT1wNoZoLCbL1uytn3f
         qCa6ykXIJ39hLu4V+KCW1lOlOmcToymqvCX7t0lR3o87WapMMqa8pTdRKzo+7J5B3GdX
         cdiIdktldMin4hXEw4px5yAX0xr90WWmxO8smtcZti/I1/LApf837ST2k6Au1cXg6Z5y
         ZmqDDGg96rXNe6zD9MZlfwQRtM+smRh0A5U6Y4j93mTVpC8y5NGpu6NsLMBfYp2NIj7k
         1sGEevKSlWBdzR0UJhugw5fzOXmVcF5hl8CdGbdCsoEuHBke8NPjMo+982KpfVcXN8mH
         6ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIGl3K3qE3k2BXQSfM80xkGe4hRnH3OA6tpOjjNrd3E=;
        b=figzsppJRl0xHkm9kxfkXyTEy6ZDOifpooC7AnKPKBt+nf1WVkxstLljarlOI28qGW
         ztPJn+a8aJ1V6Z35RgB3LemwnUwSMS8iHKSUoWL/j/QgBiCvd2dj7c4oCJYD+NriS9Sj
         RxO+JGe+T8Gnq9mWMoVNPZ7o3XTQGRGRTuOLMdhS7GKissUs3CI4oxlG3wSoCqjfGcCu
         4zuQB92EaUx6ySKpkq3qHJ5YjnxMp6RFtmWK+xBiMe0635u3dZ9Ug5GT7g0Ovq9XO1ft
         1xqCSHtGoXPHjfcpcDBJBSm/HcnZ+i4TS4NUKnaR5CZz1N+POb/3SYhPSW0Odzjgfe8w
         d+dg==
X-Gm-Message-State: AOAM532jwolrgDmJw4SJehGkLamNO73Zps3yZu8LXwjCjgEBJINDyn/M
        LQxd57obKFclUWJUBPS0MLEAyg==
X-Google-Smtp-Source: ABdhPJzY9oNGXhOxLJCihSwIGFeQ6N62MW7ZFy5SInbOGtC3xunUNEQ7q6CYNQ8xm6AW5+ASciIkSA==
X-Received: by 2002:adf:fdcd:: with SMTP id i13mr34506297wrs.185.1619605126850;
        Wed, 28 Apr 2021 03:18:46 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id s83sm3294855wms.16.2021.04.28.03.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 343B41FF8C;
        Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v1 2/4] scripts/arch-run: don't use deprecated server/nowait options
Date:   Wed, 28 Apr 2021 11:18:42 +0100
Message-Id: <20210428101844.22656-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The very fact that QEMU drops the deprecation warning while running is
enough to confuse the its-migration test into failing. The boolean
options server and wait have accepted the long form options for a long
time.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/arch-run.bash | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 5997e38..70693f2 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -122,14 +122,14 @@ run_migration ()
 	trap 'kill 0; exit 2' INT TERM
 	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
 
-	eval "$@" -chardev socket,id=mon1,path=${qmp1},server,nowait \
+	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
 	# totally breaks QEMU...
 	mkfifo ${fifo}
-	eval "$@" -chardev socket,id=mon2,path=${qmp2},server,nowait \
+	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
 		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
 	incoming_pid=`jobs -l %+ | awk '{print$2}'`
 
-- 
2.20.1

