Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26278556F44
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 02:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiFWAA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 20:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiFWAA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 20:00:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0937D403F8
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 17:00:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id bo5so17498681pfb.4
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 17:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3rHWukX/982VVQshnDvvj6GQbQddSOFHJAD6q40l/44=;
        b=OmPOCAMzms0w3oTblnyQltKKi/thfzvNUG4zP7xHKX2PzTIDcJUFoZ9De5Sczk7Kgw
         +1bDTOxLOiB+ECCROvP954pOZqeNMdoqvdszr5j93dvwf7d4REa8NDvVwpiyIAFH1Udt
         gnSpA7nqBnrr8onoj3AMImSy+tZSS56J3AUd31KbB30Hjx47YXekYpkP6YaEPSs/4NU5
         N0tTC9sgPkB6tdC+x8uAvKNRdiQT90O2/eqtOp+0BWvHRLKU5Vp7BcVB2N8blLeLsXon
         P8v+t6+K5Z3k2MOyeNObu1PQ2fQRwF1iyuN7DL7U6D9dCXi854TeDiERFyViYqYF9T5o
         q8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=3rHWukX/982VVQshnDvvj6GQbQddSOFHJAD6q40l/44=;
        b=GbQNaGfxuMwiHJeXtFp6zs8jt/xAbOFqnYv+EZ4Sz3d3ebwALIfS50wCxNmBNRtVuV
         2S6gKMHtGBXzfxsjBaujgBwL89hRC1EkE7QRsdtWNXQpMzCAYSiR/NElgJQ4pbRu58E0
         nL0ynRGosRtnBM662yurIxVGXnAkPorjVnWWB+uhFMiXs/927vXnuLwRtJeuzFi7zEKC
         8QIE6dMyAMwnR5+5/UyhnTwIPOUnCqMVk1leQjNXe4KbL+sEK+d1OzVC9nAVVwSpDeCV
         GDYfnJPVgpEjKwjCNX653GRrvAvaPEEzWtcNdYGG+C5qQR5jX8nQ6CE4A0VWVwlOi7E/
         tfvg==
X-Gm-Message-State: AJIora9NwFiKydS2yH1wH1Sz780DDf1T3UiDBVsK1efisAoEqcINMmW1
        IDf+n/OCtVqq7IatHl+MZrUZ97qByeMcaKJutUc=
X-Google-Smtp-Source: AGRyM1vZLWWm882QsFgEMVUZPF8aEuax/Apnx5gx4PQdWxMlfUxzRIDO0CKDXdVh1sEwny5uV5PaKOYtFhmF14VckBE=
X-Received: by 2002:a63:7909:0:b0:40c:6cba:b1d0 with SMTP id
 u9-20020a637909000000b0040c6cbab1d0mr5017868pgc.353.1655942426487; Wed, 22
 Jun 2022 17:00:26 -0700 (PDT)
MIME-Version: 1.0
Sender: aileen.sami1hh@gmail.com
Received: by 2002:a05:6a10:e208:0:0:0:0 with HTTP; Wed, 22 Jun 2022 17:00:26
 -0700 (PDT)
From:   Juliette Morgan <juliettemorgan21@gmail.com>
Date:   Thu, 23 Jun 2022 02:00:26 +0200
X-Google-Sender-Auth: K3oloum0iV_P6GfiIFI6ObaujfU
Message-ID: <CAG848prajqtV5n6D1FQtpzT6vZcK3_JtM5BNdq0kyo+geHG2RQ@mail.gmail.com>
Subject: READ AND REPLY URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:441 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aileen.sami1hh[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dear God,s Select Good Day,

I apologized, If this mail find's you disturbing, It might not be the
best way to approach you as we have not met before, but due to the
urgency of my present situation i decided  to communicate this way, so
please pardon my manna, I am writing this mail to you with heavy tears
In my eyes and great sorrow in my heart, My Name is Mrs.Juliette
Morgan, and I am contacting you from my country Norway, I want to tell
you this because I don't have any other option than to tell you as I
was touched to open up to you,

I married to Mr.sami Morgan. Who worked with Norway embassy in Burkina
Faso for nine years before he died in the year 2020.We were married
for eleven years without a child He died after a brief illness that
lasted for only five days. Since his death I decided not to remarry,
When my late husband was alive he deposited the sum of =E2=82=AC 8.5 Millio=
n
Euro (Eight million, Five hundred thousand Euros) in a bank in
Ouagadougou the capital city of Burkina Faso in west Africa Presently
this money is still in bank. He made this money available for
exportation of Gold from Burkina Faso mining.

Recently, My Doctor told me that I would not last for the period of
seven months due to cancer problem. The one that disturbs me most is
my stroke sickness.Having known my condition I decided to hand you
over this money to take care of the less-privileged people, you will
utilize this money the way I am going to instruct herein.

I want you to take 30 Percent of the total money for your personal use
While 70% of the money will go to charity, people in the street and
helping the orphanage. I grew up as an Orphan and I don't have any
body as my family member, just to endeavour that the house of God is
maintained. Am doing this so that God will forgive my sins and accept
my soul because these sicknesses have suffered me so much.

As soon as I receive your reply I shall give you the contact of the
bank in Burkina Faso and I will also instruct the Bank Manager to
issue you an authority letter that will prove you the present
beneficiary of the money in the bank that is if you assure me that you
will act accordingly as I Stated herein.

Always reply to my alternative for security purposes

Hoping to receive your reply:
From Mrs.Juliette Morgan,
