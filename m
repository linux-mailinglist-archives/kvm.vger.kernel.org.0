Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A911E95EFE
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfHTMiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 08:38:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40425 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfHTMiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 08:38:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so3184787pgj.7;
        Tue, 20 Aug 2019 05:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nPEeXkHVugtuWFlIz8GtMsMv1+S0Lha6cbNZpxpRArU=;
        b=LJOIlwqNYHXD7cHZ6EOsmob8xvknsOMLrMfO5zhrO/hlOWCbl9oRhwtm6GgYdix2xu
         er230DjbgsQiYIUvGeSCtB/XU+iCevsrploFnAK3HjojGToNX3MeX+f3z/WRg2j1Q7xa
         vUTX4He41+Um9Hj+tyTyBgDEwdDaMgrIqsgXJom2/xdfqHRguDhVy+xCHIRVJUg35sw2
         v39oOT5FZyi8moTwiCsatiaiE1FMrKTuHTp/hDmSNmT68FzLGFXSH8cJpKBoqkVfqXIF
         kN8k2VksGohU40xiIxRPVyFZ9SpWPms3lbT/tIhWAMUB9tF+4pGAzRm8ZMgvLl5RqOOF
         cEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nPEeXkHVugtuWFlIz8GtMsMv1+S0Lha6cbNZpxpRArU=;
        b=rsDxLZB8Ol9Z1JkEpKv7TqgFOIFUX4cgnQormXapeQlUs3p+J3FLlwJG+1Bqsd/b4F
         5pSJ/xOmZJWEa/I5klFwN3Qyj0W1gee4GIFxuqg5fk1r2mbrPq0aBX0m1CFhCKqzaDjp
         MWODilI6oa5T4UyWSdyHTSKkWsv8JIwLsHHgezGtibP8u2ZKMQwLuxL6I0wyPIpUWWEX
         S7LW0blJQTZOCYA3ijcvYPXMEGEuskGuTg+sMcPtsDjnHRwpw1l36FKO0LEdL75Ny28V
         K+rg2+6zEZIpGSsIE0Qg32lFnILS2VgKyfSj+g4ZW5YiW/rdqfdYylGIC4n+ZmpQpwmQ
         LwWA==
X-Gm-Message-State: APjAAAUd3nO+H5mBxAhsL321nsAJBJQlIUzSS98G9UsaVvwEZt3faF5a
        aMXxrrOM1Y+F8z8IKqnWQJ61qiLin4FDPv1KxnQ=
X-Google-Smtp-Source: APXvYqwggjmfndZ9vdx+84JSw4dPC+8rQAoRcmAZ/Rgr8ykhjxqa0jdGrCOY5Bb3JWVdr8YvApTm37u9Tm5cVXV+lE4=
X-Received: by 2002:a65:5043:: with SMTP id k3mr25355913pgo.406.1566304701388;
 Tue, 20 Aug 2019 05:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
 <20190819131737.26942-3-Tianyu.Lan@microsoft.com> <alpine.DEB.2.21.1908191522390.2147@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1908191522390.2147@nanos.tec.linutronix.de>
From:   Tianyu Lan <lantianyu1986@gmail.com>
Date:   Tue, 20 Aug 2019 20:38:11 +0800
Message-ID: <CAOLK0pxPKh3Gr8TVPqGernoHSTY=UyjwjqC4wEyR=Vo500ygFQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] KVM/Hyper-V: Add new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, corbet@lwn.net,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        kvm <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas:
               Thanks for your review. Will fix your comment in the
next version.

On Mon, Aug 19, 2019 at 9:27 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Mon, 19 Aug 2019, lantianyu1986@gmail.com wrote:
>
> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> >
> > This patch adds
>
> Same git grep command as before
>
> >  new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH and let
>
> baseball cap? Please do not use weird acronyms. This is text and there is
> not limitation on characters.
>
> > user space to enable direct tlb flush function when only Hyper-V
> > hypervsior capability is exposed to VM.
>
> Sorry, but I'm not understanding this sentence.
>
> > This patch also adds
>
> Once more
>
> > enable_direct_tlbflush callback in the struct kvm_x86_ops and
> > platforms may use it to implement direct tlb flush support.
>
> Please tell in the changelog WHY you are doing things not what. The what is
> obviously in the patch.
>
> So you want to explain what you are trying to achieve and why it is
> useful. Then you can add a short note about what you are adding, but not at
> the level of detail which is available from the diff itself.
>
> Thanks,
>
>         tglx



--
Best regards
Tianyu Lan
