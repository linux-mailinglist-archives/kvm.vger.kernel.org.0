Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D394C4AE2
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 17:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiBYQfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 11:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242689AbiBYQft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 11:35:49 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ED21C60D9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:35:17 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id s1so7073903iob.9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=xDo30qH2kcx1DuoIpmyriC2k6+L7XJnWdKleRcHl+ZM=;
        b=U3d3PLNTRjQFPp9/SakQuiq06Lpz39RRVfFVOdQSe/XGD178FvDeeDD7VJ2QQjg8ng
         U1dyJN/bz8CLY5sF60Fs1qiByokZT7txIws5w9GjOWt6J5nGcaQ5wLm9fX5fGywI5XJA
         ijH/DpziKcswJQO6dHG2T+/n0HESzYYq7VSjTQ/dVqxYQvMVF0Ayb1uN0kXC8RL0v60Z
         hoxMA8vGfZd0bX2PzItq9fMiDl8Dv2turSW9MDxDwGvztwxLGBF6OUx5rRsOdWCgq5Gs
         zzeBI98Cax7+TclrCBKhkP/MpIngiC8eAq4+RGsH3nNWaHXsMy3tcIHA2co+LJAgsQ/g
         6Ukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=xDo30qH2kcx1DuoIpmyriC2k6+L7XJnWdKleRcHl+ZM=;
        b=MjYNcoNXgN5WLMo/bvqYQ4pepq4VYTbRMh3r4GgwpbKWr2mobKQhHL3KwufaIXpq2d
         tMlqUhtzFh6VQ1DCRpmqaQGGw+hUbav1ipApgcgxRMoRuk3HOmg1sip2RsSzpPk03iAQ
         1LzPlOrHqcJmRVja2mu6+ACA9sPq3sRB2iuCksbW9Skww3EAUe5MrXKchuTkYFR6P4qP
         WLVwJzL4Wsr87KP9ePNBY0a1/Yt/3CtVGeeR5ZqHio98xCFFvcdqzL0ur12b8tSkibNh
         3+50415GKQ6fJe4JgKGDP15UNPQmSyBdc4shrMMsDUHpTTUT0FHgAsUQbByzsxWyHbqT
         lgAQ==
X-Gm-Message-State: AOAM5319aWrm7HlV1RUc//TPf0tjEu4xO9ElkZWEjPvBjemsWujVm1dn
        U6W7ylaBRPHXGlgnKe4AzcqB69SFT5nv770SdaU=
X-Google-Smtp-Source: ABdhPJxpBk3gUrrKYwrHV9QrmQ8aVxYxoKgVkAq3oSMdNiA7hPCfiXHbVt+KEMu6V2oQhgyVtmhcvjkuI0nTOkBnaOE=
X-Received: by 2002:a05:6638:1490:b0:314:d35c:e1b3 with SMTP id
 j16-20020a056638149000b00314d35ce1b3mr6487261jak.165.1645806916557; Fri, 25
 Feb 2022 08:35:16 -0800 (PST)
MIME-Version: 1.0
Sender: jesusdaivd38@gmail.com
Received: by 2002:a02:cd3c:0:0:0:0:0 with HTTP; Fri, 25 Feb 2022 08:35:15
 -0800 (PST)
From:   Ann Willima <annwillima@gmail.com>
Date:   Fri, 25 Feb 2022 08:35:15 -0800
X-Google-Sender-Auth: IFGLfpVnL2gIOq3fBY92cj3bgqc
Message-ID: <CAA0k9VdheKo17pgJAJt4TbH+jsf_EPxRGPaRKkwhRGTMRpjH-g@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d34 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5041]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jesusdaivd38[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [annwillima[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night  without knowing if I may be alive to see the next day. I am
Mrs.william ann, a widow suffering from a long time illness. I have
some funds I  inherited from my late husband, the sum of
($11,000,000.00, Eleven Million Dollars) my Doctor told me recently
that I have serious sickness which is a cancer problem. What disturbs
me most is my stroke sickness. Having known my condition, I decided to
donate this fund to a good person that will utilize it the way I am
going to instruct herein. I need a very honest God.

fearing a person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your
reply.

May God Bless you,
Mrs.william ann,
