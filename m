Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB7B49536A
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 18:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiATRjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 12:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiATRjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 12:39:09 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C8DC061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:39:09 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 1-20020a17090a0e8100b001b2a885e155so3043129pjx.0
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YE99vojQD2AxPQSWB/44jVS0Qb0ZYbLu9xs6WG/RgmY=;
        b=D6LYnL518npfbdVeQXIesu0zquom0i1+sfkMdjABkguXDWxwAoLo4dmjtrX4/t1fyC
         SfUBX9J6Dv+QtXM06M8qeaEifOHS7MWiLcAPaa4Y/3VQXOBRz7OXK2kdJAFSQEcXIA7c
         cOCHmddd1EMevUnWCjZhIZDO1ES2jg2QsLwyqLmK2HHa/Hlvv8p52tahLZFbyCFNYWHi
         lbQxzJE/dNOf17RGJqptAa9304lgCY1U7RMGpjIlRzATlJHnrN/ZNdphWq1qEPSz1Ai0
         qFSql/7qsjaaLC3Zq/UTrUU/+L3QH09L1VYK4hotZTzDtTwr3fcVyco+9q7Mvy8fB4P8
         GT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YE99vojQD2AxPQSWB/44jVS0Qb0ZYbLu9xs6WG/RgmY=;
        b=0I9HBOUBtGezWRhVDM4XByrys9sYKMzI1iDTTii5SCPQVUBVDJMKestIm+Dvw5U9Af
         jIdWcGkz4HjSPQl4TKw1E8MmciH3kxzD8Yz3OonJSfUF7zYp/EHFws2fUfhAV/c/ZYDC
         1oUQl3mky/eZB33QLvZ90TFmDYNRYJAczYXVvCWTqO6uCTqfEaQBmhPVav1eX0bF/9y1
         rDJxxmH2JpauEBIS248wfWhzTzLpJEYbWSQ5KZRnKhX0qwh0kUXocgm/R0xC8V45bJk3
         8g64uIdYFQx3W0JAgEwYOWJkJIQfIwJbPO33Ya1bBKaPMjB8HopmBIHkr4ekXr7I1W3u
         sJaw==
X-Gm-Message-State: AOAM533coIqXmtglMoCoyO8J676m231wnf6SgL8bzoQp8sJfvj14TsOQ
        qhcDFFuqrYmnX+sKRDieK89qPI+O55Ua9o5NDxwk+GNqVo8EsXRnQJvPoB3oQfnhcey6CENrXbb
        ufW8CBgEW1/ZpvgzviDzOe0FJJHGfNQGVlwbRwDo4N0bzQ7DSA1PQqS61GyXhcNs=
X-Google-Smtp-Source: ABdhPJy97Lg4jLb/CtetkWy0ICvzz47NCQ+mT9Hlb27wuiusZjTfw0b4KdBOMMenlF8DLQ82HlI7DiWyqcF07g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:81cf:0:b0:4c0:6242:c14e with SMTP id
 c15-20020aa781cf000000b004c06242c14emr3040pfn.83.1642700348410; Thu, 20 Jan
 2022 09:39:08 -0800 (PST)
Date:   Thu, 20 Jan 2022 09:39:03 -0800
Message-Id: <20220120173905.1047015-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 0/2] kvm: selftests: aarch64: some fixes for vgic_irq
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reiji discovered some issues with the vgic_irq series [0]:
- there's an assert that needs fixing.
- there are lots of comments that use the wrong formatting for comments.

I haven't hit the failed assert, but just by chance: my compiler is
initializing the respective local variable to 0. The second commit is not
critical, but it would be nice to have.

This series applies on top of:
[PATCH] kvm: selftests: conditionally build vm_xsave_req_perm()
The aarch64 selftests fail to build otherwise.

[0] https://lore.kernel.org/kvmarm/164072141023.1027791.3183483860602648119.b4-ty@kernel.org/

Ricardo Koller (2):
  kvm: selftests: aarch64: fix assert in gicv3_access_reg
  kvm: selftests: aarch64: fix some vgic related comments

 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 13 ++++++++-----
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
 3 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

