Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837B74CF1A7
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 07:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiCGGJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 01:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiCGGJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 01:09:56 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74A21CFD0
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 22:09:02 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id w16so28816981ybi.12
        for <kvm@vger.kernel.org>; Sun, 06 Mar 2022 22:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=7Im1JG6q3q15hqSa7NWQHVGGERLfnPf1iBbuaSTqgJQ=;
        b=fiuN4ZFaWk+EYBFChc9RcpYLnsCe3qSRwn2T8U7uZZvu4CCk0jBhvk5AUeZFRL2RaO
         t31j1AbO2uGfdy5vROAM2MPDoJAoJD935bqaAERFqJuKNQINcxtnuOWyozlLoL1r0uEk
         BkQPmKxcgr6gcjEz6c5BEv9P7n3JXFJ4+RjSRBfj0cAmVme2b2AfUwHcA0gGCsKnqlRf
         qCElvMg7Q/RXHEd/+6NFP60QGeEp/WyAkKyDJc/AXVXccEULE2+sBDCGN18YJAsvz1tJ
         BSQs49UJ6i4ORNObTsirgV7MGqYMTmDj/Yo6LgN83MOjSVJtcRqHDJDh8eDmRrkDTesg
         Nkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=7Im1JG6q3q15hqSa7NWQHVGGERLfnPf1iBbuaSTqgJQ=;
        b=VwDg2ZlnkGWyyBH7KMAtNTxalSgVF2LVr1VP+xQP521YoHk+pz9A460O/psMg+QSNt
         1W4Lz1Rsy0VmkO+HAR6NI96Ntz5PrKUkDUrmJwhT+FU5AoL6/FfjF5OqwMhElIMSRw6u
         pvWhe4xd42I1p44WylWEJmdjmxI56tDCLxjRX3KQuWx8pvzDdSQTzS+bZuDce1/qLp6+
         QnTplAru6umbHkXSEsu7e5Eo+crlsZc89w1vURj7nBhGmP57anXZfmnlABjPk8aCAyDC
         jd/tA0cGTJv5ed+96lM6Xzv1mB8eQVkW8LoJd6HVubjphHY/ExiLycjAEIe3umYiyxvL
         SOng==
X-Gm-Message-State: AOAM532FsJtTtjLADpMsNmGBdLQoQg5yDN5F2viK0D6RY7CHBTZ/ONtW
        cG3UaZG/ZCZF0qgXHcQ4Zh/+BlhwuS0YQKNgf4Y=
X-Google-Smtp-Source: ABdhPJzq67N4LaaPeNmzza4HfHmHMMjSyRp11md/2iRRghynNtFtEw2zjdJxSwCvAW7QlMKmRwjPDI00qNwN1quRT6I=
X-Received: by 2002:a25:8911:0:b0:61e:1c66:17b0 with SMTP id
 e17-20020a258911000000b0061e1c6617b0mr7152253ybl.354.1646633341810; Sun, 06
 Mar 2022 22:09:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6918:b986:b0:a4:b698:78d9 with HTTP; Sun, 6 Mar 2022
 22:09:01 -0800 (PST)
Reply-To: markwillima00@gmail.com
From:   Mark <markpeterdavid@gmail.com>
Date:   Sun, 6 Mar 2022 22:09:01 -0800
Message-ID: <CAC_St28jhc4pQRKFbEuFwqzQWUrdxnXEyXLCeBpENYG1wmS_xA@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b34 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [markwillima00[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [markpeterdavid[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
Good day,

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
