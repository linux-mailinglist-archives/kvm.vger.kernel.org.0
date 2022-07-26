Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44C5581724
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 18:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbiGZQRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 12:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbiGZQRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 12:17:14 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8C4248C9
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 09:17:13 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id k3so10735505vsr.9
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 09:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2geObz/qPbQ0zmW0zjdppN56rmNh6IuNe6i2t19UWOo=;
        b=ofQmKhi/49cqZ5A1rRryuXLezENFS9l4JDZrD2ri8Yk6DRsP18VOtFBHAW45b/UMui
         TBr8fc1SVa8bnC9+RXA97hPki0bHu4mud9Eldgu/3eObunJTYIDt11xTLSlG2UQ92Yv8
         QSKMwgoP4zb1R0maTvcscdYJ3As0sKT0QdFkayY9ekiSTbcT9nH/ptHiUxmmls93o0BD
         4+MbvwKz4G7HV1aRJKtzFIwajmXpjKmi4kqsQWnJINKdYAgnwcrd+8f0AQDx3znN24OX
         udAVJiwq53I53fbVLwIlvnQOM9EC0dvszcGohD/bhgrqsXHmJp+iLVxaHi2zZx52Rfke
         yGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=2geObz/qPbQ0zmW0zjdppN56rmNh6IuNe6i2t19UWOo=;
        b=dMi4sHDrePK2ehysAd25fiZQRfG6yEQYecfH153vdhfYfC2CEqg0WvX+Qj//7rO6bv
         0Cd4SY44dR6bzwJJeZsCG3u+fNUvQT+3kZH4bJBP2hgO8gS3WXcbwAXV3ZRhPzw4UIgH
         4TnLibXf1womff76MqnHOD1tzW4a/BwTzYw8xRQIAOmKHkhqPRVMLKvtAG3+hPWoV3tH
         hoSx6bGMRx14uOyqWVKseAoAE+vFHuqS/Yfz8tU2Srr3AolHsk0CICxscSuj68MgmDoT
         QLQq62VuG4RjGREQozK0z//effqOr+bUhQr2h1yncNLlupkXUaBBLOPfJ6LSdvNl1Dj5
         vsqA==
X-Gm-Message-State: AJIora/LzO0ISQxoKZomtIL18+dBJKRQ17mgGWld4uk6hLh26IZGi1ju
        1b8vO8olQbrfeV7tBmJ0crjVdUV2Im0THWIWae8=
X-Google-Smtp-Source: AGRyM1vsERW5ExbDZ1cfVh9Iq9uCCbPK65wLhBWU9vW/smWA40rNYGQbGWXkTSAs6Ip+dO0b4vYPVswvlwzdU5bgAEo=
X-Received: by 2002:a67:cb11:0:b0:355:84b2:5c58 with SMTP id
 b17-20020a67cb11000000b0035584b25c58mr5069497vsl.43.1658852232443; Tue, 26
 Jul 2022 09:17:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a67:ea88:0:0:0:0:0 with HTTP; Tue, 26 Jul 2022 09:17:11
 -0700 (PDT)
Reply-To: cfc.ubagroup09@gmail.com
From:   Kristalina Georgieva <ubagroup.tgo12@gmail.com>
Date:   Tue, 26 Jul 2022 09:17:11 -0700
Message-ID: <CADnAz75BBK3Vrx2Wt8H0_TFunUUpJu6wCMtMnTXUmmptq2ErJw@mail.gmail.com>
Subject: =?UTF-8?Q?GOWY_T=C3=84ZELIK?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hormatly pe=C3=BDdalanyjy,
Bu haty size bir a=C3=BD =C3=B6=C5=88 iberipdim, =C3=BD=C3=B6ne sizden e=C5=
=9Fitmedim, =C3=BDok
Al=C3=BDandygy=C5=88yza ynan=C3=BDaryn we =C5=9Fonu=C5=88 =C3=BC=C3=A7inem =
size =C3=BDene iberdim,
Ilki bilen men dolandyryjy m=C3=BCdir Kristalina Georgi=C3=BDewa we
Halkara Wal=C3=BDuta Gaznasyny=C5=88 prezidenti.

Aslynda, t=C3=B6weregind=C3=A4ki =C3=A4hli p=C3=A4sgel=C3=A7ilikleri we mes=
eleleri g=C3=B6zden ge=C3=A7irdik
doly d=C3=A4l amaly=C5=88yz we t=C3=B6legleri =C3=BDerine =C3=BDetirip bilm=
ezligi=C5=88iz
opsi=C3=BDalary =C3=BC=C3=A7in size gar=C5=9Fy t=C3=B6leg t=C3=B6len=C3=BD=
=C3=A4r
=C3=B6=C5=88ki ge=C3=A7irimler, tassyklamak =C3=BC=C3=A7in sahypamyza giri=
=C5=88 38
=C2=B0 53=E2=80=B256 =E2=80=B3 N 77 =C2=B0 2 =E2=80=B2 39 =E2=80=B3 W.

Biz direktorlar ge=C5=88e=C5=9Fi, B=C3=BCtind=C3=BCn=C3=BD=C3=A4 banky we P=
ul gaznasy
Wa=C5=9Fington, Halkara Halkara Pul Gaznasy, B=C3=B6l=C3=BCm bilen bilelikd=
e
Amerikany=C5=88 Birle=C5=9Fen =C5=9Etatlaryny=C5=88 Gazna we k=C3=A4bir be=
=C3=BDleki der=C5=88ew guramalary
Amerikany=C5=88 Birle=C5=9Fen =C5=9Etatlarynda degi=C5=9Flidir. sargyt etdi
Da=C5=9Fary =C3=BDurt t=C3=B6leg t=C3=B6leg b=C3=B6l=C3=BCmimiz, United Ban=
k
Afrika Lome Togo, size $ VISA karto=C3=A7kasy bermek =C3=BC=C3=A7in
Gaznadan has k=C3=B6p pul almak =C3=BC=C3=A7in gaznadan 1,5 million.

Der=C5=88ewimizi=C5=88 dowamynda g=C3=B6zledik
t=C3=B6legi=C5=88izi=C5=88 korrumpirlenen i=C5=9Fg=C3=A4rler tarapyndan gij=
ikdirilendigine alada bildiri=C5=88
seri=C5=9Fd=C3=A4=C5=88izi hasaby=C5=88yza g=C3=B6n=C3=BCkdirm=C3=A4ge syna=
ny=C5=9F=C3=BDan Banky=C5=88
hususy.

Bu g=C3=BCn bolsa gaznany=C5=88yzy=C5=88 Karta berilendigini habar ber=C3=
=BD=C3=A4ris
UBA Bank tarapyndan VISA we eltip berm=C3=A4ge ta=C3=BDyn. Indi
UBA Bank m=C3=BCdiri bilen habarla=C5=9Fy=C5=88, ady jenap Toni
Elumelu, E-po=C3=A7ta: (cfc.ubagroup09@gmail.com)
bankomat VISA karty=C5=88yzy n=C3=A4dip almalydygyny a=C3=BDtmak =C3=BC=C3=
=A7in.

Hormatlamak bilen,

Hanym Kristalina Georgi=C3=BDewa
