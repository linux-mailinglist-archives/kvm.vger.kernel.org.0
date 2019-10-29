Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBC6E8F8D
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 19:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfJ2SvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 14:51:14 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:42209 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbfJ2SvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 14:51:14 -0400
Received: by mail-vs1-f67.google.com with SMTP id a143so8633702vsd.9
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 11:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWnsJLFCxPwYumKsbC9ftqRp2xEMtGURfMWn0KKYS2I=;
        b=dkLKgMbSRoWWkgGg98VfMs1rX6wKMw4jF5373jrAZA54tMmyNz0Jlyf1Ak1smNfjMB
         WfZ0eKXmKfDRAsdvWPBbrTwLgj79Zpo7xCn3TrRQMaj+7hY7I5mlxixdY5LBl0xYjhjc
         wsWjntpMR8LM4+0cFPsY6CBPvD2k2Akpv+/A41JtSULBzbQK+kibYEIE4LsBbqwNLxem
         sH8z3eTSeJ2P0cZ3tJixJYGaxzC3aTte59NpRMlREM5tYg27pFOHKTZfzIFK/Q0rlK5d
         bDZmAQdfesg8H4qIZPY2amuJpxnMLoTjrD9kCTzBkXWMiiDQ0NJyuL4IDYPZ6f6DkFSy
         vaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWnsJLFCxPwYumKsbC9ftqRp2xEMtGURfMWn0KKYS2I=;
        b=ITaoJWWoP1rh8Uy1+It9QH21rDESUCkmTvNfv9zs6Fx+zsAq4FXF7r1wQVhH6HJgdx
         lumzr8OCj/9LDaNtIoZNkvBARUHmWwttSsaGRyX1HfkGwoJs81+CZjLVM7A9/PEqD8PE
         TK5ZymGUeLpnIifDgdZ2Hk8FdHMzlq5p3IFCGjq/KSVq0JMJEJZZUkGVS02CJuvkEBKu
         WaBQO/JsussAOgLtaceq++C/AiPhjJWUPtsuN9InCc3po6y73HZfqSWMgR139xI/vLDj
         5keWN3afPsKMNLehoLDSuUvYHv8w3reR2/GzLTS2lPvHF45wZml1BgRxMWGcosVMRCSg
         lZAw==
X-Gm-Message-State: APjAAAV7X+KVFeMgV84Ye+C5tPtBZHSFHUWwwgEp9SkUCnEiN78Nr2qH
        DG6MdeG20sglU57XPIqW+uYXalwxyW5l3SCxDD6C
X-Google-Smtp-Source: APXvYqzpbLqSpxu2W4kkgRd9Fa28E8GFXzjo9WwbkTxUvzvbTGO/JjtFG3PGWb2w9260VbzJxRArnYkbqlK0Vxk9mSQ=
X-Received: by 2002:a67:fb0f:: with SMTP id d15mr267615vsr.212.1572375072290;
 Tue, 29 Oct 2019 11:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191012074454.208377-1-morbo@google.com> <81877082-d6c9-9573-4b44-184695386f4f@redhat.com>
In-Reply-To: <81877082-d6c9-9573-4b44-184695386f4f@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 29 Oct 2019 11:51:01 -0700
Message-ID: <CAGG=3QVxXGuuhc4DphovQEECb2OkB8OwCmbhKi6jn5ERbCo8VA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] Use a status enum for reporting pass/fail
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 8:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/10/19 09:44, Bill Wendling wrote:
> > Some values passed into "report" as "pass/fail" are larger than the
> > size of the parameter. Instead use a status enum so that the size of the
> > argument no longer matters.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
>
> I'm going to apply Thomas's argument reversal patch.

Okay.

> Note that the
> commit message doesn't describe very well what is it that you're fixing
> (or rather, why it needs fixing).
>
My apologies for that. I'll keep that in mind for future patches.

