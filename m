Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF9678E24E
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 00:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245012AbjH3W0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 18:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242278AbjH3WZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 18:25:59 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A816FCC2
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 15:25:40 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6bd3317144fso230147a34.1
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 15:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693434339; x=1694039139; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alug9UQla6/ozFgQLg/hqL6OCwn5UvUPkbrtJzvi1JA=;
        b=EWgax2RKRwoktvhesqnp7NVxqvgndbXC2Og57rNVW6nNh30GBKlF5A4EwtkjG09FZz
         JKSOrrq57dKhTAyA1M+hBI5RJM8cR9RsSBhRU/WtImWm0ndIwfPNz2UlX4KJGyPsVssC
         lRDVGiFeMqpHG01i2Cmsx/uiItoXASjsfTFMkoH1AZ1gRkyO/hvMY6SU49Jc/Qc8pB0f
         3z9Va0bcrXePa8w/Jo7yAPkqaRZOKlK+H5cNvWz3JbKz8DuXW8TBKL+mMkmZ5CURsdLQ
         M+tsfs6L1HwZaoOO/XRVsILnA/A+yje+5zIq0m0mBA1Dt6/TdHWaXdUL1glBNQ0Hx7mO
         ooBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693434339; x=1694039139;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=alug9UQla6/ozFgQLg/hqL6OCwn5UvUPkbrtJzvi1JA=;
        b=UWZfXLOGFiKZtohKXb/xwquoUtUDXYWMKBlBBkjj5tpy1b/s9WTxD5ypW0fUrH3MAh
         W8VA9wqfAmHns4v+OxkDhdQqX6NKNkcO4SnNazReZ9rJ0ki+EbTVATd5TYgY9oDIDb7n
         4fsNQP72gN1eWD1iG68SisSdDHS1CxGtENFlxQ+cMWwJtrF1lY4A1jpkod2SJDLGSXll
         w7N782CIN6uUqg1ofyBMuN5tcFr6cvUwBZs6DSOfOgNz9gwQM/M++kEH/uWYNBvjTixA
         N4xLPLep8fZ0FXSLz59yXfhNNx+M36/3aI9WE29UUD8HriKCz3jzyqFzPqMFxkvvc08F
         xXgg==
X-Gm-Message-State: AOJu0Yy5Do0urXVGYhaKKAx9g75Ujag6fTJTXNVp2Eu3WnX9oORVnoFx
        ctY/6Vx9cwnN4NKFoxbylb7TFzcsmln/vTrf/fk=
X-Google-Smtp-Source: AGHT+IGkaAJPp3mCXqVedlCL4eLCNE/s5vH455/Mn++ChIPVmasT6Y18zbcgH1Ass5pff4TUqwRfvkybUaEF4uUA9Go=
X-Received: by 2002:a05:6830:1688:b0:6b9:1af3:3307 with SMTP id
 k8-20020a056830168800b006b91af33307mr3684535otr.17.1693434339290; Wed, 30 Aug
 2023 15:25:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6830:56:b0:6b9:7840:b038 with HTTP; Wed, 30 Aug 2023
 15:25:35 -0700 (PDT)
Reply-To: mykolaruslana@gmail.com
From:   Ruslana Mykola <ms.cathirivera@gmail.com>
Date:   Wed, 30 Aug 2023 15:25:35 -0700
Message-ID: <CA+2NUoGfxYaMVWg2t11if7KAx0JUsGDyXU6rDvHrxyoJhBMNNA@mail.gmail.com>
Subject: Re: Reply urgently!!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.0 required=5.0 tests=ADVANCE_FEE_5_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:335 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ms.cathirivera[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 ADVANCE_FEE_5_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  2.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

With due respect, my name is Ruslana Mykola, a woman from Ukraine.
Please don't be upset if I invade your privacy by contacting you at
this point in time. I contacted you based on a matter of assistance.
We are facing quiet genocide from Russian forces as well as daily
life-threatening attacks. We are experiencing the world's worst
injustice and abuse from the Russian forces. My husband was killed by
air strikes on 10th Oct 2022.

I am in tears writing you this message. He (my late husband) was a
very successful contractor in the Crude Oil and Natural Gas sector and
was privately dealing in copper and gold here in Ukraine before his
untimely death. Meanwhile, (my late husband) left behind a reasonable
amount of money, which I desire to invest in your country. I am
contacting you with great confidence and hoping that you could help me
get this money into your country for investment purposes: Please I
would like to know how convenient it might be for you to assist me in
this way. I will disclose to you the entire amount of money upon your
acceptance to assist me to receive and secure my late husband's money
for our mutual benefit.

With the current situation here in Ukraine. I decided to take this
chance because I have no other alternative but to trust you. As a
woman since my husband is dead and we don't have children. I deserve a
decent life in a peaceful country, I would like to relocate to your
country and invest the money by the law, with your advice and support;
we can work together and achieve more success.

I anticipate your positive response and upon receipt of your reply, I
will provide you with further details.

E-mail:mykolaruslana@gmail.com
Regards,
Ruslana Mykola
