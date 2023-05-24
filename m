Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE4B70F593
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 13:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjEXLru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 07:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjEXLrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 07:47:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB4A12E
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 04:47:48 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-ba82059eec9so1696683276.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 04:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684928867; x=1687520867;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PlIvlh/Wu/Gdl3bc/cwkv0nvaIs0VGs7tRG/WiHzhks=;
        b=aeJRz0UMMhYPHrGZJr9eVChNjZuVayk3a+MJkBeciDQVgu05s8pB7uwmYZGVkYhjva
         6e9wrsuw/kz9qVuSEwHldX3xnVEZVOgi8hdzGw9hJ7xfux5beZ1U8icYBCi0g6XUHouS
         DvQqUz+gyBvCMAqPPF3dOQIkd0pQMqjM9jQhOww+2yLi/5usPZmlVWON74B31BfSUVti
         C7hUYVJ8KyMsCnsmW/fjc5joqMNKxiseaZehESBrxPtnRsudW9Xra1CAiPZQgMpqhBD4
         qY7lp1HKyJMjpai3F91uv/AbaLKVzB3qhtTXp0MVIwwkbxro79wVu1pjBbJm8nEr2eaP
         NkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684928867; x=1687520867;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlIvlh/Wu/Gdl3bc/cwkv0nvaIs0VGs7tRG/WiHzhks=;
        b=DZ1/sGkvUyji/Cb3H203AqGle21x9cejfC+UYJMHMwqzpL+IzjqJM7gJzMW2Fifyy6
         fp2XC5yCbi4a6/wMkulf6mtvF4ni2LEeVjG3YdBasD3pp4q+naXsoBpYuftEW7XUfaCN
         x/0xnAQ1i+cspzIitbLgNyhDZ9TIL3OHi1hT+2EE79n9usviCVx751OIcoxEUIMBAJPZ
         IkzpFh0vy3PSMpxkttoPauNZXjzOWAb3bqLzoGN3t/Uvj+JlA0aQ2MDlZG5+axnuXDp+
         03H9h1CuJRfhFWl4/PLSEU9UOEMDkwNcyPTGdOz0cQlMuVJTYyCHY6Gx50XhIFnG5Kvg
         z36Q==
X-Gm-Message-State: AC+VfDyTxvPG1v24FW9gUP7yEfNWyaFCQquthHfdYKtWfu3HQHSPHV0l
        gHlMI9Lo+SbhTdlTpwyc6gZuCpSlDCg9aPLjUNE=
X-Google-Smtp-Source: ACHHUZ5pzn0FAQnUXHsiTGjHk3aky4Nf4dSpifKe9EcrZFvfiui2RfZG0vT6wYnKwc1TJqHvIUCg85oV3HnAqi/HzRU=
X-Received: by 2002:a25:ad63:0:b0:ba6:b486:84ed with SMTP id
 l35-20020a25ad63000000b00ba6b48684edmr18334370ybe.20.1684928867057; Wed, 24
 May 2023 04:47:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:548d:b0:4d0:6410:f1ce with HTTP; Wed, 24 May 2023
 04:47:46 -0700 (PDT)
Reply-To: wormer.amos@aol.com
From:   Wormer Amos <jyotsnafarhadmurad123@gmail.com>
Date:   Wed, 24 May 2023 12:47:46 +0100
Message-ID: <CAJzJiXUJL3Lz_xsuth-WMzGPuUSgtE37wVd1+Pu6kukg+V8XAg@mail.gmail.com>
Subject: GOOD MORNING.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2d listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jyotsnafarhadmurad123[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jyotsnafarhadmurad123[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My Dear. i just wanted to know if you're capable for handling investment
project in
your country because i
need a serious business partnership with good background, kindly reply
me to discuss details immediately. i will appreciate you to contact me
on this same email?

Thanks and awaiting for your quick response,

Wormer?
