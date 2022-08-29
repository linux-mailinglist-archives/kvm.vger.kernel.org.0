Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B535A4D1B
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 15:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiH2NLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 09:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiH2NK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 09:10:56 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5E4DF0
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 06:09:50 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bt10so11102056lfb.1
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 06:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=5SGZXXm779vUUr1cqzGV/gRigE4jlSEMeyxYIdb55pM=;
        b=iObZ0xpxUo4F6FQeuqDr20wj+qJl4swprLp7h7p/I+T8MuvV6pE5/x6nT3E8BXnNvg
         ws/v7GF+CCDkYQwyJ7mT5TYHFa26Uf7+ksZZWsxaihsJ50rGHRH5wUfTT0bPKuKqMmOA
         LKiYq65SmeSRwXYivbo/SCsEoH89z07f4NJVt8Km213oIv6xphoMHIKipaZ1n/SlEcOV
         7QwRkOds75mXTISRhRSSCmtimrVXT3mSvHQn+/Q8bZieXszdeElN9HxI2kLOpoTP8uSq
         8MWz9dNOeyZIDqwVH2QlMBLJO3Ee3dVudPpb1fkITWuBkyQoAwTRSGqqC7sV8Yvgo+n0
         i2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=5SGZXXm779vUUr1cqzGV/gRigE4jlSEMeyxYIdb55pM=;
        b=yi9RGsJuDIq7/tGKqfBUkQHmz31H9j9mTEkV6EAyCU4mKAq4fWoeXL3y1vMVEDX4T6
         pfmhbsijIwu3uknMNvINlmJsTQSSMukx6QjB+JXKumlMmPxOiWrLZDdG8l1Chpw1R/Ee
         ay4pLSxeMfxL3PR1wfYEG4iP4vDiGkr/cT9MEysHwUAzWsrJZgMY/KWSJ0AfqUc7eHir
         No77OiWcFkW4WllqavcH7WyRPw9Nnu/IkCH/NilimAD7co8uS2+RIMRs0Zi0ivWWCX3K
         xWlSaRwahFA7npbAkfsoPv7XR2iMCXbVRpd0tyNfIKzdteKArkHaVj6qmkasFoVLIF+v
         OJAQ==
X-Gm-Message-State: ACgBeo06HWJAzqfEhg1lxWmOedO6c7zKwIvqM87R845WOcfdco2+2NC/
        KXxZNi6FFUyvZyyfge0841XExF4CJg2nu04BTCQ=
X-Google-Smtp-Source: AA6agR5aEjA6Ppeoo35yA7LRqA9ciD/2p6ronzJEGLGVrPID6MLuOxc8A9xu/fuGPMGIfX+ZrLbLLTcXTPxTcVAFfbs=
X-Received: by 2002:a05:6512:a88:b0:492:ea6a:12bc with SMTP id
 m8-20020a0565120a8800b00492ea6a12bcmr6207046lfu.229.1661778584887; Mon, 29
 Aug 2022 06:09:44 -0700 (PDT)
MIME-Version: 1.0
Sender: sorerachid81@gmail.com
Received: by 2002:a05:6520:6104:b0:213:94e:9775 with HTTP; Mon, 29 Aug 2022
 06:09:44 -0700 (PDT)
From:   sofiaoleksander <sofiaoleksander2@gmail.com>
Date:   Mon, 29 Aug 2022 14:09:44 +0100
X-Google-Sender-Auth: X638rAywS2ZYbnJ3RfC9kRRcMIo
Message-ID: <CAKL4mRfVCSmchPUooXW7KC4x_HepntXgg89Z7YL_wMyUZ-DF8A@mail.gmail.com>
Subject: Hello my dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:136 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sorerachid81[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sofiaoleksander2[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello my dear,

    My Name is, sofia oleksander, a 20 years old girl from Ukraine and
I'm presently in a refugee camp here in Poland. I lost my parents in
the recent war in Ukraine, right now I'm in a refugee camp in Poland.
Please I'm in great need of your help in transferring my late father
deposited fund, the sum of $3.5 MILLION UNITED STATES DOLLAR, he
deposited  in a bank in United State.

the deposited money was from the sale of the company shares death
benefits payment, and entitlements of my deceased father by his
company.  i have every necessary document for the fund, i seek for an
honest foreigner who will stand as my foreign partner and investor. i
just need this fund to be transferred to your bank account so that I
will come over to your country and complete my education over there in
your country. as you know, my country has been in a deep crisis due to
the recent war and I cannot go back.

Please I need your urgent,
sofia oleksander,
