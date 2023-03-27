Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2876CACD1
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 20:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjC0SQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 14:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjC0SQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 14:16:11 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6CB30D2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:16:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id cn12so39869488edb.4
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679940964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oKuXRsAD4EykgSCkJHDvTpnWgWwPM+ZpJ1iPwBllBUg=;
        b=j3UniUKGaF0Zh8eqFtv88GYhaOFJx4S94K0vJdoeSQxd0eePkEyGAzyUbqF9D4tONp
         Hp4mvx8MEheNbrR6iqALm2VYxAA/oV7C1fh1hDkuIreieAv7FZj6hUFnd12vG8Eyj/L7
         yZrZaOXtc9Oq19AmJw1jFDDAViqrDFVvo40R3w8tvvYhoN6pF3Ijr3KAwQ/Ukeza9iAq
         HsnIe2+SrwgqgSG2cqUWUF4+CrkbbCbt9hDof3vPiZBS0tzV0L4jgUaVrSxADExTS/OE
         0zAGeMh3IWfCt0HpSZ3jWgNl/Fp28OhbSltUySTHqBB++aWNgYYlznYAjkeMy4SDOnDT
         RCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679940964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oKuXRsAD4EykgSCkJHDvTpnWgWwPM+ZpJ1iPwBllBUg=;
        b=lcrE2WKwrrNDc5YLVq/yr300eLXy8ulu9xVhhQbzVy61Y1olwgyWbdgjYZ/OEmwqUP
         enp8LPl/GPBymjb3gHIQqMihEAOkptXQI9aDaaaBVxnqdK5F4dLSZRo86kxss2RuhDJY
         Hu6gYurMN6IThmE7+ixky1YVyW0gspO7II/HIdqxu+vRKxMle8iNdxWszC8O8ms1N83D
         LI7O9xV1AtNUeES8OpWnwiw8IlQF6/Qgzmt6S46LMW9KxJnk0q4b8vfHhwVXWuOaTRLY
         u61mgqBkqDj1kSzfmm+81vfg4xy1yyyfTxZPVCBAmraMfpfOMXMopmv01wdY9c+LV8lU
         IfHg==
X-Gm-Message-State: AAQBX9d/BZBYWikKsMwREq8oBv1uRo852EUSnZeU5uliSkFa/wsXAcI7
        jEk8dDqFCMkSHcgKZOMYHJckUhnSU4nPzcMP2nY=
X-Google-Smtp-Source: AKy350ZS1GovPKOIBQZzeRb6vA6gyIpbu5RAUK4tgkZiBZhsgeTs1gHoz5rfwBo7F4+/3ngHC9KQbQ==
X-Received: by 2002:a17:906:d8d0:b0:8bf:e95c:467b with SMTP id re16-20020a170906d8d000b008bfe95c467bmr13133605ejb.63.1679940964559;
        Mon, 27 Mar 2023 11:16:04 -0700 (PDT)
Received: from localhost.localdomain (p4ffe007e.dip0.t-ipconnect.de. [79.254.0.126])
        by smtp.gmail.com with ESMTPSA id 22-20020a170906309600b0092f289b6fdbsm14245396ejv.181.2023.03.27.11.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 11:16:04 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 0/2] Test for CR0.WP=0/1 r/o write access
Date:   Mon, 27 Mar 2023 20:19:09 +0200
Message-Id: <20230327181911.51655-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This mini-series adds an explicit test that verifies a page fault will
occur for attempts to write to an r/o page while CR0.WP=1.

There are existing tests already, e.g. in pks.c, pku.c, smap.c or even
access.c that implicitly test it as well. However, they all either
explicitly (via INVLPG) or implicitly (via CR3 reload) flush the TLB
before such an access which might lead to false positives if the access
succeeded before, e.g. because CR0.WP was 0 before.

Better to have an explicit test, especially to back up the changes of
[1].

Please apply!

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/

Mathias Krause (2):
  x86: Use existing CR0.WP / CR4.SMEP bit definitions
  x86/access: CR0.WP toggling write access test

 x86/access.c | 57 +++++++++++++++++++++++++++++++++++++++++++---------
 x86/pks.c    |  5 ++---
 x86/pku.c    |  5 ++---
 3 files changed, 52 insertions(+), 15 deletions(-)

-- 
2.39.2

