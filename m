Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2EFD5D33
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbfJNIOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 04:14:49 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:40517 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbfJNIOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 04:14:49 -0400
Received: by mail-vk1-f196.google.com with SMTP id d126so3347856vkf.7
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 01:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g8EVJz/I4DKJzBYbFuPEfYrvSDfQuFuU+oBfazSP8gs=;
        b=h1JZhLCR+NUBW8xfqbTKiJ6aRMXX/n1ho8fP3rAgMJpdUOj8mVLsnvG47svMFQplj/
         0VxeT5fs82EzbUJCcQpdp1teMxUWHmRjpv70g50ve9K0gODSMwhybLrtDDzcuZvBlt98
         UJKmIxpwOwvHAxLQGPUxmswF9oIOutKBxpWfJ+DAbm8CFwOAqXuMOgZsTqfk+VoNcao/
         FtlYGnSTSlr1FCt9cak47ecCpK7PsQSqDhqiGrE9FaIzjp8mDEp5TzNB9A8rfYpoP0dc
         BRR5HsJQA4CQ1do8vztQY6ZYsM/DBQl212KFK9/YnOeZtdpLzBFxq+KnGlK5obDqb66t
         P+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g8EVJz/I4DKJzBYbFuPEfYrvSDfQuFuU+oBfazSP8gs=;
        b=kAKZzoytCm0I2m9F0Cpb8+WBKrWmiqdsNkbfqp231VxSw/5HHbl2/KHoT7GRXEpYfq
         3kSCGet7qBXoykv+vnm7qCSOta6j3Es5Rfu8FCjuPhT51Cyg9av57PZE0QG19at0QvDR
         f0xJlEBRw4GKlLx96k65k5x5eQKvl36DYE/2UqrVTmpyTkHCQXdRaOVTuvXXdFraXJmG
         YtLTfhy9rB59v+Ru5n92MCGNKP8X3u7/4F24n5sEu0FCslTij0G1tciSRWkehJDZvx1D
         nK9VmEpJPbY30vT61bCrx7Rbt29NbAPjXfHUb1JTNzirt4cTjKK4EktfB6b+DvwKJMLS
         SaqQ==
X-Gm-Message-State: APjAAAXbWZa89j5gNtzjymWLbrfxOK8yJneA9kqyNhU5qYNhYyFZqmab
        aqh5yHk74z6X6BZ2qTsO4GBjc7jnb494THeeSLDy
X-Google-Smtp-Source: APXvYqy6BDBIE4tawIeK1cABO6++1SqJq+RbrQeOc2XDmMy4hgx2dAkSDdTFiqHZBABMWt45udDVpyF/ZkPd70PLOGA=
X-Received: by 2002:ac5:cb62:: with SMTP id l2mr15398973vkn.32.1571040887315;
 Mon, 14 Oct 2019 01:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
 <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com> <30edb4bd-535d-d29c-3f4e-592adfa41163@redhat.com>
 <7f7fa66f-9e6c-2e48-03b2-64ebca36df99@redhat.com> <CAGG=3QUdVBg5JArMaBcRbBLrHqLLCpAcrtvgT4q1h0V7SHbbEQ@mail.gmail.com>
 <df9c5f5d-c9ec-1a7b-1fec-67d1e7a5bbad@redhat.com>
In-Reply-To: <df9c5f5d-c9ec-1a7b-1fec-67d1e7a5bbad@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 14 Oct 2019 01:14:36 -0700
Message-ID: <CAGG=3QUurbcE-gESo8D3bj-tcdWwsc=umG3QTtZrTcVZp6PpWw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?THVrw6HFoSBEb2t0b3I=?= <ldoktor@redhat.com>,
        David Gibson <dgibson@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 12:57 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 11/10/2019 20.36, Bill Wendling wrote:
