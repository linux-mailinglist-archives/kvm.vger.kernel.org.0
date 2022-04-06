Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F9A4F65C4
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiDFQik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbiDFQiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:38:09 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E764D1CAF20
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 06:56:58 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id i7so2438145oie.7
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 06:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=swiecki.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=xRcVj1lu6rUa306pADQUkHx6w5C/cy2Ix1ZuLuX6dX0=;
        b=g0mkLqx10xGd3U59raaHLB2ec0/RSvGXLw5ItyjLmCq42MQRNV6atkgJADbL4Rtu7C
         kv62mDKIBX+Wgyze2Q39VEmzpiRYcIo/1KFD++L7BK/nWp8SFkfTLBiArSm2yxMykaPy
         z3XkS16I/3ib3a3ysdBC9vAW4R8FjbKHfFVwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=xRcVj1lu6rUa306pADQUkHx6w5C/cy2Ix1ZuLuX6dX0=;
        b=xFqWDG8Mb1MHHZarZ0S/QCe5OJO4y4zcx8ZG2byt2fc3jyXYL10E99Nsu9w/5MV5/Z
         TVRZ4/Oey/rRaHpKTr0VP/yGQjR5G/Sa3cyAg93lCu2kh7IYy3KrehZ+WPHkSXRFB2CY
         vCe55LiFhRjaTiMfpdOBMXi2ruTgVHiiDA4ROOlpmalsAP66fhEuXdoJA5V/BFD2wqnk
         nOX7OSci/G/fX+54o3ESs2gyZanJKnSiSnLYTi6fqYl18tydF/ozaGHn0sZULMmxCvp+
         P2o/+3QlwvDMEpr2XM6bNooNCjCKcD0l0oz0b76bYRW0rlUfYsdfUEVfXICfGhG756+r
         ZMHA==
X-Gm-Message-State: AOAM533NqvfmZDDbfB7mBy2eqHsIrXHKmQYhqKdc34+TLNH32dFYCMTm
        +DDfXBWLICTQSQaQ6+dWAzNuBkiZrMvhfSXPRJUkGNhqAEc=
X-Google-Smtp-Source: ABdhPJzYXwWVJUYNXXTmvnWxkddtnZPCmDoFQxvX23y5+lrmOWb8MxLXzwlGqdXHqAKNPo88jXxFV6eC7WpMRchL+Ac=
X-Received: by 2002:a05:6808:14cf:b0:2d9:dcc6:8792 with SMTP id
 f15-20020a05680814cf00b002d9dcc68792mr3752584oiw.219.1649253418147; Wed, 06
 Apr 2022 06:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAP145phaXJAoQX8UAsqn1kFELdgYNVFyz4ok6U8C5Oz8kCkaYw@mail.gmail.com>
In-Reply-To: <CAP145phaXJAoQX8UAsqn1kFELdgYNVFyz4ok6U8C5Oz8kCkaYw@mail.gmail.com>
From:   =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Date:   Wed, 6 Apr 2022 15:56:47 +0200
Message-ID: <CAP145piuiNS7UnnkAtdZrADdbay_N-V1ibPQ5KrZ_EA_Pmxt7Q@mail.gmail.com>
Subject: Re: drivers/platform/x86/amd-pmc.c requires CONFIG_SUSPEND
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

> Hi,
>
> for Linux's kernel from git:
>
> I think AMD_PMC should select/depend-on CONFIG_SUSPEND, while it calls
>
> acpi_register_lps0_dev
>
> ./drivers/platform/x86/amd-pmc.c: err =3D
> acpi_register_lps0_dev(&amd_pmc_s2idle_dev_ops);
>
> and acpi_register_lps0_dev definition is surrounded by
>
> #ifdef CONFIG_SUSPEND

Ooops.. sorry, I think amd pmc is not part of kvm subsys. Please ignore.

--=20
Robert =C5=9Awi=C4=99cki
