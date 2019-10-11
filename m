Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E76D47BA
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 20:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfJKShF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 14:37:05 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:42022 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbfJKShF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 14:37:05 -0400
Received: by mail-vs1-f66.google.com with SMTP id m22so6848652vsl.9
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 11:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hruPFiPIqZIfkLpkpwC7Sn8T/A7yCrSFAT1BiIsdmq8=;
        b=XNaeDMYj6TU9vkyKs/xRffX3LclPgUG0qZwIfQgeHeyhOJDcliYOiTAEB0C4mzKEgU
         UaZtGsdKbS2I08EZ2wGlXXummdcYmGPYn0ncLeYsqJ228NKa+LAX/h/Zkm3pDw8okBK9
         aNe+e+TINSrebaM11QZacFuV74h7DHQ4f2am1XUz8pAZUNxMZ04DboROebElS0LcFnYx
         Xoeay/cSPhovk+SwsOCmF58wCMrBduG/Y5PJQCJccT9sT1/EjGhyC9YBLp3c4Irte4q3
         pmNSvlTXDUNoI3i9TuNfxtKBO6+YGEtKeODQLGsdNmyqcGVryGcjOun0cDZZAqnHZ64W
         1RMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hruPFiPIqZIfkLpkpwC7Sn8T/A7yCrSFAT1BiIsdmq8=;
        b=fSe3HWJ2E8HzWhHYqsu/zr2zGsw3ut+NoRfAwcwGYLxnCLSOa716WNqf1orFQ/2GhI
         Ytb+fJ/zae1JMUnjrdIneCbP145Fjr8nUXejQIxgHeh0Gi2zKmcIYMg0ZtQab/AjQWMc
         Gx4bCcqTFJt+8WDgx9IAz11yYCnpHTTgSFQHWUdjUz/Jg8455JpFt1CoEYZV+J/HTH2O
         /6uqa7eOlXTGsdal92ncPIjbzn+rNNCNwIx7IfewirrgMFddstH4YfT4SRIDAeHC3Ara
         I9cO9jGOX2BoUQcmBeKP+BH0STQjSZTIhtrHn1VK1WsNmnLzj33VtKzRQ+LK0GzqORtW
         IvoA==
X-Gm-Message-State: APjAAAU9MUy9Pv6+eUixBku0CTSa/3O591JW4TYqH6ioB7yegLwGFaRx
        JOBwICpEMG2Jzhp2f47lunAgFo/KiaFN2Wjo3pU9
X-Google-Smtp-Source: APXvYqyeC8ulpdw6bfEjsNiQeEM5XCl8Amzq4iP/BSv9RbfwL2VlNLU2mtOKP8/VFqZ4Ruk96+Hla1pXUHOVD5mPQUs=
X-Received: by 2002:a67:fb44:: with SMTP id e4mr9664311vsr.112.1570819022256;
 Fri, 11 Oct 2019 11:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
 <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com> <30edb4bd-535d-d29c-3f4e-592adfa41163@redhat.com>
 <7f7fa66f-9e6c-2e48-03b2-64ebca36df99@redhat.com>
In-Reply-To: <7f7fa66f-9e6c-2e48-03b2-64ebca36df99@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Fri, 11 Oct 2019 11:36:50 -0700
Message-ID: <CAGG=3QUdVBg5JArMaBcRbBLrHqLLCpAcrtvgT4q1h0V7SHbbEQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Thomas Huth <thuth@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?THVrw6HFoSBEb2t0b3I=?= <ldoktor@redhat.com>,
        David Gibson <dgibson@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I apologize for the breakage. I'm not sure how this escaped me. Here's
a proposed fix. Thoughts?

commit 5fa1940140fd75a97f3ac5ae2e4de9e1bef645d0
Author: Bill Wendling <morbo@google.com>
Date:   Fri Oct 11 11:26:03 2019 -0700

    Use a status enum for reporting pass/fail

    Some values passed into "report" as "pass/fail" are larger than the
    size of the parameter. Use instead a status enum so that the size of th=
e
    argument no longer matters.

diff --git a/lib/libcflat.h b/lib/libcflat.h
index b6635d9..8f80a1c 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -95,13 +95,22 @@ extern int vsnprintf(char *buf, int size, const
char *fmt, va_list va)
 extern int vprintf(const char *fmt, va_list va)
  __attribute__((format(printf, 1, 0)));

