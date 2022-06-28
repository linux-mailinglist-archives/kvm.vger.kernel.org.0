Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF155F0EB
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 00:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiF1WOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 18:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiF1WOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 18:14:19 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DF8326D2
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:14:18 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m6-20020a05600c3b0600b003a0489f412cso274106wms.1
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=BeXPYPsPcks1vJnkCiVR+AZ4T0LVp8r4SqdR8q577ps=;
        b=aXjRcl4mzkQ7SaIHf1a8ezJ61DtHnH8rNOB/06to1GFNsXvTz8JCyDyinU+eAI7uIc
         gyJBh8uJXAtMKfVj4TPc5yU2/x08AxXE2lNML2imlUJ1dAWeSc1DDVfqfxycW4wtjHry
         IQV2hL/6mGndVg5Ll5n2OlmYfqZ7zzOTUDxTBO+HQZiPDvFkJ6/mCIT2gWHryee+vy8+
         4iMjwGG9EESMevGRdLzAyGHQlZfIgiTi0puxBYgUFKkXeyVKYR7wxxzknybXv4FLW6hO
         pZgk1Z6B5fL1KQIKvO0C8b2OB/MGx3i02/5yYDDY7zvB3GvHj6Ln4JmK60NeFXmZrtOS
         4lRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=BeXPYPsPcks1vJnkCiVR+AZ4T0LVp8r4SqdR8q577ps=;
        b=Vcq6Fcn862fjIiR+0bnbB/3aJMElC3TBlcKdmkiS9JW0Aufu2FydhUBv+3YM/keSJl
         yZLHAWMvozB3fOgIcYCR/4TRzTqiTy8T+0We0HXtpQH6Mpw8o65sAS0etL3XG4YCYMsy
         H6Xe7yxTrf9ZHOBRBG/1IBGkKK49ssmP/XmzwXAitXtQGLXidlUPg4iqmK6MQ3iAGs16
         jm7TpchPcAGias61IiprEpLbhH9yn8iu1HKKHdjsbazTACgromdGyt0sYCm4c6uClw++
         Mg/JYLZYbEvEpA7Iz//sAKmC7VjTty1mhRUPPPVPRYXCHpMrXlLZMYrDmgNgnNHuTYlF
         HmbQ==
X-Gm-Message-State: AJIora/k/JbMreL9mTCcgHdU4gcm8UGp1jwWZqWyrK+KED8hBnzrqEnW
        9MYPFOaYYCP1I68SoAXN1mGMintWr1zmpObxEms=
X-Google-Smtp-Source: AGRyM1voUQPlAmqRZ4l/SXD33ct9oPA4JA4sFQVTKk5qVckeyXriiYLvZWmk8WJ1W4W1a9L3Q/IJNHxDqsDJGMgdRd0=
X-Received: by 2002:a05:600c:4b88:b0:3a0:4c39:dee5 with SMTP id
 e8-20020a05600c4b8800b003a04c39dee5mr100574wmp.32.1656454456526; Tue, 28 Jun
 2022 15:14:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4bcc:0:0:0:0:0 with HTTP; Tue, 28 Jun 2022 15:14:15
 -0700 (PDT)
From:   Drzulu Nelson <dr.zulunelson09@gmail.com>
Date:   Tue, 28 Jun 2022 15:14:15 -0700
Message-ID: <CALWycZrKw52DV+=wXS-kuMt0fqEmzKejKf2AJ6Gy+Zp-3D_u2w@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.8 required=5.0 tests=ADVANCE_FEE_3_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:329 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dr.zulunelson09[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dr.zulunelson09[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  3.5 ADVANCE_FEE_3_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  2.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=20

--=20
Ordering beneficiary,

This is to inform you that your payment file has been included in the
first batch,Consequently, payment approval has been issued by the
International Monitory Fund (IMF) for an initial payment of =E2=82=AC
4,650,000,00 being part of your long-overdue payment.

To facilitate this and avoid further bureaucratic bottlenecks,an
accredited financial institution has been appointed to handle your
payment file as well as others that fall in the same category.

I therefore request to know if you are interested in receiving this
fund within the next seven banking days or would prefer to have it at
a later date within the year. If you are ready to receive the above
mentioned figure as explained,let me know immediately so I can send
you contact details for the appointed financial institution.

Kindly reply through my private email: ( officeauditor28@gmail.com )

Yours In Servive
For;The International Monitory Fund (IMF)
London Ln,Bromley BR1 4HF,UK
Visit our website: www.imf.org
