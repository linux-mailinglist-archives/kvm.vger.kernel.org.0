Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084D65034B7
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 09:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiDPHst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Apr 2022 03:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiDPHss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Apr 2022 03:48:48 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F110EDFC5
        for <kvm@vger.kernel.org>; Sat, 16 Apr 2022 00:46:14 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i8so895035ila.5
        for <kvm@vger.kernel.org>; Sat, 16 Apr 2022 00:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=E35sNx8tZZDEbOXrgnkUSeo1GJpev5TxR4g//B8bPVsQsKXicXOqTey4KPKxjgdNt2
         3Ke9ym1vbhQRo7eVvgbF10Xb7jGr+hXovh9kh3Ic6YSOh63sJ0cU5YPECMMMIo4qOsfO
         ZBWvQ0bS3SR9UtTNLXllwxPHRQorZ+G917NGHPwa0m5TaGo1omzKP09ui2+CPkTgKrkw
         2CUCcvWqikllbF3wsCh3B2wOa9i/ttXxWwvdL1lyPXJTvUM/4bHXkjOQ+A7z8jwDC+cI
         Ow8rMSmq9aewZbrWQigmKqJg+r4/rGZWxM9LSe8HYI9lnu50yFh4DK4nWYcZRQfYF1+3
         6XwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=qBZCDnt/BbuvSrbZheClk2S+X3hobc0dSCzp0VAsGHTZ//ikehV1AVAWk0/9Gy5fyS
         QZTzGXjXgMP3UKpAZl3CvUdZX0LQMQk4L+9UpWd18Hun4r/u+dCeykDwnwixWZbtUQIw
         vTkDSOtGttBCkUE4Cd4j4TMU32EcNigFnQzEQ4QGUHbvzE9QuipsGh8SggYxqjvLhqmo
         jrJ44lRXQu8fAvnV/svYbanh8xnxjojPUY7HbCwxaN7i1ddmzzbfV8047oyPAucsw2yh
         Txv+lGZfx3Xd2SaJWb1OeU9IX5tMZ5/sjCJQfxgbskyleL65HDh0b+a+6q46yJIiX7Lu
         lD6Q==
X-Gm-Message-State: AOAM531VYOpaSptS4P2K6EDnBn0u0yHAriQOtpRMQ96RxZnWUVhkpxiH
        n+DcR8WtO8jkCszTvsuf7pRAE+Qel8f+02inrP0=
X-Google-Smtp-Source: ABdhPJwpz/m7WLcG1uweLeCcJreW/An06JSrpXizIXLPhNbfDYG7xCYR8yXvhv+DgFaE1QCWCOqYfJ3Qzr9bg64A10w=
X-Received: by 2002:a92:c567:0:b0:2ca:fd1a:3976 with SMTP id
 b7-20020a92c567000000b002cafd1a3976mr913155ilj.301.1650095173954; Sat, 16 Apr
 2022 00:46:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:1309:0:0:0:0 with HTTP; Sat, 16 Apr 2022 00:46:13
 -0700 (PDT)
Reply-To: daniel.seyba@yahoo.com
From:   Seyba Daniel <royhalton13@gmail.com>
Date:   Sat, 16 Apr 2022 09:46:13 +0200
Message-ID: <CALSxb2yNWsrOA5ggPtbmAWa3riifJkrqf0S1G_kc-Wg-5dJ-aA@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:142 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5004]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [royhalton13[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [royhalton13[at]gmail.com]
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

I am so sorry contacting you in this means especially when we have never
met before. I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it.

My interest is in buying real estate, private schools or companies with
potentials for rapid growth in long terms.

So please confirm interest by responding back.

My dearest regards

Seyba Daniel
