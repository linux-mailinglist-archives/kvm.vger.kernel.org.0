Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23EB504720
	for <lists+kvm@lfdr.de>; Sun, 17 Apr 2022 10:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiDQIfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Apr 2022 04:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiDQIe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Apr 2022 04:34:59 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A21E13CF2
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 01:32:25 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id m14so10346577vsp.11
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 01:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=z+v8ugHyK4Bi1bsAOtuex5rzJWIULuLfF++ZnJg6JJs=;
        b=YYwY8WR0SmkQPVZe8Z0SbCJHSErG+0FJno9c0VcRJL7X8oOA6rh1+hg48y8dGBgIhq
         KKwuCeHuPnibWe+K4fcQRZmOtM94hSzXBhiEnzq7ssJyduoQ3mLrfOIMTW6ChyhNk1d9
         lBunbdu3nhfq0hVysTdf1fu3nHHEnp/RcWfpYPEnxEEwLYYOzlc7nufXmt22888glbrV
         kOvJVJajVerocbPlOiQeWy8HlhKjlrDOckYuvpBKCSiwnoqHbNQ27yi64QOxL1/Tm+m7
         EJe1Vwy2Ndz8SwAdUCvONecU6BogOvMKmYpKvUsvApVjHpV34+boFUkiQBvVyzyJkGDv
         cITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=z+v8ugHyK4Bi1bsAOtuex5rzJWIULuLfF++ZnJg6JJs=;
        b=uZRbeIVQpPZpb2tuywvzwpb7qiBgDXctWzESVLbgpcn697Kp82sT6JKikGUVQVztvh
         0itH7wXWAkxYpY4rxcEez7/JBj3rWBIkhXRBtrMAotsO7vyVM9A1pvJycD//j44x8fAv
         IkYxp33HP+tUmcKQCysUQK7FM8Ykbnsfq3dcWiw609L9hN+IbsZN+9Smu3TRd6/W7ZSL
         UB19ZlRzp1g0Dv35rh0kNwjPzJDKvtnhk9f2xl8DJxwQPWuy+pDw0zAe2rm0OiEK62x3
         9ZVsCRVqRA4QOH/bMKaHdp3z2FcY+JZfeB+4jvKe2NNLoww2Cj12ZovTMfudOo4kfR3E
         FwKA==
X-Gm-Message-State: AOAM5312gg/Ze3CI76bnA45BAAlpsh7kyPtVNATDYvKAkBKFepc2HOYe
        U+/8qQeWgWS88f3ZnjnZiLYiDCJm6Eirf1WkVYY=
X-Google-Smtp-Source: ABdhPJzOi4Z/IKW+tSakOf6QRLVPN2kPxKCqzqyLuo8qHXAowJX7S5XYCmpP65DjYlz8uSWhFfmEw5wsSS5WtInmjmc=
X-Received: by 2002:a67:b641:0:b0:32a:1acf:5ff8 with SMTP id
 e1-20020a67b641000000b0032a1acf5ff8mr1611018vsm.81.1650184343682; Sun, 17 Apr
 2022 01:32:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:2303:b0:2a3:2b46:b7d with HTTP; Sun, 17 Apr 2022
 01:32:23 -0700 (PDT)
Reply-To: markwillima00@gmail.com
From:   Mark <muhammadsuleima888@gmail.com>
Date:   Sun, 17 Apr 2022 01:32:23 -0700
Message-ID: <CANCcrFDKp0ceD6RYir0TJiJfK7WrUr-un12OEDwvdd4Be+gyFg@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [markwillima00[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e42 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [muhammadsuleima888[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [muhammadsuleima888[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The HSBC Bank is a financial institution in United Kingdom. We
promotes long-term,sustainable and broad-based economic growth in
developing and emerging countries by providing financial support like
loans and investment to large, small and
medium-sized companies (SMEs) as well as fast-growing enterprises
which in turn helps to create secure and permanent jobs and reduce
poverty.

If you need fund to promotes your business, project(Project Funding),
Loan, planning, budgeting and expansion of your business(s) , do not
hesitate to indicate your interest as we are here to serve you better
by granting your request.


Thank you
Mr:Mark
