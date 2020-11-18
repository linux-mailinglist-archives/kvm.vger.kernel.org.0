Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD192B805D
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 16:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgKRPYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 10:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRPYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 10:24:55 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DBDC0613D4
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 07:24:55 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id ay21so2426563edb.2
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 07:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwP65fTRBjJQOZTuLRa465u12tCsPFehRRoZ9l9M4Ak=;
        b=OEi1SA2lJD02HfGZ2ZOAcIlcEsEk+vn6Xl4rPm6qVoAEKNoFe/590nTKkN6CYxoQkT
         4KA/Leefb5ifFrFJujfvTIR3BHZKTEojrX6RjUhTIuKqARH8AHmHYsScHT5FqUtrxwbz
         rcwIi2hZBqpH3CsyoCeTd3yWkfj57/1iojTSRIbC9iVU6w4l00IDrOS5Cl9/6uq5UNkk
         Wep8htTKSk6DFZEjouS6Bg9VEvqSqcrd9+884MZWKkemMu2bGxfQ71pX86R6AKgJiUX8
         t0VWD4GZFiYVhZ2zrfaxNK/ufZO1Bl6P1NSrDML3oLZUJS2JyLgwwdrN2+PJYWj4d8PG
         /uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwP65fTRBjJQOZTuLRa465u12tCsPFehRRoZ9l9M4Ak=;
        b=WEvxWfR6tH4m2zJzVzsQxepbeFGeJCxhpl2Nsm0SMJ3lKS2SKJCUP46FMIswIW2S4G
         hZsGucNTHY6ZN3Mnr43Z4IwkwssJ58UaDuh2hDEci3w+qvJqmuhaDxSDfjii9kVFnv+g
         xfcrVDYs5E2sz01zFE1iqR2c/d0cBV68iTejcTFNJiOG3LuehuJ2q60QT17/G3stsPaD
         PHdNjiF9eosO+sQfvyUuiuyvZNG7cEZkrmIRJ/t3IjxtMx0LodOp0EiVFrbFsKpmH1Tu
         71zfFObfbcbgzsd8NFKjiuL7v51rEWV41IQUwYXEj3uRYwfzLOxP0bpAsHQ60uNGJNWA
         D/4Q==
X-Gm-Message-State: AOAM533bZVB7X4I5HakolvWxpRxO5z0G6oeLG69ZUuGaJVzq1sXh/YOk
        H3jXjH6ITtu6f3mE7ir9InA=
X-Google-Smtp-Source: ABdhPJyW7tBCD+0GY8Fjihq8azddmx2u+UMZVXLscO0Zd6/pw3sTE8CszjTP3lut2/wjGRvOYLFKcQ==
X-Received: by 2002:aa7:d502:: with SMTP id y2mr26671308edq.120.1605713093726;
        Wed, 18 Nov 2020 07:24:53 -0800 (PST)
Received: from lb01399.pb.local (p200300ca573cea22894fd6f5c6d10f88.dip0.t-ipconnect.de. [2003:ca:573c:ea22:894f:d6f5:c6d1:f88])
        by smtp.gmail.com with ESMTPSA id b15sm597083ejz.114.2020.11.18.07.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 07:24:53 -0800 (PST)
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Subject: [PATCH] x86: remove extra includes
Date:   Wed, 18 Nov 2020 16:24:47 +0100
Message-Id: <20201118152447.7638-1-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

Remove extra includes.

Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
---
 x86/vmexit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/x86/vmexit.c b/x86/vmexit.c
index 47efb63..999babf 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -1,7 +1,5 @@
 #include "libcflat.h"
 #include "smp.h"
-#include "processor.h"
-#include "atomic.h"
 #include "pci.h"
 #include "x86/vm.h"
 #include "x86/desc.h"
-- 
2.20.1

