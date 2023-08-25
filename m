Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A2788358
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjHYJQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244256AbjHYJQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:16:29 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2E1212F
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:16:07 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id a1e0cc1a2514c-79df12ff0f0so268325241.3
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692954966; x=1693559766;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wxq2oGqCI7AunaqHz3ITOv6tKHtmwrhrpWQ7PfpfKwk=;
        b=nxG7F9fttBTGblPicn0kXF0cSRW/0TrJZfk0WvAKtEgie3dJyZJK1vQofJ/FrJiXfj
         5mbbu8+PsctnUxURDsQTKFwIkKZnh/J+VXf19DdhrpiYYx+axsdkkP6GeKpPVRRM0Tdi
         2/7YH1R4F3yFCIEN0aEOcl8oIZ92YmgCI+9i4f13Od2V3pvOXFFktMcu7GmP51MEePSl
         tZZ+mIE/xV3a7Z9gDhhuFkZEihIMHbhuHpMxvX2o49zIhYPkh2YLUhZald73u2QQXwey
         G6Tbwwiia2Cpb14DRfoRDUcoAB27ftgmHn7QdgBq1Anc6KojGmAQjKDGsDeH0VNfDApN
         7eXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692954966; x=1693559766;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wxq2oGqCI7AunaqHz3ITOv6tKHtmwrhrpWQ7PfpfKwk=;
        b=YNYVvQduIV3evPBvmQ95DPug1VNtXilkPfqsokrmwpQ1sx5p/Ar9/ssLydowPygmB7
         okAHN3zfkGO/n6acDb9hgPAfiOkDe7lARFBgXcHGBT12KsqGgAaQ3SjRZThd1GNT2KMa
         31Y1xCmOlF+qw1OXFjERwVNl/eNDF9z2vbjci4oaYUGRwH5rSmFzLBJkhtmnQ4C7mf0W
         rK4Iwxk5DI8eOdwTV2muq2TOedTfhHWLuXgaQsLk35oedaasZq+/pmfQOfljY8knVJTW
         5L2ymF88h+Bv5Mex1QzIi20PzmLr8hfhwhVGKwBHT9eFgjnQJ4MYKeXB4xC1iMkLrxg6
         qCPw==
X-Gm-Message-State: AOJu0Yw9NM/UBx3SbpoDVedlgIuY5u8iXPuvyzxheyDNd4mzB7B83jB5
        l5bFrG7aDEII1eVOOsP1kJh/NaQEnSQdtqmXfMQ=
X-Google-Smtp-Source: AGHT+IHzlu67/zOY+lo95h3tmB5DG0hgI2zTbw5Xyo9AkKCFTHAg8Zu5mu0LV81XILxs9r4AAJARikM4LLeK+t5S7jQ=
X-Received: by 2002:a05:6102:e4b:b0:443:5943:4f7b with SMTP id
 p11-20020a0561020e4b00b0044359434f7bmr17191159vst.13.1692954965881; Fri, 25
 Aug 2023 02:16:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:af2a:0:b0:3da:250d:8b87 with HTTP; Fri, 25 Aug 2023
 02:16:05 -0700 (PDT)
Reply-To: johnoffic@hotmail.com
From:   Diageo Company London <michelleriichard@gmail.com>
Date:   Fri, 25 Aug 2023 10:16:05 +0100
Message-ID: <CADosMv0ftJbeCyrz0S_PnQAW1FZqJcLXi9VNx=20JRc16ZBU7g@mail.gmail.com>
Subject: Necesitamos un distribuidor de ventas.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

25/08/2023

Dr. John Smith
16 Gran Marlborough St,
Londres W1F 7HS, Reino Unido.
Compa=C3=B1=C3=ADa Diageo Londres
johnoffic@hotmail.com


Estimado amigo,

Mi nombre es Dr. John Smith; Gerente de Ventas Internacionales en
Diageo Company Londres, Reino Unido, Diageo Company est=C3=A1 buscando una
persona confiable en su pa=C3=ADs para ser su representante como
distribuidor de sus productos y marcas.

La Compa=C3=B1=C3=ADa le proporcionar=C3=A1 un 50% de anticipo del producto=
, si est=C3=A1n
convencidos de que usted es confiable y tiene la capacidad de
representar los intereses de la Compa=C3=B1=C3=ADa y distribuir los product=
os de
la marca de manera efectiva en su pa=C3=ADs y sus alrededores para obtener
ganancias.

Le dar=C3=A9 m=C3=A1s detalles despu=C3=A9s de escuchar su declaraci=C3=B3n=
 de inter=C3=A9s en
trabajar con nosotros y si est=C3=A1 interesado en ser distribuidor y
representante de Diageo Company en su pa=C3=ADs/regi=C3=B3n, por favor resp=
onda
a este correo electr=C3=B3nico indicado aqu=C3=AD [johnoffic@hotmail.com ]

Atentamente,
Dr. John Smith
