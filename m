Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271BB390796
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 19:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhEYR2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 13:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhEYR2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 13:28:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05265C06138B
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:34 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v12so33088214wrq.6
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bomimE0My6Mrc6nvo4jcRDAsXmDo+wwewZnyFoFd9Qs=;
        b=FMU3n4mKiMC3eE6glB9HkdZs5xGVasuZxHEKqdM/ZsUo9pAs9YMC0neSuF+Ad4JaQu
         O88qdfYxChF9eRWfVQZw64sa8ZI9BKW7CWCRiAqRdStismovf1xTxHSSWqqdGD6xj7+q
         rr/tfKCh76T+FN2hk5qG8+FdqSF4lkjcAziSPkgHUhRHGdO303tRrJG5RI72coSG9k5a
         qbl7GD+uFYxxlnYBCk5Sfu7AvYCvVY+1X2Q5F7syHfgO+DZYxycLf0HOBNP0HI7iktF4
         AHSeVjT1IVoMj3glEHdhLhRY7LBmHGht6jWbh50NnddoxvwHtiqKvlNzgUOzfUCyYvEU
         K2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bomimE0My6Mrc6nvo4jcRDAsXmDo+wwewZnyFoFd9Qs=;
        b=Yob7DpR9/kSMk1NG0UoGaDgH467KXwm3pntu3YsBlROpT+r6MMBciLJJbRPLROh7Pl
         6EjDIRF7TeFMSSKCQaqhY7R92c+91BQOi25Ss8YQWgJ6PvOaMRW+D2yFJaaZA5MrzXnV
         BZkEwD8T9MemB61sza8oYFIaJ6BKK2+BjIOF33orzO1eK/u51k8XWd0yqdde+b39slGY
         ThOzLA2E5hQOkPR37Z0SZem5LMU07UZkOonAVdlszvpPJ4el0MeGiacf6dwRbWiluX5E
         i/rIyNdJJqYL4oNIFxyxZy0QrQe29vObDG3C4ymV0/cKfYJhtCRRMQgUWTz1x7kdPal2
         uMog==
X-Gm-Message-State: AOAM532t6dfQ7BIYYO6i56NQ6YAW1NHO0PAaBPFjoG5ApUBfQLfJBuiZ
        +CFI2cUjq9BDNvX4Q7pmjRk02g==
X-Google-Smtp-Source: ABdhPJxOcc28Mui0TDrzYURL2X6tyH8HpOBr8o1aIEP2vFUWuQdcnhbd2edMaLArv+UiTrSyKo6ekA==
X-Received: by 2002:a5d:6910:: with SMTP id t16mr28171481wru.416.1621963593368;
        Tue, 25 May 2021 10:26:33 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id r17sm3575630wmh.25.2021.05.25.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 8AE6C1FF8C;
        Tue, 25 May 2021 18:26:28 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v2 2/4] scripts/arch-run: don't use deprecated server/nowait options
Date:   Tue, 25 May 2021 18:26:26 +0100
Message-Id: <20210525172628.2088-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525172628.2088-1-alex.bennee@linaro.org>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
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
Cc: Shashi Mallela <shashi.mallela@linaro.org>
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

