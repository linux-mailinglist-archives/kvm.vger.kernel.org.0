Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429E828BFA3
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgJLSXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgJLSXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:23:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9144C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:23:43 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y1so5536185plp.6
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9PwxBBDKmvkuwQSQr3vH+ZWAG8YZjRrapYQ4w6y/v5w=;
        b=foHTX7OiCk9GnlVpqZrgBAkD+QYPVEYCvIPLCbJX0GkcRGhB5g3Fc5EL2Nk0SEU9r7
         Ez7TVg/zKeN0uDLPMjAIYCCj/6NBMgLDYIRvCtE48fJfPO4/BuRmnTcZmd2jTa+N/hh+
         3YnYAT31Wdn5MPFmF4PAy7NvKGRIwCUrvBamfznEx6+oFeYrqQjrzeptObV4dQjUNW6o
         XMxtmYG/3yJahO3TnIz4fVOwEhxkJW75U/qh8yP0owylIrKm1S7KFvH/W3a2TWkA6hX2
         0baHJrXg7+KIIJGpq6YEKf9IHFMMsXdh6L2ufNXTyz3hU1pT0LXuHZoWgMnCnnjVdXpL
         fg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9PwxBBDKmvkuwQSQr3vH+ZWAG8YZjRrapYQ4w6y/v5w=;
        b=CnOE7bf0gqq2M719dj5Tx8l/p8vlYz7BCDRFl3C/rFoTbcLFTCuS84eozdydEGJF6c
         tco2H1WUuvyNvA9AWBcUDP9flw52UrQFnNnsjoQh/PtEutkPA6N1scibLWFZheUUpQpy
         a4n+0DD90AjzeVhjAPGQh8yyUfRhIcVRWAw4xHnNeBJQZmXFvmY5lMAlhUboQJgi8Dg9
         9wxMFLTpeS459kkKdnyqBW13x580WPOhltPWaAjwrqkr9Fw5EctlihXjY03csMdWPoJc
         RNgOD0BoW6t8SseHuqn4kpYa+jNqBRshsjbf73IGvQLHnR45o/HYz50fJOO77lU9ZbAG
         B4Vg==
X-Gm-Message-State: AOAM533JyGIv8jQV5kTRmu50jsa6+5LOe8mvxpnETGsngB5bELvUXK2z
        9no1hRG4wbIKN9Kb0Cieu/I=
X-Google-Smtp-Source: ABdhPJw6wOPT+Z6YpuKLURpx0EfFv/XlH16g+89KMwQL6dFkj8jSG8jsp9HPL1/3UFRK9Jo7SO+hMg==
X-Received: by 2002:a17:902:9694:b029:d2:1b52:f46 with SMTP id n20-20020a1709029694b02900d21b520f46mr25788016plp.78.1602527023031;
        Mon, 12 Oct 2020 11:23:43 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:8cd7:a47f:78d6:7975? ([2601:647:4700:9b2:8cd7:a47f:78d6:7975])
        by smtp.gmail.com with ESMTPSA id 38sm9242013pgx.43.2020.10.12.11.23.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 11:23:42 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Add test for MTF on a guest
 MOV-to-CR0 that enables PAE
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eQBgJwLLk-9in=v1wwrj2_p5T3aLfaj79Y6Yzh+CEE1SA@mail.gmail.com>
Date:   Mon, 12 Oct 2020 11:23:41 -0700
Cc:     Peter Shier <pshier@google.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EBDAAC1E-1B27-43D6-AAAA-B8A7003CD45E@gmail.com>
References: <20200818002537.207910-1-pshier@google.com>
 <4A2666E9-2C3F-4216-9944-70AC3413C09B@gmail.com>
 <7C2513EE-5754-4F42-9700-7FE43C6A0805@gmail.com>
 <CALMp9eQBgJwLLk-9in=v1wwrj2_p5T3aLfaj79Y6Yzh+CEE1SA@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 12, 2020, at 11:16 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Sat, Oct 10, 2020 at 2:52 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>=20
>> I guess that the test makes an assumption that there are no addresses
>> greater than 4GB. When I reduce the size of the memory, the test =
passes.
>=20
> Yes; the identity-mapped page used for real-address mode has to be
> less than 4Gb.
>=20
> I think this can be fixed with an entry in unittests.cfg that =
specifies -m 2048.

I prefer to skip the test if the conditions do not allow to run it, as I =
do
not use unittests.cfg.

I will send a patch later.=
