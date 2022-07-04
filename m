Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60CE565AC9
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiGDQPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 12:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiGDQPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 12:15:53 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C97D10C2
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 09:15:53 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y18so9027714iof.2
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 09:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1vXSAvnvwdRE1mv8U6aYKMjf6TxQAWjPVRxVTPQpxFQ=;
        b=AsGUNMiCSxJSnnhk8/sGPdHS4DHHGh9jced8HKJlhFxqaGu5tlkjTiHIbXNAvEfdOi
         OgZSaBdKU/bB7P6fzFKY5naRmsurgoTdM66AKUv54BY5M3VMTjmW8rVPBY41HvQfkQOT
         qqCgu+KsEX7drhEoLn3rZops7/jITRifCi1lO4Rzg/62fiA89Aa7blCbW/zYYBe759EK
         JsEo+XNi/Dwg1ndVKB4YAXL84axWUjtCdcze0RprdmFSpIcTNZ0TKEV5DvpluyOM6R97
         U9F71SNUiRJw6o3SZ6Td5T7ktSBJxtcifqy6+1zzWhn9COhbbdtIIwurKC+7y9qtOR1q
         9zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=1vXSAvnvwdRE1mv8U6aYKMjf6TxQAWjPVRxVTPQpxFQ=;
        b=SpoyNXoTdfsPT2172fQs2v2noWOwkAVhsjrxPj0+bE3pWoN6EBdB01tSfFFE63Nkqw
         rsY4pX8DpD1Rw2374M/EPpNNDMykzB0lRQG96ffTy21VW+ADZB5vWZYN3X681sYpl6DO
         KviJ70U5GGhP9qx1gQ7xv/DnWQ1sE70o8fp2r/PEpkADMKtTFyh9iy3TaM3QAonKoI0r
         mC7fa89ksxlzxrgzeIUTVP/RyCojg5l/dlMaycJuQIXa+rY60T95N5TWK3PFubbeByxh
         juREwOxXS1OKkbbJSmvI8PtRi4xrJsRbhFxXK7qhzNXS+m4XNWA0FGSeMk5JZSB0JVfF
         gCig==
X-Gm-Message-State: AJIora9fwUJ/WD4YQYcY8YiOHqjwInF8vUcd3gjDcRxq5nV8fejT+60D
        X2anbEQnwGiCPVbd24mxN1esvKEDFPwKtxc292Q=
X-Google-Smtp-Source: AGRyM1uhe/d8LtM27O3F0ta/9g/+qjXT9TIL96znokx4pAnkfNUTUeGKZe24hAGN70Vob/s3rsQ17DYq5lLZWJIydkQ=
X-Received: by 2002:a05:6638:240f:b0:33b:f56c:8800 with SMTP id
 z15-20020a056638240f00b0033bf56c8800mr18566447jat.87.1656951352498; Mon, 04
 Jul 2022 09:15:52 -0700 (PDT)
MIME-Version: 1.0
Sender: anyaujunwa20@gmail.com
Received: by 2002:a05:6602:2dc6:0:0:0:0 with HTTP; Mon, 4 Jul 2022 09:15:51
 -0700 (PDT)
From:   MRS HANNAH VANDRAD <h.vandrad@gmail.com>
Date:   Mon, 4 Jul 2022 09:15:51 -0700
X-Google-Sender-Auth: mhv3EwXTj4qFEcWSV-gh634XJlo
Message-ID: <CALwf0ZziQ1_7dcoFKT8g_x9Zgg0VautQUYiFy4HReguSAkEBEQ@mail.gmail.com>
Subject: Greetings my dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.7 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d41 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5004]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [anyaujunwa20[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [h.vandrad[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings my dear



   This letter might be a surprise to you, But I believe that you will
be honest to fulfill my final wish. I bring peace and love to you. It
is by the grace of god, I had no choice than to do what is lawful and
right in the sight of God for eternal life and in the sight of man for
witness of god=E2=80=99s mercy and glory upon my life. My dear, I sent this
mail praying it will find you in a good condition, since I myself am
in a very critical health condition in which I sleep every night
without knowing if I may be alive to see the next day. I am Mrs.Hannah
Vandrad, a widow suffering from a long time illness. I have some funds
I inherited from my late husband, the sum of ($11,000,000.00, Eleven
Million Dollars) my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my stroke
sickness. Having known my condition, I decided to donate this fund to
a good person that will utilize it the way I am going to instruct
herein. I need a very honest and God fearing person who can claim this
money and use it for Charity works, for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of god
and the effort that the house of god is maintained.


 I do not want a situation where this money will be used in an ungodly
manner. That's why I'm taking this decision. I'm not afraid of death,
so I know where I'm going. I accept this decision because I do not
have any child who will inherit this money after I die. Please I want
your sincere and urgent answer to know if you will be able to execute
this project, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of god be with you and all those that you
love and  care for.

I am waiting for your reply.

May God Bless you,


 Mrs. Hannah Vandrad.
