Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EAD4FAA82
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiDITlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 15:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiDITlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 15:41:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E084E255167
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 12:39:07 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r13so23457359ejd.5
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 12:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1Qfy/2iZl5Equ6kwyEmLCJfXh+EZ4X64S7GQfK4oQkM=;
        b=Og1XBWjWNAfZsadTFHc3DZR8X7Ta674zT/xw4W2/G8MCGK9l4VmoSW55+vjzA5wXeo
         yoy9um6RvSymxFeaM771TkecmdKpkiFfJp6QDkWv3pMS7pRXe7vx6MkKVj+E0W7F3IYy
         Rwyv/xRBh/LuyMknlh1f9y8ekHvUvi6iJ+BvQxXIclK9y+n2WpuYt2suuuEQA8qCNnuR
         qF8iUjdROqGtT3qoyBQQUOUoG/GmelTm1xuCNChKtdXZEvSSR0vOVhR3NAEuEyIKtVvb
         fuaM+2LBECjMt2QdzsbPYtdL8xhFUWUEIq+0lgckKCLLKVb1XUG589AElLbO9ePbuHSt
         hy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=1Qfy/2iZl5Equ6kwyEmLCJfXh+EZ4X64S7GQfK4oQkM=;
        b=xvSGHm2cx8PDhQk/yCKGdw4gGuxw73Xykt9Tc3j9ZGP4KwBut3OJvEeWvhJZb45wEJ
         W/MAX3YDYiQEJT13IlA9aAkRjYJ2ejRIfbNeSnrn8Lwxs9JfdsFv0gZsngeS3Gljwkwz
         kfg8N8/wmuglHY87ok3zPEv/v+VPm3yG+wFuODo5Vj0gRgQKEXSXb+Rr9Oh4paOnTQtG
         DlUTzd9gOCdOEIBX/mN+c04uUrnLyd9LAike1vvmLY2J6xwRnyS2+bbwMnxenOXWKB1l
         0ToB1ScNZdg1lO0fPNVa4MzvBRVIMMO0z+mC7l44I0eWIWE1tigUk8jgUZH+uvDVBjVL
         aBJA==
X-Gm-Message-State: AOAM5338IJIBqlnRTB/9xp0exGMPmnjNMVEkZszHmzbyRjR6X6SFaXjo
        LiCCGFHYKASDIZxszgc7j+4ZAjm0wFGewBINIpk=
X-Google-Smtp-Source: ABdhPJwUj4uhqGmku+Vs/stA3m278G5tcOWF3usqoL99at/pEScMYPr1Bh+JOqwTPvkMFnDu5RoTnpSimM9sAKDoXVI=
X-Received: by 2002:a17:906:2991:b0:6cd:ac19:ce34 with SMTP id
 x17-20020a170906299100b006cdac19ce34mr23803186eje.746.1649533146029; Sat, 09
 Apr 2022 12:39:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6402:190f:0:0:0:0 with HTTP; Sat, 9 Apr 2022 12:39:05
 -0700 (PDT)
Reply-To: douglaselix23@gmail.com
From:   "Mr. Douglas Felix" <williamcamacho5656@gmail.com>
Date:   Sat, 9 Apr 2022 19:39:05 +0000
Message-ID: <CAHTdREO1quFPY9kx7uiTGFqQ9ZWp643_mNA-9_nbJZ+cT36XSg@mail.gmail.com>
Subject: =?UTF-8?B?SHl2w6TDpCBodW9tZW50YQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=20
Sinulle l=C3=A4hetettiin joskus viime viikolla viesti, jossa odotettiin
sain uudelleenvirityspostin sinulta, mutta yll=C3=A4tyksekseni et koskaan
vaivautunut vastaamaan.
Vastaa yst=C3=A4v=C3=A4llisesti lis=C3=A4selvityksi=C3=A4 varten.

Kunnioittaen,
Asianajaja. Douglas Felix.
