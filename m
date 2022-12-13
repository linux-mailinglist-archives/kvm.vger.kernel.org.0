Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD23C64B332
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 11:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiLMKZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 05:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiLMKYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 05:24:53 -0500
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB782AFA
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 02:24:51 -0800 (PST)
Received: by mail-vk1-xa42.google.com with SMTP id g137so1305460vke.10
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 02:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sRtNStpydLHV5Nt1jK6RZ1BTkNH49s1fiWpqAsDikD0=;
        b=HQ6vWMAnUduwNrbce6jVl1wnCeoy9q1QtTDHYZlJ0Xo/kPir4uRrc9RZSLPLff1mrc
         gz3MourWo5e0u9pJDvNHaOWi7cGM2d7BIzqyeeRuEBjtxDDYSPRlDfoYVwhKOAq+8Ay1
         X5EfHveBYUqIrrDxnEv9t4LYLh67oinQZOYyea+y40Nj7zt5jyiUJBgzYRmzFv9HcDNS
         U8i5pIydvN1CdoYz9EmKsSPsBID2VruwYmjkaccEJ0PY13VbKmFaGhnELlo9+I9gCLxA
         bKGl0gkxY74i4cGufl15Az/a97CUkC8gdBfEsPsuVwioiIinZKjj9JQt5FV4zjGR4SXw
         wlLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sRtNStpydLHV5Nt1jK6RZ1BTkNH49s1fiWpqAsDikD0=;
        b=D/cET6TX8Pud44+YjsHk+xAdt2I7Ga7yzEbcieM0mBpnBFJpueX1G9H/Z/ku2+khIj
         T5HMh2MSEMdlUjvcAAg2fy/zsaFE/oN4laJzkUh0cd0c06jZgW6bxTiIOrLURMmMwoyO
         2jf32hNsJ47MBWwvG/GsjfIaM+qr0AsSdexbIS19nN50NcBGScOXst+57/S9WKV1CanJ
         5bVKsckrDxjcvk1W/MkZT/0X/Pq5EwzAHLLnK9QnoYKERRQsQ9pXQne7xexRXOtCzjoA
         V5MGV4IsImO5rQEEMUB96Ux3ZPh7Ir71eeSoJRkTuhME88lL103jX42nNPgfUya3aUKi
         fb6g==
X-Gm-Message-State: ANoB5pkwB7QDxOBVs3P6LLlOWQjy0XArMoJzlEzIJm8GKwlT3ibYQRgS
        qoRc7IwaJI27iPIlEwLGrknBTIrAA1TOqwhoEuY=
X-Google-Smtp-Source: AA0mqf7Z2j8oaxuMRCSum+oFFZO+jTl3IU/BGrVOpxusY1QthBJweweEPo9B7Z8sCZ0G0uIT7JQNvodofvcG8rYQQF8=
X-Received: by 2002:a05:6122:1437:b0:3bd:dc4d:fb7d with SMTP id
 o23-20020a056122143700b003bddc4dfb7dmr6631700vkp.7.1670927090242; Tue, 13 Dec
 2022 02:24:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:612c:2192:b0:2fd:df2b:9282 with HTTP; Tue, 13 Dec 2022
 02:24:49 -0800 (PST)
From:   Mr Abraham Morrison <abrahammorrison1940@gmail.com>
Date:   Tue, 13 Dec 2022 02:24:49 -0800
Message-ID: <CAPgV58NPbcB3MBeoTPWPWApzrO4H8AphHGMGyum7mS1eBJ57HQ@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aufmerksamkeit bitte,

Ich bin Mr. Abraham Morrison, wie geht es Ihnen, ich hoffe, Sie sind
wohlauf und gesund? Hiermit m=C3=B6chte ich Sie dar=C3=BCber informieren, d=
ass
ich die Transaktion mit Hilfe eines neuen Partners aus Indien
erfolgreich abgeschlossen habe und nun der Fonds nach Indien auf das
Bankkonto des neuen Partners =C3=BCberwiesen wurde.

In der Zwischenzeit habe ich beschlossen, Sie aufgrund Ihrer
Bem=C3=BChungen in der Vergangenheit mit der Summe von 500.000,00 $ (nur
f=C3=BCnfhunderttausend US-Dollar) zu entsch=C3=A4digen, obwohl Sie mich au=
f der
ganzen Linie entt=C3=A4uscht haben. Aber trotzdem freue ich mich sehr =C3=
=BCber
den reibungslosen und erfolgreichen Abschluss der Transaktion und habe
mich daher entschieden, Sie mit der Summe von $500.000,00 zu
entsch=C3=A4digen, damit Sie die Freude mit mir teilen.

Ich rate Ihnen, sich an meine Sekret=C3=A4rin zu wenden, um eine
Geldautomatenkarte =C3=BCber 500.000,00 $ zu erhalten, die ich f=C3=BCr Sie
aufbewahrt habe. Kontaktieren Sie sie jetzt ohne Verz=C3=B6gerung.

Name: Linda Kofi
E-Mail: koffilinda785@gmail.com

Bitte best=C3=A4tigen Sie ihr die folgenden Informationen:

Ihr vollst=C3=A4ndiger Name:........
Deine Adresse:..........
Dein Land:..........
Ihr Alter: .........
Ihr Beruf:..........
Ihre Handynummer: ...........
Ihr Reisepass oder F=C3=BChrerschein:.........

Beachten Sie, dass, wenn Sie ihr die oben genannten Informationen
nicht vollst=C3=A4ndig gesendet haben, sie die Bankomatkarte nicht an Sie
herausgeben wird, da sie sicher sein muss, dass Sie es sind. Bitten
Sie sie, Ihnen die Gesamtsumme von ($ 500.000,00) Geldautomatenkarte
zu schicken, die ich f=C3=BCr Sie aufbewahrt habe.

Mit freundlichen Gr=C3=BC=C3=9Fen,

Herr Abraham Morrison
