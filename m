Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52510792844
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjIEQD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353844AbjIEIU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 04:20:57 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C9BCF0
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 01:20:53 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-529fb2c6583so3024905a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 01:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693902051; x=1694506851; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CvUmRYKO5rN5JiKdYLn9/Xxm/soJiVGtQm650JnL3Yc=;
        b=WyyvPMEfe4FOVqHOIWdr/B2P0p03RPzGq0eAy6olIuEmDr190DF60UMTUjSzD3ICzN
         0WsAegs64/BiRqCpXkN1qURw3kJmTI2wMa8rTaukjr0/l9jhm+3ubCn9+y0oKw0Vf/Ks
         YIRtHy/tktgd0JCbt9j66zUkqNxhaH1k0FzKmAu+yKNICqHvkjDH6q7yKGNLfZeY066C
         rjUXbiHJ42XZriL2gTX15/F6y+Se4qD3ChTlmHmU/A+Bl1kzMG1cMn1BnC25iR+qjjlJ
         Ikwy1nXebC5hCeU4AgcZQ4VZpVOWulwi6FywqPblj59NiPYUSn0tuU6Bbo6p4XZRvT/F
         gtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693902051; x=1694506851;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvUmRYKO5rN5JiKdYLn9/Xxm/soJiVGtQm650JnL3Yc=;
        b=dBi+rRjGo7GY0mn0yLWmbZzVLFw3bXqnK8ZL/HXJLzv9UMRAeVtAuFJ0e0v2I415Bd
         sMO6HOn2PohEzioXlLVYBCGthVd2sv8HcxFc7iUN6hY8uCQHXgVF2AgGjN6RAjzSE8kW
         U9ZM0Uv+h9NO4GNJS8RtocWjKhK2OBce18r5VDhMB70BXZNZLp0U9BzXmGa0grjPsYCP
         MYGgJpbB+uU7bkJEuwJ4tzcvqjifLPgljVn/8n26g8Rhf2Q1aNZdiqx5f75pDmmF0A3h
         DiDG8DzJXNfVyH5EqIPZGx/lxpN71ZA6Ax/1917zpkodE4aJKJTOE1o2OR01fsRr88Fx
         PgkA==
X-Gm-Message-State: AOJu0YyD/Fttx/GySIm+gGXOHVo1q67KISm5pru30I+vIRjWv/SMSjAS
        fyfF/1M6izhELYdF5IFDmHZGRFS9IRqAHXkK/EQ=
X-Google-Smtp-Source: AGHT+IHc9ajH3Rii9UZwOOqLrsXanmcTWvKjiURPKmJK5D52sTkbD7l1BRzq/bCfrfUZjlWt/04s1jIBCk3z7CpHIFE=
X-Received: by 2002:a19:6755:0:b0:501:bf37:1fc0 with SMTP id
 e21-20020a196755000000b00501bf371fc0mr624754lfj.33.1693902050884; Tue, 05 Sep
 2023 01:20:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3ac4:0:b0:22f:40f:e031 with HTTP; Tue, 5 Sep 2023
 01:20:50 -0700 (PDT)
Reply-To: wuwumoneytransfer5000@hotmail.com
From:   "(IMF) SCAM VICTIMS" <mimichi4500@gmail.com>
Date:   Tue, 5 Sep 2023 01:20:50 -0700
Message-ID: <CAGhkD8USA9d9+1HDw3AKO0o45v_Z8cjdpcgnjTbVjdDUbiyg2w@mail.gmail.com>
Subject: Betrugsopfer
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sehr geehrter E-Mail-Besitzer,



Der Internationale W=C3=A4hrungsfonds (IWF) entsch=C3=A4digt alle Betrugsop=
fer
und Ihre E-Mail-Adresse wurde auf der Liste der Betrugsopfer gefunden.

Dieses Western Union-B=C3=BCro wurde vom IWF beauftragt Ihnen Ihre
Verg=C3=BCtung per Western Union Money Transfer zu =C3=BCberweisen.

Wir haben uns jedoch entschieden Ihre eigene Zahlung =C3=BCber Geldtransfer
der Westunion in H=C3=B6he von =E2=82=AC5,000, pro Tag vorzunehmen bis die
Gesamtsumme von =E2=82=AC1,500.000.00, vollst=C3=A4ndig an Sie =C3=BCberwie=
sen wurde.

Wir k=C3=B6nnen die Zahlung m=C3=B6glicherweise nicht nur mit Ihrer
E-Mail-Adresse senden daher ben=C3=B6tigen wir Ihre Informationen dar=C3=BC=
ber
wohin wir das Geld an Sie senden wie z. B.:


Name des Adressaten ________________

Adresse________________

Land__________________

Telefonnummer________________

Angeh=C3=A4ngte Kopie Ihres Ausweises______________

Das Alter ________________________


Wir beginnen mit der =C3=9Cbertragung sobald wir Ihre Informationen
erhalten haben: Kontakt E-Mail: ( wuwumoneytransfer5000@hotmail.com)


Getreu,


Herr Anthony Duru,

Direktor von Geldtransfer der Westunion
