Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1690A641870
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 19:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLCSah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Dec 2022 13:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiLCSaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Dec 2022 13:30:35 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07161DF2C
        for <kvm@vger.kernel.org>; Sat,  3 Dec 2022 10:30:34 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id f21so11425684lfm.9
        for <kvm@vger.kernel.org>; Sat, 03 Dec 2022 10:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fl9EPl0MFXaGnggWqF7B4K8i5posh//Yf8HQA4Rf49s=;
        b=oMeUsk3+lcmUbQzTB8Lqgm5KKCS/BDSavO/jaElJQkyEx3x+h456NWhfYZAMmxxrQ4
         zc8I8McizFJz4Bes8q8YUx8dorIn4IWm47VgNJo/2k1YH9iFHtmVTeH2aDdhNwH9XvBZ
         8hB+jVqtFD3v+VfN+5wzgW0m0Z5YVrLPns8ksJfO+A21mbMMHeoVOLdHObcQCZ4gtF0m
         e/pmiygcWdibAssomhZ6JbPh7M11fuqjPyJRLNmxaNsg2vyWoR0S0fxMTa8NAWoShSHk
         R8dF2IVgMCHaA2deCdxSTp11e7fLIRuvR4rXEzYF/E+kZxem6KzMOgm5rQMpr9dnoRoD
         2C/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fl9EPl0MFXaGnggWqF7B4K8i5posh//Yf8HQA4Rf49s=;
        b=f+oKeacWhUTN0jXhNrOqyTRduz8SgWW2prLxAWysF/b5KMeX4melPAgBtJpGolHUs9
         a18NV6LjBKs13PxL50rJm5xF8oi46Jvc6apsQp3N/Cl3wUnQtWquDG2we4bLdbb6CqMA
         xDltNXO1r/jvgf2y5BRbJ/62dKQqFs/hEJ8MQBLP0lP4PlnEGgV4Ht5ZA1JfGeXsIWNM
         yyI5nXLHtvOPH88G6bcZnssSIEPuFGPS1o1RCn+mM2W3i8BWdnTFN/dRPqjH1vjp6EqS
         Tcra6GARii7d/coe6SqYXYRUi/FSqIrfjQmZfZqUQ6UlX68dcSZvjOCEyV8pxHeAc1qx
         Ck5g==
X-Gm-Message-State: ANoB5pl7JUsFa+qv6En6bkVQiR8EQTVwSSFSuzR/KyqJJdMOUgzi7ooN
        9BlvepDdUNStNMYI7Fhwvp2/3Vzp47IiBaGH5q0=
X-Google-Smtp-Source: AA0mqf7422qw2PwubWm99+hPNR9fxSDbXNchy9tK2NvapKXbTpVcjTcMW8pGJBYqmr5G4PcSKw8kFRHfd7GcajMbL1M=
X-Received: by 2002:ac2:430e:0:b0:4b4:9c0b:f4d3 with SMTP id
 l14-20020ac2430e000000b004b49c0bf4d3mr24840842lfh.349.1670092232795; Sat, 03
 Dec 2022 10:30:32 -0800 (PST)
MIME-Version: 1.0
Sender: ssgsggfgdgdg@gmail.com
Received: by 2002:a05:6520:130f:b0:22d:530b:d86c with HTTP; Sat, 3 Dec 2022
 10:30:31 -0800 (PST)
From:   mrseugeniajimenez <mrseugeniajimenez@gmail.com>
Date:   Sat, 3 Dec 2022 18:30:31 +0000
X-Google-Sender-Auth: aaXOBkW2f-rXntiZPYfZAzv1Dcc
Message-ID: <CAFRzY3ZFuvMnWrmVvgN+XmR4t6NkEo=BuDebmFi8uV4X8e0SPg@mail.gmail.com>
Subject: Hello to you dear close American friend Mr/Mrs, Sir/Madame,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.8 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,RISK_FREE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:142 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5019]
        *  0.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ssgsggfgdgdg[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  1.0 RISK_FREE No risk!
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello To You,

Please i appeal to you to exercise a little patience and read through
my Mail carefully and non-disclosure,i am contacting you personally
for business partnership in your country.

I am Mrs. Eugenia Jim=C3=A9nez the Fondi asset manager in Banco Posta
Italian, I decided to write you on privately regarding to a good
business deal worth,($20 Million America dollars),invested in our
Bancoprivately through Crypto Currency (BITCOIN) by late
Mr.MirceaPopescua citizen of Romania who died date of June 23 2021 by
drawn while swimming in coast of Costa Rica.

The may reason why I contacted you about this fortune is because, I
want you to partner with me and stand to contact our Banco Posta
Italian manager as the investor partner trustee to late
Mr.MirceaPopescu so that our Banco can be able to release the fund to
you either by through Bitcoin or by Cash Transfer as you may prefer,
note, this deal is 101 risk-free and I stand to provide you any
documents regarding the Bitcoin fund. our Banco Posta may ask while
contacting the manager for the fortune to be release to you.

Immediately I receive your positive respond and you agreed to work
with me in trust until this deal is done, then you have to reply back
with few of your details as below require to enabling me draft you an
official letter to contact the Banco Posta as the applicant, our both
percentage share is 50/50 % each.

1)      Your complete Name=E2=80=A6=E2=80=A6=E2=80=A6.
2)      Your Resident/office address=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6
3)      Your international/National Identity=E2=80=A6=E2=80=A6=E2=80=A6=E2=
=80=A6=E2=80=A6.
4)      Your  WhatsApp
5)      Number=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=
=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6
6)      Your Occupation=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=
=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=
=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6.

Your Sincerely
Your positive response while be highly recommended
Eugenia Jim=C3=A9nez
Fondi asset manager in Banco Posta Italian
