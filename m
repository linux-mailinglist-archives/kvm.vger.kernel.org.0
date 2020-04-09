Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8FF1A2FB7
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 09:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgDIHDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 03:03:24 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:44371 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgDIHDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 03:03:24 -0400
Received: by mail-ot1-f41.google.com with SMTP id a49so9434203otc.11
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 00:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WIKZ7+NEMSpKVc+/W0G6Y6asO6ZNbKBeIWnReIGgHns=;
        b=smHx7nstCIlDo0/kI6THSyTGBYXCw5nQ9nw8iZ5I5vF5LZI6Ah1Fw7Cq3i6tm++Aye
         oacq0NxG/cewUjLWk07FpVomnXbQMLsVnuJSJng6C4PzpagffWaEM0japKJMb6gmkR4h
         uSZfv6Ti8H2HJMERdUf6706FwY+Gb9Axx+WcDvwOTcskWPt4IVDnai9HgnTX0V32MgBs
         +ImG6LRbdYn98+T8gjKspUycL6Cyz3MxlVMIP5JUaocjEBBMTZCMUqP97s7k+nuKSqkc
         TK9cR3nJ+NEzu6oGGI3GsUnC9LtMNPGnukedKkKQ26XGR80OLCvVos1M5cImSPuUyuH6
         H17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WIKZ7+NEMSpKVc+/W0G6Y6asO6ZNbKBeIWnReIGgHns=;
        b=twQzwmAclcKkoqBJh7ucyapg2Cb0Z9jWlLvVC58q6rTOsBwlcIL1ZvOz7GPfXosm0g
         7lc/+r/c8GLDxnYP2rhF5Vi9kah+wQSzFTa1kiuo55pJ51UEb+B8AmRIS70nzESSKkZJ
         dtho6qbrViUv1owVBMjnd7Tos7JMLxTEkmYhXwunbvp44kZ5B+3ih3kQFKkoxEHdYQr6
         OdWogM4zD9UCAfPnfiK88vzvPoVbmc1h3gsXIKQZlto03NvVmnkFqX3U2B5zUBrzwlsw
         b1avJD/Am45KsXdMI8pAh6j1qVazxQOmQIWl6jBpy/SEMlIIpWYvoCepecsDXjgslJvx
         B+ng==
X-Gm-Message-State: AGi0PuYftkN82n5rbZ6wH6eGkDVKepiZxe/Nb68SZjq406/64oHwbXAP
        FGLQTY8yhRZVBJtOF0YPe2rrur0QizlkcYadXcS7SA==
X-Google-Smtp-Source: APiQypIj1Jhs+UwVg9KeZMVx7Ln01m8mfYc8tOqfYfUZhzpFOk7E64ZtK6paBQUJVoNUI55W2sMrLCd48G56F7Sq3mA=
X-Received: by 2002:a05:6830:3150:: with SMTP id c16mr8155028ots.251.1586415804017;
 Thu, 09 Apr 2020 00:03:24 -0700 (PDT)
MIME-Version: 1.0
References: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw> <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
 <017E692B-4791-46AD-B9ED-25B887ECB56B@lca.pw>
In-Reply-To: <017E692B-4791-46AD-B9ED-25B887ECB56B@lca.pw>
From:   Marco Elver <elver@google.com>
Date:   Thu, 9 Apr 2020 09:03:12 +0200
Message-ID: <CANpmjNMiHNVh3BVxZUqNo4jW3DPjoQPrn-KEmAJRtSYORuryEA@mail.gmail.com>
Subject: Re: KCSAN + KVM = host reset
To:     Qian Cai <cai@lca.pw>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Apr 2020 at 23:29, Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On Apr 8, 2020, at 5:25 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 08/04/20 22:59, Qian Cai wrote:
> >> Running a simple thing on this AMD host would trigger a reset right aw=
ay.
> >> Unselect KCSAN kconfig makes everything work fine (the host would also
> >> reset If only "echo off > /sys/kernel/debug/kcsan=E2=80=9D before runn=
ing qemu-kvm).
> >
> > Is this a regression or something you've just started to play with?  (I=
f
> > anything, the assembly language conversion of the AMD world switch that
> > is in linux-next could have reduced the likelihood of such a failure,
> > not increased it).
>
> I don=E2=80=99t remember I had tried this combination before, so don=E2=
=80=99t know if it is a
> regression or not.

What happens with KASAN? My guess is that, since it also happens with
"off", something that should not be instrumented is being
instrumented.

What happens if you put a 'KCSAN_SANITIZE :=3D n' into
arch/x86/kvm/Makefile? Since it's hard for me to reproduce on this
exact system, I'd ask you to narrow it down by placing 'KCSAN_SANITIZE
:=3D n' into suspect subsystems' Makefiles. Once you get it to work with
that, we can refine the solution.

Thanks,
-- Marco
