Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86FD4E8D01
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 06:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiC1ESF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 00:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiC1ESD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 00:18:03 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7D645069
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 21:16:22 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id z134so10349178vsz.8
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 21:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=3uXPBCjbKDf6MSQFK1r/Wo1P1Nt4GLx/YIZIqkOYc8E=;
        b=Vw3aw18g3+k1cS80+iiA3ML5SCcImG7PMpDNrq3wLPssHqD08mt7gBtIM4MX43Ze4z
         8Ho91xd3mt8fwTCJ6+okPhe5CKUkn1OAFqlYbDBW5YYZLHkBL7sSdNE8QuhjAwPb5qbJ
         l0v3L1Rkz4v+YsFiCKUscEJwXyykymDClT7yX1CORNGipF0/vjv/HuImZeoC+GoOGxHs
         ajF5FGDqrl4/NM27Sq6m7CHnbkFC9LR/mBxYI9k3xQqwt7tLJtJ25w6La+tAYtfqQSDN
         7qhmzRCo0S3Ymut0b6S0vgwG/5TjRvn3lImp7in4HoaqewwmlVQlG+jukIB2ZI5ooyel
         daWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=3uXPBCjbKDf6MSQFK1r/Wo1P1Nt4GLx/YIZIqkOYc8E=;
        b=jOv3S/OJ82iUZbSsEx+JYR1qD5tj9D1FBiQv2PfdSO3sFTm1DQ7DkKMJOaV3oONnOW
         UcqqEkUEGAcW/rBEmUu9sgslG/IFRr+knbz06kZ3/IyEedCkI82GCB3KNQQanvO3IE7t
         +kDNWE8WaQzfzLV1sM4NKeWYaUhlIFuckByJPE88QFtvr3X48Y4ifR0m7UFx9RMy/Mzv
         ykN3VZf7eSQ0HT5J7auOjJqIEyw/4pfXrfJvIAv9uRUbKfAwvnVQkVl3rusEHeSdGJRc
         nzctk3WX8yFHPiZoe5u9nhEqhUtcw1blaQZc5OVQEZM8Can4Ulm9TdgV9ujJYxjeVlg9
         5c7w==
X-Gm-Message-State: AOAM532UALQEDFgKuYih3JwEgptCPoR6A389lc2zmqDWgGiVSwV+ljlK
        bI83/rPyJvgJSI8Vjg3IhxAY3OtpTvjBs0mdEF4=
X-Google-Smtp-Source: ABdhPJxWfW7bJPAusBkxFk957bTfTTL6VMz2n/EkyFIdrpTMArVia79KK5xw9YAckEt56bWm38/KPbbV/iHUn6DJmU8=
X-Received: by 2002:a05:6102:3bd2:b0:325:44ac:69c3 with SMTP id
 a18-20020a0561023bd200b0032544ac69c3mr9451710vsv.63.1648440981449; Sun, 27
 Mar 2022 21:16:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:218b:b0:296:de20:52fd with HTTP; Sun, 27 Mar 2022
 21:16:20 -0700 (PDT)
Reply-To: michealthompson2019consultant@gmail.com
From:   "Mr. Michael Thompson" <marketingproposal15@gmail.com>
Date:   Mon, 28 Mar 2022 06:16:20 +0200
Message-ID: <CAEBfSqnuG56-xq3=WuB9mGf3Vu2ENxqthvNoKf6NgUeCvvTJNQ@mail.gmail.com>
Subject: Lets Talk About Financing Your Project.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e42 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7100]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [marketingproposal15[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [marketingproposal15[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ATTN: Managing Director,
Sir/Ma

My investor will sponsor your project. My name is Mr. Michael Thompson
a financial consultant and agent, I contact you regarding the
interested project owners and investors to our project financing
program. I am the investment consultant & financial officer of a UAE
based investment private business man who is ready to help you with a
loan to your company and personal business projects.

We are ready to fund projects outside the Dubai or Worldwide, in the
form of debt finance, we grant loans to both Corporate and Private
Companies entitles at a low interest rate of 2.5% ROI per year.

The terms and conditions are very interesting. Kindly reply back to me
for more details if you have projects that need financing, get in
touch for negotiation.

Kind Regards,
Mr. Michael Thompson,
Email: michealthompson2019consultant@gmail.com
