Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45B53FB02
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 12:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbiFGKQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 06:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240834AbiFGKQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 06:16:31 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78D8EBE90
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:16:30 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id me5so33661806ejb.2
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 03:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=DsUpTMVy3AnG06ab2HPPYE6VPm25Tedt2mleq6KKBcw=;
        b=DKOBYe3x/2TowU2RCu7ufo5XNLmz6pzvpiBfnBCkGB+ks7dCiFbT10Yo2DGAkdkTNh
         GUdZv3qCKxaSt196mhPxArCa9N0B/xP/l1+CG3QS0HgJD5lK6ORCxi296t6PhaA4CoBF
         ec6RkqGy1AOnU9hjdMM/00ZJjFrenf5V7vQUCcIdiIyi5BABmwh6QmytfqAyND7i96F4
         j+fIMBH4vTLcPdWea2Cq5YSDrGBPWWgAfJislFGHGXeOQtm02KOv0RyYYdPt7R55yyPx
         N5g3w3CE+0RAWuM8J6ooyaDYMzmuwEERmHv1YhmJZINPV8FU3KRH+B1Hxn+vXUxg3+Rb
         dAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=DsUpTMVy3AnG06ab2HPPYE6VPm25Tedt2mleq6KKBcw=;
        b=6ZWCSKD9cwg+R9bPqtg9iaM49k2BulL1/0l/wBrBv6Z1SvlimrXT8DvPZZ/sWuWOqH
         Chpr7UsxGPiq/dDuBoT5HZmt28s/KdwFah6E/dFJGcVo5OQjo8RJiCo+9+huRY/9Szqa
         qWMkGPfPkC8i4P3eFf16mLHvR0Z7DmU3sjg0rlxdbmSuwQaLILqq2ADr0pJbd8v1tGwF
         EpIHUkmQOcfb8dZaeJDktDpaG8E0aRyRcAuGIX5vDqojG21tMtB2s/E39MeRMdAa7i9f
         6dvnYJSSDAgP5XrEIs8dU6zuII/yYSk79TXhGp75p2Zoz34sMGzzt1z9lfrzIeVZfmS0
         wZDQ==
X-Gm-Message-State: AOAM530hLkmW7mZ/1tvanm3hdnSTfUzxopt7FGsx6L1l60RtTynZIoXk
        FqHkDzhX62LdPXwyUfCZ+0jUPAs+HC86mQGTlYo=
X-Google-Smtp-Source: ABdhPJxxKCzr35+H/bHViECCE6dsoJLYfrP/JTluLu28qgmMJs5xSksMfjlqcb1jtXrDdd0a0Q48nlTDIp1UHFeblfI=
X-Received: by 2002:a17:906:22c6:b0:711:cf82:cbdb with SMTP id
 q6-20020a17090622c600b00711cf82cbdbmr9277137eja.461.1654596988908; Tue, 07
 Jun 2022 03:16:28 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsaijheidi7@gmail.com
Received: by 2002:a50:2490:0:0:0:0:0 with HTTP; Tue, 7 Jun 2022 03:16:28 -0700 (PDT)
From:   Mrs Lila Haber <mrslilahabe2016@gmail.com>
Date:   Tue, 7 Jun 2022 10:16:28 +0000
X-Google-Sender-Auth: QTytQKe5F2Tfv917YhSFg4g0fMc
Message-ID: <CADXrVCoG007dgoB-G+k4qAOOvn3hDPuzOF+Qq0FT+0Z6BRxG3A@mail.gmail.com>
Subject: Dear Child of God
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_60,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,
        MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,RISK_FREE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:643 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7068]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsaijheidi7[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrsaijheidi7[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  1.6 RISK_FREE No risk!
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Child of God,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS
CHRIST the giver of every good thing. Good day and compliments of the
seasons, i know this letter will definitely come to you as a huge
surprise, but I implore you to take the time to go through it
carefully as the decision you make will go off a long way to determine
my future and continued existence. I am Mrs Lila Haber aging widow of
57 years old suffering from long time illness.I have some funds I
inherited from my late husband, the sum of (7.2Million Dollars) and I
needed a very honest and God fearing who can withdraw this money then
use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR
CHARITY WORKS. I found your email address from the internet after
honest prayers to the LORD to bring me a helper and i decided to
contact you if you may be willing and interested to handle these trust
funds in good faith before anything happens to me.

I accept this decision because I do not have any child who will
inherit this money after I die. I want your urgent reply to me so that
I will give you the deposit receipt which the SECURITY COMPANY issued
to me as next of kin for immediate transfer of the money to your
account in your country, to start the good work of God, I want you to
use the 25/percent of the total amount to help yourself in doing the
project. I am desperately in keen need of assistance and I have
summoned up courage to contact you for this task, you must not fail me
and the millions of the poor people in our todays WORLD. This is no
stolen money and there are no dangers involved,100% RISK FREE with
full legal proof. Please if you would be able to use the funds for the
Charity works kindly let me know immediately.I will appreciate your
utmost confidentiality and trust in this matter to accomplish my heart
desire, as I don't want anything that will jeopardize my last wish.

Please kindly respond quickly for further details.

Warmest Regards,
Mrs Lila Haber
