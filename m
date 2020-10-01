Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FFB280126
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 16:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732388AbgJAOTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 10:19:40 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48390 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732213AbgJAOTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 10:19:40 -0400
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4CECF208D29F;
        Thu,  1 Oct 2020 07:19:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4CECF208D29F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1601561979;
        bh=gRILOaZwzXuEDThQmT3lRN89azKbKlISfs8qhivdJQk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Yltd1jsjVEs9a23wPYlT8obTLcr5ZFxncIx1+PTyf1dj4Ls+DUt/WNyAL2NyVt66N
         +0E7OD6CSAqCwnLIPYf4xOayhzW3lEXWw+yka6oeP49+2b949SISCN87MAftPOe0lZ
         nrzWJZGFQgK5+OOhsyeK/X+7x03kPeZdb0l1YRpQ=
Received: by mail-qt1-f177.google.com with SMTP id j22so960362qtj.8;
        Thu, 01 Oct 2020 07:19:39 -0700 (PDT)
X-Gm-Message-State: AOAM530fCFz3BeEtDFKqgV30f1tWsQaxj6K0/vyO6gl4SDoQDE/e9iXT
        3x1/WBHYl4YzNWzpEr5pmOwBCwlHK3OKq08Qp2s=
X-Google-Smtp-Source: ABdhPJxygM4E5el3vx0N2+obuCYeRN1VVxQ7968KJXXjFIhKRuSK2DQpJedW7kDKuN6tYP8KsvIxU+dsuddglMyPQOc=
X-Received: by 2002:ac8:545a:: with SMTP id d26mr7964752qtq.124.1601561978347;
 Thu, 01 Oct 2020 07:19:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201001112014.9561-1-mcroce@linux.microsoft.com> <87a6x69hbf.fsf@vitty.brq.redhat.com>
In-Reply-To: <87a6x69hbf.fsf@vitty.brq.redhat.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 1 Oct 2020 16:19:02 +0200
X-Gmail-Original-Message-ID: <CAFnufp1-rYvVFykL94r-XLCyO7NDFO6UjPVQi-FG2E=iVKh50Q@mail.gmail.com>
Message-ID: <CAFnufp1-rYvVFykL94r-XLCyO7NDFO6UjPVQi-FG2E=iVKh50Q@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: hide KVM options from menuconfig when KVM is not compiled
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 1, 2020 at 4:01 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Matteo Croce <mcroce@linux.microsoft.com> writes:
>
> > From: Matteo Croce <mcroce@microsoft.com>
> >
> > Let KVM_WERROR depend on KVM, so it doesn't show in menuconfig alone.
> >
> > Signed-off-by: Matteo Croce <mcroce@microsoft.com>
>
> I'd even say
>
> Fixes: 4f337faf1c55e ("KVM: allow disabling -Werror")
>

Indeed, thanks

> > ---
> >  arch/x86/kvm/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index fbd5bd7a945a..f92dfd8ef10d 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -66,6 +66,7 @@ config KVM_WERROR
> >       default y if X86_64 && !KASAN
> >       # We use the dependency on !COMPILE_TEST to not be enabled
> >       # blindly in allmodconfig or allyesconfig configurations
> > +     depends on KVM
> >       depends on (X86_64 && !KASAN) || !COMPILE_TEST
> >       depends on EXPERT
> >       help
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> --
> Vitaly
>


-- 
per aspera ad upstream
