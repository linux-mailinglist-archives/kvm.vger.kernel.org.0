Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F12272144
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgIUKgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 06:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgIUKgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 06:36:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840ABC061755
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 03:36:46 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so12069069wmi.0
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 03:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q2Z7oFogf9Aj/tvuJ/xWjzZlYnWlkqxbhxSK4955804=;
        b=rev57v0d0kdzPOltPtLM0GBO19LlA3oqqUoVIGXisLu6aqEKZ7eRjH1/RRU6+BIzFy
         8TJw/zAsZ4xsvDw0EzHPYOtB5IcJOGdJPQHA2xJD6xTESF5SVm8mI1LWsZ+Wo3PWxTQ3
         pSY2Qn+7Zn6YRDcWl5JVyjZNywEIzsahfS5vrLQzYjE+ceG1NefGptwqM59QgWvN4a9A
         yx1RorCx9hgjGG2ctIeTJ+K1WAo1VWaEyC8LAkkK2+l1mLf0YbPg//tOsAIDcSpclv9Z
         XQycp2+0DnfKegvF4wkMIesw92358E5qXgmNKbrHXcLcYai9H5+4gBVFgDkprQ8MQN51
         ebyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q2Z7oFogf9Aj/tvuJ/xWjzZlYnWlkqxbhxSK4955804=;
        b=MiQVmHcGh0+BZpJmpQZfrNY6X7w1U1zvX9c1ruJpssuwMOs35C1eLGxa7d6D78nyNf
         ZynICVRx5LoJXVokVPSC3XuOstLtWLQbxz6/LfHoGr2yiWXnwpo7om3fhVL0/Ibb84+e
         Keo0dHKcQ9i883rNKG6Npp9VoiqLV2dYg1idd/LOLpArQmqsAmz7kHoFv5fwdn4rjT2x
         CMvJsXZRrQQNE9jBTHB7UoNigoJuQnsByZ57PByZ3/FQBahyjyZvOuAdCQWPLve8Yqsi
         gzYtrBDiZztwkCftXNrqD3yL+u3K6GQI/P03zn6lP/brwg1xaaVMrdeK4l1ebLUHVGdb
         mWUw==
X-Gm-Message-State: AOAM532/Lc+hT+yohmCGh30cAwijIV0ZNSFOiXEiSZHTR9/zo/oFuw0N
        RHtG1foyTb1FYltgtXPny7RqzT1thj5rwTvbleYo5vb2uFiP+IeHa7uv42jvbhRVlKenC/fZIJl
        pkmFEQb6DDfpqFyiSooATos9H5PchULwLmourEBvOJXx3YoPv4GSLsMF29RJDCdKiXw==
X-Google-Smtp-Source: ABdhPJyLe9uvm+3FnIep4Eq0zau4YH8Om9f9IcKerNbiWZ/hLf9WR+xa7cNbRUVuobpiklQ88nE2nw==
X-Received: by 2002:a1c:3588:: with SMTP id c130mr28744472wma.94.1600684605005;
        Mon, 21 Sep 2020 03:36:45 -0700 (PDT)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id c16sm21373461wrx.31.2020.09.21.03.36.44
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:36:44 -0700 (PDT)
From:   Jamie Iles <jamie@nuviainc.com>
To:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] scripts/arch-run: use ncat rather than nc.
Date:   Mon, 21 Sep 2020 11:36:44 +0100
Message-Id: <20200921103644.1718058-1-jamie@nuviainc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Red Hat 7+ and derived distributions, 'nc' is nmap-ncat, but on
Debian based distributions this is often netcat-openbsd.  Both are
mostly compatible with the important distinction that netcat-openbsd
does not shutdown the socket on stdin EOF without also passing '-N' as
an argument which is not supported on nmap-ncat.  This has the
unfortunate consequence of hanging qmp calls so tests like aarch64
its-migration never complete.

We're depending on ncat behaviour and nmap-ncat is available in all
major distributions.

Signed-off-by: Jamie Iles <jamie@nuviainc.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 660f1b7acb93..5997e384019b 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -101,13 +101,13 @@ timeout_cmd ()
 
 qmp ()
 {
-	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | nc -U $1
+	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
 }
 
 run_migration ()
 {
-	if ! command -v nc >/dev/null 2>&1; then
-		echo "${FUNCNAME[0]} needs nc (netcat)" >&2
+	if ! command -v ncat >/dev/null 2>&1; then
+		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
 		return 2
 	fi
 
-- 
2.25.1

