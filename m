Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEB74F6504
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbiDFQPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiDFQPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:15:05 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2AF181D8B
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 06:53:21 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q129so2448184oif.4
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 06:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=swiecki.net; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fNiKzbZhrJ0Z2qVtDhslCPoPc5n3HoH+qCBekqgMrqo=;
        b=W554+Z9ZJ8Q2GbQYz3klMq5zH86HFr/GqNSOftcxVELKHu4iY8mrREmfA+I3YPaz1O
         wR7guoEkAYo2iSljE2g82kbOd2B1e6BGccNewF6lnh7aXSSY5vYEhzK/ZMPOs914dhHm
         sBLSFHj1izrBjrOLrKbi6ETOsUMiKD1aSSgCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fNiKzbZhrJ0Z2qVtDhslCPoPc5n3HoH+qCBekqgMrqo=;
        b=Yhq1uPkLlaq+TI7vOCoVF7s23aCFomFF9Q+ACw8QvWLwpoxZjaJ1VweqJRbZqbCPl/
         EMKlqlgEyoK5gj5sxC2wDinVGfky00v7cUMiLt7Qn1f4urovj0FTkFXSiGXVgNr58QVT
         A10eypw9aMWLqsBnkOqGGiUxGafs++dGkvwZBYM0yMhU6w2qsSEIKt3e1ttowOazKLBD
         mjqDvChDbTAx93ORw2pW+MNBv1oOLMl3SMuoIuHGggOWIPok9EbJ4X8thXBqtRbcovL4
         w+JBKdgVVb1UnpkBy8j4bchSegDmQUf/qvaFjxvmURPU+yMTZSAkTppYb3V5nHa5CV1k
         pooQ==
X-Gm-Message-State: AOAM53195S0SxTZUZMv8b1gyu8egGw+nRyKBR3IoaR3zHecM4M9XKpM/
        ZvVevpfdVE0pt/avS8hZlmmUm71xTUTzFczJh4PvgMQ8XsCXpQ==
X-Google-Smtp-Source: ABdhPJxDVfGT9phLXgBa/CCRjmHFNDcMokkrnS28dEYx5US2wxSe/iW9JtP9fT20F03pg77yf9wxUm/oF+GZJOLBaFI=
X-Received: by 2002:a05:6808:28b:b0:2ee:36b8:8619 with SMTP id
 z11-20020a056808028b00b002ee36b88619mr3600056oic.275.1649253200570; Wed, 06
 Apr 2022 06:53:20 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Date:   Wed, 6 Apr 2022 15:53:09 +0200
Message-ID: <CAP145phaXJAoQX8UAsqn1kFELdgYNVFyz4ok6U8C5Oz8kCkaYw@mail.gmail.com>
Subject: drivers/platform/x86/amd-pmc.c requires CONFIG_SUSPEND
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

for Linux's kernel from git:

I think AMD_PMC should select/depend-on CONFIG_SUSPEND, while it calls

acpi_register_lps0_dev

./drivers/platform/x86/amd-pmc.c: err =3D
acpi_register_lps0_dev(&amd_pmc_s2idle_dev_ops);

and acpi_register_lps0_dev definition is surrounded by

#ifdef CONFIG_SUSPEND

--=20
Robert =C5=9Awi=C4=99cki
