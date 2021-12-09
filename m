Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F07E46F30A
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbhLISaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhLISaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:30:15 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C582CC061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:26:41 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l10-20020a17090a4d4a00b001a6f817f57eso4320488pjh.3
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=n2bOiv8CXnwGhufBSmoE6lLccR97AE1d7ZqfbzwAqfw=;
        b=iboxzHZDi/xT7CpvwaQXMZ2tLJ/Z5/IbHOI0qIn9DYEtMHkJPA7XP4aigMXgT+ZmKI
         m/o77fGELMoMzDtsoZSAoxUdRRTUEEGznpMQa/Tr3K83cuUUJtZP8SvyRdKOrBH8Zto1
         0zwYiNKObwP6KmmqFRxm1XMgKqTuB+u6FglFNoh2NbaFXUTqo7ruQDcH5BAz6io9ng2F
         ieexWientxFAv8i3EmzZfCNOEAPl4BNgdrUFg6XepD1aaGUPG8ug7UqaXd5rqpXuY8vK
         MCIhKZB2sgDb2j7xCwYYEDsgROq6TbDc/EsuK2cenidUwVrcfjgPaSCI9dGanQHEHZZ1
         8Dgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=n2bOiv8CXnwGhufBSmoE6lLccR97AE1d7ZqfbzwAqfw=;
        b=QeRarVdPFLtXpLz9gOeQoxprf45SiMYcV3f4OwFbSWiXv7zxmBshlL3kQqqwRL+4cs
         DgWxOIUPm7th1hSitlLDfEIt/xdC9WCWo49wFok6dgy0hfuwLRotQcEJcWd/fcX8X5Pz
         A2Yfx+zVHHdGiJdi0RR+YwcBN7X9uDpW3KVb7M+FFZAjEi8shN/iFRr719Os6bgypnOq
         rw6yd5p/MXTWXnRZ05fvDkxnHHIw8rywGTpGvGTZMp03485dGN0bLeq0Vyo/E+pI8gtp
         787AUFW60fj/mS9stx7XOep+vV4jW46r/EMLUNNanfBhh7Ow1SIX628IAE6zEbb9+zFS
         /H0A==
X-Gm-Message-State: AOAM533T207SxaGW+4lr6ksRyFzLVbQcno89+oeYDMx2eWNtcB6H9sqD
        78bbckY3H21T64ryG17JhDzjIJc7m3qdPgXPM78leS7uWx+p0UG8MWb7F+CzqIs9IG22eNaKoTZ
        anBpo0wJJG0D2TyLH/WP1mPx5zQ4TgzNH1cgntPutu2EznF1nFU2W6rHGFwsv8UdukCTM
X-Google-Smtp-Source: ABdhPJyVisgwaLbD4MQNFd4WoRICIMIdwPPQy7ceLr9F8Z1hkQaw+nPDFoxtdwEgNoEj22MXP3aACcm7rg5fuBlC
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr1024648pjb.0.1639074400556; Thu, 09 Dec 2021 10:26:40 -0800 (PST)
Date:   Thu,  9 Dec 2021 18:26:21 +0000
Message-Id: <20211209182624.2316453-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 0/3] Add additional testing for routing L2 exceptions
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a previous series testing was added to verify that when a #PF occured
in L2 the exception was routed to the correct place.  In this series
other exceptions are tested (ie: #GP, #UD, #DE, #DB, #BP, #AC).

The first two changes in this series are bug fixes that were discovered
while making these changes.  The last change is the test itself.

Aaron Lewis (3):
  x86: Fix a #GP from occurring in usermode's exception handlers
  x86: Align L2's stacks
  x86: Add test coverage for the routing logic when exceptions occur in
    L2

 lib/x86/desc.h     |   4 +
 lib/x86/usermode.c |   3 +
 x86/unittests.cfg  |   7 ++
 x86/vmx.c          |   4 +-
 x86/vmx_tests.c    | 211 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 227 insertions(+), 2 deletions(-)

-- 
2.34.1.173.g76aa8bc2d0-goog

