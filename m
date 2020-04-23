Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E32C1B5B45
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 14:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgDWMUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 08:20:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37113 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgDWMUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 08:20:22 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1jRaq4-0002cz-6j
        for kvm@vger.kernel.org; Thu, 23 Apr 2020 12:20:20 +0000
Received: by mail-pg1-f197.google.com with SMTP id v6so4441638pgh.16
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 05:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LOMmPuADZrh+Ws93tGV565v1kJIb9B7z6mtceZFK3nE=;
        b=NAeHr+qlAh2btAbuDdZT7u2TWi13v93rcDr7V4rBeMnXfjDCtm3RDSifMjRrqrj8rR
         C6xGJcXcKCgCdNP92HzNgDAu0WbUgF6pDeYLvJxqSww/Rl3pwmejfCUf3fTgJPQYQtsn
         +52wErDYGi8wywQxHGYU0Xn9bSy9l+cjCOUdR3NheDpgqudSWm+5uDHJJhQUFY9I+FXU
         +930fTO+CrybZArzqA/id8WWGACVDP7xK2flzFakzhSCfzyUljZZKhb5LDAq+/kAvMT/
         5GpDQoLEON/ZTBi5OoD5xSQywXHGPYE0Im2LJIU0glp3+jAh8dpcMRAdlEFI5rep+AUD
         duDA==
X-Gm-Message-State: AGi0PuYC3Bhy2HMarRFy/8EsAxeZlZc+VbzPbEprm3T8C8jb9klgaJIY
        UzDOB5MvqFtQqrc7K6bHsI9Alr4P+ckZqBugvjsvPC9fVD7LM2QcwlLcDX9R9BURlJyV/K0NLyU
        phZlWkLi+sjpan0gQ1P2pXDJdltIA
X-Received: by 2002:a62:cf81:: with SMTP id b123mr3393777pfg.84.1587644418328;
        Thu, 23 Apr 2020 05:20:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypIHA/fkbU7lgZ04x1LRhOgYSwxhyIcL3rNzaPtLF4AYieNVJLjlHJFp8oqipNzzfMIAm1RSoQ==
X-Received: by 2002:a62:cf81:: with SMTP id b123mr3393747pfg.84.1587644417980;
        Thu, 23 Apr 2020 05:20:17 -0700 (PDT)
Received: from localhost.localdomain (223-137-122-118.emome-ip.hinet.net. [223.137.122.118])
        by smtp.gmail.com with ESMTPSA id q187sm2344629pfb.131.2020.04.23.05.20.16
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 05:20:17 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86/unittests.cfg: Increase the timeout of the apic test to 240s
Date:   Thu, 23 Apr 2020 20:19:41 +0800
Message-Id: <20200423121941.29170-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The apic test can take up to 3 minutes to run on Oracle clouds.
Increase the timeout for it to make it finish properly instead
failing with timeout error.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d658bc8..3387860 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -41,7 +41,7 @@ file = apic.flat
 smp = 2
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline
 arch = x86_64
-timeout = 30
+timeout = 240
 
 [ioapic]
 file = ioapic.flat
-- 
2.20.1

