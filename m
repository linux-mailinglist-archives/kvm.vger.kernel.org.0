Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068D86629C2
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 16:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjAIPWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 10:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbjAIPVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 10:21:33 -0500
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075AF37526
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 07:20:13 -0800 (PST)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-4c15c4fc8ccso117130397b3.4
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 07:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YyPG5W2rWleKRror+/kea3+bqMQAFhdHiHY4+dsvOFI=;
        b=R1c3yL/76sZnuPVTNjfy3Tqx4DCKXZQ3RvPRqpLNK9ZRR5H7IflttRtiNYB59jBAiE
         GRGUoNxybjU+DS8SCojwNXQ6QjCWvZ5OLThUxov+NUwVPTXKNfM0Vi+2eS6SpHvRgfFa
         cum8jP0T9Cxk0ed3cAyaF8roiAOPpaEh8bqFzjknkIHrP2wPp2SqMn6PvllivA0rN6mS
         UZum2aXiICfbLShaqtP8W5/gZ6ZiicbX8j9aMRyhIrXELES9AlpaT6iuUZMhD1jb03sz
         IzvUdBSNC+00l444nfwR7DgW45uqtl8Q+S6F8dvRQ3TyqSSPC2/2jqlGFsAgCT6jg4tB
         OaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YyPG5W2rWleKRror+/kea3+bqMQAFhdHiHY4+dsvOFI=;
        b=Uxk8Jc4jEBM8OVw+WCLBKogsxSJ/mgOso63y4vjiwvzjHAwLJMGtDUNarZkWARcyH5
         1mzrBTpmkGhkGjtYgvVLCtHJiWaPuzL9z82U/cuTUaTbPqXfnzwTOqSsUHd8gdOJ/KNW
         aTH0P8wXs+v7TscHsKoB0RDEviXSwpWb3CZJZctluUiPrTn2WvsFr3Wpg6ZBWhdGwjSQ
         05PnqEcIDMso6XJMEMeux527KziITvxqaeaQvWpq7aZuRgncQojAkD94q7hOxD/FKZ1G
         Ux09h9uFkZgQepOoxT0d6qNMk61LKC7nFCiUrVMzi1kCVU5P6roTkmDhgUMJWgUEJ9r2
         pK3g==
X-Gm-Message-State: AFqh2krsXl+OTnBPBQ/WLu71AZ0x9qxabcbxi1qyJ2R/3KfCrtRlmP0C
        foO0BklyslLlA9/IR3n3b1v+gYMWopzUXLDhjlc=
X-Google-Smtp-Source: AMrXdXug9Y5h/FSNHSgeAzOeGuvjU4M8PS7mSW0i+VJ+0jfVx737ZoD47uogBeRyo1130HDbsPRVswEMZ1IrPeHgoyw=
X-Received: by 2002:a81:1283:0:b0:472:c62b:8609 with SMTP id
 125-20020a811283000000b00472c62b8609mr286304yws.23.1673277611154; Mon, 09 Jan
 2023 07:20:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:5a82:b0:418:35c8:c529 with HTTP; Mon, 9 Jan 2023
 07:20:10 -0800 (PST)
Reply-To: maly.bobb5@mail.com
From:   Maly Bobb <malybobb18@gmail.com>
Date:   Mon, 9 Jan 2023 21:20:10 +0600
Message-ID: <CAAuU1_ZbMeAmEZaaqCVZyKK4ZzxYhrYD8-X8rmQvpZNbaTnC=g@mail.gmail.com>
Subject: For Charity Purpose
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,NA_DOLLARS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1144 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5003]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [maly.bobb5[at]mail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [malybobb18[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [malybobb18[at]gmail.com]
        *  0.0 NA_DOLLARS BODY: Talks about a million North American dollars
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  0.3 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings from Maly:

I am contacting you for a Charity Project of $6.5 Million US Dollars,
ready for transfer into your account.

If you will be honest, kind and willing to assist me handle this
Charity project as I've mentioned, get back to me soon.
for more details.


Best regards
Maly Bobb
