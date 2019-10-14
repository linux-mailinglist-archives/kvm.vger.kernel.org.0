Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1292BD5EFE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 11:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfJNJdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 05:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730667AbfJNJdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 05:33:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC26310C092A;
        Mon, 14 Oct 2019 09:33:02 +0000 (UTC)
Received: from thuth.remote.csb (dhcp-200-228.str.redhat.com [10.33.200.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6F945DA8D;
        Mon, 14 Oct 2019 09:32:58 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Bill Wendling <morbo@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?THVrw6HFoSBEb2t0b3I=?= <ldoktor@redhat.com>,
        David Gibson <dgibson@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
 <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com>
 <30edb4bd-535d-d29c-3f4e-592adfa41163@redhat.com>
 <7f7fa66f-9e6c-2e48-03b2-64ebca36df99@redhat.com>
 <CAGG=3QUdVBg5JArMaBcRbBLrHqLLCpAcrtvgT4q1h0V7SHbbEQ@mail.gmail.com>
 <df9c5f5d-c9ec-1a7b-1fec-67d1e7a5bbad@redhat.com>
 <CAGG=3QUurbcE-gESo8D3bj-tcdWwsc=umG3QTtZrTcVZp6PpWw@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <b35a5604-b54a-d95d-ed09-ecf89d43d282@redhat.com>
Date:   Mon, 14 Oct 2019 11:32:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAGG=3QUurbcE-gESo8D3bj-tcdWwsc=umG3QTtZrTcVZp6PpWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 14 Oct 2019 09:33:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2019 10.14, Bill Wendling wrote:
> On Mon, Oct 14, 2019 at 12:57 AM Thomas Huth <thuth@redhat.com> wrote:
>>
>> On 11/10/2019 20.36, Bill Wendling wrote:
>>> I apologize for the breakage. I'm not sure how this escaped me. Here's
>>> a proposed fix. Thoughts?
>>>
>>> commit 5fa1940140fd75a97f3ac5ae2e4de9e1bef645d0
>>> Author: Bill Wendling <morbo@google.com>
>>> Date:   Fri Oct 11 11:26:03 2019 -0700
>>>
>>>     Use a status enum for reporting pass/fail
>>>
>>>     Some values passed into "report" as "pass/fail" are larger than the
>>>     size of the parameter. Use instead a status enum so that the size of the
>>>     argument no longer matters.
>>>
>>> diff --git a/lib/libcflat.h b/lib/libcflat.h
>>> index b6635d9..8f80a1c 100644
>>> --- a/lib/libcflat.h
>>> +++ b/lib/libcflat.h
>>> @@ -95,13 +95,22 @@ extern int vsnprintf(char *buf, int size, const
>>> char *fmt, va_list va)
>>>  extern int vprintf(const char *fmt, va_list va)
>>>   __attribute__((format(printf, 1, 0)));
>>>
>>> +enum status { PASSED, FAILED };
>>> +
>>> +#define STATUS(x) ((x) != 0 ? PASSED : FAILED)
>>> +
>>> +#define report(msg_fmt, status, ...) \
>>> + report_status(msg_fmt, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
>>> +#define report_xfail(msg_fmt, xfail, status, ...) \
>>> + report_xfail_status(msg_fmt, xfail, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
>>> +
>>>  void report_prefix_pushf(const char *prefix_fmt, ...)
>>>   __attribute__((format(printf, 1, 2)));
>>>  extern void report_prefix_push(const char *prefix);
>>>  extern void report_prefix_pop(void);
>>> -extern void report(const char *msg_fmt, unsigned pass, ...)
>>> +extern void report_status(const char *msg_fmt, unsigned pass, ...)
>>>   __attribute__((format(printf, 1, 3)));
>>> -extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
>>> +extern void report_xfail_status(const char *msg_fmt, bool xfail, enum
>>> status status, ...)
>>>   __attribute__((format(printf, 1, 4)));
>>>  extern void report_abort(const char *msg_fmt, ...)
>>>   __attribute__((format(printf, 1, 2)))
>>> diff --git a/lib/report.c b/lib/report.c
>>> index 2a5f549..4ba2ac0 100644
>>> --- a/lib/report.c
>>> +++ b/lib/report.c
>>> @@ -80,12 +80,12 @@ void report_prefix_pop(void)
>>>   spin_unlock(&lock);
>>>  }
>>>
>>> -static void va_report(const char *msg_fmt,
>>> - bool pass, bool xfail, bool skip, va_list va)
>>> +static void va_report(const char *msg_fmt, enum status status, bool xfail,
>>> +               bool skip, va_list va)
>>>  {
>>>   const char *prefix = skip ? "SKIP"
>>> -   : xfail ? (pass ? "XPASS" : "XFAIL")
>>> -   : (pass ? "PASS"  : "FAIL");
>>> +   : xfail ? (status == PASSED ? "XPASS" : "XFAIL")
>>> +   : (status == PASSED ? "PASS"  : "FAIL");
>>>
>>>   spin_lock(&lock);
>>>
>>> @@ -96,27 +96,27 @@ static void va_report(const char *msg_fmt,
>>>   puts("\n");
>>>   if (skip)
>>>   skipped++;
>>> - else if (xfail && !pass)
>>> + else if (xfail && status == FAILED)
>>>   xfailures++;
>>> - else if (xfail || !pass)
>>> + else if (xfail || status == FAILED)
>>>   failures++;
>>>
>>>   spin_unlock(&lock);
>>>  }
>>>
>>> -void report(const char *msg_fmt, unsigned pass, ...)
>>> +void report_status(const char *msg_fmt, enum status status, ...)
>>>  {
>>>   va_list va;
>>> - va_start(va, pass);
>>> - va_report(msg_fmt, pass, false, false, va);
>>> + va_start(va, status);
>>> + va_report(msg_fmt, status, false, false, va);
>>>   va_end(va);
>>>  }
>>>
>>> -void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
>>> +void report_xfail_status(const char *msg_fmt, bool xfail, enum status
>>> status, ...)
>>>  {
>>>   va_list va;
>>> - va_start(va, pass);
>>> - va_report(msg_fmt, pass, xfail, false, va);
>>> + va_start(va, status);
>>> + va_report(msg_fmt, status, xfail, false, va);
>>>   va_end(va);
>>>  }
>>
>> That's certainly a solution... but I wonder whether it might be easier
>> to simply fix the failing tests instead, to make sure that they do not
>> pass a value > sizeof(int) to report() and report_xfail_status() ?
>>
> It may be easier, but it won't stop future changes from encountering
> the same issue.

True.

>> Another idea would be to swap the parameters of report() and
>> report_xfail_status() :
>>
> It's a bit non-standard, but I don't have much of a preference. It
> would take changing tons of places in the code base though.

Yes, it's a bigger change now ... but with your approach, I'm a little
bit afraid that we'll forget the reason over the years, so one day in
the future somebody might wonder what's this "enum status" magic all
about and more or less revert your patch again... so if we take your
patch, I think there should either be some comments in the code as
explanation, or we might want to add builds with clang to the
.travis.yml and gitlab-ci.yml files to make sure that we keep building
the kvm-unit-tests with clang, too.

 Thomas
