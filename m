Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323E7173FCC
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 19:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgB1Skn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 13:40:43 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33579 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Skn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 13:40:43 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so2869465lfl.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 10:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dwCfMu2tAboFdJF+iC/vubdEwqsF4AxE1EDmWMDM8xE=;
        b=WUNxhtK5EGyBvp3mM6Kbwqqjy3a3I533pXyEf2CTzkdBQlNHJPz6I1g6B1WajOyMar
         /3lZ9+FsJaK9ZNH9LFhrE4myUeGPJKaGHE1yrZCDAWw73O8Vn9DxcOYYsAxwTN9Bdp8q
         KeNiZsb7E5uPyLkCiPp8oHxty/IffQArBdwwNlT0NNW0+mYeqKTLt1GxmyUj6GRm013Y
         00tfQqpIGwNM8CxydZ7ok4Qlvm//AFytnjyTUHL5XwvfpIDVHVdHSoXVb4tAGEzSIFsf
         Bs1XQqRO3apPpTsNLCJKVeX5RIex1SEvuARLRHDBWjFCr5VdMeSMMaYbnC9OYVcmywHk
         d3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dwCfMu2tAboFdJF+iC/vubdEwqsF4AxE1EDmWMDM8xE=;
        b=aYo/ld/sKwTwO45aoL828Oihsit2mZVKTNvX+VUHJMWgTiFxkkHGacm0J98++QblP8
         aBty9avTJjVp4+NkIu6oCJMAiGNfy8DEMidGa0doE/EX17vwHIFmif0TeWavCA/ngDD0
         056Zp57xGpE+0h1lFQT4AYIjH7So3vErcOA7DspTfEwv8CxvHS11mkUbJ8cKIoz8PkQp
         yLKo9Fj2rZY1/8pjP8YyiSW6Lmmm30vM06+M/3UCgQDu10j7HuovMG0p1+iY4YFkG7YO
         HQT+mYd/sVl/VmB2WwsnhPL9ekdoEGUM8bU0ZDOTC5Mk+xSm+69/mIy5ZS7EheMMgtPM
         Llcw==
X-Gm-Message-State: ANhLgQ3SnJno0Mg4Ugod/PE2E9DNoymUUefc6oxcUKL7MvmdCFnlAor4
        WO41wZSWoIqLfwVfgMdOU+0+qWpx5ipOxrIN/hPhX2tX
X-Google-Smtp-Source: ADFU+vus0xZZBaX7OacyLr0v5Qs+ul5zL2wgiSqYe3BxHUtXrXqFqKi01Z3IEGJVnpVym92gOb8rg9lytixT9cXTiX8=
X-Received: by 2002:ac2:48bc:: with SMTP id u28mr3447378lfg.209.1582915241610;
 Fri, 28 Feb 2020 10:40:41 -0800 (PST)
MIME-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-15-morbo@google.com> <643086be-7251-92cf-c9f5-5a467dd2827d@redhat.com>
 <CAOQ_QsjZKp3nou31jAxASojspTGbO50ZfMV_yy61rxmAwJYFsQ@mail.gmail.com> <4a9f4e8a-c2d7-3e1f-c5b6-b3bcfd43ca54@redhat.com>
In-Reply-To: <4a9f4e8a-c2d7-3e1f-c5b6-b3bcfd43ca54@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 28 Feb 2020 10:40:30 -0800
Message-ID: <CAOQ_QsjUxw7TQxN70AzfWP1Kt39UF6iSM=9vs3BCnA5djyYbVQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is gcc-specific
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <morbo@google.com>, kvm list <kvm@vger.kernel.org>,
        drjones@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 10:24 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/02/20 19:19, Oliver Upton wrote:
> > If we wanted to be absolutely certain that the extern labels used for
> > assertions about the guest RIP are correct, we may still want it.
> > Alternatively, I could rewrite the test such that the guest will
> > report the instruction boundary where it anticipates MTF whenever it
> > makes the vmcall to request the host turns on MTF.
>
> Right, but it's used only once, and as a function pointer at that, so
> there's only so much that the compiler can do to "optimize".  Let's
> think about how to fix it if it breaks.
>
> Paolo
>

Very true. Unchecked paranoia of the compiler isn't warranted here.

Thanks :)

--
Best,
Oliver