+enum status { PASSED, FAILED };
+
+#define STATUS(x) ((x) !=3D 0 ? PASSED : FAILED)
+
+#define report(msg_fmt, status, ...) \
+ report_status(msg_fmt, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
+#define report_xfail(msg_fmt, xfail, status, ...) \
+ report_xfail_status(msg_fmt, xfail, STATUS(status) __VA_OPT__(,) __VA_ARG=
S__)
+
 void report_prefix_pushf(const char *prefix_fmt, ...)
  __attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
-extern void report(const char *msg_fmt, unsigned pass, ...)
+extern void report_status(const char *msg_fmt, unsigned pass, ...)
  __attribute__((format(printf, 1, 3)));
-extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, .=
..)
+extern void report_xfail_status(const char *msg_fmt, bool xfail, enum
status status, ...)
  __attribute__((format(printf, 1, 4)));
 extern void report_abort(const char *msg_fmt, ...)
  __attribute__((format(printf, 1, 2)))
diff --git a/lib/report.c b/lib/report.c
index 2a5f549..4ba2ac0 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -80,12 +80,12 @@ void report_prefix_pop(void)
  spin_unlock(&lock);
 }

-static void va_report(const char *msg_fmt,
- bool pass, bool xfail, bool skip, va_list va)
+static void va_report(const char *msg_fmt, enum status status, bool xfail,
+               bool skip, va_list va)
 {
  const char *prefix =3D skip ? "SKIP"
-   : xfail ? (pass ? "XPASS" : "XFAIL")
-   : (pass ? "PASS"  : "FAIL");
+   : xfail ? (status =3D=3D PASSED ? "XPASS" : "XFAIL")
+   : (status =3D=3D PASSED ? "PASS"  : "FAIL");

  spin_lock(&lock);

@@ -96,27 +96,27 @@ static void va_report(const char *msg_fmt,
  puts("\n");
  if (skip)
  skipped++;
- else if (xfail && !pass)
+ else if (xfail && status =3D=3D FAILED)
  xfailures++;
- else if (xfail || !pass)
+ else if (xfail || status =3D=3D FAILED)
  failures++;

  spin_unlock(&lock);
 }

-void report(const char *msg_fmt, unsigned pass, ...)
+void report_status(const char *msg_fmt, enum status status, ...)
 {
  va_list va;
- va_start(va, pass);
- va_report(msg_fmt, pass, false, false, va);
+ va_start(va, status);
+ va_report(msg_fmt, status, false, false, va);
  va_end(va);
 }

-void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
+void report_xfail_status(const char *msg_fmt, bool xfail, enum status
status, ...)
 {
  va_list va;
- va_start(va, pass);
- va_report(msg_fmt, pass, xfail, false, va);
+ va_start(va, status);
+ va_report(msg_fmt, status, xfail, false, va);
  va_end(va);
 }




On Fri, Oct 11, 2019 at 9:36 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 11/10/2019 18.24, Thomas Huth wrote:
> > On 11/10/2019 16.19, David Hildenbrand wrote:
> >> On 10.09.19 01:11, Bill Wendling wrote:
> >>> Clang warns that passing an object that undergoes default argument
> >>> promotion to "va_start" is undefined behavior:
> >>>
> >>> lib/report.c:106:15: error: passing an object that undergoes default
> >>> argument promotion to 'va_start' has undefined behavior
> >>> [-Werror,-Wvarargs]
> >>>          va_start(va, pass);
> >>>
> >>> Using an "unsigned" type removes the need for argument promotion.
> >>>
> >>> Signed-off-by: Bill Wendling <morbo@google.com>
> >>> ---
> >>>   lib/libcflat.h | 4 ++--
> >>>   lib/report.c   | 6 +++---
> >>>   2 files changed, 5 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/lib/libcflat.h b/lib/libcflat.h
> >>> index b94d0ac..b6635d9 100644
> >>> --- a/lib/libcflat.h
> >>> +++ b/lib/libcflat.h
> >>> @@ -99,9 +99,9 @@ void report_prefix_pushf(const char *prefix_fmt, ..=
.)
> >>>    __attribute__((format(printf, 1, 2)));
> >>>   extern void report_prefix_push(const char *prefix);
> >>>   extern void report_prefix_pop(void);
> >>> -extern void report(const char *msg_fmt, bool pass, ...)
> >>> +extern void report(const char *msg_fmt, unsigned pass, ...)
> >>>    __attribute__((format(printf, 1, 3)));
> >>> -extern void report_xfail(const char *msg_fmt, bool xfail, bool pass,=
 ...)
> >>> +extern void report_xfail(const char *msg_fmt, bool xfail, unsigned p=
ass, ...)
> >>>    __attribute__((format(printf, 1, 4)));
> >>>   extern void report_abort(const char *msg_fmt, ...)
> >>>    __attribute__((format(printf, 1, 2)))
> >>> diff --git a/lib/report.c b/lib/report.c
> >>> index ca9b4fd..7d259f6 100644
> >>> --- a/lib/report.c
> >>> +++ b/lib/report.c
> >>> @@ -81,7 +81,7 @@ void report_prefix_pop(void)
> >>>   }
> >>>
> >>>   static void va_report(const char *msg_fmt,
> >>> - bool pass, bool xfail, bool skip, va_list va)
> >>> + unsigned pass, bool xfail, bool skip, va_list va)
> >>>   {
> >>>    const char *prefix =3D skip ? "SKIP"
> >>>      : xfail ? (pass ? "XPASS" : "XFAIL")
> >>> @@ -104,7 +104,7 @@ static void va_report(const char *msg_fmt,
> >>>    spin_unlock(&lock);
> >>>   }
> >>>
> >>> -void report(const char *msg_fmt, bool pass, ...)
> >>> +void report(const char *msg_fmt, unsigned pass, ...)
> >>>   {
> >>>    va_list va;
> >>>    va_start(va, pass);
> >>> @@ -112,7 +112,7 @@ void report(const char *msg_fmt, bool pass, ...)
> >>>    va_end(va);
> >>>   }
> >>>
> >>> -void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> >>> +void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ..=
.)
> >>>   {
> >>>    va_list va;
> >>>    va_start(va, pass);
> >>>
> >>
> >> This patch breaks the selftest on s390x:
> >>
> >> t460s: ~/git/kvm-unit-tests (kein Branch, Rebase von Branch master im =
Gange) $ ./run_tests.sh
> >> FAIL selftest-setup (14 tests, 2 unexpected failures)
> >>
> >> t460s: ~/git/kvm-unit-tests (kein Branch, Rebase von Branch master im =
Gange) $ cat logs/selftest-setup.log
> >> timeout -k 1s --foreground 90s /usr/bin/qemu-system-s390x -nodefaults =
-nographic -machine s390-ccw-virtio,accel=3Dtcg -chardev stdio,id=3Dcon0 -d=
evice sclpconsole,chardev=3Dcon0 -kernel s390x/selftest.elf -smp 1 -append =
test 123 # -initrd /tmp/tmp.JwIjS9RWlv
> >> PASS: selftest: true
> >> PASS: selftest: argc =3D=3D 3
> >> PASS: selftest: argv[0] =3D=3D PROGNAME
> >> PASS: selftest: argv[1] =3D=3D test
> >> PASS: selftest: argv[2] =3D=3D 123
> >> PASS: selftest: 3.0/2.0 =3D=3D 1.5
> >> PASS: selftest: Program interrupt: expected(1) =3D=3D received(1)
> >> PASS: selftest: Program interrupt: expected(5) =3D=3D received(5)
> >> FAIL: selftest: malloc: got vaddr
> >> PASS: selftest: malloc: access works
> >> FAIL: selftest: malloc: got 2nd vaddr
> >> PASS: selftest: malloc: access works
> >> PASS: selftest: malloc: addresses differ
> >> PASS: selftest: Program interrupt: expected(5) =3D=3D received(5)
> >> SUMMARY: 14 tests, 2 unexpected failures
> >>
> >> EXIT: STATUS=3D3
> >>
> >>
> >>
> >> A fix for the test would look like this:
> >>
> >> diff --git a/s390x/selftest.c b/s390x/selftest.c
> >> index f4acdc4..dc1c476 100644
> >> --- a/s390x/selftest.c
> >> +++ b/s390x/selftest.c
> >> @@ -49,9 +49,10 @@ static void test_malloc(void)
> >>         *tmp2 =3D 123456789;
> >>         mb();
> >>
> >> -       report("malloc: got vaddr", (uintptr_t)tmp & 0xf00000000000000=
0ul);
> >> +       report("malloc: got vaddr", !!((uintptr_t)tmp & 0xf00000000000=
0000ul));
> >>         report("malloc: access works", *tmp =3D=3D 123456789);
> >> -       report("malloc: got 2nd vaddr", (uintptr_t)tmp2 & 0xf000000000=
000000ul);
> >> +       report("malloc: got 2nd vaddr",
> >> +              !!((uintptr_t)tmp2 & 0xf000000000000000ul));
> >>         report("malloc: access works", (*tmp2 =3D=3D 123456789));
> >>         report("malloc: addresses differ", tmp !=3D tmp2);
> >>
> >>
> >> But I am not sure if that is the right fix.
> >>
> >> (why don't we run sanity tests to detect that, this tests works
> >> just fine with s390x TCG)
> >
> > This patch also broke the test_64bit() function in powerpc/emulator.c:
> >
> >  https://gitlab.com/huth/kvm-unit-tests/-/jobs/318694752
>
> ... and I think it even broke the intel_iommu test:
>
>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/318694755
>  https://travis-ci.com/huth/kvm-unit-tests/jobs/244827719#L1087
>
> ... why did nobody notice at least that one?
>
> (I strongly like to recommend to run either Travis or gitlab-ci on
> changes in the common lib/ directory first, to see whether it breaks
> anything for the other architectures)
>
>  Thomas
