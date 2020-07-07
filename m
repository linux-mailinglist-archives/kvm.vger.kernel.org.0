Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E17321665C
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 08:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGGG3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 02:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGGG3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 02:29:35 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BE3C061755
        for <kvm@vger.kernel.org>; Mon,  6 Jul 2020 23:29:35 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x11so16330893plo.7
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 23:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+RTRZTL952uD44udP+gYusYwiuZQqcIm9iMrkmjMeo4=;
        b=fMisAFudjFzYDE9oPrh1YvkFrw2sjhU8LhDoZVeVrPGY55xvkhP0bJKhYgMBQZaP1s
         ypEq6iZTkAfOfy8qN4cyy1YMw6qSIaJsk27u7Dxrql6d+rwPgffWJuJoym4UZgD7qgSh
         73k5HDt/UuPavyd+Tig5A/eO0wKTHSEF2FOg+nWwGHv4R56Lak1FAeLQGBDzANzoJjzp
         Tj8WJHo5C1EL0ayiLvrrF308y3N6MnDQgS4q48IER2RydJqk3PmLQELuLeE3OuL6ospp
         w7CnABEQc7b9NlJrkAFXDtAtLACjhp4ZiT3A271jZDEPk57C0aktEAuOaTDdAQrgbaW6
         f2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+RTRZTL952uD44udP+gYusYwiuZQqcIm9iMrkmjMeo4=;
        b=IYdAxgXh+fKXZ5WSLW/acUNW2gvukGqyw2uE0Volf0cA2QlcFUjRCEAeVmYkx1Qgkh
         meUf+bH4MJCObh1dkedRmXLg33Nd/qlCo7AmunhhcCdYQhzSqRWh/l5AH/MjyyDuyTxG
         LnAnR0cWG/JY1U5WgF3188FTiWrgmvg/c1eWP3gUWrOKymI3rTZcRy8FaXZ/Ch9DVFm7
         IKf8vKaYLHJIzxqi0I/lq6xLAq2LY6mUjk1CmHi2VN6S1yU5qQo5XRGFGRU2tr8Ln4ES
         Pkb1Xadhr5cK8Mjfe0ymUQzoL0UH0Q1JRtUlMlkukf25gpjkaYmp0eqp6fTFForVgstg
         AhNw==
X-Gm-Message-State: AOAM5305c80FvPZ6FqUlN9sbB6kWKtZ/GmgH+CQpNPH0BmFVpt0jxTrQ
        a2s5apA2fNytElgxNi2hBkk=
X-Google-Smtp-Source: ABdhPJzrqqswll8000CI7st45i4FzY1sq2QhjPw3E9Qcjke+8pvpOg6q3/B2Z9D3DCt4dCyzVSd2AA==
X-Received: by 2002:a17:90a:e2c7:: with SMTP id fr7mr2737663pjb.103.1594103374645;
        Mon, 06 Jul 2020 23:29:34 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:14d:2097:9aef:eb87? ([2601:647:4700:9b2:14d:2097:9aef:eb87])
        by smtp.gmail.com with ESMTPSA id g13sm1381691pje.29.2020.07.06.23.29.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 23:29:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Question regarding nested_svm_inject_npf_exit()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <773a4e20-3dd3-972c-8671-222672e54825@redhat.com>
Date:   Mon, 6 Jul 2020 23:29:32 -0700
Cc:     Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E3FBD050-816C-4FFB-A139-85342CDEAFF6@gmail.com>
References: <DAFEA995-CFBA-4466-989B-D63466815AB1@gmail.com>
 <f297ebf8-15b8-57d3-4c56-fdf3f5d16b9d@redhat.com>
 <2B43FBC4-D265-4005-8FBA-870BDC627231@gmail.com>
 <CALMp9eTDCDNctpso23uv+gM0QZUEBzMw47-M9JfNaG79fusa2A@mail.gmail.com>
 <773a4e20-3dd3-972c-8671-222672e54825@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 6, 2020, at 11:02 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 07/07/20 01:26, Jim Mattson wrote:
>>> Well, I think we can agree that bare-metal is a better reference =
than
>>> another emulator for the matter. Even without running the tests on
>>> bare-metal, it is easy to dump EXITINFO1 on the nested page-fault. I =
will
>>> try to find a bare-metal machine.
>>>=20
>>> Anyhow, I would appreciate if anyone from AMD would tell whether any =
result
>>> should be considered architectural.
>>=20
>> I'd be happy to test on bare metal, but I'm still waiting for
>> instructions that a script kiddie (with read-only console access) can
>> follow.
>=20
> I'll try to test myself and prepare some instructions.

Sorry for the late response (divorce, it turns out, is very time =
consuming).

I will try to send you scripts later on, but I did not automate things
through the iDRAC.

I managed to get an AMD machine, but unfortunately non of the tests run
on that machine. I am still trying to figure it out. I will update you
once I make progress.

