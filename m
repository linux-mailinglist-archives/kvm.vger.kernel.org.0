Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2314BC8BB
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 14:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbiBSNqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 08:46:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiBSNqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 08:46:47 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AE3B63
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 05:46:28 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id y16so2754279pjt.0
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 05:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r8JotbY5i2w4Zt7zHBdThDre/U54uU8dSMK/7cc5hDo=;
        b=WE2uYkM2JntWwiDSJJmhmd4Rj3IylEredf0S7nyvKMKChoyDQ+tBi4OUjY71VnQkpr
         O0Dh5pKyFf7c2dbVcTMvjASSYwTRVKFuaz7Y47ABnQS60FmGE1ZSKgVafiAaNWFruKPE
         2IQoOHgwzahbMl4OsuUGHlhsr2Em+CAy0YeBnYV0PPUQaEMatQ4bQsJ8MwYq/2lWKyyG
         IUrIT4jStezKaAyBVEdU7qa4o429jtCQphjFcP5kyibZDITah7WBvcPyztBX1DEfE1DX
         8wsQp3gO153afwhFCAJN1Z4Y5niyBrHF2b4pVV6+IXFdmqu8ze4vICPIeqpfgMyviZg6
         BvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r8JotbY5i2w4Zt7zHBdThDre/U54uU8dSMK/7cc5hDo=;
        b=ac4U4hCLFKGaYRWj8XYYNY4yECVbcuTyqmuCMk9zHTk6ns4nhyCSSzbEF09Cjq69UV
         vwIZmK1U1cYl5yOUrENk7r9mV32M5NRrmY8FSfNaeMFaNHlwKYnOJRGzz6p+zb1DZ6Jj
         wlpAiRPaiiP1kUNj5OlZqZB1ttmsVu08CUrkZOnRa7Qdq6CHb2W7g9NF+ULgzWJuzo6O
         Sme3BqvuR9ZSDffaD3IfaYEuf9V09H8M7RJAFQoyl0GTtzFxFcFVJSnhBS5Y+ZBhqS9X
         yNq07USDTih4ZKVeEhpTeZgtm3ma6HV3L4EZ9xPwluad/T7/1eTTLLZlQgXLoC3rmzB1
         7rdQ==
X-Gm-Message-State: AOAM531KTQDo+ZZKb3PAMmuXKMD6bPbLGYJcRBUL8s0c2s+X+5qBVAG4
        m2nx4dnVdfuBQvdhqSI1IIcKZ18Z1YMfan33E+OUqkrf
X-Google-Smtp-Source: ABdhPJzSmBwPqNDaIwav1DndGpgFXRQ2Hr/qn6Nad+yEtKdwLOkKZXRxvB6NKhUuJKL3XpVPfRTBd9RsXcsz6qSLdks=
X-Received: by 2002:a17:90a:d3d0:b0:1bb:f5b3:2fbf with SMTP id
 d16-20020a17090ad3d000b001bbf5b32fbfmr2977553pjw.87.1645278388162; Sat, 19
 Feb 2022 05:46:28 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com> <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
 <ad4e6ea2-df38-005a-5d60-375ec9be8c0e@redhat.com>
In-Reply-To: <ad4e6ea2-df38-005a-5d60-375ec9be8c0e@redhat.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Sat, 19 Feb 2022 13:46:16 +0000
Message-ID: <CAJSP0QVNjdr+9GNr+EG75tv4SaenV0TSk3RiuLG01iqHxhY7gQ@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Feb 2022 at 16:03, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/18/22 12:39, Michal Pr=C3=ADvozn=C3=ADk wrote:
> > On 2/17/22 18:52, Paolo Bonzini wrote:
> >> I would like to co-mentor one or more projects about adding more
> >> statistics to Mark Kanda's newly-born introspectable statistics
> >> subsystem in QEMU
> >> (https://patchew.org/QEMU/20220215150433.2310711-1-mark.kanda@oracle.c=
om/),
> >> for example integrating "info blockstats"; and/or, to add matching
> >> functionality to libvirt.
> >>
> >> However, I will only be available for co-mentoring unfortunately.
> >
> > I'm happy to offer my helping hand in this. I mean the libvirt part,
> > since I am a libvirt developer.
> >
> > I believe this will be listed in QEMU's ideas list, right?
>
> Does Libvirt participate to GSoC as an independent organization this
> year?  If not, I'll add it as a Libvirt project on the QEMU ideas list.

Libvirt participates as its own GSoC organization. If a project has
overlap we could do it in either org, or have a QEMU project and a
libvirt project if the amount of work is large enough.

Stefan
