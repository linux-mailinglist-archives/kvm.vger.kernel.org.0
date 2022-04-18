Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E45504C8D
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 08:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiDRGXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 02:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbiDRGXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 02:23:14 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E50A1837C
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 23:20:35 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e604f712ecso106527fac.9
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 23:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=gT0qunonoqmQDH3Sx35AGkd9jYv/vMqV6NEmgNMh3r8=;
        b=HDPRS5mn5s7IzGQybNJ4swsg6ilFjlwKBPL6JZweYZTD0y3H89nplqH1OqZDIXjfoz
         BIdYjIcYj1N0SftSGiIhI1KIYMuHOsEdEWtWm3zZdH/J67L3OCnyfkfg4FfJxQyc8Pkx
         KfojXtnnvDK3sFeZsMb9BMyA1VoV32sjAGsSN0Dcq09mqmpfMrl836dZ/4SsxgLuw1w8
         Cly2VpoX1C/cPc6FEX+XRKEQNGSFcyF4C+4DHOaXm4J8lu1AlACEtWhyNR5qUFzcuCAm
         JctxIKTXGnXeUjKLTQJMunpFV7GwoB0zFGhtqkdKAV7bPwEk3ohhuPviW5f7G6kD3QbA
         RUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=gT0qunonoqmQDH3Sx35AGkd9jYv/vMqV6NEmgNMh3r8=;
        b=PwpDdcwxudSp54rVrkKGKxquDHob0rk7OAnLO4GA6Kwt+aA1owvo+9m6Tyb02+N0+A
         peGs4R36YOR1Dy0Nt+rSrYg0I1np94iFDMOO2+HMslYXbAZkWqH3aEV7fy3g7lSnlL/H
         h/Ge32fLfESc5huC1OChQ4i2Yrw7EpBvK+yG9Kfq0fuS3nRyZJy/azAHuhSZXMXoEMG4
         LYOfbHb9ACfWbKmIhWeUeXb7QHQ0iVljEZv+1Usz73hhEzbmfl9b3bXteEVb23Tg8hov
         hNO89o+Q8sRczg3dy5kMX07n5FqkGfGKfpmrLK3XSqcNZX9AruxOlH2xC3e0WDy+WbPd
         NoVQ==
X-Gm-Message-State: AOAM530HGk8FDtGbQMO3NKsWg+oYJ+93HTV9dPdPImUC8y8dUFHT1iKU
        rWkdu9I2C1vh2SzAjtJkdzqQsbWqeuCVMpSjuYE=
X-Google-Smtp-Source: ABdhPJy156Ei9vodu9MaCqPi2FZBWlsXMXotWSd3Vry8/jG0Ev6GJLseB0/bt6Dty4n60TAT58WB80Ub1JG06nc1FII=
X-Received: by 2002:a05:6871:607:b0:e5:c1cc:31f with SMTP id
 w7-20020a056871060700b000e5c1cc031fmr3111946oan.178.1650262833528; Sun, 17
 Apr 2022 23:20:33 -0700 (PDT)
MIME-Version: 1.0
Reply-To: nafi177z@hotmail.com
Sender: g.prosper001@gmail.com
Received: by 2002:a4a:978f:0:0:0:0:0 with HTTP; Sun, 17 Apr 2022 23:20:32
 -0700 (PDT)
From:   Ms Nafisa Zongo <msnafisazongo@gmail.com>
Date:   Sun, 17 Apr 2022 23:20:32 -0700
X-Google-Sender-Auth: EyBLj86eGjfGdH9Qw9qIqFNVmx4
Message-ID: <CAL_6emfiYny4Yf9td46Tb6PdMphiyhsDam3gH4ZTA4dODTgvEw@mail.gmail.com>
Subject: RE.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4915]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:35 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [g.prosper001[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [g.prosper001[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I seek for your partnership in a transaction business which you will
be communicated in details upon response.

Best regards
Ms. Nafisa.
