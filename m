Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471C24341B1
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 00:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhJSW4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhJSW4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 18:56:08 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8D7C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:53:55 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id a1-20020a5d9801000000b005de11aa60b8so6083682iol.11
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OuQUWdMZ3wNkoC64jIPpxVoIWul9rt9StJF3Nf5qPz0=;
        b=QmPZCZimqxlxKsACecjW9qd8vW36E58nMdROwlpio6g0BcqvjG3U2xVCPHZ/vaGP36
         WQfIY+WIfc5MeJ6Q62eKlGfgkUPMcfpTA+fxwDpnbRgGg6VQzM4x478eO9/OYZCfc+XP
         Kk0wxNH9HVkBF/PlX67ipPWydvgJLnKvNpqoUhnKWGZWeJ2UpxHhq1jB9naEo+ppdKke
         QsCnCbolPStXI9YfdvlzQqdaTzWuX/4sFPFa2a1/tv7P1csW+Z3WIc4v5wTHnPuqnsP9
         ZJ8LCXrLUZ3YC3wiWdudThZQN3DVuKcCaLxClqFKfZYr5IQGbv3GjwHgVSdjEzqiAyPE
         lknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OuQUWdMZ3wNkoC64jIPpxVoIWul9rt9StJF3Nf5qPz0=;
        b=uIvt4WMfPpBaHXzDGIvcPvX/muKGWgviJy0y6uwLe3msZXH8fQUn+Q2mwEmerlNTQH
         MjvpQTqrIPtMlCChtBZpNrs7R+L0v+OuIUgSpt2tOOEIqZpmMooew68AUhQsDY+Vfkcr
         fLHb2e6clcMnutm66hqn/PyJ9UxNoHGBTaArYiwl76RKE6N4DvfuUh1zkCqBb50iCldm
         YQzhsn369/7li1ZPB9OX1322DdCpVPtyh3nuvCIWBQuVC7MwvltIcZLsuWZHAvJHMufX
         L3x6bHjToF3vXUIH++XKbGGeIup+rx4lVcfR64/4rUqCbdTcaoFEyc4UOaD6gpkjUqFh
         6Tzg==
X-Gm-Message-State: AOAM530pS4zM3Tqsh6nSBrpQCEUkR4LAVM3sHPLFqJ0Cqbc+QmnzrzRh
        yIyYLqxITm8eSVlRblWrDogD3ncXA8YXlNCfATT6blSNyF4mK35Tj+oVSGuMaIHzT5FMnWPlW4Y
        YaDjj85+irxkm+HT8VWMqt2cNv8tLkehKcPtDP6SMjMeQSOkUIdj4pvNnpg==
X-Google-Smtp-Source: ABdhPJyjS4UfVJezk3g+bb7CcEJolVI//NqMefaWO74xvZDR5q6Wr3Z1Z61lJ1KrNAzpMMhrUHxpK5EDfgw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:13d3:: with SMTP id
 o19mr20177645iov.18.1634684034807; Tue, 19 Oct 2021 15:53:54 -0700 (PDT)
Date:   Tue, 19 Oct 2021 22:53:51 +0000
In-Reply-To: <20211019225351.970397-1-oupton@google.com>
Message-Id: <20211019225351.970397-2-oupton@google.com>
Mime-Version: 1.0
References: <20211019225351.970397-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [kvm-unit-tests PATCH 2/2] git: Ignore patch files in the git tree
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index b3cf2cb..3d5be62 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,6 +5,7 @@ tags
 *.o
 *.flat
 *.elf
+*.patch
 .pc
 patches
 .stgit-*
-- 
2.33.0.1079.g6e70778dc9-goog

