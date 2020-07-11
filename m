Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4463621C50E
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 18:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgGKQMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jul 2020 12:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGKQMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jul 2020 12:12:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4457EC08C5DD
        for <kvm@vger.kernel.org>; Sat, 11 Jul 2020 09:12:50 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w17so3471929ply.11
        for <kvm@vger.kernel.org>; Sat, 11 Jul 2020 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0SNU20+gax936SwIGt9/P2KiRzkBaJ/pKWjazRsHuFM=;
        b=Kjp/6qWy3PrpSEYW+OQtG8oO5SqgQfTawquW6Q59RJ9QWox11lwGguXPJF/nLM+n9L
         lYLzkJ+UFYInmVUvvCYKaUsV4d0vEXQ0s1di1O5rQHyJcskdLIXIKR86ybr3zWXUJXVE
         6LhrQOqadg/Cj0UAJNO8MxJd7GvO23piCYPhnFHj5Gcga7y8jf5EkD2HRvvNcgB7Pf2n
         p6ZjnbVH6JUB0j2+SvqydWBRyzaczK4eIAMsBlXniHaehsZ1lZF6deCqQZZsP8OqEOGp
         bzHhDcZH/pGKexEA3ouwoWRGYuxa/27cgD+hMosXAa6mnTPxlr/DPeNxKhRcVG7R2c7p
         q0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0SNU20+gax936SwIGt9/P2KiRzkBaJ/pKWjazRsHuFM=;
        b=dIQfRKhtTmHBCz/oPsCABY1hSmbUtBA+fAoXklhtuCGHXKa7c/nlQMzRO5SMTTmPLU
         OvStt9c1VCl+F463yjPth3Nf3rWt6zR1GMifU+INKFfdwPtWmWiCAC2PXpA5DOe7Trxl
         Zls3+oqnb0VhLQqNwJshximwdnUUoD59DTwcZOhpJF5KVXmN/rbIaplxkt3o/0iQP4cU
         FHudDYsGim9wPp89HdsZLydo7KjRyaaIDdc9xZenkPJtpiQffOMw4G4JFWY5svKvpPKX
         ufUqXFU5VPSymn7MDki9KoVlKqjGRdbfaDMk48Xlx4QDYxs7ruY6bmuLEls2RucpgXUV
         LTQw==
X-Gm-Message-State: AOAM5313PEDHixZlEWWuVenkyHk/Ds2XyTVVC0zEdB6PRfx8qHhYwVSV
        5RKyifwpYU4qM2nsfWbGZWY=
X-Google-Smtp-Source: ABdhPJy2eHUwEGy7+iGP1ZzI4TOjbtyRSZIdze+PuyaAK8lsWcftmo6BZGleLPeol/wqmYdY3ZObJA==
X-Received: by 2002:a17:90a:1089:: with SMTP id c9mr11447813pja.180.1594483969422;
        Sat, 11 Jul 2020 09:12:49 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:9d2c:295f:256c:7fa3? ([2601:647:4700:9b2:9d2c:295f:256c:7fa3])
        by smtp.gmail.com with ESMTPSA id y22sm8779100pjp.41.2020.07.11.09.12.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jul 2020 09:12:48 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 3/3 v4] kvm-unit-tests: nSVM: Test that MBZ bits in CR3
 and CR4 are not set on vmrun of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <8e065692-e073-1ef6-9c0f-9190eb46d359@oracle.com>
Date:   Sat, 11 Jul 2020 09:12:47 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <307C4DB5-1D68-44B9-ABD2-4BB7A596BB27@gmail.com>
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-4-git-send-email-krish.sadhukhan@oracle.com>
 <80ff1de6-f8db-5a09-b67f-ee81937d0dc6@redhat.com>
 <8e065692-e073-1ef6-9c0f-9190eb46d359@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 8, 2020, at 5:01 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
