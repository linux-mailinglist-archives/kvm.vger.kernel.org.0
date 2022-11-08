Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CCC620CA7
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 10:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiKHJtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 04:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiKHJtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 04:49:18 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F7FDFE3
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 01:49:18 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c2so13673895plz.11
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 01:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ueRenEMUtbiyFkdIer7I3YK8sgT01nadOHVMNYLxJmQ=;
        b=dMKQbk3l1weg5mHsv7DWgE6byb/4ZAItiIrkluWJLkFGI5bPo19cYmlPbupUODauuW
         1an85MQZ1Ps1s/Qc7zlRjCU51arfSjjw7/bOgR2JEmiY8TZ+TUPXTUMr8bmGMBgHkMEI
         BGnAAoJ7jcYU4TxBJz2FCTW/D16GUoDqzhLpISG/XD8OFGZqRwU9FCLfwTvqeQtdpmW1
         xCngOXnFMTuKThg1gVFqEXvML66U+urIie/jxtYJQklKu3Ib384pEjlWpCnyiAblpjF5
         VdxaNbg/SOq8rQXrVxl1kY0jBvjaZV0W52h2ZZ4U8diGLQfEj0XDW38vYq6t5VEER8zf
         zvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ueRenEMUtbiyFkdIer7I3YK8sgT01nadOHVMNYLxJmQ=;
        b=m1rMVbDnxWBaFWXPqmvBdNZzL8D1zXDzr2OYouSFGRSz3XO4ngyqpd2Z7JF2IDowLD
         /io9KFul7/LejfCtmBNu5MtyIK9jECO20/J1WvBoi63G7DzqwIldBZEQXL3JEZAQEhBK
         EMvz1JHeNK5faAYS+AjEeEqU4FO+BYAegLfO5LGe173JLPZadiaqCCgQTTn1CwYXYk04
         jbFYCvJyB3y7yymxvKj/PgOWxl5gx11plST46LfKqmCAE1hmAqniuQQ/0LhiLr40/dls
         yTlNuQ1OnNGdZR0pn3v1Xv/VSwq8P1x/eF8rb10bOCAo4ISv/0icEYkZ2rZ+9XTMDAyt
         1UUg==
X-Gm-Message-State: ACrzQf2HgdBFM2xS5EAB/zWmaE1c+OpEZu5t6c0pd8Z/wkk2VoRqZcbz
        5NTz7kFrXP6/tIyPgc7k7+Mjvy4/vXelqZwGJdA=
X-Google-Smtp-Source: AMsMyM5cAxqBH6+pZIzdjFxOixXEzpVKn5x9UbJn6gZNeM3mywoCm5xC4+qLq+UqCi/8E0ssZraMrpsgEfxkyTyK2mw=
X-Received: by 2002:a17:902:9a0a:b0:188:4f8b:abb8 with SMTP id
 v10-20020a1709029a0a00b001884f8babb8mr29929667plp.157.1667900957880; Tue, 08
 Nov 2022 01:49:17 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:e18f:b0:357:eb9f:644c with HTTP; Tue, 8 Nov 2022
 01:49:16 -0800 (PST)
Reply-To: te463602@gmail.com
From:   "Dr. Moustapha Sanon" <moustaphasanon4@gmail.com>
Date:   Tue, 8 Nov 2022 01:49:16 -0800
Message-ID: <CAPX2G2bhsQhBdgsMGxGSAd_N=tg-TOugLDC-ka79G-V2znOPww@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [moustaphasanon4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [moustaphasanon4[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [te463602[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Greetings,
We are privileged and delighted to reach you via email" And we are
urgently waiting to hear from you. and again your number is not
connecting.

Thanks,
Dr. Moustapha Sanon