> > I apologize for the breakage. I'm not sure how this escaped me. Here's
> > a proposed fix. Thoughts?
> >
> > commit 5fa1940140fd75a97f3ac5ae2e4de9e1bef645d0
> > Author: Bill Wendling <morbo@google.com>
> > Date:   Fri Oct 11 11:26:03 2019 -0700
> >
> >     Use a status enum for reporting pass/fail
> >
> >     Some values passed into "report" as "pass/fail" are larger than the
> >     size of the parameter. Use instead a status enum so that the size of the
> >     argument no longer matters.
> >
> > diff --git a/lib/libcflat.h b/lib/libcflat.h
> > index b6635d9..8f80a1c 100644
> > --- a/lib/libcflat.h
> > +++ b/lib/libcflat.h
> > @@ -95,13 +95,22 @@ extern int vsnprintf(char *buf, int size, const
> > char *fmt, va_list va)
> >  extern int vprintf(const char *fmt, va_list va)
> >   __attribute__((format(printf, 1, 0)));
> >
> > +enum status { PASSED, FAILED };
> > +
> > +#define STATUS(x) ((x) != 0 ? PASSED : FAILED)
> > +
> > +#define report(msg_fmt, status, ...) \
> > + report_status(msg_fmt, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
> > +#define report_xfail(msg_fmt, xfail, status, ...) \
> > + report_xfail_status(msg_fmt, xfail, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
> > +
> >  void report_prefix_pushf(const char *prefix_fmt, ...)
> >   __attribute__((format(printf, 1, 2)));
> >  extern void report_prefix_push(const char *prefix);
> >  extern void report_prefix_pop(void);
> > -extern void report(const char *msg_fmt, unsigned pass, ...)
> > +extern void report_status(const char *msg_fmt, unsigned pass, ...)
> >   __attribute__((format(printf, 1, 3)));
> > -extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
> > +extern void report_xfail_status(const char *msg_fmt, bool xfail, enum
> > status status, ...)
> >   __attribute__((format(printf, 1, 4)));
> >  extern void report_abort(const char *msg_fmt, ...)
> >   __attribute__((format(printf, 1, 2)))
> > diff --git a/lib/report.c b/lib/report.c
> > index 2a5f549..4ba2ac0 100644
> > --- a/lib/report.c
> > +++ b/lib/report.c
> > @@ -80,12 +80,12 @@ void report_prefix_pop(void)
> >   spin_unlock(&lock);
> >  }
> >
> > -static void va_report(const char *msg_fmt,
> > - bool pass, bool xfail, bool skip, va_list va)
> > +static void va_report(const char *msg_fmt, enum status status, bool xfail,
> > +               bool skip, va_list va)
> >  {
> >   const char *prefix = skip ? "SKIP"
> > -   : xfail ? (pass ? "XPASS" : "XFAIL")
> > -   : (pass ? "PASS"  : "FAIL");
> > +   : xfail ? (status == PASSED ? "XPASS" : "XFAIL")
> > +   : (status == PASSED ? "PASS"  : "FAIL");
> >
> >   spin_lock(&lock);
> >
> > @@ -96,27 +96,27 @@ static void va_report(const char *msg_fmt,
> >   puts("\n");
> >   if (skip)
> >   skipped++;
> > - else if (xfail && !pass)
> > + else if (xfail && status == FAILED)
> >   xfailures++;
> > - else if (xfail || !pass)
> > + else if (xfail || status == FAILED)
> >   failures++;
> >
> >   spin_unlock(&lock);
> >  }
> >
> > -void report(const char *msg_fmt, unsigned pass, ...)
> > +void report_status(const char *msg_fmt, enum status status, ...)
> >  {
> >   va_list va;
> > - va_start(va, pass);
> > - va_report(msg_fmt, pass, false, false, va);
> > + va_start(va, status);
> > + va_report(msg_fmt, status, false, false, va);
> >   va_end(va);
> >  }
> >
> > -void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
> > +void report_xfail_status(const char *msg_fmt, bool xfail, enum status
> > status, ...)
> >  {
> >   va_list va;
> > - va_start(va, pass);
> > - va_report(msg_fmt, pass, xfail, false, va);
> > + va_start(va, status);
> > + va_report(msg_fmt, status, xfail, false, va);
> >   va_end(va);
> >  }
>
> That's certainly a solution... but I wonder whether it might be easier
> to simply fix the failing tests instead, to make sure that they do not
> pass a value > sizeof(int) to report() and report_xfail_status() ?
>
It may be easier, but it won't stop future changes from encountering
the same issue.

> Another idea would be to swap the parameters of report() and
> report_xfail_status() :
>
It's a bit non-standard, but I don't have much of a preference. It
would take changing tons of places in the code base though.

> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index b94d0ac..d6d1323 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -99,10 +99,10 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>                                         __attribute__((format(printf, 1,
> 2)));
>  extern void report_prefix_push(const char *prefix);
>  extern void report_prefix_pop(void);
> -extern void report(const char *msg_fmt, bool pass, ...)
> -                                       __attribute__((format(printf, 1,
> 3)));
> -extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> -                                       __attribute__((format(printf, 1,
> 4)));
> +extern void report(bool pass, const char *msg_fmt, ...)
> +                                       __attribute__((format(printf, 2,
> 3)));
> +extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> +                                       __attribute__((format(printf, 3,
> 4)));
>  extern void report_abort(const char *msg_fmt, ...)
>                                         __attribute__((format(printf, 1,
> 2)))
>                                         __attribute__((noreturn));
> diff --git a/lib/report.c b/lib/report.c
> index ca9b4fd..2255dc3 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -104,18 +104,18 @@ static void va_report(const char *msg_fmt,
>         spin_unlock(&lock);
>  }
>
> -void report(const char *msg_fmt, bool pass, ...)
> +void report(bool pass, const char *msg_fmt, ...)
>  {
>         va_list va;
> -       va_start(va, pass);
> +       va_start(va, msg_fmt);
>         va_report(msg_fmt, pass, false, false, va);
>         va_end(va);
>  }
>
> -void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> +void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>  {
>         va_list va;
> -       va_start(va, pass);
> +       va_start(va, msg_fmt);
>         va_report(msg_fmt, pass, xfail, false, va);
>         va_end(va);
>  }
>
> ... then we can keep the "bool" - but we have to fix all calling sites, too.
>
> Paolo, any preferences?
>
>  Thomas