> On 7/8/20 4:07 AM, Paolo Bonzini wrote:
>> On 08/07/20 02:39, Krish Sadhukhan wrote:
>>> +	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
>>> +	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
>>> +
>>> +	cr4 =3D cr4_saved & ~X86_CR4_PAE;
>>> +	vmcb->save.cr4 =3D cr4;
>>> +	SVM_TEST_CR_RESERVED_BITS(0, 11, 2, 3, cr3_saved,
>>> +	    SVM_CR3_LEGACY_RESERVED_MASK);
>>> +
>>> +	cr4 |=3D X86_CR4_PAE;
>>> +	vmcb->save.cr4 =3D cr4;
>>> +	efer |=3D EFER_LMA;
>>> +	vmcb->save.efer =3D efer;
>>> +	SVM_TEST_CR_RESERVED_BITS(0, 63, 2, 3, cr3_saved,
>>> +	    SVM_CR3_LONG_RESERVED_MASK);
>> The test is not covering *non*-reserved bits, so it doesn't catch =
that
>> in both cases KVM is checking against long-mode bits.  Doing this =
would
>> require setting up the VMCB for immediate VMEXIT (for example, =
injecting
>> an event while the IDT limit is zero), so it can be done later.
>>=20
>> Instead, you need to set/clear EFER_LME.  Please be more careful to
>> check that the test is covering what you expect.
>=20
>=20
> Sorry, I wasn't aware that setting/unsetting EFER.LMA wouldn't work !
>=20
> Another test case that I missed here is testing the reserved bits in =
CR3[11:0] in long-mode based on the setting of CR4.PCIDE.
>=20
>> Also, the tests show
>>=20
>> PASS: Test CR3 2:0: 641001
>> PASS: Test CR3 2:0: 2
>> PASS: Test CR3 2:0: 4
>> PASS: Test CR3 11:0: 1
>> PASS: Test CR3 11:0: 4
>> PASS: Test CR3 11:0: 40
>> PASS: Test CR3 11:0: 100
>> PASS: Test CR3 11:0: 400
>> PASS: Test CR3 63:0: 1
>> PASS: Test CR3 63:0: 4
>> PASS: Test CR3 63:0: 40
>> PASS: Test CR3 63:0: 100
>> PASS: Test CR3 63:0: 400
>> PASS: Test CR3 63:0: 10000000000000
>> PASS: Test CR3 63:0: 40000000000000
>> PASS: Test CR3 63:0: 100000000000000
>> PASS: Test CR3 63:0: 400000000000000
>> PASS: Test CR3 63:0: 1000000000000000
>> PASS: Test CR3 63:0: 4000000000000000
>> PASS: Test CR4 31:12: 0
>> PASS: Test CR4 31:12: 0
>>=20
>> and then exits.  There is an issue with compiler optimization for =
which
>> I've sent a patch, but even after fixing it the premature exit is a
>> problem: it is caused by a problem in __cr4_reserved_bits and a typo =
in
>> the tests:
>>=20
>> diff --git a/x86/svm.h b/x86/svm.h
>> index f6b9a31..58c9069 100644
>> --- a/x86/svm.h
>> +++ b/x86/svm.h
>> @@ -328,8 +328,8 @@ struct __attribute__ ((__packed__)) vmcb {
>>  #define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
>>  #define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
>>  #define	SVM_CR3_LONG_RESERVED_MASK		=
0xfff0000000000fe7U
>> -#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
>> -#define	SVM_CR4_RESERVED_MASK			=
0xffffffffffbaf000U
>> +#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffcaf000U
>> +#define	SVM_CR4_RESERVED_MASK			=
0xffffffffffcaf000U
>>  #define	SVM_DR6_RESERVED_MASK			=
0xffffffffffff1ff0U
>>  #define	SVM_DR7_RESERVED_MASK			=
0xffffffff0000cc00U
>>  #define	SVM_EFER_RESERVED_MASK			=
0xffffffffffff0200U
>>=20
>> (Also, this kind of problem is made harder to notice by only testing
>> even bits, which may make sense for high order bits, but certainly =
not
>> for low-order ones).
>>=20
>> All in all, fixing this series has taken me almost 2 hours.  Since I =
have
>> done the work I'm queuing
>=20
>=20
> Sorry to hear it caused so many issues ! Thanks for looking into it !
>=20
>>  but, but I wonder: the compiler optimization
>> issue could depend on register allocation, but did all of these =
issues
>> really happen only on my machine?
>=20
>=20
> Just as a reference,  I compiled it using gcc 4.8.5 and ran it on an =
AMD EPYC that was running kernel 5.8.0-rc4+. Surprisingly, all tests =
passed:
>=20
> PASS: Test CR3 2:0: 641001
> PASS: Test CR3 2:0: 641002
> PASS: Test CR3 2:0: 641004
> PASS: Test CR3 11:0: 641001
> PASS: Test CR3 11:0: 641004
> PASS: Test CR3 11:0: 641040
> PASS: Test CR3 11:0: 641100
> PASS: Test CR3 11:0: 641400
> PASS: Test CR3 63:0: 641001
> PASS: Test CR3 63:0: 641004
> PASS: Test CR3 63:0: 641040
> PASS: Test CR3 63:0: 641100
> PASS: Test CR3 63:0: 641400

Well, the tests (which I pulled) do not pass on bare-metal, so KVM is =
even
better than bare-metal=E2=80=A6 Here are the results for long-mode:

FAIL: Test CR3 63:0: 641001
FAIL: Test CR3 63:0: 641002
FAIL: Test CR3 63:0: 641004
FAIL: Test CR3 63:0: 641020
FAIL: Test CR3 63:0: 641040
FAIL: Test CR3 63:0: 641080
FAIL: Test CR3 63:0: 641100
FAIL: Test CR3 63:0: 641200
FAIL: Test CR3 63:0: 641400
FAIL: Test CR3 63:0: 641800
PASS: Test CR3 63:0: 10000000641000
PASS: Test CR3 63:0: 20000000641000
PASS: Test CR3 63:0: 40000000641000
PASS: Test CR3 63:0: 80000000641000
PASS: Test CR3 63:0: 100000000641000
PASS: Test CR3 63:0: 200000000641000
PASS: Test CR3 63:0: 400000000641000
PASS: Test CR3 63:0: 800000000641000
PASS: Test CR3 63:0: 1000000000641000
PASS: Test CR3 63:0: 2000000000641000
PASS: Test CR3 63:0: 4000000000641000
PASS: Test CR3 63:0: 8000000000641000

The PAE/legacy tests crashed my machine. Presumably the VM PTEs are
completely messed up on PAE/legacy so a failure can cause a crash. It =
would
be better to do something smarter to avoid a crash, perhaps by setting =
an
invalid PDEs or something in the guest.

Anyhow, to double-check that the VM-entry was successful, I checked the =
exit
reason on long-mode, and indeed I get a VMMCALL exit, and CR3 of the =
guest
holds the =E2=80=9Cillegal=E2=80=9D value.

Checking the APM shows that the low bits of CR3 are marked as reserved =
but
not MBZ. So the condition that the test tries to check "Any MBZ bit of =
CR3
is set=E2=80=9D does not apply to the low-bits.

