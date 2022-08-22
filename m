Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EFA59C2FA
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 17:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbiHVPiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 11:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiHVPiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 11:38:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967A8E006
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:38:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l64so9735811pge.0
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=Bt5OnuHoLWMmd8kWNIJ/R5jWGGMn2gQUophJ4PVrMCg=;
        b=fvF+gFPMHXSzZ2rxnbVbmlqbZzCjGLs8sY5IGMml5u19eXbT4Fe2OtznxVD33u5aNG
         vOWMOpFYCTJ+/vCFKo7KJhdaDy5CplJb0XV/dC654VlS4WSBviGxreR8iGAkNe7Mbumo
         w6X2GHo9ZJ2gXg1UOJHCmoJI5Zfyl0odRlyqWPzYaa35KZ/bPfaYEGzOVxmb8G79jdEf
         md0mVD//Mtmg/un9R31DFlIYQnLdF4OeR935mGNMXn9t4XvLwAu+EJ0NQWhG01lH/IJ8
         ZZXE42Q3SqTCLk37/3zBnzpvVhyVRLyZofcpqaDPSFboH7+WCaK4hT6Mg43wJ+18MJIR
         9BnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=Bt5OnuHoLWMmd8kWNIJ/R5jWGGMn2gQUophJ4PVrMCg=;
        b=EEVMR4nHVZfzUvHcWll450MEth0W6H6VwhlkYNGO0b970fSsBzBy9aBiDey/Ymx4Du
         bKUR2aM8yyKTaykfgVQ6bWDRVfI13avLFJnGDl5BSUTxHzOOsdbKtBDaSbYV794h+uPY
         bvNeKqT4CtnaIz41GdtcEbgE4Kj7JQoRlJiCOA7ZuYabyf8u863wlTnixDC3aM6h/5/2
         E4DqDwUmn8Lk75bVrAQZgW4tfFuvEcThYXYx2dDz46zHYOa2aOnDh4tJ7tf9Qubwbti0
         UQDD5D5SvX8Q9AFR0y71YLEiShmo5ceLgwyZTcu22w6/hdBdAovJzxKSj77ikjodoof4
         KRZw==
X-Gm-Message-State: ACgBeo1G6E9yAa9dlSvWuzUAIKpD+D53qi//KD+Bzl93zCL4+rNcd2/R
        u82TntXozMlFRLpsuDWaA6YOCP+ysxTaSzCpNGc=
X-Google-Smtp-Source: AA6agR7P+/+DTJ2t/xTSng5iSWdhzJnnvRzAvh3/gCoNoxTkHljaJlQ1uvOjBg5eOXKBRt85rrfzvOpoO9YFtCrERlQ=
X-Received: by 2002:a63:1f1b:0:b0:429:b4be:72f0 with SMTP id
 f27-20020a631f1b000000b00429b4be72f0mr17095559pgf.622.1661182728989; Mon, 22
 Aug 2022 08:38:48 -0700 (PDT)
MIME-Version: 1.0
Sender: dvavsvsvsvs@gmail.com
Received: by 2002:a05:6a10:d142:b0:2d6:7875:e094 with HTTP; Mon, 22 Aug 2022
 08:38:48 -0700 (PDT)
From:   "carlsen.monika" <carlsen.monika@gmail.com>
Date:   Mon, 22 Aug 2022 16:38:48 +0100
X-Google-Sender-Auth: X5c8H_gKQNi1WVqi3w8dIxIyBZU
Message-ID: <CA+hPWRNaxb9zJUQtF78H1MtJG0QkQs1-0rQzchxa5zGTBfHXDw@mail.gmail.com>
Subject: Dearest One,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.2 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:542 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [carlsen.monika[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dearest One,

    CHARITY DONATION Please read carefully, I know it is true that
this letter may come to you as a surprise. I came across your e-mail
contact through a private search while in need of your assistance. am
writing this mail to you with heavy sorrow in my heart, I have chose
to reach out to you through internet because it still remains the
fastest medium of communication. I sent this mail praying it will
found you in a good condition of health, since I myself are in a very
critical health condition in which I sleep every night without knowing
if I may be alive to see the next day.

aM Mrs.Monika John Carlsen, wife of late Mr John Carlsen, a widow
suffering from long time illness. I have some funds I inherited from
my late husband, the sum of ($11.000.000,eleven million dollars) my
Doctor told me recently that I have serious sickness which is cancer
problem. What disturbs me most is my stroke sickness. Having known my
condition, I decided to donate this fund to a good person that will
utilize it the way am going to instruct herein. I need a very honest
and God fearing person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained.

I do not want a situation where this money will be used in an ungodly
manners. That's why am taking this decision. am not afraid of death so
I know where am going. I accept this decision because I do not have
any child who will inherit this money after I die. Please I want your
sincerely and urgent answer to know if you will be able to execute
this project, and I will give you more information on how the fund
will be transferred to your bank account. am waiting for your reply,

Best Regards
Mrs.Monika John Carlsen,
