Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08745D4554
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 18:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfJKQZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 12:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbfJKQZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 12:25:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4315CC01B808;
        Fri, 11 Oct 2019 16:25:04 +0000 (UTC)
Received: from thuth.remote.csb (dhcp-200-228.str.redhat.com [10.33.200.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9200560A9F;
        Fri, 11 Oct 2019 16:25:00 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     David Hildenbrand <david@redhat.com>,
        Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        =?UTF-8?B?THVrw6HFoSBEb2t0b3I=?= <ldoktor@redhat.com>
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
 <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com>
Cc:     David Gibson <dgibson@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <30edb4bd-535d-d29c-3f4e-592adfa41163@redhat.com>
Date:   Fri, 11 Oct 2019 18:24:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 11 Oct 2019 16:25:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/2019 16.19, David Hildenbrand wrote:
> On 10.09.19 01:11, Bill Wendling wrote:
>> Clang warns that passing an object that undergoes default argument
>> promotion to "va_start" is undefined behavior:
>>
>> lib/report.c:106:15: error: passing an object that undergoes default
>> argument promotion to 'va_start' has undefined behavior
>> [-Werror,-Wvarargs]
>>          va_start(va, pass);
>>
>> Using an "unsigned" type removes the need for argument promotion.
>>
>> Signed-off-by: Bill Wendling <morbo@google.com>
>> ---
>>   lib/libcflat.h | 4 ++--
>>   lib/report.c   | 6 +++---
>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/libcflat.h b/lib/libcflat.h
>> index b94d0ac..b6635d9 100644
>> --- a/lib/libcflat.h
>> +++ b/lib/libcflat.h
>> @@ -99,9 +99,9 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>>    __attribute__((format(printf, 1, 2)));
>>   extern void report_prefix_push(const char *prefix);
>>   extern void report_prefix_pop(void);
>> -extern void report(const char *msg_fmt, bool pass, ...)
>> +extern void report(const char *msg_fmt, unsigned pass, ...)
>>    __attribute__((format(printf, 1, 3)));
>> -extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
>> +extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
>>    __attribute__((format(printf, 1, 4)));
>>   extern void report_abort(const char *msg_fmt, ...)
>>    __attribute__((format(printf, 1, 2)))
>> diff --git a/lib/report.c b/lib/report.c
>> index ca9b4fd..7d259f6 100644
>> --- a/lib/report.c
>> +++ b/lib/report.c
>> @@ -81,7 +81,7 @@ void report_prefix_pop(void)
>>   }
>>
>>   static void va_report(const char *msg_fmt,
>> - bool pass, bool xfail, bool skip, va_list va)
>> + unsigned pass, bool xfail, bool skip, va_list va)
>>   {
>>    const char *prefix = skip ? "SKIP"
>>      : xfail ? (pass ? "XPASS" : "XFAIL")
>> @@ -104,7 +104,7 @@ static void va_report(const char *msg_fmt,
>>    spin_unlock(&lock);
>>   }
>>
>> -void report(const char *msg_fmt, bool pass, ...)
>> +void report(const char *msg_fmt, unsigned pass, ...)
>>   {
>>    va_list va;
>>    va_start(va, pass);
>> @@ -112,7 +112,7 @@ void report(const char *msg_fmt, bool pass, ...)
>>    va_end(va);
>>   }
>>
>> -void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
>> +void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
>>   {
>>    va_list va;
>>    va_start(va, pass);
>>
> 
> This patch breaks the selftest on s390x:
> 
> t460s: ~/git/kvm-unit-tests (kein Branch, Rebase von Branch master im Gange) $ ./run_tests.sh 
> FAIL selftest-setup (14 tests, 2 unexpected failures)
> 
> t460s: ~/git/kvm-unit-tests (kein Branch, Rebase von Branch master im Gange) $ cat logs/selftest-setup.log 
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-s390x -nodefaults -nographic -machine s390-ccw-virtio,accel=tcg -chardev stdio,id=con0 -device sclpconsole,chardev=con0 -kernel s390x/selftest.elf -smp 1 -append test 123 # -initrd /tmp/tmp.JwIjS9RWlv
> PASS: selftest: true
> PASS: selftest: argc == 3
> PASS: selftest: argv[0] == PROGNAME
> PASS: selftest: argv[1] == test
> PASS: selftest: argv[2] == 123
> PASS: selftest: 3.0/2.0 == 1.5
> PASS: selftest: Program interrupt: expected(1) == received(1)
> PASS: selftest: Program interrupt: expected(5) == received(5)
> FAIL: selftest: malloc: got vaddr
> PASS: selftest: malloc: access works
> FAIL: selftest: malloc: got 2nd vaddr
> PASS: selftest: malloc: access works
> PASS: selftest: malloc: addresses differ
> PASS: selftest: Program interrupt: expected(5) == received(5)
> SUMMARY: 14 tests, 2 unexpected failures
> 
> EXIT: STATUS=3
> 
> 
> 
> A fix for the test would look like this:
> 
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index f4acdc4..dc1c476 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -49,9 +49,10 @@ static void test_malloc(void)
>         *tmp2 = 123456789;
>         mb();
>  
> -       report("malloc: got vaddr", (uintptr_t)tmp & 0xf000000000000000ul);
> +       report("malloc: got vaddr", !!((uintptr_t)tmp & 0xf000000000000000ul));
>         report("malloc: access works", *tmp == 123456789);
> -       report("malloc: got 2nd vaddr", (uintptr_t)tmp2 & 0xf000000000000000ul);
> +       report("malloc: got 2nd vaddr",
> +              !!((uintptr_t)tmp2 & 0xf000000000000000ul));
>         report("malloc: access works", (*tmp2 == 123456789));
>         report("malloc: addresses differ", tmp != tmp2);
> 
> 
> But I am not sure if that is the right fix.
> 
> (why don't we run sanity tests to detect that, this tests works
> just fine with s390x TCG)

This patch also broke the test_64bit() function in powerpc/emulator.c:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/318694752

 Thomas