> Paolo
>
> > ---
> >  lib/libcflat.h | 13 +++++++++++--
> >  lib/report.c   | 24 ++++++++++++------------
> >  2 files changed, 23 insertions(+), 14 deletions(-)
> >
> > diff --git a/lib/libcflat.h b/lib/libcflat.h
> > index b6635d9..8f80a1c 100644
> > --- a/lib/libcflat.h
> > +++ b/lib/libcflat.h
> > @@ -95,13 +95,22 @@ extern int vsnprintf(char *buf, int size, const char *fmt, va_list va)
> >  extern int vprintf(const char *fmt, va_list va)
> >                                       __attribute__((format(printf, 1, 0)));
> >
> > +enum status { PASSED, FAILED };
> > +
> > +#define STATUS(x) ((x) != 0 ? PASSED : FAILED)
> > +
> > +#define report(msg_fmt, status, ...) \
> > +     report_status(msg_fmt, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
> > +#define report_xfail(msg_fmt, xfail, status, ...) \
> > +     report_xfail_status(msg_fmt, xfail, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
> > +
> >  void report_prefix_pushf(const char *prefix_fmt, ...)
> >                                       __attribute__((format(printf, 1, 2)));
> >  extern void report_prefix_push(const char *prefix);
> >  extern void report_prefix_pop(void);
> > -extern void report(const char *msg_fmt, unsigned pass, ...)
> > +extern void report_status(const char *msg_fmt, unsigned pass, ...)
> >                                       __attribute__((format(printf, 1, 3)));
> > -extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
> > +extern void report_xfail_status(const char *msg_fmt, bool xfail, enum status status, ...)
> >                                       __attribute__((format(printf, 1, 4)));
> >  extern void report_abort(const char *msg_fmt, ...)
> >                                       __attribute__((format(printf, 1, 2)))
> > diff --git a/lib/report.c b/lib/report.c
> > index 2a5f549..4ba2ac0 100644
> > --- a/lib/report.c
> > +++ b/lib/report.c
> > @@ -80,12 +80,12 @@ void report_prefix_pop(void)
> >       spin_unlock(&lock);
> >  }
> >
> > -static void va_report(const char *msg_fmt,
> > -             bool pass, bool xfail, bool skip, va_list va)
> > +static void va_report(const char *msg_fmt, enum status status, bool xfail,
> > +               bool skip, va_list va)
> >  {
> >       const char *prefix = skip ? "SKIP"
> > -                               : xfail ? (pass ? "XPASS" : "XFAIL")
> > -                                       : (pass ? "PASS"  : "FAIL");
> > +                               : xfail ? (status == PASSED ? "XPASS" : "XFAIL")
> > +                                       : (status == PASSED ? "PASS"  : "FAIL");
> >
> >       spin_lock(&lock);
> >
> > @@ -96,27 +96,27 @@ static void va_report(const char *msg_fmt,
> >       puts("\n");
> >       if (skip)
> >               skipped++;
> > -     else if (xfail && !pass)
> > +     else if (xfail && status == FAILED)
> >               xfailures++;
> > -     else if (xfail || !pass)
> > +     else if (xfail || status == FAILED)
> >               failures++;
> >
> >       spin_unlock(&lock);
> >  }
> >
> > -void report(const char *msg_fmt, unsigned pass, ...)
> > +void report_status(const char *msg_fmt, enum status status, ...)
> >  {
> >       va_list va;
> > -     va_start(va, pass);
> > -     va_report(msg_fmt, pass, false, false, va);
> > +     va_start(va, status);
> > +     va_report(msg_fmt, status, false, false, va);
> >       va_end(va);
> >  }
> >
> > -void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
> > +void report_xfail_status(const char *msg_fmt, bool xfail, enum status status, ...)
> >  {
> >       va_list va;
> > -     va_start(va, pass);
> > -     va_report(msg_fmt, pass, xfail, false, va);
> > +     va_start(va, status);
> > +     va_report(msg_fmt, status, xfail, false, va);
> >       va_end(va);
> >  }
> >
> >
>
