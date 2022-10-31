Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5F46133DB
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 11:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJaKoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 06:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJaKoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 06:44:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A6ADA0
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 03:44:07 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 21so16820968edv.3
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 03:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HimZc8yramtrHBkHsNskSIVkCsBkqEjbz+TPQpvnPJY=;
        b=XSYcZMAmi81t/KQVNOBMsshKOjtXu9FkdWATKhorl2do45oU556qWFDH24TiTx+08r
         gm5o5V7djBJJ7wLgctJwgfiEZDSwC2zrcgI9o7jnJcJDOMBWOU1wWIMEcs/stg9iYwRV
         p50OoqZUPUkCyVxp4duxoQRU4cFe2tdEekvDqS2MNEEaZYsgn3Q1nSqmCjAYD+SA0dC9
         CbRKFuMVOtXT5CfOvSb+IFD8KXVvv12ZkPyZH8ZZ7Y8l3rJU6d3pQkDaFQenzxs3C431
         TJqQVXFi68B0cujmYq3+Q1HOUGF11Em6aDRLleTHRU6AdgPiGitz8mLKNVSqPzjPspio
         2hTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HimZc8yramtrHBkHsNskSIVkCsBkqEjbz+TPQpvnPJY=;
        b=aCEyVwca8+m+l8Mxa9VGRmcwAXTVhPJD3AKRbWnUNqdLvfkbd0mL8rcvAHfRh/yhH/
         r9fkVgb2FnU+SRlR52MkvD/e4sgCif8SDqRycqZTdyd8DTR4zpEsC0S7eiKixf4a3K+v
         xxPfSokZphDCMT2D2Z+YE+PayQ0St9BsSCLfcaMlV3E8n/c+CkdY5xC1IoKS8b8iEIIi
         yuIgW8Wz1bKN7AOH+MwOfSSkCy+/cDQkQOMZwA1LStEsptEuFrINdKZfdZ5pCT65LcQt
         BhXsxNKgPUSsSpQ8nfu3vd1HoY+0YwTczQo3zW8yUrAFanF90lRCWf+9Kksshy/r1isT
         kR6g==
X-Gm-Message-State: ACrzQf27Z5OJ4Qx57PKeU78n6ZPOlRrYxAxQQDhCpgzO4YV7RUovNY2O
        DLw9oX9D9Q/ecdyh9GA7u0W1DYvnJbA4t9OnQl0=
X-Google-Smtp-Source: AMsMyM6ZYFjDfYpQIYBqJVYy8J/TnaFS2P+m93kqVOQMTyYfy7xBkxvEA+OchR6Zu3xj3CcWCzLHBfJa0+7Y5zLRDug=
X-Received: by 2002:aa7:c452:0:b0:463:14dd:2093 with SMTP id
 n18-20020aa7c452000000b0046314dd2093mr9741197edr.48.1667213045311; Mon, 31
 Oct 2022 03:44:05 -0700 (PDT)
MIME-Version: 1.0
Reply-To: alyonadegrik@yandex.com
Sender: aminaterfas1975@gmail.com
Received: by 2002:a05:6402:496:b0:459:39ae:3d23 with HTTP; Mon, 31 Oct 2022
 03:44:04 -0700 (PDT)
From:   Alyona Degrik <rameshkangco@gmail.com>
Date:   Mon, 31 Oct 2022 03:44:04 -0700
X-Google-Sender-Auth: wCE6RDy9s1lbII75FBFi1ORBTM0
Message-ID: <CAGibXBgpzwqmKMaEn08kko9XHe0BoJpkrZFYczzR5sZtMKtmLg@mail.gmail.com>
Subject: Hilf mir, bitte
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:532 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8375]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rameshkangco[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aminaterfas1975[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lieber Freund,

Bitte sch=C3=A4men Sie sich nicht, Sie =C3=BCber dieses Medium zu kontaktie=
ren;
Mein Ziel ist es, eine tragf=C3=A4hige Gesch=C3=A4ftsbeziehung mit Ihnen in
Ihrem Land aufzubauen.

Ich bin Frau Alyona Degrik aus Kiew (Ukraine); Ich war Eigent=C3=BCmerin
und Gesch=C3=A4ftsf=C3=BChrerin von LEOGAMING, bevor Russland in mein Land
einmarschierte. Ich habe Ihr Profil durchgesehen und es klingt
interessant, also habe ich beschlossen, Ihnen zu schreiben und Ihre
Hilfe und Unterst=C3=BCtzung f=C3=BCr Investitionszwecke zu suchen, aufgrun=
d der
Invasion Russlands in mein Land Ukraine.

Ich halte es f=C3=BCr notwendig, mein Gesch=C3=A4ftsprojekt in Ihrem Land z=
u
diversifizieren, um die Zukunft meines einzigen Sohnes zu sichern,
nachdem mein Gesch=C3=A4ft von den russischen Milit=C3=A4rtruppen zerst=C3=
=B6rt wurde
und in meinem Land keine sinnvollen wirtschaftlichen Aktivit=C3=A4ten mehr
stattfinden.

Ich w=C3=BCrde wirklich gerne mehr =C3=BCber dich erfahren! Und ich hoffe, =
dass
du mich auch kennenlernen willst. Wenn ja, dann freue ich mich auf
Ihre Antwort.

"Mit all meiner Aufrichtigkeit
Frau Alyona Degrik
alyonadegrik@legislator.com
