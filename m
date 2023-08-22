Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09F3784D72
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 01:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjHVXpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 19:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjHVXpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 19:45:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31B7CD7
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 16:45:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51cff235226so10381172a12.0
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 16:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692747904; x=1693352704;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfeDeRSJHiUxxuM1BMUm+ZdhNfTuKogm/iy1tekuEJE=;
        b=cn27pw7l7HzECtS0U0WIcHDKIZxPeLwbAh59JOKG0l4zwhCAHC1F6Rgm5HnPllClce
         70hjp+fBD+zlLLxB7xiNbisR3qqUNkJy/HYlGdu4cYHOksaD3EBG4Smvb99SOOsw7wJ3
         zuvYuGXyBqyTtQk4ddrPXRVtVUdnInntYIDznPeIYMouDuVwmkLQ/gNbxFUAmZCJGBKN
         1vG6hWOGhf2M6tO45gaIi6tmSEUAePhWBXXktQ+wKDqs8S4DKtaW4sf8EpuvwBqtmFwA
         dwUnzFtkmjzWiIt6ibzzJWUWKF50u+8IPRe0SoenWtZc5kkxZdKrW5x7EKe5NAvCGo+O
         5ZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692747904; x=1693352704;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pfeDeRSJHiUxxuM1BMUm+ZdhNfTuKogm/iy1tekuEJE=;
        b=f8GNKNHuQBzaTpML67p6lXT/zSx7n12EW4ek5pvZqYA1zSXlJQ2l308Zi7aG+BX2yG
         v8u9Us0QOM1dYahx65TL0KGe5YKAHO57fh9pTiqul6ddbX9QWxJ65YFYXtkOq7fVHkSt
         fixEHCD3UYpBPPplz6EkQCtFIvoTRWJQ/kG+Cuy+sqe6+pl/FqrtWRorbingtF77wL1v
         A1MpXpJvCoa3hQ30G+1UmkMJP9wFrx4nVinql4QoyG01S/ZIqDBs/AnLWU/OPtbC+YUr
         vojH2syEKCKH7OBQSnv3uTylYvrqmscOfd4HPJaE4PJ+t7YQnQ93GSwfjTgIcdUZ+Mkn
         XW6w==
X-Gm-Message-State: AOJu0YxPhmNs2lF4CpyoWAUWk+EKYjMav5l7iSE6jibDYR9yc6TMJEd6
        gDQ1nw9gbp0b0OMfbFc5mDhtxED0tN9ujBOWOGE=
X-Google-Smtp-Source: AGHT+IHW+XRsG83mz7pBjX84M2nWpXS995Nx1TdjMFpPyxacNqewcyqeTkR8zrgjBjNjf6JV8qHNNMRuB7poWpDQQRE=
X-Received: by 2002:a05:6402:b37:b0:522:b876:9ef5 with SMTP id
 bo23-20020a0564020b3700b00522b8769ef5mr12610305edb.8.1692747904108; Tue, 22
 Aug 2023 16:45:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7412:82a2:b0:e2:9042:f66 with HTTP; Tue, 22 Aug 2023
 16:45:03 -0700 (PDT)
Reply-To: remittancedept@arizonaebnk.com
From:   "Union bank PLC." <rodrigueztreat10@gmail.com>
Date:   Wed, 23 Aug 2023 00:45:03 +0100
Message-ID: <CAJpLuvn1sWTPGsu1-74FZAftjfi8eBMdv8d9xLv6F=-swe7g5A@mail.gmail.com>
Subject: Contact Arizona Bank for Your ATM CARD Immediately
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=ADVANCE_FEE_5_NEW,BAYES_50,
        DEAR_BENEFICIARY,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_LOTTO_URI,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5003]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:535 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rodrigueztreat10[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rodrigueztreat10[at]gmail.com]
        *  2.6 DEAR_BENEFICIARY BODY: Dear Beneficiary:
        *  0.0 T_LOTTO_URI URI: Claims Department URL
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 ADVANCE_FEE_5_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear  Beneficiary .

Compliment of the day , we use this medium to inform you that your
fund has been called back to Arizona bank of New-York for the
immediate payment of your inheritance fund by ATM card payment which
is the most easy way of payment now with out most delays and
unnecessary demands , you are instructed immediately to contact our
corresponding bank now for your ATM CARD payment . EMAIL
;remittancedept@arizonaebnk.com  address your letter direct to Mr john
Barnabas  HEAD of Remittance department and ATM CARDS.

Please you are advice to stop all communication with those scammers
you are dealing with and also forward to us all your emails with them
to help our security unit to track them down ,you are now in the right
place and must receive your over due payment without much delay and
demands from any office.

Note; that you are going to receive your funds under 72 hours through
ATM Card if only you follow all the instructions giving to you by
Arizona bank .

Thanks for your understanding and cooperation .

Mr Frank Obi

Union bank PLC.
