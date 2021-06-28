Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064D33B66E8
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhF1QmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 12:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhF1QmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 12:42:18 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E54AC061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 09:39:52 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id g19-20020a9d12930000b0290457fde18ad0so19405240otg.1
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 09:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=902eAWMv5ipiq/bYMJrSz0Lqst1L2tCLc8+/C521zeg=;
        b=Srj8TY5XSww8YIXM8al1Oskt8S0Etqtf4Bs6BqwYPawuGMZqsQrAH5FWaz45qoppHv
         nnhJY/lviEvRHHUTmkrSSoLSxELe5R+DcoFS3xCx7IdQqlZ818OFhkudWsEGszOfEoKI
         jmEL2Brh0c7azylG6H94rnEY98SG3HAWULy5ssMnUnZD4xkoN7b869wyobhaR1BOnypJ
         M2MNz7+udfJ2daZYyc/aT/0fMRuw9hvJH1Z2QqNSliLDwpdS5qf9EVkAW/CF3tcs0fcP
         toB3GpJ+9IVgnNf4TU42M3UNgn8GLlsPWe6mQnMTEspnnxXfZ2PCCZrMQbSR2gf6apfm
         q/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=902eAWMv5ipiq/bYMJrSz0Lqst1L2tCLc8+/C521zeg=;
        b=FOVt3OGWTgsPHbEu7H3S3pSp9qp76BGrb84rmG4ZmTqswDaij9NtvdazJkjJEjbdN5
         z2hh5VbgGvgHB3hcKEK7Mr9T1lzuILBDUYjk4ftMOJ9mYAWdMx47arUon3bOdRoNUdzz
         tRRPRIYkhLvgw2odX9+FKzuMTYcb1m+cgZWbPwS4DnaLQncHZel9zsp1eUMmah0esGZa
         D+2ZOQjDpxwdzb+yZSF1k10oti7jAYsl1a+VTIrnH9GExXig8hIkAqWak1T8xC0LNpjC
         E3vtjYErtCYWyjmMbjaoYxBtjc0UYDejHKt41YetA8a/UQ2K3nGLjM2qQBRl5uWbhB2a
         WfRQ==
X-Gm-Message-State: AOAM53367mvuLXRboT/ZfuFXJCVnlBRWX/tHfbtL5mYqmR3O/HT/yH9o
        FTBatX7N+eV+x7Jut+OocHwOcRxzKsqTsI+QNBRetg==
X-Google-Smtp-Source: ABdhPJzkJsq+y+xvUJsgTcox+V1+MiHQBju5JHDPUZ6D3On0HMSaonm5zQErjMsK79yUWxegXRklUx30XduXoRD73j8=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr376697oth.241.1624898391199;
 Mon, 28 Jun 2021 09:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210627233819.857906-1-stsp2@yandex.ru> <87zgva3162.fsf@vitty.brq.redhat.com>
 <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru> <87o8bq2tfm.fsf@vitty.brq.redhat.com>
 <b08399e2-ce68-e895-ed0d-b97920f721ce@yandex.ru> <87lf6u2r6v.fsf@vitty.brq.redhat.com>
 <17c7da34-7a54-017e-1c2f-870d7e2c5ed7@yandex.ru>
In-Reply-To: <17c7da34-7a54-017e-1c2f-870d7e2c5ed7@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Jun 2021 09:39:39 -0700
Message-ID: <CALMp9eRJedCx6AMW+gMBMeMvGRzn6uzB0wtAzTDRLdYMB1Kc5Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 4:27 AM stsp <stsp2@yandex.ru> wrote:
>
> 28.06.2021 13:56, Vitaly Kuznetsov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > stsp <stsp2@yandex.ru> writes:
> >
> >> Yes, cancel_injection is supposed to
> >> be always broken indeed. But there
> >> are a few more things to it.
> >> Namely:
> >> - Other CPUs do not seem to exhibit
> >> that path. My guess here is that they
> >> just handle the exception in hardware,
> >> without returning to KVM for that. I
> >> am not sure why Core2 vmexits per
> >> each page fault. Is it incapable of
> >> handling the PF in hardware, or maybe
> >> some other bug is around?
> > Wild guess: no EPT support and running on shadow pages?
>
> That's something you should tell
> me, and not the other way around. :)
> I am just working with kvm as a user.
>
Yes, with shadow paging, kvm intercepts all guest page faults. You
should be able to replicate this behavior on modern CPUs by adding
"ept=3DN" to the kvm_intel module parameters.
