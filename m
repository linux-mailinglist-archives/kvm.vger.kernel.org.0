Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F115B399F02
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 12:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFCKfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 06:35:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33991 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhFCKfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 06:35:12 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1lokfH-0007b9-MK
        for kvm@vger.kernel.org; Thu, 03 Jun 2021 10:33:27 +0000
Received: by mail-pg1-f197.google.com with SMTP id k9-20020a63d1090000b029021091ebb84cso3690616pgg.3
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 03:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6hOw8ZMvOb7t6yVIcQ/++LfdOOzYcsbqo189jjiBR1s=;
        b=UVT3kerm7/cVZzu1ReRZteUXICylee66rX5nWqITxMtC//RplzhN8NuU6Y9iJAcDQ7
         ArXWWqxjjNTaRFGgCbaKA7XseUFoZQINPprTgit2X/53tmq63FEHgXxgrz1UabW2Ra6N
         T6M03D/6wJUiyQqvwzdCmT5p08qMe54ogNnpDLviuU7Y7MyRF8mcZchT8ukjv7qL9l0r
         RdL2ZbscMKQsQM0K+3zxb81CQXfDP1lgaRnVMd4sehZjDz69SabI1uJHn844NpJmgeqF
         EYoJpPhprUZ3Rc/dOk8tveAu5ZHiLNeZBFBOx+VFD7xA9cbEsxN5Yw9ZZCCFpPS2n5ZM
         Zm8A==
X-Gm-Message-State: AOAM532m4UCV3UxMXJxA5gqMOlyJaINv4QFBtuIL+JzdTyIilBJ0TowB
        sjlAL/hvgjhF07ALF7OyJ5Ick9gxFN+3aX4C9/ak4LPpbqCXrrL1x2ohQtDDRGoVyHf71BI5UgM
        ADsH0IvK6+bpG6b03bbE26FpaMzMY
X-Received: by 2002:a17:90a:4298:: with SMTP id p24mr10509182pjg.144.1622716406247;
        Thu, 03 Jun 2021 03:33:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0bxK6C1tGvB1stbWTD5+gYFHThVZm9Z+X2VYpvGcO5qDJadPW8z88ya3JeocNGEnK22QGsQ==
X-Received: by 2002:a17:90a:4298:: with SMTP id p24mr10509161pjg.144.1622716406033;
        Thu, 03 Jun 2021 03:33:26 -0700 (PDT)
Received: from localhost.localdomain (111-71-50-125.emome-ip.hinet.net. [111.71.50.125])
        by smtp.gmail.com with ESMTPSA id 195sm1987651pfz.24.2021.06.03.03.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:33:25 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kvm@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, cascardo@canonical.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH 0/1] x86/hyperv_clock: use report_summary
Date:   Thu,  3 Jun 2021 18:33:04 +0800
Message-Id: <20210603103305.27967-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nerr variable will always be zero in x86/hyperv_clock.c
Remove it and use use report_summary() like others instead.

Patch source:
https://kernel.ubuntu.com/git/ubuntu/kvm-unit-tests/commit/?h=disco&id=4b9cb37424b52ba94afa627675a1f780957218ca

Applied to kvm-unit-tests master tree with 3-way merge.

Thadeu Lima de Souza Cascardo (1):
  x86/hyperv_clock: use report_summary

 x86/hyperv_clock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.25.1

