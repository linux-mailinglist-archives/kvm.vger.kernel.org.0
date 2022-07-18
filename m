Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3396D5786B0
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiGRPtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRPtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:49:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA480265D
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31e0f1fa81fso43915047b3.17
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8hwXAbTV7Qa4wgHWw/mu6mOGF7/qMo3iMN2FISfVMjY=;
        b=tDbu/3n2A7sX0LInLF6tQ2mZSs3mTOiAz4QgK4s4r7Fc3GLZoH8VInfZWm7NPNXzMA
         xSYhoBx7dSyl5/U6tDUfmYKVDVfFwZ20vVWr4oSKwrOXnQl0yxnlK5v5ztb+T3uMxBhC
         HZc+U45bxGDItNRDTapkcybXZxmfFM4Sn8NPuWszObhLyL5qJGKAhfJAJuBYIOboxE/Q
         /SXu0XpAgSPU1Zi8fjFZ/p3u2/7h09X+G4MJF7+MfGMLvMpEN5O6/Mv/QSDl6vJ6wGl0
         e4aukyv6SY+6N/qFj8PJiPPmWFIIW6AvnL9e/VANyuaqFAAxYWWvjf+UQ7V1CYQFZuAP
         5Xbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8hwXAbTV7Qa4wgHWw/mu6mOGF7/qMo3iMN2FISfVMjY=;
        b=5IWGH1bp7BUUqik2L/adTtjpzv9Y1E/OANJE8Qf1Ni0bbiRpzBk0ezkLkIHTkbw1FQ
         n6aK9ltsaQhdS8eab6XylsAMzv5e2ge6S3DJ+Igw2Jnp7sJI+JijvXl3e9XhiFrpJj8B
         cY4TsNQ9jWlX01RgSN6VCWfJBdZ1si1hcbUR8S/wNThc0qHlo4gGxVRjG5cBiJPwM+MB
         u7zu5t0I3slVRTJeS0J0TNT4ZbodaLnwDtR2SOapzp32r+ZigCrGOwfQVgkEmeh5RGT/
         H1m2HvqeqS8knJ+goFdKDtw9K+8Ac0c5zt1/dYPvEMYz5vGSRmRUwF6pNGtXjqOufqz5
         yf7g==
X-Gm-Message-State: AJIora8Wvy/DNFgY3h/tcTOjEEqLnU5EyNfYOhGM0bN9furdGIm3H7q8
        lmeyGnJj/eGVKawMdX6wkZ4swfeKpu7nHFyFStkGcZM2lsCug7V+56glE/AgWER3ex9Vvqet2Ij
        XIbMeU6qjdv9+Gnud5kvClv0VwoFK7HgmbnBBryGwzxmihON52PuAlYqoycXXPa8=
X-Google-Smtp-Source: AGRyM1vYCzHqQ4m9m06B9lipyzRO7s1S5GtcnbcPAzNt/vma4+jdr/NVmOw55dp+b6E8SRtUqkY7rsVys0SByQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a81:1257:0:b0:31c:97fe:e416 with SMTP id
 84-20020a811257000000b0031c97fee416mr31830689yws.34.1658159354110; Mon, 18
 Jul 2022 08:49:14 -0700 (PDT)
Date:   Mon, 18 Jul 2022 08:49:07 -0700
Message-Id: <20220718154910.3923412-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 0/3] arm: pmu: Fixes for bare metal
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some tests that fail when running on bare metal (including a
passthrough prototype).  There are three issues with the tests.  The
first one is that there are some missing isb()'s between enabling event
counting and the actual counting. This wasn't an issue on KVM as
trapping on registers served as context synchronization events. The
second issue is that some tests assume that registers reset to 0.  And
finally, the third issue is that overflowing the low counter of a
chained event sets the overflow flag in PMVOS and some tests fail by
checking for it not being set.

I believe the third fix also requires a KVM change, but would like to
double check with others first.  The only reference I could find in the
ARM ARM is the AArch64.IncrementEventCounter() pseudocode (DDI 0487H.a,
J1.1.1 "aarch64/debug") that unconditionally sets the PMOVS bit on
overflow.

Ricardo Koller (3):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Remove checks for !overflow in chained counters tests

 arm/pmu.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog

