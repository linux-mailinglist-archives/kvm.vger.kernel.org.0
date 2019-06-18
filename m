Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8208949731
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 03:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfFRB4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 21:56:35 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44039 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFRB4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 21:56:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id k18so11279598ljc.11
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 18:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tqb5lHdVPB49oLMMk4+mZvKGrja+z+HUESTuUI6uhKc=;
        b=X526yhuWFcSRj3zadUa8T+HHpW5ML5QJcaozRsGhmuG6cwq6lR0YhjolSpl+gURYdN
         5f7YvKhntVzo8/GGYMLsiRnoSBEqAzj21sZbgh1Cf0WN6tAc66tNAQFtWK0rHcDi01Tg
         I1OcDijTTUe1dupdEInMx02g+cVKJW4qWB8HAcXsZYY3I+ChOvIWMh4AI2uN+W2kE1pj
         VfR/iNJbe9pOfOUWvfGU/T+nnMQjqHXPBpint2FmZPk5LDMrt5fdQDVsBf9dYEDF2fO2
         v1ehXiH8IacapsX+4n0bMftklLWK80Uw5igvbvnUTOlWOU9QxqbIz1OURGTXwNbvAkcN
         kbfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tqb5lHdVPB49oLMMk4+mZvKGrja+z+HUESTuUI6uhKc=;
        b=GPvBy6ok0mjex85Wa9xuxAjSPowtGGUJC+B983e1jwEly26Gh3DzaeMJ/ZJJ6PUxZ9
         g7hBCNub2AbKYKPO8ePWZFwwhJp71z7F1o34Bt4pBhPUB6iMqAnkB/uyFtDg/WAUR24H
         63EhRJSCtQnNIdPTprbIj+Vk7RKmuQGIoqff8MFMW/nYoQ9dC4K48t6kXslGo9iZ4N07
         Hmi6XUBFoj++gAMunWkKI1UOtt55VP6niYrS8KzImVwNGN99zHNSre+ZbuVs8V46zsLi
         X4iFTFKy0n0uI2wFP0Ze23u381u9yg+UsKAAnhaFLU+NMx13bEgqFz77mxT2fFfJH17h
         QU+w==
X-Gm-Message-State: APjAAAXRzQNRmD92i01Hf9CBlCbQMvDfyghmkP4fOIiDFElvnmqvKwCa
        V7NUjdi9Wh/NbR5fFq6p/6fgLs6/LK5etHneMpGZfg==
X-Google-Smtp-Source: APXvYqyi+sdX7eHGoTd5uBzh4li4owo8ThVnY9dZG5qfFp8vQWNTEZzXLHrCmJ1qGfPqW2g57BgmCHo4+WdaboVXqUU=
X-Received: by 2002:a2e:87d0:: with SMTP id v16mr3893897ljj.24.1560822992659;
 Mon, 17 Jun 2019 18:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190613150641.4304-1-naresh.kamboju@linaro.org> <01B902DE-6191-4FF2-A51B-F7E1AA87E87C@gmail.com>
In-Reply-To: <01B902DE-6191-4FF2-A51B-F7E1AA87E87C@gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Jun 2019 07:26:21 +0530
Message-ID: <CA+G9fYswbSvf_G3nEugMy6AEOU+97A1uo1SHq=FzX0TGQ22-Og@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: fix syntax error
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        karl.heubaum@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 at 01:09, Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jun 13, 2019, at 8:06 AM, Naresh Kamboju <naresh.kamboju@linaro.org>=
 wrote:
> >
> > This patch fixes this build error,
> > kvm-unit-tests/lib/x86/processor.h:497:45: error: expected =E2=80=98)=
=E2=80=99 before =E2=80=98;=E2=80=99 token
> >  return !!((cpuid(0x80000001).d & (1 << 20));
> >           ~                                 ^
> >
>
> Fixes: ddbb68a60534b ("kvm-unit-test: x86: Add a wrapper to check if the =
CPU supports NX bit in MSR_EFER")
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Cc: Karl Heubaum <karl.heubaum@oracle.com>
>
>
> > Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > ---
> > lib/x86/processor.h | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> > index 0a65808..823d65d 100644
> > --- a/lib/x86/processor.h
> > +++ b/lib/x86/processor.h
> > @@ -494,7 +494,7 @@ static inline int has_spec_ctrl(void)
> >
> > static inline int cpu_has_efer_nx(void)
> > {
> > -     return !!((cpuid(0x80000001).d & (1 << 20));
> > +     return !!((cpuid(0x80000001).d & (1 << 20)));
>
> Just because I also encountered this issue: why would you add another
> bracket instead of removing one?

I see two !! and thought that we might need ((
Sorry if that does not make sense.

- Naresh


>
>
