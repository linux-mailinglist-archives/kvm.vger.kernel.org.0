Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E051BC2B5E
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbfJAAhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:37:37 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:37547 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbfJAAhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:37:37 -0400
Received: by mail-pl1-f182.google.com with SMTP id u20so4596246plq.4
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 17:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=s8Rt9kutYLVn7K768cdGlB2asOYD+Qx9DjGQoaBYYHA=;
        b=Bsi8faMu9emF8hR0sc9Ca4dtcK1Gw5Pu31q+3BFeD5Pfu5xpal9C9uEArn+je7YYhk
         SslmTDJ2c9YpK+hd8OpvSUcmX14gYGksNKRwuGmSAxkjgXvbHM44epEpivf3usKX7DTY
         BUMAtAGEKDUlS6K1daaWO1p5v8/sTf/s7/dDE75kfxWVPc88oFOCfNlG2s1DiPb9rs1/
         sSZ+0idJIGzYyQE0WQ9eaeLqiViTTD/HkwzFCeutVQ70PelxrpKmlcF7OUgVoLF1XEvL
         N1jtmgsTB2xI/LdoI7UIe9pOwdHPhDBZkjRH32rUu082NAogJoVRYI53i6GWdTqTIYVy
         CFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=s8Rt9kutYLVn7K768cdGlB2asOYD+Qx9DjGQoaBYYHA=;
        b=A5rTbQcQdftW9HtwEwVMS8bcz4kTmLc+CU3P+1HQZY/GTdXe77WEp0ik00OlGP3BHv
         lDBkfQHtHVWbbsb1w/ekp5dmkrehgaUbGhbmkU+zmVKN+Qch6CtN8p+xGtWPIh/bO1m1
         FQ/frTOXQd5/rVvZbHQmrC/SdG3kf38xMtog4kZZf/O+A1uw7+bwFILzkelYdySTsOB1
         pv/+awLLH64BKw0dYMzJ92DukNfu79+UxJbSddX79X8c5vhHo/02HiuBtmKqdkFDlI45
         qY39Z0FAEYPmsU54D85BtHumX6lt8Q4AV+URPBZVBWVm08DghVgVKPVM5NYfguFcxaH3
         Z62A==
X-Gm-Message-State: APjAAAVTUhlPTUP4zE5i1K3ngtIu0xKpZ40tUi2j43c8GZphQ23gooMb
        LtKkf5+ZzYQuul/GPSph+2AXcG3ghCQX9A==
X-Google-Smtp-Source: APXvYqyD33Uk8H6b87PXu494ztiyzUom50sWNW+fmqOGPIYenQqSXucy0CiDWXd8JRjrUSyqzR/44A==
X-Received: by 2002:a17:902:9a92:: with SMTP id w18mr22989756plp.201.1569890256270;
        Mon, 30 Sep 2019 17:37:36 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id c125sm13649980pfa.107.2019.09.30.17.37.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 17:37:35 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAA03e5F6WRN8UdUHxCFen3YkPbNQTQFQtMVkC_rexuPTNry0Ug@mail.gmail.com>
Date:   Mon, 30 Sep 2019 17:37:33 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4BA92E7-F025-4715-9E10-FD1A636F22CB@gmail.com>
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
 <20190926143201.GA4738@linux.intel.com>
 <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com>
 <CAA03e5FPBdHhVY5AyOd68UkriG=+poWf0PCcsUVBOHW7YPF3VA@mail.gmail.com>
 <DDBD57EF-C9A9-40EE-ACFE-0E3B30C275F9@gmail.com>
 <CAA03e5EZ-e0RemkakTab+CFo=P2kLLaLi0UROpsVtQEVt8p1Bw@mail.gmail.com>
 <C8510239-CEDD-496B-A772-12A8A8C03ADD@gmail.com>
 <CAA03e5F6WRN8UdUHxCFen3YkPbNQTQFQtMVkC_rexuPTNry0Ug@mail.gmail.com>
To:     Marc Orr <marcorr@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 30, 2019, at 5:12 PM, Marc Orr <marcorr@google.com> wrote:
>=20
>>>>>> Thanks for caring, but it would be better to explicitly skip the =
test if it
>>>>>> is not running on bare-metal. For instance, I missed this thread =
and needed
>>>>>> to check why the test fails on bare-metal...
>>>>>>=20
>>>>>> Besides, it seems that v6 was used and not v7, so the error =
messages are
>>>>>> strange:
>>>>>>=20
>>>>>> Test suite: atomic_switch_overflow_msrs_test
>>>>>> FAIL: exit_reason, 18, is 2147483682.
>>>>>> FAIL: exit_qual, 0, is 513.
>>>>>> SUMMARY: 11 tests, 2 unexpected failures
>>>>>>=20
>>>>>> I also think that printing the exit-reason in hex format would be =
more
>>>>>> readable.
>>>>>=20
>>>>> Exit reasons are enumerated in decimal rather than hex in the SDM
>>>>> (volume 3, appendix C).
>>>>=20
>>>> I know, but when the failed VM entry indication is on, it is just a =
huge
>>>> mess. Never mind, this is a minor issue.
>>>>=20
>>>>> To be clear, are you saying you "opted in" to the test on bare =
metal,
>>>>> and got confused when it failed? Or, are you saying that our patch =
on
>>>>> unittest.cfg to make the test not run by default didn't work?
>>>>=20
>>>> I ran it on bare-metal and needed to spend some time to realize =
that it is
>>>> expected to fail on bare-metal =E2=80=9Cby design=E2=80=9D.
>>>=20
>>> Ack. Maybe we should move tests like this into a *_virt_only.c
>>> counter-part? E.g., we could create a new, opt-in, file,
>>> vmx_tests_virt_only.c for this test. When similar scenarios arise in
>>> the future, this new precedent could be replicated, to make it =
obvious
>>> which tests are expected to fail on bare metal.
>>=20
>> Thanks for the willingness, but I don=E2=80=99t know whether any =
intrusive change is
>> needed at the moment. Even just getting the print-out to have =
something like
>> =E2=80=9C(KVM-specific)=E2=80=9D comment would be enough, assuming =
the test can easily be
>> disabled (as is the case with atomic_switch_overflow_msrs_test).
>=20
> "(as is the case with atomic_switch_overflow_msrs_test)" --> now I'm
> confused. Are you saying that the first test,
> atomic_switch_max_msrs_test() failed on bare metal? That test is
> expected to pass on bare metal. However, I did not test it on bare
> metal.

Sorry, my bad:

atomic_switch_max_msrs_test() passes on bare-metal.
atomic_switch_overflow_msrs_test() fails.

Everything is as (I understand is) expected to be. I just copy-pasted =
the
wrong test name in my last reply.

