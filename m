Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612FF4E8AEE
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiC0WwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiC0WwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 18:52:15 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445D63388F
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 15:50:36 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id w25so14992440edi.11
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 15:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=VSEH8Q3Lr+Mcr/0lsL1VFPftJp7ALZ21MKYEz4sry74=;
        b=gx+9Hq2FqjzLYfLE+uD7MRf1Z/TWcMFWeoMZPx4W+7EoYvq0SkWwiEobMx44Uq/Ytn
         az3wwBIe9wNF5xUkbTwLQU1Pv8RMhy8IxnAMy/RwCb8MVcKpUO0U1ID+eOPgnCGdmXru
         Uyn8YKM2C9Az0FRZyo39nfy+WgCcLiZGQ+R3aYybohTVZwPxh+eVnx6ZV5Gdos1LSXSM
         07ukpoEPd+mxiwDoDmP1TS96Jn+UErW+ahwhcP0X0Kn+dsxg2Bbnw5EZzzRo1F3auYIh
         wFx2LtfLQvlyHnAwK6xivcGXzoivDn3AzDhwh/GO612YvTWOART+40T9mkxOqV4ncP4D
         J8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=VSEH8Q3Lr+Mcr/0lsL1VFPftJp7ALZ21MKYEz4sry74=;
        b=raOIoWALL9NMKB7DaWFtzgkR+Wwza62IzMGqnPKVLjxMSJWv+tLvNJwLTSE+oks5Lf
         xSN8TOeejJiqHevk67VT0sbbjyBEoCzaj5Ba+9/DtxxnN0v+nnKeohYSMaCZXTRWOuYw
         qIZmRmZjSMbJvWNRTniZbiVFZ7mMv0abEfJDwV5SslPO4X6LJWZjlcjdAvKB1zMoombv
         VN8ZKoPhdb0nJH5Uw4EE64aJqXDDHkTJZwHGhGA3D3z14dr7EwdTkyOv0drxxvdF41sj
         hCouQOTWrO7mglaBGcwf7jrcXmrLr3rcXf/Iqqykll6a/IGUhU8pzSOh0ijuCLiPAjfW
         6N6Q==
X-Gm-Message-State: AOAM532+AOtt3xVM5rFlytfCvf8V4DAS2lkgZNPRQxrRbpkr8J5ChFW+
        YgRUrItn17oSS8Py5sPTRut658QSHomVXcWaJ3E=
X-Google-Smtp-Source: ABdhPJzTu/+3kS6pMgJ+0BGLmu2UaggHrLg09EiONBfK0bQpfHr2MOqylj5bac4WiXaIe/rP+WjHg46HSEUoMk8g2mo=
X-Received: by 2002:aa7:cc82:0:b0:410:d2b0:1a07 with SMTP id
 p2-20020aa7cc82000000b00410d2b01a07mr12655473edt.359.1648421434625; Sun, 27
 Mar 2022 15:50:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:294b:0:0:0:0:0 with HTTP; Sun, 27 Mar 2022 15:50:33
 -0700 (PDT)
Reply-To: christopherdaniel830@gmail.com
From:   Christopher Daniel <cd01100222@gmail.com>
Date:   Sun, 27 Mar 2022 22:50:33 +0000
Message-ID: <CAO=CV9JeVnd4Mn2cpfai_wcAD2pZQysg+pZUa-7B9w9DVMiZbg@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:544 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4202]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [christopherdaniel830[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cd01100222[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [cd01100222[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

.
I wish to invite you to participate in our Investment Funding Program,
get back to me for more details if interested please.

Regards.
Christopher Daniel.
